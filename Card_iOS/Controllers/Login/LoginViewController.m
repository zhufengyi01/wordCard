//
//  LoginViewController.m
//  movienext
//
//  Created by 风之翼 on 15/2/27.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "LoginViewController.h"
//#import "Masonry.h"
#import "AppDelegate.h"
#import "BaseNavigationViewController.h"
//#import "MASConstraint.h"
//#import "MASConstraintMaker.h"
//#import "CustmoTabBarController.h"
#import "Constant.h"
//#import "User.h"       //用户模型
#import "UMSocial.h"
#import "UMSocialControllerService.h"
#import "AFNetworking.h"
#import "Function.h"
#import "UserDataCenter.h"
#import "UMSocialWechatHandler.h"
#import "ZCControl.h"
#import "SerViceViewController.h"
///#import "UserHeadChangeViewController.h"
#import "WXApi.h"
//#define kSegueLoginToIndex @"LoginToIndex"
#import "Login2_1ViewController.h"
#import "Function.h"
#import "SVProgressHUD.h"
#import "CustomController.h"
#import "Register_1ViewController.h"
#import "UIImage+Color.h"

#define  IsInstallWechat   0    //1表示已经安装   0是未安装

@interface LoginViewController ()<UMSocialUIDelegate>
{
    AppDelegate  *appdelegate;
    UIWindow     *window;
    NSString     *ssoName;
    
    UIButton  *weiChateButton;
    UIButton  *weiboButton;
    UIButton  *checkBtn;
    UIButton  *checkBtn2;
    
}
@end

@implementation LoginViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden=NO;
    appdelegate = [[UIApplication sharedApplication]delegate];
    window=appdelegate.window;
    self.view.backgroundColor=[UIColor whiteColor];
    [self creatUI];
}
-(void)creatUI
{
    UIImageView   *logoImageView=[[UIImageView alloc]initWithFrame:CGRectMake((kDeviceWidth-200)/2, 125, 200,250)];
    logoImageView.image=[UIImage imageNamed:@"launcher"];
    [self.view addSubview:logoImageView];
    
    UILabel  *title = [ZCControl createLabelWithFrame:CGRectMake(0,160, kDeviceWidth, 40) Font:30 Text:@"瞎扯"];
    title.textAlignment = NSTextAlignmentCenter;
    //[self.view addSubview:title];
    //title.textColor = VGray_color;
    
    UILabel  *d_title = [ZCControl createLabelWithFrame:CGRectMake(0,220, kDeviceWidth, 40) Font:16 Text:@"文字的采集与分享"];
    d_title.textAlignment = NSTextAlignmentCenter;
    //[self.view addSubview:d_title];
    d_title.textColor = VGray_color;

    checkBtn=[ZCControl createButtonWithFrame:CGRectMake((kDeviceWidth-140)/2,kDeviceHeight-40, 140, 30) ImageName:nil Target:self Action:@selector(checkClick:) Title:@""];
    //   checkBtn.backgroundColor=[UIColor redColor];
    [checkBtn setImage:[UIImage imageNamed:@"unselect_icon.png"] forState:UIControlStateNormal];
    [checkBtn setImage:[UIImage imageNamed:@"selected_icon.png"] forState:UIControlStateSelected];
    //默认勾选状态
    checkBtn.selected=YES;
    checkBtn.tag=100;
    checkBtn.hidden = YES;
    [checkBtn setTitleColor:[UIColor colorWithRed:216.0/255 green:216.0/255 blue:216.0/255 alpha:216.0/255] forState:UIControlStateNormal];
    [checkBtn setTitle:@"登录注册成功，即接受" forState:UIControlStateNormal];
    [checkBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 5, 0, 0)];
    // checkBtn.backgroundColor=[UIColor redColor];
    [checkBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    checkBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [self.view addSubview:checkBtn];
    
    
    checkBtn2=[ZCControl createButtonWithFrame:CGRectMake(checkBtn.frame.origin.x+checkBtn.frame.size.width,checkBtn.frame.origin.y, 120, 30) ImageName:nil Target:self Action:@selector(checkClick:) Title:@""];
    [checkBtn2 setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    //checkBtn2.backgroundColor=[UIColor blackColor];
    [checkBtn2 setTitle:@"《影弹服务使用条款》" forState:UIControlStateNormal];
    [checkBtn2 setTitleColor:[UIColor colorWithRed:216.0/255 green:216.0/255 blue:216.0/255 alpha:216.0/255] forState:UIControlStateNormal];
    checkBtn2.tag=101;
    checkBtn2.hidden = YES;
    checkBtn2.titleLabel.font=[UIFont systemFontOfSize:12];
    [self.view addSubview:checkBtn2];
    checkBtn.frame=CGRectMake((kDeviceWidth-checkBtn.frame.size.width-checkBtn2.frame.size.width)/2, checkBtn.frame.origin.y, checkBtn.frame.size.width, checkBtn.frame.size.height);
    checkBtn2.frame=CGRectMake(checkBtn.frame.origin.x+checkBtn.frame.size.width, checkBtn.frame.origin.y, checkBtn2.frame.size.width, checkBtn2.frame.size.height);
    //
    //    UIButton  *qqButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //    qqButton.frame=CGRectMake(50, kDeviceHeight-220, kDeviceWidth-100, 40);
    //    [qqButton setBackgroundImage:[UIImage imageNamed:@"login_button_qq －in.png"] forState:UIControlStateNormal];
    //    [qqButton setBackgroundImage:[UIImage imageNamed:@"login_button_qq.png"] forState:UIControlStateHighlighted];
    //
    //    [qqButton addTarget:self action:@selector(dealloginClick:) forControlEvents:UIControlEventTouchUpInside];
    //    qqButton.tag=1000;
    //    //[self.view addSubview:qqButton];
    //
    weiboButton=[UIButton buttonWithType:UIButtonTypeCustom];
    weiboButton.frame=CGRectMake((kDeviceWidth-202)/2, kDeviceHeight-170, 202, 40);
    [weiboButton setBackgroundImage:[UIImage imageWithColor:VLight_GrayColor_apla] forState:UIControlStateHighlighted];
     [weiboButton setBackgroundImage:[UIImage imageWithColor:View_white_Color] forState:UIControlStateNormal];
    [weiboButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, -6)];
    [weiboButton setImage:[UIImage imageNamed:@"login_sina"] forState:UIControlStateNormal];
    [weiboButton setTitleColor:View_Black_Color forState:UIControlStateNormal];
    [weiboButton setTitle:@"微博登陆" forState:UIControlStateNormal];
    weiboButton.layer.cornerRadius = 4;
    weiboButton.titleLabel.font = [UIFont fontWithName:KFontThin size:14];
    weiboButton.layer.borderColor = VLight_GrayColor.CGColor;
    weiboButton.layer.borderWidth = 0.5;
    weiboButton.clipsToBounds = YES;

    [weiboButton addTarget:self action:@selector(dealloginClick:) forControlEvents:UIControlEventTouchUpInside];
    weiboButton.tag=1001;
    // weiboButton.userInteractionEnabled=NO;
    // if (checkBtn.selected==YES) {
    weiboButton.userInteractionEnabled=YES;
    //}
    [self.view addSubview:weiboButton];
    
    weiChateButton=[UIButton buttonWithType:UIButtonTypeCustom];
    weiChateButton.frame=CGRectMake((kDeviceWidth-202)/2, kDeviceHeight-120, 202, 40);
    [weiChateButton setBackgroundImage:[UIImage imageWithColor:VLight_GrayColor_apla] forState:UIControlStateHighlighted];
      [weiChateButton setBackgroundImage:[UIImage imageWithColor:View_white_Color] forState:UIControlStateNormal];
    [weiChateButton setImage:[UIImage imageNamed:@"login_wechat"] forState:UIControlStateNormal];
    [weiChateButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, -6)];
    [weiChateButton setTitleColor:View_Black_Color forState:UIControlStateNormal];
    [weiChateButton setTitle:@"微信登陆" forState:UIControlStateNormal];
    weiChateButton.layer.cornerRadius = 4;
    weiChateButton.titleLabel.font = [UIFont fontWithName:KFontThin size:14];
    weiChateButton.layer.borderColor = VLight_GrayColor.CGColor;
    weiChateButton.layer.borderWidth = 0.5;
    weiChateButton.clipsToBounds = YES;
    //if (checkBtn.selected==YES) {
    weiChateButton.userInteractionEnabled=YES;
    //}
    //[weiChateButton setTitle:@"登陆" forState:UIControlStateNormal];
    [weiChateButton addTarget:self action:@selector(dealloginClick:) forControlEvents:UIControlEventTouchUpInside];
    weiChateButton.tag=1002;
    [self.view addSubview:weiChateButton];
    //在
    //emaillogin
    UIButton  *emaillogin =[ZCControl createButtonWithFrame:CGRectMake(0, kDeviceHeight-50, kDeviceWidth/2, 50) ImageName:@"login_alpa_backgroundcolor.png" Target:self Action:@selector(dealloginClick:) Title:@"邮箱登陆"];
    emaillogin.tag=1003;
    emaillogin.hidden=YES;
    [emaillogin setBackgroundImage:[UIImage imageWithColor:View_ToolBar] forState:UIControlStateNormal];
    [emaillogin setTitleColor:VBlue_color forState:UIControlStateNormal];
    emaillogin.titleLabel.font=[UIFont fontWithName:KFontThin size:16];
    [emaillogin setTitleColor:View_Black_Color forState:UIControlStateNormal];
    [self.view addSubview:emaillogin];
    
    UIButton  *emailregister =[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth/2, kDeviceHeight-50, kDeviceWidth/2, 50) ImageName:@"login_alpa_backgroundcolor.png" Target:self Action:@selector(dealloginClick:) Title:@"邮箱注册"];
    emailregister.tag=1004;
    [emailregister setTitleColor:VBlue_color forState:UIControlStateNormal];
    emailregister.titleLabel.font=[UIFont fontWithName:KFontThin size:16];
    [emailregister setTitleColor:View_Black_Color forState:UIControlStateNormal];
    [emailregister setBackgroundImage:[UIImage imageWithColor:View_ToolBar] forState:UIControlStateNormal];
    emailregister.hidden=YES;
    [self.view addSubview:emailregister];
    //判断是否安装了微信
    if ([WXApi  isWXAppInstalled]==NO) {
        weiboButton.hidden=YES;
        weiChateButton.hidden=YES;
        checkBtn.hidden=YES;
        checkBtn2.hidden=YES;
        emaillogin.hidden=NO;
        emailregister.hidden=NO;
    }
}
//服务条款按钮
-(void)checkClick:(UIButton *) button
{
    if (button==checkBtn) {
        if (checkBtn.selected==YES) {
            weiboButton.userInteractionEnabled=NO;
            weiChateButton.userInteractionEnabled=NO;
            button.selected=NO;
        }
        else if (checkBtn.selected==NO)
        {
            weiChateButton.userInteractionEnabled=YES;
            weiboButton.userInteractionEnabled=YES;
            button.selected=YES;
        }
    }
    else if(button==checkBtn2)
    {
        
        [self.navigationController pushViewController:[SerViceViewController new] animated:YES];
    }
    
}
//登陆按钮
-(void)dealloginClick:(UIButton *) btn
{
    //    weiboButton.hidden=YES;
    //    weiChateButton.hidden=YES;
    //    checkBtn.hidden=YES;
    //    checkBtn2.hidden=YES;
    if (btn.tag==1000) {
        //qq  登陆
        //window.rootViewController=[CustmoTabBarController new];
        ssoName =UMShareToQzone;
        NSLog(@"  点击了登陆qq");
        [self loginSocialPlatformWithName];
    }
    else if (btn.tag==1001)
    {
        //微博登陆
        ssoName = UMShareToSina;
        NSLog(@"  点击了登陆sina");
        
        [self loginSocialPlatformWithName];
    }
    else if (btn.tag==1002)
    {
        ssoName=UMShareToWechatSession;
        [self loginSocialPlatformWithName];
    }
    else if(btn.tag==1003)
    {
        //      邮箱登陆
        BaseNavigationViewController  *na =[[BaseNavigationViewController alloc]initWithRootViewController:[Login2_1ViewController new]];
        [self presentViewController:na animated:YES completion:nil];
    }
    else if (btn.tag==1004)
    {
        //邮箱注册
        BaseNavigationViewController  *na =[[BaseNavigationViewController alloc]initWithRootViewController:[Register_1ViewController new]];
        [self presentViewController:na animated:YES completion:nil];
    }
}
/**
 *  用SOS登录
 */
- (void)loginSocialPlatformWithName
{
    [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:ssoName];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [[UMSocialDataService defaultDataService] requestSnsInformation:ssoName completion:^(UMSocialResponseEntity *response) {
                if (response.responseCode == UMSResponseCodeSuccess) {
                    weiboButton.hidden=YES;
                    weiChateButton.hidden=YES;
                    checkBtn.hidden=YES;
                    checkBtn2.hidden=YES;
                    NSDictionary *data = [response valueForKey:@"data"];
                    //openid
                    NSString  *openid;
                    if ([ssoName isEqualToString:UMShareToSina]) {
                        openid   = [data valueForKey:@"uid"];
                    }
                    else{
                        openid =[data valueForKey:@"openid"];
                    }
                    //token
                    NSString *access_token   = [data valueForKey:@"access_token"];
                    //username
                    NSString *screen_name    = [data valueForKey:@"screen_name"];
                    //brief
                    NSString *brief=@" ";
                    if ([ssoName isEqualToString:UMShareToSina]) {
                        brief= [data valueForKey:@"description"];
                    }
                    //sex
                    NSString  *sex=[data objectForKey:@"gender"];
                    NSString  *verified=@"0";
                    NSString *bingdtype=ssoName;
                    //logo
                    NSString  *logo=[data objectForKey:@"profile_image_url"];
                    NSString *urlString = [NSString stringWithFormat:@"%@/user/login", kApiBaseUrl];
                    NSString *tokenString = [Function getURLtokenWithURLString:urlString];
                    NSDictionary  *parameters=@{@"openid":openid,@"token":access_token,@"username":screen_name,@"brief":brief,@"sex":sex,@"verified":verified,@"bindtype":bingdtype,@"logo":logo,KURLTOKEN:tokenString};
                    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSLog(@"登陆完成后的     JSON: %@", responseObject);
                        
                        UserDataCenter  *userCenter=[UserDataCenter shareInstance];
                        userCenter.first_login=[responseObject objectForKey:@"first_login"];
                        NSDictionary *detail    = [responseObject objectForKey:@"model"];
                        if (detail) {
                            userCenter.user_id=[detail objectForKey:@"id"];
                            userCenter.username=[detail objectForKey:@"username"];
                            userCenter.logo =[detail objectForKey:@"logo"];
                            userCenter.is_admin =[detail objectForKey:@"role_id"];
                            userCenter.verified=[detail objectForKey:@"verified"];
                            userCenter.sex=[detail objectForKey:@"sex"];
                            userCenter.signature=[detail objectForKey:@"brief"];
                            userCenter.fake=@"1";
                            if ([detail objectForKey:@"fake"]) {
                                userCenter.fake=[detail objectForKey:@"fake"];
                            }
                            [Function saveUser:userCenter];
                            window.rootViewController=[CustomController new];
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Error: %@", error);
                    }];
                } else {
                    // [self dealErrorCase];
                    //强行登陆
                    [SVProgressHUD showErrorWithStatus:@"登陆失败"];
                }
            }];
        } else {
            //[self dealErrorCase];
            [SVProgressHUD showErrorWithStatus:@"登陆失败"];
        }
    });
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
