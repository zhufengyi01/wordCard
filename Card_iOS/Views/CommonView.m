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
#import "ZfyActionSheet.h"
#import "SVProgressHUD.h"
#import "UserDataCenter.h"
#import "AFNetworking.h"
#import "Function.h"
@implementation CommonView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor=View_white_Color;
        //self.layer.cornerRadius = 4;
        //self.clipsToBounds = YES;
        //self.layer.borderWidth = 0.1;
        //self.layer.borderColor=VLight_GrayColor.CGColor;
        [self createUI];
        UILongPressGestureRecognizer  *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(copylongpress:)];
        [self addGestureRecognizer:longpress];
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
    self.titleLable.kern =  10;
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
    self.word_Soure.adjustsFontSizeToFitWidth = NO;
    self.word_Soure.numberOfLines = 1;
    
    
    self.word_Soure.font = [UIFont fontWithName:KFontThin size:12];
    if (IsIphone6plus) {
        self.word_Soure.font = [UIFont fontWithName:KFontThin size:14];
    }
    self.word_Soure.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.word_Soure];
    
}
-(void)configCommonView:(CommonModel *)model;
{
    
    //
    //    NSString *searchText = @"// Do any additional setup after loading the view, typically from a nib.";
    //    NSError *error1 = NULL;
    //    NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:@"(?:[^,])*\\." options:NSRegularExpressionCaseInsensitive error:&error1];
    //    NSTextCheckingResult *result1 = [regex1 firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    //    if (result1) {
    //        NSLog(@"~~~~~~~~~~~~~~~~~~%@\n", [searchText substringWithRange:result1.range]);
    //    }
    //
    
    self.model= model;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 15;
    if (IsIphone6) {
        paragraphStyle.lineSpacing = 15;
    }else if(IsIphone6plus)
    {
        paragraphStyle.lineSpacing = 18;
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
    NSMutableAttributedString  *mutableString = [[NSMutableAttributedString alloc] initWithString:self.model.word attributes:attributes];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z0-9_, .']{2,}" options:NSRegularExpressionCaseInsensitive error:&error];
    //匹配首个出现英文的地方
    //NSTextCheckingResult *result = [regex firstMatchInString:self.model.word options:0 range:NSMakeRange(0, [self.model.word length])];
    //if (result) {
    //NSLog(@"=======range ======dfff=======%@\n",[self.model.word substringWithRange:result.range]);
    // [mutableString addAttributes:@{NSKernAttributeName:[NSNumber numberWithInt:0]} range:result.range];
    //}
    //匹配所有出现英文的地方
    NSArray *array =  [regex matchesInString:self.model.word options:NSMatchingReportProgress range:NSMakeRange(0, self.model.word.length)];
    for (NSTextCheckingResult *res  in array) {
        [mutableString addAttributes:@{NSKernAttributeName:[NSNumber numberWithInt:0]} range:res.range];
    }
    self.titleLable.attributedText = mutableString;
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
    if (self.isLongWord==YES) {
        self.word_Soure.numberOfLines = 0;
        CGSize  Ssize = [self.word_Soure.text boundingRectWithSize:CGSizeMake(kDeviceWidth-60, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:self.word_Soure.font} context:nil].size;
        if (Ssize.width>25) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.x, kDeviceWidth-20, self.frame.size.height+Ssize.height);
        }
        
    }
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
    self.word_Soure.frame=CGRectMake(20, self.frame.size.height-40, self.frame.size.width-40, 30);
}
-(void)copylongpress:(UILongPressGestureRecognizer *) longpress
{
    if (longpress.state ==UIGestureRecognizerStateBegan) {
        ZfyActionSheet  *acs = [[ZfyActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"复制"]];
        [acs showInView:self.window];
    }
}
-(void)ZfyActionSheet:(id)actionSheet ClickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        UIPasteboard *paste = [UIPasteboard generalPasteboard];
        paste.string = self.model.word;
        [SVProgressHUD showSuccessWithStatus:@"复制成功"];
        [self requestStatiWithType:@"3" Pro_id:self.model.Id];
    }
}

//统计 复制 保存到本地
-(void)requestStatiWithType:(NSString *) type Pro_id :(NSString *) pro_id
{
    UserDataCenter *usr = [UserDataCenter shareInstance];
    NSString *urlString = [NSString stringWithFormat:@"%@counting/create", kApiBaseUrl];
    NSString *tokenString =[Function getURLtokenWithURLString:urlString];
    NSDictionary
    *parameters=@{@"prod_id":pro_id,@"user_id":usr.user_id,@"type":type,@"platform":@"1",KURLTOKEN:tokenString};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
            
        }else
        {
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
