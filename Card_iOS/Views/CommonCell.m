//
//  CommonCell.m
//  Card_iOS
//
//  Created by 朱封毅 on 02/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "CommonCell.h"
#import "ZCControl.h"
#import "Constant.h"
#import "CommonView.h"
@implementation CommonCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}
-(void)createCell
{
    self.contentView.backgroundColor =[UIColor whiteColor];
    self.comView = [[CommonView alloc]initWithFrame:CGRectMake(5, 5, kDeviceWidth-10, kDeviceWidth-10)];
    [self.contentView addSubview:self.comView];
}
-(void)configCellValue:(CommonModel *)model RowIndex:(NSInteger)rowIndex
{
    self.model = model;
    self.index=rowIndex;
    [self.comView configCommonView:model];
    
}
+(float)getCellHeightWithModel:(CommonModel*)model
{
    return kDeviceWidth;
}
@end
