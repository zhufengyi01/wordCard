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

@end
@implementation NormalTableView

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.dataArray =[NSMutableArray array];
    self.tabbleView =[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tabbleView.delegate = self;
    self.tabbleView.dataSource =self;
    [self.view addSubview:self.tabbleView];
    [self.tabbleView setTableFooterView:[[UIView alloc]init]];
    self.refreshControl =[[UIRefreshControl alloc]init];
    self.refreshControl.backgroundColor =View_BackGround;
    //NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:12],NSFontAttributeName,nil];
    //self.refreshControl.attributedTitle =[[NSAttributedString alloc]initWithString:@"下拉刷新" attributes:dict]; //
    [self.refreshControl addTarget:self action:@selector(RefreshViewControlEventValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.tabbleView addSubview:self.refreshControl];
    
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
    cell.textLabel.text  = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
