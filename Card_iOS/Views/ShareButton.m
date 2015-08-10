//
//  MyButton.m
//  movienext
//
//  Created by 杜承玖 on 6/3/15.
//  Copyright (c) 2015 redianying. All rights reserved.
//

#import "ShareButton.h"
#import "Constant.h"
#import "UIImage+Color.h"
@interface ShareButton ()
{
    CGRect boundingRect;
    CGRect m_frame;
}
@end

@implementation ShareButton

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        m_frame = frame;
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, (kDeviceWidth-20)/3,(kDeviceWidth-20)/4);
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    self.btnimage = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-30)/2, 10, 30, 30)];
    [self addSubview:self.btnimage];
    
    [self setBackgroundImage:[UIImage imageWithColor:View_ToolBar] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageWithColor:VLight_GrayColor_apla] forState:UIControlStateNormal];
    self.btnlbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 50,self.frame.size.width, 15)];
    self.btnlbl.font = [UIFont fontWithName:KFontThin size:14];
    self.btnlbl.textAlignment = NSTextAlignmentCenter;
    self.btnlbl.textColor = VGray_color;
    [self addSubview:self.btnlbl];
}
@end
