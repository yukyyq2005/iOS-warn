//
//  LvToast.m
//  TestAlert
//
//  Created by youq on 13-8-23.
//  Copyright (c) 2013年 youq. All rights reserved.
//

#import "LvToast.h"
#import "AppDelegate.h"

#define MAX_TOAST_BG_WIDTH      300

@implementation LvToast

@synthesize preMsg;

-(id)initWithMessage:(NSString *)message {
    self = [super initWithFrame:CGRectMake(0, 150, 300, 15*2+14)];
    UILabel *lbContent = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, MAX_TOAST_BG_WIDTH-15*2, 32)];
    lbContent.font = [UIFont systemFontOfSize:14];
    lbContent.backgroundColor = [UIColor clearColor];
    lbContent.textColor = [UIColor whiteColor];
    lbContent.lineBreakMode = NSLineBreakByWordWrapping;
    lbContent.numberOfLines = 0;
    lbContent.text = message;
    
    CGSize textContentSize = [message sizeWithFont:lbContent.font constrainedToSize:CGSizeMake(lbContent.frame.size.width, 1000) lineBreakMode:lbContent.lineBreakMode];
    lbContent.frame = CGRectMake(lbContent.frame.origin.x, lbContent.frame.origin.y, textContentSize.width, MAX(textContentSize.height, 14));
    UIImageView *ivBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MAX_TOAST_BG_WIDTH, self.frame.size.width)];
    ivBG.image = [[UIImage imageNamed:@"toast_bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [self addSubview:ivBG];
    
    ivBG.frame = CGRectMake(ivBG.frame.origin.x, ivBG.frame.origin.y, MIN(textContentSize.width+15*2, MAX_TOAST_BG_WIDTH), textContentSize.height+15*2);
    [ivBG addSubview:lbContent];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;

    self.frame = CGRectMake((screenSize.width-ivBG.frame.size.width)*0.5, (screenSize.height-ivBG.frame.size.height)*0.5, ivBG.frame.size.width, ivBG.frame.size.height);

    self.userInteractionEnabled = NO;
    
    return self;
}

+(UIWindow*)getCurTopWindow{
    //将提示放到键盘上面
    UIWindow   *topWindow = nil;
    for (int i=0; i<[[[UIApplication sharedApplication] windows] count]; i++) {
        topWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:i];
        NSString *topViewClassName = [NSString stringWithFormat:@"%@", [topWindow class]];
        if  ([topViewClassName isEqualToString:@"UITextEffectsWindow"]){
            break;
        }else{
            topWindow = nil;
        }
    }
    if (topWindow == nil) {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        topWindow = appDelegate.window;
    }
//    for (UIView *subView in topWindow.subviews) {
//        if ([subView isMemberOfClass:[self class]]) {
//            [subView removeFromSuperview];
//        }
//    }
    return topWindow;
}

+(void)showToast:(NSString*)message{
    if ([NSThread isMainThread] == NO) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (message.length > 0) {
                [LvToast showToast:message delay:2];
            }
        });
    }else{
        if (message.length > 0) {
            [LvToast showToast:message delay:2];
        }
    }
}
+(void)showToast:(NSString*)message delay:(CGFloat)delaySecond {
    //将提示放到键盘上面 added by youq for bug 2795
    UIWindow   *topWindow = [LvToast getCurTopWindow];
    for (UIView *subView in topWindow.subviews) {
        if ([subView isMemberOfClass:[self class]]) {
            LvToast *toast = (LvToast *)subView;
            if (![toast.preMsg isEqualToString:message]) {
                NSLog(@"message %@", message);
            }
        }
    }
    
    
    for (UIView *subView in topWindow.subviews) {
        if ([subView isMemberOfClass:[self class]]) {
            [subView removeFromSuperview];
        }
    }
    
    LvToast *toast = [[LvToast alloc] initWithMessage:message];
    toast.preMsg = message;
    toast.alpha = 0;
    [topWindow addSubview:toast];
    
    [UIView animateWithDuration:0.2 animations:^{
        toast.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 delay:delaySecond options:UIViewAnimationOptionCurveEaseOut animations:^{
            toast.alpha = 0;
        } completion:^(BOOL finished) {
            [toast removeFromSuperview];
        }];
    }];
}
/// Returns the `root` view controller (returns nil if not found).
+ (UIViewController *)getRootViewController {
    UIViewController *ctrl = nil;
    UIApplication *app = [UIApplication sharedApplication];
    if (!ctrl) ctrl = app.keyWindow.rootViewController;
    if (!ctrl) ctrl = [app.windows.firstObject rootViewController];
//    if (!ctrl) ctrl = self.viewController;
    if (!ctrl) return nil;
    
    while (!ctrl.view.window && ctrl.presentedViewController) {
        ctrl = ctrl.presentedViewController;
    }
    if (!ctrl.view.window) return nil;
    return ctrl;
}
+ (void)showSystemAlertView:(NSString*)message{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alertView show];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [[LvToast getRootViewController] presentViewController:alertController animated:YES completion:nil];
    
}
@end


