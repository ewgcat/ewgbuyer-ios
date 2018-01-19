//
//  TransViewController.m
//  My_App
//
//  Created by barney on 15/12/2.
//  Copyright © 2015年 barney. All rights reserved.
//

#import "TransViewController.h"
#import "ASIFormDataRequest.h"
#import "UIImageView+WebCache.h"
#import "orderCell.h"
#import "Model.h"
#import "ThirdViewController.h"
#import "CheckViewController.h"
@interface TransViewController ()<UITableViewDataSource,UITabBarDelegate,UITableViewDelegate,ASIHTTPRequestDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@end

@implementation TransViewController
{
    UITableView *_tabView1;
    ASIFormDataRequest *request_1;
    NSMutableArray *dataArray;
    ThirdViewController *third;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"物流查询";
    [SYObject startLoading];
    [self createTabView];
    [self createBackBtn];
    dataArray = [[NSMutableArray alloc]init];
    [self downloadData];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}
#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1){  //关闭主界面的右滑返回
        return NO;
    }else{
        
        return YES;
    }
}
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createTabView
{
    _tabView1=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-64) style:(UITableViewStylePlain)];
    _tabView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tabView1.delegate =self;
    _tabView1.dataSource= self;
    _tabView1.showsVerticalScrollIndicator=NO;
    _tabView1.showsHorizontalScrollIndicator = NO;
   
    _tabView1.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    [self.view addSubview:_tabView1];


}
#pragma mark- ASIrequest
-(void) downloadData
{
    //发起请求
    NSURL *url = [NSURL URLWithString:
                   [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&beginCount=%d&selectCount=%d&order_cat=%d",
                    FIRST_URL,
                    ORDER_URL,
                    [[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:3],
                    [[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:1],
                    0,
                    20,0]];
    request_1=[ASIFormDataRequest requestWithURL:url];
    [request_1 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_1.delegate =self;
    [request_1 setDidFailSelector:@selector(my_urlRequestFailed:)];
    [request_1 setDidFinishSelector:@selector(my_urlRequestSucceeded:)];
    [request_1 startAsynchronous];
}

// 请求成功(第一次进入页面的请求)
-(void)my_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"物流result===========%@", dicBig);
        // 每次请求都清空数据源
        if (dataArray.count!=0)
        {
            [dataArray removeAllObjects];
        }
        if (dicBig) {
            
           NSArray *arr = [dicBig objectForKey:@"order_list"];
            for (NSDictionary *dic in arr) {
                Model *shjM = [[Model alloc]init];
                shjM.order_addTime = [dic objectForKey:@"addTime"];
                shjM.order_id = [dic objectForKey:@"order_id"];
                shjM.order_num = [dic objectForKey:@"order_num"];
                shjM.order_status = [dic objectForKey:@"order_status"];
                shjM.order_total_price = [dic objectForKey:@"order_total_price"];
                shjM.order_photo_list = [dic objectForKey:@"photo_list"];
                shjM.order_name_list = [dic objectForKey:@"name_list"];
                shjM.order_ship_price = [dic objectForKey:@"ship_price"];
                shjM.order_paytype = [dic objectForKey:@"payType"];
                [dataArray addObject:shjM];
            }
            if (dataArray.count ==0) {
                _tabView1.hidden = YES;
                

            }else{
                _tabView1.hidden = NO;
                
            }
            // 下载成功刷新数据源
            [_tabView1 reloadData];
            
        }
        
        else
        {
            [SYObject failedPrompt:@"请求出错"];
        }
    }
    [SYObject endLoading];
}
-(void)my_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}

#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (dataArray.count!=0)
    {
        return dataArray.count;
    }
        return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 210;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    static NSString *myTabelviewCell = @"orderCell";
    orderCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"orderCell" owner:self options:nil] lastObject];
    }
    if (dataArray.count != 0) {
        Model *shjM = [dataArray objectAtIndex:indexPath.row];
        cell.order_id.text = [NSString stringWithFormat:@"订单号:%@",shjM.order_num];
        
        NSArray *arr = (NSArray*)shjM.order_photo_list;
        NSArray *name_Array = (NSArray*)shjM.order_name_list;
        if (arr.count ==0) {
        }else if (arr.count==1){
            cell.muchView.hidden = YES;
            for(int i=0;i<arr.count;i++){
                [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:[arr objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"kong_lj.png"]];
                cell.nameLabel.text = [name_Array objectAtIndex:i];
            }
        }else{
            cell.muchView.hidden = NO;
            cell.scrollView.tag = 102;
            cell.scrollView.bounces = YES;
            cell.scrollView.delegate = self;
            cell.scrollView.userInteractionEnabled = YES;
            cell.scrollView.showsHorizontalScrollIndicator = NO;
            cell.scrollView.contentSize=CGSizeMake(65*arr.count+15,65);
            for(int i=0;i<arr.count;i++){
                UIImageView *imgTrademark = [[UIImageView alloc]initWithFrame:[SYObject orderCellImgFrameAtIndex:i]];
                imgTrademark.userInteractionEnabled = YES;
                [imgTrademark sd_setImageWithURL:[NSURL URLWithString:[arr objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"kong_lj.png"]];
                [cell.scrollView addSubview:imgTrademark];
            }
        }
        cell.priceLabel.text = [NSString stringWithFormat:@"商品金额:￥%@",shjM.order_total_price];
        
        if ([shjM.order_status intValue]==10) {
            cell.otherBtn.hidden = YES;
            cell.btn.hidden = NO;
            cell.statusLabel.text = @"待付款";
            [cell.btn setTitle:@"立即支付" forState:UIControlStateNormal];
            cell.btn.tag = indexPath.row+200;
            [cell.btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.otherBtn.tag = indexPath.row;
            [cell.otherBtn addTarget:self action:@selector(cancelbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else if([shjM.order_status intValue]==30){
            cell.btn.hidden = NO;
            cell.statusLabel.text = @"待收货";
            [cell.btn setTitle:@"确认收货" forState:UIControlStateNormal];
            cell.btn.tag = indexPath.row+400;
            [cell.btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.otherBtn.hidden = NO;
            [cell.otherBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            [cell setOtherBtnToActive];
            cell.otherBtn.tag = indexPath.row;
            [cell.otherBtn addTarget:self action:@selector(checkLogisticBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if([shjM.order_status intValue]==20){
            cell.btn.hidden = YES;
            cell.statusLabel.text = @"待发货";
            cell.otherBtn.hidden = YES;
        }else if([shjM.order_status intValue]==16){
            cell.btn.hidden = YES;
            cell.statusLabel.text = @"待发货";//详情 货到付款
            cell.otherBtn.hidden = YES;
        }else if([shjM.order_status intValue]==0){
            cell.btn.hidden = YES;
            cell.statusLabel.text = @"订单已取消";
            cell.otherBtn.hidden = YES;
        }else if([shjM.order_status intValue]==50){
            cell.btn.hidden = YES;
            cell.statusLabel.text = @"订单已完成";
        }else if([shjM.order_status intValue]==40){
            cell.btn.hidden = NO;
            cell.statusLabel.text = @"待评价";
            [cell.btn setTitle:@"立即评价" forState:UIControlStateNormal];
            cell.btn.tag = indexPath.row+600;
            [cell.btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.otherBtn.hidden = YES;
        }else if([shjM.order_status intValue]==65){
            cell.btn.hidden = YES;
            cell.statusLabel.text = @"不可评价";
            cell.otherBtn.hidden = YES;
        }
    }
    return cell;

    
    
}
-(void)btnClicked:(UIButton *)btn
{

}
-(void)cancelbtnClicked:(UIButton *)btn
{

}
-(void)checkLogisticBtnClicked:(UIButton *)btn
{
    Model *model = dataArray[btn.tag];
    third.train_order_id = model.order_id;
    CheckViewController *check = [CheckViewController new];
    [self.navigationController pushViewController:check animated:YES];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request_1 clearDelegatesAndCancel];
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

@end
