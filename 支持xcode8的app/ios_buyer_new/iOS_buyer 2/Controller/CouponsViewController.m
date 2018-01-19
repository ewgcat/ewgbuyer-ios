//
//  CouponsViewController.m
//  My_App
//
//  Created by apple on 14-8-6.
//  赵涵 2015.11.17 优化
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "CouponsViewController.h"
#import "ASIFormDataRequest.h"
#import "CouponsCell.h"
#import "ThirdViewController.h"
#import "UIImageView+WebCache.h"
#import "FreeCouponsViewController.h"

@interface CouponsViewController ()
{
@private UIView * btnView;
@private UIButton * unUsedBtn;
@private UIButton * usedBtn;
@private UIButton * outTimeBtn;
@private UIView * redView;
@private UIButton * moreCoupon;
@protected UIView * moreCouponView;
@protected UIButton * bottomRightBtn;
@protected NSString * status;
}
@end

@implementation CouponsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"优惠券";
    status=@"0";
    dataArrShangla = [[NSMutableArray alloc]init];
    dataArray = [[NSMutableArray alloc]init];
    [self createBackBtn];
    [self createView];
    [self downloadData];
}
-(void) createView
{
    /***************** 创建底部更多好券*******************/
    moreCouponView=[[UIView alloc] initWithFrame:CGRectMake(10, ScreenFrame.size.height-64-45, ScreenFrame.size.width-20, 40)];
    moreCouponView.backgroundColor=[UIColor whiteColor];
    [moreCouponView.layer setCornerRadius:5];
    CALayer * bottomLayer = [moreCouponView layer];
    bottomLayer.borderColor = [UIColorFromRGB(0XD3D3D3) CGColor];
    bottomLayer.borderWidth = 1.0f;
    [self.view addSubview:moreCouponView];
    // 底部文字
    moreCoupon=[MyUtil createBtnFrame:CGRectMake(0, 5,ScreenFrame.size.width-50, 30) title:@"更多好券，去领券中心看看" image:nil highlighImage:nil selectImage:nil target:self action:@selector(topBtnClick:)];
    [moreCoupon.titleLabel setFont:[UIFont systemFontOfSize:16]];
    moreCoupon.tag=1004;
    [moreCouponView addSubview:moreCoupon];
    // 向右的按钮
    bottomRightBtn=[MyUtil createBtnFrame:CGRectMake(ScreenFrame.size.width-50, 10, 20, 20) title:nil image:@"bottomRightBtn" highlighImage:nil selectImage:nil target:self action:@selector(topBtnClick:)];
    bottomRightBtn.tag=1005;
    [moreCouponView addSubview:bottomRightBtn];
    
    /***************** 创建顶部按钮和滑动小条*******************/
    btnView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 47)];
    btnView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:btnView];
    CALayer * mylayer = [btnView layer];
    mylayer.borderColor = [UIColorFromRGB(0XDCDCDC) CGColor];
    mylayer.borderWidth = 1.0f;
    
    unUsedBtn=[MyUtil createBtnFrame:CGRectMake(0, 0, ScreenFrame.size.width/3, 45) title:@"未使用" image:nil highlighImage:nil selectImage:nil target:self action:@selector(topBtnClick:)];
    unUsedBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [unUsedBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    unUsedBtn.tag=1001;
    [btnView addSubview:unUsedBtn];
    
    usedBtn=[MyUtil createBtnFrame:CGRectMake(ScreenFrame.size.width/3, 0, ScreenFrame.size.width/3, 45) title:@"已使用" image:nil highlighImage:nil selectImage:nil target:self action:@selector(topBtnClick:)];
    usedBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    usedBtn.tag=1002;
    [btnView addSubview:usedBtn];
    
    outTimeBtn=[MyUtil createBtnFrame:CGRectMake(ScreenFrame.size.width/3*2, 0, ScreenFrame.size.width/3, 45) title:@"已过期" image:nil highlighImage:nil selectImage:nil target:self action:@selector(topBtnClick:)];
    outTimeBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    outTimeBtn.tag=1003;
    [btnView addSubview:outTimeBtn];
    
    redView=[[UIView alloc] initWithFrame:CGRectMake(20, 45, ScreenFrame.size.width/3-40, 1)];
    redView.backgroundColor=[UIColor redColor];
    [btnView addSubview:redView];
    
    /*****************  tableView 创建 上拉 手势 刷新圈*******************/
    ShjTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    ShjTableView.delegate =self;
    ShjTableView.dataSource= self;
    ShjTableView.showsVerticalScrollIndicator=NO;
    ShjTableView.showsHorizontalScrollIndicator = NO;
    ShjTableView.frame=CGRectMake(0, 47, ScreenFrame.size.width, ScreenFrame.size.height-111);
    ShjTableView.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    //ShjTableView.backgroundColor=[UIColor whiteColor];
    // 加入上拉刷新
    [ShjTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    // 右滑手势返回上一个页面
    UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backBtnClicked)];
    rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
    [ShjTableView addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];
    // xib的模拟转圈
    [SYObject startLoading];
}
-(void) topBtnClick:(UIButton *) btn
{
    [self setBtnBlack];
    // 未使用
    if(btn.tag==1001)
    {
        [unUsedBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            redView.frame=CGRectMake(20, 45, ScreenFrame.size.width/3-40, 1);
        }];
        status=@"0";
        [self downloadData];
    }
    // 已使用
    if(btn.tag==1002)
    {
        [usedBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            redView.frame=CGRectMake(20+ScreenFrame.size.width/3, 45, ScreenFrame.size.width/3-40, 1);
        }];
        status=@"1";
        [self downloadData];
    }
    // 已过期
    if(btn.tag==1003)
    {
        [outTimeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            redView.frame=CGRectMake(20+ScreenFrame.size.width/3*2, 45, ScreenFrame.size.width/3-40, 1);
        }];
        status=@"-1";
        [self downloadData];
    }
    // 更多好券
    if(btn.tag==1004 || btn.tag==1005)
    {
        FreeCouponsViewController *freeCoupons = [[FreeCouponsViewController alloc]init];
        [self.navigationController showViewController:freeCoupons sender:nil];
    }
}
-(void) setBtnBlack
{
    [unUsedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [usedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [outTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
#pragma mark- ASIrequest
-(void) downloadData
{
    //发起请求优惠劵
    NSURL *url2 = [NSURL URLWithString:
                   [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&beginCount=%d&selectCount=%d&status=%@",
                    FIRST_URL,
                    COUPONS_URL,
                    [[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:3],
                    [[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:1],
                    0,
                    20,
                    status]];
    request_1=[ASIFormDataRequest requestWithURL:url2];
    [request_1 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_1.tag = 102;
    request_1.delegate =self;
    [request_1 setDidFailSelector:@selector(my3_urlRequestFailed:)];
    [request_1 setDidFinishSelector:@selector(my3_urlRequestSucceeded:)];
    [request_1 startAsynchronous];
}
// 请求成功(第一次进入页面的请求)
-(void)my3_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"优惠券result===========%@", dicBig);
        // 每次请求都清空数据源
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        if (dicBig) {
            if ([[dicBig objectForKey:@"ret"] isEqualToString:@"false"]) {
            }else{
                NSArray *arr = [dicBig objectForKey:@"coupon_list"];
                for(NSDictionary *dic in arr){
                    ClassifyModel *clas = [[ClassifyModel alloc]init];
                    clas.coupon_addTime = [dic objectForKey:@"coupon_addTime"];
                    clas.coupon_amount = [dic objectForKey:@"coupon_amount"];
                    clas.coupon_beginTime =[dic objectForKey:@"coupon_beginTime"];
                    clas.coupon_endTime = [dic objectForKey:@"coupon_endTime"];
                    clas.coupon_id = [dic objectForKey:@"coupon_id"];
                    clas.coupon_info = [dic objectForKey:@"coupon_info"];
                    clas.coupon_name = [dic objectForKey:@"coupon_name"];
                    clas.coupon_order_amount = [dic objectForKey:@"coupon_order_amount"];
                    clas.coupon_sn = [dic objectForKey:@"coupon_sn"];
                    clas.coupon_status = [dic objectForKey:@"coupon_status"];
                    clas.coupon_store_name=[dic objectForKey:@"store_name"];
                    NSLog(@"coupon_info:%@",clas.coupon_info);
                    NSLog(@"coupon_status:%@",clas.coupon_status);
                    NSLog(@"coupon_sn:%@",clas.coupon_sn);
                    NSLog(@"coupon_name:%@",clas.coupon_name);
                    NSLog(@"coupon_store_name:%@",clas.coupon_store_name);
                    [dataArray addObject:clas];
                }
            }
            if (dataArray.count ==0) {
                ShjTableView.hidden = YES;
                nothingImage.hidden = NO;
                nothingLabel.hidden = NO;
            
            }else{
                ShjTableView.hidden = NO;
                nothingImage.hidden = YES;
                nothingLabel.hidden = YES;
            }
            [SYObject endLoading];
            // 下载成功刷新数据源
            [ShjTableView reloadData];
        }
    }
    else{
        [self failedPrompt:@"请求出错"];
    }
}
-(void)my3_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
// 失败调用
-(void)failedPrompt:(NSString *)prompt{
    [SYObject endLoading];
    [SYObject failedPrompt:prompt];
}
#pragma mark - 返回按钮
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    [request103 cancel];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArray.count!=0) {
        return dataArray.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 132;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *shjTabelviewCell = @"CouponsCell";
    CouponsCell *cell = [tableView dequeueReusableCellWithIdentifier:shjTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CouponsCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (dataArray.count !=0) {
        ClassifyModel *cla = [dataArray objectAtIndex:indexPath.row];
        // 价钱
        cell.coupons_price.text = [NSString stringWithFormat:@"%@",cla.coupon_amount];
        cell.coupons_price.textColor=UIColorFromRGB(0X45ABE8);
        // 满可用
        cell.price.text = [NSString stringWithFormat:@"满%@元可用",cla.coupon_order_amount];
        cell.price.textColor=UIColorFromRGB(0X4E4E4E);
        // 店铺名称
        cell.store_name.text=cla.coupon_store_name;
        cell.store_name.textColor=UIColorFromRGB(0X4E4E4E);
        // 日期
        cell.time.text = [NSString stringWithFormat:@"  %@至%@",cla.coupon_beginTime,cla.coupon_endTime];
        cell.time.textColor=UIColorFromRGB(0X6B6B6B);
        // 背景和￥颜色
        cell.price.backgroundColor = [UIColor clearColor];
        cell.priceSymbol.textColor=UIColorFromRGB(0X45ABE8);
        // 蛋疼的线
        cell.bottomLine.backgroundColor=UIColorFromRGB(0XECECEC);
        if ([status isEqualToString:@"0"]) {
            cell.priceSymbol.textColor=UIColorFromRGB(0X007AFF);
            cell.coupons_price.textColor=UIColorFromRGB(0X45ABE8);
            cell.price.textColor=UIColorFromRGB(0X4E4E4E);
            cell.store_name.textColor=UIColorFromRGB(0X4E4E4E);
            cell.time.textColor=UIColorFromRGB(0X6B6B6B);
            cell.priceSymbol.textColor=UIColorFromRGB(0X45ABE8);
            cell.bottomLine.backgroundColor=UIColorFromRGB(0XECECEC);
        }else if ([status isEqualToString:@"1"]){
            cell.priceSymbol.textColor=UIColorFromRGB(0Xc3c3c3);
            cell.coupons_price.textColor=UIColorFromRGB(0Xc3c3c3);
            cell.price.textColor=UIColorFromRGB(0Xc3c3c3);
            cell.store_name.textColor=UIColorFromRGB(0Xc3c3c3);
            cell.time.textColor=UIColorFromRGB(0Xc3c3c3);
            cell.priceSymbol.textColor=UIColorFromRGB(0Xc3c3c3);
            cell.bottomLine.backgroundColor=UIColorFromRGB(0Xc3c3c3);
        }else if ([status isEqualToString:@"-1"]){
            cell.priceSymbol.textColor=UIColorFromRGB(0Xc3c3c3);
            cell.coupons_price.textColor=UIColorFromRGB(0Xc3c3c3);
            cell.price.textColor=UIColorFromRGB(0Xc3c3c3);
            cell.store_name.textColor=UIColorFromRGB(0Xc3c3c3);
            cell.time.textColor=UIColorFromRGB(0Xc3c3c3);
            cell.priceSymbol.textColor=UIColorFromRGB(0Xc3c3c3);
            cell.bottomLine.backgroundColor=UIColorFromRGB(0Xc3c3c3);
        
        }
        
        
        // 优惠券淡灰色边框
        CALayer * cellLayer = [cell.backgroundImage layer];
        cellLayer.borderColor = [UIColorFromRGB(0XD3D3D3) CGColor];
        cellLayer.borderWidth = 1.0f;
    }
    return cell;
}
#pragma mark - 上拉刷新
-(void)footerRereshing{
    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,COUPONS_URL]];
    request102=[ASIFormDataRequest requestWithURL:url3];
    NSArray *fileContent2 =[MyUtil returnLocalUserFile];
    [request102 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request102 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    [request102 setPostValue:[NSString stringWithFormat:@"%lu",(unsigned long)dataArray.count] forKey:@"beginCount"];
    [request102 setPostValue:@"20" forKey:@"selectCount"];
    [request102 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request102.tag = 102;
    [request102 setDelegate:self];
    [request102 setDidFailSelector:@selector(my1_urlRequestFailed:)];
    [request102 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
    [request102 startAsynchronous];
}
#pragma mark - 网络上拉刷新
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if (dataArrShangla.count!=0) {
            [dataArrShangla removeAllObjects];
        }
        NSArray *arr = [dicBig objectForKey:@"coupon_list"];
        for(NSDictionary *dic in arr){
            ClassifyModel *clas = [[ClassifyModel alloc]init];
            clas.coupon_addTime = [dic objectForKey:@"coupon_addTime"];
            clas.coupon_amount = [dic objectForKey:@"coupon_amount"];
            clas.coupon_beginTime =[dic objectForKey:@"coupon_beginTime"];
            clas.coupon_endTime = [dic objectForKey:@"coupon_endTime"];
            clas.coupon_id = [dic objectForKey:@"coupon_id"];
            clas.coupon_info = [dic objectForKey:@"coupon_info"];
            clas.coupon_name = [dic objectForKey:@"coupon_name"];
            clas.coupon_order_amount = [dic objectForKey:@"coupon_order_amount"];
            clas.coupon_sn = [dic objectForKey:@"coupon_sn"];
            clas.coupon_status = [dic objectForKey:@"coupon_status"];
            [dataArray addObject:clas];
        }
    }else{
        [self failedPrompt:@"请求出错"];
    }
    //requestBool = YES;
    [dataArray addObjectsFromArray:dataArrShangla];
    [ShjTableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [ShjTableView reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [ShjTableView footerEndRefreshing];
    });
}
-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request_1 clearDelegatesAndCancel];
    [request102 clearDelegatesAndCancel];
    [request103 clearDelegatesAndCancel];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
