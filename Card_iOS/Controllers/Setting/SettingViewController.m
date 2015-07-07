//
//  SettingViewController.m
//  Card_iOS
//
//  Created by 朱封毅 on 07/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "SettingViewController.h"
#import "UserDataCenter.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "BaseNavigationViewController.h"
static const int  LOGIN_OUT = 0;
@implementation SettingViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置";
    self.dataArray = [NSMutableArray arrayWithObjects:@"退出登陆", nil];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    switch (indexPath.row) {
        case LOGIN_OUT:
            [self ClearUserCache];
            break;
        default:
            break;
    }
}
-(void)ClearUserCache
{
    UserDataCenter *user = [UserDataCenter shareInstance];
    user.user_id= nil;
    user.username = nil;
    user.logo = nil;
    user.sex = nil;
    user.is_admin = nil;
    [[NSUserDefaults standardUserDefaults ]  removeObjectForKey:kUserKey];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    BaseNavigationViewController  *na = [[BaseNavigationViewController alloc]initWithRootViewController:[LoginViewController new]];
    delegate.window.rootViewController =  na;
}
@end
