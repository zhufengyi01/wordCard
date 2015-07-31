//
//  AddpreviewVC.m
//  Card_iOS
//
//  Created by 朱封毅 on 31/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "AddpreviewVC.h"
#import "UIImage+Color.h"
#import "UIButton+Block.h"
#import "AFNetworking.h"
#import "ZCControl.h"
#import "Constant.h"
#import "CommonView.h"
#import "CommonModel.h"
#import "SVProgressHUD.h"
#import "Function.h"
#import "GCD.h"
@interface AddpreviewVC ()

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)CommonView     *comView;

@property(nonatomic,strong)CommonModel    *model;

@end

@implementation AddpreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"预览";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, kDeviceHeight-kHeightNavigation-45, kDeviceWidth, 45);
    [btn setBackgroundImage:[UIImage imageWithColor:View_white_Color] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:View_BackGround] forState:UIControlStateHighlighted];
    [btn setTitle:@"发  布" forState:UIControlStateNormal];
    [btn setTitleColor:View_Black_Color forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:KFontThin size:16];
    [btn addActionHandler:^(NSInteger tag) {
        [self requestpublish];
    }];
    [self.view addSubview:btn];
    //添加一跟横线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 1)];
    line.backgroundColor = VLight_GrayColor_apla;
    [btn addSubview:line];
    [self scrollView];
    
    self.comView = [[CommonView alloc]initWithFrame:CGRectMake(10, 10, kDeviceWidth-20, kDeviceWidth-20)];
    [self.scrollView addSubview:self.comView];
    self.comView.isLongWord = YES;
    [self.comView configCommonView:self.model];
    if (self.comView.frame.size.height>kDeviceHeight) {
        self.scrollView.contentSize = CGSizeMake(kDeviceWidth,self.comView.frame.size.height+100);
    }
}
-(CommonModel *)model
{
    if (!_model) {
        _model = [CommonModel new];
        _model.word = self.content;
        _model.reference = self.reference;
    }
    return _model;
}
-(UIScrollView *)scrollView
{
    if (_scrollView==nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kHeightNavigation-45)];
        _scrollView.contentSize = CGSizeMake(kDeviceWidth, kDeviceHeight);
        _scrollView.backgroundColor = VLight_GrayColor_apla;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}
-(void)requestpublish
{
    if (self.model.word.length==0) {
        [SVProgressHUD showInfoWithStatus:@"您还没有输入"];
        return;
    }
    [SVProgressHUD showInfoWithStatus:@"正在发布" maskType:SVProgressHUDMaskTypeBlack];
    AFHTTPRequestOperationManager  *manager = [AFHTTPRequestOperationManager manager];
    NSString  *url = [NSString stringWithFormat:@"%@text/create",kApiBaseUrl];
    NSString *tokenString = [Function getURLtokenWithURLString:url];
    NSDictionary  *parameters;
    UserDataCenter *user =[UserDataCenter shareInstance];
    if (self.model.reference.length>0) {
        parameters = @{@"user_id":user.user_id,@"word":self.model.word,@"reference":self.model.reference,KURLTOKEN:tokenString};
    }else
    {
        parameters = @{@"user_id":user.user_id,@"word":self.model.word,KURLTOKEN:tokenString};
    }
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue]==0) {
            [SVProgressHUD showSuccessWithStatus:@"发布成功"];
            [GCDQueue  executeInMainQueue:^{
                [self dismissViewControllerAnimated:YES completion:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:AddCardDidSucucessNotification object:nil];
                }];
            } afterDelaySecs: 1.f];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error  ===%@",error);
        [SVProgressHUD showErrorWithStatus:@"发布失败,请重试"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
