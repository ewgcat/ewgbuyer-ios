//
//  writeViewController.m
//  My_App
//
//  Created by apple on 14-8-13.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "writeViewController.h"
#import "ASIFormDataRequest.h"
#import "ThirdViewController.h"
#import "uporderCell.h"
#import "AddAdminViewController.h"
#import "TicketViewController.h"
#import "UsecouponsViewController.h"
#import "DataVerifier.h"
#import "PayViewController.h"
#import "DetailViewController.h"
#import "OnlinePayTypeSelectViewController.h"
#import "CashOnDeliveryViewController.h"
#import "CashOnDeliveryViewController2.h"
#import "GoodsListViewController.h"
#import "FirstViewController.h"
#import "WritePayCell.h"
#import "WriteAddressCell.h"
#import "Cart4Cell.h"
#import "writeOrderGoodsCell.h"

@interface writeViewController ()<UIScrollViewDelegate>
{
    ASIFormDataRequest *request_1;
    ASIFormDataRequest *request_2;
    ASIFormDataRequest *request_3;
    ASIFormDataRequest *requestOnlinePayTypeSelect2;
    ASIFormDataRequest *request_Tran;
    NSInteger loginCount;
    NSString *oldOrderNum;
    NSString *oldOrderID;
    NSString *beforePrice;
    NSMutableArray *goodsListArray;
    
}

@end

@implementation writeViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request_3 clearDelegatesAndCancel];
    [request_2 clearDelegatesAndCancel];
    [request_1 clearDelegatesAndCancel];
    [requestOnlinePayTypeSelect2 clearDelegatesAndCancel];
    [request_Tran clearDelegatesAndCancel];
}

-(void)viewWillAppear:(BOOL)animated{
    loginCount += 1;
    FirstViewController *fff = [FirstViewController sharedUserDefault];
    if (fff.willAppearBool == 0) {
        
    }else{
        fff.willAppearBool = NO;
    }
    [super viewWillAppear:YES];
    [_MyTableView reloadData];
    self.tabBarController.tabBar.hidden = YES;
    
    
    [SYObject startLoading];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,DEFAULTADDRESSFIND_URL]];
    request_2 = [ASIFormDataRequest requestWithURL:url];
    [request_2 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request_2 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    
    [request_2 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_2.tag = 105;
    request_2.delegate = self;
    [request_2 setDidFailSelector:@selector(my1_urlRequestFailed:)];
    [request_2 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
    [request_2 startAsynchronous];
}
-(void)goodsListRequest
{
    [SYObject startLoading];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,BUYLIST_URL];

    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    NSDictionary *par = @{
                          @"cart_ids":th.jie_cart_ids
                         
                          };
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SYObject endLoading];
        NSLog(@"商品清单列表zt******%@",responseObject);
       
        NSDictionary *dict = responseObject;
        NSArray *arr = dict[@"goods_list"];
        for (NSDictionary *dic in arr) {
            ClassifyModel *clas = [[ClassifyModel alloc]init];
           
            clas.goods_main_photo = [dic objectForKey:@"goods_main_photo"];
            clas.goods_current_price =[dic objectForKey:@"goods_price"];
            clas.goods_name = [dic objectForKey:@"goods_name"];
            [goodsListArray addObject:clas];
        }
       
        [_MyTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        [SYObject failedPrompt:[error localizedDescription]];
        [SYObject endLoading];
    }];


}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createBackBtn];
    mybool  = NO;
    loginCount = 0;
    billdataArray = [[NSMutableArray alloc]init];
    dataArray = [[NSMutableArray alloc]init];
    goodsListArray = [[NSMutableArray alloc]init];
    
    third = [ThirdViewController sharedUserDefault];
    _realPrice.text = [NSString stringWithFormat:@"￥%@",third.jie_order_goods_price];
    third.pay = @"请选择支付方式";
    third.fee =  @"请选择配送方式";
    
    [_upBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _upBtn.tag = 101;
//    [_upBtn.layer setMasksToBounds:YES];
//    [_upBtn.layer setCornerRadius:4];
    [_upBtn addTarget:self action:@selector(buttonBackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
    [_upBtn addTarget:self action:@selector(buttonBackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.title = @"填写订单";
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    
    _MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _MyTableView.delegate = self;
    _MyTableView.dataSource=  self;
    _MyTableView.backgroundColor = [UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1];
    _MyTableView.showsVerticalScrollIndicator=NO;
    _MyTableView.showsHorizontalScrollIndicator = NO;
    
//    [self createAlertListView];
    
    [self network];
    [self goodsListRequest];
}
-(void)createAlertListView{
    alertList = [[WDAlertView alloc] initWithFrame:CGRectMake(0, 0, 250, 300)buttonSty:WDAlertViewTypeTwo title:@"以下商品全部无货" doneButtonTitle:@"更改收货地址" andCancelButtonTitle:@"返回购物车"];
    alertList.datasource = self;
    alertList.delegate=self;
    __unsafe_unretained typeof(self) blockSelf = self;
    //更改收货地址
    [alertList setDoneButtonWithBlock:^{
        [blockSelf->alertList dismiss];
        AddAdminViewController *add = [[AddAdminViewController alloc]init];
        [blockSelf.navigationController pushViewController:add animated:YES];
        
    }];
    NSUserDefaults *defau = [NSUserDefaults standardUserDefaults];
    NSMutableArray *EGoodsArray=[defau objectForKey:@"ErrorGoodsData"];
    if (!EGoodsArray) {
        EGoodsArray=[[NSMutableArray alloc]init];
    }else{
        EGoodsArray=[[NSMutableArray alloc]initWithArray:[defau objectForKey:@"ErrorGoodsData"]];
    }
    for (ClassifyModel *clas in alertListArray) {
        [EGoodsArray addObject:clas.car_cart_id];
    }
//返回购物车
    [alertList setCancelButtonBlock:^{
        [blockSelf->alertList dismiss];
        
        [defau setObject:EGoodsArray forKey:@"ErrorGoodsData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [blockSelf.navigationController popToRootViewControllerAnimated:YES];
        FirstViewController *fvc=[FirstViewController sharedUserDefault];
        fvc.tabBarController.selectedIndex = 2;
    }];
    
    [alertList showAlertListView];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    dataArray = nil;
    third = nil;
    labelTi = nil;
    _realPrice = nil;
    _MyTableView = nil;
}

-(void)dealloc {
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    dataArray = nil;
    billdataArray = nil;
    third = nil;
    labelTi = nil;
    _realPrice = nil;
    _MyTableView = nil;
}
#pragma mark - 点击事件
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)btnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    for(int i=0;i<billdataArray.count;i++){
        if (btn.tag == i+100) {
        }
    }
    if (btn.tag == 101) {
        //提交订单按钮，发送请求，取得订单号
//        third.jie_order_goods_price = [NSString stringWithFormat:@"%0.2f",-[third.usecouponsMoney floatValue]+[third.jie_order_goods_price floatValue]];
       
        third.jie_order_goods_price = [NSString stringWithFormat:@"%0.2f",-[third.usecouponsMoney floatValue]+[third.jie_order_goods_price floatValue]+[third.wuliu floatValue]];
        if ((float)third.jie_reduce>0) {
            third.jie_order_goods_price = [NSString stringWithFormat:@"%0.2f",-[third.usecouponsMoney floatValue]+[beforePrice floatValue]+[third.wuliu floatValue]-[[NSString stringWithFormat:@"%ld",(long)third.jie_reduce]floatValue]];
          
        }
        if (third.pay.length ==0  ||[third.pay isEqualToString:@"请选择支付方式"]) {
            [SYObject endLoading];
            [SYObject failedPrompt:@"支付方式不能为空"];
        }else if (third.fee.length == 0||[third.fee isEqualToString:@"请选择配送方式"]){
            [SYObject endLoading];
            [SYObject failedPrompt:@"配送方式不能为空"];
        }else if ( third.tic_pu.length ==0){
            [SYObject endLoading];
            [SYObject failedPrompt:@"发票类型不能为空"];
        }else{
//           验证是否是有效订单
//          [self getPlaceOrderRequest]
            [self getToDetermineWhetherTheGoodsAvailable];
            
            
        }
        third.usecouponsID = @"";
    }
    if (btn.tag == 200) {
        AddAdminViewController *add = [[AddAdminViewController alloc]init];
        [self.navigationController pushViewController:add animated:YES];
    }
    if (btn.tag == 201) {
        //支付和配送方式
        if (mybool==NO) {
            [SYObject endLoading];
            [SYObject failedPrompt:@"请确定收货人"];
        }else{
            PayViewController *add = [[PayViewController alloc]init];
            [self.navigationController pushViewController:add animated:YES];
        }
    }
    if (btn.tag == 202) {
        //发票
        TicketViewController *add = [[TicketViewController alloc]init];
        [self.navigationController pushViewController:add animated:YES];
    }
    if (btn.tag == 203) {
        UsecouponsViewController *ccc = [[UsecouponsViewController alloc]init];
        [self.navigationController pushViewController:ccc animated:YES];
    }
    if (btn.tag == 204) {
        UIStoryboard * homePageStoryboard = [UIStoryboard storyboardWithName:@"shoppingCart" bundle:nil];
        GoodsListViewController *ordrt = [homePageStoryboard instantiateViewControllerWithIdentifier:@"GoodsListViewController"];;
        [self.navigationController pushViewController:ordrt animated:YES];
    }
    if (btn.tag == 205) {
        AddAdminViewController *add = [[AddAdminViewController alloc]init];
        [self.navigationController pushViewController:add animated:YES];
    }
}
-(void)getToDetermineWhetherTheGoodsAvailable{
    [SYObject startLoading];
    NSString *url =[NSString stringWithFormat:@"%@%@",FIRST_URL,INVENTORY_URL];
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    NSArray *fileContent=[MyUtil returnLocalUserFile];
    NSDictionary *par = @{
                          @"user_id":fileContent[3],
                          @"token":fileContent[1],
                          @"app_cart_ids":th.jie_cart_ids,
                          @"address_id":th.person_addr_id
                          };
    [[Requester managerWithHeader]POST:url parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SYObject endLoading];
        NSDictionary * dict = responseObject;
       NSInteger code = [dict[@"code"] integerValue];
        if (code==100) {
            //验证成功
            [self getPlaceOrderRequest];
        }else if (code==-100){
            //验证未成功//解析商品
            alertListArray=[[NSMutableArray alloc]init];
            NSArray *arr = [dict objectForKey:@"error_data"];
            for(NSDictionary *dic in arr){
                ClassifyModel *clas = [[ClassifyModel alloc]init];
                clas.car_cart_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cart_id"]];
                clas.goods_main_photo = [dic objectForKey:@"goods_main_photo"];
                clas.goods_name =[dic objectForKey:@"goods_name"];
                [alertListArray addObject:clas];
            }
             [self createAlertListView];
//            [alertList showAlertListView];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject endLoading];
        [SYObject failedPrompt:@"网络请求失败"];
    }];




}
-(void)getPlaceOrderRequest{
    [SYObject startLoading];
    //发起订单提交
    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,UPDINGDAN_URL]];
    request_3=[ASIFormDataRequest requestWithURL:url3];
    
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    [request_3 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request_3 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    [request_3 setPostValue:th.jie_cart_ids forKey:@"cart_ids"];
    [request_3 setPostValue:th.jie_store_ids forKey:@"store_id"];
    [request_3 setPostValue:th.person_addr_id forKey:@"addr_id"];
    //自提点信息
    [request_3 setPostValue:th.delivery_type forKey:@"delivery_type"];
    [request_3 setPostValue:th.delivery_id forKey:@"delivery_id"];
    
    [request_3 setPostValue:@"ios" forKey:@"order_type"];
    if ([third.pay isEqualToString:@"在线支付"]) {
        [request_3 setPostValue:@"" forKey:@"payType"];
    }else{
        [request_3 setPostValue:@"货到付款" forKey:@"payType"];
    }
    [request_3 setPostValue:th.tic_taitou forKey:@"invoice"];
    
    if ([th.tic_pu isEqualToString:@"专用发票"]) {
        [request_3 setPostValue:@"1" forKey:@"invoiceType"];
    }else{
        [request_3 setPostValue:@"0" forKey:@"invoiceType"];
    }
    
    [request_3 setPostValue:th.usecoupons_id forKey:@"coupon_id"];
    NSArray *myarr = [third.trans componentsSeparatedByString:@","];
    NSLog(@"myarr:%@",myarr);
    for(int i=0;i<myarr.count;i++){
        [request_3 setPostValue:[myarr objectAtIndex:i] forKey:@"trans_id"];
    }
    NSArray *myarr2 = [third.ship_price componentsSeparatedByString:@","];
    for(int i=0;i<myarr2.count;i++){
        [request_3 setPostValue:[myarr2 objectAtIndex:i] forKey:@"ship_price_id"];
    }
    NSMutableArray *mArray=[[NSMutableArray alloc]init];
    for (NSString *str in myarr) {
        NSArray *arr=[str componentsSeparatedByString:@"["];
        [mArray addObject:arr[0]];
    }
    NSArray *store_ids=[th.jie_store_ids componentsSeparatedByString:@","];
    for (int i=0; i<mArray.count; i++) {
        if (i<store_ids.count) {
             NSString *key=[NSString stringWithFormat:@"transport_%@",store_ids[i]];
            NSString *vale=[mArray objectAtIndex:i];
            [request_3 setPostValue:vale forKey:key];
        }
    }
    [request_3 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_3.tag = 101;
    request_3.delegate = self;
    
    [request_3 setDidFailSelector:@selector(urlRequestFailed:)];
    [request_3 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [request_3 startAsynchronous];
}


#pragma mark - tabelView方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4) {
       // return 350;
         if(third.jie_reduce == 0){
             return 305-44+25;
         }else
         {
         return 305+30;
         }
    }else if (indexPath.row == 0){
        return 80;
    }else if (indexPath.row == 3){
        //动态计算高度
        NSString *shipTypeStr = third.fee;
        //根据约束计算出label的宽度
        CGFloat left = 100.f;
        CGFloat right = 30.f;
        CGFloat w = ScreenFrame.size.width - left - right;
        CGSize maxSize = CGSizeMake(w, CGFLOAT_MAX);
        NSDictionary *font = @{NSFontAttributeName:[UIFont systemFontOfSize:17.f]};
        CGFloat h = [shipTypeStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:font context:nil].size.height;
        //算出总高度，返回
        CGFloat cellH = 88 + h + 34-31;
        return cellH;
    }else if (indexPath.row == 2){
        
        return 80;
        
    }else if (indexPath.row == 1){
        
        return 10;
        
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 4) {
        uporderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"downCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"uporderCell" owner:self options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1];
        }
        //单元格点击方法
        cell.ticketBtn.tag = 202;
        [cell.ticketBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.couponBtn.tag = 203;
        [cell.couponBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.goodsListBtn.tag = 204;
        [cell.goodsListBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        //第一次进入默认发票
        if (loginCount==1) {
            third.tic_pu = @"普通发票";
            third.tic_taitou = @"个人";
        }
        cell.ticketType.text = third.tic_pu;
        cell.ticketTop.text = third.tic_taitou;

        if (loginCount==1) {
            //初始化设置都在这里~~
            third.usecouponsMoney = @"0";
        }else{
        }
        if([third.wuliu isEqualToString:@"(null)"]||!third.wuliu){
            third.wuliu = @"0";
        }
        cell.shipPrice.text = [NSString stringWithFormat:@"+￥%@",third.wuliu];
        cell.couponsPrice.text = [NSString stringWithFormat:@"-￥%0.2f",[third.usecouponsMoney floatValue]];
//        cell.realPrice.text =[NSString stringWithFormat:@"￥%0.2f",-[third.usecouponsMoney floatValue]+[third.jie_order_goods_price floatValue]+[third.wuliu floatValue]];
        
        if ((float)third.jie_reduce>0) {
            cell.goodsPrice.text =[NSString stringWithFormat:@"+￥%0.2f",[beforePrice floatValue]] ;
        }else{
            cell.goodsPrice.text =[NSString stringWithFormat:@"+￥%0.2f",[third.jie_order_goods_price floatValue]] ;
        
        }
        
        
//        _realPrice.text =cell.realPrice.text ;
         _realPrice.text =[NSString stringWithFormat:@"￥%0.2f",-[third.usecouponsMoney floatValue]+[third.jie_order_goods_price floatValue]+[third.wuliu floatValue]];
        if(third.jie_reduce == 0){
            cell.reduceLabel.hidden = YES;
            cell.reducePrice.hidden = YES;
            cell.bottomLine.hidden=YES;
            cell.grayView.hidden=NO;
            
            
        }else{
            cell.reduceLabel.hidden = NO;
            cell.reducePrice.hidden = NO;
             cell.grayView.hidden=YES;
             cell.bottomLine.hidden=NO;
            
//            cell.realPrice.text =[NSString stringWithFormat:@"￥%0.2f",-[third.usecouponsMoney floatValue]+[beforePrice floatValue]+[third.wuliu floatValue]-[[NSString stringWithFormat:@"%ld",(long)third.jie_reduce]floatValue]];
//            _realPrice.text =cell.realPrice.text ;
            _realPrice.text =[NSString stringWithFormat:@"￥%0.2f",-[third.usecouponsMoney floatValue]+[beforePrice floatValue]+[third.wuliu floatValue]-[[NSString stringWithFormat:@"%ld",(long)third.jie_reduce]floatValue]];
        }
        cell.reducePrice.text = [NSString stringWithFormat:@"-￥%0.2f",(float)third.jie_reduce];
        return cell;
    }else if (indexPath.row==0){
        //地址栏
        WriteAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell"];
        if(!cell){
            cell = [[[NSBundle mainBundle]loadNibNamed:@"WriteAddressCell" owner:self options:nil]lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.name.text =[NSString stringWithFormat:@"%@",third.person_name];
        cell.phone.text =[NSString stringWithFormat:@"%@",third.person_phone];
        cell.address.text =third.person_address;
        //判断是否有默认地址
        if (mybool == NO) {
            cell.nothingView.hidden = NO;
        }else{
            cell.nothingView.hidden = YES;
        }
        //点击方法
        cell.addAddressBtn.tag = 200;
        [cell.addAddressBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectAddress.tag = 205;
        [cell.selectAddress addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else if (indexPath.row==3){
        //支付和配送方式栏
        WritePayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"paycell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"WritePayCell" owner:self options:nil]lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (loginCount==1) {
            //初始化设置都在这里~~
            third.pay = @"请选择支付方式";
            third.fee = @"请选择配送方式";
        }else{
        }
        cell.paytype.text = [NSString stringWithFormat:@"%@",third.pay];
        cell.shipType.text = [NSString stringWithFormat:@"%@\n",third.fee];
        //单元格点击方法
        cell.payBtn.tag = 201;
        [cell.payBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else if (indexPath.row==2)
    {
        //新增商品cell
        writeOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"writeOrderGoods"];
        if(!cell){
            cell = [[[NSBundle mainBundle]loadNibNamed:@"writeOrderGoodsCell" owner:self options:nil]lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        if (goodsListArray.count ==0) {
            }else if (goodsListArray.count==1){
                cell.muchView.hidden = YES;
                ClassifyModel *clas = [goodsListArray objectAtIndex:0];
                for(int i=0;i<goodsListArray.count;i++){
                    
                    [cell.img sd_setImageWithURL:[NSURL URLWithString:clas.goods_main_photo] placeholderImage:[UIImage imageNamed:@"kong_lj.png"]];
                    cell.content.text = clas.goods_name;
                    cell.price.text=[NSString stringWithFormat:@"￥%@",clas.goods_current_price];
                }
            }else{
                cell.muchView.hidden = NO;
                cell.scrollView.bounces = YES;
                cell.scrollView.delegate = self;
                cell.scrollView.userInteractionEnabled = YES;
                cell.scrollView.showsHorizontalScrollIndicator = NO;
                cell.scrollView.contentSize=CGSizeMake(65*goodsListArray.count+15,65);
                for(int i=0;i<goodsListArray.count;i++){
                    
                    ClassifyModel *clas = [goodsListArray objectAtIndex:i];
                    UIImageView *imgTrademark = [[UIImageView alloc]initWithFrame:CGRectMake(15+65*i, 12, 58, 58)];
                    imgTrademark.userInteractionEnabled = YES;
                    [imgTrademark sd_setImageWithURL:[NSURL URLWithString:clas.goods_main_photo] placeholderImage:[UIImage imageNamed:@"kong_lj.png"]];
                    [cell.scrollView addSubview:imgTrademark];
                }
            }
        return cell;
    
    }
    else {
        UITableViewCell *cell = [UITableViewCell new];
        cell.backgroundColor=UIColorFromRGB(0xF2F2F2);
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2)
    {
        UIStoryboard * homePageStoryboard = [UIStoryboard storyboardWithName:@"shoppingCart" bundle:nil];
        GoodsListViewController *ordrt = [homePageStoryboard instantiateViewControllerWithIdentifier:@"GoodsListViewController"];;
        [self.navigationController pushViewController:ordrt animated:YES];

    }

}

#pragma mark - 网络
-(void)getGooddsPrice{
    NSString *url =[NSString stringWithFormat:@"%@%@",FIRST_URL,CAR_UP_ORDER_URL];
    NSArray *fileContent=[MyUtil returnLocalUserFile];
    NSDictionary *par = @{
                          @"user_id":fileContent[3],
                          @"token":fileContent[1],
                          @"cart_ids":third.jie_cart_ids
                          };
    [[Requester managerWithHeader]POST:url parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dict = responseObject;
        if ([dict objectForKey:@"before"]) {
            beforePrice=[NSString stringWithFormat:@"%0.2f",[[dict objectForKey:@"before"] floatValue]];
        }else{
            beforePrice=[NSString stringWithFormat:@"%0.2f",[[dict objectForKey:@"order_goods_price"] floatValue]];
        }
          [_MyTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:@"网络请求失败"];
    }];
}
-(void)network{
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ADDLIST_URL]];
    request_1 = [ASIFormDataRequest requestWithURL:url];
    [request_1 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request_1 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    
    [request_1 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_1.tag = 104;
    request_1.delegate = self;
    [request_1 setDidFailSelector:@selector(my2_urlRequestFailed:)];
    [request_1 setDidFinishSelector:@selector(my2_urlRequestSucceeded:)];
    [request_1 startAsynchronous];
    
//    loadingV.hidden = NO;
    [SYObject startLoading];
    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,DEFAULTADDRESSFIND_URL]];
    request_2 = [ASIFormDataRequest requestWithURL:url2];
    [request_2 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request_2 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    
    [request_2 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_2.tag = 105;
    request_2.delegate = self;
    [request_2 setDidFailSelector:@selector(my1_urlRequestFailed:)];
    [request_2 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
    [request_2 startAsynchronous];
    
    NSURL *url22 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ALLPAYTYPE_URL]];
    requestOnlinePayTypeSelect2 = [ASIFormDataRequest requestWithURL:url22];
    
    [requestOnlinePayTypeSelect2 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [requestOnlinePayTypeSelect2 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    
    [requestOnlinePayTypeSelect2 setRequestHeaders:[LJControl requestHeaderDictionary]];
    requestOnlinePayTypeSelect2.tag = 102;
    requestOnlinePayTypeSelect2.delegate = self;
    [requestOnlinePayTypeSelect2 setDidFailSelector:@selector(my1_urlRequestFailed:)];
    [requestOnlinePayTypeSelect2 setDidFinishSelector:@selector(payType_urlRequestSucceeded:)];
    [requestOnlinePayTypeSelect2 startAsynchronous];
    
    NSURL *urlfee = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,CARFEE_URL]];
    request_Tran = [ASIFormDataRequest requestWithURL:urlfee];
    [request_Tran setPostValue:third.jie_cart_ids forKey:@"cart_ids"];
    [request_Tran setPostValue:third.jie_store_ids forKey:@"store_ids"];
    if (third.person_addr_id.length == 0) {
        [request_Tran setPostValue:@"1" forKey:@"addr_id"];
    }else{
        [request_Tran setPostValue:third.person_addr_id forKey:@"addr_id"];
    }
    
    [request_Tran setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_Tran.tag = 101;
    request_Tran.delegate = self;
    [request_Tran setDidFailSelector:@selector(my2_urlRequestFailed:)];
    [request_Tran setDidFinishSelector:@selector(mmurlRequestSucceeded:)];
    [request_Tran startAsynchronous];
    
    [self getGooddsPrice];
    
}
-(void)mmurlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig:%@",dicBig);
        NSArray *myAA = [dicBig objectForKey:@"trans_list"];
        NSString *strship;
        NSString *strship_id;
        for(NSDictionary *dic in myAA){
            if (strship.length == 0) {
                strship = [NSString stringWithFormat:@"%@:%@",[dic objectForKey:@"store_name"],[[[dic objectForKey:@"transInfo_list"] objectAtIndex:0] objectForKey:@"key"]];
            }else{
                strship = [NSString stringWithFormat:@"%@,%@:%@",strship,[dic objectForKey:@"store_name"],[[[dic objectForKey:@"transInfo_list"] objectAtIndex:0] objectForKey:@"key"]];
            }
            if (strship_id.length == 0) {
                strship_id = [NSString stringWithFormat:@"%@",[[[dic objectForKey:@"transInfo_list"] objectAtIndex:0] objectForKey:@"value"]];
            }else{
                strship_id = [NSString stringWithFormat:@"%@,%d",strship_id,[[[[dic objectForKey:@"transInfo_list"] objectAtIndex:0] objectForKey:@"value"] intValue]];
            }
        }
        third.fee = strship;
        third.trans = strship_id;
    }
    [_MyTableView reloadData];
}
-(void)payType_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"1222dicBig:%@",dicBig);
        if(dicBig){
            NSArray *arr = [dicBig objectForKey:@"datas"];
            if (arr.count !=0 ) {
                third.pay = @"在线支付";
            }else{
                third.pay = @"货到付款";
            }
        }
        
    }
    [_MyTableView reloadData];
//    loadingV.hidden = YES;
    [SYObject endLoading];
}
-(void)my2_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        
    }else{
        [SYObject endLoading];
        [SYObject failedPrompt:@"请求出错"];
    }

    [SYObject endLoading];
    
}
-(void)my2_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig2:%@",dicBig);
        if ([[dicBig objectForKey:VERIFY]intValue] == 0) {
            
        }else{
            if ([[dicBig allKeys] containsObject:@"addr_id"]){
                mybool = YES;
                third.person_addr_id =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"addr_id"]];
                third.person_address =[NSString stringWithFormat:@"%@%@",[dicBig objectForKey:@"area"],[dicBig objectForKey:@"areaInfo"]];
                third.person_name=[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"trueName"]];
                NSString *str =[dicBig objectForKey:@"telephone"];
                if(str.length == 0){
                    third.person_phone =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"mobile"]];
                }else{
                    third.person_phone =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"telephone"]];
                }
                
            }else{
                mybool = NO;
            }
        }
        [_MyTableView reloadData];
    }

    [SYObject endLoading];
}
-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig1:%@",dicBig);
        FirstViewController *ff = [FirstViewController sharedUserDefault];
        ff.willAppearBool = YES;
        
        NSString *orderNum = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"order_num"]];
        NSString *orderID = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"order_id"]];
        third.ding_hao = orderNum;
        third.ding_order_id = orderID;
        
        third.ding_fangshi = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"payType"]];
        
        third.zongji.text = @"0.00";
        third.cart_ids = @"";
        third.jiesuan.text = @"0";
        [third.btnQ2 setTitle:[NSString stringWithFormat:@"结算(%@)",third.jiesuan.text] forState:UIControlStateNormal];
        third.btnQ2.backgroundColor = [UIColor grayColor];
        
        if ([third.pay isEqualToString:@"在线支付"]) {
            OnlinePayTypeSelectViewController *onnn = [[OnlinePayTypeSelectViewController alloc]init];
            [self.navigationController pushViewController:onnn animated:YES];
        }else{
            //这里应该进入货到付款
            UIStoryboard * homePageStoryboard = [UIStoryboard storyboardWithName:@"usercenterStoryboard" bundle:nil];
            CashOnDeliveryViewController2 *ordrt = [homePageStoryboard instantiateViewControllerWithIdentifier:@"CashOnDeliveryViewController2"];
            ordrt.orderNum = third.ding_hao;
            ordrt.orderID = third.ding_order_id;
            ordrt.realPrice = -[third.usecouponsMoney floatValue]+[third.jie_order_goods_price floatValue]+[third.wuliu floatValue];
            [self.navigationController pushViewController:ordrt animated:YES];
        }
    }else{
        [SYObject endLoading];
        [SYObject failedPrompt:@"提交失败"];
    }

    [SYObject endLoading];
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
#pragma mark -设置行数
- (NSInteger)alertListTableView:(WDAlertView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return alertListArray.count;
}
-(CGFloat)alertListTableView:(WDAlertView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (alertListArray.count!=0) {
        return 80;
        
    }
    return 0;

}
- (UITableViewCell *)alertListTableView:(WDAlertView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassifyModel *class = [alertListArray objectAtIndex:indexPath.row];
    Cart4Cell *cell = [tableView dequeueReusableAlertListCellWithIdentifier:[NSString stringWithFormat:@"Cart4Cell%ld_%ld", (long)indexPath.section, (long)indexPath.row]];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"Cart4Cell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.pictureImageView sd_setImageWithURL:[NSURL URLWithString:class.goods_main_photo] placeholderImage:[UIImage imageNamed:@"kong"]];
    cell.nameLabel.text = class.goods_name;
    return cell;


}
- (void)alertListTableView:(WDAlertView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
 
}

- (void)alertListTableView:(WDAlertView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
}



@end
