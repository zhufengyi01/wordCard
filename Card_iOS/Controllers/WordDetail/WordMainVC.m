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
#import "UIImage+FX.h"
#import "UIImage+Resize.h"
#import "UIImage+Capture.h"
#import "ZfyActionSheet.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "DetailLikeBar.h"
#import "BaseNavigationViewController.h"
#import "CommentVC.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
@implementation WordMainVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   // self.navigationController.hidesBarsOnSwipe = NO;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //所有的手势
    self.CurrentIndex = 0;
    //[self creatRightNavigationItems:[UIImage imageNamed:@"share"] image2:[UIImage imageNamed:@"more"]];
    [self creatRightNavigationItem:[UIImage imageNamed:@"more"] Title:nil];
    [self createUI];
    //只有从管理员进来才可以有
    if (self.pageType==WordDetailSourcePageAdmin) {
          [self createToolBar];
    }else{
    [self createLikeBarButtoms];
    }
}
-(void)handOperationAtIndex:(NSInteger)index
{
    NSArray  *Arr =    [self.pageController viewControllers];
    CurrentVC = (WordDetailVC *) [Arr objectAtIndex:0];
    CommonModel  *model = CurrentVC.model;
    if (index==0) {
        //屏蔽
        [self requestChangeStageStatusWithweiboId:model.Id StatusType:@"0"];
    }else if(index==1)
    {
        //最新
        [self requestChangeStageStatusWithweiboId:model.Id StatusType:@"5"];
    }else if(index==2)
    {
        //正常
        [self requestChangeStageStatusWithweiboId:model.Id StatusType:@"1"];
        
    }else if(index==3)
    {
        //发现
        [self requestChangeStageStatusWithweiboId:model.Id StatusType:@"2"];
        
    }else if(index==4)
    {
        SelectTimeView *piker =[[SelectTimeView alloc]init];
        piker.delegate = self;
        [piker show];
    }
}
#pragma mark  selected date time
-(void)DatePickerSelectedTime:(NSString *)dateString    {
    //定时到热门，伴随时间戳
    NSArray  *Arr =    [self.pageController viewControllers];
    CurrentVC = (WordDetailVC *) [Arr objectAtIndex:0];
    CommonModel  *model = CurrentVC.model;
    [self requesttiming:model.Id AndTimeSp:dateString];
}
-(void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    ZfyActionSheet  *zfy = [[ZfyActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"举报"]];
    [zfy showInView:self.view];
   
}
-(void)ZfyActionSheet:(id)actionSheet ClickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        //邮箱举报
        NSArray  *Arr =    [self.pageController viewControllers];
        CurrentVC = (WordDetailVC *) [Arr objectAtIndex:0];
        CommonModel  *model = CurrentVC.model;
        [self sendFeedBackwithmodel:model];
    }
}
//分享
-(void)RightShareEvent
{
    NSArray  *Arr =    [self.pageController viewControllers];
    CurrentVC = (WordDetailVC *) [Arr objectAtIndex:0];
    [self.pageController childViewControllers];
    float height = CurrentVC.comView.frame.size.height;
     UIImage  *image= [UIImage captureWithView:CurrentVC.comView];
    NSData  *imagedata = UIImagePNGRepresentation(image);
    image = [UIImage imageWithData:imagedata];
    //image = [image imageScaledToSize:CGSizeMake(image.size.width*0.6, image.size.height*0.6)];
    UMShareView  *share =  [[UMShareView alloc]initwithScreenImage:image model:self.Currentmodel andShareHeight:height];
    __weak typeof(self) weakSelf = self;
    share.shareBtnEvent=^(NSInteger buttonIndex)
    {
        NSLog(@"bu======%ld",(long)buttonIndex);
        NSArray  *sharearray =[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline, nil];
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        [[UMSocialControllerService defaultControllerService] setShareText:weakSelf.Currentmodel.word shareImage:image socialUIDelegate:weakSelf];
        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:[sharearray  objectAtIndex:buttonIndex]].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
    };
    [share show];
}
//定时发送到热门,发送时间戳
-(void)requesttiming:(NSString *)model_id AndTimeSp:(NSString *)timeSp
{
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString =[NSString stringWithFormat:@"%@text/change-status", kApiBaseUrl];
    NSString *tokenString =[Function getURLtokenWithURLString:urlString];
    NSDictionary *parameters=@{@"user_id":userCenter.user_id,@"prod_id":model_id,@"status":@"3",@"updated_at":timeSp,KURLTOKEN:tokenString};
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSString *titSting  =[NSString stringWithFormat:@"定时到热门成功"];
            [SVProgressHUD showSuccessWithStatus:titSting maskType:SVProgressHUDMaskTypeNone];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"操作失败"];
    }];
}
//status 0 屏蔽 1 正常 2 发现/电影页 3 热门 只有到热门页的时候需要传updated_at 5 未审核
-(void)requestChangeStageStatusWithweiboId:(NSString *)word_id StatusType:(NSString *) status
{
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString  *urlString =[NSString stringWithFormat:@"%@text/change-status", kApiBaseUrl];
    NSString *tokenString =[Function getURLtokenWithURLString:urlString];
    NSDictionary *parameters=@{@"user_id":userCenter.user_id,@"prod_id":word_id,@"status":status,KURLTOKEN:tokenString};
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            NSString  *titleString ;
            if ([status intValue]==0) {
                titleString =[NSString stringWithFormat:@"屏蔽成功"];
            }else if ([status intValue]==1)
            {
                titleString=[NSString stringWithFormat:@"移到正常成功"];
            }else if ([status intValue]==2)
            {
                titleString= [NSString stringWithFormat:@"移到发现成功"];
            }else if ([status  intValue]==3)
            {
                titleString  = [NSString stringWithFormat:@"移到热门成功"];
            }
            else if([status intValue]==5)
            {
                titleString =[NSString stringWithFormat:@"发布到最新成功"];
            }
            [SVProgressHUD showSuccessWithStatus:titleString maskType:SVProgressHUDMaskTypeNone];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"操作失败"];
    }];
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
    _pageController.doubleSided = YES;
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
-(void)createLikeBarButtoms
{
    DetailLikeBar  *detail = [[DetailLikeBar alloc] initWithFrame:CGRectMake(0, kDeviceHeight-40-kHeightNavigation,kDeviceWidth, 40)];
    detail.btnClickAtInsex = ^(NSInteger buttonIndex)
    {
        switch (buttonIndex) {
            case 0:
                [self RightShareEvent];
                break;
            case 1:
            {
                NSArray  *Arr =    [self.pageController viewControllers];
                CurrentVC = (WordDetailVC *) [Arr objectAtIndex:0];
                CommonModel  *model = CurrentVC.model;
                CommentVC *cv =[CommentVC new];
                cv.pro_id =model.Id;
                cv.completeComment = ^(CommentModel *model)
                {
                    
                    
                };
                BaseNavigationViewController *na = [[BaseNavigationViewController alloc] initWithRootViewController:cv];
                [self.navigationController presentViewController:na animated:YES completion:nil];
            }
                break;
            case 2:
                break;
            default:
                break;
        }
        
    };
    [self.view addSubview:detail];
}

-(void)createToolBar
{
    AdimToolBar *tool =[[AdimToolBar alloc]initWithFrame:CGRectMake(0, kDeviceHeight-BUTTON_HEIGHT-kHeightNavigation, kDeviceWidth, BUTTON_HEIGHT)];
    tool.delegate = self;
    [self.view addSubview:tool];
    
}

#pragma  mark - UIPageViewController
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

#pragma  mark  -EmailMethod
- (void)sendFeedBackwithmodel:(CommonModel *)model;

{
    //    [self showNativeFeedbackWithAppkey:UMENT_APP_KEY];
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet:model];
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }
    
}
-(void)displayComposerSheet:(CommonModel *)model;

{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];/*MFMailComposeViewController邮件发送选择器*/
    picker.mailComposeDelegate = self;
    // Custom NavgationBar background And set the backgroup picture
    picker.navigationBar.tintColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.5];
    //    picker.navigationBar.tintColor = [UIColor colorWithRed:178.0/255 green:173.0/255 blue:170.0/255 alpha:1.0]; //    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
    //        [picker.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    //    }
    //    NSArray *ccRecipients = [NSArray arrayWithObjects:@"dcj3sjt@gmail.com", nil];
    //    NSArray *bccRecipients = [NSArray arrayWithObjects:@"dcj3sjt@163.com", nil];
    //    [picker setCcRecipients:ccRecipients];
    //    [picker setBccRecipients:bccRecipients];
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@"feedback@redianying.com"];
    [picker setToRecipients:toRecipients];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    UIDevice * myDevice = [UIDevice currentDevice];
    NSString * sysVersion = [myDevice systemVersion];
    // NSString *emailBody = [NSString stringWithFormat:@"\n\n\n\n附属信息：\n\n%@ %@(%@)\n%@ / %@ / %@ IOS%@", appCurName, appCurVersion, appCurVersionNum, @"", @"", @"",  sysVersion];
    
    UserDataCenter  *usercenter=[UserDataCenter shareInstance];
    
    //NSString *emailBody = [NSString stringWithFormat:@"\n您的名字：\n联系电话:\n投诉内容:\n\n\n\n\n-------\n请勿删除以下信息，并提交你拥有此版权的证明--------\n\n 电影:%@\n剧情id:%@\n投诉人id:%@\n投诉昵称:%@\n",@"",@"",usercenter.user_id,usercenter.username];
    NSString *emailBody = [NSString stringWithFormat:@"举报内容: \n%@",model.word];
    
    [picker setTitle:@"@版权问题"];
    [picker setMessageBody:emailBody isHTML:NO];
    [picker setSubject:[NSString stringWithFormat:@"版权投诉"]];/*emailpicker标题主题行*/
    
    [self presentViewController:picker animated:YES completion:nil];
    //        [self.navigationController presentViewController:picker animated:YES completion:nil];
    //        [self.navigationController pushViewController:picker animated:YES];
}
-(void)launchMailAppOnDevice
{
    NSString *recipients = @"mailto:dcj3sjt@gmail.com&subject=Pocket Truth or Dare Support";
    NSString *body = @"&body=email body!";
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}
// 2. Displays an email composition interface inside the application. Populates all the Mail fields.

#pragma mark - 协议的委托方法

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    NSString *msg;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";//@"邮件发送成功";
            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";
            break;
        default:
            msg = @"邮件未发送";
            break;
    }
    [SVProgressHUD showSuccessWithStatus:msg];
    [controller dismissViewControllerAnimated:YES completion:nil];
}



@end
