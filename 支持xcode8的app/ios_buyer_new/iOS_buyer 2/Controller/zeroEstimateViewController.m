//
//  zeroEstimateViewController.m
//  My_App
//
//  Created by apple on 15-1-19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "zeroEstimateViewController.h"
#import "LoginViewController.h"
#import "ASIFormDataRequest.h"
#import "NilCell.h"
#import "FirstViewController.h"
#import "UseEvaluationCell.h"
@interface zeroEstimateViewController (){
    ASIFormDataRequest *request3;
}

@end

@implementation zeroEstimateViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request3 clearDelegatesAndCancel];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)createRealBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backRealBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
    
}

-(void)backRealBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createRealBackBtn];
    requestBool = NO;
    dataArrayShangla = [[NSMutableArray alloc]init];
    dataArray = [[NSMutableArray alloc]init];
    UIImageView *imageZanwu = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenFrame.size.width-100)/2, 170, 100, 100)];
    imageZanwu.image= [UIImage imageNamed:@"seller_center_nothing"];
    [self.view addSubview:imageZanwu];
    UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(0, 300, ScreenFrame.size.width, 30)];
    la.text=@"抱歉,暂无评价";
    la.backgroundColor=[UIColor clearColor];
    la.textAlignment=NSTextAlignmentCenter;
    la.textColor=[UIColor darkGrayColor];
    la.font=[UIFont systemFontOfSize:17];
    [self.view addSubview:la];
    if (ScreenFrame.size.height<=480) {
        imageZanwu.frame =CGRectMake((ScreenFrame.size.width-100)/2, 150, 100, 100);
        la.frame = CGRectMake(0, 300, ScreenFrame.size.width, 22);
    }else if (ScreenFrame.size.height>480&&ScreenFrame.size.height<=568){
        imageZanwu.frame =CGRectMake((ScreenFrame.size.width-100)/2, 170, 100, 100);
        la.frame = CGRectMake(0, 320, ScreenFrame.size.width, 22);
    }else if (ScreenFrame.size.height>568&&ScreenFrame.size.height<=1334/2){
        imageZanwu.frame =CGRectMake((ScreenFrame.size.width-100)/2, 220, 100, 100);
        la.frame = CGRectMake(0, 370, ScreenFrame.size.width, 22);
    }else{
        imageZanwu.frame =CGRectMake((ScreenFrame.size.width-100)/2, 240, 100, 100);
        la.frame = CGRectMake(0, 380, ScreenFrame.size.width, 22);
    }
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    if (ScreenFrame.size.height>480) {//说明是5 5s
        MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y, ScreenFrame.size.width, ScreenFrame.size.height)];
    }else{
        MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y, ScreenFrame.size.width, ScreenFrame.size.height)];
    }
    MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MyTableView.delegate = self;
    MyTableView.dataSource=  self;
    MyTableView.showsVerticalScrollIndicator=NO;
    MyTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:MyTableView];
    [MyTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.title = @"试用评价";
    // Do any additional setup after loading the view.
    [SYObject startLoading];
    FirstViewController *ol = [FirstViewController sharedUserDefault];
    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ZERO_DETAIL_ESTIMATE_URL]];
    request3=[ASIFormDataRequest requestWithURL:url3];
    [request3 setPostValue:ol.Detailfree_id forKey:@"id"];
    [request3 setPostValue:@"0" forKey:@"begincount"];
    [request3 setPostValue:@"20" forKey:@"selectcount"];
    
    [request3 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request3.tag = 101;
    request3.delegate =self;
    [request3 setDidFailSelector:@selector(urlRequestFailed:)];
    [request3 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [request3 startAsynchronous];

}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
//    loadingV.hidden = YES;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求出现问题"];
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig1:%@",dicBig);
        if (dicBig) {
            NSArray *arr = [dicBig objectForKey:@"eva_list"];
            for(NSDictionary *dic in arr){
                ClassifyModel *class = [[ClassifyModel alloc]init];
                class.ping_addTime = [dic objectForKey:@"evaluate_time"];
                class.ping_content = [dic objectForKey:@"use_experience"];
                class.ping_user_user_id = [dic objectForKey:@"user_id"];
                class.ping_user_photo = [dic objectForKey:@"user_photo"];
                class.ping_user = [dic objectForKey:@"user_name"];
                [dataArray addObject:class];
            }
        }
        if (dataArray.count == 0) {
            MyTableView.hidden = YES;
        }else{
            MyTableView.hidden = NO;
        }
        [MyTableView reloadData];
//        loadingV.hidden = YES;
        [SYObject endLoading];
    }
    else{
//        loadingV.hidden = YES;
        [SYObject endLoading];
    }
    
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
        return [UseEvaluationCell cellHeightWithModel:class];
    }
    return 0;//动态的高度
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UseEvaluationCell *cell=[UseEvaluationCell cellWithTableView:tableView];
    if (dataArray.count!=0) {
         ClassifyModel *class = [dataArray  objectAtIndex:indexPath.row];
        cell.model=class;
    }
    return cell;
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
    
    FirstViewController *ol = [FirstViewController sharedUserDefault];
    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ZERO_DETAIL_ESTIMATE_URL]];
    request3=[ASIFormDataRequest requestWithURL:url3];
    [request3 setPostValue:ol.Detailfree_id forKey:@"id"];
    [request3 setPostValue:[NSString stringWithFormat:@"%lu",(unsigned long)dataArray.count] forKey:@"begincount"];
    [request3 setPostValue:@"20" forKey:@"selectcount"];
    
    [request3 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request3.tag = 101;
    request3.delegate =self;
    [request3 setDidFailSelector:@selector(up_urlRequestFailed:)];
    [request3 setDidFinishSelector:@selector(up_urlRequestSucceeded:)];
    [request3 startAsynchronous];
    
}
-(void)up_urlRequestFailed:(ASIFormDataRequest *)request{
//    loadingV.hidden = YES;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求出现问题"];
}
-(void)up_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        if (dataArrayShangla.count!=0) {
            [dataArrayShangla removeAllObjects];
        }
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if (dicBig) {
            NSArray *arr = [dicBig objectForKey:@"eva_list"];
            for(NSDictionary *dic in arr){
                ClassifyModel *class = [[ClassifyModel alloc]init];
                class.ping_addTime = [dic objectForKey:@"evaluate_time"];
                class.ping_content = [dic objectForKey:@"use_experience"];
                class.ping_user_user_id = [dic objectForKey:@"user_id"];
                class.ping_user_photo = [dic objectForKey:@"user_photo"];
                class.ping_user = [dic objectForKey:@"user_name"];
                [dataArrayShangla addObject:class];
            }
            
        }
        [dataArray addObjectsFromArray:dataArrayShangla];
        [MyTableView reloadData];
//        loadingV.hidden = YES;
        [SYObject endLoading];
    }
    else{
//        loadingV.hidden = YES;
        [SYObject endLoading];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [MyTableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [MyTableView footerEndRefreshing];
    });
}


@end
