//
//  BaseTableView.h
//  Card_iOS
//
//  Created by 朱封毅 on 02/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "RootViewController.h"

@interface BaseTableView : RootViewController

@property(nonatomic,strong) UITableView  *tabbleView;

@property(nonatomic,strong)NSMutableArray  *dataAraray;

@property(nonatomic,strong) NSMutableArray  *likeArray;


@property(nonatomic,strong)NSString *urlString;

@property(nonatomic,strong)NSDictionary  *parameters;


//滚动到顶部
-(void)tableViewScollerTop;


//子类可重写下面方法
-(void)requestData;
//刷新
-(void)RefreshViewControlEventValueChanged;

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

//子类重写配置cell的方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
