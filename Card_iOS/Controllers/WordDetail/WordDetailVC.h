//
//  WordDetailVC.h
//  Card_iOS
//
//  Created by 朱封毅 on 03/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "RootViewController.h"
#import "CommonView.h"
#import "CommonModel.h"
#import "AdimToolBar.h"
#import "SelectTimeView.h"

@interface WordDetailVC : RootViewController <AdimToolBarDelegate,SelectTimeViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong) CommonModel   *model;

@property(nonatomic,strong)CommonView  *comView;

@property(nonatomic,strong) NSMutableArray  *likeArray;

@property(nonatomic,strong) UIScrollView *myScrollerView;



@end
