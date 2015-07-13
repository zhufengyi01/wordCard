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
#import "WordMainVC.h"
@implementation MainViewController

-(instancetype)init
{
    if (self =  [super init]) {
        self.urlString = @"text/list-by-status";
        self.parameters=@{@"status":@"3"};
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"瞎扯 · 精选";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewScollerTop) name:Refresh_MAIN_LIST object:nil];
    UserDataCenter  *user = [UserDataCenter shareInstance];
    if ([user.is_admin intValue]>0) {
      [self createLeftSystemNavigationItemWith:UIBarButtonSystemItemEdit];
    }
    //[self creatRightNavigationItem:[UIImage imageNamed:@"search"] Title:nil];
    self.tabbleView.frame=CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kHeigthTabBar-kHeightNavigation);
    [self requestData];
}
-(void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    
}
-(void)LeftSystemNavigationButtonClick
{
    [self.navigationController pushViewController:[MainAdmList new] animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
