//
//  OrderListViewController.m
//  My_App
//
//  Created by apple on 15/10/22.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "OrderListViewController.h"
#import "orderCell.h"
#import "ThirdViewController.h"
#import "EnsureestimateViewController.h"
#import "OnlinePayTypeSelectViewController.h"
#import "LoginViewController.h"
#import "CheckViewController.h"
#import "SYOrderDetailsTableViewController.h"
#import "EnsureestimateViewController2.h"
#import "AddEvaluatetTableViewController.h"

@interface OrderListViewController ()<UIGestureRecognizerDelegate>
{
    ASIFormDataRequest *requestList;
    ASIFormDataRequest *requestList2;
    ASIFormDataRequest *requestList3;
    ASIFormDataRequest *requestList4;
    ASIFormDataRequest *requestList5;
    ASIFormDataRequest *requestReceipt;
    ASIFormDataRequest *requestCancel;
    ThirdViewController *third;
    LoginViewController *login;
    int count;
    int count2;
    int count3;
    int count4;
    int count5;
}

@end

@implementation OrderListViewController
-(void)topDesign{
    Top_AllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    Top_AllBtn.frame = CGRectMake(0, 0, ScreenFrame.size.width/5, 44);
    Top_AllBtn.tag = 101;
    [Top_AllBtn setTitle:@"全部" forState:UIControlStateNormal];
    [Top_AllBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [Top_AllBtn addTarget:self action:@selector(TopAction:) forControlEvents:UIControlEventTouchUpInside];
    Top_AllBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [TopView addSubview:Top_AllBtn];
    
    Top_WaitMoney = [UIButton buttonWithType:UIButtonTypeCustom];
    Top_WaitMoney.frame = CGRectMake(ScreenFrame.size.width/5, 0, ScreenFrame.size.width/5, 44);
    Top_WaitMoney.tag = 102;
    [Top_WaitMoney setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [Top_WaitMoney setTitle:@"待付款" forState:UIControlStateNormal];
    [Top_WaitMoney addTarget:self action:@selector(TopAction:) forControlEvents:UIControlEventTouchUpInside];
    Top_WaitMoney.titleLabel.font = [UIFont systemFontOfSize:14];
    [TopView addSubview:Top_WaitMoney];
    
    Top_WaitSend = [UIButton buttonWithType:UIButtonTypeCustom];
    Top_WaitSend.frame = CGRectMake(ScreenFrame.size.width/5*2, 0, ScreenFrame.size.width/5, 44);
    Top_WaitSend.tag = 103;
    [Top_WaitSend setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [Top_WaitSend setTitle:@"待发货" forState:UIControlStateNormal];
    Top_WaitSend.titleLabel.font = [UIFont systemFontOfSize:14];
    [Top_WaitSend addTarget:self action:@selector(TopAction:) forControlEvents:UIControlEventTouchUpInside];
    [TopView addSubview:Top_WaitSend];
    
    Top_WaitGoodsReceipt = [UIButton buttonWithType:UIButtonTypeCustom];
    Top_WaitGoodsReceipt.frame = CGRectMake(ScreenFrame.size.width/5*3, 0, ScreenFrame.size.width/5, 44);
    Top_WaitGoodsReceipt.tag = 104;
    [Top_WaitGoodsReceipt setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [Top_WaitGoodsReceipt setTitle:@"待收货" forState:UIControlStateNormal];
    Top_WaitGoodsReceipt.titleLabel.font = [UIFont systemFontOfSize:14];
    [Top_WaitGoodsReceipt addTarget:self action:@selector(TopAction:) forControlEvents:UIControlEventTouchUpInside];
    [TopView addSubview:Top_WaitGoodsReceipt];
    
    Top_FinishedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    Top_FinishedBtn.frame = CGRectMake(ScreenFrame.size.width/5*4, 0, ScreenFrame.size.width/5, 44);
    Top_FinishedBtn.tag = 105;
    [Top_FinishedBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [Top_FinishedBtn setTitle:@"已完成" forState:UIControlStateNormal];
    Top_FinishedBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [Top_FinishedBtn addTarget:self action:@selector(TopAction:) forControlEvents:UIControlEventTouchUpInside];
    [TopView addSubview:Top_FinishedBtn];
    
    imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(10, 42, ScreenFrame.size.width/5-20, 2)];
    imageLine.backgroundColor = MY_COLOR;
    [TopView addSubview:imageLine];
    
    MyScrollView.bounces = YES;
    MyScrollView.delegate = self;
    MyScrollView.pagingEnabled = YES;
    MyScrollView.userInteractionEnabled = YES;
    MyScrollView.showsHorizontalScrollIndicator = NO;
    MyScrollView.contentSize=CGSizeMake(ScreenFrame.size.width*5,ScreenFrame.size.height-108);
    
    nothingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-108)];
    [MyScrollView addSubview:nothingView];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenFrame.size.width-263)/2, (ScreenFrame.size.height-108-263)/2, 263, 263)];
    imageView.image = [UIImage imageNamed:@"seller_center_nothing"];
    [nothingView addSubview:imageView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.frame.size.height+imageView.frame.origin.y, ScreenFrame.size.width, 20)];
    label.text = @"未找到数据";
    label.textAlignment = NSTextAlignmentCenter;
    [nothingView addSubview:label];
    
    ListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-108) style:UITableViewStylePlain];
    ListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    ListTableView.delegate = self;
    ListTableView.dataSource = self;
    [ListTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [ListTableView addFooterWithTarget:self action:@selector(footerRefresh)];
    [MyScrollView addSubview:ListTableView];
    
    nothingView2 = [[UIView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width, 0, ScreenFrame.size.width, ScreenFrame.size.height-108)];
    [MyScrollView addSubview:nothingView2];
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenFrame.size.width-263)/2, (ScreenFrame.size.height-108-263)/2, 263, 263)];
    imageView2.image = [UIImage imageNamed:@"seller_center_nothing"];
    [nothingView2 addSubview:imageView2];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView2.frame.size.height+imageView2.frame.origin.y, ScreenFrame.size.width, 20)];
    label2.text = @"未找到数据";
    label2.textAlignment = NSTextAlignmentCenter;
    [nothingView2 addSubview:label2];
    
    ListTableView2 = [[UITableView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width*1, 0, ScreenFrame.size.width, ScreenFrame.size.height-108) style:UITableViewStylePlain];
    ListTableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    ListTableView2.delegate = self;
    ListTableView2.dataSource = self;
    [ListTableView2 addHeaderWithTarget:self action:@selector(headerRefresh2)];
    [ListTableView2 addFooterWithTarget:self action:@selector(footerRefresh2)];
    [MyScrollView addSubview:ListTableView2];
    
    nothingView3 = [[UIView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width*2, 0, ScreenFrame.size.width, ScreenFrame.size.height-108)];
    [MyScrollView addSubview:nothingView3];
    UIImageView *imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenFrame.size.width-263)/2, (ScreenFrame.size.height-108-263)/2, 263, 263)];
    imageView3.image = [UIImage imageNamed:@"seller_center_nothing"];
    [nothingView3 addSubview:imageView3];
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView3.frame.size.height+imageView3.frame.origin.y, ScreenFrame.size.width, 20)];
    label3.text = @"未找到数据";
    label3.textAlignment = NSTextAlignmentCenter;
    [nothingView3 addSubview:label3];
    ListTableView3 = [[UITableView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width*2, 0, ScreenFrame.size.width, ScreenFrame.size.height-108) style:UITableViewStylePlain];
    ListTableView3.separatorStyle = UITableViewCellSeparatorStyleNone;
    ListTableView3.delegate = self;
    ListTableView3.dataSource = self;
    [ListTableView3 addHeaderWithTarget:self action:@selector(headerRefresh3)];
    [ListTableView3 addFooterWithTarget:self action:@selector(footerRefresh3)];
    [MyScrollView addSubview:ListTableView3];
    
    nothingView4 = [[UIView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width*3, 0, ScreenFrame.size.width, ScreenFrame.size.height-108)];
    [MyScrollView addSubview:nothingView4];
    UIImageView *imageView4 = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenFrame.size.width-263)/2, (ScreenFrame.size.height-108-263)/2, 263, 263)];
    imageView4.image = [UIImage imageNamed:@"seller_center_nothing"];
    [nothingView4 addSubview:imageView4];
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView4.frame.size.height+imageView4.frame.origin.y, ScreenFrame.size.width, 20)];
    label4.text = @"未找到数据";
    label4.textAlignment = NSTextAlignmentCenter;
    [nothingView4 addSubview:label4];
    
    ListTableView4 = [[UITableView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width*3, 0, ScreenFrame.size.width, ScreenFrame.size.height-108) style:UITableViewStylePlain];
    ListTableView4.separatorStyle = UITableViewCellSeparatorStyleNone;
    ListTableView4.delegate = self;
    ListTableView4.dataSource = self;
    [ListTableView4 addHeaderWithTarget:self action:@selector(headerRefresh4)];
    [ListTableView4 addFooterWithTarget:self action:@selector(footerRefresh4)];
    [MyScrollView addSubview:ListTableView4];
    
    nothingView5 = [[UIView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width*4, 0, ScreenFrame.size.width, ScreenFrame.size.height-108)];
    [MyScrollView addSubview:nothingView5];
    UIImageView *imageView5 = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenFrame.size.width-263)/2, (ScreenFrame.size.height-108-263)/2, 263, 263)];
    imageView5.image = [UIImage imageNamed:@"seller_center_nothing"];
    [nothingView5 addSubview:imageView5];
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView5.frame.size.height+imageView5.frame.origin.y, ScreenFrame.size.width, 20)];
    label5.text = @"未找到数据";
    label5.textAlignment = NSTextAlignmentCenter;
    [nothingView5 addSubview:label5];
    
    ListTableView5 = [[UITableView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width*4, 0, ScreenFrame.size.width, ScreenFrame.size.height-108) style:UITableViewStylePlain];
    ListTableView5.separatorStyle = UITableViewCellSeparatorStyleNone;
    ListTableView5.delegate = self;
    ListTableView5.dataSource = self;
    [ListTableView5 addHeaderWithTarget:self action:@selector(headerRefresh5)];
    [ListTableView5 addFooterWithTarget:self action:@selector(footerRefresh5)];
    [MyScrollView addSubview:ListTableView5];
}
-(void)headerRefresh{
    [ListTableView headerEndRefreshing];
    [self netWork:@""];
}
-(void)footerRefresh{
    count++;
    [ListTableView footerEndRefreshing];
    [self netWork:@""];
}
-(void)headerRefresh2{
    [ListTableView2 headerEndRefreshing];
    [self netWork2:@"10"];
}
-(void)footerRefresh2{
    count2++;
    [ListTableView2 footerEndRefreshing];
    [self netWork2:@"10"];
}
-(void)headerRefresh3{
    [ListTableView3 headerEndRefreshing];
    [self netWork3:@"20"];
}
-(void)footerRefresh3{
    count3++;
    [ListTableView3 footerEndRefreshing];
    [self netWork3:@"20"];
}
-(void)headerRefresh4{
    [ListTableView4 headerEndRefreshing];
    [self netWork4:@"30"];
}
-(void)footerRefresh4{
    count4++;
    [ListTableView4 footerEndRefreshing];
    [self netWork4:@"30"];
}
-(void)headerRefresh5{
    [ListTableView5 headerEndRefreshing];
    [self netWork5:@"50"];
}
-(void)footerRefresh5{
    count5++;
    [ListTableView5 footerEndRefreshing];
    [self netWork5:@"50"];
}
#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    [self createBackBtn];
    self.title = @"我的订单";
    count=1;
    count2=1;
    count3=1;
    count4=1;
    count5=1;
    TopTag = 1;
    CancelTag = -1;
    third = [ThirdViewController sharedUserDefault];
    [Top_AllBtn setTitleColor:RGB_COLOR(241, 83, 83) forState:UIControlStateNormal];
    [Top_WaitMoney setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [Top_WaitGoodsReceipt setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [Top_WaitSend setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [Top_FinishedBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    login = [LoginViewController sharedUserDefault];
    
    [self topDesign];
    
    dataArray = [[NSMutableArray alloc]init];
    dataArray2 = [[NSMutableArray alloc]init];
    dataArray3 = [[NSMutableArray alloc]init];
    dataArray4 = [[NSMutableArray alloc]init];
    dataArray5 = [[NSMutableArray alloc]init];
    
    [self netWork:@""];
    [self netWork2:@"10"];
    [self netWork3:@"20"];
    [self netWork4:@"30"];
    [self netWork5:@"50"];
    
    CGPoint offset = MyScrollView.contentOffset;
    if (login.orderTag == 1) {
        offset.x = ScreenFrame.size.width;
        MyScrollView.contentOffset = offset;
    }else if(login.orderTag == 2){
        offset.x = ScreenFrame.size.width*2;
        MyScrollView.contentOffset = offset;
    }else if(login.orderTag == 3){
        offset.x = ScreenFrame.size.width*3;
        MyScrollView.contentOffset = offset;
    }else if(login.orderTag == 4){
        offset.x = ScreenFrame.size.width*4;
        MyScrollView.contentOffset = offset;
    }else if(login.orderTag == 5){
        
    }else{
        offset.x = 0;
        MyScrollView.contentOffset = offset;
    }

}
#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1){  //关闭主界面的右滑返回
        return NO;
    }else{
        
        return YES;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    [SYObject endLoading];
    //修复数据显示不全的问题
    if (login.orderTag == 1) {
        [self clickedOtherWithLast:Top_WaitMoney];
    }else if(login.orderTag == 2){
        [self clickedOtherWithLast:Top_WaitSend];
    }else if(login.orderTag == 3){
        [self clickedOtherWithLast:Top_WaitGoodsReceipt];
    }else if(login.orderTag == 4){
        [self clickedOtherWithLast:Top_FinishedBtn];
    }else if(login.orderTag == 0){
        [self clickedOtherWithLast:Top_AllBtn];
    }else{
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [self saveOrderTag];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 便民方法
-(NSArray *)getCurrentArray{
    CGPoint offset = MyScrollView.contentOffset;
    NSInteger index = offset.x / ScreenFrame.size.width;
    NSArray *curArray;
    switch (index) {
        case 0:{
            curArray = dataArray;
            break;
        }
        case 1:{
            curArray = dataArray2;
            break;
        }
        case 2:{
            curArray = dataArray3;
            break;
        }
        case 3:{
            curArray = dataArray4;
            break;
        }
        case 4:{
            curArray = dataArray5;
            break;
        }
        default:{
            break;
        }
    }
    return curArray;
}
-(void)saveOrderTag{
    login = [LoginViewController sharedUserDefault];
    CGPoint offset = MyScrollView.contentOffset;
    NSInteger pageIndex = offset.x / ScreenFrame.size.width;
    login.orderTag = pageIndex;
}
-(void)clickedOtherWithLast:(UIButton *)lastBtn{
    NSMutableArray *otherBtnArr = [@[Top_AllBtn,Top_FinishedBtn,Top_WaitGoodsReceipt,Top_WaitMoney,Top_WaitSend] mutableCopy];
    if (lastBtn) {
        [otherBtnArr removeObject:lastBtn];
    }
    for (UIButton *btn in otherBtnArr) {
        [self TopAction:btn];
    }
    if (lastBtn) {
        [self TopAction:lastBtn];
    }
}
#pragma mark - 网络
-(void)cancelNetWorking{
//    loadingView.hidden = NO;
    [SYObject startLoading];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ORDERCANCEL_URL]];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[USER_INFORMATION objectAtIndex:3] forKey:@"user_id"];
    [request setPostValue:[USER_INFORMATION objectAtIndex:1] forKey:@"token"];
    [request setPostValue:third.select_order_id forKey:@"order_id"];
    [request setRequestHeaders:[LJControl requestHeaderDictionary]];
    request.delegate =self;
    [request setDidFailSelector:@selector(RequestFailed:)];
    [request setDidFinishSelector:@selector(requestCancelSucceeded:)];
    [request startAsynchronous];
    
}
-(void)netWork:(NSString *)order_status{
//    loadingView.hidden = NO;
    [SYObject startLoading];
    NSArray *valueArr = [[NSArray alloc]initWithObjects:[USER_INFORMATION objectAtIndex:3],[USER_INFORMATION objectAtIndex:1],@"0",@"0",[NSString stringWithFormat:@"%d",count*20],order_status, nil];
    NSArray *keyArr = [[NSArray alloc]initWithObjects:@"user_id",@"token",@"order_cat",@"beginCount",@"selectCount",@"order_status", nil];
    requestList = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,ORDER_URL] setKey:keyArr setValue:valueArr];
    
    [requestList setDelegate:self];
    [requestList setDidFailSelector:@selector(RequestFailed:)];
    [requestList setDidFinishSelector:@selector(requestListSucceeded:)];
    [requestList startAsynchronous];
}
-(void)netWork2:(NSString *)order_status{
//    loadingView.hidden = NO;
    [SYObject startLoading];
    NSArray *valueArr = [[NSArray alloc]initWithObjects:[USER_INFORMATION objectAtIndex:3],[USER_INFORMATION objectAtIndex:1],@"0",@"0",[NSString stringWithFormat:@"%d",count2*20],order_status, nil];
    NSArray *keyArr = [[NSArray alloc]initWithObjects:@"user_id",@"token",@"order_cat",@"beginCount",@"selectCount",@"order_status", nil];
    requestList2 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,ORDER_URL] setKey:keyArr setValue:valueArr];
    
    [requestList2 setDelegate:self];
    [requestList2 setDidFailSelector:@selector(RequestFailed:)];
    [requestList2 setDidFinishSelector:@selector(requestListSucceeded2:)];
    [requestList2 startAsynchronous];
}
-(void)requestListSucceeded2:(ASIFormDataRequest *)request{
    if ([request responseStatusCode] == 200) {
        NSDictionary *dicBig = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"订单2:%@",dicBig);
        NSArray *arr = [dicBig objectForKey:@"order_list"];
        if (dataArray2.count!=0) {
            [dataArray2 removeAllObjects];
        }
        for (NSDictionary *dic in arr) {
            Model *shjM = [[Model alloc]init];
            shjM.order_addTime = [dic objectForKey:@"addTime"];
            shjM.order_id = [dic objectForKey:@"order_id"];
            shjM.order_num = [dic objectForKey:@"order_num"];
            shjM.order_status = [dic objectForKey:@"order_status"];
            shjM.order_total_price = [dic objectForKey:@"order_total_price"];
            shjM.order_photo_list = [dic objectForKey:@"photo_list"];
            shjM.order_name_list = [dic objectForKey:@"name_list"];
            shjM.order_ship_price = [dic objectForKey:@"ship_price"];
            shjM.order_paytype = [dic objectForKey:@"payType"];
            [dataArray2 addObject:shjM];
        }
        NSLog(@"dadada:%@",dataArray2);
        if(dataArray2.count!=0){
            ListTableView2.hidden = NO;
            nothingView2.hidden = YES;
        }else{
            nothingView2.hidden = NO;
            ListTableView2.hidden = YES;
        }
        [ListTableView2 reloadData];
    }else {
        [SYObject failedPrompt:@"请求出错，请重试"];
    }
//    loadingView.hidden = YES;
    [SYObject endLoading];
}
-(void)netWork3:(NSString *)order_status{
//    loadingView.hidden = NO;
    [SYObject startLoading];
    NSArray *valueArr = [[NSArray alloc]initWithObjects:[USER_INFORMATION objectAtIndex:3],[USER_INFORMATION objectAtIndex:1],@"0",@"0",[NSString stringWithFormat:@"%d",count3*20],order_status, nil];
    NSArray *keyArr = [[NSArray alloc]initWithObjects:@"user_id",@"token",@"order_cat",@"beginCount",@"selectCount",@"order_status", nil];
    requestList3 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,ORDER_URL] setKey:keyArr setValue:valueArr];
    
    [requestList3 setDelegate:self];
    [requestList3 setDidFailSelector:@selector(RequestFailed:)];
    [requestList3 setDidFinishSelector:@selector(requestListSucceeded3:)];
    [requestList3 startAsynchronous];
}
-(void)requestListSucceeded3:(ASIFormDataRequest *)request{
    if ([request responseStatusCode] == 200) {
        NSDictionary *dicBig = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"订单3:%@",dicBig);
        NSArray *arr = [dicBig objectForKey:@"order_list"];
        if (dataArray3.count!=0) {
            [dataArray3 removeAllObjects];
        }
        for (NSDictionary *dic in arr) {
            Model *shjM = [[Model alloc]init];
            shjM.order_addTime = [dic objectForKey:@"addTime"];
            shjM.order_id = [dic objectForKey:@"order_id"];
            shjM.order_num = [dic objectForKey:@"order_num"];
            shjM.order_status = [dic objectForKey:@"order_status"];
            shjM.order_total_price = [dic objectForKey:@"order_total_price"];
            shjM.order_photo_list = [dic objectForKey:@"photo_list"];
            shjM.order_name_list = [dic objectForKey:@"name_list"];
            shjM.order_ship_price = [dic objectForKey:@"ship_price"];
            shjM.order_paytype = [dic objectForKey:@"payType"];
            [dataArray3 addObject:shjM];
        }
        NSLog(@"dadada:%@",dataArray3);
        if(dataArray3.count!=0){
            ListTableView3.hidden = NO;
            nothingView3.hidden = YES;
        }else{
            nothingView3.hidden = NO;
            ListTableView3.hidden = YES;
        }
        [ListTableView3 reloadData];
    }else {
//        [SYObject failedPrompt:@"请求出错，请重试"];
    }
//    loadingView.hidden = YES;
    [SYObject endLoading];
}
-(void)netWork4:(NSString *)order_status{
//    loadingView.hidden = NO;
    [SYObject startLoading];
    NSArray *valueArr = [[NSArray alloc]initWithObjects:[USER_INFORMATION objectAtIndex:3],[USER_INFORMATION objectAtIndex:1],@"0",@"0",[NSString stringWithFormat:@"%d",count4*20],order_status, nil];
    NSArray *keyArr = [[NSArray alloc]initWithObjects:@"user_id",@"token",@"order_cat",@"beginCount",@"selectCount",@"order_status", nil];
    requestList4 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,ORDER_URL] setKey:keyArr setValue:valueArr];
    
    [requestList4 setDelegate:self];
    [requestList4 setDidFailSelector:@selector(RequestFailed:)];
    [requestList4 setDidFinishSelector:@selector(requestListSucceeded4:)];
    [requestList4 startAsynchronous];
}
-(void)requestListSucceeded4:(ASIFormDataRequest *)request{
    if ([request responseStatusCode] == 200) {
        NSDictionary *dicBig = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"订单4:%@",dicBig);
        NSArray *arr = [dicBig objectForKey:@"order_list"];
        if (dataArray4.count!=0) {
            [dataArray4 removeAllObjects];
        }
        for (NSDictionary *dic in arr) {
            Model *shjM = [[Model alloc]init];
            shjM.order_addTime = [dic objectForKey:@"addTime"];
            shjM.order_id = [dic objectForKey:@"order_id"];
            shjM.order_num = [dic objectForKey:@"order_num"];
            shjM.order_status = [dic objectForKey:@"order_status"];
            shjM.order_total_price = [dic objectForKey:@"order_total_price"];
            shjM.order_photo_list = [dic objectForKey:@"photo_list"];
            shjM.order_name_list = [dic objectForKey:@"name_list"];
            shjM.order_ship_price = [dic objectForKey:@"ship_price"];
            shjM.order_paytype = [dic objectForKey:@"payType"];
            [dataArray4 addObject:shjM];
        }
        NSLog(@"dadada:%@",dataArray4);
        if(dataArray4.count!=0){
            ListTableView4.hidden = NO;
            nothingView4.hidden = YES;
        }else{
            nothingView4.hidden = NO;
            ListTableView4.hidden = YES;
        }
        [ListTableView4 reloadData];
    }else {
        [SYObject failedPrompt:@"请求出错，请重试"];
    }
//    loadingView.hidden = YES;
    [SYObject endLoading];
}
-(void)netWork5:(NSString *)order_status{
//    loadingView.hidden = NO;
    [SYObject startLoading];
    NSArray *valueArr = [[NSArray alloc]initWithObjects:[USER_INFORMATION objectAtIndex:3],[USER_INFORMATION objectAtIndex:1],@"0",@"0",[NSString stringWithFormat:@"%d",count5*20],order_status, nil];
    NSArray *keyArr = [[NSArray alloc]initWithObjects:@"user_id",@"token",@"order_cat",@"beginCount",@"selectCount",@"order_status", nil];
    requestList5 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,ORDER_URL] setKey:keyArr setValue:valueArr];
    
    [requestList5 setDelegate:self];
    [requestList5 setDidFailSelector:@selector(RequestFailed:)];
    [requestList5 setDidFinishSelector:@selector(requestListSucceeded5:)];
    [requestList5 startAsynchronous];
}
-(void)requestListSucceeded5:(ASIFormDataRequest *)request{
    if ([request responseStatusCode] == 200) {
        NSDictionary *dicBig = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"订单5:%@",dicBig);
        NSArray *arr = [dicBig objectForKey:@"order_list"];
        if (dataArray5.count!=0) {
            [dataArray5 removeAllObjects];
        }
        for (NSDictionary *dic in arr) {
            Model *shjM = [[Model alloc]init];
            shjM.order_addTime = [dic objectForKey:@"addTime"];
            shjM.order_id = [dic objectForKey:@"order_id"];
            shjM.order_num = [dic objectForKey:@"order_num"];
            shjM.order_status = [dic objectForKey:@"order_status"];
            shjM.order_total_price = [dic objectForKey:@"order_total_price"];
            shjM.order_photo_list = [dic objectForKey:@"photo_list"];
            shjM.order_name_list = [dic objectForKey:@"name_list"];
            shjM.order_ship_price = [dic objectForKey:@"ship_price"];
            shjM.order_paytype = [dic objectForKey:@"payType"];
            [dataArray5 addObject:shjM];
        }
        NSLog(@"dadada:%@",dataArray5);
        if(dataArray5.count!=0){
            ListTableView5.hidden = NO;
            nothingView5.hidden = YES;
        }else{
            nothingView5.hidden = NO;
            ListTableView5.hidden = YES;
        }
        [ListTableView5 reloadData];
    }else {
        [SYObject failedPrompt:@"请求出错，请重试"];
    }
    [SYObject endLoading];
}
-(void)RequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)requestCancelSucceeded:(ASIFormDataRequest *)request{
    if ([request responseStatusCode] == 100) {
        //刷新页面
        [self refresh];
    }else  if ([request responseStatusCode] == 200){
        [self refresh];
    }else{
        [SYObject failedPrompt:@"商品信息错误，无法进行删除操作"];
    }
    [SYObject endLoading];
}
-(void)refresh{
    CGPoint offset = MyScrollView.contentOffset;
    NSInteger index = offset.x / ScreenFrame.size.width;
    NSArray *btnArr = @[Top_AllBtn,Top_WaitMoney,Top_WaitSend,Top_WaitGoodsReceipt,Top_FinishedBtn];
    UIButton *curBtn = btnArr[index];
    [self clickedOtherWithLast:curBtn];
}
-(void)requestListSucceeded:(ASIFormDataRequest *)request{
    if ([request responseStatusCode] == 200) {
        NSDictionary *dicBig = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"订单1:%@",dicBig);
        NSArray *arr = [dicBig objectForKey:@"order_list"];
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        for (NSDictionary *dic in arr) {
            Model *shjM = [[Model alloc]init];
            shjM.order_addTime = [dic objectForKey:@"addTime"];
            shjM.order_id = [dic objectForKey:@"order_id"];
            shjM.order_num = [dic objectForKey:@"order_num"];
            shjM.order_status = [dic objectForKey:@"order_status"];
            shjM.order_total_price = [dic objectForKey:@"order_total_price"];
            shjM.order_photo_list = [dic objectForKey:@"photo_list"];
            shjM.order_name_list = [dic objectForKey:@"name_list"];
            shjM.order_ship_price = [dic objectForKey:@"ship_price"];
            shjM.order_paytype = [dic objectForKey:@"payType"];
            shjM.order_special=[NSString stringWithFormat:@"%@",[dic objectForKey:@"order_special"]];
            if ([shjM.order_special isEqualToString:@"advance"]) {
                shjM.advance_din=[NSString stringWithFormat:@"%@",[dic objectForKey:@"advance_din"]];
                shjM.advance_type=[NSString stringWithFormat:@"%@",[dic objectForKey:@"advance_type"]];
                shjM.advance_wei=[NSString stringWithFormat:@"%@",[dic objectForKey:@"advance_wei"]];
                shjM.status=[NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
            }
            
            
            [dataArray addObject:shjM];
        }
//        NSLog(@"dadada:%@",dataArray);
        if(dataArray.count!=0){
            ListTableView.hidden = NO;
            nothingView.hidden = YES;
        }else{
            nothingView.hidden = NO;
            ListTableView.hidden = YES;
        }
        [ListTableView reloadData];
        
    }else {
        [SYObject failedPrompt:@"请求出错，请重试"];
    }
//    loadingView.hidden = YES;
    [SYObject endLoading];
}
-(void)requestReceiptSucceeded:(ASIFormDataRequest *)request{
    if ([request responseStatusCode] == 200) {
        NSDictionary *dicBig = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"确认收货:%@",dicBig);
        NSString *code = dicBig[@"code"];
        if (code.intValue == 100) {
            [self refresh];
        }
    }else {
        [SYObject failedPrompt:@"请求出错，请重试"];
    }
//    loadingView.hidden = YES;
    [SYObject endLoading];
}


#pragma mark - 点击事件
//申请退款
-(void)refundBtnClicked:(id)sender{
    UIButton *btn = sender;
    NSInteger row = btn.tag - 500;
    NSArray *curArray = [self getCurrentArray];
    Model *model = [curArray objectAtIndex:row];
    NSString *orderID = model.order_id;
    [SYShopAccessTool refundByOrderID:orderID success:^(BOOL success) {
        if (success) {
            [self refresh];
        }
    }];
}
//TODO:追加晒单
-(void)addPhotoBtnClicked:(id)sender{
//    UIButton *btn = sender;
//    NSInteger row = btn.tag - 700;
//    NSArray *curArray = [self getCurrentArray];
//    Model *shi = curArray[row];
//    third.ding_order_id = shi.order_id;
//    EnsureestimateViewController2 *ensure = [[EnsureestimateViewController2 alloc]init];
    //    [self.navigationController pushViewController:ensure animated:YES];、//追加
//    AddEvaluatetTableViewController *add = [[UIStoryboard storyboardWithName:@"WaitForEvaluateStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"add"];
//    UITableViewCell *cell = (UITableViewCell *)button.superview.superview;
//    NSInteger row = [_finishedTV indexPathForCell:cell].row;
//    EvaAddModel *model = _finishedArr[row];
//    add.model = model;
//    add.evaID = [NSString stringWithFormat:@"%ld",(long)model.evaluate_id];
//    [self.navigationController pushViewController:add animated:YES];
//    break;
}
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//查看物流
-(IBAction)checkLogisticBtnClicked:(id)sender{
    UIButton *button = sender;
    NSArray *curArray = [self getCurrentArray];
    Model *model = curArray[button.tag];
    third.train_order_id = model.order_id;
    CheckViewController *check = [CheckViewController new];
    [self.navigationController pushViewController:check animated:YES];
}
-(void)cancelbtnClicked:(UIButton *)btn{
    CancelTag = btn.tag;
    [OHAlertView showAlertWithTitle:nil message:@"您确定要取消订单吗?" cancelButton:nil otherButtons:@[@"确定",@"取消"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
        if(buttonIndex==0){
            NSArray *currentArray = [self getCurrentArray];
            Model *mode = [currentArray objectAtIndex:CancelTag];
            third.select_order_id = [NSString stringWithFormat:@"%@",mode.order_id];
            [self cancelNetWorking];
        }else{
        }
    }];
}
-(void)btnClicked:(UIButton *)btn{
    //立即支付按钮
    NSArray *curArray = [self getCurrentArray];
    for(int i=0;i<curArray.count;i++){
        if (btn.tag == i+200){
            Model *shi = [curArray objectAtIndex:btn.tag-200];
            third.ding_hao = [NSString stringWithFormat:@"%@",shi.order_num];
            third.ding_order_id = [NSString stringWithFormat:@"%@",shi.order_id];
            third.jie_order_goods_price = [NSString stringWithFormat:@"%@",shi.order_total_price];
            if ([shi.order_special isEqualToString:@"advance"]&& [shi.order_status intValue]==10) {
                third.jie_order_goods_price = [NSString stringWithFormat:@"%@",shi.advance_din];
            }else if ([shi.order_special isEqualToString:@"advance"]&& [shi.order_status intValue]==11){
                third.jie_order_goods_price = [NSString stringWithFormat:@"%@",shi.advance_wei];
            }
            if ([shi.order_special isEqualToString:@"advance"]) {
                //预售商品多出一个验证
             [SYShopAccessTool ToTestWhetherOpenToBookingCommodityOrderCanPay:third.ding_order_id success:^(NSInteger code) {
                 if (code==100) {
                     //验证通过
                     OnlinePayTypeSelectViewController *on = [[OnlinePayTypeSelectViewController alloc]init];
                     [self.navigationController pushViewController:on animated:YES];
                 }else if(code==-100){
                     shi.order_status=@"0";
                     [ListTableView reloadData];
                     [SYObject failedPrompt:@"下单已超出30分钟，订单失效"];
                 }else if(code==-300){
                     [SYObject failedPrompt:@"未到尾款支付时间"];
                 }else if(code==-500){
                     shi.order_status=@"0";
                     [ListTableView reloadData];
                     [SYObject failedPrompt:@"超出尾款支付时间，订单失效"];
                 }
             } failure:^(NSString *errstr) {
                 [SYObject failedPrompt:@"网络请求失败"];
             }];
                
            }else{
                //选择支付方式
                OnlinePayTypeSelectViewController *on = [[OnlinePayTypeSelectViewController alloc]init];
                [self.navigationController pushViewController:on animated:YES];
            
            }
        }
    }
    //确认收货按钮
    for(int i=0;i<dataArray.count;i++){
        if (btn.tag == i+400) {
            querenshouhuo = btn.tag;
            [OHAlertView showAlertWithTitle:nil message:@"您确定要收货吗?" cancelButton:nil otherButtons:@[@"确定",@"取消"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    //发起确认收货的请求
                    for(int i=0;i<curArray.count;i++){
                        if (querenshouhuo-400==i) {
                            Model *shi = [curArray objectAtIndex:querenshouhuo-400];
                            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                            NSString *documentsPath = [docPath objectAtIndex:0];
                            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                            [SYObject startLoading];
                            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ENSURE_URL]];
                            requestReceipt = [ASIFormDataRequest requestWithURL:url];
                            
                            [requestReceipt setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
                            [requestReceipt setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
                            [requestReceipt setPostValue:shi.order_id forKey:@"order_id"];
                            
                            [requestReceipt setRequestHeaders:[LJControl requestHeaderDictionary]];
                            [requestReceipt setDelegate:self];
                            [requestReceipt setDidFailSelector:@selector(RequestFailed:)];
                            [requestReceipt setDidFinishSelector:@selector(requestReceiptSucceeded:)];
                            [requestReceipt startAsynchronous];
                        }
                    }
                }else{
                }
            }];
        }
    }
    for(int i=0;i<curArray.count;i++){
        if (btn.tag == i+600){
            Model *shi = [curArray objectAtIndex:btn.tag-600];
            third.ding_order_id = shi.order_id;
            EnsureestimateViewController *ensure = [[EnsureestimateViewController alloc]init];
            [self.navigationController pushViewController:ensure animated:YES];
        }
    }
}
- (IBAction)TopAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    imageLine.frame = CGRectMake(btn.frame.origin.x+10, 42, ScreenFrame.size.width/5-20, 2);
    [UIView commitAnimations];
    
    CGPoint offset = MyScrollView.contentOffset;
    
    if (btn.tag == 101) {
        TopTag = 1;
        [Top_AllBtn setTitleColor:RGB_COLOR(241, 83, 83) forState:UIControlStateNormal];
        [Top_WaitMoney setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [Top_WaitGoodsReceipt setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [Top_WaitSend setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [Top_FinishedBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self netWork:@""];
        
        offset.x = 0;
        MyScrollView.contentOffset = offset;
    }
    if (btn.tag == 102) {
        TopTag = 2;
        [Top_AllBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [Top_WaitMoney setTitleColor:RGB_COLOR(241, 83, 83) forState:UIControlStateNormal];
        [Top_WaitGoodsReceipt setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [Top_WaitSend setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [Top_FinishedBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self netWork2:@"10"];
        offset.x = ScreenFrame.size.width;
        MyScrollView.contentOffset = offset;
    }
    if (btn.tag == 103) {
        TopTag = 3;
        [Top_AllBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [Top_WaitMoney setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [Top_WaitGoodsReceipt setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [Top_WaitSend setTitleColor:RGB_COLOR(241, 83, 83) forState:UIControlStateNormal];
        [Top_FinishedBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self netWork3:@"20"];
        offset.x = ScreenFrame.size.width*2;
        MyScrollView.contentOffset = offset;
    }
    if (btn.tag == 104) {
        TopTag = 4;
        [Top_AllBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [Top_WaitMoney setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [Top_WaitGoodsReceipt setTitleColor:RGB_COLOR(241, 83, 83) forState:UIControlStateNormal];
        [Top_WaitSend setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [Top_FinishedBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self netWork4:@"30"];
        offset.x = ScreenFrame.size.width*3;
        MyScrollView.contentOffset = offset;
    }
    if (btn.tag == 105) {
        TopTag = 5;
        [Top_AllBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [Top_WaitMoney setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [Top_WaitGoodsReceipt setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [Top_WaitSend setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [Top_FinishedBtn setTitleColor:RGB_COLOR(241, 83, 83) forState:UIControlStateNormal];
        [self netWork5:@"50"];
        offset.x = ScreenFrame.size.width*4;
        MyScrollView.contentOffset = offset;
    }
}
#pragma mark - scrollview
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == MyScrollView) {
        CGPoint offset = MyScrollView.contentOffset;
        if (offset.x == 0) {
            [Top_AllBtn setTitleColor:RGB_COLOR(241, 83, 83) forState:UIControlStateNormal];
            [Top_WaitMoney setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [Top_WaitGoodsReceipt setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [Top_WaitSend setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [Top_FinishedBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            [UIView beginAnimations:@"srcollView" context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.275f];
            imageLine.frame = CGRectMake(10, 42, ScreenFrame.size.width/5-20, 2);
            [UIView commitAnimations];
        }else if (offset.x == ScreenFrame.size.width){
            [Top_AllBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [Top_WaitMoney setTitleColor:RGB_COLOR(241, 83, 83) forState:UIControlStateNormal];
            [Top_WaitGoodsReceipt setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [Top_WaitSend setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [Top_FinishedBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [UIView beginAnimations:@"srcollView" context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.275f];
            imageLine.frame = CGRectMake(10+ScreenFrame.size.width/5, 42, ScreenFrame.size.width/5-20, 2);
            [UIView commitAnimations];
        }else if (offset.x == ScreenFrame.size.width*2){
            [Top_AllBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [Top_WaitMoney setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [Top_WaitGoodsReceipt setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [Top_WaitSend setTitleColor:RGB_COLOR(241, 83, 83) forState:UIControlStateNormal];
            [Top_FinishedBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [UIView beginAnimations:@"srcollView" context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.275f];
            imageLine.frame = CGRectMake(10+ScreenFrame.size.width/5*2, 42, ScreenFrame.size.width/5-20, 2);
            [UIView commitAnimations];
        }else if (offset.x == ScreenFrame.size.width*3){
            [Top_AllBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [Top_WaitMoney setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [Top_WaitGoodsReceipt setTitleColor:RGB_COLOR(241, 83, 83) forState:UIControlStateNormal];
            [Top_WaitSend setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [Top_FinishedBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [UIView beginAnimations:@"srcollView" context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.275f];
            imageLine.frame = CGRectMake(10+ScreenFrame.size.width/5*3, 42, ScreenFrame.size.width/5-20, 2);
            [UIView commitAnimations];
        }else if (offset.x == ScreenFrame.size.width*4){
            [Top_AllBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [Top_WaitMoney setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [Top_WaitGoodsReceipt setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [Top_WaitSend setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [Top_FinishedBtn setTitleColor:RGB_COLOR(241, 83, 83) forState:UIControlStateNormal];
            [UIView beginAnimations:@"srcollView" context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.275f];
            imageLine.frame = CGRectMake(10+ScreenFrame.size.width/5*4, 42, ScreenFrame.size.width/5-20, 2);
            [UIView commitAnimations];
        }
    }
}
#pragma mark - tableView方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == ListTableView) {
        if (dataArray.count!=0) {
            return dataArray.count;
        }
    }
    if (tableView == ListTableView2) {
        if (dataArray2.count!=0) {
            return dataArray2.count;
        }
    }
    if (tableView == ListTableView3) {
        if (dataArray3.count!=0) {
            return dataArray3.count;
        }
    }
    if (tableView == ListTableView4) {
        if (dataArray4.count!=0) {
            return dataArray4.count;
        }
    }
    if (tableView == ListTableView5) {
        if (dataArray5.count!=0) {
            return dataArray5.count;
        }
    }
    
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (dataArray.count!=0) {
        return 210-26;
    }
    return 0;
}
-(void)fuwenbenLabel:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labell.text];
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    labell.attributedText = str;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *arrTableView = [[NSMutableArray alloc]init];
    if (tableView == ListTableView) {
        arrTableView = dataArray;
    }
    if (tableView == ListTableView2) {
        arrTableView = dataArray2;
    }
    if (tableView == ListTableView3) {
        arrTableView = dataArray3;
    }
    if (tableView == ListTableView4) {
        arrTableView = dataArray4;
    }
    if (tableView == ListTableView5) {
        arrTableView = dataArray5;
    }
    
    static NSString *myTabelviewCell = @"orderCell";
    orderCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"orderCell" owner:self options:nil] lastObject];
    }
    if (arrTableView.count != 0) {
        Model *shjM = [arrTableView objectAtIndex:indexPath.row];
//        cell.order_id.text = [NSString stringWithFormat:@"订单号:%@",shjM.order_num];
        NSArray *arr = (NSArray*)shjM.order_photo_list;
        NSArray *name_Array = (NSArray*)shjM.order_name_list;
        if (arr.count ==0) {
        }else if (arr.count==1){
            cell.muchView.hidden = YES;
            for(int i=0;i<arr.count;i++){
                [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:[arr objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"kong_lj.png"]];
                cell.nameLabel.text = [name_Array objectAtIndex:i];
            }
        }else{
            cell.muchView.hidden = NO;
            cell.scrollView.tag = 102;
            cell.scrollView.bounces = YES;
            cell.scrollView.delegate = self;
            cell.scrollView.userInteractionEnabled = YES;
            cell.scrollView.showsHorizontalScrollIndicator = NO;
            cell.scrollView.contentSize=CGSizeMake(88*arr.count+15,65);
            for(int i=0;i<arr.count;i++){
                UIImageView *imgTrademark = [[UIImageView alloc]initWithFrame:[SYObject orderCellImgFrameAtIndex:i]];
                imgTrademark.userInteractionEnabled = YES;
                [imgTrademark sd_setImageWithURL:[NSURL URLWithString:[arr objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"kong_lj.png"]];
                [cell.scrollView addSubview:imgTrademark];
            }
        }
        cell.priceLabel.text = [NSString stringWithFormat:@"订单金额:￥%.2f",[shjM.order_total_price floatValue]];
        cell.priceLabel.font=[UIFont systemFontOfSize:16];
        

        [self fuwenbenLabel:cell.priceLabel FontNumber:[UIFont systemFontOfSize:12] AndRange:NSMakeRange(cell.priceLabel.text.length-3, 3) AndColor:[UIColor blackColor]];
        
        if ([shjM.order_status intValue]==10) {
            cell.otherBtn.hidden = NO;
            cell.btn.hidden = NO;
            cell.statusLabel.text = @"待付款";
            if ([shjM.order_special isEqualToString:@"advance"]) {
                 cell.order_id.text = @"（请在30分钟支付定金）";
                [cell.btn setTitle:@"支付定金" forState:UIControlStateNormal];
            }else{
               [cell.btn setTitle:@"立即支付" forState:UIControlStateNormal];
            }
            cell.btn.tag = indexPath.row+200;
            [cell.btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.otherBtn.tag = indexPath.row;
            [cell.otherBtn addTarget:self action:@selector(cancelbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else if([shjM.order_status intValue]==11){
            cell.statusLabel.text = @"已付定金";
            cell.otherBtn.hidden = NO;
            cell.otherBtn.tag = indexPath.row;
            [cell.otherBtn addTarget:self action:@selector(cancelbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            if ([shjM.order_special isEqualToString:@"advance"]) {
                cell.btn.hidden = NO;
                 [cell.btn setTitle:@"支付尾款" forState:UIControlStateNormal];
                cell.btn.tag = indexPath.row+200;
                [cell.btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                cell.btn.hidden = YES;
            }
        }else if([shjM.order_status intValue]==30){
            cell.btn.hidden = NO;
            cell.statusLabel.text = @"待收货";
            [cell.btn setTitle:@"确认收货" forState:UIControlStateNormal];
            cell.btn.tag = indexPath.row+400;
            [cell.btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.otherBtn.hidden = NO;
            [cell.otherBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            [cell setOtherBtnToActive];
            cell.otherBtn.tag = indexPath.row;
            [cell.otherBtn addTarget:self action:@selector(checkLogisticBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else if([shjM.order_status intValue]==20){
            cell.btn.hidden = NO;
            cell.statusLabel.text = @"待发货";
            cell.otherBtn.hidden = YES;
            [cell.btn setTitle:@"申请退款" forState:UIControlStateNormal];
            cell.btn.tag = 500 + indexPath.row;
            [cell.btn addTarget:self action:@selector(refundBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else if([shjM.order_status intValue]==16){
            cell.btn.hidden = YES;
            cell.statusLabel.text = @"待发货";//详情 货到付款
            cell.otherBtn.hidden = YES;
        }else if([shjM.order_status intValue]==0){
            cell.btn.hidden = YES;
            cell.statusLabel.text = @"已取消";
            cell.otherBtn.hidden = YES;
        }else if([shjM.order_status intValue]==50){
            cell.btn.hidden = YES;
            cell.statusLabel.text = @"已评价";
            cell.otherBtn.hidden = YES;
            [cell.btn setTitle:@"追加晒单" forState:UIControlStateNormal];
            cell.btn.tag = 700 + indexPath.row;
            [cell.btn addTarget:self action:@selector(addPhotoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else if([shjM.order_status intValue]==40){
            cell.btn.hidden = NO;
            cell.statusLabel.text = @"已收货";
            [cell.btn setTitle:@"立即评价" forState:UIControlStateNormal];
            cell.btn.tag = indexPath.row+600;
            [cell.btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.otherBtn.hidden = YES;
        }else if([shjM.order_status intValue]==65){
            cell.btn.hidden = YES;
            cell.statusLabel.text = @"自动评价";
            cell.otherBtn.hidden = YES;
        }else if([shjM.order_status intValue]==21){
            cell.btn.hidden = YES;
            cell.statusLabel.text = @"已申请退款";
            cell.otherBtn.hidden = YES;
        }else if([shjM.order_status intValue]==22){
            cell.btn.hidden = YES;
            cell.statusLabel.text = @"退款中";
            cell.otherBtn.hidden = YES;
        }else if([shjM.order_status intValue]==25){
            cell.btn.hidden = YES;
            cell.statusLabel.text = @"退款完成";
            cell.otherBtn.hidden = YES;
        }else if([shjM.order_status intValue]==35){
            cell.btn.hidden = YES;
            cell.statusLabel.text = @"自提点已收货";
            cell.otherBtn.hidden = YES;
        }else{
            cell.btn.hidden = YES;
            cell.otherBtn.hidden = YES;
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *curArray = [self getCurrentArray];
    Model *model = [curArray objectAtIndex:indexPath.row];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SYOrderStoryboard" bundle:nil];
    SYOrderDetailsTableViewController *detailTVC = [sb instantiateViewControllerWithIdentifier:@"orderDetails"];
    detailTVC.orderID = [SYObject stringByNumber:model.order_id];
    [self.navigationController pushViewController:detailTVC animated:YES];
}

@end
