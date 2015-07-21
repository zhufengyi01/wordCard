//
//  CommentVC.m
//  Card_iOS
//
//  Created by 朱封毅 on 20/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "CommentVC.h"
#import "AFNetworking.h"
#import "ZCControl.h"
#import "Constant.h"
#import "UserDataCenter.h"
#import "Function.h"
#import "SVProgressHUD.h"
#import "CommentModel.h"
#import "GCD.h"
@implementation CommentVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self createLeftNavigationItem:nil Title:@"取消"];
    [self creatRightNavigationItem:nil Title:@"发布"];
    [self creatTextView];
}
-(void)creatTextView
{
    //创建textview
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, kDeviceWidth-20, 200)];
    self.textView.backgroundColor = VLight_GrayColor_apla;
    self.textView.tintColor = View_Black_Color;
    self.textView.textColor= View_Black_Color;
    self.textView.delegate = self;
    [self.textView becomeFirstResponder];
    self.textView.font = [UIFont fontWithName:KFontThin size:18];
    [self.view addSubview:self.textView];
    
    UILabel  *lbl = [ZCControl createLabelWithFrame:CGRectMake(10, self.textView.frame.origin.x+self.textView.frame.size.height+10, 200, 20) Font:12 Text:@"最多只能输入100个字符"];
    lbl.font = [UIFont fontWithName:KFontThin size:10];
    lbl.textColor = VLight_GrayColor;
    [self.view addSubview:lbl];
}
-(void)LeftNavigationButtonClick:(UIButton *)leftbtn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    [self requestPublish];
}
-(void)requestPublish
{
    //去掉两边空格
    NSString *temptext = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //去掉换行符
    temptext= [temptext stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    NSString *urlString =[NSString stringWithFormat:@"%@comment/create", kApiBaseUrl];
    NSString *tokenString =[Function getURLtokenWithURLString:urlString];
    NSDictionary *parameters=@{@"user_id":userCenter.user_id,@"prod_id":self.pro_id,@"content":temptext,KURLTOKEN:tokenString};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue]==0) {
          [SVProgressHUD showSuccessWithStatus:@"发布成功"];
            [GCDQueue executeInMainQueue:^{
                [self dismissViewControllerAnimated:YES completion:^{
                    CommentModel *model =[CommentModel new];
                    [model setValuesForKeysWithDictionary:[responseObject objectForKey:@"model"]];
                    UserModel *user = [UserModel new];
                    user.username = userCenter.username;
                    user.Id= userCenter.user_id;
                    user.fake = userCenter.fake;
                    user.logo = userCenter.logo;
                    model.userInfo = user;
                    self.completeComment(model);
                }];
            } afterDelaySecs:1];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"评论失败，请重试"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"评论失败，请重试"];
    }];
}
#pragma mark  --textViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location>=100) {
        [SVProgressHUD showInfoWithStatus:@"最多输入100个字符"];
        return NO;
    }
    return YES;
}
@end
