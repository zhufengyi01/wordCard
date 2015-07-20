//
//  CommentVC.h
//  Card_iOS
//
//  Created by 朱封毅 on 20/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//


#import "RootViewController.h"
#import "CommentModel.h"
@interface CommentVC : RootViewController


@property(nonatomic,copy) NSString *pro_id;

@property (nonatomic,strong) void(^completeComment)(CommentModel * content);

@property(nonatomic,strong) UITextView  *textView;
@end
