//
//  GoodsViewController.m
//  SellerApp
//
//  Created by apple on 15-3-20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "GoodsViewController.h"
#import "Model.h"
#import "goodseditViewController.h"
#import "OrderlistViewController.h"
#import "AppDelegate.h"
#import "GoodsCell.h"
#import "TreeViewNode.h"
#import "TheProjectCell.h"
#import "sqlService.h"

@interface GoodsViewController (){
    myselfParse *_myParse;
    UITextField *SearchTextField;
}

@end

static GoodsViewController *singleInstance=nil;

@implementation GoodsViewController
@synthesize button_edit;

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
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    loadingV.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    [self netJson];
    [super viewWillAppear:YES];
}


-(void)doTimer{
    label_prompt.hidden = YES;
}





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    timeBool = NO;
    salesnumBool = NO;
    inventoryBool = NO;
    btnClickedBool = NO;
    requestBool = NO;
    allBool = NO;
    classify_ID= -1;
    self.title = @"商品信息";
    if (UIDeviceSystem>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    orderlist_Array = [[NSMutableArray alloc]init];
    orderlistPull_Array= [[NSMutableArray alloc]init];
    displayArray = [[NSMutableArray alloc]init];
    nodes = [[NSMutableArray alloc]init];
    labelTag = 0;
    filterlabelTag = 0;
    
    SearchTextField = [LJControl textFieldFrame:CGRectMake(10, 73, self.view.frame.size.width-20, 34) text:@"" placeText:@"  🔍丨输入订单号或买家账户名称查询" setfont:17 textColor:[UIColor blackColor] keyboard:UIKeyboardTypeDefault];
    SearchTextField.backgroundColor = GRAY_COLOR;
    SearchTextField.delegate = self;
    [self.view addSubview:SearchTextField];
    
    NSArray *array=@[@"出售中",@"仓库",@"违规下架",@"分类"];
    UISegmentedControl *segmentControl=[[UISegmentedControl alloc]initWithItems:array];
    segmentControl.frame=CGRectMake(10, 117, ScreenFrame.size.width-20, 34);
    segmentControl.selectedSegmentIndex=0;
    segmentControl.tintColor = NAV_COLOR;
    [segmentControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    segmentControl.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:segmentControl];
    
    UIImageView *imageNothing = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenFrame.size.width-133)/2, (ScreenFrame.size.height-87)/2, 133, 117)];
    imageNothing.image = [UIImage imageNamed:@"seller_center_nothing"];
    [self.view addSubview:imageNothing];
    UILabel *labelNothing = [[UILabel alloc]initWithFrame:CGRectMake(0, imageNothing.frame.origin.y+imageNothing.frame.size.height, ScreenFrame.size.width, 30)];
    labelNothing.text = @"抱歉，没有找到相关数据";
    labelNothing.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labelNothing];
    
    UIButton *time_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    time_btn.frame = CGRectMake(self.view.frame.size.width/3*0, 151, self.view.frame.size.width/3, 44);
    time_btn.tag = 100;
    [time_btn addTarget:self action:@selector(filterbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:time_btn];
    time_label=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/3*0, 151, self.view.frame.size.width/3, 44)];
    time_label.text=@"↑添加时间";
    time_label.backgroundColor=[UIColor clearColor];
    time_label.textAlignment=NSTextAlignmentCenter;
    time_label.textColor=[UIColor redColor];
    time_label.font=[UIFont boldSystemFontOfSize:16];
    [self.view addSubview:time_label];
    UIButton *salenumber_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    salenumber_btn.frame = CGRectMake(self.view.frame.size.width/3*1, 151, self.view.frame.size.width/3, 44);
    salenumber_btn.tag = 101;
    [salenumber_btn addTarget:self action:@selector(filterbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:salenumber_btn];
    salenumber_label=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/3*1, 151, self.view.frame.size.width/3, 44)];
    salenumber_label.text=@"销量";
    salenumber_label.backgroundColor=[UIColor clearColor];
    salenumber_label.textAlignment=NSTextAlignmentCenter;
    salenumber_label.textColor=[UIColor blackColor];
    salenumber_label.font=[UIFont boldSystemFontOfSize:16];
    [self.view addSubview:salenumber_label];
    UIButton *inventory_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    inventory_btn.frame = CGRectMake(self.view.frame.size.width/3*2, 151, self.view.frame.size.width/3, 44);
    inventory_btn.tag = 102;
    [inventory_btn addTarget:self action:@selector(filterbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inventory_btn];
    inventory_label=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/3*2, 151, self.view.frame.size.width/3, 44)];
    inventory_label.text=@"库存";
    inventory_label.backgroundColor=[UIColor clearColor];
    inventory_label.textAlignment=NSTextAlignmentCenter;
    inventory_label.textColor=[UIColor blackColor];
    inventory_label.font=[UIFont boldSystemFontOfSize:16];
    [self.view addSubview:inventory_label];
    for(int i=0;i<2;i++){
        UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/3*(i+1), 162, 0.5, 20)];
        imageLine.backgroundColor = [UIColor darkGrayColor];
        [self.view addSubview:imageLine];
    }
    UIImageView *imageV2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 190, self.view.frame.size.width, 5)];
    imageV2.backgroundColor = GRAY_COLOR;
    [self.view addSubview:imageV2];
    
    orderlist_tableview = [[PullToRefreshTableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+195, ScreenFrame.size.width, ScreenFrame.size.height-195)];
    orderlist_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    orderlist_tableview.delegate = self;
    orderlist_tableview.dataSource=  self;
    orderlist_tableview.showsVerticalScrollIndicator=NO;
    orderlist_tableview.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:orderlist_tableview];
    
    classify_tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+153, ScreenFrame.size.width, ScreenFrame.size.height-153)];
    classify_tableview.delegate = self;
    classify_tableview.dataSource=  self;
    classify_tableview.showsVerticalScrollIndicator=NO;
    classify_tableview.showsHorizontalScrollIndicator = NO;
    classify_tableview.hidden = YES;
    [self.view addSubview:classify_tableview];
    
    faildV = [LJControl netFaildView];
    faildV.hidden = YES;
    [self.view addSubview:faildV];
    UIButton *buttonR = [LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake((ScreenFrame.size.width-100)/2, 390, 100, 44) setNormalImage:[UIImage imageNamed:@""] setSelectedImage:[UIImage imageNamed:@""] setTitle:@"重新加载" setTitleFont:17 setbackgroundColor:[UIColor clearColor]];
    [buttonR addTarget:self action:@selector(loadingNet) forControlEvents:UIControlEventTouchUpInside];
    [buttonR setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [buttonR.layer setMasksToBounds:YES];
    [buttonR.layer setCornerRadius:8];
    buttonR.layer.borderWidth = 1;
    buttonR.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [faildV addSubview:buttonR];
    
    loadingV=[LJControl loadingView:CGRectMake((self.view.frame.size.width-100)/2, (self.view.frame.size.height-59-100)/2, 100, 100)];
    loadingV.hidden = YES;
    [self.view addSubview:loadingV];
    
    label_prompt =[LJControl labelFrame:CGRectMake(50, self.view.frame.size.height-100, self.view.frame.size.width-100, 30) setText:@"" setTitleFont:17 setbackgroundColor:[UIColor blackColor] setTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    [label_prompt.layer setMasksToBounds:YES];
    [label_prompt.layer setCornerRadius:4.0];
    label_prompt.alpha = 0.8;
    label_prompt.hidden = YES;
    [self.view addSubview:label_prompt];
    
    edit_view = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenFrame.size.height, ScreenFrame.size.width, 60)];
    edit_view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:edit_view];
    UIImageView *kImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 0.5)];
    kImage1.backgroundColor = [UIColor lightGrayColor];
    [edit_view addSubview:kImage1];
    All_Image = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 20, 20)];
    All_Image.backgroundColor = [UIColor whiteColor];
    All_Image.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    All_Image.layer.borderWidth = 0.5;
    All_Image.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    [All_Image.layer setMasksToBounds:YES];
    [All_Image.layer setCornerRadius:4.0];
    [edit_view addSubview:All_Image];
    UILabel *la1=[[UILabel alloc]initWithFrame:CGRectMake(50, 20, 80, 20)];
    la1.text=@"全选";
    la1.textColor=[UIColor darkGrayColor];
    la1.font=[UIFont systemFontOfSize:15];
    [edit_view addSubview:la1];
    
    UIButton *buttonAll = [UIButton buttonWithType:UIButtonTypeCustom ];
    buttonAll.frame =CGRectMake(0, 0, 100, 60);
    [buttonAll addTarget:self action:@selector(all_btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [edit_view addSubview:buttonAll];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
    button.frame =CGRectMake(ScreenFrame.size.width-100, 8, 80, 44);
    [button setTitle:@"删除" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    button.backgroundColor = [UIColor redColor];
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:4.0f];
    [button addTarget:self action:@selector(delete_btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [edit_view addSubview:button];
    btnDown = [UIButton buttonWithType:UIButtonTypeCustom ];
    btnDown.frame =CGRectMake(ScreenFrame.size.width-200, 8, 80, 44);
    [btnDown setTitle:@"下架" forState:UIControlStateNormal];
    btnDown.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    btnDown.backgroundColor = [UIColor grayColor];
    [btnDown.layer setMasksToBounds:YES];
    [btnDown.layer setCornerRadius:4.0f];
    [btnDown addTarget:self action:@selector(goodsdownBtnclicked) forControlEvents:UIControlEventTouchUpInside];
    [edit_view addSubview:btnDown];
    btnUp = [UIButton buttonWithType:UIButtonTypeCustom ];
    btnUp.frame =CGRectMake(ScreenFrame.size.width-200, 8, 80, 44);
    [btnUp setTitle:@"上架" forState:UIControlStateNormal];
    btnUp.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    btnUp.backgroundColor = [UIColor greenColor];
    [btnUp.layer setMasksToBounds:YES];
    [btnUp.layer setCornerRadius:4.0f];
    [btnUp addTarget:self action:@selector(goodsUpBtnclicked) forControlEvents:UIControlEventTouchUpInside];
    [edit_view addSubview:btnUp];
}


#pragma mark - 网络解析
-(void)netJson{
    NSArray *fileContent2 = USER_INFORMATION;
    NSString *url;
    if (labelTag == 0) {
        if (filterlabelTag == 0) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"addTime",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }else if (filterlabelTag == 1) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_salenum",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }else{
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_inventory",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }else if (labelTag == 1) {
        if (filterlabelTag == 0) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"addTime",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }else if (filterlabelTag == 1) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"goods_salenum",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }else{
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"goods_inventory",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        
    }else if (labelTag == 2) {
        if (filterlabelTag == 0) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"addTime",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }else if (filterlabelTag == 1) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"goods_salenum",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }else{
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"goods_inventory",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }else {//应该是分类
        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@",SELLER_URL,STORE_GOODS_CLASSIFY_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0]];
    }
    [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
        loadingV.hidden = YES;
        faildV.hidden = YES;
        _myParse = myParse;
        if (labelTag == 3) {
            [self classify:_myParse.dicBig];
        }else{
            [self analyze:_myParse.dicBig];
        }
        
    } failure:^(){
        loadingV.hidden = YES;
        faildV.hidden = NO;
    } ];
}
-(void)analyzePull:(NSDictionary *)dicBig{
    if (dicBig) {
        if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"]){
            [self.navigationController popToRootViewControllerAnimated:NO];
            //登录过期 提示重新登录
            [MyObject failedPrompt:@"用户登录已过期，请重新登录"];
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
        }else{
            NSArray *array = [dicBig objectForKey:@"goods_list"];
            if (orderlistPull_Array.count!=0) {
                [orderlistPull_Array removeAllObjects];
            }
            for(NSDictionary *dic in array){
                Model *my = [[Model alloc]init];
                my.addTime = [dic objectForKey:@"addTime"];
                my.goods_price = [dic objectForKey:@"goods_current_price"];
                my.goods_inventory = [dic objectForKey:@"goods_inventory"];
                my.goods_main_photo = [dic objectForKey:@"goods_main_photo"];
                my.goods_name = [dic objectForKey:@"goods_name"];
                my.goods_salenum = [dic objectForKey:@"goods_salenum"];
                my.goods_id = [dic objectForKey:@"id"];
                [orderlistPull_Array addObject:my];
            }
            if (orderlistPull_Array.count!=0) {
                if (allBool == NO) {
                    
                }else{
                    allBool = NO;
                    All_Image.image = [UIImage imageNamed:@""];
                }
            }else{
            }
            [orderlist_Array addObjectsFromArray:orderlistPull_Array];
            requestBool = YES;
            [orderlist_tableview reloadData];
            
        }
    }
}
-(void)analyze:(NSDictionary *)dicBig{
    if (dicBig) {
        if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"]){
            [self.navigationController popToRootViewControllerAnimated:NO];
            //登录过期 提示重新登录
            [MyObject failedPrompt:@"用户登录已过期，请重新登录"];
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
        }else{
            NSArray *array = [dicBig objectForKey:@"goods_list"];
            if (orderlist_Array.count !=0) {
                [orderlist_Array removeAllObjects];
            }
            for(NSDictionary *dic in array){
                Model *my = [[Model alloc]init];
                my.addTime = [dic objectForKey:@"addTime"];
                my.goods_price = [dic objectForKey:@"goods_current_price"];
                my.goods_inventory = [dic objectForKey:@"goods_inventory"];
                my.goods_main_photo = [dic objectForKey:@"goods_main_photo"];
                my.goods_name = [dic objectForKey:@"goods_name"];
                my.goods_salenum = [dic objectForKey:@"goods_salenum"];
                my.goods_id = [dic objectForKey:@"id"];
                [orderlist_Array addObject:my];
            }
            if (orderlist_Array.count ==0) {
                orderlist_tableview.hidden = YES;
            }else{
                orderlist_tableview.hidden = NO;
            }
            [orderlist_tableview reloadData];
        }
    }
}
-(void)loadingNet{
    loadingV.hidden = NO;
    [self netJson];
}
-(void)classify:(NSDictionary *)dicBig{
    if (dicBig) {
        if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"]){
            [self.navigationController popToRootViewControllerAnimated:NO];
            //登录过期 提示重新登录
            [MyObject failedPrompt:@"用户登录已过期，请重新登录"];
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
        }else{
            [nodes removeAllObjects];
            NSArray *arr = [dicBig objectForKey:@"class_list"];
            for(NSDictionary *dic  in arr){
                TreeViewNode *firstLevelNode1 = [[TreeViewNode alloc]init];
                firstLevelNode1.nodeLevel = 0;
                firstLevelNode1.nodeObject = [NSString stringWithFormat:@"Parent node 1"];
                firstLevelNode1.name = [dic objectForKey:@"className"];
                firstLevelNode1.class_id = [[dic objectForKey:@"id"] intValue];
                firstLevelNode1.isExpanded = YES;
                NSArray *chirldArr = [dic objectForKey:@"child_list"];
                firstLevelNode1.nodeChildren = [[self fillChildrenForNode:chirldArr] mutableCopy];
                [nodes addObject:firstLevelNode1];
            }
            [displayArray removeAllObjects];
            for (TreeViewNode *node in nodes) {
                [displayArray addObject:node];
                if (node.isExpanded) {
                    [self fillNodeWithChildrenArray:node.nodeChildren];
                }
            }
            [classify_tableview reloadData];
        }
    }
}
#pragma mark - seg点击事件
-(void)change:(UISegmentedControl *)segmentControl{
    [SearchTextField resignFirstResponder];
    classify_ID = -1;
    goodid_Str = @"";
    All_Image.image = [UIImage imageNamed:@""];
    loadingV.hidden = NO;
    if (segmentControl.selectedSegmentIndex == 0) {
        
        edit_view.hidden = NO;
        button_edit.tintColor = [UIColor whiteColor];
        button_edit.enabled = YES;
        
        classify_tableview.hidden = YES;
        orderlist_tableview.hidden = NO;
        
        btnClickedBool = YES;
        labelTag = 0;
        btnUp.hidden = YES;
        btnDown.hidden = NO;
        ON_label.textColor = [UIColor redColor];
        illegal_label.textColor = [UIColor blackColor];
        depot_label.textColor = [UIColor blackColor];
        category_label.textColor = [UIColor blackColor];
        
        NSArray *fileContent2 = USER_INFORMATION;
        NSString *url;
        if (labelTag == 0) {
            if (filterlabelTag == 0) {
                url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"addTime",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }else if (filterlabelTag == 1) {
                url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_salenum",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }else{
                url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_inventory",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
        }else if (labelTag == 1) {
            if (filterlabelTag == 0) {
                url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"addTime",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }else if (filterlabelTag == 1) {
                url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"goods_salenum",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }else{
                url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"goods_inventory",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
        }else if (labelTag == 2) {
            if (filterlabelTag == 0) {
                url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"addTime",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }else if (filterlabelTag == 1) {
                url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"goods_salenum",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }else{
                url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"goods_inventory",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
        }else {//应该是分类
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@",SELLER_URL,STORE_GOODS_CLASSIFY_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0]];
        }
        [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
            loadingV.hidden = YES;
            faildV.hidden = YES;
            _myParse = myParse;
            if (labelTag == 3) {
                [self classify:_myParse.dicBig];
            }else {
                [self analyze:_myParse.dicBig];
            }
        } failure:^(){
            loadingV.hidden = YES;
            faildV.hidden = NO;
        } ];
        
    }else if(segmentControl.selectedSegmentIndex == 1){
        
        edit_view.hidden = NO;
        button_edit.tintColor = [UIColor whiteColor];
        button_edit.enabled = YES;
        classify_tableview.hidden = YES;
        orderlist_tableview.hidden = NO;
        
        btnClickedBool = YES;
        labelTag = 1;
        btnUp.hidden = NO;
        btnDown.hidden = YES;
        ON_label.textColor = [UIColor blackColor];
        illegal_label.textColor = [UIColor blackColor];
        depot_label.textColor = [UIColor redColor];
        category_label.textColor = [UIColor blackColor];
        
        
        NSArray *fileContent2 = USER_INFORMATION;
        NSString *url;
        if (labelTag == 0) {
            if (filterlabelTag == 0) {
                url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"addTime",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }else if (filterlabelTag == 1) {
                url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_salenum",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }else{
                url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_inventory",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
        }else if (labelTag == 1) {
            if (filterlabelTag == 0) {
                url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"addTime",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }else if (filterlabelTag == 1) {
                url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"goods_salenum",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }else{
                url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"goods_inventory",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
        }else if (labelTag == 2) {
            if (filterlabelTag == 0) {
                url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"addTime",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }else if (filterlabelTag == 1) {
                url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"goods_salenum",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }else{
                url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"goods_inventory",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
        }else {//应该是分类
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@",SELLER_URL,STORE_GOODS_CLASSIFY_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0]];
        }
        [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
            loadingV.hidden = YES;
            faildV.hidden = YES;
            _myParse = myParse;
            if (labelTag == 3) {
                [self classify:_myParse.dicBig];
            }else{
                [self analyze:_myParse.dicBig];
            }
        } failure:^(){
            loadingV.hidden = YES;
            faildV.hidden = NO;
        } ];
        
    }else if(segmentControl.selectedSegmentIndex == 2){
        
        edit_view.hidden = NO;
        button_edit.tintColor = [UIColor whiteColor];
        button_edit.enabled = YES;
        classify_tableview.hidden = YES;
        orderlist_tableview.hidden = NO;
        btnClickedBool = YES;
        labelTag = 2;
        btnUp.hidden = YES;
        btnDown.hidden = YES;
        ON_label.textColor = [UIColor blackColor];
        illegal_label.textColor = [UIColor redColor];
        depot_label.textColor = [UIColor blackColor];
        category_label.textColor = [UIColor blackColor];
        
        NSArray *fileContent2 = USER_INFORMATION;
        NSString *url;
        if (labelTag == 0) {
            if (filterlabelTag == 0) {
                url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"addTime",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }else if (filterlabelTag == 1) {
                url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_salenum",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }else{
                url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_inventory",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
        }else if (labelTag == 1) {
            if (filterlabelTag == 0) {
                url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"addTime",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }else if (filterlabelTag == 1) {
                url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"goods_salenum",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }else{
                url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"goods_inventory",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
        }else if (labelTag == 2) {
            if (filterlabelTag == 0) {
                url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"addTime",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }else if (filterlabelTag == 1) {
                url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"goods_salenum",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }else{
                url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"goods_inventory",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
        }else {//应该是分类
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@",SELLER_URL,STORE_GOODS_CLASSIFY_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0]];
        }
        [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
            loadingV.hidden = YES;
            faildV.hidden = YES;
            _myParse = myParse;
            if (labelTag == 3) {
                [self classify:_myParse.dicBig];
            }else{
                [self analyze:_myParse.dicBig];
            }
        } failure:^(){
            loadingV.hidden = YES;
            faildV.hidden = NO;
        } ];
        
    }else{
        
        edit_view.hidden = YES;
        button_edit.tintColor = [UIColor clearColor];
        button_edit.enabled = NO;
        classify_tableview.hidden = NO;
        orderlist_tableview.hidden = YES;
        btnClickedBool = YES;
        labelTag = 3;
        ON_label.textColor = [UIColor blackColor];
        illegal_label.textColor = [UIColor blackColor];
        depot_label.textColor = [UIColor blackColor];
        category_label.textColor = [UIColor redColor];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(expandCollapseNode:) name:@"ProjectTreeNodeButtonClicked" object:nil];
        
        NSArray *fileContent2 = USER_INFORMATION;
        NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@",SELLER_URL,STORE_GOODS_CLASSIFY_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0]];
        [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
            loadingV.hidden = YES;
            faildV.hidden = YES;
            _myParse = myParse;
            [self classify:_myParse.dicBig];
        } failure:^(){
            loadingV.hidden = YES;
            faildV.hidden = NO;
        } ];
        
    }
}
#pragma mark - UITextField
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self netJson];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    return YES;
}
#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == orderlist_tableview) {
        if (orderlist_Array.count != 0) {
            return orderlist_Array.count;
        }
    }
    if (tableView == classify_tableview) {
        return displayArray.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == orderlist_tableview) {
        return 98;
    }else{
        return 44;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == orderlist_tableview) {
        static NSString *myTabelviewCell = @"GoodsCell";
        GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsCell" owner:self options:nil] lastObject];
        }
        if (orderlist_Array.count!=0) {
            Model *mm = [orderlist_Array objectAtIndex:indexPath.row];
            [cell my_cell:mm goodid_Str:goodid_Str];
            
            [cell.buttonSelect addTarget:self action:@selector(selectBtnclicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.buttonSelect.tag = 100+indexPath.row;
            
            [cell.buttonEdit addTarget:self action:@selector(edit_btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.buttonEdit.tag = 100+indexPath.row;
            if ([button_edit.title isEqualToString:@"完成"]) {
                cell.buttonEdit.hidden = NO;
                cell.selectview.hidden = NO;
            }else{
                cell.buttonEdit.hidden = YES;
                cell.selectview.hidden = YES;
            }
        }
        return cell;
    }else{
        static NSString *CellIdentifier = @"treeNodeCell";
        UINib *nib = [UINib nibWithNibName:@"ProjectCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        
        TheProjectCell *cell = (TheProjectCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        TreeViewNode *node = [displayArray objectAtIndex:indexPath.row];
        cell.treeNode = node;
        
        cell.cellLabel.text = [NSString stringWithFormat:@"        %@",node.name];
        
        [cell setNeedsDisplay];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [SearchTextField resignFirstResponder];
    if (tableView == classify_tableview) {
        TreeViewNode *node = [displayArray objectAtIndex:indexPath.row];
        //首先出售中按钮变红色 其余黑色，隐藏分类tableview；其次发起请求拿到该分类下的商品，并刷新列表，；
        classify_tableview.hidden = YES;
        orderlist_tableview.hidden = NO;
        edit_view.hidden = NO;
        button_edit.tintColor = [UIColor whiteColor];
        button_edit.enabled = YES;
        labelTag = 0;
        btnUp.hidden = YES;
        btnDown.hidden = NO;
        ON_label.textColor = [UIColor redColor];
        illegal_label.textColor = [UIColor blackColor];
        depot_label.textColor = [UIColor blackColor];
        category_label.textColor = [UIColor blackColor];
        loadingV.hidden = NO;
        classify_ID = node.class_id;
        NSArray *fileContent2 = USER_INFORMATION;
        NSString *url;
        if (labelTag == 0) {
            if (filterlabelTag == 0) {
                if (timeBool == NO) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&user_goodsclass_id=%d&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"addTime",@"asc",@"0",@"10",(int)node.class_id,[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    timeBool = YES;
                    time_label.text = @"↑添加时间";
                }else{
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&user_goodsclass_id=%d&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"addTime",@"desc",@"0",@"10",(int)node.class_id,[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    timeBool = NO;
                    time_label.text = @"↓添加时间";
                }
            }else if (filterlabelTag == 1) {
                if (timeBool == NO) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&user_goodsclass_id=%d&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_salenum",@"asc",@"0",@"10",(int)node.class_id,[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    timeBool = YES;
                    time_label.text = @"↑添加时间";
                }else{
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&user_goodsclass_id=%d&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_salenum",@"desc",@"0",@"10",(int)node.class_id,[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    timeBool = NO;
                    time_label.text = @"↓添加时间";
                }
                
            }else{
                if (timeBool == NO) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&user_goodsclass_id=%d&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_inventory",@"asc",@"0",@"10",(int)node.class_id,[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    timeBool = YES;
                    time_label.text = @"↑添加时间";
                }else{
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&user_goodsclass_id=%d&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_inventory",@"desc",@"0",@"10",(int)node.class_id,[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    timeBool = NO;
                    time_label.text = @"↓添加时间";
                }
            }
        }
        [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
            loadingV.hidden = YES;
            faildV.hidden = YES;
            _myParse = myParse;
            [self analyze:_myParse.dicBig];
        } failure:^(){
            loadingV.hidden = YES;
            faildV.hidden = NO;
        } ];
    }
}

#pragma mark - 按钮点击事件
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)all_btnClicked{
    if (orderlist_Array.count!=0) {
        if (allBool == NO) {
            NSString *str ;
            for(int i=0;i<orderlist_Array.count;i++){
                Model *mmm = [orderlist_Array objectAtIndex:i];
                if (str.length == 0) {
                    str = [NSString stringWithFormat:@"%@",mmm.goods_id];
                }else{
                    str = [NSString stringWithFormat:@"%@,%@",str,mmm.goods_id];
                }
            }
            goodid_Str = str;
            allBool = YES;
            All_Image.image = [UIImage imageNamed:@"yes"];
        }else{
            goodid_Str = @"";
            allBool = NO;
            All_Image.image = [UIImage imageNamed:@""];
        }
        [orderlist_tableview reloadData];
    }
}
-(void)filterbtnClicked:(UIButton *)btn{
    [SearchTextField resignFirstResponder];
    btnClickedBool = YES;
    if (btn.tag == 100) {
        filterlabelTag = 0;
        time_label.textColor = [UIColor redColor];
        salenumber_label.textColor = [UIColor blackColor];
        inventory_label.textColor = [UIColor blackColor];
        
        time_label.text = @"添加时间";
        salenumber_label.text = @"销量";
        inventory_label.text = @"库存";
        
        loadingV.hidden = NO;
        
        NSArray *fileContent2 = USER_INFORMATION;
        NSString *url;
        if (labelTag == 0) {
            if (filterlabelTag == 0) {
                if (timeBool == NO) {
                    if (classify_ID == -1) {
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"addTime",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else{
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&user_goodsclass_id=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"addTime",@"asc",@"0",@"10",[NSString stringWithFormat:@"%d",(int)classify_ID],[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                    timeBool = YES;
                    time_label.text = @"↑添加时间";
                }else{
                    if (classify_ID == -1){
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"addTime",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else{
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&user_goodsclass_id=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"addTime",@"desc",@"0",@"10",[NSString stringWithFormat:@"%d",(int)classify_ID],[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                    timeBool = NO;
                    time_label.text = @"↓添加时间";
                }
            }else if (filterlabelTag == 1) {
                if (timeBool == NO) {
                    if (classify_ID == -1){
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_salenum",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else{
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&user_goodsclass_id=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_salenum",@"asc",@"0",@"10",[NSString stringWithFormat:@"%d",(int)classify_ID],[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                    
                    timeBool = YES;
                    time_label.text = @"↑添加时间";
                }else{
                    if (classify_ID == -1){
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_salenum",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else{
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&user_goodsclass_id=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_salenum",@"desc",@"0",@"10",[NSString stringWithFormat:@"%d",(int)classify_ID],[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                    
                    timeBool = NO;
                    time_label.text = @"↓添加时间";
                }
                
            }else{
                if (timeBool == NO) {
                    if (classify_ID == -1){
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_inventory",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else{
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&user_goodsclass_id=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_inventory",@"asc",@"0",@"10",[NSString stringWithFormat:@"%d",(int)classify_ID],[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                    
                    timeBool = YES;
                    time_label.text = @"↑添加时间";
                }else{
                    if (classify_ID == -1){
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_inventory",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else{
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&user_goodsclass_id=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_inventory",@"desc",@"0",@"10",[NSString stringWithFormat:@"%d",(int)classify_ID],[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                    
                    timeBool = NO;
                    time_label.text = @"↓添加时间";
                }
            }
        }else if (labelTag == 1) {
            if (filterlabelTag == 0) {
                if (timeBool == NO) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"addTime",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    timeBool = YES;
                    time_label.text = @"↑添加时间";
                }else{
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"addTime",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    timeBool = NO;
                    time_label.text = @"↓添加时间";
                }
                
            }else if (filterlabelTag == 1) {
                if (timeBool == NO) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"goods_salenum",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    timeBool = YES;
                    time_label.text = @"↑添加时间";
                }else{
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"goods_salenum",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    timeBool = NO;
                    time_label.text = @"↓添加时间";
                }
                
            }else{
                if (timeBool == NO) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"goods_inventory",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    timeBool = YES;
                    time_label.text = @"↑添加时间";
                }else{
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"goods_inventory",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    timeBool = NO;
                    time_label.text = @"↓添加时间";
                }
                
            }
        }else if (labelTag == 2) {
            if (filterlabelTag == 0) {
                if (timeBool == NO) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"addTime",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    timeBool = YES;
                    time_label.text = @"↑添加时间";
                }else{
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"addTime",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    timeBool = NO;
                    time_label.text = @"↓添加时间";
                }
                
            }else if (filterlabelTag == 1) {
                if (timeBool == NO) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"goods_salenum",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    timeBool = YES;
                    time_label.text = @"↑添加时间";
                }else{
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"goods_salenum",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    timeBool = NO;
                    time_label.text = @"↓添加时间";
                }
                
            }else{
                if (timeBool == NO) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"goods_inventory",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    timeBool = YES;
                    time_label.text = @"↑添加时间";
                }else{
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"goods_inventory",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    timeBool = NO;
                    time_label.text = @"↓添加时间";
                }
                
            }
        }else {//应该是分类
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@",SELLER_URL,STORE_GOODS_CLASSIFY_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0]];
        }
        [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
            loadingV.hidden = YES;
            faildV.hidden = YES;
            _myParse = myParse;
            if (labelTag == 3) {
                [self classify:_myParse.dicBig];
            }else{
                [self analyze:_myParse.dicBig];
            }
            
        } failure:^(){
            loadingV.hidden = YES;
            faildV.hidden = NO;
        } ];
    }
    if (btn.tag == 101) {
        filterlabelTag = 1;
        time_label.textColor = [UIColor blackColor];
        salenumber_label.textColor = [UIColor redColor];
        inventory_label.textColor = [UIColor blackColor];
        time_label.text = @"添加时间";
        salenumber_label.text = @"销量";
        inventory_label.text = @"库存";
        loadingV.hidden = NO;
        
        NSArray *fileContent2 = USER_INFORMATION;
        NSString *url;
        if (labelTag == 0) {
            if (filterlabelTag == 0) {
                if (salesnumBool == NO) {
                    if (classify_ID == -1) {
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"addTime",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else{
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&user_goodsclass_id=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"addTime",@"asc",@"0",@"10",[NSString stringWithFormat:@"%d",(int)classify_ID],[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                    
                    salesnumBool = YES;
                    salenumber_label.text = @"↑销量";
                }else{
                    if (classify_ID == -1) {
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"addTime",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else{
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&user_goodsclass_id=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"addTime",@"desc",@"0",@"10",[NSString stringWithFormat:@"%d",(int)classify_ID],[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                    
                    salesnumBool = NO;
                    salenumber_label.text = @"↓销量";
                }
                
            }else if (filterlabelTag == 1) {
                if (salesnumBool == NO) {
                    if (classify_ID == -1) {
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_salenum",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else {
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&user_goodsclass_id=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_salenum",@"asc",@"0",@"10",[NSString stringWithFormat:@"%d",(int)classify_ID],[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                    
                    salesnumBool = YES;
                    salenumber_label.text = @"↑销量";
                }else{
                    if (classify_ID == -1) {
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_salenum",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else{
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&user_goodsclass_id=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_salenum",@"desc",@"0",@"10",[NSString stringWithFormat:@"%d",(int)classify_ID],[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                    
                    salesnumBool = NO;
                    salenumber_label.text = @"↓销量";
                }
            }else{
                if (salesnumBool == NO) {
                    if (classify_ID == -1){
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_inventory",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else{
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&user_goodsclass_id=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_inventory",@"asc",@"0",@"10",[NSString stringWithFormat:@"%d",(int)classify_ID],[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                    
                    salesnumBool = YES;
                    salenumber_label.text = @"↑销量";
                }else{
                    if (classify_ID == -1){
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_inventory",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else{
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&user_goodsclass_id=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_inventory",@"desc",@"0",@"10",[NSString stringWithFormat:@"%d",(int)classify_ID],[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                    
                    salesnumBool = NO;
                    salenumber_label.text = @"↓销量";
                }
                
            }
        }else if (labelTag == 1) {
            if (filterlabelTag == 0) {
                if (salesnumBool == NO) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"addTime",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    salesnumBool = YES;
                    salenumber_label.text = @"↑销量";
                }else{
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"addTime",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    salesnumBool = NO;
                    salenumber_label.text = @"↓销量";
                }
                
            }else if (filterlabelTag == 1) {
                if (salesnumBool == NO) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"goods_salenum",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    salesnumBool = YES;
                    salenumber_label.text = @"↑销量";
                }else{
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"goods_salenum",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    salesnumBool = NO;
                    salenumber_label.text = @"↓销量";
                }
                
            }else{
                if (salesnumBool == NO) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"goods_inventory",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    salesnumBool = YES;
                    salenumber_label.text = @"↑销量";
                }else{
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"goods_inventory",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    salesnumBool = NO;
                    salenumber_label.text = @"↓销量";
                }
                
            }
        }else if (labelTag == 2) {
            if (filterlabelTag == 0) {
                if (salesnumBool == NO) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"addTime",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    salesnumBool = YES;
                    salenumber_label.text = @"↑销量";
                }else{
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"addTime",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    salesnumBool = NO;
                    salenumber_label.text = @"↓销量";
                }
                
            }else if (filterlabelTag == 1) {
                if (salesnumBool == NO) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"goods_salenum",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    salesnumBool = YES;
                    salenumber_label.text = @"↑销量";
                }else{
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"goods_salenum",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    salesnumBool = NO;
                    salenumber_label.text = @"↓销量";
                }
                
            }else{
                if (salesnumBool == NO) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"goods_inventory",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    salesnumBool = YES;
                    salenumber_label.text = @"↑销量";
                }else{
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"goods_inventory",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    salesnumBool = NO;
                    salenumber_label.text = @"↓销量";
                }
                
            }
        }else {//应该是分类
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@",SELLER_URL,STORE_GOODS_CLASSIFY_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0]];
        }
        [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
            loadingV.hidden = YES;
            faildV.hidden = YES;
            _myParse = myParse;
            if (labelTag == 3) {
                [self classify:_myParse.dicBig];
            }else{
                [self analyze:_myParse.dicBig];
            }
        } failure:^(){
            loadingV.hidden = YES;
            faildV.hidden = NO;
        } ];
    }
    if (btn.tag == 102) {
        filterlabelTag = 2;
        time_label.textColor = [UIColor blackColor];
        salenumber_label.textColor = [UIColor blackColor];
        inventory_label.textColor = [UIColor redColor];
        time_label.text = @"添加时间";
        salenumber_label.text = @"销量";
        inventory_label.text = @"库存";
        loadingV.hidden = NO;
        
        NSArray *fileContent2 = USER_INFORMATION;
        NSString *url;
        if (inventoryBool == NO) {
            inventoryBool = YES;
        }else{
            inventoryBool = NO;
        }
        if (labelTag == 0) {
            if (filterlabelTag == 0) {
                if (inventoryBool == NO) {
                    if (classify_ID == -1) {
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"addTime",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else{
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&user_goodsclass_id=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"addTime",@"asc",@"0",@"10",[NSString stringWithFormat:@"%d",(int)classify_ID],[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                    inventory_label.text = @"↑库存";//↓↑
                    inventoryBool = NO;
                }else{
                    if(classify_ID == -1){
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"addTime",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else{
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&user_goodsclass_id=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"addTime",@"desc",@"0",@"10",[NSString stringWithFormat:@"%d",(int)classify_ID],[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                    inventory_label.text = @"↓库存";//↑
                    inventoryBool = YES;
                }
                
            }else if (filterlabelTag == 1) {
                if (inventoryBool == NO) {
                    if (classify_ID == -1) {
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_salenum",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else{
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&user_goodsclass_id=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_salenum",@"asc",@"0",@"10",[NSString stringWithFormat:@"%d",(int)classify_ID],[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                    inventory_label.text = @"↑库存";//↓↑
                    inventoryBool = NO;
                }else{
                    if (classify_ID == -1) {
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_salenum",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else{
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&user_goodsclass_id=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_salenum",@"desc",@"0",@"10",[NSString stringWithFormat:@"%d",(int)classify_ID],[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                    inventory_label.text = @"↓库存";//↓↑
                    inventoryBool = YES;
                }
                
            }else{
                if (inventoryBool == NO) {
                    if (classify_ID == -1) {
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_inventory",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else{
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&user_goodsclass_id=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_inventory",@"asc",@"0",@"10",[NSString stringWithFormat:@"%d",(int)classify_ID],[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                        
                    }
                    inventory_label.text = @"↑库存";//↓↑
                    inventoryBool = NO;
                }else{
                    if (classify_ID == -1) {
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_inventory",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else{
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&user_goodsclass_id=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_inventory",@"desc",@"0",@"10",[NSString stringWithFormat:@"%d",(int)classify_ID],[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                    inventory_label.text = @"↓库存";//↓↑
                    inventoryBool = YES;
                }
                
            }
        }else if (labelTag == 1) {
            if (filterlabelTag == 0) {
                if (inventoryBool == NO) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"addTime",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    
                    inventory_label.text = @"↑库存";//↓↑
                    inventoryBool = NO;
                }else{
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"addTime",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    
                    inventory_label.text = @"↓库存";//↓↑
                    inventoryBool = YES;
                }
                
            }else if (filterlabelTag == 1) {
                if (inventoryBool == NO) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"goods_salenum",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    
                    inventory_label.text = @"↑库存";//↓↑
                    inventoryBool = NO;
                }else{
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"goods_salenum",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    
                    inventoryBool = YES;
                    inventory_label.text = @"↓库存";//↓↑
                }
                
            }else{
                if (inventoryBool == NO) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"goods_inventory",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    
                    inventory_label.text = @"↑库存";//↓↑
                    inventoryBool = NO;
                }else{
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"goods_inventory",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    
                    inventory_label.text = @"↓库存";//↓↑
                    inventoryBool = YES;
                }
                
            }
        }else if (labelTag == 2) {
            if (filterlabelTag == 0) {
                if (inventoryBool == NO) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"addTime",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    inventory_label.text = @"↑库存";//↓↑
                    inventoryBool = NO;
                }else{
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"addTime",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    inventory_label.text = @"↓库存";//↓↑
                    inventoryBool = YES;
                }
                
            }else if (filterlabelTag == 1) {
                if (inventoryBool == NO) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"goods_salenum",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    inventory_label.text = @"↑库存";//↓↑
                    inventoryBool = NO;
                }else{
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"goods_salenum",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    inventory_label.text = @"↓库存";//↓↑
                    inventoryBool = YES;
                }
                
            }else{
                if (inventoryBool == NO) {
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"goods_inventory",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    inventory_label.text = @"↑库存";//↓↑
                    inventoryBool = NO;
                }else{
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"goods_inventory",@"desc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    inventory_label.text = @"↓库存";//↓↑
                    inventoryBool = YES;
                }
                
            }
        }else {//应该是分类
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@",SELLER_URL,STORE_GOODS_CLASSIFY_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0]];
        }
        [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
            loadingV.hidden = YES;
            faildV.hidden = YES;
            _myParse = myParse;
            if (labelTag == 3) {
                [self classify:_myParse.dicBig];
            }else{
                [self analyze:_myParse.dicBig];
            }
        } failure:^(){
            loadingV.hidden = YES;
            faildV.hidden = NO;
        } ];
    }
}
-(void)failedPrompt:(NSString *)prompt{
    loadingV.hidden = YES;
    label_prompt.hidden = NO;
    label_prompt.text = prompt;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
}
-(void)goodsUpBtnclicked{
    if (goodid_Str.length == 0) {
        [MyObject failedPrompt:@"请选中商品"];
    }else{
        NSArray *fileContent2 = USER_INFORMATION;
        NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&mulitId=%@",SELLER_URL,STORE_GOODS_DOWN_SHELVES_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],goodid_Str];
        
        [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
            loadingV.hidden = YES;
            faildV.hidden = YES;
            _myParse = myParse;
            [MyObject failedPrompt:@"操作成功"];
            [self netJson];
        } failure:^(){
            loadingV.hidden = YES;
            faildV.hidden = NO;
        } ];
    }
}
-(void)goodsdownBtnclicked{
    if (goodid_Str.length == 0) {
        [MyObject failedPrompt:@"请选中商品"];
    }else{
        NSArray *fileContent2 = USER_INFORMATION;
        NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&mulitId=%@",SELLER_URL,STORE_GOODS_DOWN_SHELVES_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],goodid_Str];
        
        [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
            loadingV.hidden = YES;
            faildV.hidden = YES;
            _myParse = myParse;
            [MyObject failedPrompt:@"操作成功"];
            [self netJson];
        } failure:^(){
            loadingV.hidden = YES;
            faildV.hidden = NO;
        } ];
    }
}
-(void)selectBtnclicked:(UIButton *)btn{
    if (orderlist_Array.count!=0) {
        Model *model = [orderlist_Array objectAtIndex:btn.tag-100];
        if (goodid_Str.length == 0) {
            goodid_Str = [NSString stringWithFormat:@"%@",model.goods_id];
        }else{
            NSMutableArray *arr = (NSMutableArray *)[goodid_Str componentsSeparatedByString:@","];
            if (arr.count == 1) {
                if ([[arr objectAtIndex:0] intValue] == [model.goods_id intValue]) {
                    arr = nil;
                    goodid_Str = @"";
                }else{
                    goodid_Str = [NSString stringWithFormat:@"%@,%@",goodid_Str,model.goods_id];
                }
            }else{
                BOOL myBool = NO;
                int selectTag = -1;
                for(int i=0;i<arr.count;i++){
                    if ([[arr objectAtIndex:i] intValue] == [model.goods_id intValue]) {
                        myBool = YES;
                        selectTag = i;
                    }
                }
                if (myBool == NO) {
                    goodid_Str = [NSString stringWithFormat:@"%@,%@",goodid_Str,model.goods_id];
                }else{
                    if (selectTag == -1) {
                        
                    }else{
                        [arr removeObjectAtIndex:selectTag];
                    }
                    NSString *str;
                    for(int i=0;i<arr.count;i++){
                        if (str.length == 0) {
                            str = [NSString stringWithFormat:@"%@",[arr objectAtIndex:0]];
                        }else{
                            str = [NSString stringWithFormat:@"%@,%@",str,[arr objectAtIndex:i]];
                        }
                    }
                    goodid_Str = str;
                }
            }
        }
        
        NSMutableArray *arr = (NSMutableArray *)[goodid_Str componentsSeparatedByString:@","];
        if (goodid_Str.length == 0){
            allBool = NO;
            All_Image.image = [UIImage imageNamed:@""];
        }else{
            if (arr.count == orderlist_Array.count) {
                allBool = YES;
                All_Image.image = [UIImage imageNamed:@"yes"];
            }else{
                allBool = NO;
                All_Image.image = [UIImage imageNamed:@""];
            }
        }
        [orderlist_tableview reloadData];
    }
}
-(void)edit_btnClicked:(UIButton *)btn{
    if (orderlist_Array.count!=0) {
        Model *mm = [orderlist_Array objectAtIndex:btn.tag-100];
        OrderlistViewController *order = [OrderlistViewController sharedUserDefault];
        order.good_id = mm.goods_id;
        goodseditViewController *good = [[goodseditViewController alloc]init];
        [self.navigationController pushViewController:good animated:YES];
    }
}
-(void)delete_btnClicked{
    if (goodid_Str.length == 0) {
        [MyObject failedPrompt:@"请选中要删除的商品"];
    }else{
        NSArray *fileContent2 = USER_INFORMATION;
        NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&mulitId=%@",SELLER_URL,STORE_GOODS_DELETE_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],goodid_Str];
        [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
            loadingV.hidden = YES;
            faildV.hidden = YES;
            _myParse = myParse;
            [MyObject failedPrompt:@"成功删除"];
            [self netJson];
        } failure:^(){
            loadingV.hidden = YES;
            faildV.hidden = NO;
        } ];
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
    [self netJson];
}

-(void)up_pull{
    if (orderlist_Array.count<10) {
    }else if (orderlist_Array.count>=10){
        if (requestBool == YES){
            if (orderlistPull_Array.count==10){
                loadingV.hidden = NO;
                
                NSArray *fileContent2 = USER_INFORMATION;
                NSString *url;
                if (labelTag == 0) {
                    if (filterlabelTag == 0) {
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"addTime",@"asc",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else if (filterlabelTag == 1) {
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_salenum",@"asc",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else{
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_inventory",@"asc",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                }else if (labelTag == 1) {
                    if (filterlabelTag == 0) {
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"addTime",@"asc",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else if (filterlabelTag == 1) {
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"goods_salenum",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else{
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"goods_inventory",@"asc",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                }else if (labelTag == 2) {
                    if (filterlabelTag == 0) {
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"addTime",@"asc",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else if (filterlabelTag == 1) {
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"goods_salenum",@"asc",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else{
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"goods_inventory",@"asc",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                }else {//应该是分类
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@",SELLER_URL,STORE_GOODS_CLASSIFY_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0]];
                }
                [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
                    loadingV.hidden = YES;
                    faildV.hidden = YES;
                    _myParse = myParse;
                    if (labelTag == 3) {
                        [self classify:_myParse.dicBig];
                    }else{
                        [self analyzePull:_myParse.dicBig];
                    }
                } failure:^(){
                    loadingV.hidden = YES;
                    faildV.hidden = NO;
                } ];
            }else if(orderlistPull_Array.count==0){
            }else{
            }
        }else{
            if (orderlistPull_Array.count%10==0){
                loadingV.hidden = NO;
                
                NSArray *fileContent2 = USER_INFORMATION;
                NSString *url;
                if (labelTag == 0) {
                    if (filterlabelTag == 0) {
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"addTime",@"asc",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else if (filterlabelTag == 1) {
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_salenum",@"asc",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else{
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",@"goods_inventory",@"asc",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                }else if (labelTag == 1) {
                    if (filterlabelTag == 0) {
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"addTime",@"asc",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else if (filterlabelTag == 1) {
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"goods_salenum",@"asc",@"0",@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else{
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"1",@"goods_inventory",@"asc",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                }else if (labelTag == 2) {
                    if (filterlabelTag == 0) {
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"addTime",@"asc",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else if (filterlabelTag == 1) {
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"goods_salenum",@"asc",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }else{
                        url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_status=%@&orderby=%@&ordertype=%@&begin_count=%@&select_count=%@&goods_name=%@&device=iOS",SELLER_URL,GOODS_LIST_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"-2",@"goods_inventory",@"asc",[NSString stringWithFormat:@"%d",(int)orderlist_Array.count],@"10",[SearchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                }else {//应该是分类
                    url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@",SELLER_URL,STORE_GOODS_CLASSIFY_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0]];
                }
                [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
                    loadingV.hidden = YES;
                    faildV.hidden = YES;
                    _myParse = myParse;
                    if (labelTag == 3) {
                        [self classify:_myParse.dicBig];
                    }else{
                        [self analyzePull:_myParse.dicBig];
                    }
                } failure:^(){
                    loadingV.hidden = YES;
                    faildV.hidden = NO;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 分类相关
- (void)expandCollapseNode:(NSNotification *)notification
{
    [self fillDisplayArray];
    [classify_tableview reloadData];
}
- (void)fillDisplayArray
{
    if (displayArray.count!=0) {
        [displayArray removeAllObjects];
    }
    for (TreeViewNode *node in nodes) {
        [displayArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}
- (void)fillNodeWithChildrenArray:(NSArray *)childrenArray
{
    for (TreeViewNode *node in childrenArray) {
        [displayArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}
- (NSArray *)fillChildrenForNode:(NSArray *)arr{
    NSMutableArray *returnArr = [[NSMutableArray alloc]init];
    for(NSDictionary *dic in arr){
        TreeViewNode *secondLevelNode4 = [[TreeViewNode alloc]init];
        secondLevelNode4.nodeLevel = 1;
        secondLevelNode4.nodeObject = [NSString stringWithFormat:@"Child node 4"];
        secondLevelNode4.name = [dic objectForKey:@"className" ];
        secondLevelNode4.class_id = [[dic objectForKey:@"id" ] intValue];
        [returnArr addObject:secondLevelNode4];
    }
    return returnArr;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editBtnClicked:(id)sender {
    if (labelTag == 0) {
        btnUp.hidden = YES;
        btnDown.hidden = NO;
    }else if (labelTag == 1){
        btnUp.hidden = NO;
        btnDown.hidden = YES;
    }else if (labelTag == 2){
        btnUp.hidden = YES;
        btnDown.hidden = YES;
    }else{
        
    }
    if (edit_view.frame.origin.y == ScreenFrame.size.height) {
        button_edit.title = @"完成";
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        CGRect frame = edit_view.frame;
        frame.origin.y -= 60;
        [edit_view setFrame:frame];
        [UIView commitAnimations];
        orderlist_tableview.frame = CGRectMake(0, orderlist_tableview.frame.origin.y, ScreenFrame.size.width, orderlist_tableview.frame.size.height-60);
    }else{
        button_edit.title = @"编辑";
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        CGRect frame = edit_view.frame;
        frame.origin.y += 60;
        [edit_view setFrame:frame];
        [UIView commitAnimations];
        orderlist_tableview.frame = CGRectMake(0, ScreenFrame.origin.y+193, ScreenFrame.size.width, ScreenFrame.size.height-193);
        goodid_Str = @"";
        allBool = NO;
        All_Image.image = [UIImage imageNamed:@""];
    }
    [orderlist_tableview reloadData];
}
@end
