//
//  BaseTableView.h
//  Card_iOS
//
//  Created by 朱封毅 on 02/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "RootViewController.h"

@interface BaseTableView : RootViewController

@property(nonatomic,strong) UITableView  *tabbleView;

@property(nonatomic,strong)NSMutableArray  *dataAraray;


@property(nonatomic,strong)NSString *urlString;
//-(void)requestData;

@property(nonatomic,strong)NSDictionary  *parameters;


@end
