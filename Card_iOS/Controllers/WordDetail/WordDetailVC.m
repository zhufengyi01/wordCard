//
//  WordDetailVC.m
//  Card_iOS
//
//  Created by 朱封毅 on 03/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "WordDetailVC.h"
#import "ZCControl.h"
#import "SelectTimeView.h"
#import "Constant.h"
#import "AFNetworking.h"
#import "Function.h"
@implementation WordDetailVC

-(void)viewDidLoad
{
    [super viewDidLoad];
     self.view.backgroundColor  = View_BackGround;
     self.comView = [[CommonView alloc]initWithFrame:CGRectMake(5, 5+64, kDeviceWidth-10, kDeviceWidth-10)];
    [self.view addSubview:self.comView];
    [self.comView configCommonView:self.model];
    
    [self createToolBar];
}
-(void)createToolBar
{
    AdimToolBar *tool =[[AdimToolBar alloc]initWithFrame:CGRectMake(0, kDeviceHeight-BUTTON_HEIGHT, kDeviceWidth, BUTTON_HEIGHT)];
    tool.delegate = self;
    [self.view addSubview:tool];
}
-(void)handOperationAtIndex:(NSInteger)index
{
    if (index==0) {
        
    }else if(index==1)
    {
        
    }else if(index==2)
    {
        
    }else if(index==3)
    {
        
    }else if(index==4)
    {
        SelectTimeView *piker =[[SelectTimeView alloc]init];
        piker.delegate = self;
        [piker show];
    }
    
}
//定时发送到热门,发送时间戳
-(void)requesttiming:(NSString *)model_id AndTimeSp:(NSString *)timeSp
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString =[NSString stringWithFormat:@"%@text/change-status", kApiBaseUrl];
    NSString *tokenString =[Function getURLtokenWithURLString:urlString];
    NSDictionary *parameters=@{@"user_id":@"18",@"prod_id":model_id,@"status":@"3",@"updated_at":timeSp,KURLTOKEN:tokenString};
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
        NSString *titSting  =[NSString stringWithFormat:@"[%@]\n定时到热门成功",self.model.word];
         UIAlertView  * al =[[UIAlertView alloc]initWithTitle:nil message:titSting delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
           // [self performSelector:@selector(dismisAlertView) withObject:nil afterDelay:Alert_Interval];
            //请求点赞
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
#pragma mark  selected date time
-(void)DatePickerSelectedTime:(NSString *)dateString    {
    //定时到热门，伴随时间戳
    [self requesttiming:self.model.Id AndTimeSp:dateString];
}


@end
