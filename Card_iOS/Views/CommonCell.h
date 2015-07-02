//
//  CommonCell.h
//  Card_iOS
//
//  Created by 朱封毅 on 02/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonView.h"
#import "CommonCell.h"

@interface CommonCell : UITableViewCell

@property(nonatomic,strong)CommonView *comView;

@property(nonatomic,assign) NSInteger  index;

@property(nonatomic,strong) CommonModel *model;

-(void)configCellValue:(CommonModel*)model RowIndex:(NSInteger) rowIndex;


+(float)getCellHeightWithModel:(CommonModel*)model;

@end
