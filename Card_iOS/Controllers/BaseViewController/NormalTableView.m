//
//  NormalTableView.m
//  Card_iOS
//
//  Created by 朱封毅 on 03/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "NormalTableView.h"
#import "Constant.h"
#import "SVProgressHUD.h"
#import "ZCControl.h"
#import "ZFYLoading.h"
@interface NormalTableView () <UITableViewDataSource,UITableViewDelegate>
{
    
}

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
    UIView  *line = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, 1)];
    [self.footView addSubview:line];
    line.backgroundColor = VLight_GrayColor_apla;
    self.statusLable.font =[UIFont fontWithName:KFontThin size:12];
    self.statusLable.textAlignment = NSTextAlignmentCenter;
    self.statusLable.text = @"THE-END";
    self.statusLable.textColor = VGray_color;
    [self.footView addSubview:self.statusLable];
}
-(void)requestData
{
    [self.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.5];
}
-(void)RefreshViewControlEventValueChanged
{
    [self.dataArray removeAllObjects];
    [self requestData];
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
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont fontWithName:KFontThin size:16];
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
    //    if (self.pageCount>self.page&self.dataArray.count==indexPath.row+1) {
    //        self.page++;
    //        [self requestData];
    //    }
    [self tableviewDisplayIndexpath:indexPath];
}
-(void)tableviewDisplayIndexpath:(NSIndexPath *) indexpath
{
    
}
@end
