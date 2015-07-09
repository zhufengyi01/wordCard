//
//  NormalTableView.m
//  Card_iOS
//
//  Created by 朱封毅 on 03/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "NormalTableView.h"
#import "Constant.h"
#import "ZCControl.h"
@interface NormalTableView () <UITableViewDataSource,UITableViewDelegate>
{
    
}
@property(nonatomic,strong) UIRefreshControl *refreshControl;

@property(nonatomic,strong) UIView *footView;

@property(nonatomic,strong)UILabel *statusLable;

@end
@implementation NormalTableView

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.pageCount = 1;
    self.pageSzie = 20;
    self.page = 1;
    self.dataArray =[NSMutableArray array];
    self.tabbleView =[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tabbleView.delegate = self;
    self.tabbleView.dataSource =self;
    self.tabbleView.backgroundColor = View_white_Color;
    [self.view addSubview:self.tabbleView];
    if ([self.tabbleView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tabbleView setSeparatorInset:UIEdgeInsetsMake(0, -1100, 0, -100)];
    }
    if ([self.tabbleView     respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tabbleView setLayoutMargins:UIEdgeInsetsMake(0,-1100, 0, -100)];
    }
    [self.tabbleView setTableFooterView:[[UIView alloc]init]];
    self.refreshControl =[[UIRefreshControl alloc]init];
    self.refreshControl.backgroundColor =View_white_Color;
    //NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:12],NSFontAttributeName,nil];
    //self.refreshControl.attributedTitle =[[NSAttributedString alloc]initWithString:@"下拉刷新" attributes:dict]; //
    [self.refreshControl addTarget:self action:@selector(RefreshViewControlEventValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.tabbleView addSubview:self.refreshControl];
    [self createFootView];

}
-(void)createFootView
{
    self.footView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, BUTTON_HEIGHT)];
    self.footView.backgroundColor =[UIColor whiteColor];
    [self.tabbleView setTableFooterView:self.footView];
    self.statusLable  = [[UILabel alloc]initWithFrame:CGRectMake((kDeviceWidth-100)/2, 0, 100,BUTTON_HEIGHT)];
    UIView  *line = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, 0.5)];
    [self.footView addSubview:line];
    line.backgroundColor = VLight_GrayColor_apla;
    self.statusLable.font =[UIFont fontWithName:kFontRegular size:12];
    self.statusLable.textAlignment = NSTextAlignmentCenter;
    self.statusLable.text = @"THE-END";
    self.statusLable.textColor = VGray_color;
    [self.footView addSubview:self.statusLable];
}

-(void)RefreshViewControlEventValueChanged
{
    [self.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.5];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId =@"CELL";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    if (self.dataArray.count>indexPath.row) {
      cell.textLabel.text  = [self.dataArray objectAtIndex:indexPath.row];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tabbleView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tabbleView setSeparatorInset:UIEdgeInsetsMake(0, -1100, 0, -100)];
    }
    if ([self.tabbleView     respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tabbleView setLayoutMargins:UIEdgeInsetsMake(0, -1100, 0, -100)];
    }
}

@end
