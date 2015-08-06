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
#import "UIImage+Color.h"
#import "ZFYLoading.h"
@interface NormalTableView () <UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    
}

@property(nonatomic,strong) UIView *footView;



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
    self.refreshControl.backgroundColor = VLight_GrayColor_apla;
    [self.tabbleView addSubview:self.refreshControl];
    //[self createFootView];
    [self setuoDZEmptyData];
}
-(void)setuoDZEmptyData
{
    self.tabbleView.emptyDataSetSource = self;
    self.tabbleView.emptyDataSetDelegate = self;
}
//-(void)createFootView
//{
//    self.footView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, BUTTON_HEIGHT)];
//    self.footView.backgroundColor =[UIColor whiteColor];
//    [self.tabbleView setTableFooterView:self.footView];
//    self.statusLable  = [[UILabel alloc]initWithFrame:CGRectMake((kDeviceWidth-100)/2, 0, 100,BUTTON_HEIGHT)];
//    UIView  *line = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, 1)];
//    [self.footView addSubview:line];
//    line.backgroundColor = VLight_GrayColor_apla;
//    self.statusLable.font =[UIFont fontWithName:KFontThin size:12];
//    self.statusLable.textAlignment = NSTextAlignmentCenter;
//    self.statusLable.text = @"THE-END";
//    self.statusLable.textColor = VGray_color;
//    [self.footView addSubview:self.statusLable];
//}
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
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
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
    [self tableviewDisplayIndexpath:indexPath];
}
-(void)tableviewDisplayIndexpath:(NSIndexPath *) indexpath
{
    
}

#pragma mark - DZNEmptyDataSetSource Methods
//-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
//{
//    NSMutableDictionary *attributes = [NSMutableDictionary new];
//    [attributes setObject:[UIFont fontWithName:KFontThin size:12] forKey:NSFontAttributeName];
//    NSAttributedString *text = [[NSAttributedString alloc] initWithString:@"没有数据"];
//    return nil;
//}
-(NSAttributedString*)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:[UIFont fontWithName:KFontThin size:14] forKey:NSFontAttributeName];
    [attributes setObject:VLight_GrayColor forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"没有消息" attributes:attributes];
}
-(UIImage*)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return  [UIImage imageNamed:@"empty"];
}
-(NSAttributedString*)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:[UIFont systemFontOfSize:10] forKey:NSFontAttributeName];
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:@"重试"];
    return text;
}
//-(UIImage*)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
//{
//    return [UIImage imageWithColor:VGray_color];
//}
-(CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return   CGPointMake(0, -50);
}
-(UIImage*)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    return [UIImage imageWithColor:VGray_color];
}
//行之间的间距
-(CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 20;
}



#pragma mark - DZNEmptyDataSetDelegate Methods
-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}
-(BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}
-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

-(void)emptyDataSetDidTapView:(UIScrollView *)scrollView
{
    NSLog(@"=====%s",__FUNCTION__);
}
-(void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    NSLog(@"======%s",__FUNCTION__);
}


@end
