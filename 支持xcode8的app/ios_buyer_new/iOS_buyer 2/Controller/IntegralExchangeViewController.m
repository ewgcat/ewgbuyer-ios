//
//  IntegralExchangeViewController.m
//  My_App
//
//  Created by apple on 14-12-29.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "IntegralExchangeViewController.h"
#import "ASIFormDataRequest.h"
#import "intergalCell.h"
#import "LoginViewController.h"
#import "goodsReturnApplyViewController.h"
#import "IntegraDetialViewController.h"
#import "LifeGroupViewController.h"
#import "IntegralOrderDetailViewController.h"
#import "LoginViewController.h"
#import "ThirdViewController.h"
#import "MoneyPayIntegralViewController.h"
#import "onlinePayTypesIntegralViewController.h"
#import "FirstViewController.h"
#import "ThreeDotView.h"
#import "OnlinePayTypeSelectViewController.h"

@interface IntegralExchangeViewController ()

@property (nonatomic, weak)ThreeDotView *tdv;

@end

@implementation IntegralExchangeViewController

-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
    
    UIButton *buttonChat = [UIButton buttonWithType:UIButtonTypeCustom ];
    buttonChat.frame =CGRectMake(0, 0, 24, 24);
    [buttonChat setBackgroundImage:[UIImage imageNamed:@"point"] forState:UIControlStateNormal];
    [buttonChat addTarget:self action:@selector(More) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar2 = [[UIBarButtonItem alloc]initWithCustomView:buttonChat];
    self.navigationItem.rightBarButtonItem =bar2;
}
- (void)mainBtnClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:NO];
    UIButton *btn = (UIButton *)sender;
    FirstViewController *first = [FirstViewController sharedUserDefault];
    if (btn.tag == 101) {
        [first tabbarIndex:0];
    }else if (btn.tag == 102) {
        [first tabbarIndex:1];
    }else if (btn.tag == 103) {
        [first tabbarIndex:2];
    }else if (btn.tag == 104) {
        [first tabbarIndex:3];
    }else{
        [first tabbarIndex:4];
    }
}

//-(void)More{
//    if (muchBool == NO) {
//        muchView.hidden = NO;
//        muchBool = YES;
//    }else{
//        muchView.hidden = YES;
//        muchBool = NO;
//    }
//}


-(void)viewDidLayoutSubviews{
    [self createMoreBtn];
}
-(void)createMoreBtn{
    ThreeDotView *tdv = [[ThreeDotView alloc]initWithButtonCount:1 nc:self.navigationController];
    self.tdv = tdv;
    tdv.dataArray = dataArray;
    tdv.vc = self;
    [tdv insertMoreBtn:[tdv homeBtn]];
    tdv.hidden = YES;
}
-(void)More{
    self.tdv.hidden = NO;
    self.tdv.tri.hidden=NO;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request_1 clearDelegatesAndCancel];
    [request_2 clearDelegatesAndCancel];
    [request_3 clearDelegatesAndCancel];
    [request_4 clearDelegatesAndCancel];
    [request_5 clearDelegatesAndCancel];
    [request_6 clearDelegatesAndCancel];
    [request_7 clearDelegatesAndCancel];
    [request_8 clearDelegatesAndCancel];
    [request_9 clearDelegatesAndCancel];
    [MyTableView setEditing:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [SYObject startLoading];
    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,INTEGRAL_ORDERLIST_URL]];
    request_1=[ASIFormDataRequest requestWithURL:url3];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    [request_1 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request_1 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    [request_1 setPostValue:@"0"forKey:@"beginCount"];
    
    [request_1 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_1.tag = 101;
    request_1.delegate = self;
    [request_1 setDidFailSelector:@selector(urlRequestFailed:)];
    [request_1 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [request_1 startAsynchronous];
    [super viewWillAppear:YES];
    [MyTableView setEditing:NO];
}
-(void)refresh{
    [SYObject startLoading];
    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,INTEGRAL_ORDERLIST_URL]];
    request_2=[ASIFormDataRequest requestWithURL:url3];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    [request_2 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request_2 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    [request_2 setPostValue:@"0"forKey:@"beginCount"];
    
    [request_2 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_2.tag = 101;
    request_2.delegate = self;
    [request_2 setDidFailSelector:@selector(urlRequestFailed:)];
    [request_2 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [request_2 startAsynchronous];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    muchBool = NO;
    muchView.hidden = YES;
    [grayMuchImage.layer setMasksToBounds:YES];
    [grayMuchImage.layer setCornerRadius:4];
    
    self.title = @"积分兑换订单";
    [self createBackBtn];
    requestBool = NO;
    dataArray = [[NSMutableArray alloc]init];
    dataArrayShangla = [[NSMutableArray alloc]init];
    
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    
    MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MyTableView.delegate = self;
    MyTableView.dataSource=  self;
    MyTableView.showsVerticalScrollIndicator=NO;
    MyTableView.showsHorizontalScrollIndicator = NO;
    MyTableView.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1];
    [MyTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
}

#pragma mark - tabelView方法
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        NSLog(@"要删除啦~~~~~");
        
    }else{
        
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == MyTableView) {
        if (dataArray.count!=0) {
            return dataArray.count;
        }
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == MyTableView){
        if (dataArray.count!=0) {
            return 225;
        }
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myTabelviewCell = @"intergalCell";
    intergalCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"intergalCell" owner:self options:nil] lastObject];
    }
    if (dataArray.count!=0) {
        ClassifyModel *class = [dataArray objectAtIndex:indexPath.row];
        cell.order_num.text = [NSString stringWithFormat:@"  订单号:%@",class.dingdetail_order_id];
        
        if(class.goods_groupinfos.count == 1){
            cell.muchView.hidden = YES;
            for(int i=0;i<class.goods_groupinfos.count;i++){
                [cell.photoImage sd_setImageWithURL:(NSURL*)[[class.goods_groupinfos objectAtIndex:i] objectForKey:@"goods_img"]  placeholderImage:[UIImage imageNamed:@"kong_lj"]];
                cell.name.text = [[class.goods_groupinfos objectAtIndex:i] objectForKey:@"goods_name"];
                cell.count.text = [NSString stringWithFormat:@"数量:%@",[[class.goods_groupinfos objectAtIndex:i] objectForKey:@"goods_count"]];
            }
        }else{
            cell.muchView.hidden = NO;
            cell.scrollView.tag = 102;
            cell.scrollView.bounces = YES;
            cell.scrollView.delegate = self;
            cell.scrollView.userInteractionEnabled = YES;
            cell.scrollView.showsHorizontalScrollIndicator = NO;
            cell.scrollView.contentSize=CGSizeMake(65*class.goods_groupinfos.count+15,78);
            
            for(int i=0;i<class.goods_groupinfos.count;i++){
                UIImageView *imgTrademark = [[UIImageView alloc]initWithFrame:CGRectMake(15+65*i, 10, 60, 60)];
                imgTrademark.userInteractionEnabled = YES;
                [imgTrademark sd_setImageWithURL:[NSURL URLWithString:[[class.goods_groupinfos objectAtIndex:i] objectForKey:@"goods_img"]] placeholderImage:[UIImage imageNamed:@"kong_lj.png"]];
                [cell.scrollView addSubview:imgTrademark];
            }
        }
        cell.intergalLabel.text = [NSString stringWithFormat:@"消耗积分:%@",class.goods_total_price];
        cell.shipprice.text = [NSString stringWithFormat:@"运费: ￥%.2f",[class.dingdetail_ship_price floatValue]];
        
        if ([class.goods_status intValue] == 0) {//说明此时是未支付状态呢
            cell.btn2.hidden = NO;
            cell.btn1.hidden = NO;
            cell.order_status.text = @"待付款";
            [cell.btn2 setTitle:@"支付" forState:UIControlStateNormal];
            cell.btn2.tag = 100+indexPath.row;
            [cell.btn2 addTarget:self action:@selector(btnPayClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.btn1 setTitle:@"取消" forState:UIControlStateNormal];
            cell.btn1.tag = 100+indexPath.row;
            [cell.btn1 addTarget:self action:@selector(btnCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else if ([class.goods_status intValue] == 20){//详情
            cell.btn2.hidden = YES;
            cell.btn1.hidden = YES;
            cell.order_status.text = @"待发货";
        }else if ([class.goods_status intValue] == 30){
            cell.btn2.hidden = YES;
            cell.btn1.hidden = NO;
            cell.order_status.text = @"已发货";
            [cell.btn1 setTitle:@"确认收货" forState:UIControlStateNormal];
            cell.btn1.tag = 100+indexPath.row;
            [cell.btn1 addTarget:self action:@selector(btnEnsureClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else if ([class.goods_status intValue] == 40){
            cell.btn2.hidden = YES;
            cell.btn1.hidden = YES;
            cell.order_status.text = @"已收货";
        }else if ([class.goods_status intValue] == -1){
            cell.btn2.hidden = YES;
            cell.btn1.hidden = YES;
            cell.order_status.text = @"已取消";
        }else if ([class.goods_status intValue] == 10){
            cell.order_status.text = @"线下支付已付款(待审核)";
            cell.btn2.hidden = YES;
            cell.btn1.hidden = YES;
        }else{
            cell.order_status.text = @"已取消";
            cell.btn2.hidden = YES;
            cell.btn1.hidden = YES;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == MyTableView) {
        if (dataArray.count!=0) {
            //此处应该条状进入  ---》  生活团购商品订单详情
            ClassifyModel *class = [dataArray objectAtIndex:indexPath.row];
            LoginViewController *log = [LoginViewController sharedUserDefault];
            log.return_oid = class.goods_oid;
            UIStoryboard * homePageStoryboard = [UIStoryboard storyboardWithName:@"usercenterStoryboard" bundle:nil];
            IntegralOrderDetailViewController *ordrt = [homePageStoryboard instantiateViewControllerWithIdentifier:@"IntegralOrderDetailViewController"];;
            [self.navigationController pushViewController:ordrt animated:YES];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击事件
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)btnClicked:(UIButton *)btn{
    if (dataArray.count!=0) {
        if (btn.tag<100) {
            ClassifyModel *class = [dataArray objectAtIndex:0];
            LoginViewController *log = [LoginViewController sharedUserDefault];
            for(int i=0;i<class.dingdetail_goods_maps.count;i++){
                if (btn.tag == i) {
                    if ([[[class.dingdetail_goods_maps objectAtIndex:i] objectForKey:@"return_can"] isEqualToString:@"false"]) {
                        log.return_CancelBool = NO;
                    }else{
                        log.return_CancelBool = YES;
                    }
                    log.return_goods_id = [[class.dingdetail_goods_maps objectAtIndex:i] objectForKey:@"goods_id"];
                    log.return_oid = class.dingdetail_oid;
                    log.return_gsp_ids = [[class.dingdetail_goods_maps objectAtIndex:i] objectForKey:@"goods_gsp_ids"];
                    log.return_ImagePhoto = [[class.dingdetail_goods_maps objectAtIndex:i] objectForKey:@"goods_img"];
                    log.return_Name = [[class.dingdetail_goods_maps objectAtIndex:i] objectForKey:@"goods_name"];
                    
                    goodsReturnApplyViewController *gg = [[goodsReturnApplyViewController alloc]init];
                    [self presentViewController:gg animated:YES completion:nil];
                }
            }
        }else{
            ClassifyModel *class = [dataArray objectAtIndex:btn.tag/100];
            LoginViewController *log = [LoginViewController sharedUserDefault];
            for(int i=0;i<class.dingdetail_goods_maps.count;i++){
                if (btn.tag%100 == i) {
                    if ([[[class.dingdetail_goods_maps objectAtIndex:i] objectForKey:@"return_can"] isEqualToString:@"false"]) {
                        log.return_CancelBool = NO;
                    }else{
                        log.return_CancelBool = YES;
                    }
                    log.return_goods_id = [[class.dingdetail_goods_maps objectAtIndex:i] objectForKey:@"goods_id"];
                    log.return_oid = class.dingdetail_oid;
                    log.return_gsp_ids = [[class.dingdetail_goods_maps objectAtIndex:i] objectForKey:@"goods_gsp_ids"];
                    log.return_ImagePhoto = [[class.dingdetail_goods_maps objectAtIndex:i] objectForKey:@"goods_img"];
                    log.return_Name = [[class.dingdetail_goods_maps objectAtIndex:i] objectForKey:@"goods_name"];
                    
                    goodsReturnApplyViewController *gg = [[goodsReturnApplyViewController alloc]init];
                    [self presentViewController:gg animated:YES completion:nil];
                }
            }
        }
    }
}
-(void)btnEnsureClicked:(UIButton *)btn{
    if (dataArray.count != 0) {
        ClassifyModel *calaa= [dataArray objectAtIndex:btn.tag-100];
        if ([calaa.goods_status intValue] == 30) {
            oid = [NSString stringWithFormat:@"%@",calaa.goods_oid];
            //发起确认收货的请求 应该是弹出提示框  INTEGRAL_ORDERENSUREGOODS_URL
            [OHAlertView showAlertWithTitle:@"提示" message:@"您确定要收货吗?"   cancelButton:nil otherButtons:@[@"确定",@"取消"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                if (buttonIndex == 0){
                    [SYObject startLoading];
                    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,INTEGRAL_ORDERENSUREGOODS_URL]];
                    request_4=[ASIFormDataRequest requestWithURL:url3];
                    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                    NSString *documentsPath = [docPath objectAtIndex:0];
                    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                    [request_4 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
                    [request_4 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
                    [request_4 setPostValue:oid forKey:@"oid"];
                    
                    [request_4 setRequestHeaders:[LJControl requestHeaderDictionary]];
                    request_4.tag = 101;
                    request_4.delegate = self;
                    [request_4 setDidFailSelector:@selector(my3_urlRequestFailed:)];
                    [request_4 setDidFinishSelector:@selector(my3_urlRequestSucceeded:)];
                    [request_4 startAsynchronous];
                }else{
                }
            }];

            
        }
    }
}

-(void)btnGoodsClicked:(UIButton *)btn{
    if (dataArray.count != 0) {
        
    }
}

-(void)btnPayClicked:(UIButton *)btn{
    if(dataArray.count!=0){
        ClassifyModel *class = [dataArray objectAtIndex:btn.tag -100];
        ThirdViewController *th = [ThirdViewController sharedUserDefault];
        th.ding_order_id = [NSString stringWithFormat:@"%@",class.goods_oid];
        th.ding_hao = [NSString stringWithFormat:@"%@",class.dingdetail_order_id];
        th.jie_order_goods_price = [NSString stringWithFormat:@"%@",class.dingdetail_ship_price];
//        onlinePayTypesIntegralViewController *ooo = [[onlinePayTypesIntegralViewController alloc]init];
//        [self.navigationController pushViewController:ooo animated:YES];
        OnlinePayTypeSelectViewController *onnn = [[OnlinePayTypeSelectViewController alloc]init];
        onnn.order_type=@"integral";
        [self.navigationController pushViewController:onnn animated:YES];
    }
}

-(void)btnCancelClicked:(UIButton *)btn{
    deletTag = btn.tag -100;
    [OHAlertView showAlertWithTitle:@"系统提示" message:@"您要取消该订单？"   cancelButton:nil otherButtons:@[@"确定",@"取消"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
        if (buttonIndex == 0){
            ClassifyModel *class = [dataArray objectAtIndex:deletTag];
            //发起删除的请求
            [SYObject startLoading];
            NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,INTEGRAL_ORDERCANCEL_URL]];
            request_3=[ASIFormDataRequest requestWithURL:url3];
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
            [request_3 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
            [request_3 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
            [request_3 setPostValue:class.goods_oid forKey:@"oid"];
            
            [request_3 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request_3.tag = 101;
            request_3.delegate = self;
            [request_3 setDidFailSelector:@selector(mmm_urlRequestFailed:)];
            [request_3 setDidFinishSelector:@selector(mmm_urlRequestSucceeded:)];
            [request_3 startAsynchronous];
        }else{
        }

    }];

    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101) {
        if (buttonIndex == 0){
            ClassifyModel *class = [dataArray objectAtIndex:deletTag];
            //发起删除的请求
            [SYObject startLoading];
            NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,INTEGRAL_ORDERCANCEL_URL]];
            request_3=[ASIFormDataRequest requestWithURL:url3];
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
            [request_3 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
            [request_3 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
            [request_3 setPostValue:class.goods_oid forKey:@"oid"];
            
            [request_3 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request_3.tag = 101;
            request_3.delegate = self;
            [request_3 setDidFailSelector:@selector(mmm_urlRequestFailed:)];
            [request_3 setDidFinishSelector:@selector(mmm_urlRequestSucceeded:)];
            [request_3 startAsynchronous];
        }else{
        }
    }
    if (alertView.tag == 102) {
        if (buttonIndex == 0){
            [SYObject startLoading];
            NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,INTEGRAL_ORDERENSUREGOODS_URL]];
            request_4=[ASIFormDataRequest requestWithURL:url3];
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
            [request_4 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
            [request_4 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
            [request_4 setPostValue:oid forKey:@"oid"];
            
            [request_4 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request_4.tag = 101;
            request_4.delegate = self;
            [request_4 setDidFailSelector:@selector(my3_urlRequestFailed:)];
            [request_4 setDidFinishSelector:@selector(my3_urlRequestSucceeded:)];
            [request_4 startAsynchronous];
        }else{
        }
    }
}

-(void)btnLifeGroupClicked:(UIButton *)btn{
    if (dataArray.class != 0) {
        ClassifyModel *class = [dataArray objectAtIndex:btn.tag-100];
        LoginViewController *log = [LoginViewController sharedUserDefault];
        log.return_group_id = [NSString stringWithFormat:@"%@",class.goods_id];
        log.return_group_ImagePhoto = class.goods_main_photo;
        log.return_group_Name = class.goods_name;
        log.return_group_Code = class.goods_sn;
        LifeGroupViewController *li = [[LifeGroupViewController alloc]init];
        [self presentViewController:li animated:YES completion:nil];
    }
}
#pragma mark - 下拉刷新
-(void)footerRereshing{
    
    
    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,INTEGRAL_ORDERLIST_URL]];
    request_7=[ASIFormDataRequest requestWithURL:url3];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    [request_7 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request_7 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    [request_7 setPostValue:[NSString stringWithFormat:@"%d",(int)dataArray.count] forKey:@"beginCount"];
    
    [request_7 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_7.tag = 101;
    request_7.delegate = self;
    [request_7 setDidFailSelector:@selector(my2_urlRequestFailed:)];
    [request_7 setDidFinishSelector:@selector(my2_urlRequestSucceeded:)];
    [request_7 startAsynchronous];
    
}

#pragma mark - 网络
-(void)mm2_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"1dicBig：%@",dicBig);
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        NSArray *arr = [dicBig objectForKey:@"order_list"];
        for(NSDictionary *dic in arr){
            ClassifyModel *class = [[ClassifyModel alloc]init];
            class.goods_addTime = [dic objectForKey:@"addTime"];
            class.goods_groupinfos = [dic objectForKey:@"goods_list"];
            class.goods_status = [dic objectForKey:@"igo_status"];
            class.goods_oid = [dic objectForKey:@"oid"];
            class.dingdetail_order_id = [dic objectForKey:@"order_id"];
            class.goods_total_price = [dic objectForKey:@"order_total_price"];
            class.dingdetail_order_pay_msg =[dic objectForKey:@"payType"];
            class.dingdetail_ship_price =[dic objectForKey:@"ship_price"];
            [dataArray addObject:class];
        }
        if (dataArray.count == 0) {
            MyTableView.hidden = YES;
            nothingImage.hidden = NO;
            nothingLabel.hidden = NO;
        }else{
            MyTableView.hidden = NO;
            nothingImage.hidden = YES;
            nothingLabel.hidden = YES;
        }
        [MyTableView reloadData];
        [SYObject endLoading];
    }
    else{
        [self failedPrompt:@"请求出错"];
    }
}
-(void)failedPrompt:(NSString *)prompt{
    [SYObject endLoading];
    [SYObject failedPrompt:prompt];
}
-(void)mm2_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}

-(void)mmm_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request  responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"2dicBig：%@",dicBig);
        if ([[dicBig objectForKey:@"ret"] isEqualToString:@"true"]) {
            [SYObject endLoading];
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
            NSURL *url33 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,INTEGRAL_ORDERLIST_URL]];
            request_5=[ASIFormDataRequest requestWithURL:url33];
            [request_5 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
            [request_5 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
            [request_5 setPostValue:@"0"forKey:@"beginCount"];
            
            [request_5 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request_5.tag = 101;
            request_5.delegate = self;
            [request_5 setDidFailSelector:@selector(mm2_urlRequestFailed:)];
            [request_5 setDidFinishSelector:@selector(mm2_urlRequestSucceeded:)];
            [request_5 startAsynchronous];
            
        }else{
            [self failedPrompt:@"删除失败"];
        }
    }
    else{
        [self failedPrompt:@"请求出错"];
    }
    
}
-(void)mmm_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request  responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"3dicBig：%@",dicBig);
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        NSArray *arr = [dicBig objectForKey:@"order_list"];
        for(NSDictionary *dic in arr){
            ClassifyModel *class = [[ClassifyModel alloc]init];
            class.goods_addTime = [dic objectForKey:@"addTime"];
            class.goods_groupinfos = [dic objectForKey:@"goods_list"];
            class.goods_status = [dic objectForKey:@"igo_status"];
            class.goods_oid = [dic objectForKey:@"oid"];
            class.dingdetail_order_id = [dic objectForKey:@"order_id"];
            class.goods_total_price = [dic objectForKey:@"order_total_price"];
            class.dingdetail_order_pay_msg =[dic objectForKey:@"payType"];
            class.dingdetail_ship_price =[dic objectForKey:@"ship_price"];
            [dataArray addObject:class];
        }
        if (dataArray.count == 0) {
            MyTableView.hidden = YES;
            nothingImage.hidden = NO;
            nothingLabel.hidden = NO;
        }else{
            MyTableView.hidden = NO;
            nothingImage.hidden = YES;
            nothingLabel.hidden = YES;
        }
        [MyTableView reloadData];
        
        [SYObject endLoading];
    }
    else{
        [self failedPrompt:@"请求出错"];
    }
    
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)my2_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"4dicBig：%@",dicBig);
        if (dataArrayShangla.count!=0) {
            [dataArrayShangla removeAllObjects];
        }
        NSArray *arr = [dicBig objectForKey:@"order_list"];
        for(NSDictionary *dic in arr){
            ClassifyModel *class = [[ClassifyModel alloc]init];
            class.goods_addTime = [dic objectForKey:@"addTime"];
            class.goods_groupinfos = [dic objectForKey:@"goods_list"];
            class.goods_status = [dic objectForKey:@"igo_status"];
            class.goods_oid = [dic objectForKey:@"oid"];
            class.dingdetail_order_id = [dic objectForKey:@"order_id"];
            class.goods_total_price = [dic objectForKey:@"order_total_price"];
            class.dingdetail_order_pay_msg =[dic objectForKey:@"payType"];
            class.dingdetail_ship_price =[dic objectForKey:@"ship_price"];
            [dataArrayShangla addObject:class];
        }
        [dataArray addObjectsFromArray:dataArrayShangla];
        [MyTableView reloadData];
        
        [SYObject endLoading];
    }
    else{
        [self failedPrompt:@"请求出错"];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [MyTableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [MyTableView footerEndRefreshing];
    });
}
-(void)my2_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)my3_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"5dicBig：%@",dicBig);
        if ([[dicBig objectForKey:@"ret"] isEqualToString:@"true"]) {
            [SYObject startLoading];
            NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,INTEGRAL_ORDERLIST_URL]];
            request_9=[ASIFormDataRequest requestWithURL:url3];
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
            [request_9 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
            [request_9 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
            [request_9 setPostValue:@"0"forKey:@"beginCount"];
            
            [request_9 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request_9.tag = 101;
            request_9.delegate = self;
            [request_9 setDidFailSelector:@selector(my5_urlRequestFailed:)];
            [request_9 setDidFinishSelector:@selector(my5_urlRequestSucceeded:)];
            [request_9 startAsynchronous];
            
        }
        [SYObject endLoading];
    }
    else{
        [self failedPrompt:@"请求出错"];
    }
    
}
-(void)my3_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)my4_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request  responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"6dicBig：%@",dicBig);
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        NSArray *arr = [dicBig objectForKey:@"order_list"];
        for(NSDictionary *dic in arr){
            ClassifyModel *class = [[ClassifyModel alloc]init];
            class.goods_addTime = [dic objectForKey:@"addTime"];
            class.goods_groupinfos = [dic objectForKey:@"goods_list"];
            class.goods_status = [dic objectForKey:@"igo_status"];
            class.goods_oid = [dic objectForKey:@"oid"];
            class.dingdetail_order_id = [dic objectForKey:@"order_id"];
            class.goods_total_price = [dic objectForKey:@"order_total_price"];
            class.dingdetail_order_pay_msg =[dic objectForKey:@"payType"];
            class.dingdetail_ship_price =[dic objectForKey:@"ship_price"];
            [dataArray addObject:class];
        }
        if (dataArray.count == 0) {
            MyTableView.hidden = YES;
            nothingImage.hidden = NO;
            nothingLabel.hidden = NO;
        }else{
            MyTableView.hidden = NO;
            nothingImage.hidden = YES;
            nothingLabel.hidden = YES;
        }
        [MyTableView reloadData];
        
        [SYObject endLoading];
    }
    else{
        [self failedPrompt:@"请求出错"];
    }
    
}
-(void)my4_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)my5_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"7dicBig：%@",dicBig);
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        NSArray *arr = [dicBig objectForKey:@"order_list"];
        for(NSDictionary *dic in arr){
            ClassifyModel *class = [[ClassifyModel alloc]init];
            class.goods_addTime = [dic objectForKey:@"addTime"];
            class.goods_groupinfos = [dic objectForKey:@"goods_list"];
            class.goods_status = [dic objectForKey:@"igo_status"];
            class.goods_oid = [dic objectForKey:@"oid"];
            class.dingdetail_order_id = [dic objectForKey:@"order_id"];
            class.goods_total_price = [dic objectForKey:@"order_total_price"];
            class.dingdetail_order_pay_msg =[dic objectForKey:@"payType"];
            class.dingdetail_ship_price =[dic objectForKey:@"ship_price"];
            [dataArray addObject:class];
        }
        if (dataArray.count == 0) {
            MyTableView.hidden = YES;
            nothingImage.hidden = NO;
            nothingLabel.hidden = NO;
        }else{
            MyTableView.hidden = NO;
            nothingImage.hidden = YES;
            nothingLabel.hidden = YES;
        }
        [MyTableView reloadData];
        
        [SYObject endLoading];
    }
    else{
        [self failedPrompt:@"请求出错"];
    }
    
}
-(void)my5_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)tabbarBtnClicked:(id)sender {
}
@end
