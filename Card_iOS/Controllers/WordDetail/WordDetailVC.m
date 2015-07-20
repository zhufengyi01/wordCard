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
#import "LikeModel.h"
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
    self.myScrollerView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kHeightNavigation)];
    self.myScrollerView.contentSize=CGSizeMake(kDeviceWidth, kDeviceHeight+20);
    [self.view addSubview:self.myScrollerView];
    
    self.comView = [[CommonView alloc]initWithFrame:CGRectMake(10, 10, kDeviceWidth-20, kDeviceWidth-20)];
    [self.myScrollerView addSubview:self.comView];
    self.comView.isLongWord = YES;
    [self.comView configCommonView:self.model];
    if (self.comView.frame.size.height>kDeviceHeight) {
        self.myScrollerView.contentSize = CGSizeMake(kDeviceWidth,self.comView.frame.size.height+100);
    }
    UIView *likeBar = [[UIView alloc]initWithFrame:CGRectMake(0, self.comView.frame.origin.y+self.comView.frame.size.height+10, kDeviceWidth, 40)];
    likeBar.userInteractionEnabled = YES;
    [self.myScrollerView addSubview:likeBar];
    // 点击进入个人页
    UserButton *userbtn = [[UserButton alloc]initWithFrame:CGRectMake(10,0, 200, 30)];
    NSURL  *usrl =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kUrlAvatar,self.model.userInfo.logo]];
    [userbtn addActionHandler:^(NSInteger tag) {
        
    }];
    [userbtn.headImage sd_setImageWithURL:usrl placeholderImage:nil];
    userbtn.titleLab.text= self.model.userInfo.username;
    [likeBar addSubview:userbtn];
    // 点赞
    LikeButton  *likeBtn = [[LikeButton alloc]initWithFrame:CGRectMake(kDeviceWidth-110, 0,100, 30)];
    for (int i=0;i<self.likeArray.count; i++) {
        LikeModel *model = self.likeArray[i];
        if ([model.prod_id intValue]==[self.model.Id intValue]) {
            likeBtn.selected =YES;
            likeBtn.likeImage.image = [UIImage imageNamed:@"detail_liked"];
        }
    }
    if ([self.model.liked_count intValue]>0) {
        likeBtn.likeCountLbl.text = self.model.liked_count;
    }else {
        likeBtn.likeCountLbl.text = @"喜欢";
    }
    __weak typeof(LikeButton)  *weakbtn = likeBtn;
    [likeBtn addActionHandler:^(NSInteger tag) {
        if (likeBtn.selected ==YES) {
            //取消点赞
            weakbtn.selected = NO;
            NSInteger  count = [weakbtn.likeCountLbl.text integerValue];
            count=count-1;
            if (count>0) {
                weakbtn.likeCountLbl.text = [NSString stringWithFormat:@"%ld",(long)count];
            }else {
                weakbtn.likeCountLbl.text = [NSString stringWithFormat:@"点赞"];
            }
            weakbtn.likeImage.image = [UIImage imageNamed:@"detail_like"];
            for (int i=0; i<self.likeArray.count; i++) {
                LikeModel *model = self.likeArray[i];
                if ([model.prod_id intValue] == [self.model.Id intValue]) {
                    [self.likeArray removeObject:model];
                    break;
                }
            }
            // 修改self.model 的数据
            NSInteger lcount = [self.model.liked_count integerValue];
            lcount = lcount-1;
            self.model.liked_count = [NSString stringWithFormat:@"%ld",(long)lcount];
            if (self.model.userInfo == nil) {
                UserModel *usr=[UserModel new];
                usr.Id = @"4";
                self.model.userInfo = usr;
            }
            [self requestLikeWithAuthorId:self.model.userInfo.Id andoperation:@0];
        }else
        {
            [Function BasicAnimationwithkey:@"transform.scale" Duration:0.25 repeatcont:1 autoresverses:YES fromValue:1.0 toValue:1.5 View:weakbtn.likeImage];
            //点赞
            weakbtn.selected =YES;
            NSInteger  count = [weakbtn.likeCountLbl.text integerValue];
            count=count+1;
            weakbtn.likeCountLbl.text = [NSString stringWithFormat:@"%ld",(long)count];
            weakbtn.likeImage.image = [UIImage imageNamed:@"detail_liked"];
            LikeModel *lm = [LikeModel new];
            lm.prod_id = self.model.Id;
            if (!self.likeArray) {
                self.likeArray = [NSMutableArray array];
            }
            [self.likeArray addObject:lm];
            NSInteger lcount = [self.model.liked_count integerValue];
            lcount = lcount+1;
            self.model.liked_count = [NSString stringWithFormat:@"%ld",(long)lcount];
            if (self.model.userInfo == nil) {
                UserModel *usr=[UserModel new];
                usr.Id = @"4";
                self.model.userInfo = usr;
            }
            [self requestLikeWithAuthorId:self.model.userInfo.Id andoperation:@1];
        }
        
    }];
    
    [likeBar addSubview:likeBtn];
}
#pragma mark --requset Method
-(void)requestLikeWithAuthorId:(NSString *)autuor_id andoperation:(NSNumber *) operation
{
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    NSString *urlString = [NSString stringWithFormat:@"%@/text/up", kApiBaseUrl];
    NSString *tokenString =[Function getURLtokenWithURLString:urlString];
    NSDictionary *parameters=@{@"prod_id":self.model.Id,@"user_id":userCenter.user_id,@"author_id":autuor_id,@"operation":operation,KURLTOKEN:tokenString};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSString *status=@"sucess";
            [SVProgressHUD showSuccessWithStatus:status];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showSuccessWithStatus:@"操作失败"];
    }];
}
@end
