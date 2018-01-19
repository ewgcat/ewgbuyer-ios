//
//  returnMoneyViewController.m
//  My_App
//
//  Created by apple on 15-1-26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "returnMoneyViewController.h"
#import "ASIFormDataRequest.h"
#import "buyer_returnCell.h"
#import "returnMoneyCell.h"
#import "LoginViewController.h"
#import "goodsReturnApplyViewController.h"
#import "DetailViewController.h"
#import "SecondViewController.h"
#import "LifeGroupViewController.h"
#import "NewLoginViewController.h"
#import "FirstViewController.h"

@interface returnMoneyViewController (){
    ASIFormDataRequest *request_1;
    ASIFormDataRequest *request_2;
    ASIFormDataRequest *request_3;
    ASIFormDataRequest *request_4;
    ASIFormDataRequest *request_5;
}

@end

@implementation returnMoneyViewController

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
    muchView = [LJControl MuchView:CGRectMake(self.view.frame.size.width-136, 64, 126, 220)];
    [self.view addSubview:muchView];
    muchView.hidden = YES;
    for (int i=0; i<5; i++) {
        UIButton *btn = [LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(0, 10+i*40, 126, 40) setNormalImage:[UIImage imageNamed:@""] setSelectedImage:[UIImage imageNamed:@""] setTitle:@"" setTitleFont:10 setbackgroundColor:[UIColor clearColor]];
        btn.tag = 101+i;
        [btn addTarget:self action:@selector(mainBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [muchView addSubview:btn];
    }
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

-(void)TimeOutdoTimer{
    NewLoginViewController *new = [[NewLoginViewController alloc]init];
    [self.navigationController pushViewController:new animated:YES];
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request_2 clearDelegatesAndCancel];
    [request_1 clearDelegatesAndCancel];
    [request_3 clearDelegatesAndCancel];
    [request_4 clearDelegatesAndCancel];
    [request_5 clearDelegatesAndCancel];
    [MyTableView setEditing:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    
    NSArray *keyArr = [[NSArray alloc]initWithObjects:@"user_id",@"token", nil];
    NSArray *valueArr = [[NSArray alloc]initWithObjects:[USER_INFORMATION objectAtIndex:3],[USER_INFORMATION objectAtIndex:1], nil];
    request_1 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,GROUPLIFE_RETURN_URL] setKey:keyArr setValue:valueArr];
    
    request_1.delegate = self;
    [request_1 setDidFailSelector:@selector(urlRequestFailed:)];
    [request_1 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [request_1 startAsynchronous];
    [super viewWillAppear:YES];
}
#pragma mark - 网络
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request  responseStatusCode];
    if (statuscode2 == 200) {
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        dataArray = [consultViewNetwork dataMoney_eturnListData:request];
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig：%@",dicBig);
        
        if ([[dicBig objectForKey:@"ret"] isEqualToString:@"false"]) {
            [SYObject failedPrompt:@"登录已过期,请重新登录"];
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(TimeOutdoTimer) userInfo:nil repeats:NO];
        }else{
            if (dataArray.count == 0) {
                 MyTableView.backgroundView = [SYObject noDataView];
            }else{
                MyTableView.hidden = NO;
            }
            [MyTableView reloadData];
        }
        [SYObject endLoading];
    }
    else{
        [SYObject failedPrompt:@"请求出错"];
    }
    
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig：%@",dicBig);
        
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        NSArray *arr = [dicBig objectForKey:@"datas"];
        for(NSDictionary *dic in arr){
            ClassifyModel *class = [[ClassifyModel alloc]init];
            class.goods_main_photo = [dic objectForKey:@"group_goods_img"];
            class.goods_name = [dic objectForKey:@"group_goods_name"];
            class.goods_current_price = [dic objectForKey:@"group_goods_price"];
            class.goods_status = [dic objectForKey:@"group_status"];
            class.goods_addTime = [dic objectForKey:@"group_addTime"];
            class.goods_id = [dic objectForKey:@"group_id"];
            class.goods_refund_msg = [dic objectForKey:@"refund_msg"];
            class.goods_sn = [dic objectForKey:@"group_sn"];
            [dataArray addObject:class];
        }
        if (dataArray.count == 0) {
            MyTableView.hidden = YES;
        }else{
            MyTableView.hidden = NO;
        }
        [MyTableView reloadData];
        
        [SYObject endLoading];
    }
    else{
        [SYObject failedPrompt:@"请求出错"];
    }
    
}
-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)my2_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig：%@",dicBig);
        
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        NSArray *arr = [dicBig objectForKey:@"datas"];
        for(NSDictionary *dic in arr){
            ClassifyModel *class = [[ClassifyModel alloc]init];
            class.goods_main_photo = [dic objectForKey:@"group_goods_img"];
            class.goods_name = [dic objectForKey:@"group_goods_name"];
            class.goods_current_price = [dic objectForKey:@"group_goods_price"];
            class.goods_status = [dic objectForKey:@"group_status"];
            class.goods_addTime = [dic objectForKey:@"group_addTime"];
            class.goods_id = [dic objectForKey:@"group_id"];
            class.goods_refund_msg = [dic objectForKey:@"refund_msg"];
            class.goods_sn = [dic objectForKey:@"group_sn"];
            [dataArray addObject:class];
        }
        if (dataArray.count == 0) {
            MyTableView.hidden = YES;
        }else{
            MyTableView.hidden = NO;
        }
        [MyTableView reloadData];
        
        [SYObject endLoading];
    }
    else{
        [SYObject failedPrompt:@"请求出错"];
    }
    
}
-(void)my2_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)my3_urlRequestSucceeded:(ASIFormDataRequest *)request{
    
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig：%@",dicBig);
        
        if (dataArrayShangla.count!=0) {
            [dataArrayShangla removeAllObjects];
        }
        NSArray *arr = [dicBig objectForKey:@"datas"];
        for(NSDictionary *dic in arr){
            ClassifyModel *class = [[ClassifyModel alloc]init];
            class.goods_main_photo = [dic objectForKey:@"group_goods_img"];
            class.goods_name = [dic objectForKey:@"group_goods_name"];
            class.goods_current_price = [dic objectForKey:@"group_goods_price"];
            class.goods_status = [dic objectForKey:@"group_status"];
            class.goods_addTime = [dic objectForKey:@"group_addTime"];
            class.goods_id = [dic objectForKey:@"group_id"];
            class.goods_refund_msg = [dic objectForKey:@"refund_msg"];
            class.goods_sn = [dic objectForKey:@"group_sn"];
            [dataArrayShangla addObject:class];
        }
        [dataArray addObjectsFromArray:dataArrayShangla];
        requestBool = YES;
        [MyTableView reloadData];
        
        [SYObject endLoading];
    }
    else{
        [SYObject failedPrompt:@"请求出错"];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [MyTableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [MyTableView footerEndRefreshing];
    });
}
-(void)my3_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)my4_urlRequestSucceeded:(ASIFormDataRequest *)request{
    
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig：%@",dicBig);
        
        if (dataArrayShangla.count!=0) {
            [dataArrayShangla removeAllObjects];
        }
        NSArray *arr = [dicBig objectForKey:@"datas"];
        for(NSDictionary *dic in arr){
            ClassifyModel *class = [[ClassifyModel alloc]init];
            class.goods_main_photo = [dic objectForKey:@"group_goods_img"];
            class.goods_name = [dic objectForKey:@"group_goods_name"];
            class.goods_current_price = [dic objectForKey:@"group_goods_price"];
            class.goods_status = [dic objectForKey:@"group_status"];
            class.goods_addTime = [dic objectForKey:@"group_addTime"];
            class.goods_id = [dic objectForKey:@"group_id"];
            class.goods_refund_msg = [dic objectForKey:@"refund_msg"];
            class.goods_sn = [dic objectForKey:@"group_sn"];
            [dataArrayShangla addObject:class];
        }
        requestBool = YES;
        [dataArray addObjectsFromArray:dataArrayShangla];
        [MyTableView reloadData];
        
        [SYObject endLoading];
    }
    else{
        [SYObject failedPrompt:@"请求出错"];
    }
    
}
-(void)my4_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)change:(UISegmentedControl *)segmentControl{
    if (segmentControl.selectedSegmentIndex == 0) {}
    else{
        SegmentTag = 1;
        NSArray *keyArr = [[NSArray alloc]initWithObjects:@"user_id",@"token", nil];
        NSArray *valueArr = [[NSArray alloc]initWithObjects:[USER_INFORMATION objectAtIndex:3],[USER_INFORMATION objectAtIndex:1], nil];
        request_2 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,GROUPLIFE_RETURN_URL] setKey:keyArr setValue:valueArr];
        
        request_2.delegate = self;
        [request_2 setDidFailSelector:@selector(my1_urlRequestFailed:)];
        [request_2 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
        [request_2 startAsynchronous];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    SegmentTag = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.title = @"退款订单";
    [self createBackBtn];
    
    requestBool = NO;
    dataArray = [[NSMutableArray alloc]init];
    dataArrayShangla = [[NSMutableArray alloc]init];
    
//    NSArray *array=@[@"商品退款",@"生活购退款"];
//    UISegmentedControl *segmentControl=[[UISegmentedControl alloc]initWithItems:array];
//    segmentControl.frame=CGRectMake(10, 0, 300, 30);
//    segmentControl.selectedSegmentIndex=0;
//    segmentControl.tintColor = MY_COLOR;
//    [segmentControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
//    _segmentControl = segmentControl;
//    [self.view addSubview:segmentControl];
    
//    UIImageView *imageZanwu = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenFrame.size.width-100)/2, 170, 100, 100)];
//    UIImageView *imageZanwu = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenFrame.size.width-263)/2, (ScreenFrame.size.height-108-263)/2, 263, 263)];
//    imageZanwu.image= [UIImage imageNamed:@"seller_center_nothing"];
//    [self.view addSubview:imageZanwu];
//    UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(0, 300, ScreenFrame.size.width, 30)];
//    la.text=@"抱歉,暂无退款订单";
//    la.backgroundColor=[UIColor clearColor];
//    la.textAlignment=NSTextAlignmentCenter;
//    la.textColor=[UIColor darkGrayColor];
//    la.font=[UIFont systemFontOfSize:17];
//    [self.view addSubview:la];
//    if (ScreenFrame.size.height<=480) {
//        imageZanwu.frame =CGRectMake((ScreenFrame.size.width-100)/2, 150, 100, 100);
//        la.frame = CGRectMake(0, 300, ScreenFrame.size.width, 22);
//    }else if (ScreenFrame.size.height>480&&ScreenFrame.size.height<=568){
//        imageZanwu.frame =CGRectMake((ScreenFrame.size.width-100)/2, 170, 100, 100);
//        la.frame = CGRectMake(0, 320, ScreenFrame.size.width, 22);
//    }else if (ScreenFrame.size.height>568&&ScreenFrame.size.height<=1334/2){
//        imageZanwu.frame =CGRectMake((ScreenFrame.size.width-100)/2, 220, 100, 100);
//        la.frame = CGRectMake(0, 370, ScreenFrame.size.width, 22);
//    }else{
//        imageZanwu.frame =CGRectMake((ScreenFrame.size.width-100)/2, 240, 100, 100);
//        la.frame = CGRectMake(0, 380, ScreenFrame.size.width, 22);
//    }
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    if (ScreenFrame.size.height>480) {//说明是5 5s
        MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    }else{
        MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    }
    MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MyTableView.delegate = self;
    MyTableView.dataSource=  self;
    MyTableView.showsVerticalScrollIndicator=NO;
    MyTableView.showsHorizontalScrollIndicator = NO;
    MyTableView.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1];
    [self.view addSubview:MyTableView];
    [MyTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    muchBool = NO;
    [self create_leftUI];
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
        if (SegmentTag == 0) {
            
        }else{
//            if (indexPath.row == 0) {
//                return 298-34;
//            }
            return 258-34+9;
        }
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (dataArray.count!=0) {
        if (SegmentTag==0) {}else{
//            if(indexPath.row == 0){
//                returnMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"returnMoneyCell"];
//                if(cell == nil){
//                    cell = [[[NSBundle mainBundle] loadNibNamed:@"returnMoneyCell" owner:self options:nil] lastObject];
//                }
//                ClassifyModel *class = [dataArray objectAtIndex:indexPath.row];
//                [cell setData:class];
//                cell.returnBtn.tag = 100+indexPath.row;
//                [cell.returnBtn addTarget:self action:@selector(btnLifeGroupClicked:) forControlEvents:UIControlEventTouchUpInside];
//                
//                if ([class.goods_status intValue]==7){
//                    cell.returnBtn.hidden = YES;
//                    cell.returnBtn.enabled = NO;
//                    cell.returnBtn.backgroundColor =[UIColor orangeColor];
//                }else if ([class.goods_status intValue]==5){
//                    cell.returnBtn.enabled = YES;
//                    cell.returnBtn.backgroundColor =UIColorFromRGB(0xf15353);
//                }else{
//                    cell.returnBtn.enabled = YES;
//                    cell.returnBtn.backgroundColor =UIColorFromRGB(0xf15353);
//                }
//                return cell;
//            }
           
                buyer_returnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buyer_returnCell"];
                if(cell == nil){
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"buyer_returnCell" owner:self options:nil] lastObject];
                }
                ClassifyModel *class = [dataArray objectAtIndex:indexPath.row];
                [cell setData:class];
                
                cell.applyBtn.tag = 100+indexPath.row;
                [cell.applyBtn addTarget:self action:@selector(btnLifeGroupClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                if ([class.goods_status intValue]==7){
                    cell.applyBtn.hidden = YES;
                    cell.applyBtn.enabled = NO;
                    cell.applyBtn.backgroundColor =[UIColor orangeColor];
                }else if ([class.goods_status intValue]==5){
                    cell.applyBtn.enabled = YES;
                    cell.applyBtn.backgroundColor =UIColorFromRGB(0xf15353);
                }else{
                    cell.applyBtn.enabled = YES;
                    cell.applyBtn.backgroundColor =UIColorFromRGB(0xf15353);
                }
                return cell;
                
            
            
        }
    }
    UITableViewCell *cell;
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
        if (btn.tag==100)
        {
             ClassifyModel *class = [dataArray objectAtIndex:btn.tag-100];
            LoginViewController *log = [LoginViewController sharedUserDefault];
            log.return_group_id = [NSString stringWithFormat:@"%@",class.goods_id];
            log.return_group_ImagePhoto = class.goods_main_photo;
            log.return_group_Name = class.goods_name;
            log.return_group_Code = class.goods_sn;
            LifeGroupViewController *li = [[LifeGroupViewController alloc]init];
            [self presentViewController:li animated:YES completion:nil];
        }else
        {
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
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (dataArray.count!=0) {
        if (SegmentTag == 0) {
            //应该进入闲情的
            
        }else{
        }
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
    NSArray *keyArr = [[NSArray alloc]initWithObjects:@"user_id",@"token",@"begin_count", nil];
    NSArray *valueArr = [[NSArray alloc]initWithObjects:[USER_INFORMATION objectAtIndex:3],[USER_INFORMATION objectAtIndex:1],[NSString stringWithFormat:@"%d",(int)dataArray.count+10], nil];
    request_4 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,GROUPLIFE_RETURN_URL] setKey:keyArr setValue:valueArr];
    
    request_4.delegate = self;
    [request_4 setDidFailSelector:@selector(my3_urlRequestFailed:)];
    [request_4 setDidFinishSelector:@selector(my3_urlRequestSucceeded:)];
    [request_4 startAsynchronous];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
