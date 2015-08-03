//
//  WordSearchViewController.m
//  Card_iOS
//
//  Created by 朱封毅 on 13/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "WordSearchViewController.h"
#import "SVProgressHUD.h"
#import "ZCControl.h"
#import "Constant.h"
#import "Function.h"
#import "CommonModel.h"
#import "TagModel.h"
#import "LikeModel.h"
#import "AFNetworking.h"
#import "GCD.h"
@implementation WordSearchViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [SVProgressHUD dismiss];
    UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItem=item;
    self.tabbleView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kHeightNavigation);
    //[self createLeftNavigationItem:nil Title:nil];
    self.statusLable.text =@"";
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(10, 0,kDeviceWidth-40, 30)];
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.placeholder = @"请输入搜索内容";
    //self.searchBar.showsCancelButton = YES;
    self.searchBar.delegate = self;
    [self.searchBar becomeFirstResponder];
    self.navigationItem.titleView = self.searchBar;
    [self creatRightNavigationItem:nil Title:@"取消"];
}
-(void)RightNavigationButtonClick:(UIButton *)rightbtn
{
   // [self.navigationController popViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)requestData
{
    [SVProgressHUD show];
    [self.temArr removeAllObjects];
    NSString *urlString  = [NSString stringWithFormat:@"%@text/search",kApiBaseUrl];
    NSString *tokenString = [Function getURLtokenWithURLString:urlString];
    NSDictionary  *dict = @{@"keyword":self.searchBar.text,KURLTOKEN:tokenString};
    AFHTTPRequestOperationManager  *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue]==0) {
            [SVProgressHUD dismiss];
            NSMutableArray *array =[responseObject objectForKey:@"models"];
            if (array.count>0) {
                self.statusLable.text = @"THE - END";
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
                        model.tagArray = tagArray;
                        if (!self.temArr) {
                            self.temArr =[NSMutableArray array];
                        }
                        [self.temArr addObject:model];
                        [self computeRecomendSectionView:self.temArr];
                    }
                }
                [self.tabbleView reloadData];
                [self.refreshControl endRefreshing];
            }else
            {
                [self.dataAraray removeAllObjects];
                self.statusLable.text = @"没有数据";
                [GCDQueue  executeInMainQueue:^{
                    [SVProgressHUD showInfoWithStatus:@"没有数据"];
                    [self.temArr removeAllObjects];
                    [self.tabbleView reloadData];
                    //数据为空
                    [self.refreshControl endRefreshing];
                }];
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
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error ====%@",error);
        [self.tabbleView reloadData];
        
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}
-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self requestData];
    [self.searchBar resignFirstResponder];
}
@end
