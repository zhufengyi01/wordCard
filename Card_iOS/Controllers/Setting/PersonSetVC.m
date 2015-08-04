//
//  PersonSetVC.m
//  Card_iOS
//
//  Created by 朱封毅 on 16/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "PersonSetVC.h"
#import "ZCControl.h"
#import "UIButton+Block.h"
#import "Constant.h"
#import "UserDataCenter.h"
#import "UIImage+Color.h"
#import "ZfyActionSheet.h"
#import "WCAlertView.h"
#import "SVProgressHUD.h"
#import "UpYun.h"
#import "AFNetworking.h"
#import "Function.h"
#import "UIImageView+WebCache.h"
@interface PersonSetVC ()<ZfyActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableDictionary   *upyunDict;

}
@property(nonatomic,strong) UIView  *lineView;

@property(nonatomic,strong) UILabel *namelbl;

@property(nonatomic,strong)UIImageView *headImage;
@end
@implementation PersonSetVC
-(void)viewDidLoad
{
    [super viewDidLoad];
    upyunDict= [[NSMutableDictionary alloc]init];
    self.title = @"修改个人资料";
    [self addHeadSection];
    [self addNameSection];
}
-(void)addHeadSection
{
    [WCAlertView setDefaultStyle:WCAlertViewStyleBlack];
    /*[WCAlertView setDefaultCustomiaztonBlock:^(WCAlertView *alertView) {
        alertView.labelTextColor = [UIColor colorWithRed:0.11f green:0.08f blue:0.39f alpha:1.00f];
        alertView.labelShadowColor = [UIColor whiteColor];
        
        UIColor *topGradient = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
        UIColor *middleGradient = [UIColor colorWithRed:0.93f green:0.94f blue:0.96f alpha:1.0f];
        UIColor *bottomGradient = [UIColor colorWithRed:0.89f green:0.89f blue:0.92f alpha:1.00f];
        alertView.gradientColors = @[topGradient,middleGradient,bottomGradient];
        
        alertView.outerFrameColor = [UIColor colorWithRed:250.0f/255.0f green:250.0f/255.0f blue:250.0f/255.0f alpha:1.0f];
        
        alertView.buttonTextColor = [UIColor colorWithRed:0.11f green:0.08f blue:0.39f alpha:1.00f];
        alertView.buttonShadowColor = [UIColor whiteColor];
    }];*/
    UIButton  *bg = [[UIButton alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, 60)];
    bg.userInteractionEnabled  = YES;
    [bg addActionHandler:^(NSInteger tag) {
        ZfyActionSheet *ac = [[ZfyActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:@[@"相册",@"相机"]];
        [ac showInView:self.view];
    }];
    [bg setBackgroundImage:[UIImage imageWithColor:View_white_Color] forState:UIControlStateNormal];
    [bg setBackgroundImage:[UIImage imageWithColor:View_BackGround] forState:UIControlStateHighlighted];
    [self.view addSubview:bg];

    self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
    self.headImage.clipsToBounds = YES;
    self.headImage.contentMode = UIViewContentModeScaleAspectFit;
    //self.headImage.layer.cornerRadius = 20;
    UserDataCenter *usr= [UserDataCenter shareInstance];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kUrlAvatar,usr.logo]] placeholderImage:HeadImagePlaceholder];
    [bg addSubview:self.headImage];
    UILabel  *right =[ZCControl createLabelWithFrame:CGRectMake(kDeviceWidth-130, 0, 120, 60) Font:12 Text:@"修改头像"];
    right.textAlignment =NSTextAlignmentRight;
    right.font = [UIFont fontWithName:KFontThin size:14];
    [bg addSubview:right];

}
-(void)addNameSection
{
    UIButton  *bg2 = [[UIButton alloc] initWithFrame:CGRectMake(0,60, kDeviceWidth, 50)];
    bg2.userInteractionEnabled  = YES;
    [bg2 setBackgroundImage:[UIImage imageWithColor:View_white_Color] forState:UIControlStateNormal];
    [bg2 setBackgroundImage:[UIImage imageWithColor:View_BackGround] forState:UIControlStateHighlighted];
    [self.view addSubview:bg2];
    [bg2 addActionHandler:^(NSInteger tag) {
       [WCAlertView showAlertWithTitle:nil message:@"请输入用户名" customizationBlock:^(WCAlertView *alertView) {
           alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
       } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
           if (buttonIndex==1) {
               self.namelbl.text = [[alertView textFieldAtIndex:0] text];
               [self requestUpdateUserName:self.namelbl.text];
           }
           //NSLog(@"点击了 buttonindex ===%ld",(long)buttonIndex);
       } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }];
    UserDataCenter *usr= [UserDataCenter shareInstance];
    self.namelbl =[ZCControl createLabelWithFrame:CGRectMake(10, 0, 120, 50) Font:12 Text:usr.username];
    self.namelbl.textAlignment =NSTextAlignmentLeft;
    self.namelbl.font = [UIFont fontWithName:KFontThin size:14];
    [bg2 addSubview:self.namelbl];

    
    UILabel  *right =[ZCControl createLabelWithFrame:CGRectMake(kDeviceWidth-130, 0, 120, 50) Font:12 Text:@"修改昵称"];
    right.textAlignment =NSTextAlignmentRight;
    right.font = [UIFont fontWithName:KFontThin size:14];
    [bg2 addSubview:right];


    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 60, kDeviceWidth, 1)];
    line1.backgroundColor =  VLight_GrayColor_apla;
    [self.view addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 110, kDeviceWidth, 1)];
    line2.backgroundColor =  VLight_GrayColor_apla;
    [self.view addSubview:line2];

}
-(void)ZfyActionSheet:(id)actionSheet ClickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex<2) {
        UIImagePickerController  *pick  = [[UIImagePickerController alloc] init];
        if (buttonIndex==2) {
            if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]==NO) {
                return;
            }
        }
        pick.sourceType = buttonIndex;
        pick.allowsEditing = YES;
        pick.delegate = self;
        [self presentViewController:pick animated:YES completion:nil];
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image= [info objectForKey:UIImagePickerControllerEditedImage];
    self.headImage.image = image;
    NSData   *imagedata = UIImagePNGRepresentation(image);
    [picker dismissViewControllerAnimated:YES completion:^{
        [self uploadImageToyun];
    }];
}

#pragma mark  -Request data
-(void)requestUpdateUserlogo:(NSString *) logo
{
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString =[NSString stringWithFormat:@"%@user/change-user-logo", kApiBaseUrl];
    NSString *tokenString =[Function getURLtokenWithURLString:urlString];
    NSDictionary *parameters=@{@"user_id":userCenter.user_id,@"logo":logo,KURLTOKEN:tokenString};
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            [SVProgressHUD showSuccessWithStatus:@"头像修改成功" maskType:SVProgressHUDMaskTypeNone];
            userCenter.logo = [[responseObject objectForKey:@"model"] objectForKey:@"logo"];
           //更新本地
            [Function saveUser:userCenter];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"修改失败，请重试"];
    }];

}
-(void)requestUpdateUserName:(NSString *) newUsername;
{
    UserDataCenter  *userCenter=[UserDataCenter shareInstance];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString =[NSString stringWithFormat:@"%@user/change-username", kApiBaseUrl];
    NSString *tokenString =[Function getURLtokenWithURLString:urlString];
    NSDictionary *parameters=@{@"user_id":userCenter.user_id,@"username":newUsername,KURLTOKEN:tokenString};
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            [SVProgressHUD showSuccessWithStatus:@"昵称修改成功" maskType:SVProgressHUDMaskTypeNone];
            userCenter.username = [[responseObject objectForKey:@"model"] objectForKey:@"username"];
            [Function saveUser:userCenter];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"修改失败，请重试"];
    }];
}
-(void)uploadImageToyun
{
    [SVProgressHUD showProgress:0];
    //执行上传的方法
    UpYun *uy = [[UpYun alloc] init];
    uy.bucket=@"word-avatar";
    uy.passcode=@"lqY/n8m8DoFgKVvZ7Br/9f3YbJ4=";
    uy.successBlocker = ^(id data)
    {
        NSLog(@"图片上传成功%@",data);
        if (upyunDict==nil) {
            upyunDict=[[NSMutableDictionary alloc]init];
        }
        upyunDict=data;
        [self requestUpdateUserlogo:[data objectForKey:@"url"]];
    };
    uy.failBlocker = ^(NSError * error)
    {
        [SVProgressHUD showErrorWithStatus:@"头像上传失败"];
    };
    uy.progressBlocker = ^(CGFloat percent, long long requestDidSendBytes)
    {
        [SVProgressHUD showProgress:percent status:@"正在上传头像"];
        if (percent==1) {
            [SVProgressHUD dismiss];
        }
    };
    
    /**
     *	@brief	根据 UIImage 上传
     */
    // UIImage * image = [UIImage imageNamed:@"image.jpg"];
    //[uy uploadFile:self.upimage saveKey:[self getSaveKey]];
    /**
     *	@brief	根据 文件路径 上传
     */
    //    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    //    NSString* filePath = [resourcePath stringByAppendingPathComponent:@"fileTest.file"];
    //    [uy uploadFile:filePath saveKey:[self getSaveKey]];
    
    /**
     *	@brief	根据 NSDate  上传
     */
    float kCompressionQuality = 0.6;
    NSData *photo = UIImageJPEGRepresentation(self.headImage.image, kCompressionQuality);
    //  NSData * fileData = [NSData dataWithContentsOfFile:filePath];
    [uy uploadFile:photo saveKey:[self getSaveKey]];
    
    
}
-(NSString * )getSaveKey {
    /**
     *	@brief	方式1 由开发者生成saveKey
     */
    NSDate *d = [NSDate date];
    return [NSString stringWithFormat:@"/%d/%d/%.0f.jpg",[self getYear:d],[self getMonth:d],[[NSDate date] timeIntervalSince1970]];
    
    /**
     *	@brief	方式2 由服务器生成saveKey
     */
    //    return [NSString stringWithFormat:@"/{year}/{mon}/{filename}{.suffix}"];
    
    /**
     *	@brief	更多方式 参阅 http://wiki.upyun.com/index.php?title=Policy_%E5%86%85%E5%AE%B9%E8%AF%A6%E8%A7%A3
     */
    
}

- (int)getYear:(NSDate *) date{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    int year=[comps year];
    return year;
}

- (int)getMonth:(NSDate *) date{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    int month = [comps month];
    return month;
}


//-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}
//-(NSMutableArray *)dataArray
//{
//    if () {
//        <#statements#>
//    }
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    switch (indexPath.row) {
//        case 0:
//            return 70;
//            break;
//        case 1:
//            return 50;
//            break;
//        default:
//            break;
//    }
//    return 0;
//}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.dataArray.count;
//}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString  *cellId = @"cellid";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//        switch (indexPath.row) {
//            case 0:
//            {
//                UIImageView *head = [[UIImageView alloc] initWithFrame:CGRectMake(20,20, 30, 30)];
//                head.layer.cornerRadius = 15;
//                head.clipsToBounds = YES;
//                UserDataCenter *usr = [UserDataCenter shareInstance];
//                [head sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kUrlAvatar,usr.logo]] placeholderImage:HeadImagePlaceholder];
//                [cell.contentView addSubview:head];
//                break;
//            }
//            case 1:
//            {
//                break;
//            }
//            default:
//                break;
//        }
//    }
//    cell.textLabel.text =self.dataArray[indexPath.row];
//    return cell;
//}
//-(RETableViewSection*)addUserControl
//{
//    RETableViewSection  *section = [RETableViewSection section];
//    [self.manager addSection:section];
//    
//    RETableViewItem  *titleAndImageItem1 = [RETableViewItem itemWithTitle:@"姓名" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
//        
//    }];
//    
//    RETableViewItem *titleAndImageItem2 = [RETableViewItem itemWithTitle:@"简介" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
//        
//    } accessoryButtonTapHandler:^(RETableViewItem *item) {
//        
//    }];
//    titleAndImageItem1.image = HeadImagePlaceholder;
// 
//    [section addItemsFromArray:@[titleAndImageItem1,titleAndImageItem2]];
//    return section;
//}
@end
