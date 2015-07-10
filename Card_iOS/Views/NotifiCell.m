//
//  NotifiCell.m
//  Card_iOS
//
//  Created by 朱封毅 on 08/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "NotifiCell.h"
#import "Constant.h"
#import "ZCControl.h"
#import "UserModel.h"
#import "NSDate+Extension.h"
#import "UIButton+WebCache.h"
@implementation NotifiCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        //self.contentView.backgroundColor = [UIColor grayColor];
        
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    self.headBtn = [ZCControl createButtonWithFrame:CGRectMake(15, 15,40, 40) ImageName:nil Target:self Action:@selector(btnEvent:) Title:nil];
    self.headBtn.layer.cornerRadius= 20;
    self.headBtn.clipsToBounds = YES;
    self.headBtn.tag =201;
    //self.headBtn.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.headBtn];
    
    self.namelbl = [ZCControl createLabelWithFrame:CGRectMake(65, 10, 200, 30) Font:14 Text:@"姓名"];
    self.namelbl.textColor = VBlue_color;
    [self.contentView addSubview:self.namelbl];
    
    self.timelbl = [ZCControl createLabelWithFrame:CGRectMake(65, 45, 100, 20) Font:12 Text:@"时间"];
    self.timelbl.textColor = VGray_color;
    [self.contentView addSubview:self.timelbl];
}
-(void)btnEvent:(UIButton *) sender
{
    self.handEvent((int)sender.tag-200);
}
-(void)configcell
{
    NSURL  *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kUrlAvatar,self.notimodel.OuserInfo.logo]];
    //[self.headBtn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:HeadImagePlaceholder];
    [self.headBtn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:HeadImagePlaceholder options:(SDWebImageRetryFailed|SDWebImageLowPriority)];
    int length = (int)self.notimodel.OuserInfo.username.length;
    if (self.notimodel.OuserInfo.username.length==0) {
        return;
    }
    NSString *str = [NSString stringWithFormat:@"%@ 赞了你",self.notimodel.OuserInfo.username];
    NSMutableAttributedString  *attr = [[NSMutableAttributedString alloc]initWithString:str];
    [attr setAttributes:@{NSForegroundColorAttributeName:VGray_color} range:NSMakeRange(0, length)];
    [self.namelbl setAttributedText:attr];

    NSDate  *comfromTimesp =[NSDate dateWithTimeIntervalSince1970:[self.notimodel.updated_at intValue]];
    NSString  *da = [NSDate timeInfoWithDate:comfromTimesp];
    self.timelbl.text=da;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
}
@end
