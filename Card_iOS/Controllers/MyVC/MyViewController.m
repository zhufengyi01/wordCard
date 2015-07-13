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
#import "CommonModel.h"
#import "UIImage+Color.h"
#import "TagModel.h"
#import "CommonCell.h"
#import "LikeModel.h"
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
    self.tabbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (self.addWordbtn.selected==YES) {
        [self.tabbleView setEditing:YES animated:YES];
    }else
    {
        [self.tabbleView setEditing:NO animated:NO];
    }
    [self createHeaderView];
    [self requestUserInfo];
    [self requestData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshViewControlEventValueChanged) name:AddCardwillGotoUserNotification object:nil];
}
-(void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    [self.navigationController pushViewController:[SettingViewController new] animated:YES];
    
}
-(void)RefreshViewControlEventValueChanged
{
    if (self.addWordbtn.selected ==YES) {
        page1 = 1;
        [self.dataArray1 removeAllObjects];
        
    }else {
        page2 = 1;
        [self.dataArray2 removeAllObjects];
    }
    [self requestUserInfo];
    [self requestData];
}
-(void)createHeaderView
{
    UserDataCenter  *User = [UserDataCenter shareInstance];
    UIView  *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 160)];
    headView.backgroundColor = View_white_Color;
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
    contentlbl = [ZCControl createLabelWithFrame:CGRectMake(namelbl.frame.origin.x, namelbl.frame.origin.y+namelbl.frame.size.height, 180, 20) Font:12 Text:@"内容"];
    contentlbl.textColor = VGray_color;
    [headView addSubview:contentlbl];
    
    describelbl = [ZCControl createLabelWithFrame:CGRectMake(namelbl.frame.origin.x, contentlbl.frame.origin.y+contentlbl.frame.size.height+10, kDeviceWidth-contentlbl.frame.origin.x-10, 20) Font:14 Text:@"内容"];
    describelbl.textColor = VGray_color;
    [headView addSubview:describelbl];
    
    ///添加
    self.addWordbtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addWordbtn.frame = CGRectMake(0, headView.frame.size.height-segmentheight, kDeviceWidth/2, segmentheight);
    [self.addWordbtn setTitle:@"添加" forState:UIControlStateNormal];
    self.addWordbtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.addWordbtn setTitleColor:VGray_color forState:UIControlStateNormal];
    [self.addWordbtn setTitleColor:VBlue_color forState:UIControlStateSelected];
    [self.addWordbtn setTitleColor:VBlue_color forState:UIControlStateHighlighted];
    self.addWordbtn.selected = YES;
    [self.addWordbtn setBackgroundImage:[UIImage imageWithColor:View_white_Color] forState:UIControlStateNormal];
    __weak typeof(self) weakself = self;
    [self.addWordbtn addActionHandler:^(NSInteger tag) {
        if (weakself.addWordbtn.selected ==NO) {
            weakself.addWordbtn.selected =YES;
            weakself.likeWorkbtn.selected = NO;
            if (self.dataArray1.count==0) {
                [weakself requestData];
            }else{
            [weakself.tabbleView reloadData];
            }
        }
    }];
    [headView addSubview:self.addWordbtn];
    //喜欢
    self.likeWorkbtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    self.likeWorkbtn.frame = CGRectMake(kDeviceWidth/2, headView.frame.size.height-segmentheight, kDeviceWidth/2, segmentheight);
    self.likeWorkbtn.selected = NO;
    [self.likeWorkbtn setTitle:@"喜欢" forState:UIControlStateNormal];
    self.likeWorkbtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.likeWorkbtn setTitleColor:VGray_color forState:UIControlStateNormal];
    [self.likeWorkbtn setTitleColor:VBlue_color forState:UIControlStateHighlighted];
    [self.likeWorkbtn setTitleColor:VBlue_color forState:UIControlStateSelected];
    [self.likeWorkbtn setBackgroundImage:[UIImage imageWithColor:View_white_Color] forState:UIControlStateNormal];
    [self.likeWorkbtn addActionHandler:^(NSInteger tag) {
        if (weakself.likeWorkbtn.selected ==NO) {
            weakself.likeWorkbtn.selected =YES;
            weakself.addWordbtn.selected = NO;
            if (self.dataArray2.count==0) {
                [weakself requestData];
            }else {
            [weakself.tabbleView reloadData];
            }
        }
    }];
    [headView addSubview:self.likeWorkbtn];
    UIView  *line = [[UIView alloc] initWithFrame:CGRectMake(kDeviceWidth/2,headView.frame.size.height-33,0.5, 25)];
    [headView addSubview:line];
    line.backgroundColor = VGray_color;
    UIView  *line2 = [[UIView alloc] initWithFrame:CGRectMake(0,headView.frame.size.height-1, kDeviceWidth, 0.5)];
    [headView addSubview:line2];
    line2.backgroundColor = VLight_GrayColor_apla;

    if (self.pageType ==MyViewControllerPageTypeDefault) {
        NSURL  *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kUrlAvatar,User.logo]];
        [headImage sd_setImageWithURL:url placeholderImage:HeadImagePlaceholder];
        namelbl.text = User.username;
        //NSString  *contentString = [NSString stringWithFormat:@"内容:%@ 被赞:%@",User.product_count,User.like_count];
    }
}

#pragma mark  --requestData
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
    NSDictionary  *dict = @{@"user_id":User.user_id,KURLTOKEN:tokenString};
    [manager POST:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject objectForKey:@"code"]) {
            if (!self.author_Id) {
                NSString *pr_d = [[responseObject objectForKey:@"model"] objectForKey:@"prod_count"];
                NSString *li_d = [[responseObject objectForKey:@"model"] objectForKey:@"liked_count"];
                if ([pr_d intValue]==0) {
                    pr_d=@"0";
                }
                if ([li_d intValue]==0) {
                    li_d=@"0";
                }
                User.product_count = pr_d;
                User.like_count    = li_d;
                NSString *content = [NSString stringWithFormat:@"内容 : %@  点赞 : %@",pr_d,li_d];
                //NSMutableAttributedString  *Attribute = [[NSMutableAttributedString alloc] initWithString:content];
                NSURL  *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kUrlAvatar,User.logo]];
                [headImage sd_setImageWithURL:url placeholderImage:HeadImagePlaceholder];
                namelbl.text = User.username;
                contentlbl.text = content;
                describelbl.text = User.signature;
            }else {
                NSString *pr_d = [[responseObject objectForKey:@"model"] objectForKey:@"prod_count"];
                NSString *li_d = [[responseObject objectForKey:@"model"] objectForKey:@"liked_count"];
                if ([pr_d intValue]==0) {
                    pr_d=@"0";
                }
                if ([li_d intValue]==0) {
                    pr_d=@"0";
                }
                NSString *content = [NSString stringWithFormat:@"内容 : %@  点赞 : %@",pr_d,li_d];
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
        [SVProgressHUD showErrorWithStatus:@"request fail"];
    }];
    
}

#pragma mark --requesteData 
-(void)requestDeleteDataWith:(NSString *)word_id
{
    UserDataCenter *User = [UserDataCenter shareInstance];
    NSString *urlString  = [NSString stringWithFormat:@"%@text/delete",kApiBaseUrl];
    NSString *tokenString = [Function getURLtokenWithURLString:urlString];
    NSDictionary  *dict = @{@"user_id":User.user_id,@"prod_id":word_id,KURLTOKEN:tokenString};
    AFHTTPRequestOperationManager  *manager = [AFHTTPRequestOperationManager manager];
   [manager POST:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
       if ([[responseObject objectForKey:@"code"] intValue]==0) {
           [SVProgressHUD showSuccessWithStatus:@"delete sucucess"];
       }
       else
       {
           [SVProgressHUD showErrorWithStatus:@"delete fail"];
       }
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       NSLog(@"error ==%@",error);
     [SVProgressHUD showErrorWithStatus:@"delete fail"];   }];
}
-(void)requestData
{
    if (!self.dataArray1) {
        self.dataArray1 =[NSMutableArray array];
    }
    if (!self.dataArray2) {
        self.dataArray2 = [NSMutableArray array];
    }
    UserDataCenter *User = [UserDataCenter shareInstance];
    NSString *uid;
    NSDictionary  *parameters;
    if (!self.author_Id) {
        uid = User.user_id;
    }else{
        uid =self.author_Id;
    }
    NSString  *urlString;
    if (self.addWordbtn.selected == YES) {
        urlString = [NSString stringWithFormat:@"%@text/list-by-user-id?per-page=%d&page=%d",kApiBaseUrl,(int)self.pageSzie,(int)page1];
        NSString  *tokenString = [Function getURLtokenWithURLString:urlString];
        parameters = @{@"user_id":uid,KURLTOKEN:tokenString};
    }else{
        urlString = [NSString stringWithFormat:@"%@up/list?per-page=%d&page=%d",kApiBaseUrl,(int)self.pageSzie,(int)page2];
        NSString  *tokenString = [Function getURLtokenWithURLString:urlString];
        if (!self.author_Id) {
            self.author_Id = uid;
        }
        parameters = @{@"user_id":uid,KURLTOKEN:tokenString,@"author_id":self.author_Id};
    }
    AFHTTPRequestOperationManager  *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue]==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            if (self.addWordbtn.selected ==YES) {
                pageCount1 =[[responseObject objectForKey:@"pageCount"] intValue];
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
                            model.tagArray = tagArray;
                            [self.dataArray1 addObject:model];
                        }
                    }
                    [self.tabbleView reloadData];
                    [self.refreshControl endRefreshing];
                }else
                {
                    [SVProgressHUD showInfoWithStatus:@"没有数据"];
                    [self.tabbleView reloadData];
                    //数据为空
                    [self.refreshControl endRefreshing];
                }
                NSMutableArray  *likearr = [responseObject objectForKey:@"ups"];
                for (int i=0; i<likearr.count; i++) {
                    LikeModel *likemodel = [LikeModel new];
                    [likemodel setValuesForKeysWithDictionary:[likearr objectAtIndex:i]];
                    if (self.likeArray1==nil) {
                        self.likeArray1 = [NSMutableArray array];
                    }
                    [self.likeArray1 addObject:likemodel];
                }
            }else
            {
                pageConut2 =[[responseObject objectForKey:@"pageCount"] intValue];
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
                            model.tagArray = tagArray;
                            [self.dataArray2 addObject:model];
                        }
                    }
                    [self.tabbleView reloadData];
                    [self.refreshControl endRefreshing];
                }else
                {
                    [SVProgressHUD showInfoWithStatus:@"没有数据"];
                    [self.tabbleView reloadData];
                    //数据为空
                    [self.refreshControl endRefreshing];
                }
                NSMutableArray  *likearr = [responseObject objectForKey:@"ups"];
                for (int i=0; i<likearr.count; i++) {
                    LikeModel *likemodel = [LikeModel new];
                    [likemodel setValuesForKeysWithDictionary:[likearr objectAtIndex:i]];
                    if (self.likeArray2==nil) {
                        self.likeArray2 = [NSMutableArray array];
                    }
                    [self.likeArray2 addObject:likemodel];
                }
                
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //数据加载失败
        [self.refreshControl endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return kDeviceWidth-10;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.addWordbtn.selected == YES) {
        return self.dataArray1.count;
    }else {
        return self.dataArray2.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.addWordbtn.selected==YES) {
        static  NSString *CellID =@"CELL";
        CommonCell  *cell =[tableView dequeueReusableCellWithIdentifier:CellID];
        if (!cell) {
            cell =[[CommonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        if (self.dataArray1.count>indexPath.row) {
            CommonModel *model =[self.dataArray1  objectAtIndex:indexPath.row];
            [cell configCellValue:model  RowIndex:indexPath.row];
        }
        return cell;
    }
    else{
        static  NSString *CellID2 =@"CELL2";
        CommonCell  *cell =[tableView dequeueReusableCellWithIdentifier:CellID2];
        if (!cell) {
            cell =[[CommonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID2];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        if (self.dataArray2.count>indexPath.row) {
            CommonModel *model =[self.dataArray2  objectAtIndex:indexPath.row];
            [cell configCellValue:model  RowIndex:indexPath.row];
        }
        return cell;
    }
    return nil;
}
-(void)tableviewDisplayIndexpath:(NSIndexPath *)indexpath
{
    if (self.addWordbtn.selected==YES)
    {
        if (pageCount1>page1&&self.dataArray1.count==indexpath.row+1) {
            page1++;
            [self requestData];
        }
    }else{
        if (pageConut2>page2&&self.dataArray2.count==indexpath.row+1) {
            page2++;
            [self requestData];
        }
    }
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.addWordbtn.selected==YES)
    {
        if (self.dataArray1.count>indexPath.row) {
            CommonModel *m = [self.dataArray1 objectAtIndex:indexPath.row];
            [self requestDeleteDataWith:m.Id];
            [self.dataArray1 removeObjectAtIndex:indexPath.row];
            [self.tabbleView beginUpdates];
            [self.tabbleView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [self.tabbleView endUpdates];
        }
        
    }else{
        [self.tabbleView setEditing:NO animated:YES];
        [SVProgressHUD showInfoWithStatus:@"you can't delete"];
    }
}
@end
