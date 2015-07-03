//
//  RootViewController.m
//  Card_iOS
//
//  Created by 朱封毅 on 02/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "RootViewController.h"
#import "Constant.h"
#import "ZCControl.h"
#import "UIImage+Color.h"
@implementation RootViewController
-(void)loadView
{
    [super loadView];
}
-(void)viewDidLoad
{
    
    self.view.backgroundColor = View_BackGround;
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
}
-(void)createLeftNavigationItem:(UIImage*) leftImage Title:(NSString*)leftTitle
{
    UIButton  *leftbtn =[ZCControl createButtonWithFrame:CGRectMake(0, 0, 40, 50) ImageName:nil Target:self Action:@selector(LeftNavigationButtonClick:) Title:nil];
    if (leftImage) {
        [leftbtn setImage:leftImage forState:UIControlStateNormal];
        [leftbtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    }
    if (leftTitle) {
        [leftbtn setTitle:leftTitle forState:UIControlStateNormal];
        leftbtn.titleLabel.font =[UIFont fontWithName:kFontRegular size:12];
        [leftbtn setTitleColor:VGray_color forState:UIControlStateNormal];
        [leftbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftbtn];
}
-(void)creatRightNavigationItem:(UIImage*) RightImage Title:(NSString*)RightTitle
{
    UIButton  *Righttbtn =[ZCControl createButtonWithFrame:CGRectMake(0, 0, 40, 50) ImageName:nil Target:self Action:@selector(RightNavigationButtonClick:) Title:nil];
    if (RightImage) {
        [Righttbtn setImage:RightImage forState:UIControlStateNormal];
        [Righttbtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        
    }
    if (RightTitle) {
        [Righttbtn setTitle:RightTitle forState:UIControlStateNormal];
        Righttbtn.titleLabel.font =[UIFont fontWithName:kFontRegular size:12];
        [Righttbtn setTitleColor:VGray_color forState:UIControlStateNormal];
        [Righttbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:Righttbtn];
}

-(void)createLeftSystemNavigationItemWith:(UIBarButtonSystemItem )systemBarStyle
{
    UIBarButtonItem  *bar =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:systemBarStyle target:self action:@selector(LeftSystemNavigationButtonClick)];
    self.navigationItem.leftBarButtonItem =bar;
}

-(void)createRightSystemNavigationItemWith:(UIBarButtonSystemItem )systemBarStyle
{
    UIBarButtonItem  *bar =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:systemBarStyle target:self action:@selector(RightSystemNavigationButtonClick)];
    self.navigationItem.rightBarButtonItem =bar;
}
//自定义样式
-(void)LeftNavigationButtonClick:(UIButton*) leftbtn
{
    
}
-(void)RightNavigationButtonClick:(UIButton*) rightbtn
{
    
}
//系统的样式
-(void)LeftSystemNavigationButtonClick
{
    
}
-(void)RightSystemNavigationButtonClick
{
 
    
}





//系统样式

@end
