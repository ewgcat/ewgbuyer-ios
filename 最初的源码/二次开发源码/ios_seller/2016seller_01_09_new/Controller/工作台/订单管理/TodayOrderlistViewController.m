//
//  TodayOrderlistViewController.m
//  SellerApp
//
//  Created by apple on 15/5/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "TodayOrderlistViewController.h"
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
#import "OrderlistViewController.h"
#import "sqlService.h"
@interface TodayOrderlistViewController (){
    myselfParse *_myParse;
    OrderlistViewController *orderList;
}

@end

@implementation TodayOrderlistViewController


-(void)createBackBtn{
    UIButton *button = [LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(0, 0, 44, 44) setNormalImage:[UIImage imageNamed:@"back_lj"] setSelectedImage:[UIImage imageNamed:@"back_lj"] setTitle:@"" setTitleFont:17 setbackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}

-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnClicked:(UIButton *)btn{
    if (btn.tag == 100) {
        searchViewController *sear = [[searchViewController alloc]init];
        [self.navigationController pushViewController:sear animated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    btnClickedBool = NO;
    order_status = @"0";
    [self createBackBtn];
    labelTag = 0;
    requestBool = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    orderlist_Array = [[NSMutableArray alloc]init];
    orderlistPull_Array = [[NSMutableArray alloc]init];
    self.title = @"今日订单";
    orderList = [OrderlistViewController sharedUserDefault];
    if (UIDeviceSystem>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    
    UIImageView *imageNothing = [LJControl imageViewFrame:CGRectMake((ScreenFrame.size.width-133)/2, (ScreenFrame.size.height-117)/2, 133, 117) setImage:@"seller_center_nothing" setbackgroundColor:[UIColor clearColor]];
    [self.view addSubview:imageNothing];
    UILabel *labelNothing = [LJControl labelFrame:CGRectMake(0, imageNothing.frame.origin.y+imageNothing.frame.size.height, ScreenFrame.size.width, 30) setText:@"抱歉，没有找到相关数据" setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentCenter];
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
    
    NSArray *array=@[@"今日",@"待付款",@"待发货",@"已发货",@"已收货"];
    UISegmentedControl *segmentControl=[[UISegmentedControl alloc]initWithItems:array];
    segmentControl.frame=CGRectMake(10, 117, ScreenFrame.size.width-20, 34);
    segmentControl.selectedSegmentIndex=0;
    segmentControl.tintColor = NAV_COLOR;
    [segmentControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    segmentControl.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:segmentControl];
    
    orderlist_tableview = [[PullToRefreshTableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+152, ScreenFrame.size.width, ScreenFrame.size.height-152)];
    orderlist_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    orderlist_tableview.delegate = self;
    orderlist_tableview.dataSource=  self;
    orderlist_tableview.showsVerticalScrollIndicator=NO;
    orderlist_tableview.showsHorizontalScrollIndicator = NO;
    orderlist_tableview.backgroundColor = GRAY_COLOR;
    [self.view addSubview:orderlist_tableview];
    
    loadingV=[LJControl loadingView:CGRectMake((self.view.frame.size.width-100)/2, (self.view.frame.size.height-59-100)/2, 100, 100)];
    loadingV.hidden = YES;
    [self.view addSubview:loadingV];
    
    label_prompt =[LJControl labelFrame:CGRectMake(50, self.view.frame.size.height-100, self.view.frame.size.width-100, 30) setText:@"" setTitleFont:17 setbackgroundColor:[UIColor blackColor] setTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    [label_prompt.layer setMasksToBounds:YES];
    [label_prompt.layer setCornerRadius:4.0];
    label_prompt.alpha = 0.8;
    label_prompt.hidden = YES;
    [self.view addSubview:label_prompt];
}

-(void)viewWillAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    loadingV.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    NSArray *arr = [[NSString stringWithFormat:@"%@",[NSDate date]] componentsSeparatedByString:@" "];
    
    NSArray *fileContent2 = USER_INFORMATION;
    NSString *url;
    if (labelTag == 0) {
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
    }else if (labelTag == 1) {
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"10",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
    }else if (labelTag == 2) {
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"20",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
    }else if (labelTag == 3) {
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"30",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
    }else if (labelTag == 4) {
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"40",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
    }else if (labelTag == 5) {
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"50",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
    }
    [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
        loadingV.hidden = YES;
        _myParse = myParse;
        [self analyze:_myParse.dicBig];
    } failure:^(){
        [self fail];
    } ];
    [super viewWillAppear:YES];
}
-(void)fail{
    loadingV.hidden = YES;
    [MyObject failedPrompt:@"未能连接到服务器"];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
}
-(void)analyze_upDown:(NSDictionary *)dicBig{
    if (dicBig) {
        if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"]){
            [self.navigationController popToRootViewControllerAnimated:NO];
            //登录过期 提示重新登录
            [MyObject failedPrompt:@"用户登录已过期，请重新登录"];
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
    label_prompt.hidden = YES;
}
#pragma mark - seg点击事件
-(void)change:(UISegmentedControl *)segmentControl{
    
    if (segmentControl.selectedSegmentIndex == 0) {
        
        btnClickedBool = YES;
        loadingV.hidden = NO;
        labelTag = 0;
        All_label.textColor = [UIColor redColor];
        waitGoods_label.textColor = [UIColor blackColor];
        waitMoney_label.textColor = [UIColor blackColor];
        sendGoods_label.textColor = [UIColor blackColor];
        over_label.textColor = [UIColor blackColor];
        
        NSArray *arr = [[NSString stringWithFormat:@"%@",[NSDate date]] componentsSeparatedByString:@" "];
        NSArray *fileContent2 = USER_INFORMATION;
        NSString *url;
        if (labelTag == 0) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }else if (labelTag == 1) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"10",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }else if (labelTag == 2) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"20",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }else if (labelTag == 3) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"30",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }else if (labelTag == 4) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"40",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }else if (labelTag == 5) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"50",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }
        [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
            loadingV.hidden = YES;
            _myParse = myParse;
            [self analyze:_myParse.dicBig];
        } failure:^(){
            [self fail];
        } ];
        
    }else if(segmentControl.selectedSegmentIndex == 1){
        
        btnClickedBool = YES;
        loadingV.hidden = NO;
        labelTag = 1;
        [orderlist_tableview reloadData];
        All_label.textColor = [UIColor blackColor];
        waitGoods_label.textColor = [UIColor blackColor];
        waitMoney_label.textColor = [UIColor redColor];
        sendGoods_label.textColor = [UIColor blackColor];
        over_label.textColor = [UIColor blackColor];
        
        NSArray *arr = [[NSString stringWithFormat:@"%@",[NSDate date]] componentsSeparatedByString:@" "];
        NSArray *fileContent2 = USER_INFORMATION;
        NSString *url;
        if (labelTag == 0) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }else if (labelTag == 1) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"10",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }else if (labelTag == 2) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"20",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }else if (labelTag == 3) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"30",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }else if (labelTag == 4) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"40",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }else if (labelTag == 5) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"50",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }
        [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
            loadingV.hidden = YES;
            _myParse = myParse;
            [self analyze:_myParse.dicBig];
        } failure:^(){
            [self fail];
        } ];
        
    }else if(segmentControl.selectedSegmentIndex == 2){
        
        btnClickedBool = YES;
        loadingV.hidden = NO;
        labelTag = 2;
        All_label.textColor = [UIColor blackColor];
        waitGoods_label.textColor = [UIColor redColor];
        waitMoney_label.textColor = [UIColor blackColor];
        sendGoods_label.textColor = [UIColor blackColor];
        over_label.textColor = [UIColor blackColor];
        
        NSArray *arr = [[NSString stringWithFormat:@"%@",[NSDate date]] componentsSeparatedByString:@" "];
        NSArray *fileContent2 = USER_INFORMATION;
        NSString *url;
        if (labelTag == 0) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }else if (labelTag == 1) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"10",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }else if (labelTag == 2) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"20",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }else if (labelTag == 3) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"30",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }else if (labelTag == 4) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"40",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }else if (labelTag == 5) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"50",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }
        [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
            loadingV.hidden = YES;
            _myParse = myParse;
            [self analyze:_myParse.dicBig];
        } failure:^(){
            [self fail];
        } ];
        
    }else if(segmentControl.selectedSegmentIndex == 3){
        
        btnClickedBool = YES;
        loadingV.hidden = NO;
        labelTag = 3;
        All_label.textColor = [UIColor blackColor];
        waitGoods_label.textColor = [UIColor blackColor];
        waitMoney_label.textColor = [UIColor blackColor];
        sendGoods_label.textColor = [UIColor redColor];
        over_label.textColor = [UIColor blackColor];
        
        NSArray *arr = [[NSString stringWithFormat:@"%@",[NSDate date]] componentsSeparatedByString:@" "];
        NSArray *fileContent2 = USER_INFORMATION;
        NSString *url;
        if (labelTag == 0) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }else if (labelTag == 1) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"10",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }else if (labelTag == 2) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"20",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }else if (labelTag == 3) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"30",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }else if (labelTag == 4) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"40",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }else if (labelTag == 5) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"50",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }
        [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
            loadingV.hidden = YES;
            _myParse = myParse;
            [self analyze:_myParse.dicBig];
        } failure:^(){
            [self fail];
        } ];
        
    }else{
        
        btnClickedBool = YES;
        loadingV.hidden = NO;
        labelTag = 5;
        All_label.textColor = [UIColor blackColor];
        waitGoods_label.textColor = [UIColor blackColor];
        waitMoney_label.textColor = [UIColor blackColor];
        sendGoods_label.textColor = [UIColor blackColor];
        over_label.textColor = [UIColor redColor];
        
        NSArray *arr = [[NSString stringWithFormat:@"%@",[NSDate date]] componentsSeparatedByString:@" "];
        
        NSArray *fileContent2 = USER_INFORMATION;
        NSString *url;
        if (labelTag == 0) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }else if (labelTag == 1) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"10",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }else if (labelTag == 2) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"20",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }else if (labelTag == 3) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"30",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }else if (labelTag == 4) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"40",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }else if (labelTag == 5) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"50",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
        }
        [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
            loadingV.hidden = YES;
            _myParse = myParse;
            [self analyze:_myParse.dicBig];
        } failure:^(){
            [self fail];
        } ];
        
    }
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
            over_btn.frame = CGRectMake(self.view.frame.size.width-118-6, 198.5+44, 100, 44);
            over_btn.tag = indexPath.row;
            [over_btn addTarget:self action:@selector(cellCancelbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:over_btn];
            
            UIButton *Price_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            Price_btn.frame = CGRectMake(self.view.frame.size.width-118-6-110, 198.5+44, 100, 44);
            Price_btn.tag = indexPath.row;
            [Price_btn addTarget:self action:@selector(cellPricebtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:Price_btn];
        }else if ([mymodel.order_status intValue] == 20){//待发货
            UIButton *over_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            over_btn.frame = CGRectMake(self.view.frame.size.width-118-6, 198.5+44, 100, 44);
            over_btn.tag = indexPath.row;
            [over_btn addTarget:self action:@selector(cellSendbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:over_btn];
        }else if ([mymodel.order_status intValue] == 30){// 已发货
            UIButton *over_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            over_btn.frame = CGRectMake(self.view.frame.size.width-118-6, 198.5+44, 100, 44);
            over_btn.tag = indexPath.row;
            [over_btn addTarget:self action:@selector(cellShipbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:over_btn];
            
            UIButton *Price_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            Price_btn.frame = CGRectMake(self.view.frame.size.width-118-6-130, 229, 120, 44);
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
        orderList.order_id = mmm.order_id;
        OrderDetailViewController *order = [[OrderDetailViewController alloc]init];
        [self.navigationController pushViewController:order animated:YES];
    }
}
#pragma mark - 点击事件
-(void)cellSendbtnClicked:(UIButton *)btn{
    if (orderlist_Array.count!=0) {
        Model *mmm = [orderlist_Array objectAtIndex:btn.tag];
        orderList.order_id = mmm.order_id;
        confirmdeliveryViewController *inin = [[confirmdeliveryViewController alloc]init];
        [self.navigationController pushViewController:inin animated:YES];
    }
}

-(void)cellShipbtnClicked:(UIButton *)btn{
    if (orderlist_Array.count!=0) {
        Model *mmm = [orderlist_Array objectAtIndex:btn.tag];
        orderList.order_id = mmm.order_id;
        ModifyShipViewController *modify = [[ModifyShipViewController alloc]init];
        [self.navigationController pushViewController:modify animated:YES];
    }
}
-(void)cellTimebtnClicked:(UIButton *)btn{
    if (orderlist_Array.count!=0) {
        Model *mmm = [orderlist_Array objectAtIndex:btn.tag];
        orderList.order_num = mmm.order_num;
        orderList.order_id = mmm.order_id;
        delayViewController *delay = [[delayViewController alloc]init];
        [self.navigationController pushViewController:delay animated:YES];
    }
}

-(void)cellCancelbtnClicked:(UIButton *)btn{
    if (orderlist_Array.count!=0) {
        Model *mmm = [orderlist_Array objectAtIndex:btn.tag];
        orderList.order_id = mmm.order_id;
        orderList.order_num = mmm.order_num;
        OrderCancelViewController *modify = [[OrderCancelViewController alloc]init];
        [self.navigationController pushViewController:modify animated:YES];
    }
}

-(void)cellPricebtnClicked:(UIButton *)btn{
    if (orderlist_Array.count!=0) {
        Model *mmm = [orderlist_Array objectAtIndex:btn.tag];
        orderList.order_id = mmm.order_id;
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
#pragma mark - PullingRefreshTableViewDelegate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)down_pull{
    loadingV.hidden = NO;
    NSArray *arr = [[NSString stringWithFormat:@"%@",[NSDate date]] componentsSeparatedByString:@" "];
    NSArray *fileContent2 = USER_INFORMATION;
    NSString *url;
    if (labelTag == 0) {
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
    }else if (labelTag == 1) {
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"10",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
    }else if (labelTag == 2) {
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"20",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
    }else if (labelTag == 3) {
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"30",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
    }else if (labelTag == 4) {
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"40",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
    }else if (labelTag == 5) {
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"50",@"0",[arr objectAtIndex:0],[arr objectAtIndex:0]];
    }
    [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
        loadingV.hidden = YES;
        _myParse = myParse;
        [self analyze:_myParse.dicBig];
    } failure:^(){
        [self fail];
    } ];
}
-(void)up_pull{
    if (orderlist_Array.count<10) {
    }else if (orderlist_Array.count>=10){
        if (requestBool == YES){
            if (orderlistPull_Array.count==10){
                loadingV.hidden = NO;
                NSArray *arr = [[NSString stringWithFormat:@"%@",[NSDate date]] componentsSeparatedByString:@" "];
                NSArray *fileContent2 = USER_INFORMATION;
                NSString *url;
                if (labelTag == 0) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],[arr objectAtIndex:0],[arr objectAtIndex:0]];
                }else if (labelTag == 1) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"10",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],[arr objectAtIndex:0],[arr objectAtIndex:0]];
                }else if (labelTag == 2) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"20",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],[arr objectAtIndex:0],[arr objectAtIndex:0]];
                }else if (labelTag == 3) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"30",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],[arr objectAtIndex:0],[arr objectAtIndex:0]];
                }else if (labelTag == 4) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"40",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],[arr objectAtIndex:0],[arr objectAtIndex:0]];
                }else if (labelTag == 5) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"50",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],[arr objectAtIndex:0],[arr objectAtIndex:0]];
                }
                [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
                    loadingV.hidden = YES;
                    _myParse = myParse;
                    [self analyze_upDown:_myParse.dicBig];
                } failure:^(){
                    [self fail];
                } ];
            }else if(orderlistPull_Array.count==0){
            }else{
            }
        }else{
            if (orderlistPull_Array.count%10==0){
                loadingV.hidden = NO;
                NSArray *arr = [[NSString stringWithFormat:@"%@",[NSDate date]] componentsSeparatedByString:@" "];
                NSArray *fileContent2 = USER_INFORMATION;
                NSString *url;
                if (labelTag == 0) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],[arr objectAtIndex:0],[arr objectAtIndex:0]];
                }else if (labelTag == 1) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"10",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],[arr objectAtIndex:0],[arr objectAtIndex:0]];
                }else if (labelTag == 2) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"20",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],[arr objectAtIndex:0],[arr objectAtIndex:0]];
                }else if (labelTag == 3) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"30",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],[arr objectAtIndex:0],[arr objectAtIndex:0]];
                }else if (labelTag == 4) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"40",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],[arr objectAtIndex:0],[arr objectAtIndex:0]];
                }else if (labelTag == 5) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_status=%@&begin_count=%@&beginTime=%@&endTime=%@",SELLER_URL,ORDER_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"50",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],[arr objectAtIndex:0],[arr objectAtIndex:0]];
                }
                [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
                    loadingV.hidden = YES;
                    _myParse = myParse;
                    [self analyze_upDown:_myParse.dicBig];
                } failure:^(){
                    [self fail];
                } ];
            }else{
            }
        }
    }
}
- (void)updateTableView{
    if ([orderlist_Array count] < 10) {
        [orderlist_tableview reloadData:YES];
    } else {
        if (orderlist_Array.count>=10){
            if (requestBool == YES) {
                if (orderlistPull_Array.count==10){
                    [orderlist_tableview reloadData:NO];
                }else if(orderlistPull_Array.count==0){
                    [orderlist_tableview reloadData:YES];
                }else{
                    [orderlist_tableview reloadData:YES];
                }
            }else{
                if (orderlistPull_Array.count%10==0){
                    [orderlist_tableview reloadData:NO];
                }else{
                    [orderlist_tableview reloadData:YES];
                }
            }
        }
    }
}

- (void)updateThread:(NSString *)returnKey{
    sleep(2);
    switch ([returnKey intValue]) {
        case k_RETURN_REFRESH:
            [self down_pull];
            break;
        case k_RETURN_LOADMORE:
            [self up_pull];
            break;
        default:
            break;
    }
    [self performSelectorOnMainThread:@selector(updateTableView) withObject:nil waitUntilDone:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (btnClickedBool == YES) {
        [orderlist_tableview myState];
    }else{
        [orderlist_tableview tableViewDidDragging];
    }
    btnClickedBool = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSInteger returnKey = [orderlist_tableview tableViewDidEndDragging];
    
    if (returnKey != k_RETURN_DO_NOTHING) {
        NSString * key = [NSString stringWithFormat:@"%ld", (long)returnKey];
        [NSThread detachNewThreadSelector:@selector(updateThread:) toTarget:self withObject:key];
    }else{
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        float reload_distance = -20;
        if(y > h + reload_distance) {
            [NSThread detachNewThreadSelector:@selector(updateThread:) toTarget:self withObject:@"2"];
        }
    }
}


-(void)doTimer_signout{
    label_prompt.hidden = YES;
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

@end
