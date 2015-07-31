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
@interface DiscoverVC : NormalTableView

@property(nonatomic,strong)CommonModel  *model;

@property (nonatomic,assign)NSInteger currentIndex;

@property(nonatomic,strong)CommonView  *comView;

@property(nonatomic,strong)NSMutableArray  *commentlistArray;

@property(nonatomic,strong) NSMutableArray *likeArray;

@end
