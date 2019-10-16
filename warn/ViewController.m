//
//  ViewController.m
//  warn
//
//  Created by youq on 2019/10/16.
//  Copyright © 2019年 youq. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "LvToast.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registLocalNotification];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)registLocalNotification
{
    // 申请通知权限
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        // A Boolean value indicating whether authorization was granted. The value of this parameter is YES when authorization for the requested options was granted. The value is NO when authorization for one or more of the options is denied.
        if (granted) {
            
            NSMutableArray *array = [NSMutableArray array];
            // 每个月5号的早上7:30分 每个月5号的早上7:40分 每个月5号的早上7:50分
            // 每个月15号的早上7:30分 每个月5号的早上7:40分 每个月5号的早上7:50分
            // 每个月25号的早上7:30分 每个月5号的早上7:40分 每个月5号的早上7:50分
            
            UNNotificationRequest *notificationRequest1 = [self addNti:5 hour:7 min:30 tag:1];
            UNNotificationRequest *notificationRequest2 = [self addNti:5 hour:7 min:40 tag:2];
            UNNotificationRequest *notificationRequest3 = [self addNti:5 hour:7 min:50 tag:3];
            
            UNNotificationRequest *notificationRequest4 = [self addNti:15 hour:7 min:30 tag:4];
            UNNotificationRequest *notificationRequest5 = [self addNti:15 hour:7 min:40 tag:5];
            UNNotificationRequest *notificationRequest6 = [self addNti:15 hour:7 min:50 tag:6];
            
            UNNotificationRequest *notificationRequest7 = [self addNti:25 hour:7 min:30 tag:7];
            UNNotificationRequest *notificationRequest8 = [self addNti:25 hour:7 min:40 tag:8];
            UNNotificationRequest *notificationRequest9 = [self addNti:25 hour:7 min:50 tag:9];
            
            [array addObject:notificationRequest1];
            [array addObject:notificationRequest2];
            [array addObject:notificationRequest3];
            [array addObject:notificationRequest4];
            [array addObject:notificationRequest5];
            [array addObject:notificationRequest6];
            [array addObject:notificationRequest7];
            [array addObject:notificationRequest8];
            [array addObject:notificationRequest9];
            
            for (UNNotificationRequest *noti in array) {
                //将请求加入通知中心
                [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:noti withCompletionHandler:^(NSError * _Nullable error) {
                    if (error == nil) {
                        [LvToast showToast:@"成功启用推送"];
                        NSLog(@"已成功加推送%@",noti.identifier);
                    }else{
                        [LvToast showToast:@"启用推送失败"];
                    }
                }];
            }
            // 4、将请求加入通知中心
//            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:notificationRequest1 withCompletionHandler:^(NSError * _Nullable error) {
//                if (error == nil) {
//                    [LvToast showToast:@"成功启用推送1"];
//                    NSLog(@"已成功加推送1%@",notificationRequest1.identifier);
//                }
//            }];
//            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:notificationRequest2 withCompletionHandler:^(NSError * _Nullable error) {
//                if (error == nil) {
//                    [LvToast showToast:@"成功启用推送2"];
//                    NSLog(@"已成功加推送2%@",notificationRequest2.identifier);
//                }
//            }];
        }
        
    }];
}
//每个月5号 15号 25号 早上8点 要报名义工活动
//我要定为每个月的这3天的7:30提醒一次， 7:40提醒一次 7点50提醒一次

// 每个月5号的早上7:30分 每个月5号的早上7:40分 每个月5号的早上7:50分
// 每个月15号的早上7:30分 每个月5号的早上7:40分 每个月5号的早上7:50分
// 每个月25号的早上7:30分 每个月5号的早上7:40分 每个月5号的早上7:50分
- (UNNotificationRequest*)addNti:(NSInteger)day hour:(NSInteger)hour min:(NSInteger)min tag:(NSInteger)tag{
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"报名深圳义工";
    content.subtitle = @"报名深圳义工";
    content.sound = [UNNotificationSound soundNamed:@"sound.mp3"];
    NSURL *imageUrl = [[NSBundle mainBundle] URLForResource:@"volunteer" withExtension:@"png"];
    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"imageIndetifier" URL:imageUrl options:nil error:nil];
    content.attachments = @[attachment];
    content.categoryIdentifier = @"categoryIndentifier";
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = day;//每个月的5号
    components.hour = hour;//早上7点
    components.minute = min;//30分
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
    NSString *string = [NSString stringWithFormat:@"KFGroupNotification%@", @(tag)];
    UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier:string content:content trigger:trigger];
    return notificationRequest;
}
@end
