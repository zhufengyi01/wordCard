//
//  CommentVC.h
//  Card_iOS
//
//  Created by 朱封毅 on 20/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//


#import "RootViewController.h"
#import "CommonModel.h"
#import "CommentModel.h"
typedef NS_ENUM(NSInteger, CommentVCPageType)
{
    CommentVCPageTypeDefault,
    CommentVCPageTypeReply  //评论回复
};
@interface CommentVC : RootViewController <UITextViewDelegate>


@property(nonatomic,copy) NSString *pro_id;

@property (nonatomic,strong) CommonModel  *model;

@property(nonatomic,strong) CommentModel *commentmodel;

@property (nonatomic,strong) void(^completeComment)(CommentModel * content);

@property(nonatomic,strong) UITextView  *textView;

//判断是从评论页还是回复评论页面进去
@property(nonatomic,assign) CommentVCPageType  pageType;
@end
