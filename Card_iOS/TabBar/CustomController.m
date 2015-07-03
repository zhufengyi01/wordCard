//
//  CustomController.m
//  ZFYTabbarController
//
//  Created by 朱封毅 on 29/06/15.
//  Copyright (c) 2015年 朱封毅. All rights reserved.
//

#import "CustomController.h"
#import "MainViewController.h"
#import "AddCardViewController.h"
#import "BaseNavigationViewController.h"
#import "MyViewController.h"
#import "UIImage+Color.h"
#import "Constant.h"
#import "ZCControl.h"
// 字体设置
#define TITLE_NORMAL_COLOR   [UIColor colorWithRed:20/255.0 green:20/255.0 blue:120/255.0 alpha:1]
#define TITLE_SELECTED_COLOR [UIColor colorWithRed:20/255.0 green:152/255.0 blue:172/255.0 alpha:1]
#define TITLE_FONT           [UIFont fontWithName:kFontRegular size:12.0f]

@interface CustomController ()<UITabBarControllerDelegate>
@property(nonatomic,assign) NSInteger  pageIndex;
@end

@implementation CustomController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageIndex=0;
    self.tabBar.backgroundImage =[UIImage imageWithColor:[UIColor whiteColor]];
    NSArray  *classNameArray =[NSArray arrayWithObjects:@"MainViewController",@"AddCardViewController",@"MyViewController", nil];
    NSArray *titleArray =[NSArray arrayWithObjects:@"首页",@"添加",@"我的", nil];
    NSArray *normalImageArray =[NSArray arrayWithObjects:@"feed_tab_butten_normal.png",@"movie_tab_butten_normal.png",@"me_tab_butten_normal.png",nil];
    NSArray *selectImageArray =[NSArray arrayWithObjects:@"feed_tab_butten_press.png",@"movie_tab_butten_press.png",@"me_tab_butten_press.png", nil];
    NSMutableArray  *navigationArray =[[NSMutableArray alloc]init];
    for (int i=0; i<classNameArray.count; i++) {
        UIViewController  *vc =(UIViewController *)[[NSClassFromString(classNameArray[i]) alloc] init];
        vc.title=titleArray[i];
        UIImage  *normalImage =[UIImage imageNamed:normalImageArray[i]];
        UIImage  *selectImage =[UIImage imageNamed:selectImageArray[i]];
        vc.tabBarItem.image =[normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.selectedImage=[selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        BaseNavigationViewController *na =[[BaseNavigationViewController alloc]initWithRootViewController:vc];
        [navigationArray addObject:na];
    }
    self.viewControllers=navigationArray;
    self.delegate = self;
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:TITLE_NORMAL_COLOR, NSFontAttributeName:TITLE_FONT,} forState:UIControlStateNormal];
    
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:TITLE_SELECTED_COLOR, NSFontAttributeName:TITLE_FONT} forState:UIControlStateSelected];
    //设置选择后的高亮
    //self.tabBar.selectionIndicatorImage =[UIImage imageNamed:@"back_Icon@2x.png"];
    //设置背景
    //self.tabBar.backgroundColor = [UIColor blueColor];
}
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    BaseNavigationViewController *base =(BaseNavigationViewController*)viewController;
    NSLog(@"navigation top ===%@",base.topViewController);
    if ([base.topViewController isKindOfClass:[AddCardViewController class]]) {
        return YES;
    }
    return YES;
}
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"self.select index ===%ld",(long)self.selectedIndex);
    if (self.pageIndex == self.selectedIndex) {
        NSLog(@"刷新");
        [[NSNotificationCenter defaultCenter] postNotificationName:Refresh_MAIN_LIST object:nil];
    }
    self.pageIndex = self.selectedIndex;
    
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
