//
//  NewsViewController.m
//  SellerApp
//
//  Created by barney on 16/1/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NewsViewController.h"
#import "classModel.h"
#import "ListModel.h"
#import "NewsWebViewController.h"
#import "newsListCell.h"

static CGFloat offset = 80;

@interface NewsViewController ()<UITableViewDataSource,UITabBarDelegate,UITableViewDelegate,UIScrollViewDelegate,MyObjectDelegate>

{
    MyObject *myObj;
    NSMutableArray *titleArray;//标题数组
    NSMutableArray *IDArray;//标题ID数组
    UITableView *_tabView;//全部
    UITableView *_tabView1;//商家须知
    UITableView *_tabView2;//新增功能
    NSMutableArray *dataArray;//数据源
    int count;//计数
}

@end

@implementation NewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //导航栏设置
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x2196f3);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);//背景颜色设置
    self.title = @"公告列表";//标题栏标题

    if (UIDeviceSystem>=7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;//自动调整属性设置为NO
    }else{
    }

    count=1;//默认计数为1
    dataArray = [[NSMutableArray alloc]init];//数据源初始化
    [self downloadData];//标题数组 网络请求数据
    
    myObj = [MyObject new];
    myObj.delegate = self;//设置代理
    titleArray=[NSMutableArray arrayWithObject:@"全部"];//标题数组初始化
    IDArray=[NSMutableArray arrayWithObject:@""];//标题ID数组初始化

    
    
}
//刷新底部tableview
-(void)bottomTableDidEndDecelating:(MyObject *)myObj{
    //做请求
    [self downloadData1];
    NSLog(@"数据已更新");
}
//标题数组 网络请求
-(void) downloadData
{
    [MyObject startLoading];//遮罩
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,NEWS_CLASS_URL];
    
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
                
                NSArray *ary=[dicBig objectForKey:@"articleClass"];
                for (NSDictionary *dic in ary)
                {
                    classModel *model=[[classModel alloc]init];//分类模型
                    //模型赋值
                    model.className=[dic objectForKey:@"className"];
                     model.ID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                    //标题数据源添加元素
                    [titleArray addObject:model.className];
                    //标题ID数据源添加元素
                    [IDArray addObject:model.ID];
                }
                //利用MyObject封装的方法设置tableView
                [myObj sy_addHeadNaviTitleArray:titleArray toContainerViewWithFrameSetted:self.view headerHeight:47 topMargin:64 testColor:NO normalFontSize:15 selectedFontSize:15];
                //tableView数组
                NSArray *tableViews = myObj.tableViewArray;
                
                for (int i=0; i<IDArray.count; i++)
                {
                    //取出各个tabView
                    UITableView *tabView=[tableViews objectAtIndex:i];
                    //设置tabView各个属性
                    tabView.frame=CGRectMake(ScreenFrame.size.width*i, 2, ScreenFrame.size.width, ScreenFrame.size.height-49-64);
                    tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
                    tabView.delegate =self;
                    tabView.dataSource= self;
                    tabView.showsVerticalScrollIndicator=NO;
                    tabView.showsHorizontalScrollIndicator = NO;
                    tabView.backgroundColor=UIColorFromRGB(0xf5f5f5);
                    //设置tabView上拉刷新、下拉加载
                    tabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
                    tabView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
                    tabView.backgroundView = [MyObject noDataViewOffset:offset];
                }
                _tabView=tableViews[0];//全部
                _tabView1=tableViews[1];//商家须知
                _tabView2=tableViews[2];//新增功能
               
                [self downloadData1];//公告列表 网络请求
                
                
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
       
        [MyObject endLoading];//遮罩停止加载
        
    }];
    
}

//跳转登录界面
-(void)doTimer_signout
{
    [LJControl cleanAll];
    AppDelegate *app = [AppDelegate sharedUserDefault];
    app.log_View.hidden = NO;//显示登陆界面
}
#pragma mark -上拉刷新、下拉加载
-(void)headerRereshing
{
    [self downloadData1];//公告列表 网络请求
    UITableView *tab= myObj.tableViewArray[myObj.curIndex];
    [tab.mj_header endRefreshing];//当前列表停止刷新
}
-(void)footerRereshing{
    count ++;
    [self downloadData1];//公告列表 网络请求
    UITableView *tab= myObj.tableViewArray[myObj.curIndex];
    [tab.mj_footer endRefreshing];//当前列表停止加载
}
//公告列表 网络请求
-(void) downloadData1
{
    [MyObject startLoading];//遮罩
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,NEWS_LIST_URL];//请求接口
    //请求参数字典
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken],
                          @"begin_count":@"0",
                          @"select_count":[NSString stringWithFormat:@"%d",5*count],
                          @"class_id":[NSString stringWithFormat:@"%@",IDArray[myObj.curIndex]]
                          };
    //发起请求
    
    [[MyNetTool managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MyObject endLoading];
        NSDictionary * dicBig=responseObject;
        NSLog(@"统计列表///%@",dicBig);
    
        if (dataArray.count!=0)
        {
            [dataArray removeAllObjects];//数据源清空
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
                NSArray *ary=[dicBig objectForKey:@"article"];
                for (NSDictionary *dic in ary)
                {
                    ListModel *model=[[ListModel alloc]init];
                    //kvc 模型赋值
                    [model setValuesForKeysWithDictionary:dic];
                    [dataArray addObject:model];
                }
                
               UITableView *tab= myObj.tableViewArray[myObj.curIndex];
                [tab reloadData];//刷新当前列表
                //空状态
                if (dataArray.count == 0) {
                    tab.backgroundView = [MyObject noDataViewOffset:offset];
                }else{
                    tab.backgroundView = nil;
                }
                
            }
        }
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        UITableView *tab= myObj.tableViewArray[myObj.curIndex];
        tab.backgroundView = [MyObject noDataViewOffset:offset];//若失败，隐藏当前tableView
       
        
    }];
    
}

#pragma mark - tableView
//设置tableView行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
        if (dataArray.count!=0)
        {
            return dataArray.count;//若数据源数组不为空，返回数组个数
        }
        
    return 0;
}
//设置tableView每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}
//设置tableView的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell的复用
    static NSString *cellName=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellName];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }

    if (dataArray.count !=0)
        {
            newsListCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"newsListCell" owner:self options:nil] lastObject];//读取xib文件
            //设置cell的选择样式
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            //从数据源中取出相应的模型
            ListModel *cla = [dataArray objectAtIndex:indexPath.row];
            //给cell的各个属性赋值
            cell.titleLab.text=cla.article_title;
            cell.timeLab.text=[NSString stringWithFormat:@"发布时间:%@",cla.addTime];
            return cell;
        }
    
    
       cell.backgroundColor=[UIColor whiteColor];

    return cell;
    
}
//tableView的cell点击方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsWebViewController *web=[[NewsWebViewController alloc]init];
    web.list=[dataArray objectAtIndex:indexPath.row];//将对应的模型传给下一界面
    //跳转公告详情界面
    [self.navigationController pushViewController:web animated:YES];
    
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
