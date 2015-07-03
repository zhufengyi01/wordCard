//
//  RootViewController.h
//  Card_iOS
//
//  Created by 朱封毅 on 02/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController

#pragma mark  --子类重写父类的方法
//创建导航拦左按钮
-(void)createLeftNavigationItem:(UIImage*) leftImage Title:(NSString*)leftTitle;
//创建导航拦左按钮
-(void)creatRightNavigationItem:(UIImage*) RightImage Title:(NSString*)RightTitle;
//点击左按钮
-(void)LeftNavigationButtonClick:(UIButton*) leftbtn;
//点击右按钮
-(void)RightNavigationButtonClick:(UIButton*) rightbtn;


@end
