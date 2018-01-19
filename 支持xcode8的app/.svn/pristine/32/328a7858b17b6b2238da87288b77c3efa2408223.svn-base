//
//  lifeGruopOrderDetail2ViewController.m
//  My_App
//
//  Created by apple on 15-2-6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "lifeGruopOrderDetail2ViewController.h"
#import "ASIFormDataRequest.h"
#import "NilCell.h"
#import "LoginViewController.h"
#import "goodsReturnApplyViewController.h"
#import "DetailViewController.h"
#import "SecondViewController.h"
#import "LifeGroupViewController.h"
#import "lifeGroupOrderDetailViewController.h"
#import "LoginViewController.h"
#import "onlinePayTypeLifeViewController.h"
#import "ThirdViewController.h"

@interface lifeGruopOrderDetail2ViewController ()

@end

@implementation lifeGruopOrderDetail2ViewController
{
    ASIFormDataRequest *requestlifeGruopOrderDetail3;
}

-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(MyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
    
    buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom ];
    buttonCancel.frame =CGRectMake(0, 0, 50, 30);
    [buttonCancel setTitle:@"取消订单" forState:UIControlStateNormal];
    [buttonCancel addTarget:self action:@selector(BtnCancelClicked) forControlEvents:UIControlEventTouchUpInside];
    buttonCancel.titleLabel.font  = [UIFont boldSystemFontOfSize:12];
    UIBarButtonItem *bar2 = [[UIBarButtonItem alloc]initWithCustomView:buttonCancel];
    self.navigationItem.rightBarButtonItem =bar2;
}
-(void)BtnCancelClicked{
    UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"系统提示" message:@"您要取消该订单？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alv show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        ClassifyModel *class = [dataArray objectAtIndex:0];
        //发起删除的请求
        NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,GROUPLIFE_ORDERCANCEL_URL]];
        requestlifeGruopOrderDetail3 = [ASIFormDataRequest requestWithURL:url3];
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
        [requestlifeGruopOrderDetail3 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
        [requestlifeGruopOrderDetail3 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
        [requestlifeGruopOrderDetail3 setPostValue:class.goods_oid forKey:@"oid"];
        
        [requestlifeGruopOrderDetail3 setRequestHeaders:[LJControl requestHeaderDictionary]];
        requestlifeGruopOrderDetail3.tag = 101;
        requestlifeGruopOrderDetail3.delegate = self;
        [requestlifeGruopOrderDetail3 setDidFailSelector:@selector(my2_urlRequestFailed:)];
        [requestlifeGruopOrderDetail3 setDidFinishSelector:@selector(my2_urlRequestSucceeded:)];
        [requestlifeGruopOrderDetail3 startAsynchronous];
    }else{
    }
}
-(void)failedPrompt:(NSString *)prompt{
    [SYObject endLoading];
    [SYObject failedPrompt:prompt];
}
-(void)my2_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request  responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig：%@",dicBig);
        if ([[dicBig objectForKey:@"ret"] isEqualToString:@"true"]) {
            buttonCancel.hidden = YES;
            [self failedPrompt:@"已成功删除该订单"];
        }else{
            [self failedPrompt:@"删除订单失败，请重试"];
        }
    }
    else{
        [self failedPrompt:@"请求出错"];
    }
    
}
-(void)my2_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)MyBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [requestlifeGruopOrderDetail3 clearDelegatesAndCancel];
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,GROUPLIFE_ORDERDETAIL_URL]];
    requestlifeGruopOrderDetail3 = [ASIFormDataRequest requestWithURL:url3];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    [requestlifeGruopOrderDetail3 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [requestlifeGruopOrderDetail3 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    LoginViewController *log = [LoginViewController sharedUserDefault];
    [requestlifeGruopOrderDetail3 setPostValue:log.lifeGroup_oid forKey:@"oid"];
    
    [requestlifeGruopOrderDetail3 setRequestHeaders:[LJControl requestHeaderDictionary]];
    requestlifeGruopOrderDetail3.tag = 101;
    requestlifeGruopOrderDetail3.delegate = self;
    [requestlifeGruopOrderDetail3 setDidFailSelector:@selector(urlRequestFailed:)];
    [requestlifeGruopOrderDetail3 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [requestlifeGruopOrderDetail3 startAsynchronous];
    [super viewWillAppear:YES];
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request  responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig：%@",dicBig);
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        
        ClassifyModel *class = [[ClassifyModel alloc]init];
        class.goods_goods_count = [dicBig objectForKey:@"goods_count"];
        class.goods_id = [dicBig objectForKey:@"goods_id"];;
        class.goods_main_photo = [dicBig objectForKey:@"goods_img"];
        class.goods_name = [dicBig objectForKey:@"goods_name"];
        class.goods_current_price = [dicBig objectForKey:@"goods_price"];
        class.goods_total_price = [dicBig objectForKey:@"goods_total_price"];
        class.goods_oid = [dicBig objectForKey:@"oid"];
        class.goods_addTime = [dicBig objectForKey:@"order_addTime"];
        class.goods_status = [dicBig objectForKey:@"order_status"];
        class.dingdetail_order_id = [dicBig objectForKey:@"order_id"];
        class.dingdetail_order_pay_msg =[dicBig objectForKey:@"order_pay_msg"];
        class.dingdetail_order_pay_time =[dicBig objectForKey:@"order_pay_time"];
        class.goods_groupinfos  =[dicBig objectForKey:@"groupinfos"];
        class.goods_status_msg  =[dicBig objectForKey:@"order_status_msg"];
        class.dingdetail_payType =[dicBig objectForKey:@"paytype"];
        if([[dicBig objectForKey:@"order_status"] intValue]==10){
            buttonCancel.hidden = NO;
        }else{
            buttonCancel.hidden = YES;
        }
        [dataArray addObject:class];
        
        if (dataArray.count == 0) {
            MyTableView.hidden = YES;
        }else{
            MyTableView.hidden = NO;
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.title = @"订单详情";
    [self createBackBtn];
    
    requestBool = NO;
    dataArray = [[NSMutableArray alloc]init];
    dataArrayShangla = [[NSMutableArray alloc]init];
    
    
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    if (ScreenFrame.size.height>480) {//说明是5 5s
        MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    }else{
        MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    }
    MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MyTableView.delegate = self;
    MyTableView.dataSource=  self;
    MyTableView.showsVerticalScrollIndicator=NO;
    MyTableView.showsHorizontalScrollIndicator = NO;
    MyTableView.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1];
    [self.view addSubview:MyTableView];
}


-(UIView *)loadingView:(CGRect)rect
{
    UIView *loadV=[[UIView alloc]initWithFrame:rect];
    loadV.backgroundColor=[UIColor blackColor];
    loadV.alpha = 0.8;
    UIActivityIndicatorView *activityIndicatorV=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorV.center=CGPointMake(rect.size.width/2, rect.size.height/2-10);
    [activityIndicatorV startAnimating];
    
    [loadV addSubview:activityIndicatorV];
    UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(0, 70, 100, 30)];
    la.text=@"正在加载...";
    la.backgroundColor=[UIColor clearColor];
    la.textAlignment=NSTextAlignmentCenter;
    la.textColor=[UIColor whiteColor];
    la.font=[UIFont boldSystemFontOfSize:15];
    [loadV addSubview:la];
    loadV.layer.cornerRadius=4;
    loadV.layer.masksToBounds=YES;
    return loadV;
}
//TODO:tabelView方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArray.count!=0) {
        return dataArray.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (dataArray.count!=0) {
        ClassifyModel *class = [dataArray objectAtIndex:indexPath.row];
        return  90 +class.goods_groupinfos.count*76 +30+16+53+20;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myTabelviewCell = @"NilCell";
    NilCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NilCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1];
    }else{
        for (UIView *subView in cell.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    if (dataArray.count!=0) {
        ClassifyModel *class = [dataArray objectAtIndex:indexPath.row];
        UIView *viewM = [[UIView alloc]initWithFrame:CGRectMake(0, 5, ScreenFrame.size.width, 90 +class.goods_groupinfos.count*76 +30+16+52+20)];
        viewM.backgroundColor = [UIColor whiteColor];
        [cell addSubview:viewM];
        UIImageView *ImageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 0.5)];
        ImageLine.backgroundColor = [UIColor lightGrayColor];
        [viewM addSubview:ImageLine];
        UIImageView *ImageLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, viewM.frame.size.height-0.5, ScreenFrame.size.width, 0.5)];
        ImageLine2.backgroundColor = [UIColor lightGrayColor];
        [viewM addSubview:ImageLine2];
        
        UIView *labelLineT = [[UIView alloc]initWithFrame:CGRectMake(0, 103+16+20, ScreenFrame.size.width, 0.5)];
        labelLineT.backgroundColor = [UIColor grayColor];
        [viewM addSubview:labelLineT];
        
        UILabel *labelB = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, ScreenFrame.size.width, 20)];
        labelB.text = [NSString stringWithFormat:@"  订单号: %@",class.dingdetail_order_id];
        labelB.textColor = [UIColor blackColor];
        labelB.font = [UIFont boldSystemFontOfSize:12];
        [viewM addSubview:labelB];
        
        UILabel *labelT = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, ScreenFrame.size.width, 20)];
        labelT.text = [NSString stringWithFormat:@"  下单时间: %@",class.goods_addTime];
        labelT.textColor = [UIColor blackColor];
        labelT.font = [UIFont boldSystemFontOfSize:12];
        [viewM addSubview:labelT];
        
        UILabel *labelPP = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 20)];
        labelPP.text = [NSString stringWithFormat:@"  订单状态:%@",class.goods_status_msg];
        CALayer *lay2  = labelPP.layer;
        [lay2 setMasksToBounds:YES];
        [lay2 setCornerRadius:8.0];
        labelPP.textColor = [UIColor blackColor];
        labelPP.font = [UIFont boldSystemFontOfSize:12];
        [viewM addSubview:labelPP];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
        button.frame =CGRectMake(0, 70, ScreenFrame.size.width, 80);
//        [button addTarget:self action:@selector(DEtailBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font  = [UIFont systemFontOfSize:14];
        [cell addSubview:button];
        
        UIView *labelLineT2 = [[UIView alloc]initWithFrame:CGRectMake(0, 28+16+20, ScreenFrame.size.width, 0.5)];
        labelLineT2.backgroundColor = [UIColor lightGrayColor];
        [viewM addSubview:labelLineT2];
        
        UIImageView *imageBig = [[UIImageView alloc]initWithFrame:CGRectMake(15, 40+16+20, 56, 56)];
        [imageBig sd_setImageWithURL:(NSURL*)[NSString stringWithFormat:@"%@",class.goods_main_photo]  placeholderImage:[UIImage imageNamed:@"kong_lj"]];
        [viewM addSubview:imageBig];
        
        UILabel *labelCount = [[UILabel alloc]initWithFrame:CGRectMake(80, 34+16+20, ScreenFrame.size.width-90, 34)];
        labelCount.text = class.goods_name;
        labelCount.textColor = [UIColor blackColor];
        labelCount.numberOfLines = 2;
        labelCount.font = [UIFont boldSystemFontOfSize:12];
        [viewM addSubview:labelCount];
        
        UILabel *labelShuliang = [[UILabel alloc]initWithFrame:CGRectMake(80, 60-24+30+16+20, ScreenFrame.size.width-90, 20)];
        labelShuliang.text = [NSString stringWithFormat:@"数量: %@",class.goods_goods_count];
        labelShuliang.textColor = [UIColor darkGrayColor];
        labelShuliang.font = [UIFont boldSystemFontOfSize:10];
        [viewM addSubview:labelShuliang];
        
        UILabel *labelPrice = [[UILabel alloc]initWithFrame:CGRectMake(80, 75-24+30+16+20, ScreenFrame.size.width-90, 20)];
        labelPrice.text = [NSString stringWithFormat:@"￥%@",class.goods_current_price];
        labelPrice.textColor = [UIColor redColor];
        labelPrice.font = [UIFont boldSystemFontOfSize:14];
        [viewM addSubview:labelPrice];
        if ([class.dingdetail_payType isEqualToString:after_mark]) {
            
        }else{
            if ([class.goods_status intValue] == 20) {
                
            }else{
                UIButton *buttonZ = [UIButton buttonWithType:UIButtonTypeCustom ];
                buttonZ.frame =CGRectMake(ScreenFrame.size.width-90, 20, 80, 30);
                [buttonZ addTarget:self action:@selector(payBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                buttonZ.backgroundColor = MY_COLOR;
                [buttonZ.layer setMasksToBounds:YES];
                [buttonZ.layer setCornerRadius:8.0];
                
                [buttonZ setTitle:@"去支付" forState:UIControlStateNormal];
                buttonZ.titleLabel.font  = [UIFont boldSystemFontOfSize:14];
                [cell addSubview:buttonZ];
            }
        }
        
        for(int i=0;i<class.goods_groupinfos.count;i++){
            UIView *viewGray = [[UIView alloc]initWithFrame:CGRectMake(10, 90+76*i+30+16+20, 300, 66)];
            viewGray.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
            [cell addSubview:viewGray];
            
            UILabel *labelSn = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 24)];
            labelSn.text = [NSString stringWithFormat:@"  消费码: %@",[[class.goods_groupinfos objectAtIndex:i] objectForKey:@"info_sn"]];
            labelSn.textColor = [UIColor blackColor];
            labelSn.font = [UIFont boldSystemFontOfSize:12];
            [viewGray addSubview:labelSn];
            
            UILabel *labelSatus = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, ScreenFrame.size.width, 24)];
            labelSatus.text = [NSString stringWithFormat:@"  使用状态: %@",[[class.goods_groupinfos objectAtIndex:i] objectForKey:@"info_status_msg"]];
            labelSatus.textColor = [UIColor blackColor];
            labelSatus.font = [UIFont boldSystemFontOfSize:12];
            [viewGray addSubview:labelSatus];
            UILabel *labelT = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, ScreenFrame.size.width, 24)];
            labelT.text = [NSString stringWithFormat:@"  到期时间: %@",[[class.goods_groupinfos objectAtIndex:i] objectForKey:@"info_end_time"]];
            labelT.textColor = [UIColor blackColor];
            labelT.font = [UIFont boldSystemFontOfSize:12];
            [viewGray addSubview:labelT];
        }
        UIView *labelLineT3 = [[UIView alloc]initWithFrame:CGRectMake(0, 90+76*class.goods_groupinfos.count+30+16+20, ScreenFrame.size.width, 0.5)];
        labelLineT3.backgroundColor = [UIColor grayColor];
        [viewM addSubview:labelLineT3];
        
        UILabel *labelSn = [[UILabel alloc]initWithFrame:CGRectMake(0, 90+76*class.goods_groupinfos.count+30+16+4+20, ScreenFrame.size.width, 24)];
        labelSn.text = [NSString stringWithFormat:@"  商品总金额:"];
        labelSn.textColor = [UIColor blackColor];
        labelSn.font = [UIFont boldSystemFontOfSize:12];
        [viewM addSubview:labelSn];
        UILabel *labelTP = [[UILabel alloc]initWithFrame:CGRectMake(0, 90+76*class.goods_groupinfos.count+30+16+4+20, ScreenFrame.size.width, 24)];
        labelTP.text = [NSString stringWithFormat:@"￥%@",class.goods_total_price];
        labelTP.textColor = MY_COLOR;
        labelTP.textAlignment = NSTextAlignmentRight;
        labelTP.font = [UIFont boldSystemFontOfSize:15];
        [viewM addSubview:labelTP];
        UILabel *labelP = [[UILabel alloc]initWithFrame:CGRectMake(0, 90+76*class.goods_groupinfos.count+30+16+4+24+20, ScreenFrame.size.width, 24)];
        labelP.text = [NSString stringWithFormat:@"  支付方式:"];
        labelP.textColor = [UIColor blackColor];
        labelP.font = [UIFont boldSystemFontOfSize:12];
        [viewM addSubview:labelP];
        UILabel *labelPP1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 90+76*class.goods_groupinfos.count+30+16+4+24+20, ScreenFrame.size.width, 24)];
        labelPP1.text = class.dingdetail_order_pay_msg;
        labelPP1.textColor = [UIColor blackColor];
        labelPP1.textAlignment = NSTextAlignmentRight ;
        labelPP1.font = [UIFont boldSystemFontOfSize:12];
        [viewM addSubview:labelPP1];
    }
    return cell;
}
-(void)paymentResult:(NSString *)result{
    NSLog(@"result:%@",result);
}
-(void)payBtnClicked:(UIButton *)btn{
    if (dataArray.count!=0) {
        ClassifyModel *class = [dataArray objectAtIndex:0];
        ThirdViewController *th = [ThirdViewController sharedUserDefault];
        th.ding_hao = class.dingdetail_order_id;
        th.jie_order_goods_price = class.goods_total_price;
//        onlinePayTypeLifeViewController *aa = [[onlinePayTypeLifeViewController alloc]init];
//        [self.navigationController pushViewController:aa animated:YES];
    }
}

-(void)btnDetailClicked:(UIButton *)btn{
    if (dataArray.count != 0) {
        ClassifyModel *claa = [dataArrayShangla objectAtIndex:btn.tag-100];
        LoginViewController *log= [LoginViewController sharedUserDefault];
        log.lifeGroup_oid = [NSString stringWithFormat:@"%@",claa.dingdetail_oid];
        lifeGroupOrderDetailViewController *life = [[lifeGroupOrderDetailViewController alloc]init];
        [self.navigationController pushViewController:life animated:YES];
    }
}
-(void)btnPayClicked:(UIButton *)btn{
}
-(void)btnCancelClicked:(UIButton *)btn{
}
-(void)btnGoodsDetailClicked:(UIButton *)btn{
    if (dataArray.count!=0) {
        if (btn.tag<100) {
            ClassifyModel *class = [dataArray objectAtIndex:0];
            for(int i=0;i<class.dingdetail_goods_maps.count;i++){
                if (btn.tag == i) {
                    SecondViewController *sec = [SecondViewController sharedUserDefault];
                    sec.detail_id = [[class.dingdetail_goods_maps objectAtIndex:i] objectForKey:@"goods_id"];
                    
                    DetailViewController *gg = [[DetailViewController alloc]init];
                    [self.navigationController pushViewController:gg animated:YES];
                }
            }
        }else{
            ClassifyModel *class = [dataArray objectAtIndex:btn.tag/100];
            for(int i=0;i<class.dingdetail_goods_maps.count;i++){
                if (btn.tag%100 == i) {
                    SecondViewController *sec = [SecondViewController sharedUserDefault];
                    sec.detail_id = [[class.dingdetail_goods_maps objectAtIndex:i] objectForKey:@"goods_id"];
                    
                    DetailViewController *gg = [[DetailViewController alloc]init];
                    [self.navigationController pushViewController:gg animated:YES];
                }
            }
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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


@end
