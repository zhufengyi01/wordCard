//
//  DetailLikeBar.m
//  Card_iOS
//
//  Created by 朱封毅 on 07/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "DetailLikeBar.h"
#import "ZCControl.h"
#import "Constant.h"
#import "UIImage+Color.h"

@implementation DetailLikeBar
-(instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, self.frame.origin.y, kDeviceWidth-0, liketoolBarheight);
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 1, kDeviceWidth,1)];
        line.backgroundColor = VGray_color;
        [self addSubview:line];
        self.backgroundColor = [UIColor redColor];
        [self createContent];
    }
    return self;
}
-(void)createContent
{
    NSArray *titleArray = @[@"分享",@"评论",@"点赞"];
    NSArray *imageArray = @[@"detail_share",@"detail_comment",@"detail_like2"];
    for ( int i=0; i<likebttonCount; i++) {
        double x = (kDeviceWidth-0)/likebttonCount*i;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, 0, (kDeviceWidth-0)/likebttonCount,liketoolBarheight)];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        btn.tag = 2000+i;
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
        //[btn setImageEdgeInsets:UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)];
        [btn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        [btn setTitleColor:VGray_color forState:UIControlStateNormal];
        [btn setBackgroundImage: [UIImage imageWithColor:View_BackGround] forState:UIControlStateHighlighted];
        btn.titleLabel.font = [UIFont fontWithName:KFontThin size:14];
        [btn setBackgroundImage:[UIImage imageWithColor:View_ToolBar] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClcik:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}
-(void)btnClcik:(UIButton *) btn
{
    self.btnClickAtInsex(btn.tag-2000);
}

@end
