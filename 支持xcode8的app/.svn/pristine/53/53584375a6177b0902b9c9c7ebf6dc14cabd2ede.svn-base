//
//  GroupOrdListViewController.m
//  My_App
//
//  Created by apple on 15-1-16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "GroupOrdListViewController.h"
#import "ASIFormDataRequest.h"
#import "groupOrderCell.h"
#import "LoginViewController.h"
#import "goodsReturnApplyViewController.h"
#import "DetailViewController.h"
#import "LifeGroupViewController.h"
#import "GroupDetailViewController.h"
#import "lifeGroupOrderDetailViewController.h"
#import "ThirdViewController.h"
#import "LifePayViewController.h"
#import "onlinePayTypeLifeViewController.h"
#import "FirstViewController.h"
#import "OnlinePayTypeSelectViewController.h"

@interface GroupOrdListViewController ()

@end

@implementation GroupOrdListViewController

-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
    
    UIButton *buttonChat = [UIButton buttonWithType:UIButtonTypeCustom ];
    buttonChat.frame =CGRectMake(0, 0, 24, 24);
    [buttonChat setBackgroundImage:[UIImage imageNamed:@"point"] forState:UIControlStateNormal];
    [buttonChat addTarget:self action:@selector(More) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar3 = [[UIBarButtonItem alloc]initWithCustomView:buttonChat];
    self.navigationItem.rightBarButtonItem =bar3;
}
-(void)More{
    if (muchBool == NO) {
        muchView.hidden = NO;
        muchBool = YES;
    }else{
        muchView.hidden = YES;
        muchBool = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    nothingView.hidden = NO;
    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,GROUPLIFE_ORDERLIST_URL]];
    requestGroupOrdList_1 = [ASIFormDataRequest requestWithURL:url3];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    [requestGroupOrdList_1 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [requestGroupOrdList_1 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    [requestGroupOrdList_1 setPostValue:@"0"forKey:@"beginCount"];
    
    [requestGroupOrdList_1 setRequestHeaders:[LJControl requestHeaderDictionary]];
    requestGroupOrdList_1.tag = 101;
    requestGroupOrdList_1.delegate = self;
    [requestGroupOrdList_1 setDidFailSelector:@selector(urlRequestFailed:)];
    [requestGroupOrdList_1 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [requestGroupOrdList_1 startAsynchronous];
    
    [super viewWillAppear:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.title = @"生活购订单";
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
    
    [SYObject startLoading];
    nothingView.hidden = YES;
    
    muchBool = NO;
    [grayMuchImage.layer setMasksToBounds:YES];
    [grayMuchImage.layer setCornerRadius:4];
    muchView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MyTableView setEditing:NO];
    [requestGroupOrdList_1 clearDelegatesAndCancel];
    [requestGroupOrdList_2 clearDelegatesAndCancel];
    [requestGroupOrdList_3 clearDelegatesAndCancel];
    [requestGroupOrdList_4 clearDelegatesAndCancel];
    [requestGroupOrdList_5 clearDelegatesAndCancel];
    [requestGroupOrdList_6 clearDelegatesAndCancel];
    [requestGroupOrdList_7 clearDelegatesAndCancel];
}
#pragma mark - tabelView方法
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
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
    if (tableView == MyTableView) {
        if (dataArray.count!=0) {
            ClassifyModel *class = [dataArray objectAtIndex:indexPath.row];
            if ([class.goods_status intValue] == 0 || [class.goods_status intValue] == 16|| [class.goods_status intValue] == 20|| [class.goods_status intValue] == 30|| [class.goods_status intValue] == 35|| [class.goods_status intValue] == 40|| [class.goods_status intValue] == 50|| [class.goods_status intValue] == 65)
            {
                return 205-44;
                
                
            }else
            {
            return 205;
            }
        }
    }
    return 0;
}
-(void)fuwenbenLabel:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labell.text];
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    labell.attributedText = str;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myTabelviewCell = @"groupOrderCell";
    groupOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"groupOrderCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1];
    }
    if (dataArray.count!=0) {
        ClassifyModel *class = [dataArray objectAtIndex:indexPath.row];
        cell.order_num.text = [NSString stringWithFormat:@"订单号: %@",class.dingdetail_order_num];
        cell.time.text = [NSString stringWithFormat:@"下单时间:%@",class.goods_addTime];
        cell.name.text = class.goods_name;
        [cell.photoImage sd_setImageWithURL:(NSURL*)[NSString stringWithFormat:@"%@",class.goods_main_photo]  placeholderImage:[UIImage imageNamed:@"kong_lj"]];
        cell.count.text = [NSString stringWithFormat:@"数量: %@",class.goods_goods_count];
        cell.price.text = [NSString stringWithFormat:@"价格:￥%@",class.goods_total_price];
        [self fuwenbenLabel:cell.count FontNumber:[UIFont systemFontOfSize:12] AndRange:NSMakeRange(0, 3) AndColor:UIColorFromRGB(0x666666)];
         [self fuwenbenLabel:cell.price FontNumber:[UIFont systemFontOfSize:12] AndRange:NSMakeRange(0, 3) AndColor:UIColorFromRGB(0x666666)];
        
        if ([class.goods_status intValue] == 10) {//待付款
            
            if ([class.dingdetail_order_pay_msg isEqualToString:@"未支付"]){
                cell.status.text = @"待付款";
                [cell.btn2 setTitle:@"支付" forState:UIControlStateNormal];
                cell.btn2.tag = 100+indexPath.row;
                [cell.btn2 addTarget:self action:@selector(btnPayClicked:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                //cell.btn2.hidden = YES;
                NSString *method = [NSString stringWithFormat:@"待支付:%@",class.dingdetail_order_pay_msg];
                cell.status.text = method;
                [cell.btn2 setTitle:@"支付" forState:UIControlStateNormal];
                cell.btn2.tag = 100+indexPath.row;
                [cell.btn2 addTarget:self action:@selector(btnPayClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            [cell.btn1 setTitle:@"取消" forState:UIControlStateNormal];
            cell.btn1.tag = 100+indexPath.row;
            [cell.btn1 addTarget:self action:@selector(btnCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else if ([class.goods_status intValue] == 0){//已取消
            cell.status.text = @"已取消";
            cell.btn2.hidden = YES;
            cell.btn1.hidden = YES;
            [cell.btn1 setTitle:@"取消" forState:UIControlStateNormal];
            cell.btn1.tag = 100+indexPath.row;
            [cell.btn1 addTarget:self action:@selector(btnDetailClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else if ([class.goods_status intValue] == 15){//为线下付款提交申请(已经取消该付款方式)
            cell.btn2.hidden = YES;
            [cell.btn1 setTitle:@"取消" forState:UIControlStateNormal];
            cell.btn1.tag = 100+indexPath.row;
            [cell.btn1 addTarget:self action:@selector(btnDetailClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else if ([class.goods_status intValue] == 16){//为货到付款
            cell.status.text = @"已取消";
            cell.btn2.hidden = YES;
            cell.btn1.hidden = YES;
            [cell.btn1 setTitle:@"取消" forState:UIControlStateNormal];
            cell.btn1.tag = 100+indexPath.row;
            [cell.btn1 addTarget:self action:@selector(btnDetailClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else if ([class.goods_status intValue] == 20){//20为已付款待发货
            cell.status.text = @"已付款";
            cell.btn2.hidden = YES;
            cell.btn1.hidden = YES;
            [cell.btn1 setTitle:@"取消" forState:UIControlStateNormal];
            cell.btn1.tag = 100+indexPath.row;
            [cell.btn1 addTarget:self action:@selector(btnDetailClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else if ([class.goods_status intValue] == 30){//为已发货待收货
            cell.status.text = @"已发货";
            cell.btn1.hidden = YES;
            cell.btn2.hidden = YES;
            [cell.btn1 setTitle:@"取消" forState:UIControlStateNormal];
            cell.btn1.tag = 100+indexPath.row;
            [cell.btn1 addTarget:self action:@selector(btnDetailClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else if ([class.goods_status intValue] == 35){//自提点已经收货
            cell.status.text = @"已收货";
            cell.btn2.hidden = YES;
            cell.btn1.hidden = YES;
            [cell.btn1 setTitle:@"取消" forState:UIControlStateNormal];
            cell.btn1.tag = 100+indexPath.row;
            [cell.btn1 addTarget:self action:@selector(btnDetailClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else if ([class.goods_status intValue] == 40){//为已收货
            cell.status.text = @"已收货";
            cell.btn2.hidden = YES;
            cell.btn1.hidden = YES;
            [cell.btn1 setTitle:@"取消" forState:UIControlStateNormal];
            cell.btn1.tag = 100+indexPath.row;
            [cell.btn1 addTarget:self action:@selector(btnDetailClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else if ([class.goods_status intValue] == 50){//买家评价完毕
            cell.status.text = @"已评价";
            cell.btn2.hidden = YES;
            cell.btn1.hidden = YES;
            [cell.btn1 setTitle:@"取消" forState:UIControlStateNormal];
            cell.btn1.tag = 100+indexPath.row;
            [cell.btn1 addTarget:self action:@selector(btnDetailClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else if ([class.goods_status intValue] == 65){//65订单不可评价
            cell.status.text = @"已取消";
            cell.btn2.hidden = YES;
            cell.btn1.hidden = YES;
            [cell.btn1 setTitle:@"取消" forState:UIControlStateNormal];
            cell.btn1.tag = 100+indexPath.row;
            [cell.btn1 addTarget:self action:@selector(btnDetailClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == MyTableView){
        if (dataArray.count!=0) {
            //此处应该条状进入  ---》  生活团购商品订单详情
            ClassifyModel *class = [dataArray objectAtIndex:indexPath.row];
            LoginViewController *log= [LoginViewController sharedUserDefault];
            log.lifeGroup_oid = [NSString stringWithFormat:@"%@",class.dingdetail_order_id];
            lifeGroupOrderDetailViewController *life = [[lifeGroupOrderDetailViewController alloc]init];
            [self.navigationController pushViewController:life animated:YES];
        }
    }
}
#pragma mark - 点击事件
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnDetailClicked:(UIButton *)btn{
    if (dataArray.count!=0) {
        //此处应该条状进入  ---》  生活团购商品订单详情
        ClassifyModel *class = [dataArray objectAtIndex:btn.tag - 100];
        LoginViewController *log= [LoginViewController sharedUserDefault];
        log.lifeGroup_oid = [NSString stringWithFormat:@"%@",class.dingdetail_order_id];
        lifeGroupOrderDetailViewController *life = [[lifeGroupOrderDetailViewController alloc]init];
        [self.navigationController pushViewController:life animated:YES];
    
        
    }
}
-(void)btnPayClicked:(UIButton *)btn{
    if(dataArray.count!=0){
        ClassifyModel *class = [dataArray objectAtIndex:btn.tag -100];
        
            ThirdViewController *th = [ThirdViewController sharedUserDefault];
            th.ding_hao = class.dingdetail_order_num;
            th.ding_order_id = class.dingdetail_order_id;
            th.jie_order_goods_price = class.goods_total_price;
            //这里应该跳转进入选择页面
            OnlinePayTypeSelectViewController *on = [[OnlinePayTypeSelectViewController alloc]init];
            on.group=YES;
            on.groupCenter=YES;
            [self.navigationController pushViewController:on animated:YES];
        
    }
}
-(void)refresh{
    nothingView.hidden = NO;
    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,GROUPLIFE_ORDERLIST_URL]];
    requestGroupOrdList_2 = [ASIFormDataRequest requestWithURL:url3];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    [requestGroupOrdList_2 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [requestGroupOrdList_2 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    [requestGroupOrdList_2 setPostValue:@"0"forKey:@"beginCount"];
    
    [requestGroupOrdList_2 setRequestHeaders:[LJControl requestHeaderDictionary]];
    requestGroupOrdList_2.tag = 101;
    requestGroupOrdList_2.delegate = self;
    [requestGroupOrdList_2 setDidFailSelector:@selector(my1_urlRequestFailed:)];
    [requestGroupOrdList_2 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
    [requestGroupOrdList_2 startAsynchronous];
}
-(void)btnCancelClicked:(UIButton *)btn{
    deletTag = btn.tag -100;
    UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"系统提示" message:@"您要取消该订单？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alv show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        ClassifyModel *class = [dataArray objectAtIndex:deletTag];
        //发起删除的请求
        nothingView.hidden = NO;
        NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,GROUPLIFE_ORDERCANCEL_URL]];
        requestGroupOrdList_3 = [ASIFormDataRequest requestWithURL:url3];
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
        [requestGroupOrdList_3 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
        [requestGroupOrdList_3 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
        [requestGroupOrdList_3 setPostValue:class.dingdetail_order_id forKey:@"oid"];
        
        [requestGroupOrdList_3 setRequestHeaders:[LJControl requestHeaderDictionary]];
        requestGroupOrdList_3.tag = 101;
        requestGroupOrdList_3.delegate = self;
        [requestGroupOrdList_3 setDidFailSelector:@selector(my3_urlRequestFailed:)];
        [requestGroupOrdList_3 setDidFinishSelector:@selector(my3_urlRequestSucceeded:)];
        [requestGroupOrdList_3 startAsynchronous];
    }else{
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

#pragma mark - 上拉刷新
-(void)footerRereshing{
    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,GROUPLIFE_ORDERLIST_URL]];
    requestGroupOrdList_5 = [ASIFormDataRequest requestWithURL:url3];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    [requestGroupOrdList_5 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [requestGroupOrdList_5 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    [requestGroupOrdList_5 setPostValue:[NSString stringWithFormat:@"%d",(int)dataArray.count] forKey:@"beginCount"];
    
    [requestGroupOrdList_5 setRequestHeaders:[LJControl requestHeaderDictionary]];
    requestGroupOrdList_5.tag = 101;
    requestGroupOrdList_5.delegate = self;
    [requestGroupOrdList_5 setDidFailSelector:@selector(my2_urlRequestFailed:)];
    [requestGroupOrdList_5 setDidFinishSelector:@selector(my2_urlRequestSucceeded:)];
    [requestGroupOrdList_5 startAsynchronous];
}
#pragma mark - 网络
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request  responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig：%@",dicBig);
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        NSArray *arr = [dicBig objectForKey:@"order_list"];
        for(NSDictionary *dic in arr){
            ClassifyModel *class = [[ClassifyModel alloc]init];
            class.goods_goods_count = [dic objectForKey:@"goods_count"];
            class.goods_id = [dic objectForKey:@"goods_id"];
            class.goods_main_photo = [dic objectForKey:@"goods_img"];
            class.goods_name = [dic objectForKey:@"goods_name"];
            class.goods_current_price = [dic objectForKey:@"goods_price"];
            class.goods_total_price = [dic objectForKey:@"goods_total_price"];
            class.goods_addTime = [dic objectForKey:@"addTime"];
            class.goods_status = [dic objectForKey:@"order_status"];
            class.dingdetail_order_id = [dic objectForKey:@"order_id"];
            class.dingdetail_order_num = [dic objectForKey:@"order_num"];
            class.dingdetail_order_pay_msg =[dic objectForKey:@"payType"];
            [dataArray addObject:class];
        }
        if (dataArray.count == 0) {
            MyTableView.hidden = YES;
            nothingView.hidden = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
        }
        [MyTableView reloadData];
        
        [SYObject endLoading];
    }
    else{
        nothingView.hidden = NO;
        [self failedPrompt:@"请求出错"];
    }
}
-(void)failedPrompt:(NSString *)prompt{
    [SYObject endLoading];
    [SYObject failedPrompt:prompt];
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
    nothingView.hidden = NO;
}
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig：%@",dicBig);
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        NSArray *arr = [dicBig objectForKey:@"order_list"];
        for(NSDictionary *dic in arr){
            ClassifyModel *class = [[ClassifyModel alloc]init];
            class.goods_goods_count = [dic objectForKey:@"goods_count"];
            class.goods_id = [dic objectForKey:@"goods_id"];
            class.goods_main_photo = [dic objectForKey:@"goods_img"];
            class.goods_name = [dic objectForKey:@"goods_name"];
            class.goods_current_price = [dic objectForKey:@"goods_price"];
            class.goods_total_price = [dic objectForKey:@"goods_total_price"];
            class.goods_addTime = [dic objectForKey:@"addTime"];
            class.goods_status = [dic objectForKey:@"order_status"];
            class.dingdetail_order_id = [dic objectForKey:@"order_id"];
            class.dingdetail_order_num = [dic objectForKey:@"order_num"];
            class.dingdetail_order_pay_msg =[dic objectForKey:@"payType"];
            [dataArray addObject:class];
        }
        if (dataArray.count == 0) {
            MyTableView.hidden = YES;
            nothingView.hidden = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
        }
        [MyTableView reloadData];
        [SYObject endLoading];
    }
    else{
        nothingView.hidden = NO;
        [self failedPrompt:@"请求出错"];
    }
}
-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
    nothingView.hidden = NO;
}
-(void)my2_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request  responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig：%@",dicBig);
        if (dataArrayShangla.count!=0) {
            [dataArrayShangla removeAllObjects];
        }
        NSArray *arr = [dicBig objectForKey:@"order_list"];
        for(NSDictionary *dic in arr){
            ClassifyModel *class = [[ClassifyModel alloc]init];
            class.goods_goods_count = [dic objectForKey:@"goods_count"];
            class.goods_id = [dic objectForKey:@"goods_id"];
            class.goods_main_photo = [dic objectForKey:@"goods_img"];
            class.goods_name = [dic objectForKey:@"goods_name"];
            class.goods_current_price = [dic objectForKey:@"goods_price"];
            class.goods_total_price = [dic objectForKey:@"goods_total_price"];
            class.goods_addTime = [dic objectForKey:@"addTime"];
            class.goods_status = [dic objectForKey:@"order_status"];
            class.dingdetail_order_id = [dic objectForKey:@"order_id"];
            class.dingdetail_order_num = [dic objectForKey:@"order_num"];
            class.dingdetail_order_pay_msg =[dic objectForKey:@"payType"];
            [dataArrayShangla addObject:class];
        }
        [dataArray addObjectsFromArray:dataArrayShangla];
        [MyTableView reloadData];
        [SYObject endLoading];
    }
    else{
        [self failedPrompt:@"请求出错"];
        nothingView.hidden = NO;
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
    [SYObject endLoading];
}
-(void)my3_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request  responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig：%@",dicBig);
        if ([[dicBig objectForKey:@"ret"] isEqualToString:@"true"]) {
            nothingView.hidden = NO;
            NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,GROUPLIFE_ORDERLIST_URL]];
            requestGroupOrdList_7 = [ASIFormDataRequest requestWithURL:url3];
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
            [requestGroupOrdList_7 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
            [requestGroupOrdList_7 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
            [requestGroupOrdList_7 setPostValue:@"0"forKey:@"beginCount"];
            
            [requestGroupOrdList_7 setRequestHeaders:[LJControl requestHeaderDictionary]];
            requestGroupOrdList_7.tag = 101;
            requestGroupOrdList_7.delegate = self;
            [requestGroupOrdList_7 setDidFailSelector:@selector(my4_urlRequestFailed:)];
            [requestGroupOrdList_7 setDidFinishSelector:@selector(my4_urlRequestSucceeded:)];
            [requestGroupOrdList_7 startAsynchronous];
        }
    }
    else{
        [self failedPrompt:@"请求出错"];
        nothingView.hidden = NO;
    }
}
-(void)my3_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
    nothingView.hidden = NO;
}
-(void)my4_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig：%@",dicBig);
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        NSArray *arr = [dicBig objectForKey:@"order_list"];
        for(NSDictionary *dic in arr){
            ClassifyModel *class = [[ClassifyModel alloc]init];
            class.goods_goods_count = [dic objectForKey:@"goods_count"];
            class.goods_id = [dic objectForKey:@"goods_id"];
            class.goods_main_photo = [dic objectForKey:@"goods_img"];
            class.goods_name = [dic objectForKey:@"goods_name"];
            class.goods_current_price = [dic objectForKey:@"goods_price"];
            class.goods_total_price = [dic objectForKey:@"goods_total_price"];
            class.goods_addTime = [dic objectForKey:@"addTime"];
            class.goods_status = [dic objectForKey:@"order_status"];
            class.dingdetail_order_id = [dic objectForKey:@"order_id"];
            class.dingdetail_order_num = [dic objectForKey:@"order_num"];
            class.dingdetail_order_pay_msg =[dic objectForKey:@"payType"];
            
            [dataArray addObject:class];
        }
        if (dataArray.count == 0) {
            MyTableView.hidden = YES;
            nothingView.hidden = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
        }
        [MyTableView reloadData];
        
        [SYObject endLoading];
    }
    else{
        nothingView.hidden = NO;
        [self failedPrompt:@"请求出错"];
    }
}
-(void)my4_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
    nothingView.hidden = NO;
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
@end
