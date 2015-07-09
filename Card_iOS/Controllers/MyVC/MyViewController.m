//
//  MyViewController.m
//  Card_iOS
//
//  Created by 朱封毅 on 02/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "MyViewController.h"
#import "SettingViewController.h"
#import "ZCControl.h"
#import "Constant.h"
#import "UserDataCenter.h"
#import "UIImageView+WebCache.h"
#import "Function.h"
#import "AFNetworking.h"
#import "UIButton+Block.h"
#import "SVProgressHUD.h"
#import "UIImage+Color.h"
const float segmentheight = 45;
@implementation MyViewController

-(instancetype)init
{
    if (self =  [super init]) {
        // self.urlString = @"text/list-by-user-id";
        page1 = 1;
        page2 = 1;
        pageCount1 =1;
        pageConut2 =1;
        self.dataArray1 = [NSMutableArray array];
        self.dataArray2 = [NSMutableArray array];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title  = @"我的";
    [self creatRightNavigationItem:nil Title:@"设置"];
    self.tabbleView.frame=CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kHeigthTabBar-kHeightNavigation);
    [self createHeaderView];
    [self requestUserInfo];
    // [self requestData];
}
-(void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    [self.navigationController pushViewController:[SettingViewController new] animated:YES];
}
-(void)RefreshViewControlEventValueChanged
{
    if (self.addWordbtn.selected ==YES) {
        [self.dataArray1 removeAllObjects];
    }else {
        [self.dataArray2 removeAllObjects];
    }
    
}
-(void)createHeaderView
{
    UserDataCenter  *User = [UserDataCenter shareInstance];
    UIView  *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 160)];
    headView.backgroundColor = VBlue_color;
    [self.tabbleView setTableHeaderView:headView];
    //头像
    headImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 40, 40)];
    headImage.layer.cornerRadius = 20;
    headImage.image = HeadImagePlaceholder;
    headImage.clipsToBounds = YES;
    [headView addSubview:headImage];
    //名字
    namelbl = [ZCControl createLabelWithFrame:CGRectMake(headImage.frame.origin.x+headImage.frame.size.width+10, headImage.frame.origin.y, 120, 20) Font:16 Text:@"头像"];
    namelbl.textColor = VGray_color;
    [headView addSubview:namelbl];
    contentlbl = [ZCControl createLabelWithFrame:CGRectMake(namelbl.frame.origin.x, namelbl.frame.origin.y+namelbl.frame.size.height+10, 180, 20) Font:14 Text:@"内容"];
    contentlbl.textColor = VGray_color;
    [headView addSubview:contentlbl];
    
    describelbl = [ZCControl createLabelWithFrame:CGRectMake(namelbl.frame.origin.x, contentlbl.frame.origin.y+contentlbl.frame.size.height+10, 120, 20) Font:14 Text:@"内容"];
    describelbl.textColor = VGray_color;
    [headView addSubview:describelbl];
    
    ///添加
    self.addWordbtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addWordbtn.frame = CGRectMake(0, headView.frame.size.height-segmentheight, kDeviceWidth/2, segmentheight);
    [self.addWordbtn setTitle:@"添加" forState:UIControlStateNormal];
    self.addWordbtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.addWordbtn setTitleColor:VGray_color forState:UIControlStateNormal];
    [self.addWordbtn setTitleColor:VBlue_color forState:UIControlStateSelected];
    [self.addWordbtn setTitleColor:VBlue_color forState:UIControlStateHighlighted];
    self.addWordbtn.selected = YES;
    [self.addWordbtn setBackgroundImage:[UIImage imageWithColor:View_BackGround] forState:UIControlStateNormal];
    __weak typeof(self) weakself = self;
    [self.addWordbtn addActionHandler:^(NSInteger tag) {
        if (weakself.addWordbtn.selected ==NO) {
            weakself.addWordbtn.selected =YES;
            weakself.likeWorkbtn.selected = NO;
        }
    }];
    [headView addSubview:self.addWordbtn];
    //喜欢
    self.likeWorkbtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    self.likeWorkbtn.frame = CGRectMake(kDeviceWidth/2, headView.frame.size.height-segmentheight, kDeviceWidth/2, segmentheight);
    self.likeWorkbtn.selected = NO;
    [self.likeWorkbtn setTitle:@"喜欢" forState:UIControlStateNormal];
    self.likeWorkbtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.likeWorkbtn setTitleColor:VGray_color forState:UIControlStateNormal];
    [self.likeWorkbtn setTitleColor:VBlue_color forState:UIControlStateHighlighted];
    [self.likeWorkbtn setTitleColor:VBlue_color forState:UIControlStateSelected];
    [self.likeWorkbtn setBackgroundImage:[UIImage imageWithColor:View_BackGround] forState:UIControlStateNormal];
    [self.likeWorkbtn addActionHandler:^(NSInteger tag) {
        if (weakself.likeWorkbtn.selected ==NO) {
            weakself.likeWorkbtn.selected =YES;
            weakself.addWordbtn.selected = NO;
        }
    }];
    [headView addSubview:self.likeWorkbtn];
    if (self.pageType ==MyViewControllerPageTypeDefault) {
        NSURL  *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kUrlAvatar,User.logo]];
        [headImage sd_setImageWithURL:url placeholderImage:HeadImagePlaceholder];
        namelbl.text = User.username;
        //NSString  *contentString = [NSString stringWithFormat:@"内容:%@ 被赞:%@",User.product_count,User.like_count];
    }
}
//用户数据
-(void)requestUserInfo
{
    UserDataCenter *User = [UserDataCenter shareInstance];
    NSString *uid;
    if (!self.author_Id) {
        uid = User.user_id;
    }else{
        uid =self.author_Id;
    }
    AFHTTPRequestOperationManager  *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString  = [NSString stringWithFormat:@"%@user/info",kApiBaseUrl];
    NSString *tokenString = [Function getURLtokenWithURLString:urlString];
    NSDictionary  *dict = @{@"user_id":@"4",KURLTOKEN:tokenString};
    [manager POST:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject objectForKey:@"code"]) {
            if (!self.author_Id) {
                User.product_count = [responseObject objectForKey:@"prod_count"];
                User.like_count    = [responseObject objectForKey:@"liked_count"];
                NSString *content = [NSString stringWithFormat:@"内容:%@  点赞:%@",User.product_count,User.like_count];
                //NSMutableAttributedString  *Attribute = [[NSMutableAttributedString alloc] initWithString:content];
                NSURL  *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kUrlAvatar,User.logo]];
                [headImage sd_setImageWithURL:url placeholderImage:HeadImagePlaceholder];
                namelbl.text = User.username;
                contentlbl.text = content;
                describelbl.text = User.signature;
            }else {
                NSString *pr_d = [responseObject objectForKey:@"prod_count"];
                NSString *li_d = [responseObject objectForKey:@"liked_count"];
                NSString *content = [NSString stringWithFormat:@"内容:%@  点赞:%@",pr_d,li_d];
                //NSMutableAttributedString  *Attribute = [[NSMutableAttributedString alloc] initWithString:content];
                NSURL  *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kUrlAvatar,User.logo]];
                [headImage sd_setImageWithURL:url placeholderImage:HeadImagePlaceholder];
                namelbl.text = User.username;
                contentlbl.text = content;
                describelbl.text = User.signature;

            }
        }else
        {
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.f;
}
@end
