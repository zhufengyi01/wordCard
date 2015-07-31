//
//  WordDetailListVC.m
//  Card_iOS
//
//  Created by 朱封毅 on 20/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "WordDetailListVC.h"
#import "ZCControl.h"
#import "Constant.h"
#import "UserDataCenter.h"
#import "Function.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "CommentModel.h"
#import "UserButton.h"
#import "CommentDetailCell.h"
#import "UIButton+Block.h"
#import "UIScrollView+Addition.h"
#import "MyViewController.h"
#import "UIImageView+WebCache.h"
#import "AuthorToolBar.h"
#import "NSDate+Extension.h"
#import "BaseNavigationViewController.h"
#import "CommentVC.h"
static  float  likebarheight = 80;
@implementation WordDetailListVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    //评论成功，刷新表格
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshViewControlEventValueChanged) name:CommentVCPushlicSucucessNotifation object:nil];
    self.tabbleView.tableFooterView = nil;
    self.tabbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabbleView.backgroundColor = VLight_GrayColor_apla;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceWidth)];
    headView.userInteractionEnabled = YES;
    headView.backgroundColor = VLight_GrayColor_apla;
    [self.tabbleView setTableHeaderView:headView];
    self.tabbleView.frame = CGRectMake(0, 0, kDeviceWidth-0, kDeviceHeight-kHeightNavigation-40);
    //self.tabbleView.showsVerticalScrollIndicator = NO;
    self.comView = [[CommonView alloc]initWithFrame:CGRectMake(10, 10, kDeviceWidth-20, kDeviceWidth-20)];
    [headView addSubview:self.comView];
    self.comView.isLongWord = YES;
    [self.comView configCommonView:self.model];
    
    UIView *likeBar = [[UIView alloc]initWithFrame:CGRectMake(0, self.comView.frame.origin.y+self.comView.frame.size.height+10, kDeviceWidth, likebarheight)];
    likeBar.userInteractionEnabled = YES;
    [headView addSubview:likeBar];
    // 点击进入个人页
    UserButton *userbtn = [[UserButton alloc]initWithFrame:CGRectMake(10,0, 200, 30)];
    NSURL  *usrl =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kUrlAvatar,self.model.userInfo.logo]];
    [userbtn addActionHandler:^(NSInteger tag) {
        MyViewController *my = [MyViewController new];
        my.author_Id = self.model.userInfo.Id;
        my.pageType= MyViewControllerPageTypeOthers;
        [self.navigationController pushViewController:my animated:YES];
    }];
    [userbtn.headImage sd_setImageWithURL:usrl placeholderImage:nil];
    userbtn.titleLab.text= self.model.userInfo.username;
    userbtn.brieflbl.text = self.model.userInfo.brief;
    [likeBar addSubview:userbtn];
    //喜欢，评论数量
    self.Author= [[AuthorToolBar alloc] init];
    [likeBar addSubview:self.Author];
    if ([self.model.view_count intValue]>0) {
        self.Author.esylbl.text =self.model.view_count;
    }if ([self.model.liked_count intValue]>0) {
        self.Author.heartlbl.text = self.model.liked_count;
    }if ([self.model.comm_count intValue]>0) {
        self.Author.commetlbl.text = self.model.comm_count;
    }
    //时间
    UILabel  *timelbl = [ZCControl createLabelWithFrame:CGRectMake(kDeviceWidth-90, 10, 80, 20) Font:12 Text:@"时间"];
    timelbl.font = [UIFont fontWithName:KFontThin size:10];
    //timelbl.backgroundColor = [UIColor redColor];
    timelbl.textAlignment=NSTextAlignmentRight;
    timelbl.textColor = VLight_GrayColor;
    [likeBar addSubview:timelbl];
    NSDate  *comfromTimesp =[NSDate dateWithTimeIntervalSince1970:[self.model.created_at intValue]];
    NSString  *da = [NSDate timeInfoWithDate:comfromTimesp];
    timelbl.text=da;
    
    //分割线
    UIView *seper = [[UIView alloc] initWithFrame:CGRectMake(0,likeBar.frame.size.height-5, kDeviceWidth, 5)];
    seper.backgroundColor = VLight_GrayColor_apla;
    [likeBar addSubview:seper];
    headView.frame =CGRectMake(0, 0, kDeviceWidth,likeBar.frame.origin.y+likeBar.frame.size.height+0);
    [self.tabbleView setTableHeaderView:headView];
    [self requstCommentData];
}
-(void)RefreshViewControlEventValueChanged
{
    //配置评论的数据
    [self updateComment];
    [self.dataArray removeAllObjects];
    [self requstCommentData];
}
//重新配置评论的数据
-(void)updateComment
{
    self.Author.commetlbl.text = self.model.comm_count;
}

#pragma mark --requset Method
-(void)requstCommentData
{
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
                        if (!self.dataArray) {
                            self.dataArray = [NSMutableArray array];
                        }
                        [self.dataArray addObject:model];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count>indexPath.row) {
        CommentModel *model = [self.dataArray objectAtIndex:indexPath.row];
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
    if (self.dataArray.count>indexPath.row) {
        CommentModel  *model = [self.dataArray objectAtIndex:indexPath.row];
        [cell configCellWithmodel:model :^(NSInteger buttonIndex) {
            
            switch (buttonIndex) {
                case 2000:
                    //删除自己的评论
                    //从数组中移除
                {
                    NSInteger  comment = [self.model.comm_count integerValue];
                    comment = comment -1;
                    self.model.comm_count = [NSString stringWithFormat:@"%ld",(long)comment];
                    [self updateComment];
                    [self requestDeleteCommentWithCommentId:model.Id];
                    if (self.dataArray.count <=indexPath.row) {
                        return ;
                    }
                    [self.dataArray removeObjectAtIndex:indexPath.row];
                    [self.tabbleView beginUpdates];
                    [self.tabbleView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                    [self.tabbleView endUpdates];
                }
                    break;
                case 2001:
                {
                    //评论回复
                    //点击发布评论
                    CommentVC *cv =[CommentVC new];
                    cv.pro_id =model.Id;
                    cv.model = self.model;
                    cv.commentmodel = model;
                    cv.pageType = CommentVCPageTypeReply;
                    cv.completeComment = ^(CommentModel *model)
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:CommentVCPushlicSucucessNotifation object:nil];
                    };
                    BaseNavigationViewController *na = [[BaseNavigationViewController alloc] initWithRootViewController:cv];
                    [self.navigationController presentViewController:na animated:YES completion:nil];
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
    if (self.dataArray.count==indexpath.row+2&&self.pageCount >self.page) {
        self.page++;
        [self requstCommentData];
    }
}

@end
