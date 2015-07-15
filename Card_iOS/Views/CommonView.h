//
//  CommonView.h
//  Card_iOS
//
//  Created by 朱封毅 on 02/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonModel.h"
#import "ZfyActionSheet.h"
#import "TTTAttributedLabel.h"
@interface CommonView : UIView <ZfyActionSheetDelegate>

@property(nonatomic,strong) CommonModel  *model;

@property(nonatomic,strong) TTTAttributedLabel *titleLable ;

@property(nonatomic,strong) UILabel  *topRighlbl;   //右上角的标签文字

@property(nonatomic,assign) BOOL     isLongWord;

@property(nonatomic,strong)UILabel   *word_Soure;

-(void)configCommonView:(CommonModel *)model;

@end
