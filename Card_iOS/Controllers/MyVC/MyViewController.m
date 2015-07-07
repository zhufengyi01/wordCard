//
//  MyViewController.m
//  Card_iOS
//
//  Created by 朱封毅 on 02/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "MyViewController.h"
#import "SettingViewController.h"
@implementation MyViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self creatRightNavigationItem:nil Title:@"设置"];
}
-(void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    [self.navigationController pushViewController:[SettingViewController new] animated:YES];
}

@end
