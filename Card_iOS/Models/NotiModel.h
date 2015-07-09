//
//  NotiModel.h
//  Card_iOS
//
//  Created by 朱封毅 on 08/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserModel.h"
@class  TextModel;
@interface NotiModel : NSObject

@property(nonatomic,strong) NSString *Id;
@property(nonatomic,strong) NSString *author_id;
@property(nonatomic,strong) NSString *prod_id;
@property(nonatomic,strong) NSString *created_by;
@property(nonatomic,strong) NSString *updated_by;
@property(nonatomic,strong) NSString *created_at;
@property(nonatomic,strong) NSString *updated_at;
@property(nonatomic,strong) NSString *status;
@property(nonatomic,strong) UserModel *OuserInfo;
@property(nonatomic,strong) TextModel  *textInfo;
@end
