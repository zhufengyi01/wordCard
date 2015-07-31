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
#import "AppDelegate.h"
#import "NoticeViewController.h"
#import "DiscoverViewController.h"
#import "DiscoverVC.h"
#import "MYTabbar.h"
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkUserNewNotification:) name:AppDelegateUserCheckNotification object:nil];
    self.pageIndex=0;
    self.tabBar.backgroundImage =[UIImage imageWithColor:[UIColor whiteColor]];
    NSArray  *classNameArray =[NSArray arrayWithObjects:@"MainViewController",@"DiscoverViewController",@"AddCardViewController",@"NoticeViewController",@"MyViewController", nil];
    //NSArray *titleArray =[NSArray arrayWithObjects:@"首页",@"添加",@"我的", nil];
    NSArray *normalImageArray =[NSArray arrayWithObjects:@"feed_tab_button_normal",@"discovery_tab_button_normal",@"add_tab_button_press",@"notice_tab_button_normal",@"me_tab_button_normal",nil];
    NSArray *selectImageArray =[NSArray arrayWithObjects:@"feed_tab_butten_press",@"movie_tab_butten_press.png",@"add_tab_button_press",@"notice_tab_button_press",@"me_tab_button_press", nil];
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
        DiscoverVC *dis = [DiscoverVC new];
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
    //已经点过了的话，需要取消
    BaseNavigationViewController *base =(BaseNavigationViewController*)viewController;
    NSLog(@"navigation top ===%@",base.topViewController);
    if ([base.topViewController isKindOfClass:[NoticeViewController class]]) {
        //NoticeViewController  *notiVC  = (NoticeViewController*)base.topViewController;
        //notiVC.tabBarItem.badgeValue = nil;
        for (UIView  *bad in self.tabBar.subviews) {
            if ([bad isKindOfClass:[UIView class]]) {
                if (bad.tag ==1000) {
                    [bad removeFromSuperview];
                }
            }
        }
    }
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
//每次启动检测是否有更新
-(void)checkUserNewNotification:(NSNotification*) noti
{
    NSDictionary  *dict = noti.object;
    NSString *badge = [dict objectForKey:AppDelegateUserCheckNotificationKey];
    //self.viewControllers
    NoticeViewController *notice = [self.viewControllers objectAtIndex:3];
    if ([badge intValue]>0) {
        //notice.tabBarItem.badgeValue = badge;
        [self setbageAtIndex:3];
    }
}
-(void)setbageAtIndex:(NSInteger) index;
{
    UIView  *badgeView= [[UIView alloc] initWithFrame:CGRectMake(index * (kDeviceWidth/BUTTON_COUNT)+(kDeviceWidth/BUTTON_COUNT)/2+5, 5, 10, 10)];
    badgeView.backgroundColor = [UIColor redColor];
    badgeView.layer.cornerRadius = 5;
    badgeView.clipsToBounds = YES;
    badgeView.tag = 1000;
    [self.tabBar addSubview:badgeView];
}
@end
