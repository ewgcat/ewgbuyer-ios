//
//  BrandGoodListViewController.m
//  My_App
//
//  Created by apple on 15/6/29.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BrandGoodListViewController.h"
#import "SecondViewController.h"
#import "ASIFormDataRequest.h"
#import "DetailViewController.h"
#import "goodsListCell.h"
#import "ThirdViewController.h"
#import "storegoodsDetailViewController.h"
#import "FirstViewController.h"
#import "goodsList_Other_Cell.h"

@interface BrandGoodListViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BrandGoodListViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    SecondViewController *sec = [SecondViewController sharedUserDefault];
    sec.storeAllgoodsBool = NO;
}
//界面手势滑动
#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1){  //关闭主界面的右滑返回
        return NO;
    }else{
        
        return YES;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    [self createBackBtn];
    btnClickedBool = NO;
    select_attribute = @"sales_asc";
    // Do any additional setup after loading the view from its nib.、
    dataArrayShangla =[[NSMutableArray alloc]init];
    dataArray =[[NSMutableArray alloc]init];
    exchangeBool = NO;
    priceBool = NO;
    
    requestBool = NO;
    shanglaBool = YES;
    _redPopularity.hidden = YES;
    _redPrice.hidden = YES;
    _redTime.hidden = YES;
    
    [SYObject startLoading];
    nothingView.hidden = YES;
    nothingLabel.hidden  = YES;
    
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
    MyTableView.backgroundColor = BACKGROUNDCOLOR;
    [MyTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    
    SecondViewController *sec = [SecondViewController sharedUserDefault];
    self.title = sec.sub_title2;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,CLASSIFY_SUB2_URL]];
    ASIFormDataRequest *request101=[ASIFormDataRequest requestWithURL:url];
    [request101 setPostValue:sec.sub_id2 forKey:@"gb_id"];
    [request101 setPostValue:@"goods_salenum" forKey:@"orderBy"];
    [request101 setPostValue:@"0" forKey:@"beginCount"];
    [request101 setPostValue:@"20" forKey:@"selectCount"];
    [request101 setPostValue:@"asc" forKey:@"orderType"];
    
    [request101 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request101.tag = 101;
    request101.delegate =self;
    [request101 setDidFailSelector:@selector(store_urlRequestFailed:)];
    [request101 setDidFinishSelector:@selector(store_urlRequestSucceeded:)];
    [request101 startAsynchronous];
    muchBool = NO;
    muchView.hidden = YES;
    [muchGray.layer setMasksToBounds:YES];
    [muchGray.layer setCornerRadius:4];
    
    PriceBtn.tag = 101;
    [PriceBtn addTarget:self action:@selector(TopBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    SalesBtn.tag = 102;
    [SalesBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [SalesBtn addTarget:self action:@selector(TopBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    PopularityBtn.tag = 103;
    [PopularityBtn addTarget:self action:@selector(TopBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NewGoodsBtn.tag = 104;
    [NewGoodsBtn addTarget:self action:@selector(TopBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
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
    labelTi = nil;
    dataArray = nil;
    MyTableView = nil;
    _redPopularity = nil;
    _redPrice = nil;
    _redSales = nil;
    _redTime = nil;
    _timeBtn = nil;
//    _priceBtn = nil;
//    _sales = nil;
//    _popularityBtn = nil;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - tabelView方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == MyTableView) {
        if (dataArray.count!=0) {
            if (exchangeBool == NO){
                return dataArray.count;
            }else{
                if (dataArray.count%2==0) {
                    return dataArray.count/2;
                }else{
                    return dataArray.count/2+1;
                }
            }
        }
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == MyTableView) {
        if (exchangeBool == NO){
            return 130;
        }else{
            return (ScreenFrame.size.width/2-14)/146*210;
//            return 210;
        }
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (exchangeBool == NO) {
        goodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsListCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"goodsListCell" owner:self options:nil] lastObject];
        }
        if (dataArray.count!=0) {
            ClassifyModel *classify = [dataArray objectAtIndex:indexPath.row];
            [cell setData:classify];
        }
        return cell;
    }else{
        goodsList_Other_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsList_Other_Cell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"goodsList_Other_Cell" owner:self options:nil] lastObject];
        }
        if (dataArray.count!=0) {
            if (dataArray.count%2 == 0) {
                ClassifyModel *classify = [dataArray objectAtIndex:2*indexPath.row];
                ClassifyModel *classify2 = [dataArray objectAtIndex:2*indexPath.row + 1];
                [cell setData:classify rightModel:classify2 array:(int)dataArray.count];
                
                cell.leftBtn.tag = 100+2*indexPath.row;
                [cell.leftBtn addTarget:self action:@selector(otherBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.rightBtn.tag = 100+2*indexPath.row+1;
                [cell.rightBtn addTarget:self action:@selector(otherBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                ClassifyModel *classify = [dataArray objectAtIndex:2*indexPath.row];
                cell.leftName.text = classify.goods_name;
                cell.leftPrice.text = [NSString stringWithFormat:@"￥%@",classify.goods_current_price];
                cell.leftBtn.tag = 100+2*indexPath.row;
                [cell.leftImage sd_setImageWithURL:[NSURL URLWithString:classify.goods_main_photo] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
                [cell.leftBtn addTarget:self action:@selector(otherBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                if (2*indexPath.row+1==dataArray.count) {
                    cell.rightView.hidden = YES;
                }else{
                    ClassifyModel *classify2 = [dataArray objectAtIndex:2*indexPath.row + 1];
                    cell.rightName.text = classify2.goods_name;
                    cell.rightPrice.text = [NSString stringWithFormat:@"￥%@",classify2.goods_current_price];
                    cell.rightBtn.tag = 100+2*indexPath.row+1;
                    [cell.rightImage sd_setImageWithURL:[NSURL URLWithString:classify2.goods_main_photo] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
                    [cell.rightBtn addTarget:self action:@selector(otherBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == MyTableView) {
        if (exchangeBool == NO) {
            if (dataArray.count!=0) {
                SecondViewController *sec = [SecondViewController sharedUserDefault];
                ClassifyModel *classify = [dataArray objectAtIndex:indexPath.row];
                if (sec.storeAllgoodsBool == NO) {
                    sec.detail_id = classify.goods_id;
                    DetailViewController *detail = [[DetailViewController alloc]init];
                    [self.navigationController pushViewController:detail animated:YES];
                }else{
                    sec.detail_id = classify.goods_id;
                    storegoodsDetailViewController *detail = [[storegoodsDetailViewController alloc]init];
                    [self.navigationController pushViewController:detail animated:YES];
                }
            }
        }else{
        }
    }
}
#pragma mark - 点击事件
-(void)otherBtnClicked:(UIButton *)btn{
    if (dataArray.count!=0) {
        SecondViewController *sec = [SecondViewController sharedUserDefault];
        ClassifyModel *classify = [dataArray objectAtIndex:btn.tag-100];
        if (sec.storeAllgoodsBool == NO) {
            sec.detail_id = classify.goods_id;
            DetailViewController *detail = [[DetailViewController alloc]init];
            [self.navigationController pushViewController:detail animated:YES];
        }else{
            sec.detail_id = classify.goods_id;
            storegoodsDetailViewController *detail = [[storegoodsDetailViewController alloc]init];
            [self.navigationController pushViewController:detail animated:YES];
        }
    }
}
-(void)createBackBtn{
    UIButton *buttonC = [UIButton buttonWithType:UIButtonTypeCustom ];
    buttonC.frame =CGRectMake(0, 0, 30, 30);
    [buttonC setBackgroundImage:[UIImage imageNamed:@"liebiao_big_icon"] forState:UIControlStateNormal];
    [buttonC addTarget:self action:@selector(exchange) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar4 = [[UIBarButtonItem alloc]initWithCustomView:buttonC];
    self.navigationItem.rightBarButtonItem = bar4;
    
    //重写返回按钮
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}

-(void)exchange{
    if (exchangeBool == NO) {
        exchangeBool = YES;
        [MyTableView reloadData];
    }else{
        exchangeBool = NO;
        [MyTableView reloadData];
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
    priceBool = NO;
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)dealloc {
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    dataArrayShangla = nil;
    labelTi = nil;
    MyTableView = nil;
    select_attribute = nil;
    _redPrice = nil;
    _redSales = nil;
    _redPopularity = nil;
    _redTime = nil;
    _timeBtn = nil;
//    _priceBtn = nil;
//    _sales = nil;
//    _popularityBtn = nil;
}

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

#pragma mark - 上拉刷新
-(void)footerRereshing{
    SecondViewController *sec = [SecondViewController sharedUserDefault];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,CLASSIFY_SUB2_URL]];
    ASIFormDataRequest *request102=[ASIFormDataRequest requestWithURL:url];
    [request102 setPostValue:sec.sub_id2 forKey:@"gb_id"];
    [request102 setPostValue:[NSString stringWithFormat:@"%lu",(unsigned long)dataArray.count] forKey:@"beginCount"];
    [request102 setPostValue:@"20" forKey:@"selectCount"];
    [request102 setPostValue:@"goods_salenum" forKey:@"orderBy"];
    if ([select_attribute isEqualToString:@"sales_asc"]) {
        [request102 setPostValue:@"goods_salenum" forKey:@"orderBy"];
    }else if ([select_attribute isEqualToString:@"sales_desc"]) {
        [request102 setPostValue:@"goods_salenum" forKey:@"orderBy"];
    }
    else if ([select_attribute isEqualToString:@"ren_asc"]) {
        [request102 setPostValue:@"goods_click" forKey:@"orderBy"];
    }
    else if ([select_attribute isEqualToString:@"ren_desc"]) {
        [request102 setPostValue:@"goods_click" forKey:@"orderBy"];
    }
    else if ([select_attribute isEqualToString:@"time_asc"]) {
        [request102 setPostValue:@"goods_seller_time" forKey:@"orderBy"];
    }
    else if ([select_attribute isEqualToString:@"time_desc"]) {
        [request102 setPostValue:@"goods_seller_time" forKey:@"orderBy"];
    }
    else if ([select_attribute isEqualToString:@"price_asc"]) {
        [request102 setPostValue:@"goods_current_price" forKey:@"orderBy"];
        [request102 setPostValue:@"asc" forKey:@"orderType"];
    }
    else if ([select_attribute isEqualToString:@"price_desc"]) {
        [request102 setPostValue:@"goods_current_price" forKey:@"orderBy"];
        [request102 setPostValue:@"desc" forKey:@"orderType"];
    }
    
    [request102 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request102.tag = 102;
    request102.delegate =self;
    [request102 setDidFailSelector:@selector(rm20_urlRequestFailed:)];
    [request102 setDidFinishSelector:@selector(rm20_urlRequestSucceeded:)];
    [request102 startAsynchronous];
    
}
#pragma mark - 网络
-(void)rm24_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"1dicBig:%@",dicBig);
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
            nothingView.hidden  = NO;
            nothingLabel.hidden  = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden  = YES;
            nothingLabel.hidden  = YES;
        }
        [MyTableView reloadData];
    }else{
        nothingView.hidden  = NO;
        nothingLabel.hidden  = NO;
    }
    [SYObject endLoading];
}

-(void)rm24_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden  = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)rm23_urlRequestSucceeded:(ASIHTTPRequest *)request{
    
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"2dicBig:%@",dicBig);
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
        [SYObject endLoading];
        nothingView.hidden = YES;
        nothingLabel.hidden  = YES;
    }
    
}
-(void)rm23_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden  = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)rm22_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"3dicBig:%@",dicBig);
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
        [SYObject endLoading];
        nothingView.hidden = YES;
        nothingLabel.hidden  = YES;
    }
    
}
-(void)rm22_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden  = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)rm21_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"4dicBig:%@",dicBig);
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
        [SYObject endLoading];
        nothingView.hidden = YES;
        nothingLabel.hidden  = YES;
    }
    
}
-(void)rm21_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden  = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
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
        [SYObject endLoading];
        nothingView.hidden = YES;
        nothingLabel.hidden  = YES;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [MyTableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [MyTableView footerEndRefreshing];
    });
}
-(void)rm20_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden  = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)rm19_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"6dicBig:%@",dicBig);
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
        [SYObject endLoading];
        nothingView.hidden = YES;
        nothingLabel.hidden  = YES;
    }
    
}
-(void)rm19_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden  = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)rm18_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"7dicBig:%@",dicBig);
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
        [SYObject endLoading];
        nothingView.hidden = YES;
        nothingLabel.hidden  = YES;
    }
    
}
-(void)rm18_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden  = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)rm17_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"8dicBig:%@",dicBig);
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
            nothingLabel.hidden  = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
            nothingLabel.hidden  = YES;
        }
        [MyTableView reloadData];
    }
    [SYObject endLoading];
}
-(void)rm17_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden  = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)rm16_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"9dicBig:%@",dicBig);
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
            nothingLabel.hidden  = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
            nothingLabel.hidden  = YES;
        }
        [MyTableView reloadData];
    }
    [SYObject endLoading];
}
-(void)rm16_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden  = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)rm15_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"10dicBig:%@",dicBig);
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
            nothingLabel.hidden  = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
            nothingLabel.hidden  = YES;
        }
        [MyTableView reloadData];
    }
    [SYObject endLoading];
}
-(void)rm15_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden  = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)rm14_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"11dicBig:%@",dicBig);
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
            nothingLabel.hidden  = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
            nothingLabel.hidden  = YES;
        }
        [MyTableView reloadData];
    }
    [SYObject endLoading];
}
-(void)rm14_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden  = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)rm13_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"12dicBig:%@",dicBig);
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
            nothingLabel.hidden  = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
            nothingLabel.hidden  = YES;
        }
        [MyTableView reloadData];
    }
    [SYObject endLoading];
}
-(void)rm13_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden  = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)rm12_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"13dicBig:%@",dicBig);
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
            nothingLabel.hidden  = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
            nothingLabel.hidden  = YES;
        }
        [MyTableView reloadData];
    }
    [SYObject endLoading];
}
-(void)rm12_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden  = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
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
            nothingLabel.hidden  = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
            nothingLabel.hidden  = YES;
        }
        [MyTableView reloadData];
    }
    [SYObject endLoading];
}
-(void)rm11_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden  = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)rm10_urlRequestSucceeded:(ASIHTTPRequest *)request{
    
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"15dicBig:%@",dicBig);
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
            nothingLabel.hidden  = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
            nothingLabel.hidden  = YES;
        }
        [MyTableView reloadData];
    }
    [SYObject endLoading];
}
-(void)rm10_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden  = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)rm9_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"16dicBig:%@",dicBig);
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
            nothingLabel.hidden  = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
            nothingLabel.hidden  = YES;
        }
        [MyTableView reloadData];
    }
    [SYObject endLoading];
}
-(void)rm9_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden  = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)rm8_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"17dicBig:%@",dicBig);
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
            nothingLabel.hidden  = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
            nothingLabel.hidden  = YES;
        }
        [MyTableView reloadData];
    }
   [SYObject endLoading];
}
-(void)rm8_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden  = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)rm7_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"18dicBig:%@",dicBig);
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
            nothingLabel.hidden  = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
            nothingLabel.hidden  = YES;
        }
        [MyTableView reloadData];
    }
    [SYObject endLoading];
}
-(void)rm7_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden  = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)rm6_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"19dicBig:%@",dicBig);
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
            nothingLabel.hidden  = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
            nothingLabel.hidden  = YES;
        }
        [MyTableView reloadData];
    }
    [SYObject endLoading];
}
-(void)rm6_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden  = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)rm4_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"20dicBig:%@",dicBig);
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
            nothingLabel.hidden  = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
            nothingLabel.hidden  = YES;
        }
        [MyTableView reloadData];
    }
    [SYObject endLoading];
}
-(void)rm4_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)rm3_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"21dicBig:%@",dicBig);
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
            nothingLabel.hidden  = NO;
        }else{
            MyTableView.hidden = NO;
            nothingLabel.hidden  = YES;
            nothingView.hidden = YES;
        }
        [MyTableView reloadData];
    }
    [SYObject endLoading];
}
-(void)rm3_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden  = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
    
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
            nothingLabel.hidden  = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
            nothingLabel.hidden  = YES;
        }
        [MyTableView reloadData];
    }
    [SYObject endLoading];
}
-(void)jp9_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden  = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)jp8_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"23dicBig:%@",dicBig);
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
            nothingLabel.hidden  = NO;
        }else{
            MyTableView.hidden = NO;
            nothingLabel.hidden  = YES;
            nothingView.hidden = YES;
        }
        [MyTableView reloadData];
    }
    [SYObject endLoading];
}
-(void)jp8_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden  = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)jp7_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"24dicBig:%@",dicBig);
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
            nothingLabel.hidden  = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
            nothingLabel.hidden  = YES;
        }
        [MyTableView reloadData];
    }
    [SYObject endLoading];
}
-(void)jp7_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden  = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)jp6_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"25dicBig:%@",dicBig);
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
            nothingLabel.hidden  = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
            nothingLabel.hidden  = YES;
        }
        [MyTableView reloadData];
    }
    [SYObject endLoading];
}
-(void)jp6_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden  = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)jp5_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"26dicBig:%@",dicBig);
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
            nothingLabel.hidden  = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
            nothingLabel.hidden  = YES;
        }
        [MyTableView reloadData];
    }
    [SYObject endLoading];
}
-(void)jp5_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)jp4_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"27dicBig:%@",dicBig);
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
            nothingLabel.hidden  = NO;
            nothingView.hidden  = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden  = YES;
            nothingLabel.hidden  = YES;
        }
        [MyTableView reloadData];
    }
    [SYObject endLoading];
}
-(void)jp4_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)all9_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"28dicBig:%@",dicBig);
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
            nothingView.hidden  = NO;
            nothingLabel.hidden  = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden  = YES;
            nothingLabel.hidden  = YES;
        }
        [MyTableView reloadData];
    }
    [SYObject endLoading];
}
-(void)all9_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)all8_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"29dicBig:%@",dicBig);
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
            nothingView.hidden  = NO;
            nothingLabel.hidden  = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden  = YES;
            nothingLabel.hidden  = YES
            ;
        }
        [MyTableView reloadData];
    }
    [SYObject endLoading];
}
-(void)all8_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
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
            nothingView.hidden  = NO;
            nothingLabel.hidden  = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden  = YES;
            nothingLabel.hidden  = YES;
        }
        [MyTableView reloadData];
    }
   [SYObject endLoading];
}
-(void)all7_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)all6_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"31dicBig:%@",dicBig);
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
            nothingView.hidden  = NO;
            nothingLabel.hidden  = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden  = YES;
            nothingLabel.hidden  = YES;
        }
        [MyTableView reloadData];
    }
    [SYObject endLoading];
}
-(void)all6_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)rm5_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request  responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"32dicBig:%@",dicBig);
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
            nothingView.hidden  = NO;
            nothingLabel.hidden  = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden  = YES;
            nothingLabel.hidden  = YES;
        }
        [MyTableView reloadData];
    }
    [SYObject endLoading];
}
-(void)rm5_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)jp3_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request  responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"33dicBig:%@",dicBig);
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
            nothingView.hidden  = NO;
            nothingLabel.hidden  = NO;
            
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden  = YES;
            nothingLabel.hidden  = YES;
        }
        [MyTableView reloadData];
    }
    [SYObject endLoading];
}
-(void)jp3_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
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
            nothingView.hidden  = NO;
            nothingLabel.hidden  = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden  = YES;
            nothingLabel.hidden  = YES;
        }
        [MyTableView reloadData];
    }
    [SYObject endLoading];
}
-(void)all4_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
    
}
-(void)all3_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"35dicBig:%@",dicBig);
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
    [SYObject endLoading];
    nothingView.hidden = YES;
    nothingLabel.hidden  = YES;
}
-(void)all3_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)rm2_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"36dicBig:%@",dicBig);
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
    [SYObject endLoading];
    nothingView.hidden = YES;
}
-(void)rm2_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)jpdesc_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"37dicBig:%@",dicBig);
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
    [SYObject endLoading];
    nothingView.hidden = YES;nothingLabel.hidden  = YES;
}
-(void)jpdesc_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
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
    [SYObject endLoading];
    nothingView.hidden = YES;
    nothingLabel.hidden  = YES;
}
-(void)all2_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)search_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"39dicBig:%@",dicBig);
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
    [SYObject endLoading];
    nothingView.hidden = YES;
    nothingLabel.hidden  = YES;
}
-(void)search_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)rm_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"40dicBig:%@",dicBig);
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
    [SYObject endLoading];
    nothingView.hidden = YES;
    nothingLabel.hidden  = YES;
}
-(void)rm_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)jp_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"41dicBig:%@",dicBig);
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
   [SYObject endLoading];
    nothingView.hidden = YES;
    nothingLabel.hidden  = YES;
}
-(void)jp_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
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
    [SYObject endLoading];
    nothingView.hidden = YES;
    nothingLabel.hidden  =YES;
}
-(void)all_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)store_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"43dicBig:%@",dicBig);
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
            nothingLabel.hidden  = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
            nothingLabel.hidden  = YES;
        }
        [MyTableView reloadData];
    }
    [SYObject endLoading];
    
}
-(void)store_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
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
            nothingLabel.hidden  = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
            nothingLabel.hidden  = YES;
        }
        [MyTableView reloadData];
    }
   [SYObject endLoading];
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden = NO;
    nothingLabel.hidden  = NO;
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}

-(void)TopBtnClicked:(UIButton *)btn{
    [SYObject startLoading];
    SecondViewController *sec = [SecondViewController sharedUserDefault];
    NSLog(@"%ld",(long)(long)btn.tag);
    if (btn.tag == 101){
        [PriceBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [SalesBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [PopularityBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [NewGoodsBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        if (priceBool == NO) {
            select_attribute = @"price_asc";
            
            priceImage.image = [UIImage imageNamed:@"price_down_red"];
            [PriceBtn setTitle:@"" forState:UIControlStateNormal];
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,CLASSIFY_SUB2_URL]];
            ASIFormDataRequest *request101=[ASIFormDataRequest requestWithURL:url];
            [request101 setPostValue:@"goods_current_price" forKey:@"orderBy"];
            [request101 setPostValue:@"asc" forKey:@"orderType"];
            [request101 setPostValue:sec.sub_id2 forKey:@"gb_id"];
            [request101 setPostValue:@"0" forKey:@"beginCount"];
            [request101 setPostValue:@"20" forKey:@"selectCount"];
            
            [request101 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request101.tag = 101;
            request101.delegate =self;
            [request101 setDidFailSelector:@selector(search_urlRequestFailed:)];
            [request101 setDidFinishSelector:@selector(search_urlRequestSucceeded:)];
            [request101 startAsynchronous];
            priceBool = YES;
        }else{
            priceImage.image = [UIImage imageNamed:@"price_up_red"];
            [PriceBtn setTitle:@"" forState:UIControlStateNormal];
            
            select_attribute = @"price_desc";
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,CLASSIFY_SUB2_URL]];
            ASIFormDataRequest *request101=[ASIFormDataRequest requestWithURL:url];
            [request101 setPostValue:@"goods_current_price" forKey:@"orderBy"];
            [request101 setPostValue:@"desc" forKey:@"orderType"];
            [request101 setPostValue:sec.sub_id2 forKey:@"gb_id"];
            [request101 setPostValue:@"0" forKey:@"beginCount"];
            [request101 setPostValue:@"20" forKey:@"selectCount"];
            
            [request101 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request101.tag = 101;
            request101.delegate =self;
            [request101 setDidFailSelector:@selector(all3_urlRequestFailed:)];
            [request101 setDidFinishSelector:@selector(all3_urlRequestSucceeded:)];
            [request101 startAsynchronous];
            priceBool = NO;
        }
    }
    if (btn.tag == 102){
        priceImage.image = [UIImage imageNamed:@"price_gray"];
        [PriceBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [SalesBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [PopularityBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [NewGoodsBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        select_attribute = @"sales_asc";
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,CLASSIFY_SUB2_URL]];
        ASIFormDataRequest *request101=[ASIFormDataRequest requestWithURL:url];
        [request101 setPostValue:@"goods_salenum" forKey:@"orderBy"];
        [request101 setPostValue:sec.sub_id2 forKey:@"gb_id"];
        [request101 setPostValue:@"0" forKey:@"beginCount"];
        [request101 setPostValue:@"20" forKey:@"selectCount"];
        
        [request101 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request101.tag = 101;
        request101.delegate =self;
        [request101 setDidFailSelector:@selector(jp4_urlRequestFailed:)];
        [request101 setDidFinishSelector:@selector(jp4_urlRequestSucceeded:)];
        [request101 startAsynchronous];
    }
    if (btn.tag == 103){
        priceImage.image = [UIImage imageNamed:@"price_gray"];
        [PriceBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [SalesBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [PopularityBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [NewGoodsBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        select_attribute = @"ren_asc";
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,CLASSIFY_SUB2_URL]];
        ASIFormDataRequest *request101=[ASIFormDataRequest requestWithURL:url];
        [request101 setPostValue:@"goods_click" forKey:@"orderBy"];
        [request101 setPostValue:sec.sub_id2 forKey:@"gb_id"];
        [request101 setPostValue:@"0" forKey:@"beginCount"];
        [request101 setPostValue:@"20" forKey:@"selectCount"];
        
        [request101 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request101.tag = 101;
        request101.delegate =self;
        [request101 setDidFailSelector:@selector(jp8_urlRequestFailed:)];
        [request101 setDidFinishSelector:@selector(jp8_urlRequestSucceeded:)];
        [request101 startAsynchronous];
    }
    if (btn.tag == 104){
        priceImage.image = [UIImage imageNamed:@"price_gray"];
        [PriceBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [SalesBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [PopularityBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [NewGoodsBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        select_attribute = @"time_asc";
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,CLASSIFY_SUB2_URL]];
        ASIFormDataRequest *request101=[ASIFormDataRequest requestWithURL:url];
        [request101 setPostValue:@"goods_seller_time" forKey:@"orderBy"];
        [request101 setPostValue:sec.sub_id2 forKey:@"gb_id"];
        [request101 setPostValue:@"0" forKey:@"beginCount"];
        [request101 setPostValue:@"20" forKey:@"selectCount"];
        
        [request101 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request101.tag = 101;
        request101.delegate =self;
        [request101 setDidFailSelector:@selector(rm10_urlRequestFailed:)];
        [request101 setDidFinishSelector:@selector(rm10_urlRequestSucceeded:)];
        [request101 startAsynchronous];
    }
}

- (IBAction)segcontrolBtnClicked:(id)sender {
    
}
@end
