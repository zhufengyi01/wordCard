//
//  CommonView.h
//  Card_iOS
//
//  Created by 朱封毅 on 02/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonModel.h"

@interface CommonView : UIView

@property(nonatomic,strong) CommonModel  *model;

@property(nonatomic,strong) UILabel *titleLable ;

@property(nonatomic,strong) UILabel  *topRighlbl;   //右上角的标签文字

-(void)configCommonView:(CommonModel *)model;

@end
