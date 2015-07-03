//
//  NormalTableView.m
//  Card_iOS
//
//  Created by 朱封毅 on 03/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "NormalTableView.h"

@interface NormalTableView () <UITableViewDataSource,UITableViewDelegate>
{
    
}
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
