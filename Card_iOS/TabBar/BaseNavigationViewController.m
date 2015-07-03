//
//  BaseNavigationViewController.m
//  ZFYTabbarController
//
//  Created by 朱封毅 on 29/06/15.
//  Copyright (c) 2015年 朱封毅. All rights reserved.
//

#import "BaseNavigationViewController.h"
#import "UIImage+Color.h"
#import "Constant.h"
@interface BaseNavigationViewController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation BaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor =[UIColor whiteColor];
    self.navigationBar.tintColor =[UIColor grayColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
   //防止手势失效的解决方案
   // self.delegate=self;
    //self.interactivePopGestureRecognizer.delegate=self;
    //设置返回的箭头自定义图片
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    UIImage  *backimage =[[UIImage imageNamed:@"back_Icon.png"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    [[UINavigationBar appearance]  setBackIndicatorTransitionMaskImage:backimage];
    [[UINavigationBar appearance]setBackIndicatorImage:backimage];
    
    //  去掉返回按钮文字
    UIBarButtonItem *baritem =[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    UIOffset offset;
    offset.horizontal = -500;
    [baritem setBackButtonTitlePositionAdjustment:offset forBarMetrics:UIBarMetricsDefault];
    
    NSDictionary *titleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:VGray_color,NSForegroundColorAttributeName,[UIFont fontWithName:kFontRegular size:16],NSFontAttributeName, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:titleAttributes];
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count>0) {
        ///第二层viewcontroller 隐藏tabbar
        viewController.hidesBottomBarWhenPushed=YES;
    }
    [super pushViewController:viewController animated:YES];
}
//重写系统
//-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
//}
-(void)dealloc
{
    self.delegate=nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
