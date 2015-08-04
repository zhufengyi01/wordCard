//
//  UserModel.h
//  Card_iOS
//
//  Created by 朱封毅 on 02/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface UserModel : BaseModel

@property(nonatomic,strong) NSString *Id;

@property(nonatomic,strong) NSString *username;


@property(nonatomic,strong) NSString *logo;

@property(nonatomic,strong) NSString *verified;

@property(nonatomic,strong) NSString *fake;

@property(nonatomic,strong)NSString *brief;


@end
