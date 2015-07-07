//
//  WordMainVC.h
//  Card_iOS
//
//  Created by 朱封毅 on 03/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "RootViewController.h"

@interface WordMainVC : RootViewController <UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageController;

//主要的数组
@property (nonatomic,strong) NSMutableArray  *MainArray;

//下标
@property(nonatomic,assign) NSInteger IndexOfItem;

@end
