//
//  CommentModel.h
//  Card_iOS
//
//  Created by 朱封毅 on 20/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "UserModel.h"
@interface CommentModel : BaseModel

@property(nonatomic,strong) NSString *prod_id;

@property(nonatomic,strong) NSString *content;

@property(nonatomic,strong) NSString *up_count;


@property(nonatomic,strong) NSString *created_at;
/***  创建时间
 */
@property(nonatomic,strong) NSString *created_by;
/*** 用户模型对象*/
@property(nonatomic,strong) UserModel *userInfo;


@end
