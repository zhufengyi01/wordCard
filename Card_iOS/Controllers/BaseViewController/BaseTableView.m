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
@end
@implementation BaseTableView

-(void)viewDidLoad{
    [super viewDidLoad];
    self.dataAraray =[NSMutableArray array];
    parameters =[[NSMutableDictionary alloc]initWithDictionary:self.parameters];
    page=1;
    pageCount=1;
    pageSize=20;

    NSString *userId = @"18";
    [parameters setObject:userId forKey:@"user_id"];
    self.tabbleView =[[UITableView alloc]initWithFrame:self.view.bounds];
    self.tabbleView.delegate=self;
    self.tabbleView.dataSource=self;
    [self.view addSubview: self.tabbleView];
    //请求数据
    [self requestData];
}
-(void)requestData
{
    AFHTTPRequestOperationManager  *manager =[AFHTTPRequestOperationManager manager];
    NSString *url =[NSString stringWithFormat:@"%@%@",kApiBaseUrl,self.urlString];
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
    return [CommonCell getCellHeightWithModel:[self.dataAraray objectAtIndex:indexPath.row]];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataAraray.count;
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
