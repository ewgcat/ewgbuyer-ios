//
//  SYOrderDetailsTableViewController.m
//  My_App
//
//  Created by shiyuwudi on 15/12/3.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import "SYOrderDetailsTableViewController.h"
#import "SYOrderDetailsCell1.h"
#import "SYOrderDetailsCell2.h"
#import "SYOrderDetailsCell3.h"
#import "SYOrderDetailsCell4.h"
#import "SYOrderDetailsCell44.h"
#import "SYOrderDetailsCell5.h"
#import "SYOrderDetailsCell6.h"
#import "SYOrderDetailsModel.h"
#import "OrderListModel.h"
#import "EnsureestimateViewController.h"
#import "OnlinePayTypeSelectViewController.h"
#import "ThirdViewController.h"
#import "NewLoginViewController.h"
#import "Cart4Cell.h"
#import "DetailViewController.h"
#import "SecondViewController.h"
#import "AddEvaluatetTableViewController.h"
#import "EvaAddModel.h"


@interface SYOrderDetailsTableViewController ()<SYOrderDetailsCell1Delegate,SYOrderDetailsCell44Delegate,WDAlertViewDatasource,WDAlertViewDelegate>

@property (nonatomic,strong)SYOrderDetailsModel *model;
@property (nonatomic,strong)OrderListModel *orderListModel;
@property (nonatomic,weak)UIView *bottomView;
@property (nonatomic,strong)NSMutableArray *bottomButtonArray;
@property (nonatomic,strong)WDAlertView *alertList;

@property (nonatomic,strong)NSMutableArray *alertListArray;

@end

@implementation SYOrderDetailsTableViewController

#pragma mark - 视图的生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"========order ID is %@==========",self.orderID);
    [self createBackBtn];
    [self setupUI];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self netRequest];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationItem.rightBarButtonItem = nil;
    self.tabBarController.tabBar.hidden = NO;
    [self removeBottomBar];
}
#pragma mark - 添加嵌入式按钮bar
-(void)addBottomBarByOrderStatus:(NSInteger)orderStatus{
    
    NSString *title1 = nil;
    if (orderStatus==10) {
        if ([self.model.order_special isEqualToString:@"advance"]) {
            title1 = @"支付定金";
        }else{
            title1 = @"立即支付";
        }
        
    }else if (orderStatus==11) {
        if ([self.model.order_special isEqualToString:@"advance"]) {
             title1 = @"支付尾款";
        }else{
        }
    }else if (orderStatus==20) {
        title1 = @"申请退款";
    }else if (orderStatus==30) {
        title1 = @"确认收货";
    }else if (orderStatus==40) {
        //已收货
        title1 = @"立即评价";
    }else if (orderStatus==50) {
        //已完成
        //title1 = @"追加晒单";
    }
    
    if (title1==nil) {
        return;
    }
    
    //可以在下面的数组里面继续添加更多按钮
    NSArray *btnTitleArr = @[title1];
    NSMutableArray *btnArray;
    UIView *bottomView = [SYObject bottomViewWithButtonTitleArray:btnTitleArr resultBtnArray:&btnArray];
    _bottomButtonArray = btnArray;
    _bottomView = bottomView;
    [self.navigationController.view addSubview:bottomView];
    
    for (int i = 0; i < _bottomButtonArray.count; i ++) {
        UIButton *btn = _bottomButtonArray[i];
        btn.tag = i;
        [btn addTarget:self action:@selector(bottomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius=4;
        [btn addTarget:self action:@selector(buttonBackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(buttonBackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
    }
}
//  button普通状态下的背景色
- (void)buttonBackGroundNormal:(UIButton *)sender
{
    sender.backgroundColor = UIColorFromRGB(0Xf15353);
}
//  button高亮状态下的背景色
- (void)buttonBackGroundHighlighted:(UIButton *)sender
{
    sender.backgroundColor = UIColorFromRGB(0Xd15353);
}
-(void)removeBottomBar{
    if (_bottomView) {
        [_bottomView removeFromSuperview];
    }
    _bottomView = nil;
}
-(IBAction)bottomButtonClicked:(id)sender{
    UIButton *btn = sender;
    NSInteger tag = btn.tag;
    NSString *title = btn.titleLabel.text;
    ThirdViewController *third = [ThirdViewController sharedUserDefault];
    if (tag==0) {
        //最右面按钮的动作
        //跳转页面
        if ([title isEqualToString:@"立即支付"]||[title isEqualToString:@"支付定金"]||[title isEqualToString:@"支付尾款"]) {  
            third.ding_hao = [SYObject stringByNumber:self.model.order_num];//一大串的订单号
            third.ding_order_id = [SYObject stringByNumber:self.orderID];//订单ID
            third.jie_order_goods_price = self.model.order_price4;//订单总价格
            if ([self.model.order_special isEqualToString:@"advance"]&&[title isEqualToString:@"支付定金"]) {
                third.jie_order_goods_price = [NSString stringWithFormat:@"%@",self.model.advance_din];
            }else if ([self.model.order_special isEqualToString:@"advance"]&&[title isEqualToString:@"支付尾款"]){
                third.jie_order_goods_price = [NSString stringWithFormat:@"%@",self.model.advance_wei];
            }
            if ([self.model.order_special isEqualToString:@"advance"]) {
                //预售商品多出一个验证
                [SYShopAccessTool ToTestWhetherOpenToBookingCommodityOrderCanPay:third.ding_order_id success:^(NSInteger code) {
                    if (code==100) {
                        //验证通过
                        OnlinePayTypeSelectViewController *on = [[OnlinePayTypeSelectViewController alloc]init];
                        [self.navigationController pushViewController:on animated:YES];
                    }else if(code==-100){
                        [self netRequest];
                        [SYObject failedPrompt:@"下单已超出30分钟，订单失效"];
                    }else if(code==-300){
                        [SYObject failedPrompt:@"未到尾款支付时间"];
                    }else if(code==-500){
                        [self netRequest];
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

        }else if ([title isEqualToString:@"确认收货"]){
            [OHAlertView showAlertWithTitle:@"提示" message:@"您确定要收货吗?" cancelButton:nil otherButtons:@[@"确定",@"取消"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                if(buttonIndex==0){
                    [SYShopAccessTool confirmReceiptByOrderID:self.orderID success:^(NSDictionary *dict) {
                        NSLog(@"%@",dict);
                        [self.navigationController popViewControllerAnimated:YES];
                    } failure:nil];
                }else{
                }
            }];
        }else if ([title isEqualToString:@"申请退款"]){
            [SYShopAccessTool refundByOrderID:self.orderID success:^(BOOL success) {
                if (success) {
                    if (self.successLogin==YES) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }else
                    {
                    [self.navigationController popViewControllerAnimated:YES];
                    }
                }
            }];
        }else if ([title isEqualToString:@"追加晒单"]){
                      
        }else if ([title isEqualToString:@"立即评价"]){
            //立即评价
            third.ding_order_id = _orderID;
            EnsureestimateViewController *ensur = [[EnsureestimateViewController alloc]init];
            [self.navigationController pushViewController:ensur animated:YES];
        }else{
            
        }
    }
}
#pragma mark - alertView 代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //确认收货请求
    if (alertView.tag == 101&&buttonIndex == 0) {
        [SYShopAccessTool confirmReceiptByOrderID:self.orderID success:^(NSDictionary *dict) {
            NSLog(@"%@",dict);
            [self.navigationController popViewControllerAnimated:YES];
        } failure:nil];
    }
    //取消订单请求
    if (alertView.tag==100&&buttonIndex==0) {
        [SYShopAccessTool cancelOrderByOrderID:self.orderID success:^(NSDictionary *dict) {
            NSLog(@"%@",dict);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}
#pragma mark - cell的代理方法
//查看更多按钮
-(void)shouldReloadTableView:(SYOrderDetailsCell44 *)cell44{
    [self.tableView reloadData];
}
-(void)orderDetailsCell44ActivityButtonClick:(SYOrderDetailsModel *)model{
    
    _alertListArray=[[NSMutableArray alloc]init];
    for (SYOrderDetailsModel *mm in model.activityArray) {
        [_alertListArray addObject:mm];
    }
    if (_alertListArray.count>0) {
       if ([model.order_goods_type isEqualToString:@"combin"]){
               _alertList = [[WDAlertView alloc] initWithFrame:CGRectMake(0, 0, 250, 300)buttonSty:WDAlertViewTypeOne title:@"套装详情" doneButtonTitle:@"确定" andCancelButtonTitle:nil];
        }
        _alertList.datasource = self;
        _alertList.delegate=self;
        __unsafe_unretained typeof(self) blockSelf = self;
        //更改收货地址
        [_alertList setDoneButtonWithBlock:^{
            [blockSelf->_alertList dismiss];
        }];
        [_alertList showAlertListView];
    }
   

}
//显示取消订单按钮
-(void)shouldDisplayCancelOrderBarButtonItem:(SYOrderDetailsCell1 *)cell1{
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc]initWithTitle:@"取消订单" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClicked:)];
    self.navigationItem.rightBarButtonItem = bbi;
}
-(void)tapSYOrderDetailsCell4Click:(SYOrderDetailsModel *)model{
    SecondViewController *sec = [SecondViewController sharedUserDefault];
    sec.detail_id = model.order_goods_id;
    DetailViewController *detail = [[DetailViewController alloc]init];
    [self.navigationController pushViewController:detail animated:YES];
}
-(IBAction)cancelBtnClicked:(id)sender{
    [OHAlertView showAlertWithTitle:@"提示" message:@"您确定要取消订单吗?" cancelButton:nil otherButtons:@[@"确定",@"取消"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
        if(buttonIndex==0){
            [SYShopAccessTool cancelOrderByOrderID:self.orderID success:^(NSDictionary *dict) {
                NSLog(@"%@",dict);
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
        }
    }];
}
#pragma mark - 网络操作
-(void)netRequest{
    //到手的变量:order_id
    [SYObject startLoading];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,DNGDANDETAIL_URL];
    NSDictionary *par = @{
                          @"user_id":[SYObject currentUserID],
                          @"token":[SYObject currentToken],
                          @"order_id":self.orderID
                          };
    
    
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"＝＝＝%@",responseObject);
        NSDictionary *dict = responseObject;
        NSNumber *code = dict[@"code"];
        if (code.integerValue==100) {
            SYOrderDetailsModel *model = [[SYOrderDetailsModel alloc]init];
            
            
            NSArray *arr1 = dict[@"goods_list"];
            OrderListModel *orderListModel = [OrderListModel new];
            NSMutableArray *tempOrders = [NSMutableArray array];
            for (NSDictionary *dict1 in arr1) {
                SYOrderDetailsModel *model0 = [SYOrderDetailsModel new];
                model0.order_image = dict1[@"goods_mainphoto_path"];
                model0.order_goods_name = dict1[@"goods_name"];
                model0.order_price = dict1[@"goods_price"];
                model0.order_specs = dict1[@"goods_gsp_val"];
                model0.order_qty = dict1[@"goods_count"];
                model0.order_goods_id=dict1[@"goods_id"];
//                model0.order_goods_type=dict1[@"goods_type"];
              model0.order_goods_type=dict[@"order_special"];

                if ([model0.order_goods_type isEqualToString:@"combin"]){
                    NSMutableArray *marray=[[NSMutableArray alloc]init];
                    for (NSDictionary *ddic in dict1[@"combin_info"]) {
                         SYOrderDetailsModel *ddmodel = [SYOrderDetailsModel new];
                        ddmodel.order_image = ddic[@"img"];
                        ddmodel.order_goods_name = ddic[@"name"];
                        ddmodel.order_goods_id=ddic[@"id"];
                        [marray addObject:ddmodel];
                    }
                    model0.activityArray=marray;
                }else if ([model0.order_goods_type isEqualToString:@"赠品"]){
                    NSMutableArray *marray=[[NSMutableArray alloc]init];
                    for (NSDictionary *ddic in dict1[@"combin_info"]) {
                        SYOrderDetailsModel *ddmodel = [SYOrderDetailsModel new];
                        ddmodel.order_image = ddic[@"img"];
                        ddmodel.order_goods_name = ddic[@"name"];
                        ddmodel.order_goods_id=ddic[@"id"];
                        [marray addObject:ddmodel];
                    }
                    model0.activityArray=marray;
                }else if ([model0.order_goods_type isEqualToString:@"advance"]){
                     //预售商品
                    NSLog(@"/预售商品");
                    model0.advance_din=[NSString stringWithFormat:@"%@",[dict objectForKey:@"advance_din"]];
                    model0.status=[NSString stringWithFormat:@"%@",[dict objectForKey:@"order_status"]];
                    model0.advance_wei=[NSString stringWithFormat:@"%@",[dict objectForKey:@"advance_wei"]];
                }else{
                    
                }
                [tempOrders addObject:model0];
            }
            orderListModel.orders = tempOrders;
            
            NSArray *gif_infos=dict[@"gif_info"];
            if (gif_infos.count>0) {
                NSMutableArray *gifs=[[NSMutableArray alloc]init];
                for (NSDictionary *d in gif_infos) {
                    SYOrderDetailsModel *ddmodel = [SYOrderDetailsModel new];
                    ddmodel.order_image = @"";
                    ddmodel.order_goods_name = @"";
                    ddmodel.order_price = @"";
                    ddmodel.order_specs = @"";
                    ddmodel.order_qty = @"";
                    ddmodel.order_goods_id=@"";
                    ddmodel.order_goods_type=@"normal";
                    ddmodel.order_image = d[@"img"];
                    ddmodel.order_goods_name = d[@"name"];
                    ddmodel.order_goods_id=d[@"id"];
                    [gifs addObject:ddmodel];
                }
                orderListModel.gifOrderDetails=gifs;
            }

            
            model.order_special=[NSString stringWithFormat:@"%@",[dict objectForKey:@"order_special"]];
             //预售商品
            if ([model.order_special isEqualToString:@"advance"]) {
                
                model.advance_din=[NSString stringWithFormat:@"%@",[dict objectForKey:@"advance_din"]];
//                model.advance_type=[NSString stringWithFormat:@"%@",[dict objectForKey:@"advance_type"]];
                model.advance_wei=[NSString stringWithFormat:@"%@",[dict objectForKey:@"advance_wei"]];
                model.status=[NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
            }
        
            
            
            NSDictionary *listDict = arr1[0];
            NSArray *arr2 = dict[@"trans_list"];
            NSDictionary *transDict = arr2[0];
            model.order_status = dict[@"order_status"];
            
            
            //根据订单种类来显示下面的按钮
            self.model = model;
            [self addBottomBarByOrderStatus:model.order_status.integerValue];
            model.order_num = dict[@"order_num"];
            model.order_time = dict[@"addTime"];
            
            model.order_username = dict[@"receiver_Name"];
            model.order_address = [NSString stringWithFormat:@"%@ %@",dict[@"receiver_area"],dict[@"receiver_area_info"]];
            
            model.order_image = listDict[@"goods_mainphoto_path"];
            model.order_goods_name = listDict[@"goods_name"];
            model.order_price = listDict[@"goods_price"];
            
            if (transDict[@"shipCode"]) {
                model.order_logistic = [NSString stringWithFormat:@"物流单号:%@\n物流公司:%@",transDict[@"shipCode"],transDict[@"express_company"]];
            }
           
            model.order_invoice = dict[@"invoiceType"];
            
            model.order_price1 = dict[@"goods_price"];
            model.order_price2 = dict[@"ship_price"];
            model.order_price3 = dict[@"coupon_price"];
            model.order_price4 = dict[@"order_total_price"];
            model.order_price5 = dict[@"reduce_amount"];
            model.order_specs = listDict[@"goods_gsp_val"];
            model.order_pay_type = dict[@"payType"];
            model.order_mobile = dict[@"receiver_telephone"];
            model.order_qty = listDict[@"goods_count"];
            model.order_goods_id = listDict[@"goods_id"];
            
            self.orderListModel = orderListModel;
            
            [self.tableView reloadData];
        }
        [SYObject endLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject endLoading];
        [self failedPrompt:[error localizedDescription]];
    }];
}
#pragma mark - 初始化操作
-(void)setupUI{
    self.title = @"订单详情";
    self.tableView.backgroundColor = BACKGROUNDCOLOR;
}
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    if (self.successLogin==YES) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else
    {
    [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)failedPrompt:(NSString *)prompt{
    [SYObject endLoading];
    [SYObject failedPrompt:prompt];
}
#pragma mark - Tableview数据源方法
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row!=5) {
//        return;
//    }
//    [SYObject selfNavigationController:self.navigationController pushDetailPageByGoodsID:self.model.order_goods_id];
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0||indexPath.row==2||indexPath.row==4||indexPath.row==6||indexPath.row==8) {
        return 10.f;
    }else if (indexPath.row==1){
        return 113.f;
    }else if (indexPath.row==3){
        return 96.f;
    }else if (indexPath.row==5){
        NSLog(@"%f", [SYOrderDetailsCell44 cellHeightWithModel:self.orderListModel]);
        return [SYOrderDetailsCell44 cellHeightWithModel:self.orderListModel];
    }else if (indexPath.row==7){
        return 188.f + 20.f;
    }else if (indexPath.row==9){
//        return 130.f;
        return 156.f;
    }else{
        return 0.f;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0||indexPath.row==2||indexPath.row==4||indexPath.row==6||indexPath.row==8) {
        SYOrderDetailsCell2 *grayCell = [SYOrderDetailsCell2 cell2WithTableView:tableView];
        return grayCell;
    }else if (indexPath.row==1){
        SYOrderDetailsCell1 *cell1 = [SYOrderDetailsCell1 cell1WithTableView:tableView];
        cell1.delegate = self;
        cell1.model = self.model;
        return cell1;
    }else if (indexPath.row==3){
        SYOrderDetailsCell3 *cell3 = [SYOrderDetailsCell3 cell3WithTableView:tableView];
        cell3.model = self.model;
        return cell3;
    }else if (indexPath.row==5){
        SYOrderDetailsCell44 *cell44 = [SYOrderDetailsCell44 cell44];
        cell44.tableView = tableView;
        cell44.model = self.orderListModel;
        
        NSLog(@"******%@",_orderListModel.orders.lastObject.order_status);
        NSLog(@"******%@",_orderListModel.gifOrderDetails);

        cell44.delegate = self;
        return cell44;
    }else if (indexPath.row==7){
        SYOrderDetailsCell5 *cell5 = [SYOrderDetailsCell5 cell5WithTableView:tableView];
        cell5.model = self.model;
        return cell5;
    }else if (indexPath.row==9){
        SYOrderDetailsCell6 *cell6 = [SYOrderDetailsCell6 cell6WithTableView:tableView];
        cell6.model = self.model;
        return cell6;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        return cell;
    }
}
#pragma WDAlertViewDatasource,WDAlertViewDelegate
#pragma mark -设置行数
- (NSInteger)alertListTableView:(WDAlertView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _alertListArray.count;
}
-(CGFloat)alertListTableView:(WDAlertView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_alertListArray.count!=0) {
        return 80;
        
    }
    return 0;
    
}
- (UITableViewCell *)alertListTableView:(WDAlertView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SYOrderDetailsModel *class = [_alertListArray objectAtIndex:indexPath.row];
    Cart4Cell *cell = [tableView dequeueReusableAlertListCellWithIdentifier:[NSString stringWithFormat:@"Cart4Cell%ld_%ld", (long)indexPath.section, (long)indexPath.row]];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"Cart4Cell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.pictureImageView sd_setImageWithURL:[NSURL URLWithString:class.order_image] placeholderImage:[UIImage imageNamed:@"kong"]];
    cell.nameLabel.text = class.order_goods_name;
    cell.shadingLabel.hidden=YES;
    return cell;
    
    
}
- (void)alertListTableView:(WDAlertView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)alertListTableView:(WDAlertView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


@end
