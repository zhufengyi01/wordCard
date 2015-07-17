//
//  Disc_loading.m
//  Card_iOS
//
//  Created by 朱封毅 on 16/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "Discloading.h"
#import "ZCControl.h"
#import "Constant.h"
#import <QuartzCore/QuartzCore.h>
//const float  Rotation_InterVal = 1.3f;

@implementation Discloading

-(instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = View_white_Color;
        self.frame= CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kHeightNavigation);
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    self.LoadImage  = [[UIImageView alloc]initWithFrame:CGRectMake((kDeviceWidth-180)/2, (kDeviceHeight-180-kHeightNavigation-100)/2, 180, 180)];
    self.LoadImage.image = [UIImage imageNamed:@"discover_loading"];
    [self addSubview:self.LoadImage];
    
    CABasicAnimation *animation = [self Rotaionaimation];
    [self.LoadImage.layer addAnimation:animation forKey:@"rotation"];
    
}
-(CABasicAnimation *)Rotaionaimation
{
    CABasicAnimation* rotationAnimation =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//"z"还可以是“x”“y”，表示沿z轴旋转
    rotationAnimation.toValue = [NSNumber numberWithFloat:(-2 * M_PI) * 3];
    // 3 is the number of 360 degree rotations
    // Make the rotation animation duration slightly less than the other animations to give it the feel
    // that it pauses at its largest scale value
    rotationAnimation.duration = 2.8;
    rotationAnimation.repeatCount = MAX_CANON;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]; //缓入缓出
    return rotationAnimation;
    
}
@end
