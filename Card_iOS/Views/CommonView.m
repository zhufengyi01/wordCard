//
//  CommonView.m
//  Card_iOS
//
//  Created by 朱封毅 on 02/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "CommonView.h"
#import "ZCControl.h"
#import "Constant.h"
@implementation CommonView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor=VLight_GrayColor_apla;
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    self.titleLable =[ZCControl createLabelWithFrame:CGRectMake(10, 10,kDeviceWidth-30, kDeviceWidth-30) Font:20 Text:@"哈哈"];
    self.titleLable.textColor=VGray_color;
    if (IsIphone5) {
        self.titleLable.font =[UIFont fontWithName:kFontRegular size:18];
    }else if(IsIphone6)
    {
        self.titleLable.font =[UIFont fontWithName:kFontRegular size:20];
    }else if(IsIphone6plus)
    {
        self.titleLable.font =[UIFont fontWithName:kFontRegular size:22];
    }
    self.titleLable.textAlignment=NSTextAlignmentCenter;
    [self addSubview:self.titleLable];
}
-(void)configCommonView:(CommonModel *)model;
{
    self.model= model;
    self.titleLable.text=self.model.word;
    
}

@end
