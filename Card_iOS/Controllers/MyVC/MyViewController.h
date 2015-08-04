//
//  MyViewController.h
//  Card_iOS
//
//  Created by 朱封毅 on 02/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "NormalTableView.h"
@class  UserModel;
typedef NS_ENUM(NSInteger, MyViewControllerPageType)
{
    MyViewControllerPageTypeDefault,
    MyViewControllerPageTypeOthers
};

@interface MyViewController: NormalTableView
{
    UIImageView  *headImage;
    UILabel      *namelbl;
    UILabel      *contentlbl;
    UILabel      *describelbl;
//    UIButton     *likeWorkbtn;
    NSInteger   page1;
    NSInteger   page2;
    NSInteger   pageCount1;
    NSInteger   pageConut2;
}
@property(nonatomic,strong)     UIButton     *addWordbtn;
@property(nonatomic,strong)     UIButton     *likeWorkbtn;
@property(nonatomic,strong)     NSMutableArray   *dataArray1;
@property(nonatomic,strong)     NSMutableArray   *dataArray2;
@property(nonatomic,strong)     NSMutableArray  *likeArray1;
@property(nonatomic,strong)     NSMutableArray  *likeArray2;

@property(nonatomic,assign)     MyViewControllerPageType  pageType;

//进人他人的页面
@property(nonatomic,copy) NSString *author_Id;
/**
 *  从消息和评论页跳转到个人页的整个模型
 */
@property(nonatomic,strong) UserModel  *OuserInfo;

@end
