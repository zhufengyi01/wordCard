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
        self.layer.cornerRadius = 4;
        self.clipsToBounds = YES;
        self.layer.borderWidth = 0.1;
        self.layer.borderColor=VLight_GrayColor.CGColor;
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    //self.titleLable =[ZCControl createLabelWithFrame:CGRectMake(10, 10,kDeviceWidth-40, kDeviceWidth-30) Font:20 Text:@""];
    self.titleLable = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
    self.titleLable.numberOfLines = 0;
    self.titleLable.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.titleLable.textColor=View_Black_Color;
    self.titleLable.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    self.titleLable.lineBreakMode=NSLineBreakByTruncatingTail;
    self.titleLable.adjustsFontSizeToFitWidth= NO;
    if (IsIphone5) {
        self.titleLable.font = [UIFont fontWithName:KFontThin size:17];
    }else if(IsIphone6)
    {
        self.titleLable.font = [UIFont fontWithName:KFontThin size:18];
    }else if(IsIphone6plus)
    {
        self.titleLable.font = [UIFont fontWithName:KFontThin size:20];
    }
    self.titleLable.textAlignment=NSTextAlignmentJustified;
    [self addSubview:self.titleLable];
    
    self.topRighlbl =[ZCControl createLabelWithFrame:CGRectMake(self.frame.size.width-100-10,0, 100, 20) Font:12 Text:@"时间"];
    self.topRighlbl.textColor = VGray_color;
    self.topRighlbl.textAlignment = NSTextAlignmentRight;
    //[self addSubview:self.topRighlbl];
    if (self.word_Soure) {
        [self.word_Soure removeFromSuperview];
        self.word_Soure = nil;
    }
    self.word_Soure =[[UILabel alloc] initWithFrame:CGRectZero];
    self.word_Soure.textColor = VGray_color;
    self.word_Soure.font = [UIFont fontWithName:KFontThin size:12];
    if (IsIphone6plus) {
        self.word_Soure.font = [UIFont fontWithName:KFontThin size:14];
    }
    self.word_Soure.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.word_Soure];
    
}
-(void)configCommonView:(CommonModel *)model;
{
    self.model= model;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    if (IsIphone6) {
        paragraphStyle.lineSpacing = 5;
    }else if(IsIphone6plus)
    {
        paragraphStyle.lineSpacing = 8;
    }
    NSNumber  *num= [NSNumber numberWithFloat:1.5];
    if (IsIphone6) {
        num = [NSNumber numberWithFloat:2];
    }else if(IsIphone6plus)
    {
        num = [NSNumber numberWithFloat:2.0];
    }
    NSDictionary *attributes = @{
                                 NSFontAttributeName:self.titleLable.font,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 ,NSKernAttributeName:num};
    self.titleLable.attributedText = [[NSAttributedString alloc] initWithString:self.model.word attributes:attributes];
    CGSize Msize =  [TTTAttributedLabel sizeThatFitsAttributedString:self.titleLable.attributedText withConstraints:CGSizeMake(kDeviceWidth-60, MAXFLOAT) limitedToNumberOfLines:0];
    self.frame= CGRectMake(self.frame.origin.x, self.frame.origin.y, kDeviceWidth-20,kDeviceWidth-20);
    if (self.isLongWord ==YES) {
        if (Msize.height<kDeviceWidth-80) {
            self.frame= CGRectMake(self.frame.origin.x, self.frame.origin.y, kDeviceWidth-20,kDeviceWidth-20);
        }else
        {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, kDeviceWidth-20, Msize.height+100);
        }
    }
    if (model.reference==nil) {
        model.reference = @"";
    }
    self.word_Soure.text =[NSString stringWithFormat:@"%@",model.reference];
    //    NSDate  *comfromTimesp =[NSDate dateWithTimeIntervalSince1970:[model.updated_at intValue]];
    //    NSString  *da = [NSDate timeInfoWithDate:comfromTimesp];
    //    self.topRighlbl.text=da;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLable.frame = CGRectMake(15, 40, self.frame.size.width-30,self.frame.size.height-80);
    if(IsIphone6)
    {
      self.titleLable.frame = CGRectMake(16.5, 40, self.frame.size.width-33, self.frame.size.height-80);
    }
    else if(IsIphone6plus)
    {
        self.titleLable.frame = CGRectMake(20, 40, self.frame.size.width-40, self.frame.size.height-80);
    }
    self.word_Soure.frame=CGRectMake(20, self.frame.size.height-40, self.frame.size.width-40, 25);
}

@end
