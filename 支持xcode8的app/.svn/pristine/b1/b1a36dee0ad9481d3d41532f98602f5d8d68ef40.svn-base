//
//  ConsultViewController.m
//  My_App
//
//  Created by apple on 14-8-7.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "ConsultViewController.h"
#import "normalGoodsEvaluation_TieCell.h"
#import "SecondViewController.h"
#import "ASIFormDataRequest.h"

@interface ConsultViewController ()

@end

@implementation ConsultViewController
@synthesize MyTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    btnClickedBool = NO;
    // Do any additional setup after loading the view from its nib.
    selectBtnTag = 1;
    requestBool = NO;
    [self createBackBtn];
    dataArray = [[NSMutableArray alloc]init];
    dataArrShangla = [[NSMutableArray alloc]init];
    
    self.title = @"商品评价";
    SecondViewController *sec = [SecondViewController sharedUserDefault];
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
        
    }
    
    MyTableView.delegate = self;
    MyTableView.dataSource=  self;
    MyTableView.showsVerticalScrollIndicator=NO;
    MyTableView.showsHorizontalScrollIndicator = NO;
    [MyTableView addFooterWithTarget:self action:@selector(footerRereshing)];

    [SYObject startLoading];
    NSArray *keyArr = [[NSArray alloc]initWithObjects:@"id",@"beginCount",@"selectCount", nil];
    NSArray *valueArr = [[NSArray alloc]initWithObjects:sec.detail_id,@"0",@"20", nil];
    request_1 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,ASSESS_URL] setKey:keyArr setValue:valueArr];
    request_1.delegate =self;
    [request_1 setDidFailSelector:@selector(my1_urlRequestFailed:)];
    [request_1 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
    [request_1 startAsynchronous];
    
    UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backBtnClicked)];
    rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];
    UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backBtnClicked)];
    rightSwipeGestureRecognizerSMytableview2.direction = UISwipeGestureRecognizerDirectionRight;
    [MyTableView addGestureRecognizer:rightSwipeGestureRecognizerSMytableview2];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    dataArray = nil;
    dataArrShangla = nil;
    dataArray = nil;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
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
    [request_10 clearDelegatesAndCancel];
    [request_11 clearDelegatesAndCancel];
    [request_12 clearDelegatesAndCancel];
    [request_13 clearDelegatesAndCancel];
    [request_14 clearDelegatesAndCancel];
    [request_15 clearDelegatesAndCancel];
    [request_16 clearDelegatesAndCancel];
    [request_17 clearDelegatesAndCancel];
    [request_18 clearDelegatesAndCancel];
    
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)backBtnClicked{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - label计算高度
-(CGRect )labelSizeHeight:(NSString *)labeltext frame:(CGRect)frame font:(NSInteger )myfont{
    UILabel *labelTiecontent = [[UILabel alloc]init];
    labelTiecontent.numberOfLines = 0;
    labelTiecontent.font = [UIFont systemFontOfSize:myfont];
    labelTiecontent.text = labeltext;
    CGRect labelFrameTie = frame;
    labelFrameTie.size = [labelTiecontent sizeThatFits:CGSizeMake(ScreenFrame.size.width-frame.origin.x*2,  0)];
    return labelFrameTie;
}
#pragma mark - tabelView方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArray.count!=0) {
        return dataArray.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (dataArray.count!=0) {
        ClassifyModel *model = [dataArray objectAtIndex:indexPath.row];
        if(model.ping_content.length == 0){
            CGRect labelFrame2=[self labelSizeHeight:[NSString stringWithFormat:@"%@    %@",model.ping_addTime,model.ping_spec] frame:CGRectMake(15, 0, 0.0, 0.0) font:12];
            CGRect labelFrameTie=[self labelSizeHeight:model.ping_Tie frame:CGRectMake(15, 0, 0.0, 0.0) font:13];
            return 30 + labelFrame2.size.height +60 + labelFrameTie.size.height;
        }else{
            CGRect labelFrame=[self labelSizeHeight:model.ping_content frame:CGRectMake(15, 0, 0.0, 0.0) font:16];
            
            CGRect labelFrame2=[self labelSizeHeight:[NSString stringWithFormat:@"%@    %@",model.ping_addTime,model.ping_spec] frame:CGRectMake(15, 0, 0.0, 0.0) font:12];
            
            CGRect labelFrameTie=[self labelSizeHeight:model.ping_Tie frame:CGRectMake(15, 0, 0.0, 0.0) font:13];
            return labelFrame2.size.height + labelFrame.size.height +60 + labelFrameTie.size.height;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    normalGoodsEvaluation_TieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normalGoodsEvaluation_TieCell"];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"normalGoodsEvaluation_TieCell" owner:self options:nil] lastObject];
    }
    if (dataArray.count!=0) {
        ClassifyModel *model = [dataArray objectAtIndex:indexPath.row];
        [cell setData:model];
    }
    return cell;
}
#pragma mark - 网路
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    
    if ([request responseStatusCode] == 200) {
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        dataArray = [consultViewNetwork dataManage:request];
        
        NSMutableArray *countArray = [consultViewNetwork dataManageCount:request];
        _evaluateLabel.text = [NSString stringWithFormat:@"    好评度:%@",[countArray objectAtIndex:0]];
        [_MysegControl setTitle:[NSString stringWithFormat:@"全部(%@)",[countArray objectAtIndex:1]] forSegmentAtIndex:0];
        [_MysegControl setTitle:[NSString stringWithFormat:@"好评(%@)",[countArray objectAtIndex:2]] forSegmentAtIndex:1];
        [_MysegControl setTitle:[NSString stringWithFormat:@"中评(%@)",[countArray objectAtIndex:3]] forSegmentAtIndex:2];
        [_MysegControl setTitle:[NSString stringWithFormat:@"差评(%@)",[countArray objectAtIndex:4]] forSegmentAtIndex:3];
        
        if (dataArray.count!=0) {
            MyTableView.hidden = NO;
        }else{
            MyTableView.hidden = YES;
        }
        [MyTableView reloadData];
        [SYObject endLoading];
    }
    else{
        [SYObject failedPrompt:@"请求出错"];
        [SYObject endLoading];
    }
    _MysegControl.enabled = YES;
    [SYObject endLoading];
}
//-(void)failedPrompt:(NSString *)prompt{
//    loadingV.hidden = YES;
//    labelTi.hidden = NO;
//    labelTi.text = prompt;
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
//    _MysegControl.enabled = YES;
//}
-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
    _MysegControl.enabled = YES;
}
-(void)my2_urlRequestSucceeded:(ASIFormDataRequest *)request{
    if ([request responseStatusCode] == 200) {
        NSMutableArray *countArray = [consultViewNetwork dataManageCount:request];
        _evaluateLabel.text = [NSString stringWithFormat:@"    好评度:%@",[countArray objectAtIndex:0]];
        [_MysegControl setTitle:[NSString stringWithFormat:@"全部(%@)",[countArray objectAtIndex:1]] forSegmentAtIndex:0];
        [_MysegControl setTitle:[NSString stringWithFormat:@"好评(%@)",[countArray objectAtIndex:2]] forSegmentAtIndex:1];
        [_MysegControl setTitle:[NSString stringWithFormat:@"中评(%@)",[countArray objectAtIndex:3]] forSegmentAtIndex:2];
        [_MysegControl setTitle:[NSString stringWithFormat:@"差评(%@)",[countArray objectAtIndex:4]] forSegmentAtIndex:3];
        
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        dataArray = [consultViewNetwork dataManage:request];
        
        if(dataArray.count == 0){
            MyTableView.hidden = YES;
        }else{
            MyTableView.hidden = NO;
        }
        [MyTableView reloadData];
        [SYObject endLoading];
        
    }
    else{
        [SYObject endLoading];
        [SYObject failedPrompt:@"请求出错"];
    }
    [SYObject endLoading];
    _MysegControl.enabled = YES;
}
-(void)my2_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
    _MysegControl.enabled = YES;
}
-(void)my3_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSMutableArray *countArray = [consultViewNetwork dataManageCount:request];
        _evaluateLabel.text = [NSString stringWithFormat:@"    好评度:%@",[countArray objectAtIndex:0]];
        [_MysegControl setTitle:[NSString stringWithFormat:@"全部(%@)",[countArray objectAtIndex:1]] forSegmentAtIndex:0];
        [_MysegControl setTitle:[NSString stringWithFormat:@"好评(%@)",[countArray objectAtIndex:2]] forSegmentAtIndex:1];
        [_MysegControl setTitle:[NSString stringWithFormat:@"中评(%@)",[countArray objectAtIndex:3]] forSegmentAtIndex:2];
        [_MysegControl setTitle:[NSString stringWithFormat:@"差评(%@)",[countArray objectAtIndex:4]] forSegmentAtIndex:3];
        
        if (dataArrShangla.count!=0) {
            [dataArrShangla removeAllObjects];
        }
        dataArrShangla = [consultViewNetwork dataManage:request];
        requestBool = YES;
        [dataArray addObjectsFromArray:dataArrShangla];
        [MyTableView reloadData];
        [SYObject endLoading];
        
    }
    else{
         [SYObject endLoading];
        [SYObject failedPrompt:@"请求出错"];
        _MysegControl.enabled = YES;
    
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [MyTableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [MyTableView footerEndRefreshing];
    });
}
-(void)my3_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
    _MysegControl.enabled = YES;
}

#pragma mark - 点击事件
- (IBAction)segControlAction:(id)sender {
    _MysegControl.enabled = NO;
    SecondViewController *sec = [SecondViewController sharedUserDefault];
    UISegmentedControl *segmentControl = (UISegmentedControl *)sender;
    btnClickedBool = YES;
    if (segmentControl.selectedSegmentIndex == 0) {
        selectBtnTag = 1;
        [SYObject startLoading];
        NSArray *keyArr = [[NSArray alloc]initWithObjects:@"id",@"beginCount",@"selectCount", nil];
        NSArray *valueArr = [[NSArray alloc]initWithObjects:sec.detail_id,@"0",@"20", nil];
        request_1 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,ASSESS_URL] setKey:keyArr setValue:valueArr];
        request_1.delegate =self;
        [request_1 setDidFailSelector:@selector(my1_urlRequestFailed:)];
        [request_1 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
        [request_1 startAsynchronous];
        
    }else if(segmentControl.selectedSegmentIndex == 1){
        
        selectBtnTag = 2;
        [SYObject startLoading];
        NSArray *keyArr = [[NSArray alloc]initWithObjects:@"id",@"beginCount",@"selectCount",@"type", nil];
        NSArray *valueArr = [[NSArray alloc]initWithObjects:sec.detail_id,@"0",@"20",@"1", nil];
        request_3 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,ASSESS_URL] setKey:keyArr setValue:valueArr];
        request_3.delegate =self;
        [request_3 setDidFailSelector:@selector(my2_urlRequestFailed:)];
        [request_3 setDidFinishSelector:@selector(my2_urlRequestSucceeded:)];
        [request_3 startAsynchronous];
        
    }else if(segmentControl.selectedSegmentIndex == 2){
        
        selectBtnTag = 3;
        [SYObject startLoading];
        NSArray *keyArr = [[NSArray alloc]initWithObjects:@"id",@"beginCount",@"selectCount",@"type", nil];
        NSArray *valueArr = [[NSArray alloc]initWithObjects:sec.detail_id,@"0",@"20",@"0", nil];
        request_4 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,ASSESS_URL] setKey:keyArr setValue:valueArr];
        request_4.delegate =self;
        [request_4 setDidFailSelector:@selector(my2_urlRequestFailed:)];
        [request_4 setDidFinishSelector:@selector(my2_urlRequestSucceeded:)];
        [request_4 startAsynchronous];
        
    }else{
        
        selectBtnTag = 4;
         [SYObject startLoading];
        NSArray *keyArr = [[NSArray alloc]initWithObjects:@"id",@"beginCount",@"selectCount",@"type", nil];
        NSArray *valueArr = [[NSArray alloc]initWithObjects:sec.detail_id,@"0",@"20",@"-1", nil];
        request_5 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,ASSESS_URL] setKey:keyArr setValue:valueArr];
        request_5.delegate =self;
        [request_5 setDidFailSelector:@selector(my2_urlRequestFailed:)];
        [request_5 setDidFinishSelector:@selector(my2_urlRequestSucceeded:)];
        [request_5 startAsynchronous];
        
    }
}
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}

#pragma mark - 上拉刷新
-(void)footerRereshing{
    SecondViewController *sec = [SecondViewController sharedUserDefault];
     [SYObject startLoading];
    if (selectBtnTag == 1) {
        NSArray *keyArr = [[NSArray alloc]initWithObjects:@"id",@"beginCount",@"selectCount", nil];
        NSArray *valueArr = [[NSArray alloc]initWithObjects:sec.detail_id,[NSString stringWithFormat:@"%lu",(unsigned long)dataArray.count],@"20", nil];
        request_11 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,ASSESS_URL] setKey:keyArr setValue:valueArr];
        request_11.delegate =self;
        [request_11 setDidFailSelector:@selector(my3_urlRequestFailed:)];
        [request_11 setDidFinishSelector:@selector(my3_urlRequestSucceeded:)];
        [request_11 startAsynchronous];
    }else if(selectBtnTag == 2){
        NSArray *keyArr = [[NSArray alloc]initWithObjects:@"id",@"beginCount",@"selectCount",@"type", nil];
        NSArray *valueArr = [[NSArray alloc]initWithObjects:sec.detail_id,[NSString stringWithFormat:@"%lu",(unsigned long)dataArray.count],@"20",@"1", nil];
        request_12 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,ASSESS_URL] setKey:keyArr setValue:valueArr];
        request_12.delegate =self;
        [request_12 setDidFailSelector:@selector(my3_urlRequestFailed:)];
        [request_12 setDidFinishSelector:@selector(my3_urlRequestSucceeded:)];
        [request_12 startAsynchronous];
    }else if(selectBtnTag == 3){
        NSArray *keyArr = [[NSArray alloc]initWithObjects:@"id",@"beginCount",@"selectCount",@"type", nil];
        NSArray *valueArr = [[NSArray alloc]initWithObjects:sec.detail_id,[NSString stringWithFormat:@"%lu",(unsigned long)dataArray.count],@"20",@"0", nil];
        request_13 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,ASSESS_URL] setKey:keyArr setValue:valueArr];
        request_13.delegate =self;
        [request_13 setDidFailSelector:@selector(my3_urlRequestFailed:)];
        [request_13 setDidFinishSelector:@selector(my3_urlRequestSucceeded:)];
        [request_13 startAsynchronous];
    }else if(selectBtnTag == 4){
        NSArray *keyArr = [[NSArray alloc]initWithObjects:@"id",@"beginCount",@"selectCount",@"type", nil];
        NSArray *valueArr = [[NSArray alloc]initWithObjects:sec.detail_id,[NSString stringWithFormat:@"%lu",(unsigned long)dataArray.count],@"20",@"-1", nil];
        request_14 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,ASSESS_URL] setKey:keyArr setValue:valueArr];
        request_14.delegate =self;
        [request_14 setDidFailSelector:@selector(my3_urlRequestFailed:)];
        [request_14 setDidFinishSelector:@selector(my3_urlRequestSucceeded:)];
        [request_14 startAsynchronous];
    }
}



-(void)dealloc {
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    MyTableView = nil;
}

@end
