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

@interface BaseTableView () <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableDictionary  *parameters;
    int page;
    int pageCount;
    int pageSize;

}
@property(nonatomic,strong) UIRefreshControl *refreshControl;
@end
@implementation BaseTableView

-(void)viewDidLoad{
    [super viewDidLoad];
    self.dataAraray =[NSMutableArray array];
    parameters =[[NSMutableDictionary alloc]initWithDictionary:self.parameters];
    page=1;
    pageCount=1;
    pageSize=10;

    NSString *userId = @"18";
    [parameters setObject:userId forKey:@"user_id"];
    self.tabbleView =[[UITableView alloc]initWithFrame:self.view.bounds];
    self.tabbleView.delegate=self;
    self.tabbleView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tabbleView.dataSource=self;
    [self.view addSubview: self.tabbleView];
    
    self.refreshControl =[[UIRefreshControl alloc]init];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:12],NSFontAttributeName,nil];
    self.refreshControl.attributedTitle =[[NSAttributedString alloc]initWithString:@"下拉刷新" attributes:dict]; //
    [self.refreshControl addTarget:self action:@selector(RefreshViewControlEventValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.tabbleView addSubview:self.refreshControl];
    //请求数据
    [self requestData];
}
-(void)RefreshViewControlEventValueChanged
{
    page=1;
    if (self.dataAraray.count>0) {
        [self.dataAraray removeAllObjects];
    }
    [self requestData];
    
}
-(void)requestData
{
    AFHTTPRequestOperationManager  *manager =[AFHTTPRequestOperationManager manager];
    NSString *url =[NSString stringWithFormat:@"%@%@?per-page=%d&page=%d",kApiBaseUrl,self.urlString,pageSize,page];
    NSString *apitoken=[Function getURLtokenWithURLString:url];
    [parameters setObject:apitoken forKey:KURLTOKEN];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject objectForKey:@"code"]) {
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
                        if (!self.dataAraray) {
                            self.dataAraray =[NSMutableArray array];
                        }
                        [self.dataAraray addObject:model];
                    }
                 }
              [self.tabbleView reloadData];
              [self.refreshControl endRefreshing];
            }else
            {
                //数据为空
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //数据加载失败
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataAraray.count>indexPath.row) {
        //CommonCell *model =[self.dataAraray objectAtIndex:indexPath.row];
        return [CommonCell getCellHeightWithModel:[self.dataAraray objectAtIndex:indexPath.row]];
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataAraray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *CellID =@"CELL";
    CommonCell  *cell =[tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell =[[CommonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (self.dataAraray.count>indexPath.row) {
        CommonModel *model =[self.dataAraray objectAtIndex:indexPath.row];
        [cell configCellValue:model  RowIndex:indexPath.row];
    }
    return cell;
}


@end
