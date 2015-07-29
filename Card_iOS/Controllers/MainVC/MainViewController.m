//
//  MainViewController.m
//  Card_iOS
//
//  Created by 朱封毅 on 02/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "MainViewController.h"
#import "ZCControl.h"
#import "UserDataCenter.h"
#import "Constant.h"
#import "MainAdmList.h"
#import "WordSearchViewController.h"
#import "BaseNavigationViewController.h"
#import "WordMainVC.h"
#import <FIR/FIR.h>
@implementation MainViewController

-(instancetype)init
{
    if (self =  [super init]) {
        self.urlString = @"text/list-by-status";
        self.parameters=@{@"status":@"3"};
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //self.navigationController.hidesBarsOnSwipe = YES;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"瞎扯 · 精选";
    //[self requestVersionUpdate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewScollerTop) name:Refresh_MAIN_LIST object:nil];
    UserDataCenter  *user = [UserDataCenter shareInstance];
    if ([user.is_admin intValue]>0) {
      [self createLeftSystemNavigationItemWith:UIBarButtonSystemItemEdit];
    }
    [self creatRightNavigationItem:[UIImage imageNamed:@"search"] Title:nil];
    self.tabbleView.frame=CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kHeigthTabBar-kHeightNavigation);
    [self requestData];
}
-(void)RightNavigationButtonClick:(UIButton *)rightbtn
{
   // [self.navigationController pushViewController:[WordSearchViewController new] animated:NO];
    BaseNavigationViewController  *na = [[BaseNavigationViewController alloc] initWithRootViewController:[WordSearchViewController new]];
    na.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:na animated:NO completion:nil];
    
}
-(void)LeftSystemNavigationButtonClick
{
    [self.navigationController pushViewController:[MainAdmList new] animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}
//
//#pragma mark  - fir 更新请求上线后需要去掉
//-(void)requestVersionUpdate
//{
//    NSString  *apiStr =@"http://melaka.fir.im/api/v2/app/version/559fa773f61ceb5a0e00012e?token=260fc3700aaf11e597435eaa6f4fb53848e89872";
//    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:apiStr]] queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        if (data) {
//            @try {
//                NSDictionary *result= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//                NSLog(@"=====%@",result);
//                //对比版本
//               // NSString * version=result[@"version"]; //对应 CFBundleVersion, 对应Xcode项目配置"General"中的 Build
//                NSString * versionShort=result[@"versionShort"]; //对应 CFBundleShortVersionString, 对应Xcode项目配置"General"中的 Version
//                
//              //NSString * localVersion=[[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
//                NSString * localVersionShort=[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
//                
//                //NSString *url=result[@"update_url"]; //如果有更新 需要用Safari打开的地址
//                //NSString *changelog=result[@"changelog"]; //如果有更新 需要用Safari打开的地址
//                //这里放对比版本的逻辑  每个 app 对版本更新的理解都不同
//                //有的对比 version, 有的对比 build
//                if (![versionShort isEqualToString:localVersionShort]) {
//                    UIAlertView  *al =[[UIAlertView alloc]initWithTitle:@"版本更新提示" message:@"增加了详细页评论\n增加了个人信息修改" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"去下载", nil];
//                    al.tag=100;
//                    [al show];
//                }
//            }
//            @catch (NSException *exception) {
//                //返回格式错误 忽略掉
//            }
//        }
//        
//    }];
//}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (alertView.tag==100) {
//        if (buttonIndex==0) {
//        }
//        else
//        {
//            [[UIApplication  sharedApplication] openURL:[NSURL URLWithString:@"https://fir.im/wordCard"]];
//        }
//    }
//}

@end
