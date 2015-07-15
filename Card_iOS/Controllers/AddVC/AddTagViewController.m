//
//  AddTagViewController.m
//  Card_iOS
//
//  Created by 朱封毅 on 06/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "AddTagViewController.h"
#import "ZCControl.h"
#import "Constant.h"
@implementation AddTagViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    //self.title = @"填写信息";
    [self creatRightNavigationItem:nil Title:@"确定"];
    [self createTextView];
}
-(void)createTextView
{
    self.myTextfield = [[UITextField alloc]initWithFrame:CGRectMake(0, 10, kDeviceWidth , 40)];
    self.myTextfield.textColor = View_Black_Color;
    self.myTextfield.placeholder =@"输入出处";
    self.myTextfield.tintColor = View_Black_Color;
    self.myTextfield.font = [UIFont fontWithName:KFontThin size:14];
    self.myTextfield.backgroundColor = VLight_GrayColor_apla;
    //self.myTextfield.selectedTextRange = NSMakeRange(1, 0);
    self.myTextfield.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    self.myTextfield.leftViewMode = UITextFieldViewModeAlways;
    [self.myTextfield becomeFirstResponder];
    [self.view addSubview:self.myTextfield];
}
-(void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    self.callback(self.myTextfield.text);
    [self.navigationController popViewControllerAnimated:NO];
   
}
@end
