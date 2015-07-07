//
//  WordDetailVC.m
//  Card_iOS
//
//  Created by 朱封毅 on 03/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "WordDetailVC.h"
#import "ZCControl.h"
#import "SelectTimeView.h"
#import "Constant.h"
#import "AFNetworking.h"
#import "UserDataCenter.h"
#import "Function.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "UserButton.h"
#import "LikeButton.h"
#import "UIButton+Block.h"
@implementation WordDetailVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor  =[UIColor whiteColor];
    self.myScrollerView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kHeightNavigation-BUTTON_HEIGHT)];
    self.myScrollerView.contentSize=CGSizeMake(kDeviceWidth, kDeviceHeight);
    [self.view addSubview:self.myScrollerView];
    
    self.comView = [[CommonView alloc]initWithFrame:CGRectMake(10, 10, kDeviceWidth-20, kDeviceWidth-20)];
    [self.myScrollerView addSubview:self.comView];
    self.comView.isLongWord = YES;
    [self.comView configCommonView:self.model];
    
    
    //UserDataCenter *user = [UserDataCenter shareInstance];
    //if ([user.is_admin intValue]>0) {
        [self createToolBar];
   // }else
    //{
        
    //}
    UIView *likeBar = [[UIView alloc]initWithFrame:CGRectMake(0, self.comView.frame.origin.y+self.comView.frame.size.height+10, kDeviceWidth, 40)];
    likeBar.userInteractionEnabled = YES;
    [self.myScrollerView addSubview:likeBar];
    
    UserButton *userbtn = [[UserButton alloc]initWithFrame:CGRectMake(10,0, 200, 30)];
    NSURL  *usrl =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kUrlAvatar,self.model.userInfo.logo]];
    [userbtn addActionHandler:^(NSInteger tag) {
        
    }];
    [userbtn.headImage sd_setImageWithURL:usrl placeholderImage:HeadImagePlaceholder];
    userbtn.titleLab.text= self.model.userInfo.username;
    [likeBar addSubview:userbtn];
    
    LikeButton  *likeBtn = [[LikeButton alloc]initWithFrame:CGRectMake(kDeviceWidth-110, 0,100, 30)];
    [likeBtn addActionHandler:^(NSInteger tag) {
        
    }];
    [likeBar addSubview:likeBtn];
}
-(void)createUserBar
{
    
}
-(void)createToolBar
{
    AdimToolBar *tool =[[AdimToolBar alloc]initWithFrame:CGRectMake(0, kDeviceHeight-BUTTON_HEIGHT-kHeightNavigation, kDeviceWidth, BUTTON_HEIGHT)];
    tool.delegate = self;
    [self.view addSubview:tool];
    
}
-(void)handOperationAtIndex:(NSInteger)index
{
    if (index==0) {
        //屏蔽
        [self requestChangeStageStatusWithweiboId:self.model.Id StatusType:@"0"];
    }else if(index==1)
    {
        //最新
        [self requestChangeStageStatusWithweiboId:self.model.Id StatusType:@"5"];
        
        
    }else if(index==2)
    {
        //正常
        [self requestChangeStageStatusWithweiboId:self.model.Id StatusType:@"1"];
        
    }else if(index==3)
    {
        //发现
        [self requestChangeStageStatusWithweiboId:self.model.Id StatusType:@"2"];
        
    }else if(index==4)
    {
        SelectTimeView *piker =[[SelectTimeView alloc]init];
        piker.delegate = self;
        [piker show];
    }
    
}
//定时发送到热门,发送时间戳
-(void)requesttiming:(NSString *)model_id AndTimeSp:(NSString *)timeSp
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString =[NSString stringWithFormat:@"%@text/change-status", kApiBaseUrl];
    NSString *tokenString =[Function getURLtokenWithURLString:urlString];
    NSDictionary *parameters=@{@"user_id":@"18",@"prod_id":model_id,@"status":@"3",@"updated_at":timeSp,KURLTOKEN:tokenString};
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSString *titSting  =[NSString stringWithFormat:@"定时到热门成功"];
            [SVProgressHUD showSuccessWithStatus:titSting maskType:SVProgressHUDMaskTypeNone];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"操作失败"];
        
        
    }];
}
//status 0 屏蔽 1 正常 2 发现/电影页 3 热门 只有到热门页的时候需要传updated_at 5 未审核
-(void)requestChangeStageStatusWithweiboId:(NSString *)word_id StatusType:(NSString *) status
{
    
    //UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString  *urlString =[NSString stringWithFormat:@"%@text/change-status", kApiBaseUrl];
    NSString *tokenString =[Function getURLtokenWithURLString:urlString];
    
    NSDictionary *parameters=@{@"user_id":@"18",@"prod_id":word_id,@"status":status,KURLTOKEN:tokenString};
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSString  *titleString ;
            if ([status intValue]==0) {
                titleString =[NSString stringWithFormat:@"屏蔽成功"];
            }else if ([status intValue]==1)
            {
                titleString=[NSString stringWithFormat:@"移到正常成功"];
            }else if ([status intValue]==2)
            {
                titleString= [NSString stringWithFormat:@"移到发现成功"];
            }else if ([status  intValue]==3)
            {
                titleString  = [NSString stringWithFormat:@"移到热门成功"];
            }
            else if([status intValue]==5)
            {
                titleString =[NSString stringWithFormat:@"发布到最新成功"];
            }
            [SVProgressHUD showSuccessWithStatus:titleString maskType:SVProgressHUDMaskTypeNone];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"操作失败"];
    }];
}

#pragma mark  selected date time
-(void)DatePickerSelectedTime:(NSString *)dateString    {
    //定时到热门，伴随时间戳
    [self requesttiming:self.model.Id AndTimeSp:dateString];
}


@end
