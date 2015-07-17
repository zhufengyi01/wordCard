//
//  DiscoverViewController.h
//  Card_iOS
//
//  Created by 朱封毅 on 07/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "RootViewController.h"
#import "CommonView.h"
#import "LikeModel.h"
#import "Discloading.h"
@class CommonModel;
@class TagModel;
@interface DiscoverViewController : RootViewController
{
    Discloading *loadView;
}
@property(nonatomic,strong) CommonModel   *model;

@property(nonatomic,strong)CommonView  *comView;

@property(nonatomic,assign) NSInteger  currentIndex;

@property(nonatomic,strong) NSMutableArray  *likeArray;

@property(nonatomic,strong) UIScrollView *myScrollerView;


@property(nonatomic,strong) NSMutableArray *dataArray;

@property(nonatomic,strong) UIView *likeBar;

@end
