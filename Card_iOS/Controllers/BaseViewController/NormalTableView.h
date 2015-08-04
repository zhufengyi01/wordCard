//
//  NormalTableView.h
//  Card_iOS
//
//  Created by 朱封毅 on 03/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "RootViewController.h"
#import "UIScrollView+EmptyDataSet.h"
@interface NormalTableView : RootViewController

@property(nonatomic,strong) UITableView *tabbleView;

@property(nonatomic,strong) NSMutableArray *dataArray;


@property(nonatomic,assign) NSInteger    pageCount;

@property(nonatomic,assign) NSInteger    pageSzie;

@property(nonatomic,assign) NSInteger    page;

@property(nonatomic,strong) UIRefreshControl *refreshControl;

@property(nonatomic,strong)UILabel *statusLable;


#pragma mark --TableViewDelegate And DataSource
/**
 *  刷新数据
 */
-(void)RefreshViewControlEventValueChanged;

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

//cell即将要显示的时候执行
-(void)tableviewDisplayIndexpath:(NSIndexPath *) indexpath;

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  空数据的代理方法
 *
 *  @param CGPoint 返回空的view 距离左右上下的距离
 *
 *  @return
 */
#pragma mark - DZNEmptyDataSetSource Methods
-(CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView;

/**
 *    空数据的 点击屏幕代理，子类实现这个方法，重新加载
 *
 *  @param scrollView
 */
-(void)emptyDataSetDidTapView:(UIScrollView *)scrollView;

@end
