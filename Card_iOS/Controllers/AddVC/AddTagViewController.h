//
//  AddTagViewController.h
//  Card_iOS
//
//  Created by 朱封毅 on 06/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "RootViewController.h"

@interface AddTagViewController : RootViewController

@property (copy,nonatomic) void (^callback) (NSString *value);


@property(nonatomic,strong) UITextField  *myTextfield;

@end
