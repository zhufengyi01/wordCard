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
    self.textView.font = [UIFont fontWithName:KFontThin size:18];
    [self.view addSubview:self.textView];
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
          [self dismissViewControllerAnimated:YES completion:^{
              //self.completeComment();
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
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"评论失败，请重试"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"评论失败，请重试"];
    }];
    
    
}
@end
