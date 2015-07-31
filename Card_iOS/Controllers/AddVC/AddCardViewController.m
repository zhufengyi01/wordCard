//
//  AddCardViewController.m
//  Card_iOS
//
//  Created by 朱封毅 on 02/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "AddCardViewController.h"
#import "ZCControl.h"
#import "Constant.h"
#import "AFNetworking.h"
#import "UIButton+Block.h"
#import "UITextView+PlaceHolder.h"
#import "UIScrollView+Addition.h"
#import "Function.h"
#import "UIImage+Color.h"
#import "AddTagViewController.h"
#import "SVProgressHUD.h"
#import "UserDataCenter.h"
#import "GCD.h"
#import "AddpreviewVC.h"
#define TEXT_VIEW_HEIGHT  200

NSTimeInterval const  dismissInterval = 1.f;
@implementation AddCardViewController

#pragma mark  --SystemMethod
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发布文字";
    [self createmyScrollView];
    [self createLeftNavigationItem:nil Title:@"取消"];
    [self creatRightNavigationItem:nil Title:@"预览"];
    [self createWordView];
    [self  textField];
}

#pragma mark --Custom Method

-(void )createmyScrollView
{
    self.myScrollView  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kHeightNavigation)];
    self.myScrollView.contentSize = CGSizeMake(kDeviceWidth, kDeviceHeight);
    //self.myScrollView.backgroundColor =View_BackGround;
    self.myScrollView.delegate = self;
    [self.view addSubview:self.myScrollView];
    [self textField];
}
-(UITextField *)textField
{
    if(_textField==nil)
    {
        _textField = [[UITextField alloc]init];
        _textField.frame = CGRectMake(10, TEXT_VIEW_HEIGHT+20, kDeviceWidth-20, 40);
        _textField.placeholder  =@"原文出处";
        _textField.textColor = View_Black_Color;
        _textField.font = [UIFont fontWithName:KFontThin size:16];
        [_textField setBackgroundColor:VLight_GrayColor_apla];
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _textField.leftViewMode = UITextFieldViewModeAlways;
        [self.view addSubview:_textField];
    }
    return _textField;
}

//-(void )createSourceButton{
//    self.SourceButton =  [UIButton  buttonWithType:UIButtonTypeCustom];
//    self.SourceButton.frame= CGRectMake(10, TEXT_VIEW_HEIGHT+20, kDeviceWidth-20, 40);
//    NSMutableAttributedString  *tititstr =[[NSMutableAttributedString alloc]initWithString:@"出处"];
//    NSRange  rang = NSMakeRange(0, 2);
//    [self.SourceButton  setBackgroundImage:[UIImage imageWithColor:VLight_GrayColor_apla] forState:UIControlStateNormal];
//    [self.SourceButton setBackgroundImage:[UIImage imageWithColor:VLight_GrayColor] forState:UIControlStateHighlighted];
//    __weak typeof(self) weakself = self;
//    [self.SourceButton addActionHandler:^(NSInteger tag) {
//        AddTagViewController *Adt = [AddTagViewController new];
//        Adt.callback = ^(NSString *value)
//        {
//            NSLog(@"value ===%@",value);
//            weakself.tagString = value;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                weakself.sourceLable.text = weakself.tagString;
//            });
//        };
//        [weakself.navigationController pushViewController:Adt animated:NO];
//    }];
//    [tititstr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} range:rang];
//    [tititstr addAttributes:@{NSForegroundColorAttributeName:VGray_color} range:rang];
//    //self.SourceButton.titleLabel.attributedText = tititstr;
//    //[self.SourceButton setTitle:@"出处" forState:UIControlStateNormal];
//    [self.SourceButton setTitleColor:VGray_color forState:UIControlStateNormal];
//    self.SourceButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    [self.myScrollView addSubview:self.SourceButton];
//    
//    UILabel  *shlbl = [ZCControl createLabelWithFrame:CGRectMake(10,0, 40, 40) Font:16 Text:@"出处"];
//    shlbl.textColor = VGray_color;
//    shlbl.font = [UIFont fontWithName:KFontThin size:14];
//    [self.SourceButton addSubview:shlbl];
//     self.sourceLable = [ZCControl createLabelWithFrame:CGRectMake(50, 0,kDeviceWidth-50, 40) Font:12 Text:@"例如：连岳《发扬不要脸精神》"];
//    self.sourceLable.font = [UIFont fontWithName:KFontThin size:12];
//    self.sourceLable.textAlignment= NSTextAlignmentLeft;
//    self.sourceLable.adjustsFontSizeToFitWidth = NO;
//    self.sourceLable.textColor = VLight_GrayColor;
//    [self.SourceButton addSubview:self.sourceLable];
//}
#pragma mark  --Naviation Overwrite
-(void)LeftNavigationButtonClick:(UIButton *)leftbtn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    if (self.myTextView.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"您还没有输入"];
        return;
    }
    AddpreviewVC *prevc = [AddpreviewVC new];
    prevc.content  = self.myTextView.text;
    prevc.reference = self.textField.text;
    [self.navigationController pushViewController:prevc animated:YES];

}
-(void)createWordView
{
    UIImageView *bgImageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 10,kDeviceWidth-20 , TEXT_VIEW_HEIGHT)];
    bgImageView.backgroundColor =VLight_GrayColor_apla;
    [self.myScrollView addSubview:bgImageView];
    bgImageView.layer.cornerRadius = 4;
    bgImageView.clipsToBounds = YES;
    bgImageView.layer.borderWidth = 0.1;
    bgImageView.layer.borderColor=VLight_GrayColor.CGColor;
    bgImageView.userInteractionEnabled = YES;
    self.myTextView =[[UITextView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth-20, TEXT_VIEW_HEIGHT)];
    //[self.myTextView addPlaceHolder:@"输入文字"];
    [self.myTextView becomeFirstResponder];
    self.myTextView.backgroundColor = VLight_GrayColor_apla;
    self.myTextView.tintColor = View_Black_Color;
    self.myTextView.delegate = self;
    self.myTextView.font =[UIFont fontWithName:KFontThin size:18];
    self.myTextView.textColor = View_Black_Color;
    [bgImageView addSubview:self.myTextView];
}
#pragma mark  --UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

#pragma mark  --UIScrollerViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.myTextView resignFirstResponder];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AddCardDidSucucessNotification object:nil];
}

@end
