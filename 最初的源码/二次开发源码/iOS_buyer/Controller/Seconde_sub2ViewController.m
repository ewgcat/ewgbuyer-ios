//
//  Seconde_sub2ViewController.m
//  My_App
//
//  Created by apple on 14-7-29.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "Seconde_sub2ViewController.h"
#import "SecondViewController.h"
#import "ASIFormDataRequest.h"
#import "DetailViewController.h"
#import "goodsListCell.h"
#import "ThirdViewController.h"
#import "storegoodsDetailViewController.h"
#import "MJRefresh.h"
#import "second1Cell.h"
#import "FilterCell.h"
#import "SearchViewController.h"
#import "FilterConditionsCell.h"

static CGFloat filterRowHeight = 44.f;//筛选按钮每行的高度

@interface Seconde_sub2ViewController ()<UIGestureRecognizerDelegate,FilterConditionsCellDelegate>
{
    SecondViewController *sec;
    ASIFormDataRequest *request101;
}

@end

@implementation Seconde_sub2ViewController



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    sec.storeAllgoodsBool = NO;
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    [request101 clearDelegatesAndCancel];
}
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
    btnClickedBool = NO;
    // Do any additional setup after loading the view from its nib.
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.navigationController.navigationBar.barTintColor = RGB_COLOR(219,34,46);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    sec = [SecondViewController sharedUserDefault];
    priceImage.image = [UIImage imageNamed:@"price_gray"];
    dataArrayShangla =[[NSMutableArray alloc]init];
    dataArray =[[NSMutableArray alloc]init];
    FilterDataArray =[[NSMutableArray alloc]init];
    select_attribute = @"sales_asc";
    priceBool = NO;
    FilterView.hidden = YES;
    requestBool = NO;
    shanglaBool = YES;
    FilterFirstIndex = -1;
    [searchBg.layer setMasksToBounds:YES];
    [searchBg.layer setCornerRadius:4];
    
    [SYObject startLoading];
    nothingView.hidden = YES;
    [ClearFilterBtn.layer setMasksToBounds:YES];
    [ClearFilterBtn.layer setCornerRadius:4];
    ClearFilterBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    ClearFilterBtn.layer.borderWidth = 0.5;
    
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    [MyTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    //设置代理
    searchTextField.text = sec.sub_title2;
    FilterTableView.delegate = self;
    FilterTableView.dataSource=  self;
    FilterTwoTableView.delegate = self;
    FilterTwoTableView.dataSource=  self;
    FilterSecondView.hidden = YES;
    
    UIView *TopViewFilter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 108)];
    TopViewFilter.backgroundColor = [UIColor whiteColor];
    MyTableView.tableHeaderView = TopViewFilter;
    MyTableView.delegate = self;
    MyTableView.dataSource=  self;
    
    PriceBtn.tag = 101;
    [PriceBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    SalesBtn.tag = 102;
    [SalesBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [SalesBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    PopularityBtn.tag = 103;
    [PopularityBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NewGoodsBtn.tag = 104;
    [NewGoodsBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if ([[NSString stringWithFormat:@"%@",sec.sub_id2] isEqualToString:@"search"]) {
        [self NetWork_OrderBy:@"goods_salenum" orderType:@"asc" gc_id:@"" keyword:sec.searchKeyword beginCount:@"0" selectCount:@"20" properties:@""];
    }else{
        [self NetWork_OrderBy:@"goods_salenum" orderType:@"asc" gc_id:sec.sub_id2 keyword:@"" beginCount:@"0" selectCount:@"20" properties:@""];
    }
    [self filterNetwork];
    
    //添加消失手势
    UITapGestureRecognizer *singleTapGestureRecognizer3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappear)];
    [singleTapGestureRecognizer3 setNumberOfTapsRequired:1];
    [FilterBgImage addGestureRecognizer:singleTapGestureRecognizer3];
    
    //筛选条件 加入自营，货到付款，仅看有货
    filterConditions = [NSMutableDictionary dictionaryWithDictionary:@{@"自营":@"0",@"货到付款":@"0",@"仅看有货":@"0"}];//一行3个
}

-(void)scrollViewWillBeginDragging:(UIScrollView*)scrollView{
    lastContentOffset = MyTableView.contentOffset.y;
}
-( void )scrollViewDidScroll:( UIScrollView *)scrollView {
    //lastContentOffset
    if (scrollView.contentOffset.y< 20 )
    {
        [topView setFrame:CGRectMake(0, 64, ScreenFrame.size.width, 44)];
        [titleView setFrame:CGRectMake(0, 0, ScreenFrame.size.width, 64)];
        
    } else if (scrollView. contentOffset.y >lastContentOffset )
    {
        if (MyTableView.contentOffset.y - lastContentOffset >=0 && MyTableView.contentOffset.y - lastContentOffset<=108) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [topView setFrame:CGRectMake(0, 64-MyTableView.contentOffset.y, ScreenFrame.size.width, 44)];
            [titleView setFrame:CGRectMake(0, -MyTableView.contentOffset.y, ScreenFrame.size.width, 64)];
            [UIView commitAnimations];
        }
    }
}

-(void)disappear{
    FilterView.hidden = YES;
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
-(NSString *)properties_str{
    NSMutableArray *d=[[NSMutableArray alloc]init];
    for(ClassifyModel *class in FilterDataArray){
        if(class.ping_height != 0){
            [d addObject:[NSString stringWithFormat:@"%@,%@",class.goods_id,[class.classify_thirdArray objectAtIndex:class.ping_height]]];
        }
    }
    NSString *properties=[d componentsJoinedByString:@"|"];
    return properties;
}
-(void)footerRereshing{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,CLASSIFY_SUB2_URL]];
    ASIFormDataRequest *request102=[ASIFormDataRequest requestWithURL:url];
    if ([[NSString stringWithFormat:@"%@",sec.sub_id2] isEqualToString:@"search"]) {
        [request102 setPostValue:sec.searchKeyword forKey:@"keyword"];
    }else{
        [request102 setPostValue:sec.sub_id2 forKey:@"gc_id"];
    }
    [request102 setPostValue:[self properties_str] forKey:@"properties"];
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
    NSArray *arrObjc;
    if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
        arrObjc = [[NSArray alloc]initWithObjects:@"", nil];
    }else{
        arrObjc = [[NSArray alloc]initWithObjects:[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:4], nil];
    }
    NSArray *arrKey = [[NSArray alloc]initWithObjects:VERIFY, nil];
    NSMutableDictionary *dicMy = [[NSMutableDictionary alloc]initWithObjects:arrObjc forKeys:arrKey];
    [request102 setRequestHeaders:dicMy];
    request102.tag = 102;
    request102.delegate =self;
    [request102 setDidFailSelector:@selector(urlRequestFailed:)];
    [request102 setDidFinishSelector:@selector(rm20_urlRequestSucceeded:)];
    [request102 startAsynchronous];
}

#pragma mark - tabelView方法
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == FilterTableView) {
        if (section == 1) {
            return 10;
        }
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == FilterTableView) {
        return 2;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == MyTableView) {
        if (dataArray.count!=0) {
            return dataArray.count;
        }
    }else if (tableView == FilterTwoTableView){
        if (FilterDataArray.count!=0) {
            ClassifyModel *class = [FilterDataArray objectAtIndex:FilterFirstIndex];
            return class.classify_thirdArray.count;
        }
    }else if (tableView == FilterTableView){
        if (section == 1 && FilterDataArray.count!=0) {
            return FilterDataArray.count;
        } else if (section == 0) {
            return 1;
        }
    }
    
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == MyTableView) {
        return 130;
    }else if (tableView == FilterTwoTableView){
        return 44;
    }else if (tableView == FilterTableView){
        if (indexPath.section == 1) {
            if (FilterDataArray.count!=0) {
                return 44;
            }
        } else if (indexPath.section == 0) {
            return filterRowHeight * ((filterConditions.allKeys.count -1) / 3 + 1);
        }
        
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == MyTableView) {
        goodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsListCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"goodsListCell" owner:self options:nil] lastObject];
        }
        if (dataArray.count!=0) {
            ClassifyModel *classify = [dataArray objectAtIndex:indexPath.row];
            [cell setData:classify];
        }
        return cell;
    }else if (tableView == FilterTwoTableView){
        second1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"second1Cell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"second1Cell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        if (FilterDataArray.count!=0) {
            ClassifyModel *class = [FilterDataArray objectAtIndex:FilterFirstIndex];
            if (class.ping_height == indexPath.row) {
                cell.label.textColor = [UIColor redColor];
            }else{
                cell.label.textColor = [UIColor darkGrayColor];
            }
            cell.label.text = [class.classify_thirdArray objectAtIndex:indexPath.row];
            cell.imageLine.hidden = YES;
            cell.label.font = [UIFont systemFontOfSize:14];
        }
        return cell;
    }else if (tableView == FilterTableView){
        if (indexPath.section == 1) {
            FilterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterCell"];
            if(cell == nil){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"FilterCell" owner:self options:nil] lastObject];
            }
            if (FilterDataArray.count!=0) {
                ClassifyModel *classify = [FilterDataArray objectAtIndex:indexPath.row];
                [cell setData:classify];
            }
            return cell;
        } else if (indexPath.section == 0) {
            FilterConditionsCell *cell = [FilterConditionsCell cellWithTableView:tableView];
            cell.dict = filterConditions;
            cell.delegate = self;
            return cell;
        }
        
    }
    UITableViewCell *cell;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == MyTableView) {
        if (dataArray.count!=0) {
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
    }else if (tableView == FilterTwoTableView){
        ClassifyModel *class = [FilterDataArray objectAtIndex:FilterFirstIndex];
        class.ping_height = indexPath.row;
        FilterSecondView.hidden = YES;
        [FilterTableView reloadData];
    }else if (tableView == FilterTableView && indexPath.section == 1){
        FilterSecondView.hidden = NO;
        FilterFirstIndex = indexPath.row;
        
        ClassifyModel *classify = [FilterDataArray objectAtIndex:indexPath.row];
        FilterSecondTitle.text = classify.goods_name;
        if (classify.classify_thirdArray.count>0) {
            [FilterTwoTableView reloadData];
        }else{
            FilterTwoTableView.backgroundView=[SYObject noDataView];
        }
      
    }
}

#pragma mark - textField
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

#pragma mark - 点击事件
-(void)filterButtonClicked:(FilterConditionsCell *)cell{
    [FilterTableView reloadData];
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
    topView = nil;
    select_attribute = nil;
    
}
- (void)btnClicked:(UIButton *)btn {
    btnClickedBool = YES;
//    loadingV.hidden = NO;
    [SYObject startLoading];
    [MyTableView setContentOffset:CGPointMake(0,0) animated:YES];
    
    if (btn.tag == 101) {
        [PriceBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [SalesBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [PopularityBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [NewGoodsBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        if (priceBool == NO) {
            select_attribute = @"price_asc";
            priceImage.image = [UIImage imageNamed:@"price_down_red"];
            [PriceBtn setTitle:@"" forState:UIControlStateNormal];
            
            if ([[NSString stringWithFormat:@"%@",sec.sub_id2] isEqualToString:@"search"]) {
                [self NetWork_OrderBy:@"goods_current_price" orderType:@"asc" gc_id:@"" keyword:sec.searchKeyword beginCount:@"0" selectCount:@"20" properties:[self properties_str]];
            }else{
                [self NetWork_OrderBy:@"goods_current_price" orderType:@"asc" gc_id:sec.sub_id2 keyword:@"" beginCount:@"0" selectCount:@"20" properties:[self properties_str]];
            }
            
            priceBool = YES;
        }else{
            priceImage.image = [UIImage imageNamed:@"price_up_red"];
            [PriceBtn setTitle:@"" forState:UIControlStateNormal];
            select_attribute = @"price_desc";
            
            if ([[NSString stringWithFormat:@"%@",sec.sub_id2] isEqualToString:@"search"]) {
                [self NetWork_OrderBy:@"goods_current_price" orderType:@"desc" gc_id:@"" keyword:sec.searchKeyword beginCount:@"0" selectCount:@"20" properties:[self properties_str]];
            }else{
                [self NetWork_OrderBy:@"goods_current_price" orderType:@"desc" gc_id:sec.sub_id2 keyword:@"" beginCount:@"0" selectCount:@"20" properties:[self properties_str]];
            }
            
            priceBool = NO;
        }
    }
    if (btn.tag == 102) {
        priceImage.image = [UIImage imageNamed:@"price_gray"];
        [PriceBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [SalesBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [PopularityBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [NewGoodsBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        select_attribute = @"sales_desc";
        
        if ([[NSString stringWithFormat:@"%@",sec.sub_id2] isEqualToString:@"search"]) {
            [self NetWork_OrderBy:@"goods_salenum" orderType:@"asc" gc_id:@"" keyword:sec.searchKeyword beginCount:@"0" selectCount:@"20" properties:[self properties_str]];
        }else{
            [self NetWork_OrderBy:@"goods_salenum" orderType:@"asc" gc_id:sec.sub_id2 keyword:@"" beginCount:@"0" selectCount:@"20" properties:[self properties_str]];
        }
    }
    if (btn.tag == 103) {
        priceImage.image = [UIImage imageNamed:@"price_gray"];
        [PriceBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [SalesBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [PopularityBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [NewGoodsBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        select_attribute = @"ren_asc";
        
        if ([[NSString stringWithFormat:@"%@",sec.sub_id2] isEqualToString:@"search"]) {
            [self NetWork_OrderBy:@"goods_click" orderType:@"asc" gc_id:@"" keyword:sec.searchKeyword beginCount:@"0" selectCount:@"20" properties:[self properties_str]];
        }else{
            [self NetWork_OrderBy:@"goods_click" orderType:@"asc" gc_id:sec.sub_id2 keyword:@"" beginCount:@"0" selectCount:@"20" properties:[self properties_str]];
        }
        
    }
    if (btn.tag == 104) {
        priceImage.image = [UIImage imageNamed:@"price_gray"];
        [PriceBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [SalesBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [PopularityBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [NewGoodsBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        select_attribute = @"time_asc";
        
        if ([[NSString stringWithFormat:@"%@",sec.sub_id2] isEqualToString:@"search"]) {
            [self NetWork_OrderBy:@"goods_seller_time" orderType:@"asc" gc_id:@"" keyword:sec.searchKeyword beginCount:@"0" selectCount:@"20" properties:[self properties_str]];
        }else{
            [self NetWork_OrderBy:@"goods_seller_time" orderType:@"asc" gc_id:sec.sub_id2 keyword:@"" beginCount:@"0" selectCount:@"20" properties:[self properties_str]];
        }
    }
}

- (IBAction)filterAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 101) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (btn.tag == 102) {
        FilterView.hidden = NO;
    }
    if (btn.tag == 103) {
        FilterView.hidden = YES;
        
        if ([[NSString stringWithFormat:@"%@",sec.sub_id2] isEqualToString:@"search"]) {
            [self NetWork_OrderBy:@"goods_current_price" orderType:@"asc" gc_id:@"" keyword:sec.searchKeyword beginCount:@"0" selectCount:@"20" properties:[self properties_str]];
        }else{
            [self NetWork_OrderBy:@"goods_current_price" orderType:@"asc" gc_id:sec.sub_id2 keyword:@"" beginCount:@"0" selectCount:@"20" properties:[self properties_str]];
        }
    }
    if (btn.tag == 104) {
        FilterView.hidden = YES;
    }
    if (btn.tag == 105) {
        for(ClassifyModel *class in FilterDataArray){
            class.ping_height = 0;
        }
        
        NSArray *allKeys = filterConditions.allKeys;
        for (NSString *key in allKeys) {
            [filterConditions setValue:@"0" forKey:key];
        }
        [FilterTableView reloadData];
    }
    if (btn.tag == 106) {
        FilterSecondView.hidden = YES;
    }
    if (btn.tag == 107) {
        SearchViewController *search = [[SearchViewController alloc]init];
        [self.navigationController pushViewController:search animated:YES];
    }
}

- (IBAction)gotoTopAction:(id)sender {
    [MyTableView setContentOffset:CGPointMake(0,0) animated:YES];
}
-(NSString *)ch2en:(NSString *)ch {
    //@"自营":@"0",@"货到付款":@"0",@"仅看有货"
    if ([ch isEqualToString:@"自营"]) {
        return @"selfFilter";
    } else if ([ch isEqualToString:@"货到付款"]){
        return @"payafterFilter";
    } else if ([ch isEqualToString:@"仅看有货"]){
        return @"inventoryFilter";
    } else {
        return nil;
    }
}

#pragma mark - 网络
-(void)NetWork_OrderBy:(NSString *)orderBy orderType:(NSString *)orderType gc_id:(NSString *)gc_id keyword:(NSString *)keyword beginCount:(NSString *)beginCount selectCount:(NSString *)selectCount properties:(NSString *)properties {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,CLASSIFY_SUB2_URL]];
    request101=[ASIFormDataRequest requestWithURL:url];
    [request101 setPostValue:orderBy forKey:@"orderBy"];
    [request101 setPostValue:orderType forKey:@"orderType"];
    [request101 setPostValue:gc_id forKey:@"gc_id"];
    [request101 setPostValue:keyword forKey:@"keyword"];
    [request101 setPostValue:beginCount forKey:@"beginCount"];
    [request101 setPostValue:selectCount forKey:@"selectCount"];
    [request101 setPostValue:properties forKey:@"properties"];
    
    //按钮条件筛选
    NSArray *allKeys = [filterConditions allKeysForObject:@"1"];
    NSLog(@"all keys:%@",allKeys);
    for (NSString *key in allKeys) {
        NSString *keykey = [self ch2en:key];
        [request101 setPostValue:@"1" forKey:keykey];
    }
    
    NSArray *arrObjc;
    if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
        arrObjc = [[NSArray alloc]initWithObjects:@"", nil];
    }else{
        arrObjc = [[NSArray alloc]initWithObjects:[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:4], nil];
    }
    NSArray *arrKey = [[NSArray alloc]initWithObjects:VERIFY, nil];
    NSMutableDictionary *dicMy = [[NSMutableDictionary alloc]initWithObjects:arrObjc forKeys:arrKey];
    [request101 setRequestHeaders:dicMy];
    request101.tag = 101;
    request101.delegate =self;
    [request101 setDidFailSelector:@selector(urlRequestFailed:)];
    [request101 setDidFinishSelector:@selector(store_urlRequestSucceeded:)];
    [request101 startAsynchronous];
}
-(void)filterNetwork{
    NSArray *keyArr = [[NSArray alloc]initWithObjects:@"gc_id", nil];
    NSArray *valueArr = [[NSArray alloc]initWithObjects:sec.sub_id2, nil];
    ASIFormDataRequest *RequestList = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,GETFILTER_URL] setKey:keyArr setValue:valueArr];
    RequestList.delegate = self;
    [RequestList setDidFailSelector:@selector(urlRequestFailed:)];
    [RequestList setDidFinishSelector:@selector(FilterRequestSucceeded:)];
    [RequestList startAsynchronous];
}



-(void)rm20_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"5dicBig:%@",dicBig);
        if (dataArrayShangla.count!=0) {
            [dataArrayShangla removeAllObjects];
        }
        shanglaBool = NO;
        
        dataArrayShangla = [consultViewNetwork dataGoodsListData:request];
        
        requestBool = YES;
        [dataArray addObjectsFromArray:dataArrayShangla];
        [MyTableView reloadData];
//        loadingV.hidden = YES;
        [SYObject endLoading];
        nothingView.hidden = YES;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MyTableView reloadData];
            [MyTableView footerEndRefreshing];
        });
    }
}


-(void)FilterRequestSucceeded:(ASIFormDataRequest *)request{
    if ([request responseStatusCode] == 200) {
        if(FilterDataArray.count!=0){
            [FilterDataArray removeAllObjects];
        }
        FilterDataArray = [consultViewNetwork dataFilterData:request];
        if (FilterDataArray.count>0) {
            [FilterTableView reloadData];
        }else{
            FilterTableView.backgroundView=[SYObject noDataView];
        }
//        [FilterTableView reloadData];
    }
//    loadingV.hidden = YES;
    [SYObject endLoading];
}

-(void)store_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        dataArray = [consultViewNetwork dataGoodsListData:request];
        
        if (dataArray.count == 0) {
            MyTableView.hidden = YES;
            nothingView.hidden = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
        }
        [MyTableView reloadData];
    }else{
        NSLog(@"出错");
    }
//    loadingV.hidden = YES;
    [SYObject endLoading];
    
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden = NO;

    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
@end
