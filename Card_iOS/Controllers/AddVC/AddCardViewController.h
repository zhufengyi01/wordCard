//
//  AddCardViewController.h
//  Card_iOS
//
//  Created by 朱封毅 on 02/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "RootViewController.h"

typedef NS_ENUM(NSInteger, addCardVCType)
{
    addCardVCTypeAddCard,  //添加文字
    addCardVCTypeEditCard  //编辑文字
};
@interface AddCardViewController : RootViewController <UITextViewDelegate,UIScrollViewDelegate>
{
}
@property(nonatomic,copy) NSString *tagString;

@property (nonatomic,strong) UITextView  *myTextView;

@property(nonatomic,strong)  UIScrollView *myScrollView;

@property(nonatomic,strong) UITextField   *textField;
@property(nonatomic,strong) UIButton      *SourceButton;

@property (nonatomic,strong) UILabel      *sourceLable;


@end
