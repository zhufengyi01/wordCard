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
#import "AddCardViewController.h"
#import "LikeButton.h"
#import "LikeModel.h"
#import "WCAlertView.h"
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
        [self createAdminToolBar];
        [self createLikeBarButtoms];
        detail.frame =  CGRectMake(0, kDeviceHeight-40-BUTTON_HEIGHT-kHeightNavigation,kDeviceWidth, 40);
    }else{
        [self createLikeBarButtoms];
    }
}
-(void)handOperationAtIndex:(NSInteger)index
{
    NSArray  *Arr =    [self.pageController viewControllers];
    CurrentVC = (WordDetailListVC *) [Arr objectAtIndex:0];
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
    CurrentVC = (WordDetailListVC *) [Arr objectAtIndex:0];
    CommonModel  *model = CurrentVC.model;
    [self requesttiming:model.Id AndTimeSp:dateString];
}
-(void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    //用户个人页
    if (self.pageType ==WordDetailListVCUserSelf) {
        ZfyActionSheet  *zfy = [[ZfyActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"删除"]];
        zfy.tag = 100;
        [zfy showInView:self.view];
    }else {
        //非个人页
        UserDataCenter  *user = [UserDataCenter shareInstance];
        if ([user.is_admin intValue]>0) {
            //管理员，编辑功能
            ZfyActionSheet  *zfy = [[ZfyActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"编辑"]];
            zfy.tag = 102;
            [zfy showInView:self.view];
        }else{
            //举报功能
        ZfyActionSheet  *zfy = [[ZfyActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"举报"]];
        zfy.tag = 101;
        [zfy showInView:self.view];
        }
    }
}
-(void)ZfyActionSheet:(ZfyActionSheet*)actionSheet ClickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSArray  *Arr =    [self.pageController viewControllers];
    CurrentVC = (WordDetailListVC *) [Arr objectAtIndex:0];
    CommonModel  *model = CurrentVC.model;
    if (actionSheet.tag==100) {
        if (actionSheet.tag==100) {
            
            [WCAlertView showAlertWithTitle:@"确定删除" message:nil customizationBlock:^(WCAlertView *alertView) {
                
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                if (buttonIndex==1) {
                    //删除
                    [self requestDeleteDataWith:model.Id];
                }
            } cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        }
    }else if(actionSheet.tag ==101){
        if (buttonIndex==0) {
            //邮箱举报
            [self sendFeedBackwithmodel:model];
        }
    }else
    {
        if (buttonIndex == 0) {
            //进入添加页
            AddCardViewController  *add = [AddCardViewController new];
            add.model = CurrentVC.model;
            [self.navigationController pushViewController:add animated:YES];
        }
    }
}
//分享
-(void)RightShareEvent
{
    NSArray  *Arr =    [self.pageController viewControllers];
    CurrentVC = (WordDetailListVC *) [Arr objectAtIndex:0];
    [self.pageController childViewControllers];
    float height = CurrentVC.comView.frame.size.height;
    UIImage  *image= [UIImage captureWithView:CurrentVC.comView];
    NSData  *imagedata = UIImagePNGRepresentation(image);
    image = [UIImage imageWithData:imagedata];
    UMShareView  *share =  [[UMShareView alloc]initwithScreenImage:image model:CurrentVC.model andShareHeight:height];
    __weak typeof(self) weakSelf = self;
    share.shareBtnEvent=^(NSInteger buttonIndex,UIImage *capimage)
    {
        NSLog(@"bu======%ld",(long)buttonIndex);
        NSArray  *sharearray =[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline, nil];
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        [[UMSocialControllerService defaultControllerService] setShareText:weakSelf.Currentmodel.word shareImage:capimage socialUIDelegate:weakSelf];
        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:[sharearray  objectAtIndex:buttonIndex]].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
    };
    [share show];
}
#pragma mark  - requestData
//删除个人
-(void)requestDeleteDataWith:(NSString *)word_id
{
    UserDataCenter *User = [UserDataCenter shareInstance];
    NSString *urlString  = [NSString stringWithFormat:@"%@text/delete",kApiBaseUrl];
    NSString *tokenString = [Function getURLtokenWithURLString:urlString];
    NSDictionary  *dict = @{@"user_id":User.user_id,@"prod_id":word_id,KURLTOKEN:tokenString};
    AFHTTPRequestOperationManager  *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue]==0) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            //通知更新
            [[NSNotificationCenter defaultCenter] postNotificationName:AddCardwillGotoUserNotification object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"删除失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error ==%@",error);
        [SVProgressHUD showErrorWithStatus:@"删除失败"];   }];
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
//点赞
-(void)requestLikeWithAuthorId:(NSString *)autuor_id andoperation:(NSNumber *) operation
{
    NSString *status;
    if ([operation isEqual:@0])  {
        status = @"取消赞";
    }else{
        status = @"点赞";
    }
    NSArray  *Arr =  [self.pageController viewControllers];
    CurrentVC = (WordDetailListVC *) [Arr objectAtIndex:0];
    CommonModel  *smodel = CurrentVC.model;
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    NSString *urlString = [NSString stringWithFormat:@"%@/text/up", kApiBaseUrl];
    NSString *tokenString =[Function getURLtokenWithURLString:urlString];
    NSDictionary *parameters=@{@"prod_id":smodel.Id,@"user_id":userCenter.user_id,@"author_id":autuor_id,@"operation":operation,KURLTOKEN:tokenString};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            [SVProgressHUD showSuccessWithStatus:status];
        }else
        {
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showSuccessWithStatus:@"操作失败"];
    }];
}
#pragma mark  - create UI
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
    WordDetailListVC *initialViewController =[self viewControllerAtIndex:self.IndexOfItem];// 得到第一
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
//改变喜欢的状态
-(void)changelikeBarStatus
{
    NSArray  *Arr =    [self.pageController viewControllers];
    CurrentVC = (WordDetailListVC *) [Arr objectAtIndex:0];
    CommonModel  *smodel = CurrentVC.model;
    if (detail) {
        for (id  v  in detail.subviews) {
            if ([v isKindOfClass:[LikeButton class]]) {
                LikeButton *likeBtn = (LikeButton*)(v);
                if (likeBtn.tag==2002) {
                    likeBtn.selected =NO;
                    likeBtn.likeImage.image = [UIImage imageNamed:@"detail_like2"];
                    NSInteger count =[smodel.liked_count integerValue];
                    if (count>0) {
                        likeBtn.likeCountLbl.text = [NSString stringWithFormat:@"%ld",(long)count];
                    }else {
                        likeBtn.likeCountLbl.text = [NSString stringWithFormat:@"点赞"];
                    }
                    for (int i=0;i<self.likeArray.count; i++) {
                        LikeModel *model = self.likeArray[i];
                        if ([model.prod_id intValue]==[smodel.Id intValue]) {
                            likeBtn.selected =YES;
                            likeBtn.likeImage.image = [UIImage imageNamed:@"detail_liked2"];
                        }
                    }
                    
                }
            }
        }
    }
}
-(void)changelikeBarStatusWith:(LikeButton *) likeBtn
{
    NSArray  *Arr =    [self.pageController viewControllers];
    CurrentVC = (WordDetailListVC *) [Arr objectAtIndex:0];
    CommonModel  *smodel = CurrentVC.model;
    if (likeBtn.selected ==YES) {
        //取消点赞
        likeBtn.selected = NO;
        NSInteger  count = [likeBtn.likeCountLbl.text integerValue];
        count=count-1;
        if (count>0) {
            likeBtn.likeCountLbl.text = [NSString stringWithFormat:@"%ld",(long)count];
        }else {
            likeBtn.likeCountLbl.text = [NSString stringWithFormat:@"点赞"];
        }
        likeBtn.likeImage.image = [UIImage imageNamed:@"detail_like2"];
        for (int i=0; i<self.likeArray.count; i++) {
            LikeModel *model = self.likeArray[i];
            if ([model.prod_id intValue] == [smodel.Id intValue]) {
                [self.likeArray removeObject:model];
                break;
            }
        }
        // 修改self.model 的数据
        NSInteger lcount = [smodel.liked_count integerValue];
        lcount = lcount-1;
        smodel.liked_count = [NSString stringWithFormat:@"%ld",(long)lcount];
        if (smodel.userInfo == nil) {
            UserModel *usr=[UserModel new];
            usr.Id = @"4";
            smodel.userInfo = usr;
        }
        [self requestLikeWithAuthorId:smodel.userInfo.Id andoperation:@0];
    }else
    {
        [Function BasicAnimationwithkey:@"transform.scale" Duration:0.25 repeatcont:1 autoresverses:YES fromValue:1.0 toValue:1.5 View:likeBtn.likeImage];
        //点赞
        likeBtn.selected =YES;
        NSInteger  count = [likeBtn.likeCountLbl.text integerValue];
        count=count+1;
        likeBtn.likeCountLbl.text = [NSString stringWithFormat:@"%ld",(long)count];
        likeBtn.likeImage.image = [UIImage imageNamed:@"detail_liked2"];
        LikeModel *lm = [LikeModel new];
        lm.prod_id = smodel.Id;
        if (!self.likeArray) {
            self.likeArray = [NSMutableArray array];
        }
        [self.likeArray addObject:lm];
        NSInteger lcount = [smodel.liked_count integerValue];
        lcount = lcount+1;
        smodel.liked_count = [NSString stringWithFormat:@"%ld",(long)lcount];
        if (smodel.userInfo == nil) {
            UserModel *usr=[UserModel new];
#warning  此处写 4的原因是防止用户信息为空导致的奔溃的问题
            usr.Id = @"4";
            smodel.userInfo = usr;
        }
        [self requestLikeWithAuthorId:smodel.userInfo.Id andoperation:@1];
    }
    CurrentVC.Author.heartlbl.text=[likeBtn.likeCountLbl.text integerValue]==0?@"0":likeBtn.likeCountLbl.text;
    
}
-(void)createLikeBarButtoms
{
    NSArray  *Arr =    [self.pageController viewControllers];
    CurrentVC = (WordDetailListVC *) [Arr objectAtIndex:0];
    CommonModel  *smodel = CurrentVC.model;
    __weak typeof(self) weakself = self;
    detail = [[DetailLikeBar alloc] initWithFrame:CGRectMake(0, kDeviceHeight-40-kHeightNavigation,kDeviceWidth, 40)];
    if (detail) {
        for (id  v  in detail.subviews) {
            if ([v isKindOfClass:[LikeButton class]]) {
                LikeButton *likeBtn = (LikeButton*)(v);
                if (likeBtn.tag==2002) {
                    NSInteger count =[smodel.liked_count integerValue];
                    if (count>0) {
                        likeBtn.likeCountLbl.text = [NSString stringWithFormat:@"%ld",(long)count];
                    }else {
                        likeBtn.likeCountLbl.text = [NSString stringWithFormat:@"点赞"];
                    }
                    for (int i=0;i<self.likeArray.count; i++) {
                        LikeModel *model = self.likeArray[i];
                        likeBtn.selected = NO;
                        if ([model.prod_id intValue]==[smodel.Id intValue]) {
                            likeBtn.selected =YES;
                            likeBtn.likeImage.image = [UIImage imageNamed:@"detail_liked2"];
                        }
                    }
                }
            }
        }
    }
    //__weak __block
    detail.btnClickAtInsex = ^(LikeButton *button)
    {
        switch (button.tag) {
            case 2000:
                [weakself RightShareEvent];
                break;
            case 2001:
            {
                //点击发布评论
                NSArray  *Arr =    [weakself.pageController viewControllers];
                CurrentVC = (WordDetailListVC *) [Arr objectAtIndex:0];
                CommonModel  *model = CurrentVC.model;
                CommentVC *cv =[CommentVC new];
                cv.pro_id =model.Id;
                cv.model = model;
                cv.completeComment = ^(CommentModel *model)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:CommentVCPushlicSucucessNotifation object:nil];
                };
                BaseNavigationViewController *na = [[BaseNavigationViewController alloc] initWithRootViewController:cv];
                [self.navigationController presentViewController:na animated:YES completion:nil];
            }
                break;
            case 2002:
                // 点赞
            {
                NSLog(@"点击了点赞按钮");
                [self changelikeBarStatusWith:button];
            }
                break;
            default:
                break;
        }
        
    };
    [self.view addSubview:detail];
}

-(void)createAdminToolBar
{
    AdimToolBar *tool =[[AdimToolBar alloc]initWithFrame:CGRectMake(0, kDeviceHeight-BUTTON_HEIGHT-kHeightNavigation, kDeviceWidth, BUTTON_HEIGHT)];
    tool.delegate = self;
    [self.view addSubview:tool];
    
}

#pragma  mark - UIPageViewController
//根据下标值获取上一个控制器或者下一个控制器  得到相应的VC对象
- (WordDetailListVC *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.MainArray count] == 0) || (index >= [self.MainArray count])) {
        return nil;
    }
    // 创建一个新的控制器类，并且分配给相应的数据
    WordDetailListVC * dataViewController =[[WordDetailListVC alloc] init];
    dataViewController.model = [self.MainArray objectAtIndex:index];
    dataViewController.likeArray = self.likeArray;
    return dataViewController;
}
// 根据数组元素值，得到下标值
- (NSUInteger)indexOfViewController:(WordDetailListVC *)viewController {
    WordDetailListVC *dataViewController=(WordDetailListVC *)viewController;
    return [self.MainArray indexOfObject:dataViewController.model];
}

// 返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    //获取当前控制器
    
    NSUInteger index = [self indexOfViewController:(WordDetailListVC*)viewController];
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
    NSUInteger index = [self indexOfViewController:(WordDetailListVC *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.MainArray count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    NSLog(@"已经跳转到下一页");
    [self changelikeBarStatus];
    
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
