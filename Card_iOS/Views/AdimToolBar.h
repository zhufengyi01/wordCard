//
//  AdimToolBar.h
//  Card_iOS
//
//  Created by 朱封毅 on 03/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AdimToolBarDelegate  <NSObject>

-(void)handOperationAtIndex:(NSInteger) index;


@end
@interface AdimToolBar : UIView


@property(nonatomic,assign) id <AdimToolBarDelegate> delegate;

@end
