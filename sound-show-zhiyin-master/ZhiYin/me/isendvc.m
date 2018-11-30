//
//  isendvc.m
//  ZhiYin
//
//  Created by pro on 2018/10/11.
//  Copyright © 2018年 zy. All rights reserved.
//

#import "isendvc.h"
#import <AFHTTPSessionManager+Synchronous.h>
#import "zyprotocol.h"
#import "QLglobalvar.h"
#import "QLcommom_utils.h"
#import <MagicalRecord/MagicalRecord.h>
#import "SupportM+CoreDataClass.h"
#import "MJRefresh.h"
#import "QLisendcell.h"

@interface isendvc ()
{
    dispatch_source_t _speak_timer;
}
@property(nonatomic, strong)NSArray* audiolist;
@property(nonatomic, strong)AVPlayer* avplayer;
@property(nonatomic, assign)NSInteger curplayingitem;
@property(nonatomic, assign)NSInteger speak_img_index;
@property(nonatomic, strong)NSIndexPath* lastselectindexpath;
@end

@implementation isendvc

-(void)request_isend_audio {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString* url = [zyprotocol_isend_audio isend_url];
    NSDictionary* param = [zyprotocol_isend_audio isend_param:30];
    NSError *error = nil;
    NSDictionary *result = [manager syncPOST:url
                                  parameters:param
                                        task:NULL
                                       error:&error];
    protocol_isend_audio_info* isend_audio = [zyprotocol_isend_audio token_response:result];
    BOOL ret = NO;
    if (isend_audio.IsSuccess) {
        NSLog(@"request isend_data successful");
        self.audiolist = isend_audio.audio_info_list;
        ret = YES;
    }
    else {
        NSLog(@"request isend_audio error");
        dispatch_sync(dispatch_get_main_queue(), ^{
            [QMUITips showError:@"未能加载到数据，请保持网络畅通，往下滑动界面进行重试。" inView:self.view hideAfterDelay:3];
        });
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideEmptyView];
        [self.isendtv reloadData];
        [self.isendtv.mj_header endRefreshing];
        [self.isendtv.mj_footer endRefreshing];
        self.lastselectindexpath = nil;
    });
}

-(void)loadtianya:(id)btn {
    [self showEmptyViewWithLoading:YES image:nil text:@"寡人的语音正在加载的路上..." detailText:nil buttonTitle:nil buttonAction:nil];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self request_isend_audio];
    });
}

- (void)settableview {
    MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"refresh isend audio");
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self request_isend_audio];
        });
    }];
    header.automaticallyChangeAlpha = YES;
    [header setTitle:@"请再用力拉一下" forState:MJRefreshStateIdle];
    [header setTitle:@"松手就刷新数据" forState:MJRefreshStatePulling];
    [header setTitle:@"寡人语录正在路上..." forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.isendtv.mj_header = header;

    MJRefreshBackNormalFooter* footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"refresh tianya audio, at footer");
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self request_isend_audio];
        });
    }];
    footer.automaticallyChangeAlpha = YES;
    [footer setTitle:@"请再用力拉一下" forState:MJRefreshStateIdle];
    [footer setTitle:@"松手就刷新数据" forState:MJRefreshStatePulling];
    [footer setTitle:@"寡人语录正在路上..." forState:MJRefreshStateRefreshing];
    self.isendtv.mj_footer = footer;

    self.isendtv.delegate = self;
    self.isendtv.dataSource = self;

    // 没有数据的cell隐藏分隔线
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    self.isendtv.tableFooterView = view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.audiolist count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 50;
    UIImage* image = [UIImage imageNamed:@"respose"]; // 48*48
    if (image) {
        UIImageView* view = [[UIImageView alloc]initWithImage:image];
        height = view.qmui_width * 3.5;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        QLisendcell* cell = [QLisendcell cellwithTableview:tableView];
        protocol_audio_info* audioinfo = self.audiolist[indexPath.row];
        cell.duration.text = [NSString stringWithFormat:@"%d\"", (int)audioinfo.audioduration];
        cell.time.text = [QLcommom_utils howlonginfo:audioinfo.createtime];
        [cell.play setImage:[UIImage imageNamed:@"tianya_speak3"]];
        NSInteger towhere = audioinfo.towhere;
        if (towhere == 1) {
            cell.towho.text = @"(发往)天涯何处";
        }
        else {
            // 这里，audioinfo.nickname是目标对象的nickname
            NSString* info = [NSString stringWithFormat:@"(发往)%@", audioinfo.nickname];
            cell.towho.text = info;
        }

        return cell;
    }
    return nil;
}

- (void)reset_lastaudioimage {
    NSIndexPath* selindexpath = self.lastselectindexpath;
    if (selindexpath) {
        QLisendcell* cell = (QLisendcell*)[self.isendtv cellForRowAtIndexPath:selindexpath];
        UIImage* image = [UIImage imageNamed:@"tianya_speak3"];
        [cell.play setImage:image];
    }
}

- (void)setcurplayitem:(NSInteger)index {
    _curplayingitem = index;
}

-(void)setspeakimage {
    if (self.speak_img_index >= 4) {
        self.speak_img_index = 1;
    }
    NSIndexPath* selindexpath = self.isendtv.indexPathForSelectedRow;
    if (selindexpath) {
        QLisendcell* cell = (QLisendcell*)[self.isendtv cellForRowAtIndexPath:selindexpath];
        NSString* imagename = [NSString stringWithFormat:@"tianya_speak%d", (int)self.speak_img_index];
        UIImage* image = [UIImage imageNamed:imagename];
        [cell.play setImage:image];
        self.speak_img_index ++;
    }
}

-(void)disposespeaktimer {
    if (_speak_timer) {
        dispatch_source_cancel(_speak_timer);
        _speak_timer = NULL;
    }
}

- (void)initPlaySession
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _curplayingitem) {
        [self.avplayer pause];
        [self disposespeaktimer];
        [self reset_lastaudioimage];
        [self setcurplayitem:-1];
    }
    else {
        protocol_audio_info* audioinfo = self.audiolist[indexPath.row];
        if (audioinfo.audiourl) {
            [self reset_lastaudioimage];
            NSURL* url = [NSURL URLWithString:audioinfo.audiourl];
            [self initPlaySession];
            self.avplayer = [[AVPlayer alloc]initWithURL:url];
            [self.avplayer play];
            [self setcurplayitem:indexPath.row];

            [self disposespeaktimer];
            _speak_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
            dispatch_source_set_timer(_speak_timer, DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC, 1ull * NSEC_PER_SEC);
            __weak __typeof(self) weakSelf = self;
            self.speak_img_index = 1;
            dispatch_source_set_event_handler(_speak_timer, ^{
                __strong __typeof(weakSelf) _self = weakSelf;
                [_self setspeakimage];
            });
            dispatch_resume(_speak_timer);
        }
    }
    self.lastselectindexpath = indexPath;
}

- (void)playbackFinished:(NSNotification *)notice {
    NSLog(@"播放完成");
    [self disposespeaktimer];
    [self reset_lastaudioimage];
    [self setcurplayitem:-1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showEmptyViewWithLoading:YES image:nil text:@"寡人的语音正在加载的路上..." detailText:nil buttonTitle:nil buttonAction:nil];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self request_isend_audio];
    });
    [self settableview];
    [self setcurplayitem:-1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self.returnbtn setImage:[UIImage imageNamed:@"me_returnbtn"] forState:UIControlStateNormal];
    [self.returnbtn addTarget:self action:@selector(returnaction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)returnaction:(UIButton*)btn {
    [[QLglobalvar shareglobalvar].tabbarcontroller resetmevc];
}

@end
