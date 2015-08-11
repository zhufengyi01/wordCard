//
//  MainVC.m
//  Card_iOS
//
//  Created by 朱封毅 on 10/08/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "MainVC.h"
#import "UserDataCenter.h"
#import "WordSearchViewController.h"
#import "BaseNavigationViewController.h"
#import "MainAdmList.h"
#import "ZCControl.h"
#import "UIView+ICExtension.h"
#import "Constant.h"
#import "UIView+MJExtension.h"
#import "UIButton+Block.h"
#import "Function.h"
#import "AFNetworking.h"
#import "CommonCell.h"
#import "CommonModel.h"
#import "SVProgressHUD.h"
#import "NSDate+Addition.h"
#import "NSDateFormatter+Make.h"
#import "NSDate+Extension.h"
const CGFloat  Main_NavHeigth  = 45;
const CGFloat  Main_NavWidth   = 200;
@interface MainVC () <UITableViewDelegate,UITableViewDataSource>
//精选
@property(nonatomic,strong)UIButton  *hotbtn;
// 最新
@property(nonatomic,strong)UIButton  *newbtn;
/*
 2个像素的指示器
 */
@property(nonatomic,strong) UIView   *IndicatorView;

@property(nonatomic,strong)UIScrollView  *scrollerView;
@property(nonatomic,assign)NSInteger  pageCount1;
@property(nonatomic,assign)NSInteger  pageCount2;
@property(nonatomic,assign)NSInteger  page1;
@property(nonatomic,assign)NSInteger  page2;
@property(nonatomic,assign)NSInteger  pageSize;
@property(nonatomic,strong)NSMutableArray *temArr1;
@property(nonatomic,strong)NSMutableArray *temArr2;
@end
@interface MainVC ()

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    UserDataCenter  *user = [UserDataCenter shareInstance];
    if ([user.is_admin intValue]>0) {
        [self createLeftSystemNavigationItemWith:UIBarButtonSystemItemEdit];
    }
    [self creatRightNavigationItem:[UIImage imageNamed:@"search"] Title:nil];
    [self setUpNav];
    [self scrollerView];
    [self.scrollerView addSubview:self.tableView1];
    [self.scrollerView addSubview:self.tableView2];
    [self requestData];
}
-(instancetype)init{
    if (self = [super init]) {
        self.pageCount1 = 1;
        self.pageCount2 = 1;
        self.page1 = 1;
        self.page2 = 1;
        self.pageSize = 20;
        self.dataArray1  = [NSMutableArray array];
        self.dataArray2  = [NSMutableArray array];
        self.temArr1 = [NSMutableArray array];
        self.temArr2 = [NSMutableArray array];
    }
    return self;
}
-(void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    BaseNavigationViewController  *na = [[BaseNavigationViewController alloc] initWithRootViewController:[WordSearchViewController new]];
    na.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:na animated:NO completion:nil];
}
-(void)LeftSystemNavigationButtonClick
{
    [self.navigationController pushViewController:[MainAdmList new] animated:YES];
}

#pragma mark  getter Mothod
-(UIView *)IndicatorView
{
    if (_IndicatorView==nil) {
        _IndicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, Main_NavHeigth-2, Main_NavWidth/2, 2)];
        _IndicatorView.userInteractionEnabled = YES;
        _IndicatorView.backgroundColor = VLight_GrayColor;
    }
    return _IndicatorView;
}

-(UIScrollView *)scrollerView{
    if (_scrollerView==nil) {
        _scrollerView  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kHeigthTabBar-kHeightNavigation)];
        _scrollerView.contentSize = CGSizeMake(kDeviceWidth*2, kDeviceHeight-kHeigthTabBar-kHeightNavigation);
        _scrollerView.delegate = self;
        _scrollerView.pagingEnabled = YES;
        _scrollerView.showsHorizontalScrollIndicator  = NO;
        _scrollerView.backgroundColor = [UIColor redColor];
        [self.view addSubview:_scrollerView];
    }
    return _scrollerView;
}
-(UITableView *)tableView1{
    if (_tableView1==nil) {
        _tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kHeightNavigation-kHeigthTabBar)];
        //_tableView1.backgroundColor = [UIColor blueColor];
        _tableView1.delegate =self;
        _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView1.dataSource = self;
    }
    return _tableView1;
}
-(UITableView *)tableView2{
    if (_tableView2==nil) {
        _tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(kDeviceWidth, 0, kDeviceWidth, kDeviceHeight-kHeightNavigation-kHeigthTabBar)];
        //_tableView2.backgroundColor = [UIColor yellowColor];
        _tableView2.delegate =self;
        _tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView2.dataSource = self;
    }
    return _tableView2;
}
-(void)setUpNav
{
    UIView  *naview = [[UIView alloc] initWithFrame:CGRectMake(0, 0,Main_NavWidth, Main_NavHeigth)];
    naview.userInteractionEnabled = YES;
    self.navigationItem.titleView = naview;
    // 热门
    UIButton  *hot = [[UIButton alloc] initWithFrame:CGRectMake(0,0, Main_NavWidth/2, Main_NavHeigth)];
    [hot setTitle:@"精选" forState:UIControlStateNormal];
    [hot setTitleColor:View_Black_Color forState:UIControlStateSelected];
    [hot setTitleColor:VLight_GrayColor forState:UIControlStateNormal];
     hot.titleLabel.font = [UIFont fontWithName:KFontThin size:16];
    hot.selected = YES;
    [naview addSubview:hot];
    [hot addActionHandler:^(NSInteger tag) {
        if (hot.selected ==NO) {
            self.hotbtn.selected = YES;
            self.newbtn.selected =NO;
            [UIView animateWithDuration:0.3 animations:^{
                self.IndicatorView.centerX_ic = self.hotbtn.centerX_ic;
            }];
            [self.scrollerView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        
    }];
    self.hotbtn = hot;
    //最新
    UIButton  *new = [[UIButton alloc] initWithFrame:CGRectMake(Main_NavWidth/2,0, 100, Main_NavHeigth)];
    [new setTitle:@"最新" forState:UIControlStateNormal];
    [new setTitleColor:View_Black_Color forState:UIControlStateSelected];
    new.titleLabel.font = [UIFont fontWithName:KFontThin size:16];
    [new setTitleColor:VLight_GrayColor forState:UIControlStateNormal];
    new.selected = NO;
    [naview addSubview:new];
    [new addActionHandler:^(NSInteger tag) {
        if (new.selected == NO) {
            self.hotbtn.selected = NO;
            self.newbtn.selected =YES;
            [UIView animateWithDuration:0.3 animations:^{
                self.IndicatorView.centerX_ic = self.newbtn.centerX_ic;
            }];
            [self.scrollerView setContentOffset:CGPointMake(kDeviceWidth, 0) animated:YES];
            if (self.temArr2.count==0) {
                [self requestData];
            }
        }
    }];
    self.newbtn = new;
    [naview addSubview:self.IndicatorView];
}
-(void)requestData
{
    UserDataCenter *user = [UserDataCenter shareInstance];
    AFHTTPRequestOperationManager  *manager =[AFHTTPRequestOperationManager manager];
    NSString *url;
    NSDictionary  *parameters;
    if (self.hotbtn.selected==YES) {
        //精选
        url =[NSString stringWithFormat:@"%@text/list-by-status?per-page=%ld&page=%ld",kApiBaseUrl,(long)self.pageSize,(long)self.page1];
            NSString *apitoken=[Function getURLtokenWithURLString:url];
        parameters = @{@"user_id":user.user_id,@"status":@"3",KURLTOKEN:apitoken};
        
    }else{
        //最新
         url =[NSString stringWithFormat:@"%@text/list-recently?per-page=%ld&page=%ld",kApiBaseUrl,(long)self.pageSize,(long)self.page2];
            NSString *apitoken=[Function getURLtokenWithURLString:url];
        parameters = @{@"user_id":user.user_id,KURLTOKEN:apitoken};
    }
  
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject objectForKey:@"code"]) {
            if (self.hotbtn.selected == YES) {
                self.pageCount1 = [[responseObject objectForKey:@"pageCount"] integerValue];
                NSMutableArray *array =[responseObject objectForKey:@"models"];
                self.temArr1 = [CommonModel objectArrayWithKeyValuesArray:array];
                [self computeRecomendSectionView:self.temArr1];
                [self.tableView1 reloadData];
            }else{
                self.pageCount2 = [[responseObject objectForKey:@"pageCount"]integerValue];
                NSMutableArray *array =[responseObject objectForKey:@"models"];
                self.temArr2 = [CommonModel objectArrayWithKeyValuesArray:array];
                [self computeRecomendSectionView:self.temArr2];
                [self.tableView2 reloadData];
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}
-(void)computeRecomendSectionView:(NSMutableArray *) dataArray
{
    if (self.hotbtn.selected ==YES) {
        [self.dataArray1 removeAllObjects];
    }else{
        [self.dataArray2 removeAllObjects];
    }
    NSMutableArray  *array0 =[[NSMutableArray alloc]init];
    CommonModel  *obj0 = [dataArray objectAtIndex:0];
    //把第一个对象加入到数组中
    [array0 insertObject:obj0 atIndex:0];
    if (self.hotbtn.selected ==YES) {
        [self.dataArray1 addObject:array0];
    }else{
        [self.dataArray2 addObject:array0];
    }
    //取出时间
    NSDate  *comfromTimesp =[NSDate dateWithTimeIntervalSince1970:[obj0.updated_at intValue]];
    NSDateFormatter *formatter =[NSDateFormatter  dateFormatterWithFormat:@"YYYY-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+8000"]];
    NSString  *datestr0 = [formatter stringFromDate:comfromTimesp];
    //目的，根据时间，对dataarray进行分组，最后把这个分组存放在self.dataArray0 中
    for (int i = 1; i<dataArray.count; i++) {
        CommonModel *model =[dataArray objectAtIndex:i];
        //取出时间
        NSDate  *comfromTimesp =[NSDate dateWithTimeIntervalSince1970:[model.updated_at intValue]];
        NSDateFormatter *formatter =[NSDateFormatter  dateFormatterWithFormat:@"YYYY-MM-dd"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+8000"]];
        NSString  *datestr = [formatter stringFromDate:comfromTimesp];
        if ([datestr0 isEqualToString:datestr]) {//如果上一项等于下一项的话，把第二项加入到上面的数组
            [array0 addObject:model];
        }
        else
        {
            array0 =[[NSMutableArray alloc]init];
            [array0 addObject:model];
            if (self.hotbtn.selected ==YES) {
                [self.dataArray1 addObject:array0];
            }else{
                [self.dataArray2 addObject:array0];
            }
        }
        datestr0=datestr;
    }
}

#pragma  mark  - TableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.hotbtn.selected ==YES) {
        if (self.dataArray1.count>indexPath.section) {
            NSArray  *Arr = self.dataArray1[indexPath.section];
            if (Arr.count>indexPath.row) {
                return  [CommonCell getCellHeightWithModel:[self.dataArray1[indexPath.section] objectAtIndex:indexPath.row]];
            }
        }
    }else
    {
        if (self.dataArray2.count>indexPath.section) {
            NSArray  *Arr = self.dataArray2[indexPath.section];
            if (Arr.count>indexPath.row) {
                return  [CommonCell getCellHeightWithModel:[self.dataArray2[indexPath.section] objectAtIndex:indexPath.row]];
            }
        }
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.hotbtn.selected == YES) {
        return self.dataArray1.count;
    }else{
        return self.dataArray2.count;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.hotbtn.selected == YES) {
        if (self.dataArray1.count >section) {
            NSArray *Arr = self.dataArray1[section];
            return Arr.count;
        }
    }else{
        if (self.dataArray2.count >section) {
            NSArray *Arr = self.dataArray2[section];
            return Arr.count;
        }
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.hotbtn.selected ==YES) {
        static  NSString *CellID =@"CELL1";
        CommonCell  *cell =[tableView dequeueReusableCellWithIdentifier:CellID];
        if (!cell) {
            cell =[[CommonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        if (self.dataArray1.count >indexPath.section) {
        CommonModel *model =[[self.dataArray1 objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [cell configCellValue:model  RowIndex:indexPath.row];
        }
        return cell;
    }else{
        static  NSString *CellID =@"CELL2";
        CommonCell  *cell =[tableView dequeueReusableCellWithIdentifier:CellID];
        if (!cell) {
            cell =[[CommonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        if (self.dataArray2.count>indexPath.row) {
        CommonModel *model =[[self.dataArray2 objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [cell configCellValue:model  RowIndex:indexPath.row];
        }
        return cell;
    }
    return nil;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView  *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40)];
    headView.backgroundColor =[VLight_GrayColor_apla colorWithAlphaComponent:0.95];//[[UIColor whiteColor] colorWithAlphaComponent:0.95];
    UILabel *hlbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40)];
    hlbl.textColor = VLight_GrayColor;
    hlbl.font = [UIFont fontWithName:KFontThin size:14];
    hlbl.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:hlbl];
    NSMutableArray *Arr;
    if(self.hotbtn.selected == YES)
    {
        Arr = self.dataArray1;
    }else{
        Arr = self.dataArray2;
    }
    if (Arr.count>section) {
        CommonModel *model =[[Arr objectAtIndex:section] objectAtIndex:0];
        //取出时间
        NSDate  *comfromTimesp =[NSDate dateWithTimeIntervalSince1970:[model.updated_at intValue]];
        NSDateFormatter *formatter =[NSDateFormatter  dateFormatterWithFormat:@"MM月dd日"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+8000"]];
        NSString  *datestr0 = [formatter stringFromDate:comfromTimesp];
        hlbl.text= [NSString stringWithFormat:@"%@  %@",datestr0,[comfromTimesp dayFromWeekday]];
    }
    return headView;
}


#pragma mark  - scrollerViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //改变_indicortview 得位置
    if (scrollView == self.scrollerView) {
    CGPoint  point = scrollView.contentOffset;
        NSLog(@"========point - x ===%f",point.x);
     // self.IndicatorView.centerX_ic = (Main_NavWidth/kDeviceWidth)*point.x/2;
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //结束滚动
    if (scrollView == self.scrollerView) {
        CGPoint  point = scrollView.contentOffset;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
