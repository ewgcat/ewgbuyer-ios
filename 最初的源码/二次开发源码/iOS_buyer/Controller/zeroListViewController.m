//
//  zeroListViewController.m
//  My_App
//
//  Created by apple on 15-1-5.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "zeroListViewController.h"
#import "zeroListCell.h"
#import "zeroDetailViewController.h"
#import "ASIFormDataRequest.h"
#import "LoginViewController.h"
#import "NewLoginViewController.h"
#import "zeroApplyAddressViewController.h"
#import "FirstViewController.h"


@interface zeroListViewController ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>
{
    ASIFormDataRequest *request_1;
    ASIFormDataRequest *request_2;
    ASIFormDataRequest *request_3;
    ASIFormDataRequest *request_4;
    ASIFormDataRequest *request_5;
    ASIFormDataRequest *request_6;
    ASIFormDataRequest *request_7;
    NSMutableDictionary *dataDict;
    CGFloat prevX;
}

@property (nonatomic, strong) NSMutableArray *tableViewArray;

@end

@implementation zeroListViewController

-(NSMutableArray *)tableViewArray{
    if (!_tableViewArray) {
        _tableViewArray = [NSMutableArray array];
    }
    return _tableViewArray;
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    loadingV.hidden=YES;
    
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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    requestBool = NO;
    classTag = 0;
    dataArray = [[NSMutableArray alloc]init];
    class_dataArray = [[NSMutableArray alloc]init];
    dataArrayShangla = [[NSMutableArray alloc]init];
    dataDict = [[NSMutableDictionary alloc]init];
    // Do any additional setup after loading the view.
    self.title = @"0元购";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createRealBackBtn];
    
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    
    TopScrollView.tag = 1022;
    TopScrollView.bounces = YES;
    TopScrollView.delegate = self;
    TopScrollView.showsHorizontalScrollIndicator = NO;
    TopScrollView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1];
    UISwipeGestureRecognizer *selfview_rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backRealBtnClicked)];
    selfview_rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:selfview_rightSwipeGestureRecognizerSMytableview];
    
   
    labelTi.hidden = YES;
    
   
    [SYObject startLoading];
    nothingView.hidden = YES;
    //获取分类
    request_2 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,ZERO_LIST_CLASSIFY_URL] setKey:nil setValue:nil];
    request_2.delegate = self;
    [request_2 setDidFailSelector:@selector(classify_urlRequestFailed:)];
    [request_2 setDidFinishSelector:@selector(classify_urlRequestSucceeded:)];
    [request_2 startAsynchronous];
}
#pragma mark - scrollView代理方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(scrollView!=containerScrollView){
        return;
    }
    CGFloat x = scrollView.contentOffset.x;
    NSInteger index = x/ScreenFrame.size.width;
    UIButton *btn;
    for (UIView *view in TopScrollView.subviews){
        if (view.tag ==100+index&&[view isKindOfClass:[UIButton class]]) {
            btn = (UIButton *)view;
        }
    }
    [self classBtnClicked:btn];
}
#pragma mark  - tabelView方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        NSInteger tableViewIndex = tableView.tag - 300;
        NSArray *arr = [dataDict objectForKey:@(tableViewIndex)];
    
        return arr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 220;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myTabelviewCell = @"zeroListCell";
    zeroListCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"zeroListCell" owner:self options:nil] lastObject];
    }
    NSInteger tableViewIndex = tableView.tag - 300;
    NSArray *arr = [dataDict objectForKey:@(tableViewIndex)];
    ClassifyModel *class = [arr objectAtIndex:indexPath.row];
    [cell setData:class];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger indexOfTableView = tableView.tag-300;
    NSArray *currentDataArray = dataDict[@(indexOfTableView)];
    if (currentDataArray.count !=0 ) {
        ClassifyModel *class = [currentDataArray objectAtIndex:indexPath.row];
        FirstViewController *log = [FirstViewController sharedUserDefault];
        
        log.Detailfree_id = [NSString stringWithFormat:@"%@",class.free_id];
        UIStoryboard * homePageStoryboard = [UIStoryboard storyboardWithName:@"first" bundle:nil];
        zeroDetailViewController *ordrt = [homePageStoryboard instantiateViewControllerWithIdentifier:@"zeroDetailViewController"];;
        [self.navigationController pushViewController:ordrt animated:YES];
    }
}
-(void)failedPrompt:(NSString *)prompt
{

    [SYObject endLoading];
    [SYObject failedPrompt:prompt];
}
#pragma mark  - 网络
-(void)supply_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)supply_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([[dicBig objectForKey:@"code"] intValue] == -100) {
            //您有尚未评价的0元购或您申请过此0元购
            [self failedPrompt:@"您有尚未评价的0元购或您申请过此0元购"];
        }else if ([[dicBig objectForKey:@"code"] intValue] == 100){
            ClassifyModel *class = [dataArray objectAtIndex:supplyTag];
            FirstViewController *log = [FirstViewController sharedUserDefault];
            log.Detailfree_id = [NSString stringWithFormat:@"%@",class.free_id];
            
            zeroApplyAddressViewController *apply = [[zeroApplyAddressViewController alloc]init];
            [self.navigationController pushViewController:apply animated:YES];
        }
        for (UITableView *tv in self.tableViewArray) {
            [tv reloadData];
        }
//        loadingV.hidden = YES;
        [SYObject endLoading];
    }
    else{
//        loadingV.hidden = YES;
        [SYObject endLoading];
    }
    
}
-(void)classify_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)classify_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if (class_dataArray.count !=0) {
            [class_dataArray removeAllObjects];
            [TopScrollView removeFromSuperview];
        }
        
        if (dicBig) {
            NSLog(@"DI:%@",dicBig);
            NSArray *arrClass = [dicBig objectForKey:@"freeclass_list"];
            for(NSDictionary *dic in arrClass){
                ClassifyModel *class = [[ClassifyModel alloc]init];
                class.goods_id = [dic objectForKey:@"class_id"];
                class.goods_name = [dic objectForKey:@"class_name"];
                [class_dataArray addObject:class];
            }
            TopScrollView.contentSize=CGSizeMake(80*class_dataArray.count,40);
            //在这里在scrollview上添加按钮啥的
            redBar = [[UIImageView alloc]initWithFrame:CGRectMake(3, 38,42, 2)];
            redBar.backgroundColor = _K_Color(241, 83, 83);
            [TopScrollView addSubview:redBar];
            //设定滚动相关
            containerScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, ScreenFrame.size.width, ScreenFrame.size.height-40-20-44)];
            containerScrollView.contentSize = CGSizeMake(containerScrollView.frame.size.width*(class_dataArray.count+1), containerScrollView.frame.size.height);
            containerScrollView.pagingEnabled = YES;
            containerScrollView.showsHorizontalScrollIndicator = NO;
            containerScrollView.delegate = self;
            [self.view insertSubview:containerScrollView belowSubview:nothingView];
            
            for (int i=0; i<class_dataArray.count+1; i++) {
                UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(i*ScreenFrame.size.width, 0, ScreenFrame.size.width, containerScrollView.frame.size.height) style:UITableViewStylePlain];
                tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                tableView.delegate = self;
                tableView.dataSource=  self;
                tableView.showsVerticalScrollIndicator=NO;
                tableView.showsHorizontalScrollIndicator = NO;
                tableView.tag = 300+i;
                [containerScrollView addSubview:tableView];
                [self.tableViewArray addObject:tableView];
            }
            CGFloat x=0;
            for(int i=0;i<class_dataArray.count+1;i++){
                UILabel *la=[[UILabel alloc]init];
                UIFont *fnt = [UIFont systemFontOfSize:14];
                la.font=fnt;
                if (i==0) {
                    la.text=@"全部";
                    currentLabel = la;
                    la.textColor = _K_Color(241, 83, 83);
                }else{
                    ClassifyModel *calsss = [class_dataArray objectAtIndex:i-1];
                    la.text=calsss.goods_name;
                }
                CGSize size = [la.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:la.font,NSFontAttributeName, nil]];
                
                CGFloat w=size.width+20;
                CGRect frame=CGRectMake(x, 0, w, 40);
                x= w+x;
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button addTarget:self action:@selector(classBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                button.frame=frame;
                button.tag = i+100;
                [TopScrollView addSubview:button];
                if(i==0){
                    [self classBtnClicked:button];
                }
                la.frame=CGRectMake(10, 0, w-20, 40);
                la.backgroundColor=[UIColor clearColor];
                la.textAlignment=NSTextAlignmentCenter;
                if (i!=0) {
                    la.textColor=_K_Color(97, 97, 97);
                }
                la.font=[UIFont boldSystemFontOfSize:14];
                la.tag = i+200;
                [button addSubview:la];
            }
        }
    }
    else{
    }
    
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    nothingView.hidden = NO;
    [self failedPrompt:@"网络请求失败"];
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    NSInteger index = request.tag;
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSArray *arr = [dicBig objectForKey:@"free_list"];
        for(NSDictionary *dic in arr){
            ClassifyModel *class = [[ClassifyModel alloc]init];
            class.free_price = [dic objectForKey:@"free_price"];
            class.free_name = [dic objectForKey:@"free_name"];
            class.free_id = [dic objectForKey:@"free_id"];
            class.free_count = [dic objectForKey:@"free_count"];
            class.free_acc = [dic objectForKey:@"free_acc"];
            [dataArray addObject:class];
        }
        [dataDict setObject:dataArray forKey:@(index)];
        UITableView *tv = self.tableViewArray[index];
        if (dataArray.count == 0) {
            tv.hidden = YES;
            nothingView.hidden = NO;
        }else{
            tv.hidden = NO;
            nothingView.hidden = YES;
        }
        [tv reloadData];
//        loadingV.hidden = YES;
        [SYObject endLoading];
    }
    else{
//        loadingV.hidden = YES;
        [SYObject endLoading];
        nothingView.hidden = NO;
    }
    
}
#pragma mark  - 点击事件
-(void)classBtnClicked:(UIButton *)btn{
    classTag = btn.tag-100;
    [containerScrollView setContentOffset:CGPointMake(classTag*containerScrollView.frame.size.width, 0) animated:NO];
    UITableView *currentTV = self.tableViewArray[classTag];
    [currentTV setContentOffset:CGPointMake(0, 0) animated:NO];
    labelTag = classTag+200;
    currentLabel.textColor = _K_Color(97, 97, 97);
    UILabel *la=[btn viewWithTag:labelTag];
    currentLabel = la;
    la.textColor = _K_Color(241, 83, 83);

    CGRect frame=CGRectMake(btn.frame.origin.x+10,38,btn.frame.size.width-20, 2);
    [UIView animateWithDuration:0.5 animations:^{
       [redBar setFrame:frame];
        if (frame.origin.x+frame.size.width>ScreenFrame.size.width) {
            [TopScrollView setContentOffset:CGPointMake(frame.origin.x, 0) animated:YES];
        }else{
            [TopScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }

    }];
    

    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,ZERO_LIST_URL];
    NSDictionary *par;
    if(class_dataArray.count!=0){
        if (btn.tag == 100) {
            par = @{
                    @"class_id":@"",
                    @"begin_count":@"0",
                    @"select_count":@"20",
                    };
        }else{
            ClassifyModel *claa = [class_dataArray objectAtIndex:btn.tag-101];
            par = @{
                    @"class_id":[NSString stringWithFormat:@"%@",claa.goods_id],
                    @"begin_count":@"0",
                    @"select_count":@"20",
                    };
        }
    }
    //网络请求
    [[Requester manager]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger index = classTag;
        NSInteger statuscode2 = operation.response.statusCode;
        if (statuscode2 == 200) {
            if (dataArray.count!=0) {
                [dataArray removeAllObjects];
            }
            NSDictionary *dicBig = responseObject;
            NSArray *arr = [dicBig objectForKey:@"free_list"];
            NSMutableArray *arr1 = [NSMutableArray array];
            for(NSDictionary *dic in arr){
                ClassifyModel *class = [[ClassifyModel alloc]init];
                class.free_price = [dic objectForKey:@"free_price"];
                class.free_name = [dic objectForKey:@"free_name"];
                class.free_id = [dic objectForKey:@"free_id"];
                class.free_count = [dic objectForKey:@"free_count"];
                class.free_acc = [dic objectForKey:@"free_acc"];
                [arr1 addObject:class];
            }
            [dataDict setObject:arr1 forKey:@(index)];
            
            
            UITableView *tv = self.tableViewArray[index];
            [tv reloadData];
            if (arr1.count == 0) {
                tv.backgroundView = [SYObject noDataView];
            }else{
                tv.backgroundView = nil;
            }
            [SYObject endLoading];
        }
        else{
            [SYObject endLoading];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ;
    }];
}
-(void)btnClicked:(UIButton *)btn{
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
    if([fileManagerDong fileExistsAtPath:filePathDong] == NO){
        NewLoginViewController *new = [[NewLoginViewController alloc]init];
        [self.navigationController pushViewController:new animated:YES];
    }else{
        supplyTag = btn.tag -100;
        //首先，判断用户是否登录。若登录，（1）没有填写过收货地址信息时，则跳转到填写收货地址，并且提交申请页面（2）填写过收货地址，则直接拿到默认的收货地址，并且增加编辑、设为默认地址按钮
//        loadingV.hidden = NO;
        //发起请求 判断用户是否可以申请免费试用
        NSArray *keyArr = [[NSArray alloc]initWithObjects:@"user_id",@"token", nil];
        NSArray *valueArr = [[NSArray alloc]initWithObjects:[USER_INFORMATION objectAtIndex:3] ,[USER_INFORMATION objectAtIndex:1], nil];
        request_4 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,ZERO_SUPPLY_VALIDATE_URL] setKey:keyArr setValue:valueArr];
        request_4.delegate = self;
        [request_4 setDidFailSelector:@selector(supply_urlRequestFailed:)];
        [request_4 setDidFinishSelector:@selector(supply_urlRequestSucceeded:)];
        [request_4 startAsynchronous];
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
    
    //发起相应classTag的请求
    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ZERO_LIST_URL]];
    request_6=[ASIFormDataRequest requestWithURL:url3];
    if (classTag == 0){
        [request_6 setPostValue:[NSString stringWithFormat:@"%lu",(unsigned long)dataArray.count] forKey:@"begincount"];
        [request_6 setPostValue:@"" forKey:@"class_id"];
        [request_6 setPostValue:@"20" forKey:@"selectcount"];
    }else{
        if(class_dataArray.count!=0){
            ClassifyModel *claa = [class_dataArray objectAtIndex:classTag-1];
            [request_6 setPostValue:[NSString stringWithFormat:@"%lu",(unsigned long)dataArray.count] forKey:@"begincount"];
            [request_6 setPostValue:[NSString stringWithFormat:@"%@",claa.goods_id] forKey:@"class_id"];
            [request_6 setPostValue:@"20" forKey:@"selectcount"];
        }
    }
    
    [request_6 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_6.tag = 101;
    request_6.delegate = self;
    [request_6 setDidFailSelector:@selector(up_urlRequestFailed:)];
    [request_6 setDidFinishSelector:@selector(up_urlRequestSucceeded:)];
    [request_6 startAsynchronous];
    
    
}
-(void)up_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)up_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
//        loadingV.hidden = YES;
        [SYObject endLoading];
        if (dataArrayShangla.count!=0) {
            [dataArrayShangla removeAllObjects];
        }
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSArray *arr = [dicBig objectForKey:@"free_list"];
        for(NSDictionary *dic in arr){
            ClassifyModel *class = [[ClassifyModel alloc]init];
            class.free_price = [dic objectForKey:@"free_price"];
            class.free_name = [dic objectForKey:@"free_name"];
            class.free_id = [dic objectForKey:@"free_id"];
            class.free_count = [dic objectForKey:@"free_count"];
            class.free_acc = [dic objectForKey:@"free_acc"];
            [dataArrayShangla addObject:class];
        }
        [dataArray addObjectsFromArray:dataArrayShangla];
        for (UITableView *tv in self.tableViewArray) {
            [tv reloadData];
        }
//        loadingV.hidden = YES;
        [SYObject endLoading];
        requestBool = YES;
    }
    else{
//        loadingV.hidden = YES;]
        [SYObject endLoading];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        for (UITableView *tv in self.tableViewArray) {
            [tv reloadData];
        }
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        for (UITableView *tv in self.tableViewArray) {
            [tv footerEndRefreshing];
        }
    });
}


@end
