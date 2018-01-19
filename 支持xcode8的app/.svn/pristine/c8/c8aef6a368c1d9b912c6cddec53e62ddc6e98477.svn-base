//
//  YungouCenterViewController.m
//  My_App
//
//  Created by 邱炯辉 on 16/5/31.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "YungouCenterViewController.h"
#import "YungouCenterViewController.h"
#import "ASIFormDataRequest.h"
#import "CouponsCell.h"
#import "ThirdViewController.h"
#import "UIImageView+WebCache.h"
#import "FreeCouponsViewController.h"



@interface YungouCenterViewController ()<UITableViewDataSource,UITabBarDelegate,UITableViewDelegate,ASIHTTPRequestDelegate>
{
@private UIView * btnView;
@private UIButton * ingButton;//进行中
@private UIButton * comingButton;//即将揭晓
@private UIButton * alreadyButton;//已经揭晓
@private UIView * redView;

@protected NSString * status;
    
   
    UITableView *ShjTableView;
    
    NSMutableArray *dataArray;
    ASIFormDataRequest *request103;
    ASIFormDataRequest *request102;
    ASIFormDataRequest *request_1;
    NSMutableArray *dataArrShangla;
    UIImageView *nothingImage;
     UILabel *nothingLabel;
    
    BOOL requestBool;


}
@end

@implementation YungouCenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"云购中心";
    self.view.backgroundColor=[UIColor whiteColor];
    status=@"0";
    dataArrShangla = [[NSMutableArray alloc]init];
    dataArray = [[NSMutableArray alloc]init];
    [self createView];
}
-(void) createView
{

    /***************** 创建顶部按钮和滑动小条*******************/
    btnView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 47)];
    btnView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:btnView];
    CALayer * mylayer = [btnView layer];
    mylayer.borderColor = [UIColorFromRGB(0XDCDCDC) CGColor];
    mylayer.borderWidth = 1.0f;
    
    ingButton=[MyUtil createBtnFrame:CGRectMake(0, 0, ScreenFrame.size.width/3, 45) title:@"进行中" image:nil highlighImage:nil selectImage:nil target:self action:@selector(topBtnClick:)];
    ingButton.titleLabel.font=[UIFont systemFontOfSize:15];
    [ingButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    ingButton.tag=1001;
    [btnView addSubview:ingButton];
    
    comingButton=[MyUtil createBtnFrame:CGRectMake(ScreenFrame.size.width/3, 0, ScreenFrame.size.width/3, 45) title:@"即将揭晓" image:nil highlighImage:nil selectImage:nil target:self action:@selector(topBtnClick:)];
    comingButton.titleLabel.font=[UIFont systemFontOfSize:15];
    comingButton.tag=1002;
    [btnView addSubview:comingButton];
    
    alreadyButton=[MyUtil createBtnFrame:CGRectMake(ScreenFrame.size.width/3*2, 0, ScreenFrame.size.width/3, 45) title:@"已经揭晓" image:nil highlighImage:nil selectImage:nil target:self action:@selector(topBtnClick:)];
    alreadyButton.titleLabel.font=[UIFont systemFontOfSize:15];
    alreadyButton.tag=1003;
    [btnView addSubview:alreadyButton];
    
    redView=[[UIView alloc] initWithFrame:CGRectMake(20, 45, ScreenFrame.size.width/3-40, 1)];
    redView.backgroundColor=[UIColor redColor];
    [btnView addSubview:redView];
    
    /*****************  tableView 创建 上拉 手势 刷新圈*******************/
    ShjTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    ShjTableView.delegate =self;
    ShjTableView.dataSource= self;
    ShjTableView.showsVerticalScrollIndicator=NO;
    ShjTableView.showsHorizontalScrollIndicator = NO;
    ShjTableView.frame=CGRectMake(0, 47, ScreenFrame.size.width, ScreenFrame.size.height-111);
    ShjTableView.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    //ShjTableView.backgroundColor=[UIColor whiteColor];
    // 加入上拉刷新
    [ShjTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    // 右滑手势返回上一个页面
    UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backBtnClicked)];
    rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
    [ShjTableView addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];
    // xib的模拟转圈
//    [SYObject startLoading];
}
-(void) topBtnClick:(UIButton *) btn
{
    [self setBtnBlack];
    // 进行中
    if(btn.tag==1001)
    {
        [ingButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            redView.frame=CGRectMake(20, 45, ScreenFrame.size.width/3-40, 1);
        }];
        status=@"0";
//        [self downloadData];
    }
    // 即将揭晓
    if(btn.tag==1002)
    {
        [comingButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            redView.frame=CGRectMake(20+ScreenFrame.size.width/3, 45, ScreenFrame.size.width/3-40, 1);
        }];
        status=@"1";
//        [self downloadData];
    }
    // 已经揭晓
    if(btn.tag==1003)
    {
        [alreadyButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            redView.frame=CGRectMake(20+ScreenFrame.size.width/3*2, 45, ScreenFrame.size.width/3-40, 1);
        }];
        status=@"-1";
//        [self downloadData];
    }
}
-(void) setBtnBlack
{
    [ingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [comingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [alreadyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
#pragma mark- ASIrequest
//-(void) downloadData
//{
//    //发起请求优惠劵
//    NSURL *url2 = [NSURL URLWithString:
//                   [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&beginCount=%d&selectCount=%d&status=%@",
//                    FIRST_URL,
//                    COUPONS_URL,
//                    [[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:3],
//                    [[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:1],
//                    0,
//                    20,
//                    status]];
//    request_1=[ASIFormDataRequest requestWithURL:url2];
//    [request_1 setRequestHeaders:[LJControl requestHeaderDictionary]];
//    request_1.tag = 102;
//    request_1.delegate =self;
//    [request_1 setDidFailSelector:@selector(my3_urlRequestFailed:)];
//    [request_1 setDidFinishSelector:@selector(my3_urlRequestSucceeded:)];
//    [request_1 startAsynchronous];
//}
//// 请求成功(第一次进入页面的请求)
//-(void)my3_urlRequestSucceeded:(ASIFormDataRequest *)request{
//    int statuscode2 = [request responseStatusCode];
//    if (statuscode2 == 200) {
//        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"优惠券result===========%@", dicBig);
//        // 每次请求都清空数据源
//        if (dataArray.count!=0) {
//            [dataArray removeAllObjects];
//        }
//        if (dicBig) {
//            if ([[dicBig objectForKey:@"ret"] isEqualToString:@"false"]) {
//            }else{
//                NSArray *arr = [dicBig objectForKey:@"coupon_list"];
//                for(NSDictionary *dic in arr){
//                    ClassifyModel *clas = [[ClassifyModel alloc]init];
//                    clas.coupon_addTime = [dic objectForKey:@"coupon_addTime"];
//                    clas.coupon_amount = [dic objectForKey:@"coupon_amount"];
//                    clas.coupon_beginTime =[dic objectForKey:@"coupon_beginTime"];
//                    clas.coupon_endTime = [dic objectForKey:@"coupon_endTime"];
//                    clas.coupon_id = [dic objectForKey:@"coupon_id"];
//                    clas.coupon_info = [dic objectForKey:@"coupon_info"];
//                    clas.coupon_name = [dic objectForKey:@"coupon_name"];
//                    clas.coupon_order_amount = [dic objectForKey:@"coupon_order_amount"];
//                    clas.coupon_sn = [dic objectForKey:@"coupon_sn"];
//                    clas.coupon_status = [dic objectForKey:@"coupon_status"];
//                    clas.coupon_store_name=[dic objectForKey:@"store_name"];
//                    NSLog(@"coupon_info:%@",clas.coupon_info);
//                    NSLog(@"coupon_status:%@",clas.coupon_status);
//                    NSLog(@"coupon_sn:%@",clas.coupon_sn);
//                    NSLog(@"coupon_name:%@",clas.coupon_name);
//                    NSLog(@"coupon_store_name:%@",clas.coupon_store_name);
//                    [dataArray addObject:clas];
//                }
//            }
//            if (dataArray.count ==0) {
//                ShjTableView.hidden = YES;
//                nothingImage.hidden = NO;
//                nothingLabel.hidden = NO;
//                
//            }else{
//                ShjTableView.hidden = NO;
//                nothingImage.hidden = YES;
//                nothingLabel.hidden = YES;
//            }
//            [SYObject endLoading];
//            // 下载成功刷新数据源
//            [ShjTableView reloadData];
//        }
//    }
//    else{
//        [self failedPrompt:@"请求出错"];
//    }
//}
//-(void)my3_urlRequestFailed:(ASIFormDataRequest *)request{
//    [self failedPrompt:@"网络请求失败"];
//}
//// 失败调用
//-(void)failedPrompt:(NSString *)prompt{
//    [SYObject endLoading];
//    [SYObject failedPrompt:prompt];
//}
#pragma mark - 返回按钮
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    [request103 cancel];
    [self.navigationController popViewControllerAnimated:YES];
}
//#pragma mark - tableView
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (dataArray.count!=0) {
//        return dataArray.count;
//    }
//    return 0;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 132;
//}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request_1 clearDelegatesAndCancel];
    [request102 clearDelegatesAndCancel];
    [request103 clearDelegatesAndCancel];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end


