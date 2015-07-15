//
//  NoticeViewController.m
//  Card_iOS
//
//  Created by 朱封毅 on 07/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "NoticeViewController.h"
#import "ZCControl.h"
#import "Constant.h"
#import "Function.h"
#import "AFNetworking.h"
#import "UserDataCenter.h"
#import "NotiModel.h"
#import "TextModel.h"
#import "SVProgressHUD.h"
#import "TagModel.h"
#import "NotifiCell.h"
#import "UserModel.h"
#import "ZFYLoading.h"
#import "UIImage+Color.h"
@implementation NoticeViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}
-(instancetype)init
{
    if ( self = [super init]) {
        // self.urlString = @"noti-up/list";
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"消息";
    self.tabbleView.frame = CGRectMake(0,0, kDeviceWidth, kDeviceHeight-kHeightNavigation-kHeigthTabBar);
    //self.tabbleView.rowHeight = 70;
    [self requestData];
}
//-(void)RefreshViewControlEventValueChanged
//{
//    self.page=1;
//    [self.dataArray removeAllObjects];
//    [self requestData];
//}
-(void)requestData
{
    UserDataCenter *user = [UserDataCenter shareInstance];
    NSString  *urlString  = [NSString stringWithFormat:@"%@noti-up/list",kApiBaseUrl];
    NSString *tokenString = [Function getURLtokenWithURLString:urlString];
    NSDictionary  *paremetes =@{@"user_id":user.user_id,KURLTOKEN:tokenString};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager  POST:urlString parameters:paremetes success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if ([[responseObject objectForKey:@"code"] intValue]==0) {
            NSArray *array = [responseObject objectForKey:@"models"];
            self.pageCount =[[responseObject objectForKey:@"pageCount"] integerValue];
            if (array.count>0) {
                for (NSDictionary *dict in array) {
                    NotiModel  *model = [NotiModel new];
                    if (dict) {
                        [model setValuesForKeysWithDictionary:dict];
                        TextModel *text = [TextModel new];
                        if (![[dict objectForKey:@"text"] isKindOfClass:[NSNull class]]) {
                            [text setValuesForKeysWithDictionary:[dict objectForKey:@"text"]];
                            UserModel *user = [UserModel new];
                            if ([[dict objectForKey:@"text"] objectForKey:@"user"]) {
                                [user setValuesForKeysWithDictionary:[[dict objectForKey:@"text"] objectForKey:@"user"]];
                                text.userInfo = user;
                            }
                            NSMutableArray *tagArray =[[NSMutableArray alloc]init];
                            if (![[dict objectForKey:@"tags"] isKindOfClass:[NSNull class]]) {
                                NSArray *tagarr =[dict objectForKey:@"tags"];
                                for (int i=0; i<tagarr.count; i++) {
                                    NSDictionary *tagdict =[tagarr objectAtIndex:i];
                                    TagModel *tagmodel =[[TagModel alloc]init];
                                    [tagmodel setValuesForKeysWithDictionary:tagdict];
                                    [tagArray addObject:tagmodel];
                                }
                            }
                            text.TagArray= tagArray;
                            model.textInfo = text;
                        }
                        UserModel  *ouser  = [UserModel new];
                        if (![[dict objectForKey:@"user"] isKindOfClass:[NSNull class]]) {
                            [ouser setValuesForKeysWithDictionary:[dict objectForKey:@"user"]];
                            model.OuserInfo= ouser;
                        }
                    }
                    if (self.dataArray==nil) {
                        self.dataArray = [NSMutableArray array];
                    }
                    [self.refreshControl endRefreshing];
                    [self.dataArray addObject:model];
                    [self.tabbleView reloadData];
                }
            }else {
                [ZFYLoading showNullWithstatus:@"没有数据..." inView:self.tabbleView];
                [SVProgressHUD showInfoWithStatus:@"没有数据"];
                [self.refreshControl endRefreshing];
            }
        }
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.refreshControl endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        [ZFYLoading showFailWithstatus:@"加载失败" inView:self.tabbleView event:^(UIButton *sender) {
            
        }];
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId =@"CELL";
    NotifiCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell =[[NotifiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    if (self.dataArray.count>indexPath.row) {
        NotiModel *model =self.dataArray[indexPath.row];
        cell.notimodel = model;
        [cell configcell];
        cell.handEvent=^(NSInteger index)
        {
            
        };
    }
    return cell;
}
-(void)tableviewDisplayIndexpath:(NSIndexPath *)indexpath
{
    if (self.pageCount>self.page&&self.dataArray.count==indexpath.row+1) {
        self.page++;
        [self requestData];
    }
    
}
@end
