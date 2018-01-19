//
//  UsecouponsViewController.m
//  My_App
//
//  Created by apple on 14-8-19.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "UsecouponsViewController.h"
#import "CouponsCell.h"
#import "ASIFormDataRequest.h"
#import "ThirdViewController.h"
#import "CoupCell.h"

@interface UsecouponsViewController (){
    ASIFormDataRequest *request103;
}

@end



@implementation UsecouponsViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request103 clearDelegatesAndCancel];
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillAppear:YES];
    [self network];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataArray = [[NSMutableArray alloc]init];
    
    [self createBackBtn];
    
    [SYObject startLoading];
    nothingView.hidden = YES;
    
    self.title = @"优惠劵";
    
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    
    if (ScreenFrame.size.height>480) {//说明是5 5s
        myTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, ScreenFrame.origin.y, ScreenFrame.size.width, ScreenFrame.size.height-64) style:UITableViewStylePlain];
        
    }else{
        myTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, ScreenFrame.origin.y , ScreenFrame.size.width, ScreenFrame.size.height-64) style:UITableViewStylePlain];
    }
    myTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableview.delegate =self;
    myTableview.dataSource= self;
    myTableview.showsVerticalScrollIndicator=NO;
    myTableview.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:myTableview];
    myTableview.backgroundColor = BACKGROUNDCOLOR;
    UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backBtnClicked)];
    rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
    [myTableview addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];
}
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    
    myTableview = nil;
    dataArray = nil;
    labelTi = nil;
    _useCouponsID = nil;
    _useCouponsprice = nil;
    
}
-(void)dealloc {
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    myTableview = nil;
    labelTi = nil;
 
    _useCouponsID = nil;
    _useCouponsprice = nil;
}
#pragma mark - 网络
-(void)network{
    [SYObject startLoading];
    ThirdViewController *third = [ThirdViewController sharedUserDefault];
    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,COUPONLIST_URL]];
    request103=[ASIFormDataRequest requestWithURL:url3];
    
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    [request103 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request103 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    
    [request103 setPostValue:third.jie_store_ids forKey:@"store_ids"];
    [request103 setPostValue:third.jie_order_goods_price forKey:@"order_goods_price"];
    
    [request103 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request103.tag = 103;
    request103.delegate = self;
    [request103 setDidFailSelector:@selector(urlRequestFailed:)];
    [request103 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [request103 startAsynchronous];
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig=%@",dicBig);
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        NSArray *arr = [dicBig objectForKey:@"coupon_list"];
        for(NSDictionary *dic in arr){
            ClassifyModel *clas = [[ClassifyModel alloc]init];
            clas.coupon_amount = [dic objectForKey:@"coupon_amount"];
            clas.coupon_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"coupon_id"]];
            clas.coupon_info = [dic objectForKey:@"coupon_info"];
            clas.coupon_name = [dic objectForKey:@"coupon_name"];
            clas.coupon_store_name = [dic objectForKey:@"store_name"];
            clas.coupon_beginTime = [dic objectForKey:@"coupon_beginTime"];
            clas.coupon_endTime = [dic objectForKey:@"coupon_endTime"];
            [dataArray addObject:clas];
        }
    }
    if (dataArray.count == 0) {
        myTableview.hidden = YES;
        nothingView.hidden = NO;
    }else{
        myTableview.hidden = NO;
        nothingView.hidden = YES;
    }
    [myTableview reloadData];
    [SYObject endLoading];
    
    
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}

#pragma mark - tableView delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *shjTabelviewCell = @"CoupCell";
    CoupCell *cell = [tableView dequeueReusableCellWithIdentifier:shjTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CoupCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (dataArray.count !=0) {
        ClassifyModel *cla = [dataArray objectAtIndex:indexPath.row];
        cell.condition.text = [NSString stringWithFormat:@" %@",cla.coupon_name];
        cell.price.text = [NSString stringWithFormat:@"%@",cla.coupon_info];
        cell.sign.text = [NSString stringWithFormat:@"%@",cla.coupon_store_name];
        cell.date.text = [NSString stringWithFormat:@"%@ 至 %@",cla.coupon_beginTime,cla.coupon_endTime];
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
    
    return 150;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //应该返回下单页面
    ClassifyModel *cla = [dataArray objectAtIndex:indexPath.row];
    
    ThirdViewController *third = [ThirdViewController sharedUserDefault];
    third.usecouponsMoney = [NSString stringWithFormat:@"%@" ,cla.coupon_amount];
    third.usecouponsID = [NSString stringWithFormat:@"%@" ,cla.coupon_id];
    third.usecoupons_id = [NSString stringWithFormat:@"%@" ,cla.coupon_id];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 点击事件
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
