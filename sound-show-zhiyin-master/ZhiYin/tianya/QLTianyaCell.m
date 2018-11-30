//
//  TianyaCell.m
//  ZhiYin
//
//  Created by freejet on 2018/10/1.
//  Copyright © 2018年 zy. All rights reserved.
//

#import "QLTianyaCell.h"

@implementation QLTianyaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellwithTableview:(UITableView*)tableview {
    static NSString* idcell = @"tianya_cell";
    QLTianyaCell* cell = [tableview dequeueReusableCellWithIdentifier:idcell];
    if (!cell) {
        cell = [[QLTianyaCell alloc]init];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
