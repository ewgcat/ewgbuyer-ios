//
//  myzeroViewController.m
//  My_App
//
//  Created by apple on 15-1-5.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "myzeroViewController.h"
#import "zeroOrderCell.h"
#import "myzerodetailViewController.h"
#import "ASIFormDataRequest.h"
#import "LoginViewController.h"
#import "FirstViewController.h"
#import "ThreeDotView.h"

@interface myzeroViewController (){
    ASIFormDataRequest *request_1;
    ASIFormDataRequest *request_2;
    ASIFormDataRequest *request_3;
    ASIFormDataRequest *request_4;
    ThreeDotView *tdv;
}

@end

@implementation myzeroViewController

-(void)createRealBackBtn{
  
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backRealBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;

    UIButton *buttonChat = [UIButton buttonWithType:UIButtonTypeCustom ];
    buttonChat.frame =CGRectMake(0, 0, 22, 22);
    [buttonChat setBackgroundImage:[UIImage imageNamed:@"point"] forState:UIControlStateNormal];
    [buttonChat addTarget:self action:@selector(MoreClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar2 = [[UIBarButtonItem alloc]initWithCustomView:buttonChat];
    self.navigationItem.rightBarButtonItem =bar2;
}
-(void)MoreClicked{
    tdv.hidden = NO;
}
-(void)viewDidLayoutSubviews{
    [self createMoreBtn];
}
-(void)createMoreBtn{
    ThreeDotView *three = [[ThreeDotView alloc]initWithButtonCount:2 nc:self.navigationController];
    tdv = three;
    tdv.dataArray = dataArray;
    three.dataArray = dataArray;
    three.vc = self;
    [three insertMoreBtn:[three homeBtn]];
    three.hidden = YES;
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

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request_1 clearDelegatesAndCancel];
    [request_2 clearDelegatesAndCancel];
    [request_3 clearDelegatesAndCancel];
    [request_4 clearDelegatesAndCancel];
    [MyTableView setEditing:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [SYObject startLoading];
    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,FREE_ORDERLIST_URL]];
    request_1=[ASIFormDataRequest requestWithURL:url3];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    [request_1 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request_1 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    
    [request_1 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_1.tag = 101;
    request_1.delegate = self;
    [request_1 setDidFailSelector:@selector(my2_urlRequestFailed:)];
    [request_1 setDidFinishSelector:@selector(my2_urlRequestSucceeded:)];
    [request_1 startAsynchronous];
    [MyTableView setEditing:NO];
    [super viewWillAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    muchBool = NO;
    muchView.hidden = YES;
    
    [muchGray.layer setMasksToBounds:YES];
    [muchGray.layer setCornerRadius:4];
    
    self.title = @"0元购订单";
    dataArray = [[NSMutableArray alloc]init];
    dataArrayShangla = [[NSMutableArray alloc]init];
    [self createRealBackBtn];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    
    MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MyTableView.delegate = self;
    MyTableView.dataSource=  self;
    MyTableView.showsVerticalScrollIndicator=NO;
    MyTableView.backgroundColor = [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1];
    MyTableView.showsHorizontalScrollIndicator = NO;
    [MyTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backRealBtnClicked)];
    rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
    [MyTableView addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];
    
    [SYObject startLoading];
    nothingView.hidden = YES;
}
#pragma mark - 点击事件
-(void)backRealBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnClicked:(UIButton *)btn{
    
    if (dataArray.count!=0) {
        ClassifyModel *claa = [dataArray objectAtIndex:btn.tag-100];
        LoginViewController *log = [LoginViewController sharedUserDefault];
        log.lifeGroup_oid = claa.goods_oid;
        myzerodetailViewController *my = [[myzerodetailViewController alloc]init];
        [self.navigationController pushViewController:my animated:YES];
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
    return 170;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myTabelviewCell = @"zeroOrderCell";
    zeroOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"zeroOrderCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1];
    }
    if (dataArray.count !=0) {
        ClassifyModel *class = [dataArray objectAtIndex:indexPath.row];
        if([class.goods_apply_status intValue] == 5){
            cell.status.text = @"审核通过";
        }else{
            cell.status.text = @"审核中";
        }
        cell.time.text = [NSString stringWithFormat:@"下单时间:%@",class.goods_addTime];
        [cell.photoImage sd_setImageWithURL:(NSURL*)[NSString stringWithFormat:@"%@",class.goods_main_photo]  placeholderImage:[UIImage imageNamed:@"kong_lj"]];
        cell.name.text = [NSString stringWithFormat:@"%@",class.goods_name];
        
        if ([class.goods_evaluate_status intValue] == 0) {
            cell.statusBottom.text = @"评价状态:未评价";
        }else{
            cell.statusBottom.text = @"评价状态:已评价";
        }
        [self fuwenbenLabel:cell.statusBottom FontNumber:[UIFont systemFontOfSize:15] AndRange:NSMakeRange(0, 5) AndColor:UIColorFromRGB(0x999999)];
        
        
        [cell.btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn.tag = 100+indexPath.row;
    }
    return cell;
}
-(void)fuwenbenLabel:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labell.text];
    
    [str addAttribute:NSFontAttributeName value:font range:range];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    labell.attributedText = str;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassifyModel *claa = [dataArray objectAtIndex:indexPath.row];
    LoginViewController *log = [LoginViewController sharedUserDefault];
    log.lifeGroup_oid = claa.goods_oid;
    myzerodetailViewController *my = [[myzerodetailViewController alloc]init];
    [self.navigationController pushViewController:my animated:YES];
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
    
    [SYObject startLoading];
    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,FREE_ORDERLIST_URL]];
    request_3=[ASIFormDataRequest requestWithURL:url3];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    [request_3 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request_3 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    [request_3 setPostValue:[NSString stringWithFormat:@"%lu",(unsigned long)dataArray.count] forKey:@"beginCount"];
    
    [request_3 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_3.tag = 101;
    request_3.delegate = self;
    [request_3 setDidFailSelector:@selector(my1_urlRequestFailed:)];
    [request_3 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
    [request_3 startAsynchronous];
    
}
#pragma mark - 网络
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request  responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig：%@",dicBig);
        if (dataArrayShangla.count!=0) {
            [dataArrayShangla removeAllObjects];
        }
        NSArray *arr = [dicBig objectForKey:@"order_list"];
        for(NSDictionary *dic in arr){
            ClassifyModel *class = [[ClassifyModel alloc]init];
            class.goods_evaluate_status = [dic objectForKey:@"evaluate_status"];
            class.goods_addTime = [dic objectForKey:@"addTime"];
            class.goods_apply_status = [dic objectForKey:@"apply_status"];
            class.goods_main_photo = [dic objectForKey:@"goods_img"];
            class.goods_name = [dic objectForKey:@"goods_name"];
            class.goods_oid = [dic objectForKey:@"oid"];
            
            [dataArrayShangla addObject:class];
        }
        [dataArray addObjectsFromArray:dataArrayShangla];
        [MyTableView reloadData];
        nothingView.hidden = YES;
        [SYObject endLoading];
    }
    else{
        nothingView.hidden = NO;
        [self failedPrompt:@"请求出错"];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [MyTableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [MyTableView footerEndRefreshing];
    });
}
-(void)failedPrompt:(NSString *)prompt{
    [SYObject endLoading];
    [SYObject failedPrompt:prompt];
}
-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden = NO;
    [self failedPrompt:@"网络请求失败"];
}
-(void)my2_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig：%@",dicBig);
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        NSArray *arr = [dicBig objectForKey:@"order_list"];
        for(NSDictionary *dic in arr){
            ClassifyModel *class = [[ClassifyModel alloc]init];
            class.goods_evaluate_status = [dic objectForKey:@"evaluate_status"];
            class.goods_addTime = [dic objectForKey:@"addTime"];
            class.goods_apply_status = [dic objectForKey:@"apply_status"];
            class.goods_main_photo = [dic objectForKey:@"goods_img"];
            class.goods_name = [dic objectForKey:@"goods_name"];
            class.goods_oid = [dic objectForKey:@"oid"];
            
            [dataArray addObject:class];
        }
        if (dataArray.count == 0) {
            MyTableView.hidden = YES;
            nothingView.hidden = NO;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
        }
        [MyTableView reloadData];
        
        [SYObject endLoading];
    }
    else{
        nothingView.hidden = NO;
        [self failedPrompt:@"请求出错"];
    }
    
}
-(void)my2_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
    nothingView.hidden = NO;
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig：%@",dicBig);
        if (dataArrayShangla.count!=0) {
            [dataArrayShangla removeAllObjects];
        }
        NSArray *arr = [dicBig objectForKey:@"order_list"];
        for(NSDictionary *dic in arr){
            ClassifyModel *class = [[ClassifyModel alloc]init];
            class.goods_evaluate_status = [dic objectForKey:@"evaluate_status"];
            class.goods_addTime = [dic objectForKey:@"addTime"];
            class.goods_apply_status = [dic objectForKey:@"apply_status"];
            class.goods_main_photo = [dic objectForKey:@"goods_img"];
            class.goods_name = [dic objectForKey:@"goods_name"];
            class.goods_oid = [dic objectForKey:@"oid"];
            
            [dataArrayShangla addObject:class];
        }
        [dataArray addObjectsFromArray:dataArrayShangla];
        [MyTableView reloadData];
        nothingView.hidden = YES;
        [SYObject endLoading];
    }
    else{
        nothingView.hidden = NO;
        [self failedPrompt:@"请求出错"];
    }
    
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
    nothingView.hidden = NO;
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
@end
