//
//  CommentDetailCell.m
//  Card_iOS
//
//  Created by 朱封毅 on 20/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "CommentDetailCell.h"
#import "UIImageView+WebCache.h"
#import "ZCControl.h"
#import "UIButton+WebCache.h"
#import "Constant.h"
#import "UIImageView+WebCache.h"
#import "NSDate+Extension.h"
#import "UserDataCenter.h"
#import "SVProgressHUD.h"
#import "Function.h"
#import "AFNetworking.h"
static CGFloat  nameheight = 30;
static CGFloat  timeheight = 20;
static CGFloat  headwidth  = 30;
@implementation CommentDetailCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = VLight_GrayColor_apla;
        [self createUI];
    }
    return self;
}
-(void)deleteUserselfComment:(UITapGestureRecognizer *) longp
{
        UserDataCenter *usr = [UserDataCenter shareInstance];
        if (([usr.user_id intValue]==[m_model.userInfo.Id intValue])||([usr.is_admin intValue]>0)) {
            ZfyActionSheet *ac = [[ZfyActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"删除",@"回复",@"点赞"]];
            ac.tag =100;
            [ac showInView:self];
        }else
        {
            ZfyActionSheet *ac = [[ZfyActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"复制",@"回复",@"点赞"]];
            ac.tag=101;
            [ac showInView:self];
        }
}

#pragma mark   --ZFYActionSheet
-(void)ZfyActionSheet:(ZfyActionSheet*)actionSheet ClickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag ==100) {
        //删除
        if (buttonIndex==0) {
            m_cellClick(2000);
        }else if(buttonIndex==1)
        {
            m_cellClick(2001);
        }else if(buttonIndex==2){
            //点赞
            [self requestLike];
        }
    }else
    {
        //复制
        if (buttonIndex==0) {
            UIPasteboard *paste = [UIPasteboard generalPasteboard];
            paste.string = m_model.content;
            [SVProgressHUD showSuccessWithStatus:@"复制成功"];
        }else if(buttonIndex==1)
        {
            //回复
            m_cellClick(2001);
        }else if(buttonIndex ==2){
            //点赞
            [self requestLike];
        }
    }
}
-(void)createUI
{
    self.headImage = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
   //self.headImage.layer.cornerRadius = 15;
   // self.headImage.clipsToBounds = YES;
    self.headImage.tag = 1000;
    //self.headImage.backgroundColor = [UIColor redColor];
    [self.headImage addTarget:self action:@selector(cellEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.headImage];
    
    self.nameLable =[ZCControl createLabelWithFrame:CGRectMake(self.headImage.frame.size.width+self.headImage.frame.origin.x+10,10,200, 30) Font:12 Text:@""];
    self.nameLable.font = [UIFont fontWithName:KFontThin size:14];
    self.nameLable.textColor = VGray_color;
    [self.contentView addSubview:self.nameLable];
    
    
    self.commentLable =[ZCControl createLabelWithFrame:CGRectMake(self.headImage.frame.size.width+self.headImage.frame.origin.x+10, self.nameLable.frame.origin.y+self.nameLable.frame.size.height+10,kDeviceWidth-50-60, 30) Font:12 Text:@""];
    self.commentLable.font = [UIFont fontWithName:KFontThin size:14];
    self.commentLable.textColor = View_Black_Color;
    [self.contentView addSubview:self.commentLable];
    
    self.timeLable =[ZCControl createLabelWithFrame:CGRectMake(self.headImage.frame.size.width+self.headImage.frame.origin.x+10, self.nameLable.frame.origin.y+self.nameLable.frame.size.height+10,kDeviceWidth-50-60, 30) Font:12 Text:@""];
    self.timeLable.font = [UIFont fontWithName:KFontThin size:10];
    self.timeLable.textColor = VLight_GrayColor;
    self.timeLable.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.timeLable];
    
    self.likeIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.likeIcon.image = [UIImage imageNamed:@"Comment_Vote"];
    self.likeIcon.hidden = YES;
    [self.contentView addSubview:self.likeIcon];
    /**
     *  喜欢数量
     *
     */
    self.likeCount =[ZCControl createLabelWithFrame:CGRectMake(self.headImage.frame.size.width+self.headImage.frame.origin.x+10, self.nameLable.frame.origin.y+self.nameLable.frame.size.height+10,kDeviceWidth-50-60, 30) Font:12 Text:@""];
    self.likeCount.frame = CGRectZero;
    self.likeCount.font = [UIFont fontWithName:KFontThin size:10];
    self.likeCount.textColor = VLight_GrayColor;
    //self.likeCount.backgroundColor = [UIColor redColor];
    self.likeCount.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.likeCount];
    
    buttomLin = [[UIView alloc]init];
    buttomLin.backgroundColor = View_BackGround;
    [self.contentView addSubview:buttomLin];
}
-(void)configCellWithmodel:(CommentModel*) model:(void (^)(NSInteger buttonIndex)) cellClick;
{
    m_cellClick = cellClick;
    m_model = model;
    NSURL  *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kUrlAvatar,model.userInfo.logo]];
    [self.headImage sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:HeadImagePlaceholder];
    if (model.userInfo.username) {
        self.nameLable.text = model.userInfo.username;
    }
    self.commentLable.text = model.content;
    NSDate  *comfromTimesp =[NSDate dateWithTimeIntervalSince1970:[model.created_at intValue]];
    NSString  *da = [NSDate timeInfoWithDate:comfromTimesp];
    self.timeLable.text=da;
    if ([m_model.up_count intValue]>0) {
        self.likeCount.text = [NSString stringWithFormat:@"%@",model.up_count];
        self.likeIcon.hidden = NO;
         //计算点赞的长度
        CGSize  Lisize = [m_model.up_count boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:self.likeCount.font} context:nil].size;
        self.likeCount.frame = CGRectMake(0, 0, Lisize.width+2, 15);
    }
   
    UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteUserselfComment:)];
    [self addGestureRecognizer:tap];

}
-(void)cellEvent:(UIButton *) button
{
    m_cellClick(button.tag);
}

//获取每个cell 的高度
+(float)getCellHeightWithModel:(CommentModel*)model
{
//    float  nameheight = 30;
//    float  headwidth  = 30;
//    float  timeheight = 20;
    UIFont  * font =[UIFont fontWithName:KFontThin size:14];
    CGSize size = [model.content boundingRectWithSize:CGSizeMake(kDeviceWidth-headwidth-20-10, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:font} context:nil].size;
    return nameheight+size.height+10+timeheight;
}
#pragma mark - 点赞
-(void)requestLike{
    UserDataCenter *User = [UserDataCenter shareInstance];
    NSString *urlString  = [NSString stringWithFormat:@"%@comm-up/up",kApiBaseUrl];
    NSString *tokenString = [Function getURLtokenWithURLString:urlString];
    NSDictionary  *dict = @{@"user_id":User.user_id,@"prod_id":m_model.Id,@"author_id":m_model.userInfo.Id,KURLTOKEN:tokenString};
    AFHTTPRequestOperationManager  *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue]==0) {
            [SVProgressHUD showSuccessWithStatus:@"sucecess"];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"sucucess"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error ==%@",error);
        [SVProgressHUD showErrorWithStatus:@"删除失败"];
    }];
}

-(void)layoutSubviews
{
    self.headImage.frame = CGRectMake(10, 10,30 , 30);
    self.nameLable.frame =CGRectMake(50, 5, 200, 25);
    self.commentLable.frame = CGRectMake(50,30, kDeviceWidth-60,self.frame.size.height-30-20-10);
    self.timeLable.frame = CGRectMake(50,self.frame.size.height-25,110, 15);
    float likeW =self.likeCount.frame.size.width;
    self.likeCount.frame = CGRectMake(kDeviceWidth-likeW-10, self.frame.size.height-25,likeW, 15);
    self.likeIcon.frame =  CGRectMake(self.likeCount.frame.origin.x-20, self.frame.size.height-25, 15,15);
    buttomLin.frame = CGRectMake(60, self.frame.size.height-2, kDeviceHeight-60, 1);
    [super layoutSubviews];
}
@end
