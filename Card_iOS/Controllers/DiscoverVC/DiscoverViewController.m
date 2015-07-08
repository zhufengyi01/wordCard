//
//  DiscoverViewController.m
//  Card_iOS
//
//  Created by 朱封毅 on 07/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "DiscoverViewController.h"
#import "ZCControl.h"
#import "UserDataCenter.h"
#import "Function.h"
#import "AFNetworking.h"
#import "Constant.h"
#import "UIButton+Block.h"
#import "UIImage+Color.h"
#import "SVProgressHUD.h"
#import "TagModel.h"
#import "UserButton.h"
#import "UserButton.h"
#import "UIImageView+WebCache.h"
float const  LIKE_BAR_HEIGHT = 50;
@implementation DiscoverViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发现";
    self.model = [CommonModel new];
    self.currentIndex = 0;
    self.dataArray = [NSMutableArray array];
    [self createLeftNavigationItem:nil Title:@"取消"];
    [self requestData];
    self.myScrollerView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kHeightNavigation-BUTTON_HEIGHT)];
    self.myScrollerView.contentSize=CGSizeMake(kDeviceWidth, kDeviceHeight);
    [self.view addSubview:self.myScrollerView];
    
    self.comView = [[CommonView alloc]initWithFrame:CGRectMake(10, 10, kDeviceWidth-20, kDeviceWidth-20)];
    [self.myScrollerView addSubview:self.comView];
    [self createLikeBar];
    //[self createUserBar];
    
}
-(void)LeftNavigationButtonClick:(UIButton *)leftbtn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark --RequestData Method
-(void)requestlikeWithOperation:(NSString *) oper
{
    if ([oper isEqualToString:@"1"]) {
        [SVProgressHUD showSuccessWithStatus:@"click like"];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"click dislike"];
    }
    
}
-(void)requestData
{
    [SVProgressHUD show];
    UserDataCenter  *user = [UserDataCenter shareInstance];
    AFHTTPRequestOperationManager  *manager =[AFHTTPRequestOperationManager manager];
    NSString *url =[NSString stringWithFormat:@"%@text/discover",kApiBaseUrl];
    NSString *apitoken=[Function getURLtokenWithURLString:url];
    NSDictionary  *parameters= @{@"user_id":user.user_id,KURLTOKEN:apitoken};
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject objectForKey:@"code"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            NSMutableArray *array =[responseObject objectForKey:@"models"];
            if (array.count>0) {
                for (int i=0; i<array.count; i++) {
                    NSDictionary  *commondict =[array objectAtIndex:i];
                    if (![commondict isKindOfClass:[NSNull class]]) {
                        CommonModel *model =[[CommonModel alloc] init];
                        [model setValuesForKeysWithDictionary:commondict];
                        //创建user
                        UserModel *usermodel =[[UserModel alloc]init];
                        if (![[commondict objectForKey:@"user"] isKindOfClass:[NSNull class]]) {
                            [usermodel setValuesForKeysWithDictionary:[commondict objectForKey:@"user"]];
                            model.userInfo = usermodel;
                        }
                        NSMutableArray *tagArray =[[NSMutableArray alloc]init];
                        if (![[commondict objectForKey:@"tags"] isKindOfClass:[NSNull class]]) {
                            NSArray *tagarr =[commondict objectForKey:@"tags"];
                            for (int i=0; i<tagarr.count; i++) {
                                NSDictionary *tagdict =[tagarr objectAtIndex:i];
                                TagModel *tagmodel =[[TagModel alloc]init];
                                [tagmodel setValuesForKeysWithDictionary:tagdict];
                                [tagArray addObject:tagmodel];
                            }
                        }
                        if (self.dataArray==nil) {
                            self.dataArray =[NSMutableArray array];
                        }
                        [self.dataArray addObject:model];
                    }
                }
            }else
            {
                [SVProgressHUD showInfoWithStatus:@"没有数据"];
            }
            NSMutableArray  *likearr = [responseObject objectForKey:@"ups"];
            ///if (likearr.count>0) {
            for (int i=0; i<likearr.count; i++) {
                LikeModel *likemodel = [LikeModel new];
                [likemodel setValuesForKeysWithDictionary:[likearr objectAtIndex:i]];
                if (self.likeArray==nil) {
                    self.likeArray = [NSMutableArray array];
                }
                [self.likeArray addObject:likemodel];
            }
            [self configComentView];
            //}
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //数据加载失败
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}
-(void) configComentView
{
    if (self.dataArray.count>self.currentIndex) {
        self.model = self.dataArray[self.currentIndex];
    }
    self.comView.isLongWord = YES;
    [self.comView configCommonView:self.model];
    [self createUserBar];
}
-(void)createLikeBar
{
    UIView *_toolView =[[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-LIKE_BAR_HEIGHT-kHeightNavigation,kDeviceWidth, LIKE_BAR_HEIGHT)];
    _toolView.userInteractionEnabled =YES;
    [self.view addSubview:_toolView];
    
    UIButton  *btn1 =[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame=CGRectMake(0, 0, kDeviceWidth/2, LIKE_BAR_HEIGHT);
    [btn1 setTitle:@"喜欢" forState:UIControlStateNormal];
    [btn1 setBackgroundImage:[UIImage imageWithColor:View_ToolBar] forState:UIControlStateNormal];
    [btn1 setBackgroundImage:[UIImage imageWithColor:VLight_GrayColor] forState:UIControlStateHighlighted];
    [btn1 setTitleColor:VGray_color forState:UIControlStateNormal];
    btn1.tag=99;
    [btn1 addActionHandler:^(NSInteger tag) {
        if (self.dataArray.count>self.currentIndex) {
            self.currentIndex++;
            if (self.dataArray.count>self.currentIndex) {
                self.model = self.dataArray[self.currentIndex];
                [self requestlikeWithOperation:@"1"];
                [self configComentView];
            }
            else{
                [SVProgressHUD showInfoWithStatus:@"看完了..."];
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:@"看完了..."];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forState:UIControlStateNormal];
    btn1.backgroundColor=[UIColor whiteColor];
    [_toolView addSubview:btn1];
    UIButton  *btn2 =[UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame=CGRectMake(kDeviceWidth/2, 0, kDeviceWidth/2, LIKE_BAR_HEIGHT);
    [btn2 setTitle:@"没感觉" forState:UIControlStateNormal];
    [btn2 setBackgroundImage:[UIImage imageWithColor:View_ToolBar] forState:UIControlStateNormal];
    [btn2 setBackgroundImage:[UIImage imageWithColor:VLight_GrayColor] forState:UIControlStateHighlighted];
    btn2.tag=100;
    [btn2 addActionHandler:^(NSInteger tag) {
        if (self.dataArray.count>self.currentIndex) {
            self.currentIndex++;
            if (self.dataArray.count>self.currentIndex) {
                self.model = self.dataArray[self.currentIndex];
                [self requestlikeWithOperation:@"0"];
                [self configComentView];
            }else{
                
                [SVProgressHUD showInfoWithStatus:@"看完了..."];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:@"看完了..."];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    [btn2 setTitleColor:VGray_color forState:UIControlStateNormal];
    btn2.backgroundColor=[UIColor whiteColor];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forState:UIControlStateNormal];
    [_toolView addSubview:btn2];
    
    //添加一个线
    UIView  *verline =[[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth/2,12, 0.5, 26)];
    verline.backgroundColor =VLight_GrayColor;
    [_toolView addSubview:verline];
}

-(void)createUserBar
{
    if (self.likeBar) {
        [self.likeBar removeFromSuperview];
        self.likeBar = nil;
    }
    self.likeBar = [[UIView alloc]initWithFrame:CGRectMake(0, self.comView.frame.origin.y+self.comView.frame.size.height+10, kDeviceWidth, 40)];
    self.likeBar.userInteractionEnabled = YES;
    [self.myScrollerView addSubview:self.likeBar];
    // 点击进入个人页
    UserButton *userbtn = [[UserButton alloc]initWithFrame:CGRectMake(10,0, 200, 30)];
    NSURL  *usrl =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kUrlAvatar,self.model.userInfo.logo]];
    [userbtn addActionHandler:^(NSInteger tag) {
        
    }];
    [userbtn.headImage sd_setImageWithURL:usrl placeholderImage:HeadImagePlaceholder];
    userbtn.titleLab.text= self.model.userInfo.username;
    [self.likeBar addSubview:userbtn];

    
}
@end