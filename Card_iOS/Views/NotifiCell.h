//
//  NotifiCell.h
//  Card_iOS
//
//  Created by 朱封毅 on 08/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotiModel.h"



@interface NotifiCell : UITableViewCell


@property(nonatomic,strong) UIButton  *headBtn;

@property(nonatomic,strong) UILabel   *namelbl;

@property(nonatomic,strong) UILabel   *timelbl;

@property(nonatomic,strong) UIView    *badgeparentView;

/*
区别于是赞还是评论
  YES 赞
  NO  评论
*/
@property(nonatomic,assign)BOOL       islike;

@property(nonatomic,strong) NotiModel  *notimodel;


@property(nonatomic,copy) void (^handEvent)(NSInteger index);

@end
