//
//  DiscoverViewController.m
//  Card_iOS
//
//  Created by 朱封毅 on 07/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "DiscoverViewController.h"

@implementation DiscoverViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    //self.title = @"发现";
    [self createLeftNavigationItem:nil Title:@"取消"];
}
-(void)LeftNavigationButtonClick:(UIButton *)leftbtn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
