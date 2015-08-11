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
#import "UserDataCenter.h"
#import "PersonSetVC.h"
#import "UIImageView+WebCache.h"
#import "BaseNavigationViewController.h"
static const int  LOGIN_OUT = 1;
@implementation SettingViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置";
    UserDataCenter *user= [UserDataCenter shareInstance];
    self.dataArray = [NSMutableArray arrayWithObjects:user.username,@"退出登陆", nil];
    self.tabbleView.tableFooterView = [[UIView alloc] init];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[super tableView:tableView cellForRowAtIndexPath:indexPath];
    static NSString *cellID = @"cellID";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellID];
    UIImageView *img;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //cell.separatorInset = UIEdgeInsetsMake(0, 100, 0, -100);
        cell.textLabel.font = [UIFont fontWithName:KFontThin size:14];
        img = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
        img.contentMode = UIViewContentModeScaleAspectFit;
        //img.layer.cornerRadius = 20;
        //img.clipsToBounds = YES;
        [cell.contentView addSubview:img];
    }
    UserDataCenter *usr = [UserDataCenter shareInstance];
    NSURL  *headurl =  [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kUrlAvatar,usr.logo]];
    switch (indexPath.row) {
        case 0:
            [img sd_setImageWithURL:headurl placeholderImage:HeadImagePlaceholder options:(SDWebImageRetryFailed|SDWebImageLowPriority)];
            cell.textLabel.text = [NSString stringWithFormat:@"              %@",self.dataArray[indexPath.row]];
            break;
        case 1:
            cell.textLabel.text = self.dataArray[indexPath.row];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor redColor];
            break;
        default:
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:[PersonSetVC new] animated:YES];
            break;
        case LOGIN_OUT:
            [self ClearUserCache];
            break;
        default:
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 60.f;
            break;
            return 50.f;
        default:
            break;
    }
    return 50.f;
}
-(void)ClearUserCache
{
    UserDataCenter *user = [UserDataCenter shareInstance];
    user.user_id= nil;
    user.username = nil;
    user.logo = nil;
    user.sex = nil;
    user.is_admin = nil;
    NSUserDefaults  *userdefualts = [NSUserDefaults standardUserDefaults];
    [userdefualts removeObjectForKey:kUserKey];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    BaseNavigationViewController  *na = [[BaseNavigationViewController alloc]initWithRootViewController:[LoginViewController new]];
    delegate.window.rootViewController =  na;
}
@end
