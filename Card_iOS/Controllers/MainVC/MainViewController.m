//
//  MainViewController.m
//  Card_iOS
//
//  Created by 朱封毅 on 02/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

-(instancetype)init
{
    if (self =  [super init]) {
        self.urlString = @"text/list-by-status";
        self.parameters=@{@"status":@"5"};
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
}
@end
