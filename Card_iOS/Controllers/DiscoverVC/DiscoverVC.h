//
//  DiscoverVC.h
//  Card_iOS
//
//  Created by 朱封毅 on 30/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "NormalTableView.h"
#import "CommonCell.h"
#import "CommentModel.h"
#import "CommonView.h"
#import "AuthorToolBar.h"
@interface DiscoverVC : NormalTableView

@property(nonatomic,strong)CommonModel  *model;

@property (nonatomic,assign)NSInteger currentIndex;

@property(nonatomic,strong)CommonView  *comView;

@property(nonatomic,strong)NSMutableArray  *commentlistArray;

@property(nonatomic,strong) NSMutableArray *likeArray;

//喜欢和点赞和评论的数量
@property(nonatomic,strong) AuthorToolBar  *Author;

/**
 *  评论的点赞数组
 */
@property(nonatomic,strong) NSMutableArray  *commentLike;

@end
