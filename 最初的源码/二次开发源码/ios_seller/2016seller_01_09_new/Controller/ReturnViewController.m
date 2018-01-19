//
//  ReturnViewController.m
//  2016seller_01_09_new
//
//  Created by barney on 16/1/16.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

#import "ReturnViewController.h"
#import "ReturnRefundNewCell.h"
#import "ReturnModel.h"

@interface ReturnViewController ()
{
    NSMutableArray *dataArray;//tableView数据源
    UITableView *returnTabView;//退货列表
    int count;//加载计数
    UITextField *textField;
    UIView *nodata;//空状态视图
}
@end
@implementation ReturnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);//背景颜色设置
    self.title = @"退货管理";//标题栏标题
    
    if (UIDeviceSystem>=7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;//自动调整属性设置为NO
    }else{
    }
    dataArray=[[NSMutableArray alloc]init];
    //退货列表
    returnTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    nodata = [MyObject noDataViewForTableView:returnTabView];
    returnTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    returnTabView.delegate = self;
    returnTabView.dataSource=  self;
    returnTabView.showsVerticalScrollIndicator=NO;
    returnTabView.showsHorizontalScrollIndicator = NO;
    returnTabView.backgroundColor=UIColorFromRGB(0xf5f5f5);
    returnTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    returnTabView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    count=1;
    [self.view addSubview:returnTabView];
    [self getNetWorking];//调用网络请求
    

}
//网络请求
- (void)getNetWorking
{
    [MyObject startLoading];//遮罩
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,RETURN_LIST_URL];
    //参数字典
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken],
                          @"begin_count":@"0",
                          @"select_count":[NSString stringWithFormat:@"%d",count*10]
                          };
    //发起请求
    [[MyNetTool managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MyObject endLoading];
        NSDictionary * dicBig=responseObject;//数据字典
        NSLog(@"退货列表123///%@",dicBig);
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
                
                NSArray *ary=[dicBig objectForKey:@"returnGoodsLog"];
                for (NSDictionary *dic in ary)
                {
                    ReturnModel *model=[[ReturnModel alloc]init];
                    //kvc  模型赋值
                    [model setValuesForKeysWithDictionary:dic];
                    
                    [dataArray addObject:model];//数据源添加元素
                }
                [returnTabView reloadData];//刷新列表
                
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@",[error localizedDescription]);
         [MyObject endLoading];//结束遮罩
         
     }];
    
    
}
#pragma mark -上拉刷新、下拉加载
-(void)headerRereshing
{
    [self getNetWorking];//请求数据
    [returnTabView.mj_header endRefreshing];//结束刷新
}
-(void)footerRereshing{
    count ++;//计数加1
    [self getNetWorking];//请求数据
    [returnTabView.mj_footer endRefreshing];//结束加载
}
//跳转登陆界面
-(void)doTimer_signout
{
    [LJControl cleanAll];
    AppDelegate *app = [AppDelegate sharedUserDefault];
    app.log_View.hidden = NO;//显示登陆界面
}
#pragma mark - UITableView
//设置tableView的行数
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
//设置tableView每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 178.5+44*2+20;
    
}
//设置tableView的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myTabelviewCell = @"ReturnRefundNewCell";
    ReturnRefundNewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReturnRefundNewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = GRAY_COLOR;
    }else{
        for (UIView *subView in cell.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    if (dataArray.count!=0) {
        ReturnModel *mymodel = [dataArray objectAtIndex:indexPath.row];
        [cell my_cell:mymodel];
        if ([mymodel.goods_return_status intValue] == 1||[mymodel.goods_return_status intValue] == 5){
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
        }else if ([mymodel.goods_return_status intValue] == 6||[mymodel.goods_return_status intValue] == 7){
            
            UIButton *over_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            over_btn.frame = CGRectMake(self.view.frame.size.width-118-6, 198.5+44, 110, 44);
            over_btn.tag = indexPath.row;
            [over_btn addTarget:self action:@selector(cellSurebtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:over_btn];
        }
    }
    return cell;
    
}
//审核通过按钮点击事件
-(void)cellPassbtnClicked:(UIButton *)btn
{
    [OHAlertView showAlertWithTitle:@"提示" message:@"请输入收货地址" alertStyle:(OHAlertViewStylePlainTextInput) cancelButton:@"取消" otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex)
     {
         textField=[alert textFieldAtIndex:0];
         if (buttonIndex==1) {
             if (textField.text.length>0) {
             
             ReturnModel *returnModel = dataArray[btn.tag];
             NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,RETURN_BTN_URL];
             //参数字典
             NSDictionary *par = @{
                                   @"user_id":[MyNetTool currentUserID],
                                   @"token":[MyNetTool currentToken],
                                   @"return_goods_id":[NSString stringWithFormat:@"%@",returnModel.return_goods_id],
                                   @"goods_return_status":@"6",
                                   @"self_address":textField.text
                                   };
             //发起请求
             [[MyNetTool managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
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
                         NSString *ret=[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"op_title"]];
                         [MyObject failedPrompt:ret];
                         [self getNetWorking];
                         
                     }
                 }
                 
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error)
              {
                  NSLog(@"%@",[error localizedDescription]);
                  
                  
              }];

         }
             else
             {
             [OHAlertView showAlertWithTitle:@"提示" message:@"输入内容不能为空" alertStyle:(OHAlertViewStyleDefault) cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                 
             }];
             
             
             }
         }
         
     }];
}
//审核拒绝按钮点击事件
-(void)cellRefusebtnClicked:(UIButton *)btn
{
    [OHAlertView showAlertWithTitle:@"提示" message:@"亲, 您确定审核拒绝吗?" alertStyle:(OHAlertViewStyleDefault) cancelButton:@"取消" otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
        if (buttonIndex==1) {
            
        [MyObject startLoading];
        ReturnModel *returnModel = dataArray[btn.tag-1];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,RETURN_BTN_URL];
        //参数字典
        NSDictionary *par = @{
                              @"user_id":[MyNetTool currentUserID],
                              @"token":[MyNetTool currentToken],
                              @"return_goods_id":[NSString stringWithFormat:@"%@",returnModel.return_goods_id],
                              @"goods_return_status":@"-1",
                              @"self_address":@""
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
                    NSString *ret=[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"op_title"]];
                    [MyObject failedPrompt:ret];
                    [self getNetWorking];
                    
                    
                }
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"%@",[error localizedDescription]);
             
             
         }];
        }

        
    }];
 
}
//确认收货按钮点击事件
-(void)cellSurebtnClicked:(UIButton *)btn
{
     ReturnModel *mymodel = [dataArray objectAtIndex:btn.tag];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,RETURN_SURE_URL];
    //参数字典
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken],
                          @"return_goods_id":[NSString stringWithFormat:@"%@",mymodel.return_goods_id]
                          
                          };
    //发起请求
    [[MyNetTool managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
                    [MyObject failedPrompt:@"请求成功"];
                    [self getNetWorking];
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
