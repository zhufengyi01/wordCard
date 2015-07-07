//
//  BaseTableView.m
//  Card_iOS
//
//  Created by 朱封毅 on 06/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "BaseTable.h"

@implementation BaseTable
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self =[super initWithFrame:frame style:style]) {
       
    }
    return self;
}
-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = @"哈哈";
    return cell;
}
@end
