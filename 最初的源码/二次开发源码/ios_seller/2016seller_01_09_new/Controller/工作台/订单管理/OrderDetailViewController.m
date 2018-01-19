//
//  OrderDetailViewController.m
//  SellerApp
//
//  Created by apple on 15-3-30.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "Model.h"
#import "NilCell.h"
#import "OrderlistViewController.h"
#import "ModifyShipViewController.h"
#import "OrderCancelViewController.h"
#import "delayViewController.h"
#import "ModifyShipViewController.h"
#import "ModifyPriceViewController.h"
#import "AppDelegate.h"
#import "confirmdeliveryViewController.h"
#import "sqlService.h"
@interface OrderDetailViewController (){
    myselfParse *_myParse;
}

@end

@implementation OrderDetailViewController



-(void)rightBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)doTimer
{
    [label_prompt setHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createBackBtn];
    // Do any additional setup after loading the view from its nib.
    self.title = @"订单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    dataArray = [[NSMutableArray alloc]init];
    if (UIDeviceSystem>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    
    if (ScreenFrame.size.height>480) {//说明是5 5s
        MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ScreenFrame.origin.y+44+20, ScreenFrame.size.width, ScreenFrame.size.height-64) style:UITableViewStylePlain];
        
    }else{
        MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ScreenFrame.origin.y+44+20, ScreenFrame.size.width, ScreenFrame.size.height-64 ) style:UITableViewStylePlain];
    }
    MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MyTableView.delegate = self;
    MyTableView.dataSource=  self;
    MyTableView.showsVerticalScrollIndicator=NO;
    MyTableView.showsHorizontalScrollIndicator = NO;
    MyTableView.backgroundColor = GRAY_COLOR;
    [self.view addSubview:MyTableView];
    
    loadingV=[LJControl loadingView:CGRectMake((self.view.frame.size.width-100)/2, (self.view.frame.size.height-59-100)/2, 100, 100)];
    loadingV.hidden = YES;
    [self.view addSubview:loadingV];
    
    label_prompt =[LJControl labelFrame:CGRectMake(50, self.view.frame.size.height-100, self.view.frame.size.width-100, 30) setText:@"" setTitleFont:17 setbackgroundColor:[UIColor blackColor] setTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    [label_prompt.layer setMasksToBounds:YES];
    [label_prompt.layer setCornerRadius:4.0];
    label_prompt.alpha = 0.8;
    label_prompt.hidden = YES;
    [self.view addSubview:label_prompt];
    
    //TODO:查询订单详情
    NSString *oid = nil;
    
    if (_orderID) {
        oid = _orderID;
    }else{
        OrderlistViewController *order=[OrderlistViewController sharedUserDefault];
        oid = order.order_id;
    }
    NSArray *fileContent2 = USER_INFORMATION;
    NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_id=%@",SELLER_URL,ORDER_DETAIL_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],oid];
    [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
        loadingV.hidden = YES;
        _myParse = myParse;
        [self analyze:_myParse.dicBig];
    } failure:^(){
        [self fail];
    } ];
}
-(void)doTimer_signout{
    label_prompt.hidden = YES;
    [LJControl cleanAll];
    AppDelegate *app = [AppDelegate sharedUserDefault];
    app.log_View.hidden = NO;
}
-(void)clearCacheSuccessOut{
    NSLog(@"成功");
}
-(void)fail{
    loadingV.hidden = YES;
    [MyObject failedPrompt: @"未能连接到服务器"];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
}
-(void)analyze:(NSDictionary *)dicBig{
    NSLog(@"dicBig:%@",dicBig);
    if (dicBig) {
        if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"]){
            [self.navigationController popToRootViewControllerAnimated:NO];
            //登录过期 提示重新登录
            [MyObject failedPrompt: @"用户登录已过期，请重新登录"];
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
        }else{
            if (dataArray.count!=0) {
                [dataArray removeAllObjects];
            }
            Model *model = [[Model alloc]init];
            model.addTime = [dicBig objectForKey:@"addTime"];
            model.coupon_price = [dicBig objectForKey:@"coupon_price"];
            model.photo_list = [dicBig objectForKey:@"goods_list"];
            model.invoice = [dicBig objectForKey:@"invoice"];
            model.invoiceType = [dicBig objectForKey:@"invoiceType"];
            model.order_id = [dicBig objectForKey:@"order_id"];
            model.order_num = [dicBig objectForKey:@"order_num"];
            model.order_status = [dicBig objectForKey:@"order_status"];
            model.totalPrice = [dicBig objectForKey:@"order_total_price"];
            model.payTime = [dicBig objectForKey:@"payTime"];
            model.payType = [dicBig objectForKey:@"payType"];
            model.receiver_Name = [dicBig objectForKey:@"receiver_Name"];
            model.receiver_area = [dicBig objectForKey:@"receiver_area"];
            model.receiver_area_info = [dicBig objectForKey:@"receiver_area_info"];
            model.receiver_mobile = [dicBig objectForKey:@"receiver_mobile"];
            model.receiver_telephone = [dicBig objectForKey:@"receiver_telephone"];
            model.receiver_zip = [dicBig objectForKey:@"receiver_zip"];
            model.reduce_amount = [dicBig objectForKey:@"reduce_amount"];
            model.ship_price = [dicBig objectForKey:@"ship_price"];
            model.trans_list = [dicBig objectForKey:@"trans_list"];
            model.goods_price = [dicBig objectForKey:@"goods_price"];
            model.sendTime = [dicBig objectForKey:@"shipTime"];
            model.company = [dicBig objectForKey:@"express_company"];
            
            if (model.payTime == nil) {
                model.payTime = @"不可用";
            }
            if (model.company == nil) {
                model.company = @"不可用";
            }
            if (model.sendTime == nil) {
                model.sendTime = @"不可用";
            }
            
            [dataArray addObject:model];
            [MyTableView reloadData];
        }
    }
}

-(void)createBackBtn{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
    button.frame =CGRectMake(0, 0, 44, 44);
    [button setBackgroundImage:[UIImage imageNamed:@"back_lj"] forState:UIControlStateNormal];
    button.tag = 101;
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font  = [UIFont systemFontOfSize:14];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}

-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-tableView方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (dataArray.count!=0) {
        Model *mm = [dataArray objectAtIndex:0];
        if (indexPath.row == 0) {
            return 44*3+40+mm.photo_list.count*81+44;
        }
        if (indexPath.row == 1) {
            return 44*7+20;
        }
        if (indexPath.row == 2) {
            return 154;
        }
        if (indexPath.row == 3) {
            return 44*3+20;
        }
        if (indexPath.row == 4) {
            if ([mm.order_status intValue] == 10) {
                return 0;
            }
            return 44*6+20;
        }
    }
    
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myTabelviewCell = @"NilCell";
    NilCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NilCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = GRAY_COLOR;
    }else{
        for (UIView *subView in cell.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    if (dataArray.count!=0) {
        Model *model = [dataArray objectAtIndex:0];
        if (indexPath.row ==0) {
            UIView *viewTop = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44*3)];
            viewTop.backgroundColor = [UIColor whiteColor];
            [cell addSubview:viewTop];
            UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
            imageLine.backgroundColor = [UIColor lightGrayColor];
            [viewTop addSubview:imageLine];
            UIImageView *imageLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, viewTop.frame.size.height-0.5, self.view.frame.size.width, 0.5)];
            imageLine2.backgroundColor = [UIColor lightGrayColor];
            [viewTop addSubview:imageLine2];
            for(int i=0;i<2;i++){
                UIImageView *imageLine3 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 43.75+44*i, self.view.frame.size.width-15, 0.5)];
                imageLine3.backgroundColor = LINE_COLOR;
                [viewTop addSubview:imageLine3];
            }
            UILabel *lbl_ordernum = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-30, 44)];
            lbl_ordernum.text = @"订单号";
            [viewTop addSubview:lbl_ordernum];
            UILabel *lbl_ordernum2 = [[UILabel alloc]initWithFrame:CGRectMake(115, 0, self.view.frame.size.width-110, 44)];
            lbl_ordernum2.text = [NSString stringWithFormat:@"%@",model.order_num];
            [viewTop addSubview:lbl_ordernum2];
            UILabel *lbl_status = [[UILabel alloc]initWithFrame:CGRectMake(15, 44, self.view.frame.size.width-30, 44)];
            lbl_status.text = @"状态";
            [viewTop addSubview:lbl_status];
            UILabel *lbl_status2 = [[UILabel alloc]initWithFrame:CGRectMake(115, 44, self.view.frame.size.width-110, 44)];
            if ([model.order_status intValue] == 10){//待付款
                lbl_status2.text = @"待付款";
                
            }else if ([model.order_status intValue] == 20||[model.order_status intValue] == 16){//待发货
                lbl_status2.text = @"待发货";
               
            }else if ([model.order_status intValue] == 30){// 已发货
                lbl_status2.text = @"待收货";
//                UILabel *btnbtn=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-118, 20+44+6, 100, 32)];
               
            }else if ([model.order_status intValue] == 40){// 已确认收货
                lbl_status2.text = @"已确认收货";
            }else if ([model.order_status intValue] == 50){// 已完成
                lbl_status2.text = @"已收货";
            }else{
                lbl_status2.text = @"已取消";
            }
            [viewTop addSubview:lbl_status2];
            UILabel *lbl_TotalPrice = [[UILabel alloc]initWithFrame:CGRectMake(15, 44*2, self.view.frame.size.width-30, 44)];
            lbl_TotalPrice.text = @"应支付金额";
            [viewTop addSubview:lbl_TotalPrice];
            UILabel *lbl_TotalPrice2 = [[UILabel alloc]initWithFrame:CGRectMake(115, 44*2, self.view.frame.size.width-110, 44)];
            lbl_TotalPrice2.text = [NSString stringWithFormat:@"¥%.2f",model.totalPrice.floatValue];
            lbl_TotalPrice2.textColor = [UIColor redColor];
            [viewTop addSubview:lbl_TotalPrice2];
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 44*3+40, self.view.frame.size.width, 44+81*model.photo_list.count)];
            view.backgroundColor = [UIColor whiteColor];
            [cell addSubview:view];
            UIImageView *imageLine22 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
            imageLine22.backgroundColor = [UIColor lightGrayColor];
            [view addSubview:imageLine22];
            UIImageView *imageLine23 = [[UIImageView alloc]initWithFrame:CGRectMake(0, view.frame.size.height-0.5, self.view.frame.size.width, 0.5)];
            imageLine23.backgroundColor = [UIColor lightGrayColor];
            [view addSubview:imageLine23];
            UILabel *lbl_list = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width, 44)];
            lbl_list.text = @"商品清单:";
            [view addSubview:lbl_list];
            for(int i=0;i<model.photo_list.count;i++){
                UIImageView *imageLine24 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 44+81*i, self.view.frame.size.width-15, 0.5)];
                imageLine24.backgroundColor = [UIColor lightGrayColor];
                [view addSubview:imageLine24];
                
                UIImageView *imgePhoto  = [[UIImageView alloc]initWithFrame:CGRectMake(15, 56+81*i, 56, 56)];
                [imgePhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[model.photo_list objectAtIndex:i] objectForKey:@"goods_mainphoto_path"]]] placeholderImage:[UIImage imageNamed:@"loading"]];
                [view addSubview:imgePhoto];
                
                UILabel *lbl_name = [[UILabel alloc]initWithFrame:CGRectMake(80, 56+81*i, self.view.frame.size.width-85, 40)];
                NSString *str = [[model.photo_list objectAtIndex:i] objectForKey:@"goods_name"];
                str = [str stringByAppendingString:@"\n "];
                lbl_name.text = str;
                
                
                lbl_name.numberOfLines = 2;
                lbl_name.font = [UIFont systemFontOfSize:15];
                [view addSubview:lbl_name];
                UILabel *lbl_Price = [[UILabel alloc]initWithFrame:CGRectMake(80, 94+81*i, self.view.frame.size.width-85, 20)];
                NSString *priceStr = [[model.photo_list objectAtIndex:i] objectForKey:@"goods_price"];
                lbl_Price.text = [NSString stringWithFormat:@"价格:￥%.2f    数量:%@", priceStr.floatValue,[[model.photo_list objectAtIndex:i] objectForKey:@"goods_count"]];
                lbl_Price.textColor = [UIColor blackColor];
                lbl_Price.font = [UIFont systemFontOfSize:14];
                [view addSubview:lbl_Price];
            }
            
        }else if (indexPath.row == 1){
            UIView *viewTop = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44*7)];
            viewTop.backgroundColor = [UIColor whiteColor];
            [cell addSubview:viewTop];
            UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
            imageLine.backgroundColor = [UIColor lightGrayColor];
            [viewTop addSubview:imageLine];
            UIImageView *imageLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, viewTop.frame.size.height-0.5, self.view.frame.size.width, 0.5)];
            imageLine2.backgroundColor = [UIColor lightGrayColor];
            [viewTop addSubview:imageLine2];
            for(int i=0;i<1;i++){
                UIImageView *imageLine3 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 43.75+44*i, self.view.frame.size.width-15, 0.5)];
                imageLine3.backgroundColor = LINE_COLOR;
                [viewTop addSubview:imageLine3];
            }
            UILabel *lbl_ordernum = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-30, 44)];
            lbl_ordernum.text = @"付款信息:";
            [viewTop addSubview:lbl_ordernum];
            
            UILabel *lbl_status = [[UILabel alloc]initWithFrame:CGRectMake(15, 44, self.view.frame.size.width-30, 44)];
            lbl_status.text = @"付款方式:";
            [viewTop addSubview:lbl_status];
            UILabel *lbl_status2 = [[UILabel alloc]initWithFrame:CGRectMake(115, 44, self.view.frame.size.width-110, 44)];
            lbl_status2.text = model.payType;
            NSLog(@"model.payType:%@",model.payType);
            [viewTop addSubview:lbl_status2];
            UILabel *lbl_TotalPrice = [[UILabel alloc]initWithFrame:CGRectMake(15, 44*2, self.view.frame.size.width-30, 44)];
            lbl_TotalPrice.text = @"商品金额:";
            [viewTop addSubview:lbl_TotalPrice];
            UILabel *lbl_TotalPrice2 = [[UILabel alloc]initWithFrame:CGRectMake(115, 44*2, self.view.frame.size.width-110, 44)];
            lbl_TotalPrice2.text = [NSString stringWithFormat:@"¥%.2f",model.goods_price.floatValue];
            [viewTop addSubview:lbl_TotalPrice2];
            UILabel *lbl_shipPrice = [[UILabel alloc]initWithFrame:CGRectMake(15, 44*3, self.view.frame.size.width-30, 44)];
            lbl_shipPrice.text = @"运费金额:";
            [viewTop addSubview:lbl_shipPrice];
            UILabel *lbl_shipPrice2 = [[UILabel alloc]initWithFrame:CGRectMake(115, 44*3, self.view.frame.size.width-110, 44)];
            lbl_shipPrice2.text = [NSString stringWithFormat:@"¥%.2f",model.ship_price.floatValue];
            [viewTop addSubview:lbl_shipPrice2];
            UILabel *lbl_youhuiPrice = [[UILabel alloc]initWithFrame:CGRectMake(15, 44*4, self.view.frame.size.width-30, 44)];
            lbl_youhuiPrice.text = @"优惠金额:";
            [viewTop addSubview:lbl_youhuiPrice];
            UILabel *lbl_youhuiPrice2 = [[UILabel alloc]initWithFrame:CGRectMake(115, 44*4, self.view.frame.size.width-110, 44)];
            lbl_youhuiPrice2.text = [NSString stringWithFormat:@"¥%.2f",model.coupon_price.floatValue];
            [viewTop addSubview:lbl_youhuiPrice2];
            UILabel *lbl_reducePrice = [[UILabel alloc]initWithFrame:CGRectMake(15, 44*5, self.view.frame.size.width-30, 44)];
            lbl_reducePrice.text = @"满减金额:";
            [viewTop addSubview:lbl_reducePrice];
            UILabel *lbl_reducePrice2 = [[UILabel alloc]initWithFrame:CGRectMake(115, 44*5, self.view.frame.size.width-110, 44)];
            lbl_reducePrice2.text = [NSString stringWithFormat:@"¥%.2f",model.reduce_amount.floatValue];
            [viewTop addSubview:lbl_reducePrice2];
            UILabel *lbl_tttPrice = [[UILabel alloc]initWithFrame:CGRectMake(15, 44*6, self.view.frame.size.width-30, 44)];
            lbl_tttPrice.text = @"应支付金额:";
            [viewTop addSubview:lbl_tttPrice];
            UILabel *lbl_tttPrice2 = [[UILabel alloc]initWithFrame:CGRectMake(115, 44*6, self.view.frame.size.width-110, 44)];
            lbl_tttPrice2.textColor = [UIColor redColor];
            lbl_tttPrice2.text = [NSString stringWithFormat:@"¥%.2f",model.totalPrice.floatValue];
            [viewTop addSubview:lbl_tttPrice2];
        }else if (indexPath.row == 2){
            UIView *viewPerson = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 134)];
            viewPerson.backgroundColor = [UIColor whiteColor];
            [cell addSubview:viewPerson];
            UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
            imageLine.backgroundColor = [UIColor lightGrayColor];
            [viewPerson addSubview:imageLine];
            UIImageView *imageLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, viewPerson.frame.size.height-0.5, self.view.frame.size.width, 0.5)];
            imageLine2.backgroundColor = [UIColor lightGrayColor];
            [viewPerson addSubview:imageLine2];
            UIImageView *imageLine3 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 43, self.view.frame.size.width-15, 0.5)];
            imageLine3.backgroundColor = [UIColor lightGrayColor];
            [viewPerson addSubview:imageLine3];
            
            UILabel *lbl_person = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-15, 44)];
            lbl_person.text = @"收货人信息";
            [viewPerson addSubview:lbl_person];
            
            UILabel *lbl_personname = [[UILabel alloc]initWithFrame:CGRectMake(0, 54, self.view.frame.size.width/2, 24)];
            lbl_personname.text = [NSString stringWithFormat:@"    %@",model.receiver_Name];
            [viewPerson addSubview:lbl_personname];
            UILabel *lbl_personphone = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, 54, self.view.frame.size.width/2-15, 24)];
            if (model.receiver_mobile.length == 0) {
                lbl_personphone.text = model.receiver_telephone;
            }else{
                lbl_personphone.text = model.receiver_mobile;
            }
            
            lbl_personphone.textAlignment = NSTextAlignmentRight;
            [viewPerson addSubview:lbl_personphone];
            UILabel *lbl_personads = [[UILabel alloc]initWithFrame:CGRectMake(15, 80, self.view.frame.size.width-30, 44)];
            lbl_personads.text = [NSString stringWithFormat:@"%@%@",model.receiver_area,model.receiver_area_info];
            lbl_personads.numberOfLines = 2;
            [viewPerson addSubview:lbl_personads];
        }else if (indexPath.row == 3){
            UIView *viewTicket = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44*3)];
            viewTicket.backgroundColor = [UIColor whiteColor];
            [cell addSubview:viewTicket];
            UIImageView *imageLine12 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
            imageLine12.backgroundColor = [UIColor lightGrayColor];
            [viewTicket addSubview:imageLine12];
            UIImageView *imageLine22 = [[UIImageView alloc]initWithFrame:CGRectMake(0, viewTicket.frame.size.height-0.5, self.view.frame.size.width, 0.5)];
            imageLine22.backgroundColor = [UIColor lightGrayColor];
            [viewTicket addSubview:imageLine22];
            UIImageView *imageLine32 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 43, self.view.frame.size.width-15, 0.5)];
            imageLine32.backgroundColor = [UIColor lightGrayColor];
            [viewTicket addSubview:imageLine32];
            UILabel *lbl_ticket = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-15, 44)];
            lbl_ticket.text = @"发票信息:";
            [viewTicket addSubview:lbl_ticket];
            UILabel *lbl_ticket1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 44, self.view.frame.size.width-15, 44)];
            lbl_ticket1.text = [NSString stringWithFormat:@"发票类型:          %@",model.invoiceType];
            [viewTicket addSubview:lbl_ticket1];
            UILabel *lbl_ticket2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 88, self.view.frame.size.width-15, 44)];
            lbl_ticket2.text = [NSString stringWithFormat:@"发票台头:          %@",model.invoice];
            [viewTicket addSubview:lbl_ticket2];
        }else if (indexPath.row == 4){
            if ([model.order_status intValue] == 10) {
                
            }else{
                UIView *viewPay = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44*8)];
                viewPay.backgroundColor = [UIColor whiteColor];
                [cell addSubview:viewPay];
                UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
                imageLine.backgroundColor = [UIColor lightGrayColor];
                [viewPay addSubview:imageLine];
                UIImageView *imageLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, viewPay.frame.size.height-0.5, self.view.frame.size.width, 0.5)];
                imageLine2.backgroundColor = [UIColor lightGrayColor];
                [viewPay addSubview:imageLine2];
                UIImageView *imageLine3 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 43, self.view.frame.size.width-15, 0.5)];
                imageLine3.backgroundColor = [UIColor lightGrayColor];
                [viewPay addSubview:imageLine3];
                
                UILabel *lbl_paymess = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-15, 44)];
                lbl_paymess.text = @"支付方式及配送方式";
                [viewPay addSubview:lbl_paymess];
                UILabel *lbl_paymess1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 44, self.view.frame.size.width-15, 44)];
                lbl_paymess1.text = [NSString stringWithFormat:@"支付方式:          %@",model.payType];
                [viewPay addSubview:lbl_paymess1];
                UILabel *lbl_paymess2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 44*2, self.view.frame.size.width-15, 44)];
                lbl_paymess2.text = [NSString stringWithFormat:@"支付时间:          %@",model.payTime];
                [viewPay addSubview:lbl_paymess2];
                UILabel *lbl_paymess3 = [[UILabel alloc]initWithFrame:CGRectMake(15, 44*3, self.view.frame.size.width-15, 44)];
                lbl_paymess3.text = [NSString stringWithFormat:@"配送运费:          %.2f",model.ship_price.floatValue];
                [viewPay addSubview:lbl_paymess3];
                UILabel *lbl_paymess5 = [[UILabel alloc]initWithFrame:CGRectMake(15, 44*4, self.view.frame.size.width-15, 44)];
                
                
                [viewPay addSubview:lbl_paymess5];
                UILabel *lbl_paymess6 = [[UILabel alloc]initWithFrame:CGRectMake(15, 44*5, self.view.frame.size.width-15, 44)];
                if ([model.order_status intValue] == 20){
                    lbl_paymess5.text = [NSString stringWithFormat:@"发货快递:          还未发货"];
                    lbl_paymess6.text = [NSString stringWithFormat:@"发货时间:          还未发货"];
                }else{
                    lbl_paymess5.text = [NSString stringWithFormat:@"发货快递:          %@",model.company];
                    lbl_paymess6.text = [NSString stringWithFormat:@"发货时间:          %@",model.sendTime];
                }
                [viewPay addSubview:lbl_paymess6];
            }
        }
    }
    
    return cell;
}
-(void)cellSendbtnClicked{
    if (dataArray.count!=0) {
        Model *mmm = [dataArray objectAtIndex:0];
        OrderlistViewController *or = [OrderlistViewController sharedUserDefault];
        or.order_id = mmm.order_id;
        confirmdeliveryViewController *inin = [[confirmdeliveryViewController alloc]init];
        [self.navigationController pushViewController:inin animated:YES];
    }
    
}
-(void)cellShipbtnClicked:(UIButton *)btn{
    if (dataArray.count!=0) {
        Model *mmm = [dataArray objectAtIndex:0];
        OrderlistViewController *or = [OrderlistViewController sharedUserDefault];
        or.order_id = mmm.order_id;
        ModifyShipViewController *modify = [[ModifyShipViewController alloc]init];
        [self.navigationController pushViewController:modify animated:YES];
    }
}

-(void)cellTimebtnClicked:(UIButton *)btn{
    if (dataArray.count!=0) {
        Model *mmm = [dataArray objectAtIndex:0];
        OrderlistViewController *or = [OrderlistViewController sharedUserDefault];
        or.order_id = mmm.order_id;
        or.order_num = mmm.order_num;
        delayViewController *delay = [[delayViewController alloc]init];
        [self.navigationController pushViewController:delay animated:YES];
    }
}

-(void)cellCancelbtnClicked:(UIButton *)btn{
    if (dataArray.count!=0) {
        Model *mmm = [dataArray objectAtIndex:0];
        OrderlistViewController *or = [OrderlistViewController sharedUserDefault];
        or.order_id = mmm.order_id;
        or.order_num = mmm.order_num;
        OrderCancelViewController *modify = [[OrderCancelViewController alloc]init];
        [self.navigationController pushViewController:modify animated:YES];
    }
}

-(void)cellPricebtnClicked:(UIButton *)btn{
    if (dataArray.count!=0) {
        Model *mmm = [dataArray objectAtIndex:0];
        OrderlistViewController *or = [OrderlistViewController sharedUserDefault];
        or.order_id = mmm.order_id;
        ModifyPriceViewController *modify = [[ModifyPriceViewController alloc]init];
        [self.navigationController pushViewController:modify animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
}

@end
