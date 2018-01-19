//
//  EstimateViewController.m
//  My_App
//
//  Created by apple on 14-7-31.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "EstimateViewController.h"
#import "SecondViewController.h"
#import "ASIFormDataRequest.h"
#import "pingjiaCell.h"
#import "PublishViewController.h"

@interface EstimateViewController ()

@end

@implementation EstimateViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [request_1 clearDelegatesAndCancel];
    [request_2 clearDelegatesAndCancel];
    [request_3 clearDelegatesAndCancel];
    [request_4 clearDelegatesAndCancel];
    [request_5 clearDelegatesAndCancel];
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillAppear:YES];
    
    [SYObject startLoading];
    SecondViewController *sec = [SecondViewController sharedUserDefault];
    
    NSArray *keyArr = [[NSArray alloc]initWithObjects:@"id",@"beginCount",@"selectCount", nil];
    NSArray *valueArr = [[NSArray alloc]initWithObjects:sec.detail_id,@"0",@"20", nil];
    request_1 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,CONSULT_URL] setKey:keyArr setValue:valueArr];
    request_1.delegate =self;
    [request_1 setDidFailSelector:@selector(my1_urlRequestFailed:)];
    [request_1 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
    [request_1 startAsynchronous];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom ];
    button2.frame =CGRectMake(0, 0, 60, 30);
    [button2 setTitle:@"发表咨询" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:14];
    button2.titleLabel.textColor = [UIColor whiteColor];
    [button2 addTarget:self action:@selector(publickBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    button2.titleLabel.font  = [UIFont systemFontOfSize:14];
    UIBarButtonItem *bar2 = [[UIBarButtonItem alloc]initWithCustomView:button2];
    self.navigationItem.rightBarButtonItem =bar2;
}
-(void)publickBtnClicked{
    PublishViewController *pub = [[PublishViewController alloc]init];
    [self.navigationController pushViewController:pub animated:YES];
}
-(void)backBtnClicked{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tabelView方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    pingjiaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pingjiaCell"];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"pingjiaCell" owner:self options:nil] lastObject];
    }
    if (dataArray.count!=0) {
        ClassifyModel *model = [dataArray objectAtIndex:indexPath.row];
        [cell setData:model];
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArray.count!=0) {
        return dataArray.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (dataArray.count!=0) {
        ClassifyModel *mm = [dataArray objectAtIndex:indexPath.row];
        if ([mm.ping_reply intValue] == 1){
            CGRect labelFrameModel2 = [self labelSizeHeight:mm.ping_content frame:CGRectMake(40, 0, 0.0, 0.0) font:15];
            CGRect labelFrameModel22 = [self labelSizeHeight:mm.ping_reply_content frame:CGRectMake(40, 0, 0.0, 0.0) font:15];
            return 40+labelFrameModel2.size.height+20+labelFrameModel22.size.height+20;
        }else{
            CGRect labelFrameModel2 = [self labelSizeHeight:mm.ping_content frame:CGRectMake(40, 0, 0.0, 0.0) font:15];
            return 40+labelFrameModel2.size.height+20;
        }
    }
    return 0;
}

#pragma mark - label计算高度
-(CGRect )labelSizeHeight:(NSString *)labeltext frame:(CGRect)frame font:(NSInteger )myfont{
    UILabel *labelTiecontent = [[UILabel alloc]init];
    labelTiecontent.numberOfLines = 0;
    labelTiecontent.font = [UIFont systemFontOfSize:myfont];
    labelTiecontent.text = labeltext;
    CGRect labelFrameTie = frame;
    labelFrameTie.size = [labelTiecontent sizeThatFits:CGSizeMake(ScreenFrame.size.width-frame.origin.x-15,  0)];
    return labelFrameTie;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createBackBtn];
    dataArray = [[NSMutableArray alloc]init];
    dataArrShangla = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view from its nib.
    requestBool = NO;
    imageZanwu.hidden = YES;
    la.hidden = YES;
    
    self.title = @"商品咨询";
    self.view.backgroundColor = [UIColor whiteColor];
    SecondViewController *sec = [SecondViewController sharedUserDefault];
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    MyTableView.delegate = self;
    MyTableView.dataSource=  self;
    MyTableView.showsVerticalScrollIndicator=NO;
    MyTableView.showsHorizontalScrollIndicator = NO;
    MyTableView.backgroundColor = BACKGROUNDCOLOR;
    [MyTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    grayView.layer.cornerRadius=8;
    grayView.layer.masksToBounds=YES;
    
    NSArray *keyArr = [[NSArray alloc]initWithObjects:@"id",@"beginCount",@"selectCount", nil];
    NSArray *valueArr = [[NSArray alloc]initWithObjects:sec.detail_id,@"0",@"20", nil];
    request_2 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,CONSULT_URL] setKey:keyArr setValue:valueArr];
    request_2.delegate =self;
    [request_2 setDidFailSelector:@selector(my1_urlRequestFailed:)];
    [request_2 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
    [request_2 startAsynchronous];
    
    UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backBtnClicked)];
    rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
    [MyTableView addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];
    UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backBtnClicked)];
    rightSwipeGestureRecognizerSMytableview2.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGestureRecognizerSMytableview2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
}

#pragma mark - 上拉刷新
-(void)footerRereshing{
//    loadingV.hidden = NO;
    [SYObject startLoading];
    SecondViewController *sec = [SecondViewController sharedUserDefault];
    
    NSArray *keyArr = [[NSArray alloc]initWithObjects:@"id",@"beginCount",@"selectCount", nil];
    NSArray *valueArr = [[NSArray alloc]initWithObjects:sec.detail_id,[NSString stringWithFormat:@"%lu",(unsigned long)dataArray.count],@"20", nil];
    request_4 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,CONSULT_URL] setKey:keyArr setValue:valueArr];
    request_4.delegate =self;
    [request_4 setDidFailSelector:@selector(my2_urlRequestFailed:)];
    [request_4 setDidFinishSelector:@selector(my2_urlRequestSucceeded:)];
    [request_4 startAsynchronous];
    
}
#pragma mark - 网络
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        dataArray = [consultViewNetwork dataEstimateData:request];
        if (dataArray.count==0) {
            MyTableView.hidden =YES;
            imageZanwu.hidden = NO;
            la.hidden = NO;
        }else{
            [MyTableView reloadData];
            MyTableView.hidden =NO;
            imageZanwu.hidden = YES;
            la.hidden = YES;
        }
        [MyTableView reloadData];
        [SYObject endLoading];
    }
    else{
          [SYObject endLoading];
    }
}
-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{
     [SYObject endLoading];
}
-(void)my2_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        if (dataArrShangla.count!=0) {
            [dataArrShangla removeAllObjects];
        }
        dataArrShangla = [consultViewNetwork dataEstimateData:request];
        [dataArray addObjectsFromArray:dataArrShangla];
        requestBool = YES;
        [MyTableView reloadData];
        [SYObject endLoading];
    }
    else{
       [SYObject endLoading];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MyTableView reloadData];
        [MyTableView footerEndRefreshing];
    });
}
-(void)my2_urlRequestFailed:(ASIFormDataRequest *)request{
      [SYObject endLoading];
}

-(void)dealloc {
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    dataArray = nil;
    dataArrShangla = nil;
    MyTableView = nil;
}

@end
