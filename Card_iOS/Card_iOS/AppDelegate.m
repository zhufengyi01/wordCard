//
//  AppDelegate.m
//  Card_iOS
//
//  Created by 朱封毅 on 02/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomController.h"
#import "UMSocial.h"
#import "UMSocialData.h"
#import "UMSocialQQHandler.h"
#import "MobClick.h"
#import "ZCControl.h"
#import "LoginViewController.h"
#import "Function.h"
#import "Constant.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "BaseNavigationViewController.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "GiderPageViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSDictionary  *userInfo=[[NSUserDefaults  standardUserDefaults] objectForKey:kUserKey];
    [self initUmeng];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    if (userInfo) {  //用户已经登陆
        [Function getUserInfoWith:userInfo];
        self.window.rootViewController =[CustomController new];
    }
    else {
        NSString      *firstlogin =[[NSUserDefaults standardUserDefaults] objectForKey:IS_FIRST_LOGIN];
         firstlogin = @"no";
        if (![firstlogin isEqualToString:@"YES"]) {//是第一次进入应用
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:IS_FIRST_LOGIN];
            UINavigationController  *GNa=[[UINavigationController alloc]initWithRootViewController:[GiderPageViewController new]];
            self.window.rootViewController=GNa;
        }else {

        //用户没有登陆
        BaseNavigationViewController  *loginNa=[[BaseNavigationViewController alloc]initWithRootViewController:[LoginViewController new]];
        self.window.rootViewController=loginNa;
        }
    }
    return YES;
}
/**
 *  初始化友盟组件, 配置SSO
 */
- (void)initUmeng {
#pragma mark 友盟统计
    //友盟统计
    //channekId 应用的推广渠道  nil或者@""默认为appstore
    [MobClick setLogEnabled:YES];
    [MobClick startWithAppkey:kUmengKey reportPolicy:BATCH channelId:@""];
    //版本标识（version）
    NSString  *version =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    //如果@param value为YES，SDK会对日志进行加密。加密模式可以有效防止网络攻击，提高数据安全性。
    // 如果@param value为NO，SDK将按照非加密的方式来传输日志。
    //如果您没有设置加密模式，SDK的加密模式为NO（不加密）。
    [MobClick setEncryptEnabled:YES];
    
    // 您可以设置在应用切入后台时，是否进入background模式。
    //对于支持backgound模式的APP，SDK可以确保在进入后台时，完成对日志的持久化工作，保证数据的完整性。您可以通过以下方法对后台模式进行设置：
    [MobClick setBackgroundTaskEnabled:YES];
    
    [UMSocialData setAppKey:kUmengKey];
    //    BOOL isOauth = [UMSocialAccountManager isOauthWithPlatform:UMShareToSina];
    //    LOG(@"isoauth = %d", isOauth);
    
    [UMSocialData openLog:YES];
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskPortrait];
    NSString *shareAppUrl = @"http://um0.cn/47MUuq/";
    [UMSocialWechatHandler setWXAppId:weiChatShareKey appSecret:weiChatShareSecret url:shareAppUrl];
    
    //    QQ100551660 的16进制是 05FE4BEC
    //    1103486275 41C5DD43
   // [UMSocialQQHandler setQQWithAppId:@"1103486275" appKey:@"htGJ2JFqtS2GTmM2" url:@"http://www.redianying.com"];
    [UMSocialSinaHandler openSSOWithRedirectURL:SSOSinRedirectURL];
}

/*
 友盟sso 在APPdelegate中实现下面的回调方法
 */
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    /**
     *  为了SSO能够正常跳转
     */
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
