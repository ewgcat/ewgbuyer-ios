//
//  EvaluationViewController.m
//  2016seller_01_09_new
//
//  Created by barney on 16/1/9.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

#import "EvaluationViewController.h"
#import "EvaluateCell.h"
#import "EvaluateModel.h"
#import "EvaluateDetailViewController.h"
@interface EvaluationViewController ()
{
    NSMutableArray *dataArray;//tableView数据源
    UITableView *evaluateTabView;//评价列表
    int count;//加载计数
    UIView *nodata;//空状态视图

}
@end

@implementation EvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray=[[NSMutableArray alloc]init];//数据源初始化
    self.title=@"评价列表";//标题栏题目
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);//背景颜色
    if (UIDeviceSystem>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;//自动调整属性设置为NO
    }else{
    }
   

    //评价列表
    evaluateTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
   
    nodata = [MyObject noDataViewForTableView:evaluateTabView];
    evaluateTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    evaluateTabView.delegate = self;
    evaluateTabView.dataSource=  self;
    evaluateTabView.showsVerticalScrollIndicator=NO;
    evaluateTabView.showsHorizontalScrollIndicator = NO;
    evaluateTabView.backgroundColor=UIColorFromRGB(0xf5f5f5);
    evaluateTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    evaluateTabView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    count=1;
    [self.view addSubview:evaluateTabView];
    [self getNetWorking];//调用网络请求
    
    

}
//网络请求
- (void)getNetWorking
{
    [MyObject startLoading];//遮罩
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,EVALUATE_LIST_URL];
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
        NSLog(@"公告分类///%@",dicBig);
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
                
                NSArray *ary=[dicBig objectForKey:@"evaluate_list"];
                for (NSDictionary *dic in ary)
                {
                    EvaluateModel *model=[[EvaluateModel alloc]init];
                    //kvc  模型赋值
                    [model setValuesForKeysWithDictionary:dic];
                   
                    [dataArray addObject:model];//数据源添加元素
                }
                [evaluateTabView reloadData];//刷新列表
               
                
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
    [evaluateTabView.mj_header endRefreshing];//结束刷新
}
-(void)footerRereshing{
    count ++;//计数加1
    [self getNetWorking];//请求数据
    [evaluateTabView.mj_footer endRefreshing];//结束加载
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
    else {
        tableView.backgroundView = nodata;
        return 0;
    }
}
//设置tableView每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80.f;
    
}
//设置tableView的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName=@"evaluate";
    EvaluateCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell==nil)
    {
        cell =[[[NSBundle mainBundle] loadNibNamed:@"EvaluateCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
    }
    //从数据源中取出对应的模型
    EvaluateModel *model=[dataArray objectAtIndex:indexPath.row];
    //用模型给cell赋值
    [cell.img sd_setImageWithURL:[NSURL URLWithString:model.main_photo]placeholderImage:[UIImage imageNamed:@"loading"]];
    cell.titleLab.text=model.goods_name;
    cell.evaluate.text=model.evaluate_buyer_val;
    if (model.evaluate_info.length>0) {
        cell.evaluateContent.text=[NSString stringWithFormat:@"评价: %@",model.evaluate_info];
    }else
    {
    cell.evaluateContent.text=@"暂无评价";
    
    }
    
    return cell;
    
}
//cell的点击方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //从数据源中取出对应的模型
    EvaluateModel *model=[dataArray objectAtIndex:indexPath.row];
    //跳转评价详情界面
    EvaluateDetailViewController *evaDetail=[[EvaluateDetailViewController alloc]init];
    evaDetail.evaID=model.eva_id;//将评价id传给下级界面
    [self.navigationController pushViewController:evaDetail animated:YES];
   
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
