//
//  ShareView.m
//  movienext
//
//  Created by 风之翼 on 15/5/19.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "UMShareView.h"
#import "ZCControl.h"
#import "ShareButton.h"
#import "Constant.h"
#import "Function.h"
#import "MobClick.h"
#import "AFNetworking.h"
#import "UIImage+Color.h"
#import "SVProgressHUD.h"
#import "UIImage+Capture.h"
static CGFloat const shareheadH=40;
static CGFloat const shareCancleH = 40;
static CGFloat const logoHeight   = 20;

@implementation UMShareView

-(instancetype)initwithScreenImage:(UIImage *) screenImage model:(CommonModel *) model andShareHeight:(float) Height;

{
    if ([super init]) {
        _screenImage=screenImage;
        shareheight=Height;
        _model = model;
        self.frame=CGRectMake(0, 0,kDeviceWidth,kDeviceHeight);
        self.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0];
        float height=(kDeviceWidth/4)+shareheight+shareheadH+30+shareCancleH+0;
        backView =[[UIView alloc]initWithFrame:CGRectMake(0,kDeviceHeight, kDeviceWidth, height)];
        if (Height>kDeviceWidth-20) {
            backView.frame = CGRectMake(0,kDeviceHeight,kDeviceWidth,height+kDeviceWidth-20-shareheight);
        }
        backView.userInteractionEnabled=YES;
        backView.backgroundColor = VLight_GrayColor_apla;
        UILabel  *sh_lbl= [ZCControl createLabelWithFrame:CGRectMake(0, 0, kDeviceWidth, 40) Font:14 Text:@"分享"];
        sh_lbl.textColor = VGray_color;
        sh_lbl.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:sh_lbl];
        
        //用于截取点击self的事件
        UITapGestureRecognizer  *t =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
        [backView addGestureRecognizer:t];
        [self addSubview:backView];
        [self createShareView];
        [self createButtomView];
        //添加手势
        UITapGestureRecognizer  *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CancleShareClick)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

//截获点击屏幕的事件
-(void)click
{
    
}
-(void)CancleShareClick
{
    [UIView animateWithDuration:KShow_ShareView_Time animations:^{
        float height=(kDeviceWidth/4)+shareheight+40+30+50;
        backView.frame=CGRectMake(0, kDeviceHeight, kDeviceWidth,height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)createShareView
{
    contentScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(10,40 , kDeviceWidth-20,kDeviceWidth-20)];
    contentScroll.backgroundColor = [UIColor whiteColor];
    contentScroll.contentSize = CGSizeMake(kDeviceWidth-20, kDeviceWidth-20);
    [backView addSubview:contentScroll];
    
    shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,contentScroll.frame.size.width, shareheight+20)];
    shareView.backgroundColor = [UIColor whiteColor];
    if (shareView.frame.size.height>kDeviceWidth-20) {
        contentScroll.contentSize = CGSizeMake(kDeviceWidth-20, shareheight+20);
    }
    [contentScroll addSubview:shareView];
    
    //放置截图
    _ShareimageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,kDeviceWidth-20,shareheight+0)];
    _ShareimageView.backgroundColor=[UIColor redColor];
    _ShareimageView.image=_screenImage;
    _ShareimageView.layer.cornerRadius = 5;
    _ShareimageView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _ShareimageView.clipsToBounds = YES;
    _ShareimageView.contentMode=UIViewContentModeScaleAspectFit;
    [shareView addSubview:_ShareimageView];
    
    //放置logo
    UILabel  *logolbl = [[UILabel alloc] initWithFrame:CGRectMake(0,shareView.frame.size.height-30 , shareView.frame.size.width, 32)];
    logolbl.text = @"瞎扯App";
    logolbl.textColor = [UIColor colorWithRed:190.0/255 green:190.0/255 blue:190.0/255 alpha:1];
    logolbl.font = [UIFont fontWithName:KFontThin size:10];
    logolbl.backgroundColor = View_white_Color;
    logolbl.textAlignment = NSTextAlignmentCenter;
    [shareView addSubview:logolbl];

}
-(void)createButtomView
{
    buttomView=[[UIView alloc]initWithFrame:CGRectMake(10,backView.frame.size.height-(kDeviceWidth/4)-50, kDeviceWidth-20, (kDeviceWidth-20)/4)];
    buttomView.backgroundColor= View_white_Color;
    buttomView.userInteractionEnabled=YES;
    [backView addSubview:buttomView];
#pragma create four button
    NSArray  *imageArray=[NSArray arrayWithObjects:@"wechat_share.png",@"moment_share.png", @"download.png", nil];
    NSArray *titleArray = [NSArray arrayWithObjects:@"微信", @"朋友圈", @"保存", nil];
    for (int i=0; i<3; i++) {
        double   x=((kDeviceWidth-20)/3)*i;
        double   y=0;
        ShareButton  *btn = [[ShareButton alloc] initWithFrame:CGRectMake(x, y, (kDeviceWidth-20)/2, (kDeviceWidth-20)/4)];
        btn.btnimage.image = [UIImage imageNamed:imageArray[i]];
        btn.btnlbl.text    = titleArray[i];
        btn.tag = 10000 +i;
        [buttomView addSubview:btn];
        [btn addTarget:self action:@selector(handShareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
//取消按钮
    UIButton  *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:VGray_color forState:UIControlStateNormal];
    [button setTitleColor:View_white_Color forState:UIControlStateHighlighted];
    button.frame=CGRectMake(20, backView.frame.size.height-50, kDeviceWidth-40, 40);
    button.titleLabel.font =[UIFont fontWithName:kFontRegular size:14];
    button.layer.cornerRadius = 4;
    button.clipsToBounds = YES;
    button.layer.borderColor =VLight_GrayColor.CGColor;
    button.layer.borderWidth = 0.5;
    [button setBackgroundImage:[UIImage imageWithColor:VLight_GrayColor_apla] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:VLight_GrayColor] forState:UIControlStateHighlighted];
    button.layer.cornerRadius = 3;
    [button addTarget:self action:@selector(CancleShareClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:button];
}
//点击分享
-(void)handShareButtonClick:(UIButton *) button
{
    logosupView.hidden=NO;
    UIImage  *image =[UIImage captureWithView:shareView];
    NSData  *imagedata = UIImagePNGRepresentation(image);
    image = [UIImage imageWithData:imagedata];
    NSArray *eventArray = [NSArray arrayWithObjects:@"share_moment", @"share_wechat",@"share_download", nil];
    [MobClick event:eventArray[button.tag-10000]];
    if (button.tag==10000) {
        [self requestStatiWithType:@"2" Pro_id:_model.Id withContent:@"wechat"];
    }else if (button.tag==10001)
    {
        [self requestStatiWithType:@"2" Pro_id:_model.Id withContent:@"moments"];
    }
    else  if (button.tag == 10002) {
        [self requestStatiWithType:@"2" Pro_id:_model.Id withContent:@"save"];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        return;
    }
    self.shareBtnEvent(button.tag-10000,image);
    [self CancleShareClick];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    [self CancleShareClick];
    if (error != NULL)
    {
        [SVProgressHUD showSuccessWithStatus:@"图片保存失败"];
        NSLog(@"保存失败");
    } else {
        [SVProgressHUD showSuccessWithStatus:@"图片保存成功"];
    }
}
//以动画形式显示出分享视图
-(void)show
{
    //添加分享视图到window
    [AppView addSubview:self];
    [UIView animateWithDuration:KShow_ShareView_Time animations:^{
        float height=(kDeviceWidth/4)+shareheight+shareheadH+30+shareCancleH+0;
        if (shareheight>kDeviceWidth-20) {
            height=(kDeviceWidth/4)+kDeviceWidth-20+shareheadH+30+shareCancleH+0;
        }
        backView.frame=CGRectMake(0, kDeviceHeight-height, backView.frame.size.width, backView.frame.size.height);
    } completion:^(BOOL finished) {
        self.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.4];
    }];
}
//统计 复制 保存到本地
-(void)requestStatiWithType:(NSString *) type Pro_id :(NSString *) pro_id withContent:(NSString *) content
{
    UserDataCenter *usr = [UserDataCenter shareInstance];
    NSString *urlString = [NSString stringWithFormat:@"%@counting/create", kApiBaseUrl];
    NSString *tokenString =[Function getURLtokenWithURLString:urlString];
    NSDictionary
    *parameters=@{@"prod_id":pro_id,@"user_id":usr.user_id,@"type":type,@"platform":@"1",@"content":content,KURLTOKEN:tokenString};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            
        }else
        {
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
    }];
}
@end
