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
#import "UIView+ICExtension.h"
#import "MyViewController.h"
#import "UIButton+Block.h"
const float  NavViewHeight =  45;
@interface NoticeViewController ()
{
    
}
/*
 喜欢按钮
 */
@property(nonatomic,strong) UIButton *likedBtn;
/*
 点赞按钮
 */
@property(nonatomic,strong) UIButton *commentBtn;
/*
 2个像素的指示器
 */
@property(nonatomic,strong) UIView   *IndicatorView;

/*
 
 */
@property(nonatomic,strong)NSMutableArray *dataArray2;

@property(nonatomic,assign)NSInteger       pageCount2;

@property(nonatomic,assign)NSInteger       page2;

@end
@implementation NoticeViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}
-(instancetype)init
{
    if ( self = [super init]) {
        self.dataArray2 = [NSMutableArray array];
        self.pageCount2 = 20;
        self.page2 = 1;
    }
    return self;
}
#pragma  mark -getter method
-(UIButton *)likedBtn
{
    if (_likedBtn==nil) {
        _likedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _likedBtn.frame = CGRectMake(0, 0, kDeviceWidth/2, NavViewHeight);
        [_likedBtn setTitle:@"点赞" forState:UIControlStateNormal];
        [_likedBtn setTitleColor:VLight_GrayColor forState:UIControlStateNormal];
        [_likedBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        _likedBtn.titleLabel.font = [UIFont fontWithName:KFontThin size:14];
        [_likedBtn setBackgroundImage:[UIImage imageWithColor:View_white_Color] forState:UIControlStateNormal];
        [_likedBtn setBackgroundImage:[UIImage imageWithColor:View_white_Color] forState:UIControlStateSelected];
        [_likedBtn setBackgroundImage:[UIImage imageWithColor:VLight_GrayColor_apla] forState:UIControlStateHighlighted];
        
    }
    return _likedBtn;
}
-(UIButton *)commentBtn
{
    if (_commentBtn==nil) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentBtn.frame = CGRectMake(kDeviceWidth/2, 0, kDeviceWidth/2,NavViewHeight);
        [_commentBtn setTitle:@"评论" forState:UIControlStateNormal];
        [_commentBtn setTitleColor:VLight_GrayColor forState:UIControlStateNormal];
        [_commentBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_commentBtn setBackgroundImage:[UIImage imageWithColor:View_white_Color] forState:UIControlStateNormal];
        [_commentBtn setBackgroundImage:[UIImage imageWithColor:View_white_Color] forState:UIControlStateSelected];
        _commentBtn.titleLabel.font = [UIFont fontWithName:KFontThin size:14];
        [_commentBtn setBackgroundImage:[UIImage imageWithColor:VLight_GrayColor_apla] forState:UIControlStateHighlighted];
    }
    return _commentBtn;
}
-(UIView *)IndicatorView{
    if (_IndicatorView==nil) {
        _IndicatorView = [[UIView alloc] initWithFrame:CGRectMake(0,NavViewHeight-2, kDeviceWidth/2, 2)];
        _IndicatorView.userInteractionEnabled = YES;
        _IndicatorView.backgroundColor = VLight_GrayColor;
    }
    return _IndicatorView;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"消息";
    self.tabbleView.frame = CGRectMake(0,NavViewHeight, kDeviceWidth, kDeviceHeight-kHeightNavigation-kHeigthTabBar-NavViewHeight);
    [self setupNotNav];
    [self requestData];
}
#pragma mark -custom UI
-(void)setupNotNav
{
    UIView *notiView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, NavViewHeight)];
    notiView.userInteractionEnabled = YES;
    notiView.backgroundColor = [UIColor redColor];
    [self.view addSubview:notiView];
    [notiView addSubview:self.likedBtn];
    [notiView addSubview:self.commentBtn];
    [notiView addSubview:self.IndicatorView];
    self.IndicatorView.width_ic = self.likedBtn.width_ic/2;
    self.IndicatorView.centerX_ic = self.likedBtn.center.x;
    self.likedBtn.selected = YES;
    self.commentBtn.selected = NO;
    __weak typeof(self)  weakself  = self;
    //点赞
    [self.likedBtn addActionHandler:^(NSInteger tag) {
        if (weakself.likedBtn.selected ==NO) {
            weakself.likedBtn.selected = YES;
            weakself.commentBtn.selected = NO;
            [UIView animateWithDuration:0.3 animations:^{
                weakself.IndicatorView.centerX_ic = weakself.likedBtn.centerX_ic;
            }];
            if (self.dataArray.count>0) {
                [weakself.tabbleView reloadData];
            }else
            {
                [weakself requestData];
            }
        }else {
            
        }
    }];
    //评论
    [self.commentBtn addActionHandler:^(NSInteger tag) {
        if (self.commentBtn.selected ==NO) {
            [UIView animateWithDuration:0.3 animations:^{
                weakself.commentBtn.selected = YES;
                weakself.likedBtn.selected = NO;
                weakself.IndicatorView.centerX_ic = weakself.commentBtn.centerX_ic;
                
            }];
            if (self.dataArray2.count>0) {
                [weakself.tabbleView reloadData];
            }else
            {
                [weakself requestData];
            }
        }else {
            
        }
    }];
}
#pragma mark  -override parents method
-(void)RefreshViewControlEventValueChanged
{
    if (self.likedBtn.selected==YES) {
        self.page=1;
        [self.dataArray removeAllObjects];
    }else
    {
        self.page2 =1;
        [self.dataArray2 removeAllObjects];
    }
    [self requestData];
}
#pragma mark -ReqeustData
-(void)requestData
{
    [ZFYLoading showLoadViewInview:self.tabbleView];
    UserDataCenter *user = [UserDataCenter shareInstance];
    NSString  *urlString;
    if (self.likedBtn.selected == YES) {
        urlString  = [NSString stringWithFormat:@"%@noti-up/list?per-page=%ld&page=%ld",kApiBaseUrl,(long)self.pageSzie,(long)self.page];
    }
    else if(self.commentBtn.selected == YES) {
        urlString = [NSString stringWithFormat:@"%@noti-comm/list?per-page=%ld&page=%ld",kApiBaseUrl,(long)self.pageSzie,(long)self.page2];
    }
    NSString *tokenString = [Function getURLtokenWithURLString:urlString];
    NSDictionary  *paremetes =@{@"user_id":@"4",KURLTOKEN:tokenString};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager  POST:urlString parameters:paremetes success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        [ZFYLoading dismiss];
        if ([[responseObject objectForKey:@"code"] intValue]==0) {
            NSArray *array = [responseObject objectForKey:@"models"];
            if (self.likedBtn.selected==YES) {
                self.pageCount =[[responseObject objectForKey:@"pageCount"] integerValue];
            }else
            {
                self.pageCount2 =[[responseObject objectForKey:@"pageCount"] integerValue];
            }
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
                    if (self.dataArray2 == nil) {
                        self.dataArray2 = [NSMutableArray array];
                    }
                    [self.refreshControl endRefreshing];
                    if (self.likedBtn.selected==YES) {
                        [self.dataArray addObject:model];
                    }else
                    {
                        [self.dataArray2 addObject:model];
                    }
                    [self.tabbleView reloadData];
                }
            }else {
                [ZFYLoading showNullWithstatus:@"没有数据..." inView:self.tabbleView];
                [SVProgressHUD showInfoWithStatus:@"没有数据"];
                [self.tabbleView reloadData];
                [self.refreshControl endRefreshing];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.refreshControl endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        [ZFYLoading showFailWithstatus:@"加载失败" inView:self.tabbleView event:^(UIButton *sender) {
            [self requestData];
        }];
    }];
}
#pragma mark   -tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.likedBtn.selected==YES) {
        return self.dataArray.count;
    }else
    {
        return self.dataArray2.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId =@"CELL";
    NotifiCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell =[[NotifiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    //if (self.dataArray.count>indexPath.row) {
    NotiModel *model;
    if (self.likedBtn.selected==YES) {
        if (self.dataArray.count>indexPath.row) {
            model =self.dataArray[indexPath.row];
        }
        cell.islike = YES;
    }else
    {   cell.islike = NO;
        if (self.dataArray2.count>indexPath.row) {
        model =self.dataArray2[indexPath.row];
        }
    }
    cell.notimodel = model;
    cell.handEvent=^(NSInteger index)
    {
        [self.tabbleView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        MyViewController *my = [MyViewController new];
        my.author_Id = model.OuserInfo.Id;
        my.pageType= MyViewControllerPageTypeOthers;
        [self.navigationController pushViewController:my animated:YES];
    };
    //}
    return cell;
}
-(void)tableviewDisplayIndexpath:(NSIndexPath *)indexpath
{
    if (self.likedBtn.selected==YES) {
        if (self.pageCount>self.page&&self.dataArray.count==indexpath.row+1) {
            self.page++;
            [self requestData];
        }
    }else
    {
        if (self.pageCount2>self.page2&&self.dataArray2.count==indexpath.row+1) {
            self.page2++;
            [self requestData];
        }
    }
    
}
@end
