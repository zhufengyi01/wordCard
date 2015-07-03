//
//  MainAdmList.m
//  Card_iOS
//
//  Created by 朱封毅 on 03/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "MainAdmList.h"
#import "TimingList.h"
#define ADM_CLOSE 0
#define ADM_NEW 1
#define ADM_NOR 2
#define ADM_DISCOR 3
#define ADM_TIM  4

@implementation MainAdmList

-(void)viewDidLoad
{
    [super viewDidLoad];
     self.title = @"管理员功能列表";
    self.dataArray = [NSMutableArray arrayWithObjects:@"屏蔽",@"最新",@"正常",@"发现",@"定时", nil];
    [self.tabbleView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimingList *TVC= [TimingList new];
    TVC.urlString =  @"text/list-by-status";
    switch (indexPath.row) {
        case ADM_CLOSE:
            TVC.parameters=@{@"status":@"0"};
            TVC.title = @"屏蔽";
            break;
            case ADM_NEW:
             TVC.parameters=@{@"status":@"5"};
             TVC.title = @"最新";
             break;
            case ADM_NOR:
            TVC.parameters=@{@"status":@"1"};
            TVC.title =@"正常";
            break;
            case ADM_DISCOR:
            TVC.parameters=@{@"status":@"2"};
            TVC.title =@"发现";
            break;
            case ADM_TIM:
            TVC.parameters=@{@"status":@"4"};
            TVC.title =@"定时";
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:TVC animated:YES];
    
}
@end
