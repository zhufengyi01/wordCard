//
//  AuthorToolBar.m
//  Card_iOS
//
//  Created by 朱封毅 on 23/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "AuthorToolBar.h"
#import "ZCControl.h"
#import "Constant.h"
@implementation AuthorToolBar

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(5, 50,kDeviceWidth-10, 20);
        //self.backgroundColor = [UIColor redColor];
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    
    ///关于图片
    _eyesView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 20, 20)];
    _eyesView.image = [UIImage imageNamed:@"tiny_eye"];
    [self addSubview:_eyesView];
    
    _heartView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 0, 20, 20)];
    _heartView.image = [UIImage imageNamed:@"tiny_like"];
    [self addSubview:_heartView];
    
    _commentView = [[UIImageView alloc]initWithFrame:CGRectMake(110, 0, 20, 20)];
    _commentView.image = [UIImage imageNamed:@"tiny_comments"];
    [self addSubview:_commentView];
    
    
    //lbl 设置
    _esylbl = [ZCControl createLabelWithFrame:CGRectMake(30, 0, 40, 20) Font:12 Text:@"0"];
    _esylbl.font = [UIFont fontWithName:KFontThin size:10];
    _esylbl.textColor = VGray_color;
    [self addSubview:_esylbl];
    
    _heartlbl = [ZCControl createLabelWithFrame:CGRectMake(80, 0, 40, 20) Font:12 Text:@"0"];
    _heartlbl.font = [UIFont fontWithName:KFontThin size:10];
    _heartlbl.textColor = VGray_color;
    [self addSubview:_heartlbl];

    _commetlbl = [ZCControl createLabelWithFrame:CGRectMake(130, 0, 40, 20) Font:12 Text:@"0"];
    _commetlbl.font = [UIFont fontWithName:KFontThin size:10];
    _commetlbl.textColor = VGray_color;
    [self addSubview:_commetlbl];
        
}
//-(void)setEyesView:(UIImageView *)eyesView
//{
//    if (_eyesView) {
//        _eyesView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 10, 10)];
//        _eyesView.backgroundColor = [UIColor redColor];
//        [self addSubview:_eyesView];
//    }
//}
//-(void)setHeartView:(UIImageView *)heartView
//{
//    
//}
//-(void)setCommentView:(UIImageView *)commentView
//{
//    
//}
@end
