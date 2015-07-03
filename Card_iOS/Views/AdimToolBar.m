//
//  AdimToolBar.m
//  Card_iOS
//
//  Created by 朱封毅 on 03/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "AdimToolBar.h"
#import "ZCControl.h"
#import "Constant.h"
#import "UIImage+Color.h"
@implementation AdimToolBar
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    UIView *Bgview =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,BUTTON_HEIGHT)];
    Bgview.userInteractionEnabled = YES;
    [self addSubview:Bgview];
    //管理员页面进入
    NSArray *titleArray = [NSArray arrayWithObjects:@"屏蔽", @"最新", @"正常", @"发现", @"定时", nil];
    for (int i=0; i<5; i++) {
        UIButton *btnBlock =[UIButton buttonWithType:UIButtonTypeCustom];
        btnBlock.tag = 2000 + i;
        UIImage  *ligImage =[UIImage imageWithColor:VGray_color];
        btnBlock.frame=CGRectMake(kDeviceWidth/5*i,0, kDeviceWidth/5, BUTTON_HEIGHT);
        [btnBlock setTitle:titleArray[i] forState:UIControlStateNormal];
        [btnBlock setTitleColor:VBlue_color forState:UIControlStateNormal];
        btnBlock.titleLabel.font =[UIFont fontWithName:kFontRegular size:14];
        [btnBlock setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color"] forState:UIControlStateNormal];
        [btnBlock setBackgroundImage:ligImage forState:UIControlStateHighlighted];
        [btnBlock addTarget:self action:@selector(changeWeiboStatus:) forControlEvents:UIControlEventTouchUpInside];
        [Bgview addSubview:btnBlock];
    }
}
-(void)changeWeiboStatus:(UIButton* ) btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(handOperationAtIndex:)]) {
        [self.delegate handOperationAtIndex:btn.tag-2000];
    }
    
}
@end
