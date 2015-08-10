//
//  ShareView.h
//  movienext
//
//  Created by 风之翼 on 15/5/19.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonModel.h"
#define KShow_ShareView_Time 0.3
typedef NS_ENUM(NSInteger, UMShareType)
{
    UMShareTypeDefult,
    UMShareTypeSuccess
};

@protocol UMShareViewDelegate <NSObject>

//-(void)UMShareViewHandClick:(UIButton *) button ShareImage:(UIImage *)shareImage StageInfoModel :(stageInfoModel *) StageInfo;
//取消分享，应该返回上一页
-(void)UMCancleShareClick;

@end

@interface UMShareView : UIView
{

    UIView       *backView;
    UIView       *shareView;  //分享的view
    UILabel      *logoLable;
    UIButton     *wechatSessionBtn;
    UIButton     *wechatTimelineBtn;
    UIButton     *qzoneBtn;
    UIButton     *weiboBtn;
    UIImageView  *_ShareimageView;
    UIView       *buttomView;
    UIView       *logosupView;
    UIImage      *_screenImage;
    float        shareheight;
    UIScrollView  *contentScroll;
    CommonModel  *_model;
}


@property(nonatomic,strong) void(^shareBtnEvent)(NSInteger buttonIndex,UIImage *shareImage);

-(instancetype)initwithScreenImage:(UIImage *) screenImage model:(CommonModel *) model andShareHeight:(float) Height;

@property(nonatomic,assign) UMShareType  pageType;

//分享头部视图
-(void)setShareLable;

-(void)setshareHeightwithFloat:(float) height;

//显示出来
-(void)show;
@end
