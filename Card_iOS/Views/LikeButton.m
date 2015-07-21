//
//  LikeButton.m
//  Card_iOS
//
//  Created by 朱封毅 on 07/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "LikeButton.h"
#import "ZCControl.h"
#import "Constant.h"
#import "UIImage+Color.h"
@implementation LikeButton
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:[UIImage imageWithColor:View_ToolBar] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageWithColor:View_BackGround] forState:UIControlStateHighlighted];
        //[self setBackgroundImage:[UIImage imageWithColor:VGray_color] forState:UIControlStateSelected];
        self.frame= CGRectMake(self.frame.origin.x, self.frame.origin.y,kDeviceWidth/3, 40);
        self.backgroundColor = [UIColor redColor];
        self.likeImage= [[UIImageView alloc]initWithFrame:CGRectMake(45,12, 15, 15)];
        self.likeImage.image = [UIImage imageNamed:@"detail_like.png"];
        [self addSubview:self.likeImage];
        
        self.likeCountLbl = [[UILabel alloc]initWithFrame:CGRectMake(70,0,40, 40)];
        self.likeCountLbl.textColor = VGray_color;
        self.likeCountLbl.textAlignment = NSTextAlignmentLeft;
        self.likeCountLbl.font = [UIFont fontWithName:KFontThin size:14];
        self.likeCountLbl.text= @"123";
        [self addSubview:self.likeCountLbl];
    }
    return self;
}

@end
