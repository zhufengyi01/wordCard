//
//  BaseTableView.h
//  Card_iOS
//
//  Created by 朱封毅 on 06/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTable : UITableView  <UITextViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSMutableArray *dataArray;
//返回组数
-(NSInteger)numberOfRowsInSection:(NSInteger)section;
//返回行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
