//
//  TimingList.m
//  Card_iOS
//
//  Created by 朱封毅 on 03/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "TimingList.h"
#import "ZCControl.h"
#import "Constant.h"
#import "MainAdmList.h"
#import "WordMainVC.h"
@implementation TimingList

-(instancetype)init
{
    if (self =  [super init]) {
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
    self.tabbleView.frame=CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kHeightNavigation);
    [self requestData];
}
@end
