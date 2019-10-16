//
//  LvToast.h
//  TestAlert
//
//  Created by youq on 13-8-23.
//  Copyright (c) 2013年 youq. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NETWORK_ERROR_TIP @"请检查你的网络连接"

@interface LvToast : UIView
@property (strong, nonatomic) NSString *preMsg;

//该函数默认2秒自动消失
+ (void)showToast:(NSString*)message;

//该函数支持指定消失时间间隔
+ (void)showToast:(NSString*)message delay:(CGFloat)delaySecond;

+ (void)showSystemAlertView:(NSString*)message;

@end
