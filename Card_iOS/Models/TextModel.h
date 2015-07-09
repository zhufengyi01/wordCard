//
//  TextModel.h
//  Card_iOS
//
//  Created by 朱封毅 on 08/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "UserModel.h"
@class UserModel;
@interface TextModel : NSObject
@property(nonatomic,strong) NSString *Id;

@property(nonatomic,strong) NSString *liked_count;

@property(nonatomic,strong) NSString *comm_count;

@property(nonatomic,strong) NSString *word;

@property(nonatomic,strong) NSString *created_by;

@property(nonatomic,strong) NSString *created_at;

@property(nonatomic,strong) NSString *updated_at;

@property(nonatomic,strong) UserModel  *userInfo;

@property(nonatomic,strong) NSMutableArray *TagArray;



@end
