//
//  DiscoverVC.m
//  Card_iOS
//
//  Created by 朱封毅 on 30/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "DiscoverVC.h"
#import "SVProgressHUD.h"
#import "Constant.h"
#import "UIImage+Color.h"
#import "TagModel.h"
#import "ZCControl.h"
#import "UIButton+Block.h"
#import "GCD.h"
#import "Function.h"
#import "UserDataCenter.h"
#import "AFNetworking.h"
#import "MyViewController.h"
#import "CommentDetailCell.h"
#import "DiscoverViewController.h"
//float const LIKE_BAR_HEIGH2 = 50;
#define like_barheight  50
@interface DiscoverVC ()
{
    Discloading  *loadView;
}
@end
@implementation DiscoverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentIndex = 1;
    [self createLikeBar];
    [self createLeftNavigationItem:nil Title:@"返回"];
    [self requestData];
    loadView= [[Discloading alloc]init];
    [self.view addSubview:loadView];
    self.tabbleView.tableFooterView = [UIView new];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceWidth)];
    headView.userInteractionEnabled = YES;
    headView.backgroundColor = VLight_GrayColor_apla;
    [self.tabbleView setTableHeaderView:headView];
    self.tabbleView.frame = CGRectMake(0, 0, kDeviceWidth-0, kDeviceHeight-kHeightNavigation-40);
    self.comView = [[CommonView alloc]initWithFrame:CGRectMake(10, 10, kDeviceWidth-20, kDeviceWidth-20)];
    [headView addSubview:self.comView];
    self.comView.isLongWord = YES;
}
-(void)configComView
{
    [self.comView configCommonView:self.model];
}
-(void)LeftNavigationButtonClick:(UIButton *)leftbtn
{
    [SVProgressHUD dismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)RefreshViewControlEventValueChanged
{
    self.page =1;
    [self.commentlistArray removeAllObjects];
    [self requstCommentData];
}
#pragma mark --RequestData Method
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
            self.currentIndex ++;
            [SVProgressHUD showImage:[UIImage imageNamed:@"svlike"] status:@"喜欢"];
            //[SVProgressHUD showSuccessWithStatus:status];
            [GCDQueue executeInMainQueue:^{
                //[self configComentView];
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showSuccessWithStatus:@"操作失败"];
    }];
}
-(void)requestDislike
{
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    NSString *urlString = [NSString stringWithFormat:@"%@/text/down", kApiBaseUrl];
    NSString *tokenString =[Function getURLtokenWithURLString:urlString];
    NSDictionary *parameters=@{@"prod_id":self.model.Id,@"user_id":userCenter.user_id,KURLTOKEN:tokenString};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            self.currentIndex ++;
            [SVProgressHUD showImage:[UIImage imageNamed:@"svdislike"] status:@"没感觉"];
            [GCDQueue executeInMainQueue:^{
                //[self configComentView];
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showSuccessWithStatus:@"操作失败"];
    }];
}
//删除评论
-(void)requestDeleteCommentWithCommentId:(NSString *)comment_id
{
    UserDataCenter *User = [UserDataCenter shareInstance];
    NSString *urlString  = [NSString stringWithFormat:@"%@comment/delete",kApiBaseUrl];
    NSString *tokenString = [Function getURLtokenWithURLString:urlString];
    NSDictionary  *dict = @{@"user_id":User.user_id,@"comment_id":comment_id,KURLTOKEN:tokenString};
    AFHTTPRequestOperationManager  *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue]==0) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"删除失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error ==%@",error);
        [SVProgressHUD showErrorWithStatus:@"删除失败"];
    }];
}

-(void)requestData
{
    NSDate* tmpStartData = [NSDate date];
    //You code here...
    UserDataCenter  *user = [UserDataCenter shareInstance];
    AFHTTPRequestOperationManager  *manager =[AFHTTPRequestOperationManager manager];
    NSString *url =[NSString stringWithFormat:@"%@text/discover",kApiBaseUrl];
    NSString *apitoken=[Function getURLtokenWithURLString:url];
    NSDictionary  *parameters= @{@"user_id":user.user_id,KURLTOKEN:apitoken};
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
        NSLog(@"cost time ＝＝＝＝＝= %f", deltaTime);
        if (deltaTime<2) {
            [GCDQueue  executeInMainQueue:^{
                [loadView removeFromSuperview];
                loadView=nil;
            } afterDelaySecs:2-deltaTime];
        }
        else
        {
            [GCDQueue executeInMainQueue:^{
                [loadView removeFromSuperview];
                loadView = nil;
            } afterDelaySecs:0];
        }
        if ([[responseObject objectForKey:@"code"] intValue]==0) {
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
                [self requstCommentData];
               
            }else
            {
                if (deltaTime<2) {
                    [GCDQueue  executeInMainQueue:^{
                        UIView  *view= [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth,kDeviceHeight-kHeightNavigation)];
                        view.backgroundColor = View_BackGround;
                        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth-75)/2, (kDeviceHeight-kHeightNavigation-75-100)/2, 75, 75)];
                        img.image = [UIImage imageNamed:@"empty"];
                        //img.backgroundColor =VGray_color;
                        [view addSubview:img];
                        
                        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0,img.frame.origin.y+img.frame.size.height+10, kDeviceWidth, 40)];
                        lable.text = @"看完了，等会再来吧";
                        lable.textColor = VGray_color;
                        lable.textAlignment = NSTextAlignmentCenter;
                        lable.font = [UIFont fontWithName:KFontThin size:14];
                        [view addSubview:lable];
                        [self.view addSubview:view];
                        
                    } afterDelaySecs:2-deltaTime];
                }
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
            [GCDQueue executeInMainQueue:^{
                [SVProgressHUD dismiss];
            } afterDelaySecs:2];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //数据加载失败
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}
-(void)requstCommentData
{
    if (self.dataArray.count<=self.currentIndex) {
        [SVProgressHUD showInfoWithStatus:@"看完了"];
        return;
    }
    self.model= [self.dataArray objectAtIndex:self.currentIndex];
    [self configComView];
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    NSString *urlString = [NSString stringWithFormat:@"%@comment/list?per-page=%ld&page=%ld", kApiBaseUrl,(long)self.pageSzie,(long)self.page];
    NSString *tokenString =[Function getURLtokenWithURLString:urlString];
    NSDictionary *parameters=@{@"prod_id":self.model.Id,@"user_id":userCenter.user_id,KURLTOKEN:tokenString};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            self.pageCount = [[responseObject objectForKey:@"pageCount"] integerValue];
            NSArray *Arr = [responseObject objectForKey:@"models"];
            if  (Arr.count>0) {
                for (NSDictionary  *dict in Arr) {
                    CommentModel *model = [CommentModel new];
                    if (dict) {
                        [model setValuesForKeysWithDictionary:dict];
                        UserModel *user = [UserModel new];
                        if (![[dict objectForKey:@"user"] isKindOfClass:[NSNull class]]) {
                            [user setValuesForKeysWithDictionary:[dict objectForKey:@"user"]];
                            model.userInfo = user;
                        }
                        if (!self.commentlistArray) {
                            self.commentlistArray = [NSMutableArray array];
                        }
                        [self.commentlistArray addObject:model];
                    }
                }
                [self.tabbleView reloadData];
                [self.refreshControl endRefreshing];
            }else
            {
                [self.tabbleView reloadData];
                [self.refreshControl endRefreshing];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.refreshControl endRefreshing];
        //[SVProgressHUD showSuccessWithStatus:@"操作失败"];
    }];
}

-(void)createLikeBar
{
    UIView *_toolView =[[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-like_barheight-kHeightNavigation,kDeviceWidth, like_barheight)];
    _toolView.userInteractionEnabled =YES;
    [self.view addSubview:_toolView];
    
    UIButton  *btn1 =[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame=CGRectMake(0, 0, kDeviceWidth/2, like_barheight);
    [btn1 setTitle:@"喜欢" forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont fontWithName:KFontThin size:16];
    [btn1 setBackgroundImage:[UIImage imageWithColor:View_ToolBar] forState:UIControlStateNormal];
    [btn1 setBackgroundImage:[UIImage imageWithColor:VLight_GrayColor] forState:UIControlStateHighlighted];
    [btn1 setBackgroundImage:[UIImage imageWithColor:VLight_GrayColor] forState:UIControlStateReserved];
    [btn1 setTitleColor:VGray_color forState:UIControlStateNormal];
    btn1.tag=99;
    [btn1 addActionHandler:^(NSInteger tag) {
        [GCDQueue  executeInMainQueue:^{
        //喜欢
            self.currentIndex ++;
            [self requstCommentData];
    }];
    }];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forState:UIControlStateNormal];
    btn1.backgroundColor=[UIColor whiteColor];
    [_toolView addSubview:btn1];
    UIButton  *btn2 =[UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame=CGRectMake(kDeviceWidth/2, 0, kDeviceWidth/2, like_barheight);
    [btn2 setTitle:@"没感觉" forState:UIControlStateNormal];
    [btn2 setBackgroundImage:[UIImage imageWithColor:View_ToolBar] forState:UIControlStateNormal];
    [btn2 setBackgroundImage:[UIImage imageWithColor:VLight_GrayColor] forState:UIControlStateHighlighted];
    btn2.tag=100;
    btn2.titleLabel.font = [UIFont fontWithName:KFontThin size:16];
    [btn2 addActionHandler:^(NSInteger tag) {
        self.currentIndex++;
        [self requstCommentData];
    }];
    [btn2 setTitleColor:VGray_color forState:UIControlStateNormal];
    btn2.backgroundColor=[UIColor whiteColor];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"tabbar_backgroud_color.png"] forState:UIControlStateNormal];
    [_toolView addSubview:btn2];
    
    //添加一个线
    UIView  *verline =[[UIView alloc]initWithFrame:CGRectMake(0,0,kDeviceWidth, 2)];
    verline.backgroundColor =VLight_GrayColor_apla;
    [_toolView addSubview:verline];
    
    UIView  *line = [[UIView alloc] initWithFrame:CGRectMake(kDeviceWidth/2,15,2, 20)];
    [_toolView addSubview:line];
    line.backgroundColor = VLight_GrayColor_apla;
}
#pragma mark  -tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentlistArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.commentlistArray.count>indexPath.row) {
        CommentModel *model = [self.commentlistArray objectAtIndex:indexPath.row];
        return  [CommentDetailCell getCellHeightWithModel:model];
    }
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellid";
    CommentDetailCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=  [[CommentDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (self.commentlistArray.count>indexPath.row) {
        CommentModel  *model = [self.commentlistArray objectAtIndex:indexPath.row];
        [cell configCellWithmodel:model :^(NSInteger buttonIndex) {
            
            switch (buttonIndex) {
                case 2000:
                    //删除自己的评论
                    //从数组中移除
                {
                    NSInteger  comment = [self.model.comm_count integerValue];
                    comment = comment -1;
                    self.model.comm_count = [NSString stringWithFormat:@"%ld",(long)comment];
                    //[self updateComment];
                    [self requestDeleteCommentWithCommentId:model.Id];
                    [self.commentlistArray removeObjectAtIndex:indexPath.row];
                    [self.tabbleView beginUpdates];
                    [self.tabbleView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                    [self.tabbleView endUpdates];
                }
                    break;
                case 1000:
                    //点击个人头像按钮
                {
                    MyViewController *my = [MyViewController new];
                    my.author_Id = model.userInfo.Id;
                    my.pageType= MyViewControllerPageTypeOthers;
                    [self.navigationController pushViewController:my animated:YES];
                }
                    break;
                default:
                    break;
            }
        } ];
        
    }
    return cell;
}

//上拉刷新
-(void)tableviewDisplayIndexpath:(NSIndexPath *)indexpath
{
    if (self.commentlistArray.count==indexpath.row+2&&self.pageCount >self.page) {
        self.page++;
        [self requstCommentData];
    }
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
