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
#import "LikeButton.h"

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
    NSArray *imageArray = @[@"detail_share",@"detail_comments",@"detail_like2"];
    for ( int i=0; i<likebttonCount; i++) {
        double x = (kDeviceWidth-0)/likebttonCount*i;
        LikeButton *btn = [[LikeButton alloc]initWithFrame:CGRectMake(x, 0, (kDeviceWidth-0)/likebttonCount,liketoolBarheight)];
        btn.tag = 2000+i;
        [btn setBackgroundImage:[UIImage imageWithColor:View_white_Color] forState:UIControlStateNormal];
        btn.likeImage.image = [UIImage imageNamed:imageArray[i]];
        btn.likeCountLbl.text = titleArray[i];
        [btn addTarget:self action:@selector(btnClcik:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}
-(void)btnClcik:(LikeButton *) btn
{
    self.btnClickAtInsex(btn);
}

@end
