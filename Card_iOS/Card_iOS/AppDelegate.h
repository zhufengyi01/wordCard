//
//  AppDelegate.h
//  Card_iOS
//
//  Created by 朱封毅 on 02/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 用户消息通知
*/
UIKIT_EXTERN NSString *const  AppDelegateUserCheckNotification;
UIKIT_EXTERN NSString *const  AppDelegateUserCheckNotificationKey;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

