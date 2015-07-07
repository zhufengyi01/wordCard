//
//  UserButton.m
//  Card_iOS
//
//  Created by 朱封毅 on 07/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "UserButton.h"
#import "Constant.h"
@implementation UserButton
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame= CGRectMake(self.frame.origin.x, self.frame.origin.y,240, 30);
        //self.backgroundColor = [UIColor redColor];
        self.headImage= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 26, 26)];
        self.headImage.layer.cornerRadius = 13;
        self.headImage.clipsToBounds= YES;
        self.imageView.backgroundColor = VGray_color;
        [self addSubview:self.headImage];
        
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(35,2, 200, 26)];
        self.titleLab.textColor = VGray_color;
        self.titleLab.font = [UIFont systemFontOfSize:14];
        self.titleLab.text= @"名字";
        [self addSubview:self.titleLab];
    }
    return self;
}
@end
