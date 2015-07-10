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
#import "UIButton+Block.h"
#import "ZCControl.h"
#import "NoticeViewController.h"
#import "DiscoverViewController.h"
#define  BUTTON_COUNT 5
// 字体设置
#define TITLE_NORMAL_COLOR   [UIColor colorWithRed:20/255.0 green:20/255.0 blue:120/255.0 alpha:1]
#define TITLE_SELECTED_COLOR [UIColor colorWithRed:20/255.0 green:152/255.0 blue:172/255.0 alpha:1]
#define TITLE_FONT           [UIFont fontWithName:kFontRegular size:12.0f]
//标签栏按钮的偏移量
#define TABAR_IMAGE_INSET    UIEdgeInsetsMake(5,0,-5, 0)   
@interface CustomController ()<UITabBarControllerDelegate>
@property(nonatomic,assign) NSInteger  pageIndex;
@end

@implementation CustomController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //接受通知
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(notiMyController) name:AddCardDidSucucessNotification object:nil];
    self.pageIndex=0;
    self.tabBar.backgroundImage =[UIImage imageWithColor:[UIColor whiteColor]];
    NSArray  *classNameArray =[NSArray arrayWithObjects:@"MainViewController",@"DiscoverViewController",@"AddCardViewController",@"NoticeViewController",@"MyViewController", nil];
    //NSArray *titleArray =[NSArray arrayWithObjects:@"首页",@"添加",@"我的", nil];
    NSArray *normalImageArray =[NSArray arrayWithObjects:@"feed_tab_butten_normal.png",@"discovery_tab_button_normal",@"add_tab_butten.png",@"notice_tab_butten_normal.png",@"me_tab_butten_normal.png",nil];
    NSArray *selectImageArray =[NSArray arrayWithObjects:@"feed_tab_butten_press.png",@"movie_tab_butten_press.png",@"add_tab_butten.png",@"notice_tab_butten_press.png",@"me_tab_butten_press.png", nil];
    NSMutableArray  *navigationArray =[[NSMutableArray alloc]init];
    for (int i=0; i<classNameArray.count; i++) {
        UIViewController  *vc =(UIViewController *)[[NSClassFromString(classNameArray[i]) alloc] init];
        //vc.title=titleArray[i];
        UIImage  *normalImage =[UIImage imageNamed:normalImageArray[i]];
        UIImage  *selectImage =[UIImage imageNamed:selectImageArray[i]];
        UIOffset  offoset = UIOffsetMake(0, 300);
        [vc.tabBarItem setTitlePositionAdjustment:offoset];
        vc.tabBarItem.image =[normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [vc.tabBarItem setImageInsets:TABAR_IMAGE_INSET];
        vc.tabBarItem.selectedImage=[selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        BaseNavigationViewController *na =[[BaseNavigationViewController alloc]initWithRootViewController:vc];
        [navigationArray addObject:na];
    }
    self.viewControllers=navigationArray;
    self.delegate = self;
    //UITabBarItem *item = [UITabBarItem appearance];
   // [item setTitleTextAttributes:@{NSForegroundColorAttributeName:TITLE_NORMAL_COLOR, NSFontAttributeName:TITLE_FONT,} forState:UIControlStateNormal];
   // [item setTitleTextAttributes:@{NSForegroundColorAttributeName:TITLE_SELECTED_COLOR, NSFontAttributeName:TITLE_FONT} forState:UIControlStateSelected];
    //设置选择后的高亮
    //self.tabBar.selectionIndicatorImage =[UIImage imageNamed:@"back_Icon@2x.png"];
    //设置背景
    //self.tabBar.backgroundColor = [UIColor blueColor];
    
    UIButton  *discbtn =[ZCControl createButtonWithFrame:CGRectMake(kDeviceWidth/BUTTON_COUNT, 0, kDeviceWidth/BUTTON_COUNT, kHeigthTabBar) ImageName:nil Target:self Action:nil Title:@""];
    discbtn.backgroundColor =[UIColor clearColor];
    [discbtn  addActionHandler:^(NSInteger tag) {
        DiscoverViewController *dis = [DiscoverViewController new];
        BaseNavigationViewController *na =[[BaseNavigationViewController alloc] initWithRootViewController:dis];
        [self presentViewController:na animated:YES completion:nil];
    }];
    [self.tabBar addSubview:discbtn];
    //在系统的第二个按钮上加一个
    UIButton  *Addbtn =[ZCControl createButtonWithFrame:CGRectMake((kDeviceWidth/BUTTON_COUNT)*2, 0, kDeviceWidth/BUTTON_COUNT, kHeigthTabBar) ImageName:nil Target:self Action:nil Title:@""];
    Addbtn.backgroundColor =[UIColor clearColor];
    [Addbtn  addActionHandler:^(NSInteger tag) {
        AddCardViewController *Add = [AddCardViewController new];
        BaseNavigationViewController *na =[[BaseNavigationViewController alloc] initWithRootViewController:Add];
        [self presentViewController:na animated:YES completion:nil];
    }];
    [self.tabBar addSubview:Addbtn];
    
}
//中间
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
-(void)notiMyController
{
    self.selectedIndex = 4;
    [[NSNotificationCenter defaultCenter ] postNotificationName:AddCardwillGotoUserNotification object:nil];
}

@end
