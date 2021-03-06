//
//  CommonModel.h
//  Card_iOS
//
//  Created by 朱封毅 on 02/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "BaseModel.h"
@interface CommonModel : BaseModel

//@property(nonatomic,strong) NSString *Id;

@property(nonatomic,strong) NSString *word;

@property(nonatomic,strong) NSString *usage;

@property(nonatomic,strong) NSString *reference;

@property(nonatomic,strong) NSString *link;

@property(nonatomic,strong) NSString *comm_count;

@property(nonatomic,strong) NSString *liked_count;

@property(nonatomic,strong) NSString *shared_count;

@property(nonatomic,strong) NSString *view_count;

@property(nonatomic,strong) NSString *created_by;

@property(nonatomic,strong) NSString *updated_by;

@property(nonatomic,strong) NSString *created_at;

@property(nonatomic,strong) NSString *updated_at;

@property(nonatomic,strong) NSString *status;

@property(nonatomic,strong) UserModel  *userInfo;

@property(nonatomic,strong) NSMutableArray *tagArray;


@end
