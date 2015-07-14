//
//  WordMainVC.h
//  Card_iOS
//
//  Created by 朱封毅 on 03/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "RootViewController.h"
#import "CommonModel.h"
#import "WordDetailVC.h"
@interface WordMainVC : RootViewController <UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIGestureRecognizerDelegate>
{
    WordDetailVC *CurrentVC;
}
@property (strong, nonatomic) UIPageViewController *pageController;

//@property(nonatomic,strong) WordDetailVC  *CurrentVC;

//当前页面的model 对象
@property(strong,nonatomic) CommonModel  *Currentmodel;

//当前角标
@property(assign,nonatomic)NSInteger   CurrentIndex;
//主要的数组
@property (nonatomic,strong) NSMutableArray  *MainArray;



@property(nonatomic,strong)NSMutableArray    *likeArray;

//下标
@property(nonatomic,assign) NSInteger IndexOfItem;

@end
