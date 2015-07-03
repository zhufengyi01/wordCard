//
//  CommonView.m
//  Card_iOS
//
//  Created by 朱封毅 on 02/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "CommonView.h"
#import "ZCControl.h"
#import "Constant.h"
#import "NSDate+Extension.h"
@implementation CommonView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor=VLight_GrayColor_apla;
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    self.titleLable =[ZCControl createLabelWithFrame:CGRectMake(10, 10,kDeviceWidth-30, kDeviceWidth-30) Font:20 Text:@"哈哈"];
    self.titleLable.textColor=VGray_color;
    self.titleLable.lineBreakMode=NSLineBreakByTruncatingTail;
    self.titleLable.adjustsFontSizeToFitWidth= NO;
    if (IsIphone5) {
        self.titleLable.font =[UIFont fontWithName:kFontRegular size:18];
    }else if(IsIphone6)
    {
        self.titleLable.font =[UIFont fontWithName:kFontRegular size:20];
    }else if(IsIphone6plus)
    {
        self.titleLable.font =[UIFont fontWithName:kFontRegular size:22];
    }
    self.titleLable.textAlignment=NSTextAlignmentCenter;
    [self addSubview:self.titleLable];
    
    self.topRighlbl =[ZCControl createLabelWithFrame:CGRectMake(self.frame.size.width-100-10,0, 100, 20) Font:12 Text:@"时间"];
    self.topRighlbl.textColor = VGray_color;
    self.topRighlbl.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.topRighlbl];
}
-(void)configCommonView:(CommonModel *)model;
{
    self.model= model;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:self.titleLable.font,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    self.titleLable.attributedText = [[NSAttributedString alloc] initWithString:self.model.word attributes:attributes];
    NSDate  *comfromTimesp =[NSDate dateWithTimeIntervalSince1970:[model.updated_at intValue]];
    NSString  *da = [NSDate timeInfoWithDate:comfromTimesp];
    self.topRighlbl.text=da;
    
}

@end
