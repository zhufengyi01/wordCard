//
//  MJExtensionConfig.m
//  Card_iOS
//
//  Created by 朱封毅 on 04/08/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "MJExtensionConfig.h"
#import "MJExtension.h"
#import "TagModel.h"
@implementation MJExtensionConfig
/**
 *  这个方法会在MJExtensionConfig加载进内存时调用一次
 */

+(void)load{
    
    /**
     *  所有的模型都继承自BaseModel，所有的id 都执行这个方法
     */
    [BaseModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"Id":@"id"};
    }];
#pragma mark  - 配置model
    /**
     *  这里注意是一个坑，在setupReplacedKeyFromPropertyName替换了名字之后，一定要指明数组包含的模型，也就是说一定要使用下面两个方法结合使用
     */
    [CommonModel setupReplacedKeyFromPropertyName:^NSDictionary *{
         return @{@"userInfo":@"user",
                  @"tagArray":@"tags"};
     }];
    [CommonModel setupObjectClassInArray:^NSDictionary *{
        return @{@"tagArray":[TagModel class]};
    }];
    
//    [TagModel setupReplacedKeyFromPropertyName:^NSDictionary *{
//        return @{@"Id":@"id"};
//    }];
//    [UserModel setupReplacedKeyFromPropertyName:^NSDictionary *{
//        return @{@"Id":@"id"};
//    }];
    [CommentModel  setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"userInfo":@"user"};
    }];
}
@end
