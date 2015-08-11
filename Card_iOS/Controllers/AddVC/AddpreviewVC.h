//
//  AddpreviewVC.h
//  Card_iOS
//
//  Created by 朱封毅 on 31/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "RootViewController.h"
#import "AddCardViewController.h"
#import "CommonModel.h"
//typedef NS_ENUM(NSInteger, addPreviewVCType)
//{
//    addPreviewVCTypeAddCard,
//    addPreviewVCTypeEditCard
//};
@interface AddpreviewVC : RootViewController
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *reference;

@property(nonatomic,assign) addCardVCType  pageType;

@property(nonatomic,strong) CommonModel  *editmodel;

@end
