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
@implementation LikeButton
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame= CGRectMake(self.frame.origin.x, self.frame.origin.y,100, 30);
        //self.backgroundColor = [UIColor redColor];
        self.likeImage= [[UIImageView alloc]initWithFrame:CGRectMake(100-28,5, 18, 15)];
        self.likeImage.image = [UIImage imageNamed:@"detail_like.png"];
        [self addSubview:self.likeImage];
        
        self.likeCountLbl = [[UILabel alloc]initWithFrame:CGRectMake(10,0,55, 25)];
        self.likeCountLbl.textColor = VGray_color;
        self.likeCountLbl.textAlignment = NSTextAlignmentRight;
        self.likeCountLbl.font = [UIFont fontWithName:KFontThin size:12];
        self.likeCountLbl.text= @"123";
        [self addSubview:self.likeCountLbl];
    }
    return self;
}

@end
