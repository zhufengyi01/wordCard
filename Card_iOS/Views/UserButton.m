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
        self.frame= CGRectMake(self.frame.origin.x, self.frame.origin.y,240, 40);
        //self.backgroundColor = [UIColor redColor];
        self.headImage= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        //self.headImage.layer.cornerRadius = 13;
        //self.headImage.clipsToBounds= YES;
        self.imageView.backgroundColor = VGray_color;
        [self addSubview:self.headImage];
        
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(40,0, 200, 15)];
        self.titleLab.textColor = View_Black_Color;
        self.titleLab.font = [UIFont fontWithName:KFontThin size:14];
        self.titleLab.text= @"名字";
        [self addSubview:self.titleLab];
        
        self.brieflbl = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, 200, 20)];
        self.brieflbl.textColor=VGray_color;
        self.brieflbl.font = [UIFont fontWithName:KFontThin size:12];
        self.brieflbl.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.brieflbl];
    }
    return self;
}
//
//-(void)setBrieflbl:(UILabel *)brieflbl
//{
//    if (brieflbl==nil) {
//        brieflbl = [[UILabel alloc] initWithFrame:CGRectMake(40,18, 200, 10)];
//        brieflbl.tex
//    }
//}
@end
