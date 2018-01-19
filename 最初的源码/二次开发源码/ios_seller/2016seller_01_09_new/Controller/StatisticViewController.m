//
//  StatisticViewController.m
//  SellerApp
//
//  Created by barney on 16/1/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "StatisticViewController.h"
#import "UIImageView+WebCache.h"
#import "includeCell.h"
#import "includeBottomCell.h"
#import "includeModel.h"
#import "accessCell.h"
#import "accessModel.h"
#import "GoodsPreviewViewController.h"

@interface StatisticViewController ()<UITableViewDataSource,UITabBarDelegate,UITableViewDelegate,UIScrollViewDelegate>
{
    UIView * btnView;
    UIButton * includeBtn;//概况按钮
    UIButton * accessBtn;//访问按钮
    UIButton * payBtn;//支付按钮
    UIView * redView;//下划线
    
    UITableView *_tabView;//概况
    UITableView *_tabView1;//访问
    UITableView *_tabView2;//支付
    UIScrollView *_scroll;
    NSMutableArray *dataArray;//概况界面数据源
    NSMutableArray *dataArray1;//访问界面数据源
    NSMutableArray *dataArray2;//支付界面数据源
    int count;//用于下拉加载计数
    
}

@end

@implementation StatisticViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //导航栏设置
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x2196f3);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);//背景颜色
    self.title = @"店铺统计";//界面标题
    
    if (UIDeviceSystem>=7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;//自动调整属性设置为NO
    }else{
    }
    //调用MyObject中封装的空状态界面
    [MyObject noDataViewIn:self.view];
    
    count=1;//默认计数为1
    //三个数据源初始化
    dataArray = [[NSMutableArray alloc]init];
    dataArray1 = [[NSMutableArray alloc]init];
    dataArray2 = [[NSMutableArray alloc]init];
    //整个scrollView的设置
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+47, ScreenFrame.size.width, ScreenFrame.size.height-64-47)];
    
    _scroll.contentSize=CGSizeMake(ScreenFrame.size.width*3, 0);
    _scroll.pagingEnabled=YES;
    _scroll.showsHorizontalScrollIndicator=NO;
    _scroll.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_scroll];
    _scroll.delegate=self;
    _scroll.backgroundColor=UIColorFromRGB(0xf5f5f5);
    
    [self createView];//设计界面
    [self downloadData];//发起概况界面的网络请求
    [self downloadData1];//访问界面的网络请求
    [self downloadData2];//支付界面的网络请求
    
    [self scrollToPage];//进入对应的页面
}
-(void)scrollToPage {
    switch (self.selectedTag) {
        case 2:{
            [_scroll setContentOffset:CGPointMake(ScreenFrame.size.width, 0)];
            break;
        }case 3:{
            [_scroll setContentOffset:CGPointMake(ScreenFrame.size.width * 2, 0)];
            break;
        }
        default:{
            break;
        }
    }
}
//界面设计
-(void)createView
{
    
    /***************** 创建顶部按钮和滑动小条*******************/
    btnView=[[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenFrame.size.width, 47)];
    btnView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:btnView];
    CALayer * mylayer = [btnView layer];
    mylayer.borderColor = [UIColorFromRGB(0XDCDCDC) CGColor];
    mylayer.borderWidth = 1.0f;
    //概况
    includeBtn=[LJControl buttonType:(UIButtonTypeCustom) setFrame:CGRectMake(0, 0, ScreenFrame.size.width/3, 45) setNormalImage:nil setSelectedImage:nil setTitle:@"概况" setTitleFont:15 setbackgroundColor:nil];
    [includeBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [includeBtn setTitleColor:UIColorFromRGB(0x2196f3) forState:UIControlStateNormal];
    includeBtn.tag=1001;
    [btnView addSubview:includeBtn];
    
    //访问
    accessBtn=[LJControl buttonType:(UIButtonTypeCustom) setFrame:CGRectMake(ScreenFrame.size.width/3, 0, ScreenFrame.size.width/3, 45) setNormalImage:nil setSelectedImage:nil setTitle:@"访问" setTitleFont:15 setbackgroundColor:nil];
    [accessBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [accessBtn setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    accessBtn.tag=1002;
    [btnView addSubview:accessBtn];
    
    //支付
    payBtn=[LJControl buttonType:(UIButtonTypeCustom) setFrame:CGRectMake(ScreenFrame.size.width/3*2, 0, ScreenFrame.size.width/3, 45) setNormalImage:nil setSelectedImage:nil setTitle:@"支付" setTitleFont:15 setbackgroundColor:nil];
    [payBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    payBtn.tag=1003;
    [payBtn setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    [btnView addSubview:payBtn];
    
    //下划线
    redView=[[UIView alloc] initWithFrame:CGRectMake(30, 45, ScreenFrame.size.width/3-60, 1)];
    redView.backgroundColor=UIColorFromRGB(0x2196f3);
    [btnView addSubview:redView];
    
    /*****************  tableView 创建 上拉 手势 刷新圈*******************/
    //概况
    _tabView=[[UITableView alloc]initWithFrame:CGRectMake(0, 7, ScreenFrame.size.width, ScreenFrame.size.height-47-64) style:(UITableViewStylePlain)];
    _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tabView.delegate =self;
    _tabView.dataSource= self;
    _tabView.showsVerticalScrollIndicator=NO;
    _tabView.showsHorizontalScrollIndicator = NO;
    _tabView.backgroundColor=UIColorFromRGB(0xf5f5f5);
    _tabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    [_scroll addSubview:_tabView];
    
    //访问
    _tabView1=[[UITableView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width, 0, ScreenFrame.size.width, ScreenFrame.size.height-47-64) style:UITableViewStylePlain];
    _tabView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tabView1.delegate =self;
    _tabView1.dataSource= self;
    _tabView1.backgroundColor=UIColorFromRGB(0xf5f5f5);
    _tabView1.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing1)];
    _tabView1.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing1)];
    [_scroll addSubview:_tabView1];
    
    //支付
    _tabView2=[[UITableView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width*2, 0, ScreenFrame.size.width, ScreenFrame.size.height-47-64) style:(UITableViewStylePlain)];
    _tabView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tabView2.delegate =self;
    _tabView2.dataSource= self;
    _tabView2.showsVerticalScrollIndicator=NO;
    _tabView2.showsHorizontalScrollIndicator = NO;
    _tabView2.backgroundColor=UIColorFromRGB(0xf5f5f5);
    _tabView2.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing2)];
    _tabView2.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing2)];
    [_scroll addSubview:_tabView2];
    
    
}
#pragma mark -上拉刷新、下拉加载
//概况界面下拉刷新
-(void)headerRereshing{
    [self downloadData];
    [_tabView.mj_header endRefreshing];
}
//访问界面刷新、加载
-(void)headerRereshing1{
    [self downloadData1];
    [_tabView1.mj_header endRefreshing];
}
-(void)footerRereshing1{
    count ++;//每上拉一次计数加1
    [self downloadData1];
    [_tabView1.mj_footer endRefreshing];
}
//支付界面刷新、加载
-(void)headerRereshing2{
    [self downloadData2];
    [_tabView2.mj_header endRefreshing];
}
-(void)footerRereshing2{
    count ++;
    [self downloadData2];
    [_tabView2.mj_footer endRefreshing];
}
//三个按钮点击事件
-(void) topBtnClick:(UIButton *) btn
{
    // 概况
    if(btn.tag==1001)
    {
        //设置每个按钮字体颜色、下划线位置
        [includeBtn setTitleColor:UIColorFromRGB(0x2196f3) forState:UIControlStateNormal];
        [accessBtn setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
        [payBtn setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            redView.frame=CGRectMake(30, 45, ScreenFrame.size.width/3-60, 1);
        }];
        _scroll.contentOffset=CGPointMake(0, 0);
        [self downloadData];//发起概况界面的网络请求
    }
    // 访问
    if(btn.tag==1002)
    {
        //设置每个按钮字体颜色、下划线位置
        [accessBtn setTitleColor:UIColorFromRGB(0x2196f3) forState:UIControlStateNormal];
        [includeBtn setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
        [payBtn setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            redView.frame=CGRectMake(ScreenFrame.size.width/3, 45, ScreenFrame.size.width/3-60, 1);
        }];
        _scroll.contentOffset=CGPointMake(ScreenFrame.size.width, 0);
        
        [self downloadData1];//发起访问界面的网络请求
        
    }
    // 支付
    if(btn.tag==1003)
    {
        //设置每个按钮字体颜色、下划线位置
        [payBtn setTitleColor:UIColorFromRGB(0x2196f3) forState:UIControlStateNormal];
        [includeBtn setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
        [accessBtn setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            redView.frame=CGRectMake(ScreenFrame.size.width/3*2-30, 45, ScreenFrame.size.width/3-60, 1);
        }];
        _scroll.contentOffset=CGPointMake(ScreenFrame.size.width*2, 0);
        
        [self downloadData2];//发起支付界面的网络请求
        
    }
    
    
}
//scrollView的滚动方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView==_scroll)
    {
        redView.frame=CGRectMake(30+scrollView.contentOffset.x/3, 45, ScreenFrame.size.width/3-60, 1);
        if (_scroll.contentOffset.x==ScreenFrame.size.width)
        {
            [self downloadData1];//发起访问界面的网络请求
            //设置每个按钮字体颜色、下划线位置
            [accessBtn setTitleColor:UIColorFromRGB(0x2196f3) forState:UIControlStateNormal];
            [includeBtn setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
            [payBtn setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
            
            
        }if (_scroll.contentOffset.x==ScreenFrame.size.width*2)
        {
            [self downloadData2];//发起支付界面的网络请求
            //设置每个按钮字体颜色、下划线位置
            [accessBtn setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
            [includeBtn setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
            [payBtn setTitleColor:UIColorFromRGB(0x2196f3) forState:UIControlStateNormal];
            
        }
        if (_scroll.contentOffset.x==0){
            //设置每个按钮字体颜色、下划线位置
            [includeBtn setTitleColor:UIColorFromRGB(0x2196f3) forState:UIControlStateNormal];
            [accessBtn setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
            [payBtn setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
            
        }
        
    }
    
    
}


//概况界面  网络请求数据
-(void) downloadData
{
    [MyObject startLoading];//开始遮罩加载
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,STATISTIC_INCLUDE_URL];//请求接口url
    //参数字典设置
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken]
                          };
    //开始网络请求
    [[MyNetTool managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MyObject endLoading];
        NSDictionary * dicBig=responseObject;
        NSLog(@"统计概况///%@",dicBig);
        if (dataArray.count!=0)
        {
            [dataArray removeAllObjects];//清空数据源
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
                includeModel *model=[[includeModel alloc]init];
                //kvc  模型赋值
                [model setValuesForKeysWithDictionary:dicBig];
                [dataArray addObject:model];//数据源添加模型
                [_tabView reloadData];
                
                
            }
        }
        //空状态
        if (dataArray.count == 0) {
            _tabView.hidden = YES;
            _scroll.backgroundColor=[UIColor clearColor];
        }else{
            _tabView.hidden = NO;
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        _tabView.hidden = YES;
        [MyObject endLoading];//遮罩停止加载
        
    }];
    
}
//跳转登陆界面
-(void)doTimer_signout{
    [LJControl cleanAll];
    AppDelegate *app = [AppDelegate sharedUserDefault];
    app.log_View.hidden = NO;//显示登陆界面
}
//访问界面网络请求
-(void) downloadData1
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,STATISTIC_ACCESS_URL];
    //参数字典
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken],
                          @"begin_count":@"0",
                          @"select_count":[NSString stringWithFormat:@"%d",5*count]
                          };
    //发起请求
    [[MyNetTool managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //[MyObject endLoading];
        NSDictionary * dicBig=responseObject;
        NSLog(@"统计访问///%@",dicBig);
        if (dataArray1.count!=0)
        {
            [dataArray1 removeAllObjects];//清空数据源
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
                NSArray *ary=[dicBig objectForKey:@"goods"];
                for (NSDictionary *dic in ary) {
                    accessModel *model=[[accessModel alloc]init];
                    // kvc 模型赋值
                    [model setValuesForKeysWithDictionary:dic];
                    [dataArray1 addObject:model];//给访问数据源添加模型
                }
                
                [_tabView1 reloadData];//刷新列表
                
                
            }
            
        }
        //空状态
        if (dataArray1.count == 0) {
              _tabView1.hidden = YES;
              _scroll.backgroundColor=[UIColor clearColor];
        }else{
            _tabView1.hidden = NO;
            
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        _tabView1.hidden = YES;
    }];
    
}
//支付界面请求数据
-(void) downloadData2
{
    [MyObject startLoading];//遮罩加载
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,STATISTIC_PAY_URL];
    //参数字典
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken],
                          @"begin_count":@"0",
                          @"select_count":[NSString stringWithFormat:@"%d",5*count]
                          };
    //发起请求
    [[MyNetTool managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MyObject endLoading];
        NSDictionary * dicBig=responseObject;
        NSLog(@"统计支付///%@",dicBig);
        if (dataArray2.count!=0)
        {
            [dataArray2 removeAllObjects];//清空数据源
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
                NSArray *ary=[dicBig objectForKey:@"goods"];
                for (NSDictionary *dic in ary)
                {
                    accessModel *model=[[accessModel alloc]init];
                    //kvc 模型赋值
                    [model setValuesForKeysWithDictionary:dic];
                    [dataArray2 addObject:model];
                }
                
                [_tabView2 reloadData];//刷新列表
                
                
            }
        }
        //空状态
        if (dataArray2.count == 0) {
            _tabView2.hidden = YES;
            _scroll.backgroundColor=[UIColor clearColor];
        }else{
            _tabView2.hidden = NO;
            
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        _tabView2.hidden = YES;
        [MyObject endLoading];//遮罩停止加载
        
    }];
    
}


#pragma mark - tableView
//设置tableView的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //概况界面
    if (tableView==_tabView) {
        
        return 5;
    }else if(tableView==_tabView1)//访问
    {
        if (dataArray1.count!=0)
        {
            return dataArray1.count+1;
        }
        return 1;
        
    }else if(tableView==_tabView2)//支付
    {
        if (dataArray2.count!=0) {
            return dataArray2.count+1;
        }
        return 1;
        
        
    }
    return 0;
    
}
//设置tableView每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_tabView)//概况
    {
        if (indexPath.row==0||indexPath.row==2)
        {
            return 80.f;
        }else if (indexPath.row==4)
            return 160.f;
        else
            return 20.f;
    }else if (tableView==_tabView1)//访问
    {
        if (indexPath.row==0) {
            return 40.f;
        }else
            return 80.f;
    }else if (tableView==_tabView2)//支付
    {
        if (indexPath.row==0) {
            return 40.f;
        }else
            return 80.f;
    }
    
    
    return 100;
    
}
//设置tableView的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellName];
        
    }
    //概况cell
    if (tableView==_tabView) {
        
        if (dataArray.count !=0)
        {
            includeModel *cla = [dataArray firstObject];
            if (indexPath.row==0||indexPath.row==2)
            {
                includeCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"includeCell" owner:self options:nil] lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (indexPath.row==0)
                {
                    cell.amount.text=[NSString stringWithFormat:@"￥%@",cla.payMoney];
                    cell.precent.text=[NSString stringWithFormat:@"来自移动端%@",cla.percentage_of_transactions];
                }else if (indexPath.row==2)
                {
                    cell.title.text=@"访问人数";
                    cell.amount.text=[NSString stringWithFormat:@"%@",cla.accessNumber];
                    cell.precent.text=[NSString stringWithFormat:@"来自移动端%@",cla.percentage_of_access];
                }
                
                return cell;
            }else if (indexPath.row==4)
            {
                includeBottomCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"includeBottomCell" owner:self options:nil] lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIView *view=[LJControl viewFrame:CGRectMake(ScreenFrame.size.width/2, 0, 1, 160) backgroundColor:UIColorFromRGB(0xe3e3e3)];
                [cell addSubview:view];
                cell.paychange.text=[NSString stringWithFormat:@"%@",cla.payment_conversion_rate];
                cell.order.text=[NSString stringWithFormat:@"%@",cla.payment_order];
                cell.buyer.text=[NSString stringWithFormat:@"%@",cla.payment_user];
                cell.goods.text=[NSString stringWithFormat:@"%@",cla.goods_num];
                
                return cell;
                
            }else if (indexPath.row==1||indexPath.row==3)
            {
                UIView *finalGray=[LJControl viewFrame:CGRectMake(0, 0, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe3e3e3)];
                [cell addSubview:finalGray];
            }
        }
    }
    //访问cell
    else if (tableView==_tabView1)
    {
        if (indexPath.row!=0)
        {
            //cell复用
            static NSString *Cell = @"accessCell";
            accessCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
            
            if(cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"accessCell" owner:self options:nil] lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.index.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
            if (dataArray1.count !=0)
            {
                accessModel *cla = [dataArray1 objectAtIndex:indexPath.row-1];
                cell.title.text=cla.goods_name;
                cell.people.text=[NSString stringWithFormat:@"今日%@人",cla.goods_click];
                cell.yesPeople.text=[NSString stringWithFormat:@"昨日%@人",cla.goods_click_yesterday];
                [cell.img sd_setImageWithURL:[NSURL URLWithString:cla.main_photo]placeholderImage:[UIImage imageNamed:@"loading"]];
                
                
            }
            return cell;
        }
    }
    //支付cell
    else if (tableView==_tabView2)
    {
        if (indexPath.row!=0)
        {
            
            static NSString *Cell = @"accessCell";
            accessCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
            
            if(cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"accessCell" owner:self options:nil] lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.index.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
            if (dataArray2.count !=0)
            {
                accessModel *cla = [dataArray2 objectAtIndex:indexPath.row-1];
                cell.title.text=cla.goods_name;
                cell.people.text=[NSString stringWithFormat:@"今日%@元",cla.goods_salenum];
                cell.yesPeople.text=[NSString stringWithFormat:@"昨日%@元",cla.goods_salenum_yesterday];
                [cell.img sd_setImageWithURL:[NSURL URLWithString:cla.main_photo]placeholderImage:[UIImage imageNamed:@"loading"]];
                
                
            }
            return cell;
        }
    }
   
    cell.backgroundColor=UIColorFromRGB(0xf5f5f5);
    if (tableView==_tabView1)
    {
        if (indexPath.row==0)
        {
            cell.textLabel.text=@"按照访客从高到低";
            cell.textLabel.textColor=UIColorFromRGB(0xafafaf);
            cell.textLabel.font=[UIFont systemFontOfSize:14];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
    }if (tableView==_tabView2)
    {
        if (indexPath.row==0)
        {
            cell.textLabel.text=@"按照支付金额从高到低";
            cell.textLabel.textColor=UIColorFromRGB(0xafafaf);
            cell.textLabel.font=[UIFont systemFontOfSize:14];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView==_tabView1)//访问
    {
        if(indexPath.row!=0)
    {
        accessModel *cla = [dataArray1 objectAtIndex:indexPath.row-1];
        //跳转商品详情界面
        GoodsPreviewViewController *gpvc=[[GoodsPreviewViewController alloc]init];
        gpvc.staticID=[NSString stringWithFormat:@"%@",cla.goods_id];
        [self.navigationController pushViewController:gpvc animated:YES];
        
    }
    }else if (tableView==_tabView2)//支付
    {
        if (indexPath.row!=0) {
            
        accessModel *cla = [dataArray2 objectAtIndex:indexPath.row-1];
        //跳转商品详情界面
        GoodsPreviewViewController *gpvc=[[GoodsPreviewViewController alloc]init];
        gpvc.staticID=[NSString stringWithFormat:@"%@",cla.goods_id];
        [self.navigationController pushViewController:gpvc animated:YES];
            
        }
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
