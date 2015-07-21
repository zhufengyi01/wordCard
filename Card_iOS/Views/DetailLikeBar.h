//
//  DetailLikeBar.h
//  Card_iOS
//
//  Created by 朱封毅 on 07/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LikeButton.h"
static const float liketoolBarheight = 40;

static const int   likebttonCount = 3;

@interface DetailLikeBar : UIView

@property(nonatomic,strong) void (^btnClickAtInsex)(LikeButton *button);

@end
