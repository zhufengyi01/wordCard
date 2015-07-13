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
@implementation WordMainVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    //self.title = @"详细";
    //[self creatRightNavigationItem:[UIImage imageNamed:@"share"] Title:@""];
    [self createUI];
    //self.pageController.gestureRecognizers;
    //[self dealGesture];
    
}
-(void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    
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
    //    CenterViewController=initialViewController;
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
