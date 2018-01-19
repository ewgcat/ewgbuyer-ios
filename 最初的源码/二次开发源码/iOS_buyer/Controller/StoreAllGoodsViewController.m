//
//  StoreAllGoodsViewController.m
//  My_App
//
//  Created by apple on 15/9/30.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "StoreAllGoodsViewController.h"
#import "SecondViewController.h"
#import "ASIFormDataRequest.h"
#import "DetailViewController.h"
#import "goodsListCell.h"
#import "ThirdViewController.h"
#import "storegoodsDetailViewController.h"
#import "MJRefresh.h"


@interface StoreAllGoodsViewController ()

@end

@implementation StoreAllGoodsViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    SecondViewController *sec = [SecondViewController sharedUserDefault];
    sec.storeAllgoodsBool = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createBackBtn];
    btnClickedBool = NO;
    // Do any additional setup after loading the view from its nib.、
    self.title = @"全部商品";
   
    dataArrayShangla =[[NSMutableArray alloc]init];
    dataArray =[[NSMutableArray alloc]init];
    select_attribute = @"sales_asc";
    priceBool = NO;
    timeBool = NO;
    renBool = NO;
    salesBool = YES;
    requestBool = NO;
    shanglaBool = YES;
    _redPopularity.hidden = YES;
    _redPrice.hidden = YES;
    _redTime.hidden = YES;
    
    [grayView.layer setMasksToBounds:YES];
    [grayView.layer setCornerRadius:4];
    [SYObject startLoading];
    nothingView.hidden = YES;
    
    dataArray = [[NSMutableArray alloc]init];
    
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MyTableView.delegate = self;
    MyTableView.dataSource=  self;
    MyTableView.showsVerticalScrollIndicator=NO;
    MyTableView.showsHorizontalScrollIndicator = NO;
    
    [MyTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backBtnClicked)];
    rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
    [MyTableView addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];
    
    laP=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width/4, 44)];
    laP.text=@"价格";
    laP.textAlignment=NSTextAlignmentCenter;
    laP.textColor=[UIColor darkGrayColor];
    [topView addSubview:laP];
    la2S=[[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width/4, 0, ScreenFrame.size.width/4, 44)];
    la2S.text=@"销量";
    la2S.textAlignment=NSTextAlignmentCenter;
    la2S.textColor=[UIColor darkGrayColor];
    [topView addSubview:la2S];
    la3R=[[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width/4*2, 0, ScreenFrame.size.width/4, 44)];
    la3R.text=@"人气";
    la3R.textAlignment=NSTextAlignmentCenter;
    la3R.textColor=[UIColor darkGrayColor];
    [topView addSubview:la3R];
    la4N=[[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width/4*3, 0, ScreenFrame.size.width/4, 44)];
    la4N.text=@"新品";
    la4N.textAlignment=NSTextAlignmentCenter;
    la4N.textColor=[UIColor darkGrayColor];
    [topView addSubview:la4N];
    
    imageKuang = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width/4+2, 4, ScreenFrame.size.width/4-4, 36)];
    imageKuang.layer.borderWidth = 1;
    imageKuang.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    CALayer *lay2  = imageKuang.layer;
    [lay2 setMasksToBounds:YES];
    [lay2 setCornerRadius:4.0];
    [topView addSubview:imageKuang];
    
    _timeBtn = [UIButton buttonWithType:UIButtonTypeCustom ];
    _timeBtn.frame =CGRectMake(0, 0, ScreenFrame.size.width/4, 44);
    _timeBtn.tag = 101;
    [_timeBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _timeBtn.titleLabel.font  = [UIFont systemFontOfSize:14];
    [topView addSubview:_timeBtn];
    _priceBtn = [UIButton buttonWithType:UIButtonTypeCustom ];
    _priceBtn.frame =CGRectMake(ScreenFrame.size.width/4, 0, ScreenFrame.size.width/4, 44);
    _priceBtn.tag = 102;
    [_priceBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _priceBtn.titleLabel.font  = [UIFont systemFontOfSize:14];
    [topView addSubview:_priceBtn];
    
    
    
    _sales = [UIButton buttonWithType:UIButtonTypeCustom ];
    _sales.frame =CGRectMake(ScreenFrame.size.width/4*2, 0, ScreenFrame.size.width/4, 44);
    _sales.tag = 103;
    [_sales addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _sales.titleLabel.font  = [UIFont systemFontOfSize:14];
    [topView addSubview:_sales];
    _popularityBtn = [UIButton buttonWithType:UIButtonTypeCustom ];
    _popularityBtn.frame =CGRectMake(ScreenFrame.size.width/4*3, 0, ScreenFrame.size.width/4, 44);
    _popularityBtn.tag = 104;
    [_popularityBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _popularityBtn.titleLabel.font  = [UIFont systemFontOfSize:14];
    [topView addSubview:_popularityBtn];
    
    [self netWork];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    dataArray = nil;
    dataArrayShangla = nil;

    dataArray = nil;
    MyTableView = nil;
    _redPopularity = nil;
    _redPrice = nil;
    _redSales = nil;
    _redTime = nil;
    _timeBtn = nil;
    _priceBtn = nil;
    _sales = nil;
    _popularityBtn = nil;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - 下拉刷新
-(void)footerRereshing{
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    NSURL *url4 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,STORE_LIST_URL]];
    ASIFormDataRequest *request4=[ASIFormDataRequest requestWithURL:url4];
    [request4 setPostValue:th.store_id forKey:@"store_id"];
    [request4 setPostValue:[NSString stringWithFormat:@"%lu",(unsigned long)dataArray.count] forKey:@"beginCount"];
    [request4 setPostValue:@"20" forKey:@"selectCount"];
    
    if ([select_attribute isEqualToString:@"price_asc"]) {
        [request4 setPostValue:@"asc" forKey:@"orderType"];
        [request4 setPostValue:@"goods_current_price" forKey:@"orderBy"];
    }else if ([select_attribute isEqualToString:@"price_desc"]){
        [request4 setPostValue:@"desc" forKey:@"orderType"];
        [request4 setPostValue:@"goods_current_price" forKey:@"orderBy"];
    }else if ([select_attribute isEqualToString:@"sales"]){
        [request4 setPostValue:@"asc" forKey:@"orderType"];
        [request4 setPostValue:@"goods_salenum" forKey:@"orderBy"];
    }else if ([select_attribute isEqualToString:@"ren"]){
        [request4 setPostValue:@"asc" forKey:@"orderType"];
        [request4 setPostValue:@"goods_click" forKey:@"orderBy"];
    }else{
        [request4 setPostValue:@"goods_seller_time" forKey:@"orderBy"];
        [request4 setPostValue:@"asc" forKey:@"orderType"];
    }
    NSArray *arrObjc;
    if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
        arrObjc = [[NSArray alloc]initWithObjects:@"", nil];
    }else{
        arrObjc = [[NSArray alloc]initWithObjects:[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:4], nil];
    }
    NSArray *arrKey = [[NSArray alloc]initWithObjects:VERIFY, nil];
    NSMutableDictionary *dicMy = [[NSMutableDictionary alloc]initWithObjects:arrObjc forKeys:arrKey];
    [request4 setRequestHeaders:dicMy];
    request4.tag = 101;
    request4.delegate =self;
    [request4 setDidFailSelector:@selector(urlRequestFailed:)];
    [request4 setDidFinishSelector:@selector(rm20_urlRequestSucceeded:)];
    [request4 startAsynchronous];
}

#pragma mark - tabelView方法
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
        return 100;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    goodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsListCell"];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"goodsListCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        for (UIView *subView in cell.contentView.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    if (dataArray.count!=0) {
        
        UIImageView *imaLine = [[UIImageView alloc]initWithFrame:CGRectMake(10, 99.5, ScreenFrame.size.width-20, 0.5)];
        imaLine.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:imaLine];
        
        ClassifyModel *classify = [dataArray objectAtIndex:indexPath.row];
        cell.name.text = classify.goods_name;
        cell.price.text = [NSString stringWithFormat:@"￥%@",classify.goods_current_price];
        cell.count.text = classify.goods_evaluate;
        cell.status.text = classify.goods_evaluate;
        [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:classify.goods_main_photo] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
        cell.photoImage.layer.borderWidth = 0.5;
        cell.photoImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        
        
        if (classify.goods_status.length == 0) {
            cell.status.backgroundColor = [UIColor whiteColor];
        }else{
            cell.status.backgroundColor = [UIColor redColor];
            cell.status.text = classify.goods_status;
        }
        
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == MyTableView) {
        if (dataArray.count!=0) {
            SecondViewController *sec = [SecondViewController sharedUserDefault];
            ClassifyModel *classify = [dataArray objectAtIndex:indexPath.row];
            sec.detail_id = classify.goods_id;
            storegoodsDetailViewController *detail = [[storegoodsDetailViewController alloc]init];
            [self.navigationController pushViewController:detail animated:YES];
        }
    }
}
#pragma mark - 点击事件
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}

-(void)backBtnClicked{
    priceBool = NO;
    timeBool = NO;
    renBool = NO;
    salesBool = YES;
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)dealloc {
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    dataArrayShangla = nil;
    MyTableView = nil;
    topView = nil;
    select_attribute = nil;
    loadingV = nil;
    _redPrice = nil;
    _redSales = nil;
    _redPopularity = nil;
    _redTime = nil;
    _timeBtn = nil;
    _priceBtn = nil;
    _sales = nil;
    _popularityBtn = nil;
}
- (IBAction)btnClicked:(id)sender {
    btnClickedBool = YES;
//    SecondViewController *sec = [SecondViewController sharedUserDefault];
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 101) {
//        loadingV.hidden = NO;
        [SYObject startLoading];
        [MyTableView setContentOffset:CGPointMake(0,0) animated:YES];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        CGRect frame = imageKuang.frame;
        if (btn.frame.origin.x<frame.origin.x) {//则是在左侧
            frame.origin.x -= frame.origin.x-btn.frame.origin.x-2;
        }else if (btn.frame.origin.x>frame.origin.x){//则在右侧
            frame.origin.x += btn.frame.origin.x-frame.origin.x;
        }
        [imageKuang setFrame:frame];
        [UIView commitAnimations];
        
        _redPopularity.hidden = YES;
        _redPrice.hidden = NO;
        _redTime.hidden = YES;
        _redSales.hidden = YES;
        
        if (priceBool == NO) {
            select_attribute = @"price_asc";
            laP.text =@"↑价格";
            
            ThirdViewController *th = [ThirdViewController sharedUserDefault];
            NSURL *url4 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,STORE_LIST_URL]];
            ASIFormDataRequest *request4=[ASIFormDataRequest requestWithURL:url4];
            [request4 setPostValue:th.store_id forKey:@"store_id"];
            [request4 setPostValue:@"goods_current_price" forKey:@"orderBy"];
            [request4 setPostValue:@"0" forKey:@"beginCount"];
            [request4 setPostValue:@"20" forKey:@"selectCount"];
            [request4 setPostValue:@"asc" forKey:@"orderType"];
            NSArray *arrObjc;
            if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
                arrObjc = [[NSArray alloc]initWithObjects:@"", nil];
            }else{
                arrObjc = [[NSArray alloc]initWithObjects:[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:4], nil];
            }
            NSArray *arrKey = [[NSArray alloc]initWithObjects:VERIFY, nil];
            NSMutableDictionary *dicMy = [[NSMutableDictionary alloc]initWithObjects:arrObjc forKeys:arrKey];
            [request4 setRequestHeaders:dicMy];
            request4.tag = 101;
            request4.delegate =self;
            [request4 setDidFailSelector:@selector(urlRequestFailed:)];
            [request4 setDidFinishSelector:@selector(all2_urlRequestSucceeded:)];
            [request4 startAsynchronous];
            
            priceBool = YES;
        }else{
            laP.text =@"↓价格";
            select_attribute = @"price_desc";
            
            ThirdViewController *th = [ThirdViewController sharedUserDefault];
            NSURL *url4 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,STORE_LIST_URL]];
            ASIFormDataRequest *request4=[ASIFormDataRequest requestWithURL:url4];
            [request4 setPostValue:th.store_id forKey:@"store_id"];
            [request4 setPostValue:@"goods_current_price" forKey:@"orderBy"];
            [request4 setPostValue:@"0" forKey:@"beginCount"];
            [request4 setPostValue:@"20" forKey:@"selectCount"];
            [request4 setPostValue:@"desc" forKey:@"orderType"];
            NSArray *arrObjc;
            if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
                arrObjc = [[NSArray alloc]initWithObjects:@"", nil];
            }else{
                arrObjc = [[NSArray alloc]initWithObjects:[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:4], nil];
            }
            NSArray *arrKey = [[NSArray alloc]initWithObjects:VERIFY, nil];
            NSMutableDictionary *dicMy = [[NSMutableDictionary alloc]initWithObjects:arrObjc forKeys:arrKey];
            [request4 setRequestHeaders:dicMy];
            request4.tag = 101;
            request4.delegate =self;
            [request4 setDidFailSelector:@selector(urlRequestFailed:)];
            [request4 setDidFinishSelector:@selector(all4_urlRequestSucceeded:)];
            [request4 startAsynchronous];
            
            priceBool = NO;
        }
    }
    if (btn.tag == 102) {
//        loadingV.hidden = NO;
        [SYObject startLoading];
        [MyTableView setContentOffset:CGPointMake(0,0) animated:YES];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        CGRect frame = imageKuang.frame;
        if (btn.frame.origin.x<frame.origin.x) {//则是在左侧
            frame.origin.x -= frame.origin.x-btn.frame.origin.x;
        }else if (btn.frame.origin.x>frame.origin.x){//则在右侧
            frame.origin.x += btn.frame.origin.x-frame.origin.x;
        }
        [imageKuang setFrame:frame];
        [UIView commitAnimations];
        
        _redPopularity.hidden = YES;
        _redPrice.hidden = YES;
        _redTime.hidden = YES;
        _redSales.hidden = NO;
        
        la2S.text =@"销量";
        select_attribute = @"sales";
        
        ThirdViewController *th = [ThirdViewController sharedUserDefault];
        NSURL *url4 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,STORE_LIST_URL]];
        ASIFormDataRequest *request4=[ASIFormDataRequest requestWithURL:url4];
        [request4 setPostValue:th.store_id forKey:@"store_id"];
        [request4 setPostValue:@"goods_salenum" forKey:@"orderBy"];
        [request4 setPostValue:@"0" forKey:@"beginCount"];
        NSArray *arrObjc;
        if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
            arrObjc = [[NSArray alloc]initWithObjects:@"", nil];
        }else{
            arrObjc = [[NSArray alloc]initWithObjects:[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:4], nil];
        }
        NSArray *arrKey = [[NSArray alloc]initWithObjects:VERIFY, nil];
        NSMutableDictionary *dicMy = [[NSMutableDictionary alloc]initWithObjects:arrObjc forKeys:arrKey];
        [request4 setRequestHeaders:dicMy];
        request4.tag = 101;
        request4.delegate =self;
        [request4 setDidFailSelector:@selector(urlRequestFailed:)];
        [request4 setDidFinishSelector:@selector(all7_urlRequestSucceeded:)];
        [request4 startAsynchronous];
    }
    if (btn.tag == 103) {
//        loadingV.hidden = NO;
        [SYObject startLoading];
        [MyTableView setContentOffset:CGPointMake(0,0) animated:YES];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        CGRect frame = imageKuang.frame;
        if (btn.frame.origin.x<frame.origin.x) {//则是在左侧
            frame.origin.x -= frame.origin.x-btn.frame.origin.x;
        }else if (btn.frame.origin.x>frame.origin.x){//则在右侧
            frame.origin.x += btn.frame.origin.x-frame.origin.x;
        }
        [imageKuang setFrame:frame];
        [UIView commitAnimations];
        
        _redPopularity.hidden = NO;
        _redPrice.hidden = YES;
        _redTime.hidden = YES;
        _redSales.hidden = YES;
        
        select_attribute = @"ren";
        
        ThirdViewController *th = [ThirdViewController sharedUserDefault];
        NSURL *url4 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,STORE_LIST_URL]];
        ASIFormDataRequest *request4=[ASIFormDataRequest requestWithURL:url4];
        [request4 setPostValue:th.store_id forKey:@"store_id"];
        [request4 setPostValue:@"goods_click" forKey:@"orderBy"];
        [request4 setPostValue:@"0" forKey:@"beginCount"];
        [request4 setPostValue:@"20" forKey:@"selectCount"];
        NSArray *arrObjc;
        if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
            arrObjc = [[NSArray alloc]initWithObjects:@"", nil];
        }else{
            arrObjc = [[NSArray alloc]initWithObjects:[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:4], nil];
        }
        NSArray *arrKey = [[NSArray alloc]initWithObjects:VERIFY, nil];
        NSMutableDictionary *dicMy = [[NSMutableDictionary alloc]initWithObjects:arrObjc forKeys:arrKey];
        [request4 setRequestHeaders:dicMy];
        request4.tag = 101;
        request4.delegate =self;
        [request4 setDidFailSelector:@selector(urlRequestFailed:)];
        [request4 setDidFinishSelector:@selector(jp9_urlRequestSucceeded:)];
        [request4 startAsynchronous];
    }
    if (btn.tag == 104) {
//        loadingV.hidden = NO;
        [SYObject startLoading];
        [MyTableView setContentOffset:CGPointMake(0,0) animated:YES];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        CGRect frame = imageKuang.frame;
        if (btn.frame.origin.x<frame.origin.x) {//则是在左侧
            frame.origin.x -= frame.origin.x-btn.frame.origin.x;
        }else if (btn.frame.origin.x>frame.origin.x){//则在右侧
            frame.origin.x += btn.frame.origin.x-frame.origin.x;
        }
        [imageKuang setFrame:frame];
        [UIView commitAnimations];
        
        _redPopularity.hidden = YES;
        _redPrice.hidden = YES;
        _redTime.hidden = NO;
        _redSales.hidden = YES;
        
        la4N.text =@"新品";
        select_attribute = @"time";
        
        ThirdViewController *th = [ThirdViewController sharedUserDefault];
        NSURL *url4 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,STORE_LIST_URL]];
        ASIFormDataRequest *request4=[ASIFormDataRequest requestWithURL:url4];
        [request4 setPostValue:th.store_id forKey:@"store_id"];
        [request4 setPostValue:@"goods_seller_time" forKey:@"orderBy"];
        [request4 setPostValue:@"0" forKey:@"beginCount"];
        [request4 setPostValue:@"20" forKey:@"selectCount"];
        NSArray *arrObjc;
        if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
            arrObjc = [[NSArray alloc]initWithObjects:@"", nil];
        }else{
            arrObjc = [[NSArray alloc]initWithObjects:[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:4], nil];
        }
        NSArray *arrKey = [[NSArray alloc]initWithObjects:VERIFY, nil];
        NSMutableDictionary *dicMy = [[NSMutableDictionary alloc]initWithObjects:arrObjc forKeys:arrKey];
        [request4 setRequestHeaders:dicMy];
        request4.tag = 101;
        request4.delegate =self;
        [request4 setDidFailSelector:@selector(urlRequestFailed:)];
        [request4 setDidFinishSelector:@selector(rm11_urlRequestSucceeded:)];
        [request4 startAsynchronous];
    }
}
#pragma mark - 网络
-(void)rm20_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"5dicBig:%@",dicBig);
        if (dataArrayShangla.count!=0) {
            [dataArrayShangla removeAllObjects];
        }
        shanglaBool = NO;
        NSArray *array = [dicBig objectForKey:@"goods_list"];
        for(NSDictionary *dic in array){
            ClassifyModel *classify = [[ClassifyModel alloc]init];
            classify.goods_salenum = [dic objectForKey:@"goods_salenum"];
            classify.goods_name = [dic objectForKey:@"goods_name"];
            classify.goods_main_photo = [dic objectForKey:@"goods_main_photo"];
            classify.goods_id = [dic objectForKey:@"id"];
            classify.goods_current_price = [dic objectForKey:@"goods_current_price"];
            classify.goods_status = [dic objectForKey:@"status"];
            [dataArrayShangla addObject:classify];
        }
        requestBool = YES;
        [dataArray addObjectsFromArray:dataArrayShangla];
        [MyTableView reloadData];
//        loadingV.hidden = YES;
        [SYObject endLoading];
        nothingView.hidden = YES;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格
            [MyTableView reloadData];
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [MyTableView footerEndRefreshing];
        });
    }
    
}
-(void)netWork{
    
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    NSURL *url4 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,STORE_LIST_URL]];
    ASIFormDataRequest *request4=[ASIFormDataRequest requestWithURL:url4];
    [request4 setPostValue:th.store_id forKey:@"store_id"];
    [request4 setPostValue:@"goods_salenum" forKey:@"orderBy"];
    [request4 setPostValue:@"0" forKey:@"beginCount"];
    [request4 setPostValue:@"20" forKey:@"selectCount"];
    [request4 setPostValue:@"asc" forKey:@"orderType"];
    NSArray *arrObjc;
    if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
        arrObjc = [[NSArray alloc]initWithObjects:@"", nil];
    }else{
        arrObjc = [[NSArray alloc]initWithObjects:[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:4], nil];
    }
    NSArray *arrKey = [[NSArray alloc]initWithObjects:VERIFY, nil];
    NSMutableDictionary *dicMy = [[NSMutableDictionary alloc]initWithObjects:arrObjc forKeys:arrKey];
    [request4 setRequestHeaders:dicMy];
    request4.tag = 101;
    request4.delegate =self;
    [request4 setDidFailSelector:@selector(urlRequestFailed:)];
    [request4 setDidFinishSelector:@selector(all_urlRequestSucceeded:)];
    [request4 startAsynchronous];
    
}



-(void)rm11_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"14dicBig:%@",dicBig);
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        NSArray *array = [dicBig objectForKey:@"goods_list"];
        for(NSDictionary *dic in array){
            ClassifyModel *classify = [[ClassifyModel alloc]init];
            classify.goods_salenum = [dic objectForKey:@"goods_salenum"];
            classify.goods_name = [dic objectForKey:@"goods_name"];
            classify.goods_main_photo = [dic objectForKey:@"goods_main_photo"];
            classify.goods_id = [dic objectForKey:@"id"];
            classify.goods_current_price = [dic objectForKey:@"goods_current_price"];
            classify.goods_status = [dic objectForKey:@"status"];
            classify.goods_evaluate = [dic objectForKey:@"evaluate"];
            [dataArray addObject:classify];
        }
        if (dataArray.count == 0) {
            MyTableView.hidden = YES;
            nothingView.hidden = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
        }
        [MyTableView reloadData];
    }
//    loadingV.hidden = YES;
    [SYObject endLoading];
}

-(void)jp9_urlRequestSucceeded:(ASIHTTPRequest *)request{
    
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"22dicBig:%@",dicBig);
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        NSArray *array = [dicBig objectForKey:@"goods_list"];
        for(NSDictionary *dic in array){
            ClassifyModel *classify = [[ClassifyModel alloc]init];
            classify.goods_salenum = [dic objectForKey:@"goods_salenum"];
            classify.goods_name = [dic objectForKey:@"goods_name"];
            classify.goods_main_photo = [dic objectForKey:@"goods_main_photo"];
            classify.goods_id = [dic objectForKey:@"id"];
            classify.goods_current_price = [dic objectForKey:@"goods_current_price"];
            classify.goods_status = [dic objectForKey:@"status"];
            classify.goods_evaluate = [dic objectForKey:@"evaluate"];
            [dataArray addObject:classify];
        }
        if (dataArray.count == 0) {
            MyTableView.hidden = YES;
            nothingView.hidden = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
        }
        [MyTableView reloadData];
    }
//    loadingV.hidden = YES;
    [SYObject endLoading];
}

-(void)all7_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"30dicBig:%@",dicBig);
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        NSArray *array = [dicBig objectForKey:@"goods_list"];
        for(NSDictionary *dic in array){
            ClassifyModel *classify = [[ClassifyModel alloc]init];
            classify.goods_salenum = [dic objectForKey:@"goods_salenum"];
            classify.goods_name = [dic objectForKey:@"goods_name"];
            classify.goods_main_photo = [dic objectForKey:@"goods_main_photo"];
            classify.goods_id = [dic objectForKey:@"id"];
            classify.goods_current_price = [dic objectForKey:@"goods_current_price"];
            classify.goods_status = [dic objectForKey:@"status"];
            classify.goods_evaluate = [dic objectForKey:@"evaluate"];
            [dataArray addObject:classify];
        }
        if (dataArray.count == 0) {
            MyTableView.hidden = YES;
        }else{
            MyTableView.hidden = NO;
        }
        [MyTableView reloadData];
    }
//    loadingV.hidden = YES;
    [SYObject endLoading];
    nothingView.hidden = YES;
}

-(void)all4_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"34dicBig:%@",dicBig);
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        NSArray *array = [dicBig objectForKey:@"goods_list"];
        for(NSDictionary *dic in array){
            ClassifyModel *classify = [[ClassifyModel alloc]init];
            classify.goods_salenum = [dic objectForKey:@"goods_salenum"];
            classify.goods_name = [dic objectForKey:@"goods_name"];
            classify.goods_main_photo = [dic objectForKey:@"goods_main_photo"];
            classify.goods_id = [dic objectForKey:@"id"];
            classify.goods_current_price = [dic objectForKey:@"goods_current_price"];
            classify.goods_status = [dic objectForKey:@"status"];
            classify.goods_evaluate = [dic objectForKey:@"evaluate"];
            [dataArray addObject:classify];
        }
        if (dataArray.count == 0) {
            MyTableView.hidden = YES;
        }else{
            MyTableView.hidden = NO;
        }
        [MyTableView reloadData];
    }
//    loadingV.hidden = YES;
    [SYObject endLoading];
    nothingView.hidden = YES;
}

-(void)all2_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"38dicBig:%@",dicBig);
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        NSArray *array = [dicBig objectForKey:@"goods_list"];
        for(NSDictionary *dic in array){
            ClassifyModel *classify = [[ClassifyModel alloc]init];
            classify.goods_salenum = [dic objectForKey:@"goods_salenum"];
            classify.goods_name = [dic objectForKey:@"goods_name"];
            classify.goods_main_photo = [dic objectForKey:@"goods_main_photo"];
            classify.goods_id = [dic objectForKey:@"id"];
            classify.goods_current_price = [dic objectForKey:@"goods_current_price"];
            classify.goods_status = [dic objectForKey:@"status"];
            classify.goods_evaluate = [dic objectForKey:@"evaluate"];
            [dataArray addObject:classify];
        }
        if (dataArray.count == 0) {
            MyTableView.hidden = YES;
        }else{
            MyTableView.hidden = NO;
        }
        [MyTableView reloadData];
    }
//    loadingV.hidden = YES;
    [SYObject endLoading];
    nothingView.hidden = YES;
}

-(void)all_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"42dicBig:%@",dicBig);
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        NSArray *array = [dicBig objectForKey:@"goods_list"];
        for(NSDictionary *dic in array){
            ClassifyModel *classify = [[ClassifyModel alloc]init];
            classify.goods_salenum = [dic objectForKey:@"goods_salenum"];
            classify.goods_name = [dic objectForKey:@"goods_name"];
            classify.goods_main_photo = [dic objectForKey:@"goods_main_photo"];
            classify.goods_id = [dic objectForKey:@"id"];
            classify.goods_current_price = [dic objectForKey:@"goods_current_price"];
            classify.goods_status = [dic objectForKey:@"status"];
            classify.goods_evaluate = [dic objectForKey:@"evaluate"];
            [dataArray addObject:classify];
        }
        if (dataArray.count == 0) {
            MyTableView.hidden = YES;
        }else{
            MyTableView.hidden = NO;
        }
        [MyTableView reloadData];
    }
//    loadingV.hidden = YES;
    [SYObject endLoading];
    nothingView.hidden = YES;
}

-(void)urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"44dicBig:%@",dicBig);
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        NSArray *array = [dicBig objectForKey:@"goods_list"];
        for(NSDictionary *dic in array){
            ClassifyModel *classify = [[ClassifyModel alloc]init];
            classify.goods_salenum = [dic objectForKey:@"goods_salenum"];
            classify.goods_name = [dic objectForKey:@"goods_name"];
            classify.goods_main_photo = [dic objectForKey:@"goods_main_photo"];
            classify.goods_id = [dic objectForKey:@"id"];
            classify.goods_current_price = [dic objectForKey:@"goods_current_price"];
            classify.goods_status = [dic objectForKey:@"status"];
            classify.goods_evaluate = [dic objectForKey:@"evaluate"];
            [dataArray addObject:classify];
        }
        if (dataArray.count == 0) {
            MyTableView.hidden = YES;
            nothingView.hidden = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
        }
        [MyTableView reloadData];
    }
//    loadingV.hidden = YES;
    [SYObject endLoading];
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden = NO;
//    loadingV.hidden = YES;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
//    labelTi.hidden = NO;
//    labelTi.text = @"网络请求失败";
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
}

@end
