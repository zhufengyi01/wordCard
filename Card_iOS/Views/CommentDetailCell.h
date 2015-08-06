//
//  CommentDetailCell.h
//  Card_iOS
//
//  Created by 朱封毅 on 20/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
#import "ZfyActionSheet.h"
#import "CommonCell.h"
//typedef NS_ENUM(NSInteger, c) <#name#>
@interface CommentDetailCell : UITableViewCell <ZfyActionSheetDelegate>
{
    void (^m_cellClick)(NSInteger buttonIndex);
    CommentModel  *m_model;
    UIView  *buttomLin;
}
@property(nonatomic,strong) UIButton     *headImage ;

@property(nonatomic,strong) UILabel      *nameLable;

@property(nonatomic,strong) UILabel      *commentLable;

@property(nonatomic,strong) UILabel      *timeLable;

@property(nonatomic,strong) UIImageView  *likeIcon;
/**
 *  内容的model
 */
@property(nonatomic,strong) CommonModel  *model;
/**
 *  喜欢数量
 */
@property(nonatomic,strong) UILabel      *likeCount;
/**
 *  评论数组
 */
@property(nonatomic,strong) NSMutableArray  *ConmmentLike;
//计算cell 的高度
+ (float)getCellHeightWithModel:(CommentModel*)model;
- (void)configCellWithmodel:(CommentModel*)model :(void (^)(NSInteger buttonIndex)) cellClick;
@end
