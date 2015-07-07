//
//  NoticeViewController.m
//  Card_iOS
//
//  Created by 朱封毅 on 07/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "NoticeViewController.h"

@implementation NoticeViewController
-(instancetype)init
{
    if ( self = [super init]) {
         self.urlString = @"noti-up/list";
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
   // self.title = @"消息";
    [self requestData];
}
@end
