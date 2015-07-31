//
//  WordDetailListVC.h
//  Card_iOS
//
//  Created by 朱封毅 on 20/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "NormalTableView.h"
#import "CommonView.h"
#import "CommentVC.h"
#import "AuthorToolBar.h"
@interface WordDetailListVC : NormalTableView

@property(nonatomic,strong) CommonModel   *model;

@property(nonatomic,strong) CommonView     *comView;

@property(nonatomic,strong) NSMutableArray  *likeArray;

//评论的数组
@property(nonatomic,strong)NSMutableArray   *comentArray;

//喜欢和点赞和评论的数量
@property(nonatomic,strong) AuthorToolBar  *Author;
@end
