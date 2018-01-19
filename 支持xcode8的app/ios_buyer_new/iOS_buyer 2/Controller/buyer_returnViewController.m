//
//  buyer_returnViewController.m
//  My_App
//
//  Created by apple on 15-1-22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "buyer_returnViewController.h"
#import "NilCell.h"
#import "LoginViewController.h"
#import "goodsReturnApplyViewController.h"
#import "DetailViewController.h"
#import "SecondViewController.h"
#import "LifeGroupViewController.h"
#import "returnGoodsShipViewController.h"
#import "NewLoginViewController.h"
#import "FirstViewController.h"
#import "returnMoneyViewController.h"
#import "ApplyForReturnCancelViewController.h"
#import "ApplyForReturnViewController.h"

@interface buyer_returnViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong)SYObject *obj;

@end

@implementation buyer_returnViewController

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
-(void)create_leftUI{
    muchView = [LJControl MuchView:CGRectMake(self.view.frame.size.width-136,0, 126, 220)];
    [self.view addSubview:muchView];
    muchView.hidden = YES;
    for (int i=0; i<5; i++) {
        UIButton *btn = [LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(0, 10+i*40, 126, 40) setNormalImage:[UIImage imageNamed:@""] setSelectedImage:[UIImage imageNamed:@""] setTitle:@"" setTitleFont:10 setbackgroundColor:[UIColor clearColor]];
        btn.tag = 101+i;
        [btn addTarget:self action:@selector(mainBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [muchView addSubview:btn];
    }
    
    //添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
    
    
}
-(void)tap
{
    muchView.hidden = YES;
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
-(void)More{
    if (muchBool == NO) {
        muchView.hidden = NO;
        muchBool = YES;
    }else{
        muchView.hidden = YES;
        muchBool = NO;
    }
}
-(void)backBtnClicked{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request_4 clearDelegatesAndCancel];
    [request_3 clearDelegatesAndCancel];
    [request_2 clearDelegatesAndCancel];
    [request_1 clearDelegatesAndCancel];
    [MyTableView setEditing:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    NSArray *keyArr = [[NSArray alloc]initWithObjects:@"user_id",@"token", nil];
    NSArray *valueArr = [[NSArray alloc]initWithObjects:[USER_INFORMATION objectAtIndex:3],[USER_INFORMATION objectAtIndex:1], nil];
    request_1 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,BUYER_RETURN_LIST_URL] setKey:keyArr setValue:valueArr];
    request_1.delegate =self;
    [request_1 setDidFailSelector:@selector(my1_urlRequestFailed:)];
    [request_1 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
    [request_1 startAsynchronous];
    
    [super viewWillAppear:YES];
}
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        dataArray = [consultViewNetwork dataBuyer_eturnListData:request];
        if (dataArray.count == 0) {
            MyTableView.backgroundView = [SYObject noDataView];
        }else{
            MyTableView.hidden = NO;
        }
        [MyTableView reloadData];
        
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"result=%@", dicBig);
        if ([[dicBig objectForKey:@"code"] intValue] == 100) {
            
        }else if([[dicBig objectForKey:@"code"] intValue] == -100){
            [SYObject failedPrompt:@"用户登录已过期,请重新登录"];
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(TimeoutdoTimer) userInfo:nil repeats:NO];
        }else{
            MyTableView.backgroundView = [SYObject noDataView];
        }
        [SYObject endLoading];
    }else{
        [SYObject failedPrompt:@"网络请求失败"];
    }
    
}
-(void)myHeader_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        dataArray = [consultViewNetwork dataBuyer_eturnListData:request];
        if (dataArray.count == 0) {
            MyTableView.backgroundView = [SYObject noDataView];
        }else{
            MyTableView.hidden = NO;
        }
        [MyTableView reloadData];
        
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"result=%@", dicBig);
        if ([[dicBig objectForKey:@"code"] intValue] == 100) {
            
        }else if([[dicBig objectForKey:@"code"] intValue] == -100){
            [SYObject failedPrompt:@"用户登录已过期,请重新登录"];
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(TimeoutdoTimer) userInfo:nil repeats:NO];
        }else{
            MyTableView.backgroundView = [SYObject noDataView];
        }
        [SYObject endLoading];
    }else{
        [SYObject failedPrompt:@"网络请求失败"];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [MyTableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [MyTableView headerEndRefreshing];
    });

}

-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}

-(void)TimeoutdoTimer{
    NewLoginViewController *new = [[NewLoginViewController alloc]init];
    [self.navigationController pushViewController:new animated:YES];
}

-(void)TimeOutdoTimer{
    NewLoginViewController *new  = [[NewLoginViewController alloc]init];
    [self.navigationController pushViewController:new animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.title = @"退货订单";
    [self createBackBtn];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    requestBool = NO;
    dataArray = [[NSMutableArray alloc]init];
    dataArrayShangla = [[NSMutableArray alloc]init];
    
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    if (ScreenFrame.size.height>480) {//说明是5 5s
        MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y, ScreenFrame.size.width, ScreenFrame.size.height-20)];
    }else{
        MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y, ScreenFrame.size.width, ScreenFrame.size.height-20)];
    }
    MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MyTableView.delegate = self;
    MyTableView.dataSource=  self;
    MyTableView.showsVerticalScrollIndicator=NO;
    MyTableView.showsHorizontalScrollIndicator = NO;
    MyTableView.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1];
    
//    _obj = [[SYObject alloc]init];
//    NSArray *titleArr = @[@"商品退货",@"团购退款"];
//    [_obj sy_addHeadNaviTitleArray:titleArr toContainerViewWithFrameSetted:self.view headerHeight:44.0 topMargin:0 testColor:NO normalFontSize:15.f selectedFontSize:15.f];
//    [_obj setFirstTableViewAs:MyTableView];
    
    //生活购退货
//    returnMoneyViewController *groupReturnVC = [returnMoneyViewController new];
//
//    [self addChildViewController:groupReturnVC];
//    UITableView *tv2 = _obj.tableViewArray[1];
//    groupReturnVC.view.frame = tv2.bounds;
//    [tv2 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    [tv2 addSubview:groupReturnVC.view];
//    [groupReturnVC didMoveToParentViewController:self];
//    groupReturnVC.segmentControl.hidden = YES;
//    groupReturnVC.view.transform = CGAffineTransformMakeTranslation(0, -64);
//   
    
    [MyTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [MyTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    [self.view addSubview:MyTableView];

    muchBool = NO;
    [self create_leftUI];
}
#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1){  //关闭主界面的右滑返回
        return NO;
    }else{
        
        return YES;
    }
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
    if (dataArray.count!=0) {
        return dataArray.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (dataArray.count!=0) {
        ClassifyModel *class = [dataArray objectAtIndex:indexPath.row];
        return  class.dingdetail_goods_maps.count*74+78+20;
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
        UIView *viewM = [[UIView alloc]initWithFrame:CGRectMake(0, 10, ScreenFrame.size.width, class.dingdetail_goods_maps.count*74+68+20)];
        viewM.backgroundColor = [UIColor whiteColor];
        [cell addSubview:viewM];
        
        UILabel *labelDi = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, ScreenFrame.size.width, 30)];
        labelDi.text = [NSString stringWithFormat:@"  订单编号:%@",class.dingdetail_order_id];
        labelDi.textColor = [UIColor darkGrayColor];
        labelDi.font = [UIFont systemFontOfSize:15];
        [viewM addSubview:labelDi];
        
        UILabel *labelMyTime = [[UILabel alloc]initWithFrame:CGRectMake(10, 30+5, 300, 30)];
        labelMyTime.text = [NSString stringWithFormat:@"  下单时间:%@",class.dingdetail_shipTime];
        labelMyTime.textColor = [UIColor darkGrayColor];
        labelMyTime.font = [UIFont systemFontOfSize:15];
        [viewM addSubview:labelMyTime];
        
        UIView *labelLineT = [[UIView alloc]initWithFrame:CGRectMake(15,60+10, ScreenFrame.size.width, 0.5)];
        if (class.dingdetail_goods_maps.count == 0) {
            labelLineT.hidden = YES;
        }else{
            labelLineT.hidden = NO;
        }
        labelLineT.backgroundColor = [UIColor lightGrayColor];
        [viewM addSubview:labelLineT];
        
        for(int i=0;i<class.dingdetail_goods_maps.count;i++){
            NSDictionary *dic = [class.dingdetail_goods_maps objectAtIndex:i];
            UIImageView *imageBig = [[UIImageView alloc]initWithFrame:CGRectMake(15, 68+10+5+i*74, 64, 64)];
            [imageBig sd_setImageWithURL:(NSURL*)[NSString stringWithFormat:@"%@",[dic objectForKey:@"goods_img"]]  placeholderImage:[UIImage imageNamed:@"kong_lj"]];
            [viewM addSubview:imageBig];
            
            UILabel *labelCount = [[UILabel alloc]initWithFrame:CGRectMake(90, 68+10+5+i*74, ScreenFrame.size.width - 100, 38)];
            labelCount.text = [dic objectForKey:@"goods_name"];
            labelCount.textColor = [UIColor blackColor];
            labelCount.numberOfLines = 2;
            labelCount.font = [UIFont systemFontOfSize:14];
            [viewM addSubview:labelCount];
            
            UIImageView *labelLine = [[UIImageView alloc]initWithFrame:CGRectMake(20, 68+10+73.5+i*74, ScreenFrame.size.width-20, 0.5)];
            labelLine.backgroundColor = [UIColor grayColor];
            [viewM addSubview:labelLine];
            if (i==class.dingdetail_goods_maps.count-1) {
                labelLine.hidden = YES;
            }
            
            UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom ];
            button2.frame =CGRectMake(0, 68+10+5+i*74, viewM.frame.size.width, 74);
            button2.tag = 100*indexPath.row +i;
            [button2 addTarget:self action:@selector(btnGoodsDetailClicked:) forControlEvents:UIControlEventTouchUpInside];
            [viewM addSubview:button2];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
            button.frame =CGRectMake(ScreenFrame.size.width - 95, 68+10+i*74+42, 90, 28);
            [button setTitle:[dic objectForKey:@"return_mark"] forState:UIControlStateNormal];
            button.tag = 100*indexPath.row +i;
            NSLog(@"button.tag:%ld",(long)button.tag);
            button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [button.layer setMasksToBounds:YES];
            [button.layer setCornerRadius:4.0f];
            button.backgroundColor =UIColorFromRGB(0xf15353);
            [viewM addSubview:button];
            if ([[dic objectForKey:@"return_can"] isEqualToString:@"true"]) {
                button.backgroundColor =UIColorFromRGB(0xf15353);
            }else{
                button.backgroundColor = [UIColor orangeColor];
            }
        }
    }
    return cell;
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
                    ///
                    log.return_goods_count=[[class.dingdetail_goods_maps objectAtIndex:i] objectForKey:@"goods_count"];
                    log.return_goods_price=[[class.dingdetail_goods_maps objectAtIndex:i] objectForKey:@"goods_price"];
                    NSLog(@"%@",[[class.dingdetail_goods_maps objectAtIndex:i] objectForKey:@"return_mark"]);
                    if ([[[class.dingdetail_goods_maps objectAtIndex:i] objectForKey:@"return_mark"] isEqualToString:@"填写退货物流"]) {
                        returnGoodsShipViewController *gg = [[returnGoodsShipViewController alloc]init];
                        [self presentViewController:gg animated:YES completion:nil];
                    }else if ([[[class.dingdetail_goods_maps objectAtIndex:i] objectForKey:@"return_mark"] isEqualToString:@"已申请"]) {
                        ApplyForReturnCancelViewController *gg = [[ApplyForReturnCancelViewController alloc]init];
                        [self presentViewController:gg animated:YES completion:nil];
                    }else if ([[[class.dingdetail_goods_maps objectAtIndex:i] objectForKey:@"return_mark"] isEqualToString:@"申请退货"]){
                        ApplyForReturnViewController *gg = [[ApplyForReturnViewController alloc]init];
                        [self presentViewController:gg animated:YES completion:nil];
                    }
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
                    ///
                    log.return_goods_count=[[class.dingdetail_goods_maps objectAtIndex:i] objectForKey:@"goods_count"];
                    log.return_goods_price=[[class.dingdetail_goods_maps objectAtIndex:i] objectForKey:@"goods_price"];
                    if ([[[class.dingdetail_goods_maps objectAtIndex:i] objectForKey:@"return_mark"] isEqualToString:@"填写退货物流"]) {
                        
                        returnGoodsShipViewController *gg = [[returnGoodsShipViewController alloc]init];
                        [self presentViewController:gg animated:YES completion:nil];
                    }else if ([[[class.dingdetail_goods_maps objectAtIndex:i] objectForKey:@"return_mark"] isEqualToString:@"已申请"]) {
                        ApplyForReturnCancelViewController *gg = [[ApplyForReturnCancelViewController alloc]init];
                        [self presentViewController:gg animated:YES completion:nil];
                    }else if ([[[class.dingdetail_goods_maps objectAtIndex:i] objectForKey:@"return_mark"] isEqualToString:@"申请退货"]){
                        ApplyForReturnViewController *gg = [[ApplyForReturnViewController alloc]init];
                        [self presentViewController:gg animated:YES completion:nil];
                    }
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

#pragma mark - 下拉刷新
-(void)footerRereshing{
    NSArray *keyArr = [[NSArray alloc]initWithObjects:@"user_id",@"token",@"begin_count", nil];
    NSArray *valueArr = [[NSArray alloc]initWithObjects:[USER_INFORMATION objectAtIndex:3],[USER_INFORMATION objectAtIndex:1],[NSString stringWithFormat:@"%d",(int)dataArray.count], nil];
    request_3 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,BUYER_RETURN_LIST_URL] setKey:keyArr setValue:valueArr];
    request_3.delegate =self;
    [request_3 setDidFailSelector:@selector(my2_urlRequestFailed:)];
    [request_3 setDidFinishSelector:@selector(my2_urlRequestSucceeded:)];
    [request_3 startAsynchronous];
    
}
-(void)headerRereshing
{
    NSArray *keyArr = [[NSArray alloc]initWithObjects:@"user_id",@"token", nil];
    NSArray *valueArr = [[NSArray alloc]initWithObjects:[USER_INFORMATION objectAtIndex:3],[USER_INFORMATION objectAtIndex:1], nil];
    request_1 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,BUYER_RETURN_LIST_URL] setKey:keyArr setValue:valueArr];
    request_1.delegate =self;
    [request_1 setDidFailSelector:@selector(my1_urlRequestFailed:)];
    [request_1 setDidFinishSelector:@selector(myHeader_urlRequestSucceeded:)];
    [request_1 startAsynchronous];


}
-(void)my2_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        if (dataArrayShangla.count!=0) {
            [dataArrayShangla removeAllObjects];
        }
        dataArrayShangla = [consultViewNetwork dataBuyer_eturnListData:request];
        requestBool = YES;
        [dataArray addObjectsFromArray:dataArrayShangla];
        [MyTableView reloadData];
        
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"result=%@", dicBig);
        if ([[dicBig objectForKey:@"code"] intValue] == 100) {
        }else if([[dicBig objectForKey:@"code"] intValue] == -100){
            [SYObject failedPrompt:@"用户登录已过期,请重新登录"];
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(TimeoutdoTimer) userInfo:nil repeats:NO];
        }else{
            MyTableView.hidden = YES;
        }
        [SYObject endLoading];
    }else{
        [SYObject failedPrompt:@"网络请求失败"];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [MyTableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [MyTableView footerEndRefreshing];
    });
}
-(void)my2_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
    
}


@end
