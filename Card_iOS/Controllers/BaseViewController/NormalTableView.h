//
//  NormalTableView.h
//  Card_iOS
//
//  Created by 朱封毅 on 03/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "RootViewController.h"

@interface NormalTableView : RootViewController

@property(nonatomic,strong) UITableView *tabbleView;

@property(nonatomic,strong) NSMutableArray *dataArray;


@property(nonatomic,assign) NSInteger    pageCount;

@property(nonatomic,assign) NSInteger    pageSzie;

@property(nonatomic,assign) NSInteger    page;

@property(nonatomic,strong) UIRefreshControl *refreshControl;


#pragma mark --TableViewDelegate And DataSource
/*
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



@end
