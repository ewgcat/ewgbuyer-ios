//
//  OrderlistViewController.m
//  SellerApp
//
//  Created by apple on 15-3-20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "OrderlistViewController.h"
#import "OrderlistCell.h"
#import "Model.h"
#import "ModifyPriceViewController.h"
#import "ModifyShipViewController.h"
#import "delayViewController.h"
#import "OrderDetailViewController.h"
#import "confirmdeliveryViewController.h"
#import "OrderCancelViewController.h"
#import "AppDelegate.h"
#import "searchViewController.h"
#import "WorkBenchViewController.h"
#import "sqlService.h"

@interface OrderlistViewController ()
{
    myselfParse *_myParse;
    int count;
}


@end

static OrderlistViewController *singleInstance=nil;

@implementation OrderlistViewController
@synthesize labelTag;

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

-(void)createBackBtn{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
    button.frame =CGRectMake(0, 0, 44, 44);
    [button setBackgroundImage:[UIImage imageNamed:@"back_lj"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}



-(void)viewWillAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    self.tabBarController.tabBar.hidden = NO;
    [MyObject startLoading];
    //self.tabBarController.tabBar.hidden = YES;
    WorkBenchViewController *work = [WorkBenchViewController sharedUserDefault];
    if (work.selectTag == -1) {
        
    }else{
        labelTag = work.selectTag;
        work.selectTag = -1;
    }
    [self netJson];
    [super viewWillAppear:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    btnClickedBool = NO;
    order_status = @"0";
    labelTag = 0;
    requestBool = NO;
    count=1;
    self.view.backgroundColor = [UIColor whiteColor];
    orderlist_Array = [[NSMutableArray alloc]init];
    orderlistPull_Array = [[NSMutableArray alloc]init];
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x2196f3);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];

    self.title = @"订单";
    if (UIDeviceSystem>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    
    UIImageView *imageNothing = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenFrame.size.width-133)/2, (ScreenFrame.size.height-117)/2, 133, 117)];
    imageNothing.image = [UIImage imageNamed:@"seller_center_nothing"];
    [self.view addSubview:imageNothing];
    UILabel *labelNothing = [[UILabel alloc]initWithFrame:CGRectMake(0, imageNothing.frame.origin.y+imageNothing.frame.size.height, ScreenFrame.size.width, 30)];
    labelNothing.text = @"抱歉，没有找到相关数据";
    labelNothing.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labelNothing];
    
    UIButton *logbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logbtn.frame = CGRectMake(10, 73-5, self.view.frame.size.width-20, 44);
    logbtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [logbtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    logbtn.tag = 100;
    [self.view addSubview:logbtn];
    UILabel *ss_label=[LJControl labelFrame:CGRectMake(10, 73, self.view.frame.size.width-20, 34) setText:@"  🔍丨输入订单号或买家账户名称查询" setTitleFont:17 setbackgroundColor:[UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1] setTextColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft];
    ss_label.font=[UIFont boldSystemFontOfSize:17];
    [self.view addSubview:ss_label];
    
    NSArray *array=@[@"全部",@"待付款",@"待发货",@"已发货",@"已收货"];
    MysegmentControl=[[UISegmentedControl alloc]initWithItems:array];
    MysegmentControl.frame=CGRectMake(10, 117, ScreenFrame.size.width-20, 34);
    MysegmentControl.selectedSegmentIndex=0;
    MysegmentControl.tintColor =UIColorFromRGB(0X2196f3);
    [MysegmentControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    MysegmentControl.backgroundColor = UIColorFromRGB(0Xffffff);
    
    [self.view addSubview:MysegmentControl];

    orderlist_tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+161, ScreenFrame.size.width, ScreenFrame.size.height-171)];
    orderlist_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    orderlist_tableview.delegate = self;
    orderlist_tableview.dataSource=  self;
    orderlist_tableview.showsVerticalScrollIndicator=NO;
    orderlist_tableview.showsHorizontalScrollIndicator = NO;
    orderlist_tableview.backgroundColor = GRAY_COLOR;
    orderlist_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    orderlist_tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [self.view addSubview:orderlist_tableview];
    
    faildV = [LJControl netFaildView];
    faildV.hidden = YES;
    [self.view addSubview:faildV];
    UIButton *button = [LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake((ScreenFrame.size.width-100)/2, 370, 100, 44) setNormalImage:[UIImage imageNamed:@""] setSelectedImage:[UIImage imageNamed:@""] setTitle:@"重新加载" setTitleFont:17 setbackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(loadingNet) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:8];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [faildV addSubview:button];
    
}
-(void)headerRereshing{

    [self down_pull];
    [orderlist_tableview.mj_header endRefreshing];
}
-(void)footerRereshing{
    [self up_pull];
    [orderlist_tableview.mj_footer endRefreshing];
}

#pragma mark - seg点击事件
-(void)change:(UISegmentedControl *)segmentControl{
    
    if (segmentControl.selectedSegmentIndex == 0) {
        
        btnClickedBool = YES;
        [MyObject startLoading];
        labelTag = 0;
        
        NSArray *fileContent2 = USER_INFORMATION;
        NSString *url;
        if (labelTag == 0) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"0",@"10"];
        }else if (labelTag == 1) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"10",@"0",@"10"];
        }else if (labelTag == 2) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"20",@"0",@"10"];
        }else if (labelTag == 3) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"30",@"0",@"10"];
        }else if (labelTag == 4) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"40",@"0",@"10"];
        }else if (labelTag == 5) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"50",@"0",@"10"];
        }
        [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
            [MyObject endLoading];
            faildV.hidden = YES;
            _myParse = myParse;
            [self analyze:_myParse.dicBig];
        } failure:^(){
            [MyObject endLoading];
            faildV.hidden = NO;
        } ];
        
    }else if(segmentControl.selectedSegmentIndex == 1){
        
        btnClickedBool = YES;
        [MyObject startLoading];
        labelTag = 1;
        [orderlist_tableview reloadData];
        
        NSArray *fileContent2 = USER_INFORMATION;
        NSString *url;
        if (labelTag == 0) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"0",@"10"];
        }else if (labelTag == 1) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"10",@"0",@"10"];
        }else if (labelTag == 2) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"20",@"0",@"10"];
        }else if (labelTag == 3) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"30",@"0",@"10"];
        }else if (labelTag == 4) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"40",@"0",@"10"];
        }else if (labelTag == 5) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"50",@"0",@"10"];
        }
        [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
            [MyObject endLoading];
            _myParse = myParse;
            [self analyze:_myParse.dicBig];
        } failure:^(){
            [MyObject endLoading];
            faildV.hidden = NO;
        } ];
        
    }else if(segmentControl.selectedSegmentIndex == 2){
        
        btnClickedBool = YES;
        [MyObject startLoading];
        labelTag = 2;
        
        
        NSArray *fileContent2 = USER_INFORMATION;
        NSString *url;
        if (labelTag == 0) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"0",@"10"];
        }else if (labelTag == 1) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"10",@"0",@"10"];
        }else if (labelTag == 2) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"20",@"0",@"10"];
        }else if (labelTag == 3) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"30",@"0",@"10"];
        }else if (labelTag == 4) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"40",@"0",@"10"];
        }else if (labelTag == 5) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"50",@"0",@"10"];
        }
        [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
            [MyObject endLoading];
            faildV.hidden = YES;
            _myParse = myParse;
            [self analyze:_myParse.dicBig];
        } failure:^(){
             [MyObject endLoading];
            faildV.hidden = NO;
        } ];
        
    }else if(segmentControl.selectedSegmentIndex == 3){
        
        
        btnClickedBool = YES;
         [MyObject startLoading];
        labelTag = 3;
        
        
        NSArray *fileContent2 = USER_INFORMATION;
        NSString *url;
        if (labelTag == 0) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"0",@"10"];
        }else if (labelTag == 1) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"10",@"0",@"10"];
        }else if (labelTag == 2) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"20",@"0",@"10"];
        }else if (labelTag == 3) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"30",@"0",@"10"];
        }else if (labelTag == 4) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"40",@"0",@"10"];
        }else if (labelTag == 5) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"50",@"0",@"&select_count=%@"];
        }
        [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
             [MyObject endLoading];
            faildV.hidden = YES;
            _myParse = myParse;
            [self analyze:_myParse.dicBig];
        } failure:^(){
            [MyObject endLoading];
            faildV.hidden = NO;
        } ];
        
        
    }else{
        
        btnClickedBool = YES;
         [MyObject startLoading];
        labelTag = 5;
        
        
        NSArray *fileContent2 = USER_INFORMATION;
        NSString *url;
        if (labelTag == 0) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"0",@"10"];
        }else if (labelTag == 1) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"10",@"0",@"10"];
        }else if (labelTag == 2) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"20",@"0",@"10"];
        }else if (labelTag == 3) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"30",@"0",@"10"];
        }else if (labelTag == 4) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"40",@"0",@"10"];
        }else if (labelTag == 5) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"50",@"0",@"10"];
        }
        [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
             [MyObject endLoading];
            faildV.hidden = YES;
            _myParse = myParse;
            [self analyze:_myParse.dicBig];
        } failure:^(){
             [MyObject endLoading];
            faildV.hidden = NO;
        } ];
        
    }
}


#pragma mark - 网络解析
-(void)netJson{
    NSArray *fileContent2 = USER_INFORMATION;
    NSString *url;
    if (labelTag == 0) {
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"0",@"10"];
        MysegmentControl.selectedSegmentIndex = 0;
    }else if (labelTag == 1) {
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"10",@"0",@"10"];
        MysegmentControl.selectedSegmentIndex = 1;
    }else if (labelTag == 2) {
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"20",@"0",@"10"];
        MysegmentControl.selectedSegmentIndex = 2;
    }else if (labelTag == 3) {
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"30",@"0",@"10"];
        MysegmentControl.selectedSegmentIndex = 3;
    }else if (labelTag == 4) {
        MysegmentControl.selectedSegmentIndex = 4;
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"40",@"0",@"10"];
    }else if (labelTag == 5) {
        MysegmentControl.selectedSegmentIndex = 4;
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"50",@"0",@"10"];
    }
    
    [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
        faildV.hidden = YES;
         [MyObject endLoading];
        _myParse = myParse;
        [self analyze:_myParse.dicBig];
    } failure:^(){
         [MyObject endLoading];
        faildV.hidden = NO;
    } ];
}
-(void)loadingNet{
     [MyObject startLoading];
    [self netJson];
}
-(void)analyze_upDown:(NSDictionary *)dicBig{
    if (dicBig) {
        if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"]){
            [self.navigationController popToRootViewControllerAnimated:NO];
            //登录过期 提示重新登录
            [MyObject failedPrompt: @"用户登录已过期，请重新登录"];
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
        }else{
            NSArray *array = [dicBig objectForKey:@"order_list"];
            if (orderlistPull_Array.count!=0) {
                [orderlistPull_Array removeAllObjects];
            }
            order_status = [dicBig objectForKey:@"order_status"];
            for(NSDictionary *dic in array){
                Model *model = [[Model alloc]init];
                model.addTime = [dic objectForKey:@"addTime"];
                model.order_id = [dic objectForKey:@"order_id"];
                model.order_num = [dic objectForKey:@"order_num"];
                model.order_type = [dic objectForKey:@"order_type"];
                model.payment = [dic objectForKey:@"payment"];
                model.photo_list = [dic objectForKey:@"photo_list"];
                model.ship_price = [dic objectForKey:@"ship_price"];
                model.totalPrice = [dic objectForKey:@"totalPrice"];
                model.name_list = [dic objectForKey:@"name_list"];
                model.order_status = [dic objectForKey:@"order_status"];
                [orderlistPull_Array addObject:model];
            }
            [orderlist_Array addObjectsFromArray:orderlistPull_Array];
            requestBool = YES;
            [orderlist_tableview reloadData];
        }
    }
}
-(void)analyze:(NSDictionary *)dicBig{
    if (dicBig) {
        NSLog(@"111111111%@",dicBig);
        if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"]) {
            [self.navigationController popToRootViewControllerAnimated:NO];
            //登录过期 提示重新登录
            [MyObject failedPrompt:@"用户登录已过期，请重新登录"];
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
        }else{
            NSArray *array = [dicBig objectForKey:@"order_list"];
            if (orderlist_Array.count !=0) {
                [orderlist_Array removeAllObjects];
            }
            order_status = [dicBig objectForKey:@"order_status"];
            for(NSDictionary *dic in array){
                
                Model *model = [[Model alloc]init];
                
                model.addTime = [dic objectForKey:@"addTime"];
                model.order_id = [dic objectForKey:@"order_id"];
                model.order_num = [dic objectForKey:@"order_num"];
                model.order_type = [dic objectForKey:@"order_type"];
                model.payment = [dic objectForKey:@"payment"];
                model.photo_list = [dic objectForKey:@"photo_list"];
                model.ship_price = [dic objectForKey:@"ship_price"];
                model.totalPrice = [dic objectForKey:@"totalPrice"];
                model.name_list = [dic objectForKey:@"name_list"];
                model.order_status = [dic objectForKey:@"order_status"];
                [orderlist_Array addObject:model];
            }
            if (orderlist_Array.count == 0) {
                orderlist_tableview.hidden = YES;
            }else{
                orderlist_tableview.hidden = NO;
            }
            [orderlist_tableview reloadData];
        }
    }
}
-(void)doTimer{
    
}

#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (orderlist_Array.count != 0) {
        return orderlist_Array.count;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 178.5+44*2+20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myTabelviewCell = @"OrderlistCell";
    OrderlistCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderlistCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = GRAY_COLOR;
    }else{
        for (UIView *subView in cell.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    if (orderlist_Array.count!=0) {
        Model *mymodel = [orderlist_Array objectAtIndex:indexPath.row];
        [cell my_cell:mymodel];
        if ([mymodel.order_status intValue] == 10){//代付款
            UIButton *over_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            over_btn.frame = CGRectMake(self.view.frame.size.width-118-6, 198.5+44, 110, 44);
            over_btn.tag = indexPath.row;
            [over_btn addTarget:self action:@selector(cellCancelbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:over_btn];
            
            UIButton *Price_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            Price_btn.frame = CGRectMake(self.view.frame.size.width-118-6-110, 198.5+44, 110, 44);
            Price_btn.tag = indexPath.row;
            [Price_btn addTarget:self action:@selector(cellPricebtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:Price_btn];
        }else if ([mymodel.order_status intValue] == 20 || [mymodel.order_status intValue] == 16){//待发货
            
            UIButton *over_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            over_btn.frame = CGRectMake(self.view.frame.size.width-118-6, 198.5+44, 110, 44);
            over_btn.tag = indexPath.row;
            [over_btn addTarget:self action:@selector(cellSendbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:over_btn];
        }else if ([mymodel.order_status intValue] == 30){// 已发货
            
            UIButton *over_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            over_btn.frame = CGRectMake(self.view.frame.size.width-118-6, 198.5+44, 110, 44);
            over_btn.tag = indexPath.row;
            [over_btn addTarget:self action:@selector(cellShipbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:over_btn];
            
            
            UIButton *Price_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            Price_btn.frame = CGRectMake(self.view.frame.size.width-118-6-130, 198.5+44, 130, 44);
            Price_btn.tag = indexPath.row;
            [Price_btn addTarget:self action:@selector(cellTimebtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:Price_btn];
        }else if ([mymodel.order_status intValue] == 40){// 已确认收货
            
        }else if ([mymodel.order_status intValue] == 50){// 已完成
            
        }else{
            
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (orderlist_Array.count!=0) {
        Model *mmm = [orderlist_Array objectAtIndex:indexPath.row];
        _order_id = mmm.order_id;
        OrderDetailViewController *order = [[OrderDetailViewController alloc]init];
        [self.navigationController pushViewController:order animated:YES];
    }
}
#pragma mark - 点击事件
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnClicked:(UIButton *)btn{
    if (btn.tag == 100) {
        searchViewController *sear = [[searchViewController alloc]init];
        [self.navigationController pushViewController:sear animated:YES];
    }
}
-(void)cellSendbtnClicked:(UIButton *)btn{
    if (orderlist_Array.count!=0) {
        Model *mmm = [orderlist_Array objectAtIndex:btn.tag];
        _order_id = mmm.order_id;
        confirmdeliveryViewController *inin = [[confirmdeliveryViewController alloc]init];
        [self.navigationController pushViewController:inin animated:YES];
    }
}

-(void)cellShipbtnClicked:(UIButton *)btn{
    if (orderlist_Array.count!=0) {
        Model *mmm = [orderlist_Array objectAtIndex:btn.tag];
        _order_id = mmm.order_id;
        ModifyShipViewController *modify = [[ModifyShipViewController alloc]init];
        [self.navigationController pushViewController:modify animated:YES];
    }
}
-(void)cellTimebtnClicked:(UIButton *)btn{
    if (orderlist_Array.count!=0) {
        Model *mmm = [orderlist_Array objectAtIndex:btn.tag];
        _order_num = mmm.order_num;
        _order_id = mmm.order_id;
        delayViewController *delay = [[delayViewController alloc]init];
        [self.navigationController pushViewController:delay animated:YES];
    }
}

-(void)cellCancelbtnClicked:(UIButton *)btn{
    if (orderlist_Array.count!=0) {
        Model *mmm = [orderlist_Array objectAtIndex:btn.tag];
        _order_id = mmm.order_id;
        _order_num = mmm.order_num;
        OrderCancelViewController *modify = [[OrderCancelViewController alloc]init];
        [self.navigationController pushViewController:modify animated:YES];
    }
}

-(void)cellPricebtnClicked:(UIButton *)btn{
    if (orderlist_Array.count!=0) {
        Model *mmm = [orderlist_Array objectAtIndex:btn.tag];
        _order_id = mmm.order_id;
        ModifyPriceViewController *modify = [[ModifyPriceViewController alloc]init];
        [self.navigationController pushViewController:modify animated:YES];
    }
}
-(void)cellbtnClicked:(UIButton *)btn{
    if (labelTag == 0) {
        
    }else if (labelTag == 1){
        
    }else if (labelTag == 2){
        
    }
}

-(void)down_pull{
     [MyObject startLoading];
    
    NSArray *fileContent2 = USER_INFORMATION;
    NSString *url;
    if (labelTag == 0) {
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"0",@"10"];
    }else if (labelTag == 1) {
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"10",@"0",@"10"];
    }else if (labelTag == 2) {
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"20",@"0",@"10"];
    }else if (labelTag == 3) {
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"30",@"0",@"10"];
    }else if (labelTag == 4) {
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"40",@"0",@"10"];
    }else if (labelTag == 5) {
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"50",@"0",@"10"];
    }
    [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
         [MyObject endLoading];
        faildV.hidden = YES;
        _myParse = myParse;
        [self analyze:_myParse.dicBig];
    } failure:^(){
         [MyObject endLoading];
        faildV.hidden = NO;
    } ];
}
-(void)pullNet{
    NSArray *fileContent2 = USER_INFORMATION;
    NSString *url;
    if (labelTag == 0) {
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],@"10"];
    }else if (labelTag == 1) {
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"10",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],@"10"];
    }else if (labelTag == 2) {
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"20",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],@"10"];
    }else if (labelTag == 3) {
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"30",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],@"10"];
    }else if (labelTag == 4) {
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"40",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],@"10"];
    }else if (labelTag == 5) {
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&select_count=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"50",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],@"10"];
    }
    [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
         [MyObject endLoading];
        faildV.hidden = YES;
        _myParse = myParse;
        [self analyze_upDown:_myParse.dicBig];
    } failure:^(){
         [MyObject endLoading];
        faildV.hidden = NO;
    } ];
}
-(void)up_pull{
    if (orderlist_Array.count<10) {
    }else if (orderlist_Array.count>=10){
        if (requestBool == YES){
            if (orderlistPull_Array.count==10){
                 [MyObject startLoading];
                [self pullNet];
            }else if(orderlistPull_Array.count==0){
            }else{
            }
        }else{
            if (orderlistPull_Array.count%10==0){
                [MyObject startLoading];
                [self pullNet];
            }else{
            }
        }
    }
}
-(void)doTimer_signout{
    
    [LJControl cleanAll];
    AppDelegate *app = [AppDelegate sharedUserDefault];
    app.log_View.hidden = NO;
    
}
-(void)clearCacheSuccessOut{
    NSLog(@"成功");
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
