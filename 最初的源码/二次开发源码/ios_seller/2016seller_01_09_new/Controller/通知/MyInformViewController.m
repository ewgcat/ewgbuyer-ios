//
//  MyInformViewController.m
//  SellerApp
//
//  Created by barney on 15/12/31.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ChatViewController.h"
#import "InformCell.h"
#import "StoreMsgModel.h"
#import "MyInformViewController.h"
#import "_015b2b2cseller-Swift.h"
#import "ReturnRefundViewController.h"
#import "ThirdViewController.h"

static NSString *key1 = @"SellerNotifCenterMsgCount";
//static NSString *key2 = @"SellerNotifCenterStockWarningCount";
//static NSString *key3 = @"SellerNotifCenterRefundCount";

@interface MyInformViewController ()
{
    NSMutableArray *dataArray;
    NSMutableArray *redViewArray;
    
    UITableView *informTabView;
    
    NSMutableArray *storeMsgArray;
    NSMutableArray *stockWarningArray;
    NSMutableArray *refundArray;
    NSMutableArray *returnArray;
    
    BOOL read1;
    BOOL read2;
    BOOL read3;
}
@end

@implementation MyInformViewController

#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self netRequest];
}
#pragma mark - 网络请求下属的所有消息
-(void)netRequest
{
    [self requestForStoreWideMsg];
    //下面两个已经搬家到主页
//    [self requestForStockWarning];
//    [self requestForRefundNotif];
}
//站内信请求
-(void)requestForStoreWideMsg
{
    [MyNetTool requestForMessageSelectCount:@"20" success:^(NSMutableArray *modelArray) {
        storeMsgArray = modelArray;
        [self refreshLine:key1 newCount:storeMsgArray.count];
    }];
}
//库存预警请求
-(void)requestForStockWarning{
    [MyNetTool requestForStockWarningSuccess:^(NSMutableArray *modelArray) {
        stockWarningArray = modelArray;
        //[self refreshLine:key2 newCount:stockWarningArray.count];
    }];
}
//退货退款请求
-(void)requestForRefundNotif{
    [MyNetTool requestForRefundStatusBegin:@"0" select:@"20" success:^(NSMutableArray *modelArray) {
        refundArray = modelArray;
        [MyNetTool requestForReturnStatusBegin:@"0" select:@"20" success:^(NSMutableArray *modelArray) {
            returnArray = modelArray;
            //[self refreshLine:key3 newCount:refundArray.count + returnArray.count];
        }];
        
    }];
    
}
#pragma mark - 已读未读逻辑
-(void)refreshLine:(NSString *)key newCount:(NSInteger)newCount{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *value = [defaults valueForKey:key];
    BOOL read = NO;
    
    NSInteger line = -1;
    if ([key isEqualToString:key1]) {
        line = 1;
    }
//    }else if ([key isEqualToString:key2]){
//        line = 2;
//    }else if ([key isEqualToString:key3]){
//        line = 3;
//    }
        else
        {
        }
    
    if (value == nil && newCount != 0) {
        read = NO;
    }else if (value == nil && newCount == 0){
        read = YES;
    }else {
        read = value.integerValue == newCount;
    }
    [self setRead:read forLine:line];
    
}
#pragma mark - 初始化
-(void)setupUI{
    self.title = @"通知";
    
    dataArray = [NSMutableArray array];
    redViewArray = [NSMutableArray array];
    
    storeMsgArray = [NSMutableArray array];
    stockWarningArray = [NSMutableArray array];
    refundArray = [NSMutableArray array];
    returnArray = [NSMutableArray array];
    
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x2196f3);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    if (UIDeviceSystem>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    
    informTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenFrame.size.width, ScreenFrame.size.height-64-49)];
    informTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    informTabView.delegate = self;
    informTabView.dataSource=  self;
    informTabView.showsVerticalScrollIndicator=NO;
    informTabView.showsHorizontalScrollIndicator = NO;
    informTabView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:informTabView];
}
#pragma mark - UITableView 代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80.f;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InformCell *cell =[[[NSBundle mainBundle] loadNibNamed:@"InformCell" owner:self options:nil] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    NSArray *imgAry=@[@"phoneServer",@"stationWrite",@"inform",@"rechangeGoods"];
    NSArray *titleAry=@[@"客服",@"站内信",@"库存预警通知",@"退货退款通知"];
    [cell.img setImage:[UIImage imageNamed:imgAry[indexPath.row]]];
    cell.title.text=titleAry[indexPath.row];
    cell.redView.layer.cornerRadius=5;
    [cell.redView.layer setMasksToBounds:YES];
    
    //红点儿
    cell.redView.hidden = YES;
    [redViewArray addObject:cell.redView];
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    switch (indexPath.row) {
        case 0:{
            //客服
            ThirdViewController *chatList = [ThirdViewController sharedUserDefault];
            [self.navigationController pushViewController:chatList animated:YES];
            break;
        }
        case 1:{
            //站内信
            [defaults setValue:@(storeMsgArray.count) forKey:key1];
            StoreWideMessageViewController *swmVC = [[UIStoryboard storyboardWithName:@"NotifStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"storeMessage"];
            swmVC.dataArray = storeMsgArray;
            [self.navigationController pushViewController:swmVC animated:YES];
            break;
        }
        case 2:{
            //库存预警通知
            //[defaults setValue:@(stockWarningArray.count) forKey:key2];
            
            StockWarnTableViewController *swTVC = [[UIStoryboard storyboardWithName:@"NotifStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"stockWarning"];
            swTVC.dataArray = stockWarningArray;
            [self.navigationController pushViewController:swTVC animated:YES];
            break;
        }
        case 3:{
            //退货退款通知
            //[defaults setValue:@(refundArray.count + returnArray.count) forKey:key3];
            ReturnRefundViewController *rfVC = [ReturnRefundViewController new];
            rfVC.refundArray = refundArray;
            rfVC.returnArray = returnArray;
            [self.navigationController pushViewController:rfVC animated:YES];
            break;
        }
        default:{
            break;
        }
    }
}
#pragma mark - 设置已读
-(void)setRead:(BOOL)read forLine:(NSInteger)line{
    UIView *redView = redViewArray[line];
    redView.hidden = read;
}

@end
