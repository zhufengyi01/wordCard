//
//  CommentModel.h
//  Card_iOS
//
//  Created by 朱封毅 on 20/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserModel.h"
@interface CommentModel : NSObject

@property(nonatomic,strong) NSString *Id;


@property(nonatomic,strong) NSString *prod_id;


@property(nonatomic,strong) NSString *content;


@property(nonatomic,strong) NSString *created_at;


@property(nonatomic,strong) NSString *created_by;


@property(nonatomic,strong) UserModel *userInfo;



@end
