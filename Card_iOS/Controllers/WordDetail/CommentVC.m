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
#import "UITextView+PlaceHolder.h"
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
    self.textView.font = [UIFont fontWithName:KFontThin size:18];
    [self.view addSubview:self.textView];
    if (self.commentmodel) {
        self.title = [NSString stringWithFormat:@"@%@",self.commentmodel.userInfo.username];
        [self.textView addPlaceHolder:[NSString stringWithFormat:@"回复%@ : ",self.commentmodel.userInfo.username]];
    }
    [self.textView becomeFirstResponder];
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
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    NSString *temptext = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //去掉换行符
    temptext= [temptext stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    if (temptext.length==0) {
        [SVProgressHUD showInfoWithStatus:@"不能输入空内容"];
        return ;
    }
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    NSString *urlString =[NSString stringWithFormat:@"%@comment/create", kApiBaseUrl];
    NSString *tokenString =[Function getURLtokenWithURLString:urlString];
    NSDictionary *parameters=@{@"user_id":userCenter.user_id,@"prod_id":self.model.Id,@"content":temptext,KURLTOKEN:tokenString};
    if (self.pageType == CommentVCPageTypeReply) {
        temptext = [NSString stringWithFormat:@"回复%@: %@",self.commentmodel.userInfo.username,temptext];
        parameters =@{@"user_id":userCenter.user_id,@"prod_id":self.model.Id,@"comm_user_id":self.commentmodel.userInfo.Id,@"content":temptext,KURLTOKEN:tokenString};
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue]==0) {
            if (self.pageType == CommentVCPageTypeDefault) {
                [SVProgressHUD showSuccessWithStatus:@"评论成功"];
            }else
            {
                [SVProgressHUD showSuccessWithStatus:@"回复成功"];
            }
            NSInteger  comment = [self.model.comm_count integerValue];
            comment = comment + 1;
            self.model.comm_count =[NSString stringWithFormat:@"%ld",(long)comment];
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
        else{
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
