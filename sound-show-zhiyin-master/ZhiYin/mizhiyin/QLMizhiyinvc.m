//
//  Mizhiyinvc.m
//  ZhiYin
//
//  Created by freejet on 2018/10/5.
//  Copyright © 2018年 zy. All rights reserved.
//

#import "QLMizhiyinvc.h"
#import "QLglobalvar.h"
#import "QLCWVoiceView.h"
#import "UIView+CWChat.h"

@interface QLMizhiyinvc ()

@end

@implementation QLMizhiyinvc

-(void)introlabelinfo {
    NSString* info = @"---------使用说明书---------\n\n1. 用声音，宣泄您的情绪，表明态度。\n\n2. 最长有90秒的录音时间。\n\n3. 吼几句熟悉的歌词；抱怨一下上司；大声说我要奋斗... \n\n4. 不要告诉别人您有千万身家，也不要说出密码跟隐私。\n\n5. 都是有身份证的人，请务必文明用语，勿发布不良信息。";
    self.introlabel.numberOfLines = 20;
    self.introlabel.text = info;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect rt = self.view.frame;
    float xscal = [QLglobalvar shareglobalvar].autoSizeScaleX;
    float yscal = [QLglobalvar shareglobalvar].autoSizeScaleY;
    CGRect rtfit = CGRectMake(rt.origin.x*xscal, rt.origin.y*yscal, rt.size.width*xscal, rt.size.height*yscal);
    self.view.frame = rtfit;
    
    self.recordview.backgroundColor = MAIN_BLUE_COLOR;
    QLCWVoiceView *view = [[QLCWVoiceView alloc] initWithFrame:CGRectMake(0, 0,self.recordview.cw_width, self.recordview.cw_height)];
    [self.recordview addSubview:view];
//    [self.view addSubview:view];
    [self introlabelinfo];
}

-(void)viewDidAppear:(BOOL)animated {
    if ([QLglobalvar shareglobalvar].towhere == 0) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"寡人的语音将发往天涯何处，全世界在听。"];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,8)];
        [str addAttribute:NSForegroundColorAttributeName value:MAIN_BLUE_COLOR range:NSMakeRange(8,4)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(12,7)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, 8)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0] range:NSMakeRange(8, 4)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(12, 7)];
        self.towherelabel.text = str;
    }
    else if ([QLglobalvar shareglobalvar].towhere == 1) {
        NSString* info = [NSString stringWithFormat:@"寡人的语音将发给%@。", [QLglobalvar shareglobalvar].tonickname];
        NSInteger nicklen = [[QLglobalvar shareglobalvar].tonickname length];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:info];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,8)];
        [str addAttribute:NSForegroundColorAttributeName value:MAIN_BLUE_COLOR range:NSMakeRange(8,nicklen)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(8+nicklen,1)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, 8)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0] range:NSMakeRange(8, nicklen)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(8+nicklen, 1)];
        self.towherelabel.text = str;
    }
    [super viewDidAppear:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
