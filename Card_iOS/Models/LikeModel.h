//
//  UpModel.h
//  Card_iOS
//
//  Created by 朱封毅 on 07/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface  LikeModel: BaseModel

@property(nonatomic,strong) NSString *prod_id;

@property(nonatomic,strong) NSString *comm_id;

@property(nonatomic,strong) NSString *created_by;

@property(nonatomic,strong) NSString *updated_by;

@property(nonatomic,strong) NSString *created_at;

@property(nonatomic,strong) NSString *updated_at;

@property(nonatomic,strong) NSString *status;


@end
