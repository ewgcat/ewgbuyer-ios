//
//  RefundNewViewController.m
//  2016seller_01_09_new
//
//  Created by barney on 16/1/16.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

#import "RefundNewViewController.h"
#import "ReturnRefundNewCell.h"
#import "RefundModel.h"
#import "RefundCell.h"
#import "OrderDetailViewController.h"
@interface RefundNewViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *refundTableview;//tableView列表
    NSMutableArray *dataArray;//数据源数组
    UISegmentedControl *MysegmentControl;
    int count;//加载计数
    
    NSString *order_status;//订单状态
    NSInteger labelTag;
    UIView *nodata;//空状态视图
}
@end

@implementation RefundNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);//背景颜色设置
    self.title = @"退款管理";//标题栏标题
    count=1;
    labelTag = 0;
    order_status=@"0";//默认为待审核状态
    
    if (UIDeviceSystem>=7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;//自动调整属性设置为NO
    }else{
    }
    dataArray = [[NSMutableArray alloc]init];
    NSArray *array=@[@"待审核",@"全部",@"已通过",@"已拒绝",@"已退款"];
    MysegmentControl=[[UISegmentedControl alloc]initWithItems:array];
    MysegmentControl.frame=CGRectMake(10, 74, ScreenFrame.size.width-20, 34);
    MysegmentControl.selectedSegmentIndex=0;
    MysegmentControl.tintColor =UIColorFromRGB(0X2196f3);
    [MysegmentControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    MysegmentControl.backgroundColor = UIColorFromRGB(0Xffffff);
    
    [self.view addSubview:MysegmentControl];
    
    refundTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+118, ScreenFrame.size.width, ScreenFrame.size.height-118)];
    nodata = [MyObject noDataViewForTableView:refundTableview];//调用空状态视图
    //退款列表的设置
    refundTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    refundTableview.delegate = self;
    refundTableview.dataSource=  self;
    refundTableview.showsVerticalScrollIndicator=NO;
    refundTableview.showsHorizontalScrollIndicator = NO;
    refundTableview.backgroundColor =UIColorFromRGB(0xf5f5f5);
    refundTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    refundTableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [self.view addSubview:refundTableview];
    [self getNetWorking];//调用网络请求
}
#pragma mark -上拉刷新、下拉加载
-(void)headerRereshing
{
    [self getNetWorking];//请求数据
    [refundTableview.mj_header endRefreshing];//结束刷新
}
-(void)footerRereshing{
    count ++;//计数加1
    [self getNetWorking];//请求数据
    [refundTableview.mj_footer endRefreshing];//结束加载
}
//网络请求
- (void)getNetWorking
{
    [MyObject startLoading];//遮罩
    if (labelTag == 0) {
        order_status=@"0";
        MysegmentControl.selectedSegmentIndex = 0;
    }else if (labelTag == 1) {
        order_status=@"";
        MysegmentControl.selectedSegmentIndex = 1;
    }else if (labelTag == 2) {
        order_status=@"10";
        MysegmentControl.selectedSegmentIndex = 2;
    }else if (labelTag == 3) {
        order_status=@"5";
        MysegmentControl.selectedSegmentIndex = 3;
    }else if (labelTag == 4) {
        MysegmentControl.selectedSegmentIndex = 4;
       order_status=@"15";
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,REFUND_LIST_URL];
    //参数字典
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken],
                          @"status":order_status,
                          @"begin_count":@"0",
                          @"select_count":[NSString stringWithFormat:@"%d",count*10]
                          };
    //发起请求
    [[MyNetTool managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MyObject endLoading];
        NSDictionary * dicBig=responseObject;//数据字典
        NSLog(@"退款列表///%@",dicBig);
        if (dataArray.count!=0)
        {
            [dataArray removeAllObjects];
        }
        if (dicBig)
        {
            if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"])
            {
                [self.navigationController popToRootViewControllerAnimated:NO];
                //登录过期，提示重新登录
                [MyObject failedPrompt:@"用户登录已过期，请重新登录"];
                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
                
            }
            else
            {
                
                NSArray *ary=[dicBig objectForKey:@"refundApplyForm"];
                for (NSDictionary *dic in ary)
                {
                    RefundModel *model=[[RefundModel alloc]init];
                    //kvc  模型赋值
                    [model setValuesForKeysWithDictionary:dic];
                    
                    [dataArray addObject:model];//数据源添加元素
                }
                [refundTableview reloadData];//刷新列表
               
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@",[error localizedDescription]);
         [MyObject endLoading];//结束遮罩
         
     }];
    
    
}

//跳转登陆界面
-(void)doTimer_signout
{
    [LJControl cleanAll];
    AppDelegate *app = [AppDelegate sharedUserDefault];
    app.log_View.hidden = NO;//显示登陆界面
}
#pragma mark - seg点击事件
-(void)change:(UISegmentedControl *)segmentControl{
    
    if (segmentControl.selectedSegmentIndex == 0) {
        
        labelTag = 0;
        
        if (labelTag == 0) {
            order_status=@"0";
            
        }else if (labelTag == 1) {
           order_status=@"";
        }else if (labelTag == 2) {
            order_status=@"10";
        }else if (labelTag == 3) {
           order_status=@"5";
        }else if (labelTag == 4) {
          order_status=@"15";
        }
        [self getNetWorking];
    }else if(segmentControl.selectedSegmentIndex == 1){
        
        labelTag = 1;
        [refundTableview reloadData];
        
        if (labelTag == 0) {
            order_status=@"0";
            
        }else if (labelTag == 1) {
            order_status=@"";
        }else if (labelTag == 2) {
            order_status=@"10";
        }else if (labelTag == 3) {
            order_status=@"5";
        }else if (labelTag == 4) {
            order_status=@"15";
        }
        [self getNetWorking];
    }else if(segmentControl.selectedSegmentIndex == 2){
        
        labelTag = 2;
        
        
        if (labelTag == 0) {
            order_status=@"0";
            
        }else if (labelTag == 1) {
            order_status=@"";
        }else if (labelTag == 2) {
            order_status=@"10";
        }else if (labelTag == 3) {
            order_status=@"5";
        }else if (labelTag == 4) {
            order_status=@"15";
        }
        [self getNetWorking];
    }else if(segmentControl.selectedSegmentIndex == 3){
        
        labelTag = 3;
        
        if (labelTag == 0) {
            order_status=@"0";
            
        }else if (labelTag == 1) {
            order_status=@"";
        }else if (labelTag == 2) {
            order_status=@"10";
        }else if (labelTag == 3) {
            order_status=@"5";
        }else if (labelTag == 4) {
            order_status=@"15";
        }
        [self getNetWorking];
    }else{
        
        labelTag = 4;
   
        if (labelTag == 0) {
            order_status=@"0";
            
        }else if (labelTag == 1) {
            order_status=@"";
        }else if (labelTag == 2) {
            order_status=@"10";
        }else if (labelTag == 3) {
            order_status=@"5";
        }else if (labelTag == 4) {
            order_status=@"15";
        }
        [self getNetWorking];
    }
    
}

#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArray.count!=0)
    {
        tableView.backgroundView = nil;
        return dataArray.count;
    }
    else{
        tableView.backgroundView = nodata;
        return 0;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 178.5+44*2+20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myTabelviewCell = @"RefundCell";
    RefundCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RefundCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = GRAY_COLOR;
    }else{
        for (UIView *subView in cell.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    if (dataArray.count!=0) {
        RefundModel *mymodel = [dataArray objectAtIndex:indexPath.row];
        [cell my_cell:mymodel];
        
        if ([mymodel.status intValue] == 0){
            UIButton *over_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            over_btn.frame = CGRectMake(self.view.frame.size.width-118-6, 198.5+44, 110, 44);
            over_btn.tag = indexPath.row;
            [over_btn addTarget:self action:@selector(cellPassbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:over_btn];
            
            UIButton *Price_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            Price_btn.frame = CGRectMake(self.view.frame.size.width-118-6-110, 198.5+44, 110, 44);
            Price_btn.tag = indexPath.row+1;
            [Price_btn addTarget:self action:@selector(cellRefusebtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:Price_btn];
        }

        
    }
    return cell;
}
-(void)cellPassbtnClicked:(UIButton *)btn
{
    [OHAlertView showAlertWithTitle:@"提示" message:@"亲, 您确定审核通过吗?" cancelButton:@"取消" otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
     
        if (buttonIndex==1) {
        [MyObject startLoading];
        RefundModel *refundModel = dataArray[btn.tag];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,REFUND_BTN_URL];
        //参数字典
        NSDictionary *par = @{
                              @"user_id":[MyNetTool currentUserID],
                              @"token":[MyNetTool currentToken],
                              @"apply_form_id":[NSString stringWithFormat:@"%@",refundModel.apply_form_id],
                              @"result":@"0"
                              
                              };
        //发起请求
        [[MyNetTool managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MyObject endLoading];
            NSDictionary * dicBig=responseObject;//数据字典
            NSLog(@"退货退款结果///%@",dicBig);
            
            if (dicBig)
            {
                if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"])
                {
                    [self.navigationController popToRootViewControllerAnimated:NO];
                    //登录过期，提示重新登录
                    [MyObject failedPrompt:@"用户登录已过期，请重新登录"];
                    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
                    
                }
                else
                {
                    NSString *ret=[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"ret"]];
                    if ([ret isEqualToString:@"100"])
                    {   [self getNetWorking];
                        [MyObject failedPrompt:@"该审核已通过"];
                    }else
                    {
                        
                        [MyObject failedPrompt:@"请求失败"];
                    }
                    
                }
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"%@",[error localizedDescription]);
             
             
         }];
        
        }
    }];
   

}
-(void)cellRefusebtnClicked:(UIButton *)btn
{
    [OHAlertView showAlertWithTitle:@"提示" message:@"亲, 您确定审核拒绝吗?" cancelButton:@"取消" otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
        if (buttonIndex==1) {
        [MyObject startLoading];
        RefundModel *refundModel = dataArray[btn.tag-1];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,REFUND_BTN_URL];
        //参数字典
        NSDictionary *par = @{
                              @"user_id":[MyNetTool currentUserID],
                              @"token":[MyNetTool currentToken],
                              @"apply_form_id":[NSString stringWithFormat:@"%@",refundModel.apply_form_id],
                              @"result":@"1"
                              
                              };
        //发起请求
        [[MyNetTool managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MyObject endLoading];
            NSDictionary * dicBig=responseObject;//数据字典
            NSLog(@"退货退款结果///%@",dicBig);
            
            if (dicBig)
            {
                if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"])
                {
                    [self.navigationController popToRootViewControllerAnimated:NO];
                    //登录过期，提示重新登录
                    [MyObject failedPrompt:@"用户登录已过期，请重新登录"];
                    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
                    
                }
                else
                {
                    NSString *ret=[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"ret"]];
                    if ([ret isEqualToString:@"100"])
                    {
                        [self getNetWorking];
                        [MyObject failedPrompt:@"该审核已拒绝"];
                    }else
                    {
                        
                        [MyObject failedPrompt:@"请求失败"];
                    }
                    
                }
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"%@",[error localizedDescription]);
             
             
         }];

        }
    }];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (dataArray.count!=0) {
        RefundModel *mmm = [dataArray objectAtIndex:indexPath.row];
        OrderDetailViewController *order = [[OrderDetailViewController alloc]init];
        order.orderID=mmm.order_form_id;
        [self.navigationController pushViewController:order animated:YES];
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

@end
