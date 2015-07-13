//
//  BaseTableView.m
//  Card_iOS
//
//  Created by 朱封毅 on 02/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "BaseTableView.h"
#import "AFNetworking.h"
#import "CommonCell.h"
#import "Function.h"
#import "Constant.h"
#import "CommonModel.h"
#import "TagModel.h"
#import "LikeModel.h"
#import "UIScrollView+Addition.h"
#import "SVProgressHUD.h"
#import "NSDate+Extension.h"
#import "NSDateFormatter+Make.h"
#import "WordMainVC.h"
@interface BaseTableView () <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableDictionary  *parameters;
    int page;
    int pageCount;
    int pageSize;
}
@property(nonatomic,strong) UIRefreshControl *refreshControl;

@property(nonatomic,strong) UIView *footView;

@property(nonatomic,strong)UILabel *statusLable;
@end
@implementation BaseTableView

-(void)viewDidLoad{
    [super viewDidLoad];
    self.dataAraray = [NSMutableArray array];
    self.likeArray  = [NSMutableArray array];
    self.temArr = [NSMutableArray array];
    parameters =[[NSMutableDictionary alloc]initWithDictionary:self.parameters];
    page=1;
    pageCount=1;
    pageSize=20;
    UserDataCenter  *user = [UserDataCenter shareInstance];
    NSString *userId = user.user_id;
    [parameters setObject:userId forKey:@"user_id"];
    self.tabbleView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) style:UITableViewStylePlain];
    self.tabbleView.delegate=self;
    self.tabbleView.backgroundColor = [UIColor whiteColor];
    self.tabbleView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tabbleView.dataSource=self;
    [self.view addSubview: self.tabbleView];
    [self createFootView];
    
    self.refreshControl =[[UIRefreshControl alloc]init];
    self.refreshControl.tintColor =VGray_color;
    self.refreshControl.backgroundColor =[UIColor whiteColor];
    //NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:12],NSFontAttributeName,nil];
    //self.refreshControl.attributedTitle =[[NSAttributedString alloc]initWithString:@"下拉刷新" attributes:dict]; //
    [self.refreshControl addTarget:self action:@selector(RefreshViewControlEventValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.tabbleView addSubview:self.refreshControl];
    [SVProgressHUD show];
}
#pragma mark  --UserMethod
//刷新视图
-(void)createFootView
{
    self.footView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, BUTTON_HEIGHT)];
    self.footView.backgroundColor =[UIColor whiteColor];
    [self.tabbleView setTableFooterView:self.footView];
    self.statusLable  = [[UILabel alloc]initWithFrame:CGRectMake((kDeviceWidth-100)/2, 0, 100,BUTTON_HEIGHT)];
    UIView  *line = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, 0.5)];
    [self.footView addSubview:line];
    line.backgroundColor = VLight_GrayColor_apla;

    self.statusLable.font =[UIFont fontWithName:kFontRegular size:12];
    self.statusLable.textAlignment = NSTextAlignmentCenter;
    self.statusLable.text = @"THE-END";
    self.statusLable.textColor = VGray_color;
    [self.footView addSubview:self.statusLable];
}
-(void)RefreshViewControlEventValueChanged
{
    [self.temArr removeAllObjects];
    page=1;
    [self requestData];
}
-(void)tableViewScollerTop
{
    [self.tabbleView scrollToTopAnimated:YES];
    
}
//根据热门请求的数组返回一系列的数组，
-(void)computeRecomendSectionView:(NSMutableArray *) dataArray
{
    if (self.dataAraray.count>0) {
        [self.dataAraray removeAllObjects];
    }
    NSMutableArray  *array0 =[[NSMutableArray alloc]init];
    CommonModel  *obj0 = [dataArray objectAtIndex:0];
    //把第一个对象加入到数组中
    [array0 insertObject:obj0 atIndex:0];
    [self.dataAraray addObject:array0];
    //取出时间
    NSDate  *comfromTimesp =[NSDate dateWithTimeIntervalSince1970:[obj0.updated_at intValue]];
    NSDateFormatter *formatter =[NSDateFormatter  dateFormatterWithFormat:@"YYYY-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+8000"]];
    NSString  *datestr0 = [formatter stringFromDate:comfromTimesp];
    //目的，根据时间，对dataarray进行分组，最后把这个分组存放在self.dataArray0 中
    for (int i = 1; i<dataArray.count; i++) {
        CommonModel *model =[dataArray objectAtIndex:i];
        //取出时间
        NSDate  *comfromTimesp =[NSDate dateWithTimeIntervalSince1970:[model.updated_at intValue]];
        NSDateFormatter *formatter =[NSDateFormatter  dateFormatterWithFormat:@"YYYY-MM-dd"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+8000"]];
        NSString  *datestr = [formatter stringFromDate:comfromTimesp];
        if ([datestr0 isEqualToString:datestr]) {//如果上一项等于下一项的话，把第二项加入到上面的数组
            [array0 addObject:model];
        }
        else
        {
            array0 =[[NSMutableArray alloc]init];
            [array0 addObject:model];
            [self.dataAraray addObject:array0];
        }
        datestr0=datestr;
    }
}

-(void)requestData
{
    AFHTTPRequestOperationManager  *manager =[AFHTTPRequestOperationManager manager];
    NSString *url =[NSString stringWithFormat:@"%@%@?per-page=%d&page=%d",kApiBaseUrl,self.urlString,pageSize,page];
    NSString *apitoken=[Function getURLtokenWithURLString:url];
    [parameters setObject:apitoken forKey:KURLTOKEN];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject objectForKey:@"code"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            self.statusLable.text = @"THE-END";
            if (page==1&&self.dataAraray.count>0) {
                [self.dataAraray removeAllObjects];
            }
            pageCount =[[responseObject objectForKey:@"pageCount"] intValue];
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
                [SVProgressHUD showInfoWithStatus:@"没有数据"];
                //数据为空
                [self.refreshControl endRefreshing];
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
            //}
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //数据加载失败
        [self.statusLable setText:@"加载失败"];
        [self.refreshControl endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}

#pragma  mark --TableViewDelegate dataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray  *Arr = self.dataAraray[indexPath.section];
    if (Arr.count>indexPath.row) {
        return  [CommonCell getCellHeightWithModel:[self.dataAraray[indexPath.section] objectAtIndex:indexPath.row]];
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataAraray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataAraray.count >section) {
        NSArray *Arr = self.dataAraray[section];
        return Arr.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *CellID =@"CELL";
    CommonCell  *cell =[tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell =[[CommonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
        CommonModel *model =[[self.dataAraray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [cell configCellValue:model  RowIndex:indexPath.row];
    
    return cell;
}
//获取点击的下标
-(int)getIndexWithSection:(int) section Row:(int) row
{
    int num=0;
    for (int i=0; i<section; i++) {
        NSArray *arr =[self.dataAraray objectAtIndex:i];
        int a= (int)[arr count];
        num =num+a;
    }
    return num+row;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WordMainVC  *wordmian =[WordMainVC new];
    wordmian.MainArray = self.temArr;
    int  index =  [self getIndexWithSection:(int)indexPath.section Row:(int)indexPath.row];
    wordmian.IndexOfItem= index;
    wordmian.likeArray = self.likeArray;
    [self.navigationController pushViewController:wordmian animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView  *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40)];
    headView.backgroundColor =[[ UIColor whiteColor] colorWithAlphaComponent:0.95];
    UILabel *hlbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40)];
    hlbl.textColor = VLight_GrayColor;
    hlbl.font = [UIFont systemFontOfSize:14];
    hlbl.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:hlbl];
    if (self.dataAraray.count>section) {
        CommonModel *model =[[self.dataAraray objectAtIndex:section] objectAtIndex:0];
        //取出时间
        NSDate  *comfromTimesp =[NSDate dateWithTimeIntervalSince1970:[model.updated_at intValue]];
        NSDateFormatter *formatter =[NSDateFormatter  dateFormatterWithFormat:@"MM月dd日"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+8000"]];
        NSString  *datestr0 = [formatter stringFromDate:comfromTimesp];
        hlbl.text= [NSString stringWithFormat:@"%@  %@",datestr0,[comfromTimesp dayFromWeekday]];
    }
    return headView;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    long  int index= [self getIndexWithSection:(int)indexPath.section Row:(int)indexPath.row];
    if (pageCount>page&&(self.temArr.count==index+1)) {
        page++;
        [self requestData];
    }else
    {
        self.statusLable.text = @"THE-END";
    }
}
@end
