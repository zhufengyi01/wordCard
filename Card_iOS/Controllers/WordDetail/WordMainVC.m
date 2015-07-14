//
//  WordMainVC.m
//  Card_iOS
//
//  Created by 朱封毅 on 03/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "WordMainVC.h"
#import "WordDetailVC.h"
#import "ZCControl.h"
#import "Constant.h"
#import "UMSocial.h"
#import "UMShareView.h"
#import "Function.h"
@implementation WordMainVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   // self.navigationController.hidesBarsOnSwipe = NO;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.CurrentIndex = 0;
    //self.title = @"详细";
    [self creatRightNavigationItem:[UIImage imageNamed:@"share"] Title:@""];
    [self createUI];
    //self.pageController.gestureRecognizers;
    //[self dealGesture];
}
//分享
-(void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    
    
    
    NSArray  *Arr =    [self.pageController viewControllers];
   // NSLog(@"=============%@",Arr);
   // NSArray  *vcarray =  [self.pageController childViewControllers];
   // NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~%@",vcarray);
    
    //if ([vcarray count]==1) {
      //      CurrentVC = (WordDetailVC *) [vcarray objectAtIndex:0];
       // }else
        //{
          //  CurrentVC = (WordDetailVC*) [vcarray objectAtIndex:1];
        //}
    CurrentVC = (WordDetailVC *) [Arr objectAtIndex:0];
    [self.pageController childViewControllers];
    float height = CurrentVC.comView.frame.size.height;
    UIImage *image= [Function getImage:CurrentVC.comView WithSize:CGSizeMake(kDeviceWidth-20, height)];
    UMShareView  *share =  [[UMShareView alloc]initwithScreenImage:image model:self.Currentmodel andShareHeight:height];
    __weak typeof(self) weakSelf = self;
    share.shareBtnEvent=^(NSInteger buttonIndex)
    {
        NSLog(@"bu======%ld",(long)buttonIndex);
        NSArray  *sharearray =[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline, UMShareToSina, nil];
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        [[UMSocialControllerService defaultControllerService] setShareText:weakSelf.Currentmodel.word shareImage:image socialUIDelegate:weakSelf];
        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:[sharearray  objectAtIndex:buttonIndex]].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
    };
    [share show];
}
-(void)createUI
{
    // 设置UIPageViewController的配置项
    NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMax]
                                                       forKey: UIPageViewControllerOptionSpineLocationKey];
    // 实例化UIPageViewController对象，根据给定的属性
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options: options];
    // 设置UIPageViewController对象的代理
    _pageController.dataSource = self;
    _pageController.delegate=self;
    // 定义“这本书”的尺寸
    [[_pageController view] setFrame:self.view.bounds];
    
    // 让UIPageViewController对象，显示相应的页数据。
    // UIPageViewController对象要显示的页数据封装成为一个NSArray。
    // 因为我们定义UIPageViewController对象显示样式为显示一页（options参数指定）。
    // 如果要显示2页，NSArray中，应该有2个相应页数据。
    WordDetailVC *initialViewController =[self viewControllerAtIndex:self.IndexOfItem];// 得到第一
    //初始化的时候记录了当前的第一个viewcontroller  以后每次都在代理里面获取当前的viewcontroller
    CurrentVC=initialViewController;
    NSArray *viewControllers =[NSArray arrayWithObject:initialViewController];
    [_pageController setViewControllers:viewControllers
                              direction:UIPageViewControllerNavigationDirectionForward
                               animated:NO
                             completion:nil];
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageController];
    [[self view] addSubview:[_pageController view]];
}

//根据下标值获取上一个控制器或者下一个控制器  得到相应的VC对象
- (WordDetailVC *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.MainArray count] == 0) || (index >= [self.MainArray count])) {
        return nil;
    }
    // 创建一个新的控制器类，并且分配给相应的数据
    WordDetailVC * dataViewController =[[WordDetailVC alloc] init];
    dataViewController.model = [self.MainArray objectAtIndex:index];
    dataViewController.likeArray = self.likeArray;
    return dataViewController;
}
// 根据数组元素值，得到下标值
- (NSUInteger)indexOfViewController:(WordDetailVC *)viewController {
    WordDetailVC *dataViewController=(WordDetailVC *)viewController;
    return [self.MainArray indexOfObject:dataViewController.model];
}

// 返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    //获取当前控制器
     //CurrentVC =(WordDetailVC *) viewController;
    NSUInteger index = [self indexOfViewController:(WordDetailVC *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    // 返回的ViewController，将被添加到相应的UIPageViewController对象上。
    // UIPageViewController对象会根据UIPageViewControllerDataSource协议方法，自动来维护次序。
    // 不用我们去操心每个ViewController的顺序问题。
    return [self viewControllerAtIndex:index];
}

// 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    //CurrentVC =(WordDetailVC *) viewController;
    NSUInteger index = [self indexOfViewController:(WordDetailVC *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.MainArray count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}
@end
