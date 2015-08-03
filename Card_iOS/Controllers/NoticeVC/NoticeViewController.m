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
#import "WordMainVC.h"
#import "CommonModel.h"
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

@property(nonatomic,strong) UIButton *systemBtn;
/*
 2个像素的指示器
 */
@property(nonatomic,strong) UIView   *IndicatorView;

/*
 评论消息通知
 */
@property(nonatomic,strong)NSMutableArray *dataArray2;

/*
 评论总页数
 */

@property(nonatomic,assign)NSInteger       pageCount2;
@property(nonatomic,assign)NSInteger       page2;
/*
 系统通知页数
 */
@property(nonatomic,assign)NSInteger       pageCount3;
@property(nonatomic,assign)NSInteger       page3;
@property(nonatomic,strong)NSMutableArray  *dataArray3;
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
        self.dataArray3 = [NSMutableArray array];
        self.pageCount2 = 1;
        self.pageCount3 = 1;
        self.page2 = 1;
        self.page3 = 1;
    }
    return self;
}
#pragma  mark -getter method
-(UIButton *)likedBtn
{
    if (_likedBtn==nil) {
        _likedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _likedBtn.frame = CGRectMake(0, 0, kDeviceWidth/3, NavViewHeight);
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
        _commentBtn.frame = CGRectMake(kDeviceWidth/3, 0, kDeviceWidth/3,NavViewHeight);
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
-(UIButton *)systemBtn
{
    if (_systemBtn==nil) {
        _systemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _systemBtn.frame = CGRectMake((kDeviceWidth/3)*2, 0, kDeviceWidth/3,NavViewHeight);
        [_systemBtn setTitle:@"系统" forState:UIControlStateNormal];
        [_systemBtn setTitleColor:VLight_GrayColor forState:UIControlStateNormal];
        [_systemBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_systemBtn setBackgroundImage:[UIImage imageWithColor:View_white_Color] forState:UIControlStateNormal];
        [_systemBtn setBackgroundImage:[UIImage imageWithColor:View_white_Color] forState:UIControlStateSelected];
        _systemBtn.titleLabel.font = [UIFont fontWithName:KFontThin size:14];
        [_systemBtn setBackgroundImage:[UIImage imageWithColor:VLight_GrayColor_apla] forState:UIControlStateHighlighted];
    }
    return _systemBtn;
}

-(UIView *)IndicatorView{
    if (_IndicatorView==nil) {
        _IndicatorView = [[UIView alloc] initWithFrame:CGRectMake(0,NavViewHeight-2, kDeviceWidth/3, 2)];
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
    [notiView addSubview:self.systemBtn];
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
            weakself.systemBtn.selected = NO;
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
                weakself.systemBtn.selected = NO;
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
    [self.systemBtn addActionHandler:^(NSInteger tag) {
        if (self.systemBtn.selected ==NO) {
            [UIView animateWithDuration:0.3 animations:^{
                weakself.systemBtn.selected = YES;
                weakself.likedBtn.selected = NO;
                weakself.commentBtn.selected = NO;
                weakself.IndicatorView.centerX_ic = weakself.systemBtn.centerX_ic;
            }];
            if (self.dataArray3.count>0) {
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
    }else if(self.commentBtn.selected == YES)
    {
        self.page2 =1;
        [self.dataArray2 removeAllObjects];
    }else
    {
        self.page3 = 1;
        [self.dataArray3 removeAllObjects];
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
    else if (self.systemBtn.selected == YES)
    {
        urlString = [NSString stringWithFormat:@"%@noti-sys/list?per-page=%ld&page=%ld",kApiBaseUrl,(long)self.pageSzie,(long)self.page3];
    }
    NSString *tokenString = [Function getURLtokenWithURLString:urlString];
    NSDictionary  *paremetes =@{@"user_id":user.user_id,KURLTOKEN:tokenString};
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
                        CommonModel *text = [CommonModel new];
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
                            text.tagArray= tagArray;
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
                    if (self.dataArray3 == nil) {
                        self.dataArray3 = [NSMutableArray array];
                    }
                    [self.refreshControl endRefreshing];
                    if (self.likedBtn.selected==YES) {
                        [self.dataArray addObject:model];
                    }else if (self.commentBtn.selected == YES)
                    {
                        [self.dataArray2 addObject:model];
                    }
                    else if(self.systemBtn.selected == YES) {
                        [self.dataArray3 addObject:model];
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
    }else if(self.commentBtn.selected == YES)
    {
        return self.dataArray2.count;
    }else
    {
        return self.dataArray3.count;
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
    cell.headBtn.hidden = NO;
    cell.namelbl.frame = CGRectMake(65, 10, 200, 30);
    cell.timelbl.frame = CGRectMake(65, 45, 100, 20);
    NotiModel *model;
    if (self.likedBtn.selected==YES) {
        if (self.dataArray.count>indexPath.row) {
            model =self.dataArray[indexPath.row];
        }
        cell.islike = YES;
    }else if(self.commentBtn.selected == YES)
    {   cell.islike = NO;
        if (self.dataArray2.count>indexPath.row) {
            model =self.dataArray2[indexPath.row];
        }
    }else
    {
        cell.headBtn.hidden = YES;
        cell.namelbl.frame = CGRectMake(10, 10, 200, 30);
        cell.timelbl.frame = CGRectMake(10, 45, 100,20);
        NotiModel * model3 = self.dataArray3[indexPath.row];
        if ([model3.type isEqualToString:@"1"]) {
            cell.namelbl.text = @"恭喜，你的内容入选“发现”";
        }else if([model3.type isEqualToString:@"2"])
        {
            cell.namelbl.text=@"大恭喜，你的内容入选“热门” ";
        }
    }
    NSLog(@" model textinfo == %@",model.textInfo);
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self tableView:tableView didSelectRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray *Arr = [NSMutableArray array];
    NotiModel *model;
    if (self.likedBtn.selected==YES) {
        {
            model= [self.dataArray objectAtIndex:indexPath.row];
            [self.dataArray enumerateObjectsUsingBlock:^(NotiModel *obj, NSUInteger idx, BOOL *stop){
                if (!obj.textInfo) {
                    return ;
                }
                [Arr addObject:obj.textInfo];
            }];
        }
    }else if(self.commentBtn.selected==YES)
    {
        model = [self.dataArray2 objectAtIndex:indexPath.row];
        [self.dataArray2 enumerateObjectsUsingBlock:^(NotiModel *obj, NSUInteger idx, BOOL *stop) {
            if (!obj.textInfo) {
                return ;
            }
            [Arr addObject:obj.textInfo];
        }];
    }else{
        model = [self.dataArray3 objectAtIndex:indexPath.row];
        [self.dataArray3 enumerateObjectsUsingBlock:^(NotiModel *obj, NSUInteger idx, BOOL *stop) {
            if (!obj.textInfo) {
                return ;
            }
            [Arr addObject:obj.textInfo];
        }];
    }
    if (!model.textInfo) {
        return;
    }
    model.status = @"0";
    [self.tabbleView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    WordMainVC  *wordmian =[WordMainVC new];
    wordmian.MainArray = Arr;
    NSInteger  index = indexPath.row;
    wordmian.IndexOfItem = index;
    [self.navigationController pushViewController:wordmian animated:YES];
}
-(void)tableviewDisplayIndexpath:(NSIndexPath *)indexpath
{
    if (self.likedBtn.selected==YES) {
        if (self.pageCount>self.page&&self.dataArray.count==indexpath.row+1) {
            self.page++;
            [self requestData];
        }
    }else if(self.commentBtn.selected==YES)
    {
        if (self.pageCount2>self.page2&&self.dataArray2.count==indexpath.row+1) {
            self.page2++;
            [self requestData];
        }
    }else{
        if (self.pageCount3>self.page3&&self.dataArray3.count==indexpath.row+1) {
            self.page3 ++;
            [self requestData];
        }
    }
    
}
@end
