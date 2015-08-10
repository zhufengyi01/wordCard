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
#import "WCAlertView.h"
#import "LikeModel.h"
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
    NSString *havelike;
    if ([self haveLiked]==YES) {
        havelike = @"取消赞";
    }else{
        havelike = @"点赞";
    }
    if (([usr.user_id intValue]==[m_model.userInfo.Id intValue])||([usr.is_admin intValue]>0)) {
        ZfyActionSheet *ac = [[ZfyActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[havelike,@"回复",@"删除"]];
        ac.tag =100;
        [ac showInView:self];
    }else
    {
        ZfyActionSheet *ac = [[ZfyActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[havelike,@"回复",@"复制"]];
        ac.tag=101;
        [ac showInView:self];
    }
}
#pragma mark   --ZFYActionSheet
-(void)ZfyActionSheet:(ZfyActionSheet*)actionSheet ClickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag ==100) {
        //删除
        if (buttonIndex==2) {
            //删除的时候提示管理员
            [WCAlertView showAlertWithTitle:@"确定删除此评论" message:nil customizationBlock:^(WCAlertView *alertView) {
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                if (buttonIndex==1) {
                    m_cellClick(2000);
                }
            } cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        }else if(buttonIndex==1)
        {
            m_cellClick(2001);
        }else if(buttonIndex==0){
            //点赞
            [self requestLike];
        }
    }else
    {
        //复制
        if (buttonIndex==2) {
            UIPasteboard *paste = [UIPasteboard generalPasteboard];
            paste.string = m_model.content;
            [SVProgressHUD showSuccessWithStatus:@"复制成功"];
        }else if(buttonIndex==1)
        {
            //回复
            m_cellClick(2001);
        }else if(buttonIndex ==0){
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
/**
 *  cell 数据配置
 *
 *  @param model     评论的模型
 *  @param cellClick 点击按钮的blocks
 */
-(void)configCellWithmodel:(CommentModel*)model:(void (^)(NSInteger buttonIndex)) cellClick;
{
    self.likeIcon.hidden  = YES;
    self.likeCount.hidden = YES;
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
        self.likeCount.hidden = NO;
        self.likeCount.text = [NSString stringWithFormat:@"%@",model.up_count];
        /**
         *  配置图片
         */
        [self configLikeImageView];
        //计算点赞的长度
        [self updatelikeCountFrame];
    }
    UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteUserselfComment:)];
    [self addGestureRecognizer:tap];
}
/**
 *  更新喜欢的frame
 */
-(void)updatelikeCountFrame
{
    CGSize  Lisize = [m_model.up_count boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:self.likeCount.font} context:nil].size;
    self.likeCount.frame = CGRectMake(kDeviceWidth-Lisize.width-10, 10,Lisize.width+2, 15);
    self.likeIcon.frame =  CGRectMake(self.likeCount.frame.origin.x-20, 10, 12,12);
}
- (void)configLikeImageView
{
    self.likeIcon.hidden = NO;
    if ([self haveLiked]==YES) {
        self.likeIcon.image  = [UIImage imageNamed:@"Comment_Voted"];
    }else{
        self.likeIcon.image = [UIImage imageNamed:@"Comment_Vote"];
    }
}
/**
 *   是否已经点赞
 *
 *  @return 返回是或者否
 */
- (BOOL)haveLiked
{
    __block BOOL isliked = NO;
    [self.ConmmentLike enumerateObjectsUsingBlock:^(LikeModel *model, NSUInteger idx, BOOL *stop) {
        if ([model.comm_id isEqualToString:m_model.Id]) {
            isliked = YES;
        }
    }];
    return isliked;
}
/**
 *  移除当前的模型
 */
- (void)removecontentUps
{
    //移除赞数组的当前字段
    [self.ConmmentLike enumerateObjectsUsingBlock:^(LikeModel *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.comm_id isEqualToString:m_model.Id]) {
            //把当前的obj从喜欢数组中移除
            [self.ConmmentLike removeObject:obj];
        }
    }];
    [self changemodelwith:-1];
}
/**
 *  添加当前模型
 */
- (void)addcontentUps
{
    //当前的添加进赞数组中
    LikeModel *like = [LikeModel new];
    like.comm_id = m_model.Id;
    [self.ConmmentLike addObject:like];
    [self changemodelwith:1];
}
/**
 *  修改m_model的up_count
 *
 *  @param operation
 */
-(void)changemodelwith:(NSInteger) operation
{
    NSInteger  up_count = [m_model.up_count integerValue];
    up_count = up_count + operation;
    m_model.up_count = [NSString stringWithFormat:@"%ld",(long)up_count];
    if ([m_model.up_count intValue]>0) {
        self.likeIcon.hidden = NO;
        self.likeCount.hidden = NO;
        self.likeCount.text = m_model.up_count;
        [self configLikeImageView];
        [self updatelikeCountFrame];
    }else{
        self.likeIcon.hidden = YES;
        self.likeCount.hidden = YES;
        //self.likeCount.text = m_model.up_count;
    }
}
-(void)cellEvent:(UIButton *) button
{
    m_cellClick(button.tag);
}
//获取每个cell 的高度
+(float)getCellHeightWithModel:(CommentModel*)model
{
    UIFont  * font =[UIFont fontWithName:KFontThin size:14];
    CGSize size = [model.content boundingRectWithSize:CGSizeMake(kDeviceWidth-headwidth-20-10, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:font} context:nil].size;
    return nameheight+size.height+10+timeheight;
}
#pragma mark - 点赞
-(void)requestLike{
    UserDataCenter *User = [UserDataCenter shareInstance];
    NSString *urlString  = [NSString stringWithFormat:@"%@comm-up/up",kApiBaseUrl];
    NSString *tokenString = [Function getURLtokenWithURLString:urlString];
    NSDictionary  *dict = @{@"user_id":User.user_id,@"comm_id":m_model.Id,@"prod_id":m_model.prod_id,@"author_id":m_model.userInfo.Id,KURLTOKEN:tokenString};
    AFHTTPRequestOperationManager  *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue]==0) {
             //[SVProgressHUD showSuccessWithStatus:@"Success"];
            if ([self haveLiked]==YES) {
                //已经点赞，移除掉已经ups 的其中一个字段，同时把 赞－ 1
                [self removecontentUps];
            }else{
                //未赞，
                [self addcontentUps];
            }
        }
        else
        {
           // [SVProgressHUD showErrorWithStatus:@"Success"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error ==%@",error);
        //[SVProgressHUD showErrorWithStatus:@"删除失败"];
    }];
}
-(void)layoutSubviews
{
    self.headImage.frame = CGRectMake(10, 10,30 , 30);
    self.nameLable.frame =CGRectMake(50, 5, 200, 25);
    self.commentLable.frame = CGRectMake(50,30, kDeviceWidth-60,self.frame.size.height-30-20-10);
    self.timeLable.frame = CGRectMake(50,self.frame.size.height-25,110, 15);
    float likeW =self.likeCount.frame.size.width;
    self.likeCount.frame = CGRectMake(kDeviceWidth-likeW-10, 10,likeW, 15);
    self.likeIcon.frame =  CGRectMake(self.likeCount.frame.origin.x-20, 10, 12,12);
    buttomLin.frame = CGRectMake(60, self.frame.size.height-2, kDeviceHeight-60, 1);
    [super layoutSubviews];
}
@end
