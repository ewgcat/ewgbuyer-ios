//
//  AskViewController.m
//  2016seller_01_09_new
//
//  Created by barney on 16/1/9.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

#import "AskViewController.h"
#import "AskCell.h"
#import "AskDidCell.h"
#import "AskDetailViewController.h"

@interface AskViewController ()<UITableViewDataSource,UITabBarDelegate,UITableViewDelegate,UIScrollViewDelegate,MyObjectDelegate>
{
    MyObject *myObj;
    NSMutableArray *titleArray;//标题数组
    NSMutableArray *IDArray;//标题ID数组
    UITableView *_tabView;//未回复咨询
    UITableView *_tabView1;//已回复咨询
    
    NSMutableArray *dataArray;//数据源
    int count;//网络请求加载计数
}
@end

@implementation AskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"咨询列表";//导航栏题目
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);//背景颜色
    if (UIDeviceSystem>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;//自动调整属性设置为NO
    }else{
    }
    count=1;//计数默认为1
    dataArray = [[NSMutableArray alloc]init];//数据源初始化
    //[self downloadData];
    
    myObj = [MyObject new];
    myObj.delegate = self;
    titleArray=[NSMutableArray arrayWithObjects:@"未回复咨询",@"已回复咨询",nil];
    IDArray=[NSMutableArray arrayWithObjects:@"",@"",nil];
    
    [myObj sy_addHeadNaviTitleArray:titleArray toContainerViewWithFrameSetted:self.view headerHeight:47 topMargin:64 testColor:NO normalFontSize:15 selectedFontSize:15];
    NSArray *tableViews = myObj.tableViewArray;
    
    for (int i=0; i<2; i++)
    {
        UITableView *tabView=[tableViews objectAtIndex:i];
        
        tabView.frame=CGRectMake(ScreenFrame.size.width*i, 0, ScreenFrame.size.width, ScreenFrame.size.height-47-64);
        tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tabView.delegate =self;
        tabView.dataSource= self;
        tabView.showsVerticalScrollIndicator=NO;
        tabView.showsHorizontalScrollIndicator = NO;
        tabView.backgroundColor=[UIColor clearColor];
        tabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        tabView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        
    }
    _tabView=tableViews[0];
    _tabView1=tableViews[1];
    
    [self downloadData1];
}
//刷新底部tableview
-(void)bottomTableDidEndDecelating:(MyObject *)myObj{
    //做请求
    [self downloadData1];
    NSLog(@"数据已更新");
}
-(void) downloadData
{
    [MyObject startLoading];//加载遮罩
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,NEWS_CLASS_URL];
    //参数字典
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken]
                          };
    //发起请求
    [[MyNetTool managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MyObject endLoading];
        NSDictionary * dicBig=responseObject;
        NSLog(@"公告分类///%@",dicBig);
        
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
                
                //                NSArray *ary=[dicBig objectForKey:@"articleClass"];
                //                for (NSDictionary *dic in ary)
                //                {
                //                    classModel *model=[[classModel alloc]init];
                //                    model.className=[dic objectForKey:@"className"];
                //                    model.ID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                //                    [titleArray addObject:model.className];
                //                    [IDArray addObject:model.ID];
                //                }
                //利用MyObject封装的方法设置tableView
                [myObj sy_addHeadNaviTitleArray:titleArray toContainerViewWithFrameSetted:self.view headerHeight:47 topMargin:64 testColor:NO normalFontSize:15 selectedFontSize:15];
                NSArray *tableViews = myObj.tableViewArray;//tableView数组
                
                for (int i=0; i<3; i++)
                {
                    //设置tableView
                    UITableView *tabView=[tableViews objectAtIndex:i];
                    
                    tabView.frame=CGRectMake(ScreenFrame.size.width*i, 1, ScreenFrame.size.width, ScreenFrame.size.height-48-64);
                    tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
                    tabView.delegate =self;
                    tabView.dataSource= self;
                    tabView.showsVerticalScrollIndicator=NO;
                    tabView.showsHorizontalScrollIndicator = NO;
                    tabView.backgroundColor=UIColorFromRGB(0xf5f5f5);
                    tabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
                    tabView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
                    
                }
                _tabView=tableViews[0];
                _tabView1=tableViews[1];
                
                
                [self downloadData1];//请求列表数据
                
                
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        
        [MyObject endLoading];//结束遮罩加载
        
    }];
    
}
#pragma mark -上拉刷新、下拉加载
-(void)headerRereshing
{
    [self downloadData1];//请求列表数据
    UITableView *tab= myObj.tableViewArray[myObj.curIndex];
    [tab.mj_header endRefreshing];
}
-(void)footerRereshing{
    count ++;//加载计数加1
    [self downloadData1];
    UITableView *tab= myObj.tableViewArray[myObj.curIndex];
    [tab.mj_footer endRefreshing];//当前tableView停止刷新
}
//请求列表数据
-(void) downloadData1
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,NEWS_LIST_URL];
    //参数字典
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken],
                          @"begin_count":@"0",
                          @"select_count":[NSString stringWithFormat:@"%d",5*count],
                          @"class_id":[NSString stringWithFormat:@"%@",IDArray[myObj.curIndex]]
                          };
    //发起请求
    [[MyNetTool managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * dicBig=responseObject;
        NSLog(@"统计列表///%@",dicBig);
        
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
                //                NSArray *ary=[dicBig objectForKey:@"article"];
                //                for (NSDictionary *dic in ary) {
                //                    ListModel *model=[[ListModel alloc]init];
                //                    [model setValuesForKeysWithDictionary:dic];
                //                    [dataArray addObject:model];
                //                }
                
                UITableView *tab= myObj.tableViewArray[myObj.curIndex];
                [tab reloadData];//刷新当前列表
                
                
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        UITableView *tab= myObj.tableViewArray[myObj.curIndex];
        tab.hidden = YES;//若请求失败，隐藏当前列表
        
        
    }];
    
}
#pragma mark - tableView
//设置tableView行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (dataArray.count!=0)
    {
        return dataArray.count;
    }
    
    return 3;
}
//设置tableView行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_tabView)
    {
        return 100.f;
        
    }else if (tableView==_tabView1)
    {
        return  130.f;
    
    }
    return 0;
    
}
//设置tableView的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (tableView==_tabView)
    {
        AskCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"AskCell" owner:self options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (tableView==_tabView1)
    {
    
        AskDidCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"AskDidCell" owner:self options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    static NSString *cellName=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellName];
    }
    return cell;
    
    
    
    
}
//cell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AskDetailViewController *askDetail=[[AskDetailViewController alloc]init];
    [self.navigationController pushViewController:askDetail animated:YES];
    
}

//跳转登录界面
-(void)doTimer_signout{
    
    [LJControl cleanAll];
    AppDelegate *app = [AppDelegate sharedUserDefault];
    app.log_View.hidden = NO;//显示登陆界面
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
