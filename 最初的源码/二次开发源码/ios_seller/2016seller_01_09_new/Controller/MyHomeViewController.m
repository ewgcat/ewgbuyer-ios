//
//  MyHomeViewController.m
//  SellerApp
//
//  Created by barney on 15/12/29.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MyHomeViewController.h"
#import "MyOrderViewController.h"
#import "HomeCell.h"
#import "HomeModel.h"
#import "UIImageView+WebCache.h"
#import "LGScrollView.h"
#import "LoginViewController.h"
#import "StatisticViewController.h"
#import "NewsViewController.h"
#import "ComplainViewController.h"
#import "EvaluationViewController.h"
#import "ReturnRefundViewController.h"
#import "confirmdeliveryViewController.h"
#import "DeliverySettingViewController.h"
#import "ReturnViewController.h"
#import "RefundNewViewController.h"

@interface MyHomeViewController ()
{
  myselfParse * _myParse;
  NSMutableArray *dataArray;//数据源
  LGScrollView *showScrollView;
  NSMutableArray *redViewArray;//红点
  NSMutableArray *stockWarningArray;//库存预警数据源
 
}

@end

static MyHomeViewController *singleInstance=nil;
@implementation MyHomeViewController
+(id)sharedUserDefault
{
    if(singleInstance==nil)
    {
        @synchronized(self)
        {
            if(singleInstance==nil)
            {
                singleInstance=[[[self class] alloc] init];
            }
        }
    }
    return singleInstance;
}

+ (id)allocWithZone:(NSZone *)zone;
{
    if(singleInstance==nil)
    {
        singleInstance=[super allocWithZone:zone];
    }
    return singleInstance;
}

-(id)copyWithZone:(NSZone *)zone
{
    
    return singleInstance;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    //获取当前的currentUserID
    if ([MyNetTool currentUserID]) {
        [self network];
    }
    dataArray=[[NSMutableArray alloc]init];//数据源初始化
    redViewArray = [NSMutableArray array];
    stockWarningArray = [NSMutableArray array];//库存预警数据源初始化
    self.tabBarController.tabBar.hidden = NO;//显示tabBar
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)network{
    [self getNetWorking];//调用网络请求
    [self requestForStockWarning];
   
}
//库存预警请求
-(void)requestForStockWarning{
    [MyNetTool requestForStockWarningSuccess:^(NSMutableArray *modelArray) {
        stockWarningArray = modelArray;
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x2196f3);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    self.title = @"首页";//标题栏题目
    
    if (UIDeviceSystem>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    //首页tableView列表
    home_tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenFrame.size.width, ScreenFrame.size.height-64-49)];
    home_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    home_tableview.delegate = self;
    home_tableview.dataSource=  self;
    home_tableview.showsVerticalScrollIndicator=NO;
    home_tableview.showsHorizontalScrollIndicator = NO;
    home_tableview.backgroundColor = UIColorFromRGB(0xf5f5f5);
    home_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    [self.view addSubview:home_tableview];
}

#pragma mark -上拉刷新、下拉加载
-(void)headerRereshing{
    [self getNetWorking];
    [home_tableview.mj_header endRefreshing];//结束刷新
}

- (void)getNetWorking
{
    [MyObject startLoading];//遮罩
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,HOME_URL];
   
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken],
                          };
    [[MyNetTool managerWithVerify] POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MyObject endLoading];
        NSDictionary * dicBig=responseObject;
         NSLog(@"/////////%@",dicBig);
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
                        {   HomeModel *model=[[HomeModel alloc]init];
                            //kvc 给模型赋值
                            [model setValuesForKeysWithDictionary:dicBig];

                            [dataArray addObject:model];
                            [home_tableview reloadData];
                            
                            [self.navigationController popToRootViewControllerAnimated:NO];
                        }
            }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        home_tableview.hidden = YES;
        [MyObject endLoading];//遮罩
        
    }];

    
    
}
//进入登陆页面
-(void)doTimer_signout{
    [LJControl cleanAll];
    AppDelegate *app = [AppDelegate sharedUserDefault];
    app.log_View.hidden = NO;
}
#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        
        return 95;
    }else if (indexPath.row==1)
        return 120;
    else if(indexPath.row==2)
        return 23;
    else
        return 185;
        
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myTabelviewCell = @"Cell";
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:myTabelviewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromRGB(0xf5f5f5);
        HomeModel *model=[dataArray firstObject];//从数据源取出模型
        if (indexPath.row==0) {
            if (dataArray.count !=0)//如果有数据
        {
        HomeCell *cell=[[[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:self options:nil] lastObject];
            
            [cell.logo sd_setImageWithURL:[NSURL URLWithString:model.store_logo]placeholderImage:[UIImage imageNamed:@"loading"]];
            cell.storeName.text=model.store_name;
            if (![model.validity isEqualToString:@"永久"])
            {
                //设置到期时间的格式 年月日
                NSArray *ary=[model.validity componentsSeparatedByString:@" "];
                NSString *dataStr=ary[0];
                NSArray *ary2=[dataStr componentsSeparatedByString:@"-"];
                 cell.data.text=[NSString stringWithFormat:@"到期时间:%@年%@月%@日",ary2[0],ary2[1],ary2[2]];
            }else
            {
                cell.data.text=[NSString stringWithFormat:@"到期时间: %@",model.validity];
            }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
                return cell;
        }
    }else if (indexPath.row==1)
    {
        UIView *Line1=[LJControl viewFrame:CGRectMake(0, 0, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe3e3e3)];
        [cell addSubview:Line1];
        
        cell.backgroundColor=[UIColor whiteColor];
        NSArray *titleAry=@[@"今日成交",@"今日访客",@"今日订单"];
        NSArray *contentAry=@[[NSString stringWithFormat:@"%@",model.total_transactions],[NSString stringWithFormat:@"%@",model.browsing_times],[NSString stringWithFormat:@"%@",model.order_quantity]];
        
        
        //中间两条竖线
        for (int j=0; j<2; j++) {
            UIView *grayLine=[LJControl viewFrame:CGRectMake(16+(ScreenFrame.size.width-16*2)/3*(j+1)-1, 20, 1, 38) backgroundColor:UIColorFromRGB(0xe3e3e3)];
            [cell addSubview:grayLine];
            
        }
        CGFloat x2 = 16+(ScreenFrame.size.width-16*2)/3*(0+1)-1;
        CGFloat x3 = 16+(ScreenFrame.size.width-16*2)/3*(1+1)-1;
        //三个进入统计页面的按钮
        UIButton *tjBtn1=[LJControl buttonType:(UIButtonTypeCustom) setFrame:CGRectMake(0, 0, x2, 70) setNormalImage:nil setSelectedImage:nil setTitle:nil setTitleFont:0 setbackgroundColor:[UIColor clearColor]];
        [tjBtn1 addTarget:self action:@selector(tjClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell addSubview:tjBtn1];
        tjBtn1.tag = 414;
        
        UIButton *tjBtn2=[LJControl buttonType:(UIButtonTypeCustom) setFrame:CGRectMake(x2, 0, x3 - x2, 70) setNormalImage:nil setSelectedImage:nil setTitle:nil setTitleFont:0 setbackgroundColor:[UIColor clearColor]];
        [tjBtn2 addTarget:self action:@selector(tjClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell addSubview:tjBtn2];
        tjBtn2.tag = 415;
        
        UIButton *tjBtn3 = [LJControl buttonType:(UIButtonTypeCustom) setFrame:CGRectMake(x3, 0, ScreenFrame.size.width - x3, 70) setNormalImage:nil setSelectedImage:nil setTitle:nil setTitleFont:0 setbackgroundColor:[UIColor clearColor]];
        [tjBtn3 addTarget:self action:@selector(tjClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell addSubview:tjBtn3];
        tjBtn3.tag = 416;
        
        for (int i=0; i<3; i++)
        {
            UILabel *titleLab=[LJControl labelFrame:CGRectMake(16+(ScreenFrame.size.width-16*2)/3*i, 10, (ScreenFrame.size.width-16*2)/3, 30) setText:titleAry[i] setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0xbdbdbd) textAlignment:(NSTextAlignmentCenter)];
            [cell addSubview:titleLab];
            
           UILabel *contentLab=[LJControl labelFrame:CGRectMake(10+(ScreenFrame.size.width-10*2)/3*i, 38, (ScreenFrame.size.width-10*2)/3, 30) setText:contentAry[i] setTitleFont:20 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0xf15353) textAlignment:(NSTextAlignmentCenter)];
            if (i==0)
            {
                contentLab.text=[NSString stringWithFormat:@"￥%@",contentAry[i]];
               
            }

            [cell addSubview:contentLab];
            
        }
       
        UIView *grayLine1=[LJControl viewFrame:CGRectMake(0, 75, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe3e3e3)];
        [cell addSubview:grayLine1];
        UIImageView *newsImg=[LJControl imageViewFrame:CGRectMake(15, 87, 77, 20) setImage:@"todayNews.png" setbackgroundColor:nil];
        newsImg.userInteractionEnabled=YES;
        [cell addSubview:newsImg];
        
            if (model.article_title.count>0) {
             NSMutableArray *viewsArray = [NSMutableArray new];
            for (int i=0; i<model.article_title.count; i++)
            {
                UILabel *newsLabel = [UILabel new];
              
                newsLabel.text=model.article_title[i];
                newsLabel.textColor=UIColorFromRGB(0x5d5d5d);
                newsLabel.font=[UIFont systemFontOfSize:15];
                newsLabel.textAlignment=NSTextAlignmentLeft;
                [viewsArray addObject:newsLabel];
            }
            
            showScrollView= [[LGScrollView alloc] initWIthFrame:CGRectMake(55, 44, ScreenFrame.size.width-105, 20) showImages:viewsArray];
            [showScrollView start];
                UIButton *clearBtn=[LJControl buttonType:(UIButtonTypeCustom) setFrame:CGRectMake(15, 87, ScreenFrame.size.width-15, 20) setNormalImage:nil setSelectedImage:nil setTitle:nil setTitleFont:0 setbackgroundColor:[UIColor clearColor]];
                [clearBtn addTarget:self action:@selector(newsClick) forControlEvents:(UIControlEventTouchUpInside)];
                [cell addSubview:clearBtn];
            [cell addSubview:showScrollView];

        }
        
        UIView *gray=[LJControl viewFrame:CGRectMake(102, 87, 1, 21) backgroundColor:UIColorFromRGB(0xe3e3e3)];
         [cell addSubview:gray];
        UIView *finalGray=[LJControl viewFrame:CGRectMake(0, 120, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe3e3e3)];
        [cell addSubview:finalGray];
       
    
    }else if (indexPath.row==2)
    {
        UIView *finalGray=[LJControl viewFrame:CGRectMake(0, 0, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe3e3e3)];
        [cell addSubview:finalGray];
    
    }
    else if (indexPath.row==3)
        
    {
        cell.backgroundColor=[UIColor whiteColor];
        UIView *gray1=[LJControl viewFrame:CGRectMake(0, 0, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe3e3e3)];
        [cell addSubview:gray1];
        UIView *gray2=[LJControl viewFrame:CGRectMake(0, 185, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe3e3e3)];
        [cell addSubview:gray2];
        
        NSArray *arr = [[NSArray alloc]initWithObjects:@"库存预警",@"评价管理",@"退货管理",@"退款管理",@"发货设置",@"结算管理",@"团购验证",@"店铺统计", nil];
        NSArray *indexArray=@[@"complain.png",@"evaluate.png",@"changeGoods.png",@"refund.png",@"deliver.png",@"conclude.png",@"group.png",@"ask.png"];
        for(int i =0;i<4;i++){
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenFrame.size.width/4-50)/2+(50+(ScreenFrame.size.width/4-50))*i, 10, 50, 50)];
            
            [cell addSubview:imageV];
            UILabel *labelN = [[UILabel alloc]initWithFrame:CGRectMake(imageV.frame.origin.x-10, 17+45, 70, 20)];
            labelN.text =[arr objectAtIndex:i];
            labelN.textColor = UIColorFromRGB(0x5d5d5d);
            labelN.font = [UIFont systemFontOfSize:15];
            labelN.textAlignment = NSTextAlignmentCenter;
            [cell addSubview:labelN];
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((ScreenFrame.size.width/4-50)/2+(50+(ScreenFrame.size.width/4-50))*i, 15, 50, 60)];
            [btn addTarget:self action:@selector(topBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 100+i;
            [cell addSubview:btn];
            
            UIImageView *imageV2 = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenFrame.size.width/4-50)/2+(50+(ScreenFrame.size.width/4-50))*i, 15+70, 50, 50)];
            imageV.image = [UIImage imageNamed:[indexArray objectAtIndex:i]];
            imageV2.image = [UIImage imageNamed:[indexArray objectAtIndex:i+4]];
            [cell addSubview:imageV2];
            UILabel *labelN2 = [[UILabel alloc]initWithFrame:CGRectMake(imageV2.frame.origin.x-10, 17+50+70, 70, 20)];
            labelN2.text = [arr objectAtIndex:4+i];
            labelN2.textColor = UIColorFromRGB(0x5d5d5d);
            labelN2.font = [UIFont systemFontOfSize:15];
            labelN2.textAlignment = NSTextAlignmentCenter;
            [cell addSubview:labelN2];
            UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake((ScreenFrame.size.width/4-50)/2+(50+(ScreenFrame.size.width/4-50))*i, 15+75, 50, 60)];
            [btn2 addTarget:self action:@selector(topBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            btn2.tag = 104+i;
            [cell addSubview:btn2];
            
        }
        
    }
    return cell;
   
}
//跳转公告列表界面
-(void)newsClick
{
    NewsViewController *news=[[NewsViewController alloc]init];
    [self.navigationController pushViewController:news animated:YES];
}
-(void)topBtnClicked:(UIButton *)btn
{
    NSLog(@"主页按钮tag值:%d",(int)btn.tag);
    switch (btn.tag) {
        case 102:{
            //退货管理
            ReturnViewController *rrvc = [ReturnViewController new];
            [self.navigationController pushViewController:rrvc animated:YES];
            break;
        }
        case 103:{
            //退款管理
           RefundNewViewController *rrvc = [RefundNewViewController new];
            [self.navigationController pushViewController:rrvc animated:YES];
            break;
        }
        case 107:{
            //店铺统计
            StatisticViewController *statistic=[[StatisticViewController alloc]init];
            [self.navigationController pushViewController:statistic animated:YES];
             break;
        }
        case 100:{
            //库存预警
            StockWarnTableViewController *swTVC = [[UIStoryboard storyboardWithName:@"NotifStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"stockWarning"];
            swTVC.dataArray = stockWarningArray;
            [self.navigationController pushViewController:swTVC animated:YES];

            break;
        }
        case 101:{
            //评价管理
            EvaluationViewController *evaVC = [EvaluationViewController new];
            [self.navigationController pushViewController:evaVC animated:YES];
            break;
        }
        case 105:{
            //结算管理
            MyOrderViewController *moVC = [MyOrderViewController new];
            [self.navigationController pushViewController:moVC animated:YES];
            break;
        }
        case 106:{
            //团购验证
            GroupPurchaseVerifyViewController *gpvVC = [GroupPurchaseVerifyViewController groupPurchaseVerifyVC];
            [self.navigationController pushViewController:gpvVC animated:YES];
            break;
        }
        case 104:{
            //发货设置
            
            DeliverySettingViewController *del = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"deliverysetting"];
            [self.navigationController pushViewController:del animated:YES];
            break;
        }
        default:
            break;
    }


}
//跳转统计中心
-(void)tjClick:(UIButton *)tjBtn
{
    NSInteger selectTag = 0;
    switch (tjBtn.tag) {
        case 414:{
            selectTag = 1;
            break;
        }case 415:{
            selectTag = 2;
            break;
        }case 416:{
            selectTag = 3;
            break;
        }
        default:{
            break;
        }
    }
    StatisticViewController *statistic=[[StatisticViewController alloc]init];
    statistic.selectedTag = selectTag;
    [self.navigationController pushViewController:statistic animated:YES];
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
