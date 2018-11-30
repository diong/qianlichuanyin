//
//  ZYTabBarController.h
//  ZhiYin
//
//  Created by pro on 2018/9/20.
//  Copyright © 2018年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLTabBarCenterBtn.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLZYTabBarController : UITabBarController<UITabBarControllerDelegate>
@property (nonatomic, strong) QLTabBarCenterBtn* tabbarCenterBtn;
-(void)resetmevc;
-(void)resettianya;
-(void)resetrank;
-(void)resetsendme;
-(void)changevc_overme:(UIViewController*)newvc title:(NSString*)title;
-(void)changevc_overtianya:(UIViewController*)newvc title:(NSString*)title;
-(void)changevc_overrank:(UIViewController*)newvc title:(NSString*)title;
-(void)changevc_oversendme:(UIViewController*)newvc title:(NSString*)title;
@end

@interface UITabBar (Extend)

- (void)showLastBadgeOnItemIndex:(NSInteger)index;
- (void)showBadgeOnItemIndex:(NSInteger)index; // 显示小红点
- (void)hideBadgeOnItemIndex:(NSInteger)index; // 隐藏小红点


@end

NS_ASSUME_NONNULL_END
