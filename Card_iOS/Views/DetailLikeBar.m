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


@implementation DetailLikeBar
-(instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, kDeviceWidth-20, liketoolBarheight);
        [self createContent];
    }
    return self;
}
-(void)createContent
{
    NSArray *titleArray = @[@"分享",@"喜欢",@"评论"];
    for ( int i=0; i<likebttonCount; i++) {
        double x = (kDeviceWidth-20)/likebttonCount;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, 0, (kDeviceWidth-20)/likebttonCount,liketoolBarheight)];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        btn.tag = 2000+i;
        [btn addTarget:self action:@selector(btnClcik:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}
-(void)btnClcik:(UIButton *) btn
{
    self.btnClickAtInsex(btn.tag-2000);
}

@end
