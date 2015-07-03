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
//        self.urlString = @"text/list-by-status";
//        self.parameters=@{@"status":@"5"};
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
     self.tabbleView.frame=CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
    [self requestData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    WordMainVC  *wordmian =[WordMainVC new];
    wordmian.MainArray = self.dataAraray;
    wordmian.IndexOfItem= indexPath.row;
    [self.navigationController pushViewController:wordmian animated:YES];
}


@end
