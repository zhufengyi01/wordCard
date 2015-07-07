//
//  AddCardViewController.h
//  Card_iOS
//
//  Created by 朱封毅 on 02/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "RootViewController.h"

@interface AddCardViewController : RootViewController <UITextViewDelegate,UIScrollViewDelegate>
{
}
@property(nonatomic,copy) NSString *tagString;

@property (nonatomic,strong) UITextView  *myTextView;

@property(nonatomic,strong)  UIScrollView *myScrollView;

@property(nonatomic,strong) UIButton      *SourceButton;

@property (nonatomic,strong) UILabel      *sourceLable;

@end
