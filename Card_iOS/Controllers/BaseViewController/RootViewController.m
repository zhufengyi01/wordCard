//
//  RootViewController.m
//  Card_iOS
//
//  Created by 朱封毅 on 02/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "RootViewController.h"
#import "Constant.h"
#import "ZCControl.h"
#import "UIImage+Color.h"
@implementation RootViewController
-(void)loadView
{
    [super loadView];
}
-(void)viewDidLoad
{

    self.view.backgroundColor = View_BackGround;
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
}
@end
