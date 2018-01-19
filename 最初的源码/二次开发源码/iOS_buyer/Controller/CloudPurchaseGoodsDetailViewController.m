//
//  CloudPurchaseGoodsDetailViewController.m
//  My_App
//
//  Created by barney on 16/2/16.
//  Copyright © 2016年 barney. All rights reserved.
//

#import "CloudPurchaseGoodsDetailViewController.h"
#import "NilCell.h"
#import "OneYuanGoodsClassCell1.h"
#import "OneYuanGoodsClassCell2.h"
#import "OneYuanGoodsClassCell3.h"
#import "OneYuanGoodsLoginCell.h"
#import "OneYuanDetailListCell.h"
#import "CloudPurchaseGoodsModel.h"
#import "OneYuanCartTableViewController.h"
#import "NewLoginViewController.h"
#import "SYStepper.h"
#import "PreviousPrizeWinnerTableViewController.h"
#import "ThreeDotView.h"
#import "SwiftHeader.h"
#import "PictureDetailViewController.h"
#import "GoodsDetailRecord.h"
#import "CloudPurchaseLottery.h"

@interface CloudPurchaseGoodsDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    NSMutableArray *dataArray;//tableView数据源
    NSMutableArray *listDataArray;//参与记录数据源
    NSMutableArray *arrImage;
    UITableView *goodsTabView;//tableView列表
    UIScrollView *myScroll;
    UIPageControl *pageControl;
    CGSize size;
    dispatch_source_t _timer;
    UIButton *loginBtn;//登录按钮
    UILabel *lab;//提示Label
    UILabel *loginLab;//已登录提示
    UIView *bottomView;//两个按钮
    UIView *bottomView1;//立即前往
    SYStepper *stepper;
    UIView *cartView;
    UIButton *cartJoin1;
    UIButton *cartJoin;
    UIView *backView;
    
    ThreeDotView *tdv;
    UILabel *numLabel;
    UIButton *cartBtn;
    NSInteger lastCount;
    UIButton *checkNum;
    UILabel *numLab;//期号
    int count;
    NSMutableArray *codesArray;

    NSString *strM;
    NSString *strS;
    NSString *strMS;
    
    OneYuanGoodsClassCell3 *cell3jjjx;
    CloudPurchaseLottery *lottery;
    
    NSString *status;
    NSTimer *timer;
    NSString *purchased_id;
    
    AFHTTPRequestOperation *operation;//夺宝号码请求
    
}
@end

@implementation CloudPurchaseGoodsDetailViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    //[self preCartView];
    dataArray=[[NSMutableArray alloc]init];//数据源初始化
    listDataArray=[[NSMutableArray alloc]init];
//    codesArray=[[NSMutableArray alloc]init];
    //arrImage=[[NSMutableArray alloc]initWithObjects:@"top",@"shop_logo_lj",nil];
    arrImage=[[NSMutableArray alloc]init];
    [self setBottomBtn];
    backView=[LJControl viewFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-210) backgroundColor:[UIColor blackColor]];
    backView.alpha=0.3;
    backView.hidden=YES;
    [self.view addSubview:backView];
    
    BOOL login;
    [SYObject hasUserLogedIn:&login];
    if (login) {
        
        loginBtn.hidden=YES;
        lab.hidden=YES;
        loginLab.hidden=NO;
        [self updateCartCount];
        [self getUserInfo]; //发请求得到用户是否参与夺宝的信息
      
        
    }else{
        loginBtn.hidden=NO;
        lab.hidden=NO;
        loginLab.hidden=YES;
        numLabel.hidden=YES;
        checkNum.hidden=YES;
        
        
    }
    [self getNetworking];
    [self fakeModel];
}
-(void)fakeModel{
    CloudPurchaseGoodsModel *model = [CloudPurchaseGoodsModel new];
    model.goods_description = @"";
    model.period = @"";
    model.goods_name = @"";
    dataArray[0] = model;
}
-(void)getUserInfo
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,CLOUDPURCHASE_GOODSDETAIL_SELFRECORD_URL];
    NSDictionary *par = @{
                          @"user_id":[SYObject currentUserID],
                          @"token":[SYObject currentToken],
                          @"lottery_id":[NSString stringWithFormat:@"%@",self.ID]
                          
                          };
    
    operation = [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * resultDict = responseObject;
        NSInteger code=[resultDict[@"code"] integerValue];
         NSLog(@"商品详情用户自己的购买记录resultDict******%@",resultDict);
        if(code ==10000)
        {
            NSLog(@"商品详情用户自己的购买记录******%@",resultDict);
            codesArray=[resultDict objectForKey:@"data"];
            
        }else
        {
            //[SYObject failedPrompt:@"请求失败"];
            
        }
     
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[SYObject failedPrompt:@"请求失败"];
        NSLog(@"%@",[error localizedDescription]);
    }];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [cartBtn removeFromSuperview];
    self.tabBarController.tabBar.hidden = NO;
    [bottomView removeFromSuperview];
    [bottomView1 removeFromSuperview];

    [cartView removeFromSuperview];
    backView.hidden=YES;
    [stepper removeFromSuperview];
    
    [timer invalidate];
    timer=nil;
    [self cancelCountDown];

    if (operation) {
        [operation cancel];
        operation = nil; 
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"商品详情";
    count=0;
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);//背景颜色
    
     if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0)
     {
       self.automaticallyAdjustsScrollViewInsets = NO;//自动调整属性设置为NO
     }
    codesArray=[[NSMutableArray alloc]init];
    goodsTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-64-60)];
    goodsTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    goodsTabView.delegate = self;
    goodsTabView.dataSource=  self;
    [goodsTabView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [goodsTabView addFooterWithTarget:self action:@selector(footerRereshing)];
    goodsTabView.showsVerticalScrollIndicator=NO;
    goodsTabView.showsHorizontalScrollIndicator = NO;
    goodsTabView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:goodsTabView];
    [self createBackBtn];
    [self watchForTextfield];
  
}
-(void)createCartIcon{
    cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat h = 40;
    CGFloat w = h;
    CGFloat x = ScreenFrame.size.width-10;
    CGFloat y = 10;
    cartBtn.frame = CGRectMake(x, y, w, h);
    UIImage *cartImg = [UIImage imageNamed:@"ygcart"];
    [cartBtn setImage:cartImg forState:UIControlStateNormal];
    
    cartBtn.layer.cornerRadius = h / 2;
    cartBtn.alpha = 0.6;
    cartBtn.backgroundColor = UIColorFromRGB(0xf15353);
    
    //[self.navigationController.view addSubview:cartBtn];
    [bottomView addSubview:cartBtn];
    [cartBtn addTarget:self action:@selector(cartBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGFloat w1 = 15;
    CGFloat h1 = 15;
    numLabel = [[UILabel alloc]initWithFrame:CGRectMake(w - w1, 0, w1, h1)];
    numLabel.textColor = [UIColor whiteColor];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.font = [UIFont systemFontOfSize:14];
    numLabel.layer.cornerRadius = w1 / 2;
    numLabel.layer.masksToBounds = YES;
    [cartBtn addSubview:numLabel];
    numLabel.backgroundColor = [UIColor blackColor];
    
    [self updateCartCount];
}

-(void)createMoreBtn{
    ThreeDotView *tdv1 = [[ThreeDotView alloc]initWithButtonCount:2 nc:self.navigationController];
    tdv = tdv1;
    tdv1.dataArray =[self DataTypeConversion:dataArray] ;
    tdv1.vc = self;
    [tdv1 insertMoreBtn:[tdv1 homeBtn]];
    [tdv1 insertMoreBtn:[tdv1 shareBtn]];
    tdv1.hidden = YES;
    
}
-(void)updateCartCount{
    
    [SYObject checkLogin:self.navigationController s:^(BOOL login) {
        if (login)
        {
            [SYShopAccessTool checkCart:^(NSArray *items) {
                if (items.count == 0) {
                    numLabel.hidden = YES;
                    numLabel.text = @"0";
                }else{
                    numLabel.hidden = NO;
                    numLabel.text = [NSString stringWithFormat:@"%ld",(long)items.count];
                }
            }];
            
        }
    }];
}
-(NSInteger)cartCount{
    return numLabel.text.integerValue;
}
-(void)cartBtnClicked{
    [SYObject checkLogin:self.navigationController s:^(BOOL login) {
        if (login)
        {
            OneYuanCartTableViewController *cart = [[OneYuanCartTableViewController alloc]init];
            [self.navigationController pushViewController:cart animated:YES];
            
        }
    }];

}
-(NSArray *)DataTypeConversion:(NSArray *)datArray{
    NSMutableArray *classifyArray=[[NSMutableArray alloc]init];
    for ( CloudPurchaseGoodsModel *model in datArray) {
        ClassifyModel *classify = [[ClassifyModel alloc]init];
        
        classify.detail_id = model.period;
        classify.detail_goods_photos =model.primary_photo;
        classify.detail_goods_name = model.goods_name;
        classify.detail_goods_details =model.goods_description;
        
        [classifyArray addObject:classify];
        
    }
    return classifyArray;
    
}
-(void)cancelCountDown {
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}
-(void)updateTime:(int)mili{
    
    __unsafe_unretained typeof(self) weakSelf = self;
    __block int timeout = mili;
    if (timeout!=0) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),0.01*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                [weakSelf cancelCountDown];
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell3jjjx.hundredSecond.text = @"00";
                    cell3jjjx.minuteLab.text = @"00";
                    cell3jjjx.secondLab.text = @"00";

                    [weakSelf timeUp];//倒计时结束
                });
            }else{
                int minute = (int)(timeout/6000);
                int second = (int)(timeout-minute*6000)/100;
                int hundred = timeout-minute*6000-second*100;
                dispatch_async(dispatch_get_main_queue(), ^{

                    cell3jjjx.minuteLab.text = [NSString stringWithFormat:@"%0.2d",minute];
                    cell3jjjx.secondLab.text = [NSString stringWithFormat:@"%0.2d",second];
                    cell3jjjx.hundredSecond.text = [NSString stringWithFormat:@"%0.2d",hundred];
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
    }
    
    
}
-(void)getNetworking
{
    [SYObject startLoading];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,CLOUDPURCHASE_GOODSDETAIL_URL];
    NSDictionary *par = @{
                          @"lottery_id":[NSString stringWithFormat:@"%@",self.ID]
                          };
    NSLog(@"par////%@",par);
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SYObject endLoading];
        NSDictionary * resultDict = responseObject;
        NSInteger code=[resultDict[@"code"] integerValue];
        
        if(code ==10001)
        {
            NSLog(@"商品详情******%@",resultDict);
            NSDictionary *dict=[resultDict objectForKey:@"data"];
            dataArray=[[NSMutableArray alloc]init];
            arrImage=[[NSMutableArray alloc]init];
            
            lottery = [CloudPurchaseLottery yy_modelWithDictionary:dict];
            CloudPurchaseGoodsModel *model=[[CloudPurchaseGoodsModel alloc]init];
            model.period=[NSString stringWithFormat:@"%@",[dict objectForKey:@"period"]];
            model.purchased_id=[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
            purchased_id=model.purchased_id;
            model.purchased_left_times=[NSString stringWithFormat:@"%@",[dict objectForKey:@"purchased_left_times"]];
            model.status=[NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
           
            model.purchased_times=[NSString stringWithFormat:@"%@",[dict objectForKey:@"purchased_times"]];
            model.addTime=[NSString stringWithFormat:@"%@",[dict objectForKey:@"addTime"]];
            
            model.purchased_left_times=[NSString stringWithFormat:@"%@",[dict objectForKey:@"purchased_left_times"]];
            if ([[dict objectForKey:@"announced_date"]length]>0)
            {
                model.announced_date=[NSString stringWithFormat:@"%@",[dict objectForKey:@"announced_date"]];
                
            }
            NSDictionary *d=[dict objectForKey:@"cloudPurchaseGoods"];
            
            model.goods_name=[d objectForKey:@"goods_name"];
            model.goods_description=[d objectForKey:@"goods_description"];
            model.goods_price=[NSString stringWithFormat:@"%@",[d objectForKey:@"goods_price"]];
            model.least_rmb=[NSString stringWithFormat:@"%@",[d objectForKey:@"least_rmb"]];
            model.pictureID=[NSString stringWithFormat:@"%@",[d objectForKey:@"id"]];
            model.primary_photo=[d objectForKey:@"primary_photo"];
            
            [arrImage addObject:model.primary_photo];
            model.secondary_photo=[d objectForKey:@"secondary_photo"];
            
            NSMutableArray *ary1=(NSMutableArray *)[model.secondary_photo componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[],"]];
            [ary1 removeObjectAtIndex:0];
            [ary1 removeLastObject];
            for (int i=0; i<ary1.count; i++) {
                
                NSString *img=[[[ary1 objectAtIndex:i]componentsSeparatedByString:@"\""]objectAtIndex:1];
                [arrImage addObject:img];
                
            }
  
            [dataArray addObject:model];
            [self createMoreBtn];
            
            if ([model.status isEqualToString:@"10"])
            {
                
                //倒计时
                NSString *shijiancha=[self intervalFromLastDate:model.addTime toTheDate:model.announced_date];
                int t=shijiancha.intValue;
                NSLog(@"时间差。。。。。。。%@",shijiancha);
                [self updateTime:t*100];
 
                
            }
            
            [goodsTabView reloadData];
            if (model.least_rmb.integerValue==10) {
                stepper =[[SYStepper alloc]initWithFrame:CGRectMake(20, 80, 160, 40) max:model.purchased_left_times.integerValue min:10 step:10 tintColor:UIColorFromRGB(0xbababa) buttonWidth:0.3 superView:cartView];
                
            }else
            {
                stepper =[[SYStepper alloc]initWithFrame:CGRectMake(20, 80, 160, 40) max:model.purchased_left_times.integerValue min:1 step:1 tintColor:UIColorFromRGB(0xbababa) buttonWidth:0.3 superView:cartView];
                
            }
            
            [cartView addSubview:stepper];
            
            if (model.status.integerValue==5) {
                bottomView.hidden=NO;
                bottomView1.hidden=YES;
                
            }else
            {
                bottomView.hidden=YES;
                bottomView1.hidden=NO;
                
            }
          
        }else
        {
            [SYObject failedPrompt:@"请求失败"];
            
        }
 
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [SYObject endLoading];
        [SYObject failedPrompt:@"请求失败"];
        NSLog(@"%@",[error localizedDescription]);
    }];
    [self preCartView];

  
}
//监听文本框
-(void)stepperChanged:(NSNotification *)notif
{
    if (notif.name == [SYStepper notifName]) {
        //结束编辑
        //cartView.frame = CGRectMake(0, ScreenFrame.size.height-210, ScreenFrame.size.width, 210);
        
        long mol = (stepper.value - stepper.min) % stepper.step;
        if(mol != 0){
            //10元专区买的不是10的倍数的情况
            long newValue = stepper.value - mol + stepper.step;
            if (newValue > stepper.max){
                newValue = stepper.max;
            } else if (stepper.value < stepper.min){
                newValue = stepper.min;
            }
            stepper.num = newValue;
        }
        
    }else if (notif.name == [SYStepper startNotifName]){
        //开始编辑
        //cartView.frame=CGRectMake(0, 20, ScreenFrame.size.width, 210);
      
    }
    
}
-(void)watchForTextfield{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stepperChanged:) name:[SYStepper notifName] object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stepperChanged:) name:[SYStepper startNotifName] object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyboardWillShow:(NSNotification *)notif{
    /*2016-02-26 11:01:54.948 My_App[8202:1405861] keyboard info : {
     UIKeyboardAnimationCurveUserInfoKey = 7;
     UIKeyboardAnimationDurationUserInfoKey = "0.25";
     UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {320, 260}}";
     UIKeyboardCenterBeginUserInfoKey = "NSPoint: {160, 350}";
     UIKeyboardCenterEndUserInfoKey = "NSPoint: {160, 610}";
     UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 220}, {320, 260}}";
     UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 480}, {320, 260}}";
     UIKeyboardIsLocalUserInfoKey = 1;
     }*/
    NSString *duration = notif.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    CGFloat time = duration.floatValue;
    NSValue *a = notif.userInfo[UIKeyboardFrameBeginUserInfoKey];
    CGFloat height = a.CGRectValue.size.height;
    //time height游泳
    [UIView animateWithDuration:time animations:^{
        CGRect frame = cartView.frame;
        frame.origin.y -= height;
        frame.origin.y += 10;
        cartView.frame = frame;
    }];
    
}
-(void)keyboardWillHide:(NSNotification *)notif{
    NSString *duration = notif.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    CGFloat time = duration.floatValue;
    NSValue *a = notif.userInfo[UIKeyboardFrameBeginUserInfoKey];
    CGFloat height = a.CGRectValue.size.height;
    //time height游泳
    [UIView animateWithDuration:time animations:^{
        CGRect frame = cartView.frame;
        frame.origin.y += height;
        frame.origin.y -= 10;
        cartView.frame = frame;
    }];
}
//设计底部按钮
-(void)setBottomBtn
{
    bottomView=[LJControl viewFrame:CGRectMake(0, ScreenFrame.size.height-60, ScreenFrame.size.width, 60) backgroundColor:[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f]];
    
    [self.navigationController.view addSubview:bottomView];
    bottomView.hidden=YES;
    
    UIView *grayLine=[LJControl viewFrame:CGRectMake(0, bottomView.top, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe3e3e3)];
    [bottomView addSubview:grayLine];
    UIButton *joinBtn=[LJControl buttonType:(UIButtonTypeCustom) setFrame:CGRectMake(10, 10, ScreenFrame.size.width/3, 40) setNormalImage:nil setSelectedImage:nil setTitle:@"立即参与" setTitleFont:15 setbackgroundColor:[UIColor colorWithRed:0.85f green:0.22f blue:0.32f alpha:1.00f]];
    [joinBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [joinBtn.layer setMasksToBounds:YES];
    [joinBtn.layer setCornerRadius:4.0];
    [bottomView addSubview:joinBtn];
    [joinBtn addTarget:self action:@selector(joinBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton *addBtn=[LJControl buttonType:(UIButtonTypeCustom) setFrame:CGRectMake(joinBtn.right+10, 10, ScreenFrame.size.width/3, 40) setNormalImage:nil setSelectedImage:nil setTitle:@"加入清单" setTitleFont:15 setbackgroundColor:[UIColor whiteColor]];
    [addBtn setTitleColor:[UIColor colorWithRed:0.85f green:0.22f blue:0.32f alpha:1.00f] forState:(UIControlStateNormal)];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:(UIControlEventTouchUpInside)];

    [addBtn.layer setMasksToBounds:YES];
    [addBtn.layer setCornerRadius:4.0];
    addBtn.layer.borderWidth=1;
    addBtn.layer.borderColor=[UIColor colorWithRed:0.85f green:0.22f blue:0.32f alpha:1.00f].CGColor;
    [bottomView addSubview:addBtn];
    
    
    bottomView1=[LJControl viewFrame:CGRectMake(0, ScreenFrame.size.height-60, ScreenFrame.size.width, 60) backgroundColor:[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f]];
    bottomView1.hidden=YES;
    [self.navigationController.view addSubview:bottomView1];
    UIButton *toBtn=[LJControl buttonType:(UIButtonTypeCustom) setFrame:CGRectMake(ScreenFrame.size.width-ScreenFrame.size.width/3-10, 10, ScreenFrame.size.width/3, 40) setNormalImage:nil setSelectedImage:nil setTitle:@"立即前往" setTitleFont:15 setbackgroundColor:[UIColor colorWithRed:0.85f green:0.22f blue:0.32f alpha:1.00f]];
    [toBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [toBtn addTarget:self action:@selector(toBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [toBtn.layer setMasksToBounds:YES];
    [toBtn.layer setCornerRadius:4.0];
    [bottomView1 addSubview:toBtn];
    
    UILabel *leftLab=[LJControl labelFrame:CGRectMake(10, 10, 170, 40) setText:@"新一期正在火热进行..." setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor lightGrayColor] textAlignment:(NSTextAlignmentLeft)];
    [bottomView1 addSubview:leftLab];
    
    cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat h = 40;
    CGFloat w = h;
    CGFloat x = addBtn.right+(bottomView.size.width-addBtn.right-40)/2;
    CGFloat y = 10;
    cartBtn.frame = CGRectMake(x, y, w, h);
    UIImage *cartImg = [UIImage imageNamed:@"ygcart"];
    [cartBtn setImage:cartImg forState:UIControlStateNormal];
    
    cartBtn.layer.cornerRadius = h / 2;
    cartBtn.alpha = 0.6;
    cartBtn.backgroundColor = UIColorFromRGB(0xf15353);
    
    //[self.navigationController.view addSubview:cartBtn];
    [bottomView addSubview:cartBtn];
    [cartBtn addTarget:self action:@selector(cartBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGFloat w1 = 15;
    CGFloat h1 = 15;
    numLabel = [[UILabel alloc]initWithFrame:CGRectMake(w - w1, 0, w1, h1)];
    numLabel.textColor = [UIColor whiteColor];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.font = [UIFont systemFontOfSize:14];
    numLabel.layer.cornerRadius = w1 / 2;
    numLabel.layer.masksToBounds = YES;
    [cartBtn addSubview:numLabel];
    numLabel.backgroundColor = [UIColor blackColor];
    
    //[self updateCartCount];
 }
#pragma mark - 上拉刷新、下拉加载
-(void)headerRereshing{
    
    [goodsTabView headerEndRefreshing];
    [self getNetworking2];

}
-(void)footerRereshing
{
     count++;
    [self record];
    [goodsTabView footerEndRefreshing];
    
}
//参与记录请求
-(void)record
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,CLOUDPURCHASE_GOODSDETAIL_RECORD_URL];
    NSDictionary *par = @{
                          
                          @"lottery_id":[NSString stringWithFormat:@"%@",self.ID],
                          @"begin_count":@"0",
                          @"select_count":[NSString stringWithFormat:@"%d",count*20]
                          
                          
                          };
    NSLog(@"par////%@",par);
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * resultDict = responseObject;
        NSInteger code=[resultDict[@"code"] integerValue];
        
        if (listDataArray.count!=0)
        {
            [listDataArray removeAllObjects];
        }
        if(code ==10000)
        {
            NSLog(@"商品详情购买记录******%@",resultDict);
            NSArray *ary=[resultDict objectForKey:@"data"];
            
            for (NSDictionary *d in ary) {
                GoodsDetailRecord *model=[[GoodsDetailRecord alloc]init];

              model.user_name = [NSString stringWithFormat:@"%@",[d objectForKey:@"user_name"]];
              model.user_photo = [d objectForKey:@"user_photo"];
              model.addTime=[d objectForKey:@"addTime"];
              model.purchased_times=[NSString stringWithFormat:@"%@",[d objectForKey:@"purchased_times"]];
                [listDataArray addObject:model];
                
            }
           
            [goodsTabView reloadData];
   
            
        }else
        {
            [SYObject failedPrompt:@"请求失败"];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:@"请求失败"];
        NSLog(@"%@",[error localizedDescription]);
    }];

}
-(void)preCartView
{
    cartView=[LJControl viewFrame:CGRectMake(0, ScreenFrame.size.height-210, ScreenFrame.size.width, 210) backgroundColor:[UIColor whiteColor]];
    [self.navigationController.view addSubview:cartView];
    cartView.hidden=YES;
    
    UIView *topView=[LJControl viewFrame:CGRectMake(0, 0, ScreenFrame.size.width, 40) backgroundColor:[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f]];
    [cartView addSubview:topView];
    UILabel *topLab=[LJControl labelFrame:CGRectMake(20, 0, 100, 40) setText:@"人次期数选择" setTitleFont:15 setbackgroundColor:nil setTextColor:[UIColor grayColor] textAlignment:(NSTextAlignmentLeft)];
    [topView addSubview:topLab];
    UIButton *btn=[LJControl buttonType:(UIButtonTypeCustom) setFrame:CGRectMake(ScreenFrame.size.width-32, 10, 32, 20) setNormalImage:[UIImage imageNamed:@"cancel"] setSelectedImage:nil setTitle:nil setTitleFont:0 setbackgroundColor:nil];
    [btn addTarget:self action:@selector(cancleClick) forControlEvents:(UIControlEventTouchUpInside)];
    [topView addSubview:btn];
    
    UILabel *midLab=[LJControl labelFrame:CGRectMake(20, topView.bottom+10, 100, 30) setText:@"参与人次" setTitleFont:15 setbackgroundColor:nil setTextColor:[UIColor grayColor] textAlignment:(NSTextAlignmentLeft)];
    [cartView addSubview:midLab];
    
    
    cartJoin=[LJControl buttonType:(UIButtonTypeCustom) setFrame:CGRectMake(ScreenFrame.size.width/4, cartView.size.height-10-40, ScreenFrame.size.width/2, 40) setNormalImage:nil setSelectedImage:nil setTitle:@"1元夺宝" setTitleFont:15 setbackgroundColor:[UIColor colorWithRed:0.85f green:0.22f blue:0.32f alpha:1.00f]];
    [cartJoin addTarget:self action:@selector(realJoinCart) forControlEvents:(UIControlEventTouchUpInside)];
    
    [cartJoin.layer setMasksToBounds:YES];
    [cartJoin.layer setCornerRadius:4.0];
    [cartView addSubview:cartJoin];
    
    
    cartJoin1=[LJControl buttonType:(UIButtonTypeCustom) setFrame:CGRectMake(ScreenFrame.size.width/4, cartView.size.height-10-40, ScreenFrame.size.width/2, 40) setNormalImage:nil setSelectedImage:nil setTitle:@"加入清单" setTitleFont:15 setbackgroundColor:[UIColor whiteColor]];
    [cartJoin1 addTarget:self action:@selector(realJoinCart1) forControlEvents:(UIControlEventTouchUpInside)];
    [cartJoin1 setTitleColor:[UIColor colorWithRed:0.85f green:0.22f blue:0.32f alpha:1.00f] forState:(UIControlStateNormal)];

    [cartJoin1.layer setMasksToBounds:YES];
    [cartJoin1.layer setCornerRadius:4.0];
    cartJoin1.layer.borderWidth=1;
    cartJoin1.layer.borderColor=[UIColor colorWithRed:0.85f green:0.22f blue:0.32f alpha:1.00f].CGColor;
    cartJoin1.hidden=YES;
    [cartView addSubview:cartJoin1];
    
    
    
    UIView *grayLine=[LJControl viewFrame:CGRectMake(0, cartJoin.top-10, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe3e3e3)];
    [cartView addSubview:grayLine];
    

}
//跳转购物车界面
-(void)realJoinCart
{
    if (stepper.value>0) {
        [SYShopAccessTool addToCartWithLotteryID:self.ID count:[SYObject toStr:stepper.value]];
        
        OneYuanCartTableViewController *cart=[[OneYuanCartTableViewController alloc]init];
        [self.navigationController pushViewController:cart animated:YES];
        
    }else
    {
    [OHAlertView showAlertWithTitle:@"提示" message:@"参与人次不能为0，请重新输入" cancelButton:@"确定" otherButtons:nil buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
        
    }];
    
    }
    
    
}
//只加入购物车，并不跳转
-(void)realJoinCart1
{
    if (stepper.value>0) {
    [SYShopAccessTool addToCartWithLotteryID:self.ID count:[SYObject toStr:stepper.value]];
    [self updateCartCount];
    cartView.hidden=YES;
    bottomView.hidden=NO;
    bottomView1.hidden=YES;
    backView.hidden=YES;
    
    CloudPurchaseGoodsModel *model=[dataArray firstObject];
    [stepper removeFromSuperview];
    if (model.least_rmb.integerValue==10) {
        stepper =[[SYStepper alloc]initWithFrame:CGRectMake(20, 80, 160, 40) max:model.purchased_left_times.integerValue min:10 step:10 tintColor:UIColorFromRGB(0xbababa) buttonWidth:0.3 superView:cartView];
        
    }else
    {
        stepper =[[SYStepper alloc]initWithFrame:CGRectMake(20, 80, 160, 40) max:model.purchased_left_times.integerValue min:1 step:1 tintColor:UIColorFromRGB(0xbababa) buttonWidth:0.3 superView:cartView];
        
    }
    [cartView addSubview:stepper];
        
    }else
    {
        [OHAlertView showAlertWithTitle:@"提示" message:@"参与人次不能为0，请重新输入" cancelButton:@"确定" otherButtons:nil buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            
        }];
        
    }
    
}

-(void)cancleClick
{
    cartView.hidden=YES;
    bottomView.hidden=NO;
    bottomView1.hidden=YES;
    backView.hidden=YES;
    CloudPurchaseGoodsModel *model=[dataArray firstObject];
    [stepper removeFromSuperview];
    if (model.least_rmb.integerValue==10) {
        stepper =[[SYStepper alloc]initWithFrame:CGRectMake(20, 80, 160, 40) max:model.purchased_left_times.integerValue min:10 step:10 tintColor:UIColorFromRGB(0xbababa) buttonWidth:0.3 superView:cartView];
        
    }else
    {
        stepper =[[SYStepper alloc]initWithFrame:CGRectMake(20, 80, 160, 40) max:model.purchased_left_times.integerValue min:1 step:1 tintColor:UIColorFromRGB(0xbababa) buttonWidth:0.3 superView:cartView];
        
    }
    [cartView addSubview:stepper];



}
//立即参与按钮点击事件
-(void)joinBtnClick
{
    //判断是否登录
    [SYObject checkLogin:self.navigationController s:^(BOOL login) {
        if (login)
        {
//            OneYuanCartTableViewController *cart=[[OneYuanCartTableViewController alloc]init];
//            [self.navigationController pushViewController:cart animated:YES];
            bottomView.hidden=YES;
             bottomView1.hidden=YES;
             cartView.hidden=NO;
            cartJoin1.hidden=YES;
            cartJoin.hidden=NO;
            backView.hidden=NO;
          
        }
    }];
}
#pragma mark - 查看计算详情
-(void)checkFormula {
    FormulaTableViewController *fTVC = [FormulaTableViewController new];
    fTVC.lotteryID = self.ID;
    fTVC.lottery = lottery;
    [self.navigationController pushViewController:fTVC animated:YES];
}
//加入清单按钮点击事件
-(void)addBtnClick
{
    //判断是否登录
    [SYObject checkLogin:self.navigationController s:^(BOOL login) {
        if (login)
        {
            bottomView.hidden=YES;
             bottomView1.hidden=YES;
            cartView.hidden=NO;
            cartJoin1.hidden=NO;
            cartJoin.hidden=YES;
             backView.hidden=NO;
        }
    }];

}
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
    
    
    UIButton *buttonMore = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonMore.frame =CGRectMake(0, 0, 18, 18);
    [buttonMore setBackgroundImage:[UIImage imageNamed:@"point"] forState:UIControlStateNormal];
    [buttonMore addTarget:self action:@selector(More) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar1 = [[UIBarButtonItem alloc]initWithCustomView:buttonMore];
    self.navigationItem.rightBarButtonItem =bar1;
}

-(void)More{
    tdv.hidden = NO;
    tdv.tri.hidden=NO;
}

-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 8+listDataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CloudPurchaseGoodsModel *model=[dataArray firstObject];
    if (indexPath.row==0) {
        
         if ([model.status isEqualToString:@"10"])
         {
         return 205+size.height-150+ScreenFrame.size.width-20;
         }
        
        else
        return 205+size.height-150+ScreenFrame.size.width;
    }else if (indexPath.row==1)
    {
        
         if ([model.status isEqualToString:@"10"])
         {
             return 60;
         
         }else if ([model.status isEqualToString:@"15"])
         {
             return 96;
             
         }else
             
        return 44;
        
        
    }else if (indexPath.row==2)
    {
        return 44;
    }else if (indexPath.row==3||indexPath.row==6)
    {
        return 10;
    }else if (indexPath.row==4||indexPath.row==5||indexPath.row==7)
    {
        return 44;
    }
    else
    {
        return 60;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectRowAtIndexPath : %ld",(long)indexPath.row);
     CloudPurchaseGoodsModel *model=[dataArray firstObject];
    if (indexPath.row == 5) {
        //self.ID
        PreviousPrizeWinnerTableViewController *ppwTVC = [PreviousPrizeWinnerTableViewController new];
        ppwTVC.lotteryID = self.ID;
        [self.navigationController pushViewController:ppwTVC animated:YES];
    }else if (indexPath.row == 4){
        PictureDetailViewController *picture=[[PictureDetailViewController alloc]init];
        picture.ID=model.pictureID;
        [self.navigationController pushViewController:picture animated:YES];
        
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NilCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NilCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        for (UIView *subView in cell.contentView.subviews)
        {
            [subView removeFromSuperview];
            
        }
    }
    
    CloudPurchaseGoodsModel *model=[dataArray firstObject];
    if (indexPath.row == 0) {
        NilCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NilCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            for (UIView *subView in cell.contentView.subviews)
            {
                [subView removeFromSuperview];
            }
        }
        myScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.width)];
        myScroll.tag = 100;
        myScroll.bounces = YES;
        myScroll.delegate = self;
        myScroll.pagingEnabled = YES;
        myScroll.userInteractionEnabled = YES;
        myScroll.showsHorizontalScrollIndicator = NO;
        myScroll.contentSize=CGSizeMake(ScreenFrame.size.width*arrImage.count,150);
        [cell addSubview:myScroll];
        
        for(int i=0;i<arrImage.count;i++){
            UIImageView *imageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width*i, 0, ScreenFrame.size.width, ScreenFrame.size.width)];
            [imageVIew sd_setImageWithURL: [NSURL URLWithString:[arrImage objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
            //[imageVIew setImage:[UIImage imageNamed:arrImage[i]]];
            [myScroll addSubview:imageVIew];
        }
        UIImageView *mark=[LJControl imageViewFrame:CGRectMake(0, 0, 25, 30) setImage:@"ygten" setbackgroundColor:nil];
        mark.hidden=YES;
        [cell addSubview:mark];
        if (model.least_rmb.integerValue==10) {
            mark.hidden=NO;
        }else
        {
        mark.hidden=YES;
        
        }
        UIPageControl *page=[[UIPageControl alloc]initWithFrame:CGRectMake((cell.size.width-100)/2, ScreenFrame.size.width, 100, 20)];
        page.numberOfPages=arrImage.count;
        //当前高亮的点
        page.currentPage=0;
        page.backgroundColor=[UIColor whiteColor];
        
        pageControl=page;
       // pageControl.center=CGPointMake(self.view.center.x, pageControl.center.y);
        //当前点颜色
        pageControl.currentPageIndicatorTintColor=[UIColor redColor];
        // 不是当前点颜色
        pageControl.pageIndicatorTintColor=[UIColor darkGrayColor];
        [cell addSubview:page];
        
        NSString *str=[NSString stringWithFormat:@"%@  %@",model.goods_name,model.goods_description];
        
        
        UILabel *detailLab=[LJControl labelFrame:CGRectMake(10, page.bottom+5, ScreenFrame.size.width-20, 30) setText:str setTitleFont:13 setbackgroundColor:[UIColor whiteColor] setTextColor:[UIColor blackColor] textAlignment:(NSTextAlignmentLeft)];
        size=[str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
        detailLab.frame=CGRectMake(10, page.bottom+5, ScreenFrame.size.width-20, size.height);
        detailLab.numberOfLines=0;
        detailLab.font=[UIFont systemFontOfSize:13];
        
        [cell addSubview:detailLab];
        
        //设置不同字体颜色
        [self fuwenbenLabel:detailLab FontNumber:[UIFont systemFontOfSize:13] AndRange:NSMakeRange(model.goods_name.length+1, model.goods_description.length+1) AndColor:[UIColor redColor]];
        
       
        numLab=[LJControl labelFrame:CGRectMake(10, detailLab.bottom, ScreenFrame.size.width, 30) setText:[NSString stringWithFormat:@"期号: %@",model.period] setTitleFont:13 setbackgroundColor:[UIColor whiteColor] setTextColor:[UIColor grayColor] textAlignment:(NSTextAlignmentLeft)];
        [cell addSubview:numLab];

        return cell;
    }
    if (indexPath.row == 1) {
        
        if ([model.status isEqualToString:@"5"])//正在进行
        {
            
            OneYuanGoodsClassCell1 *cell = [[[NSBundle mainBundle] loadNibNamed:@"OneYuanGoodsClassCell1" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.goodsPrice.text=[NSString stringWithFormat:@"总需%@人次",model.goods_price];
//            cell.unAll.text=[NSString stringWithFormat:@"剩余%ld",(long)model.goods_price.integerValue-model.sell_num.integerValue];
            cell.progressView.progress=model.purchased_times.floatValue/model.goods_price.floatValue;
            cell.progressView.progressImage = [UIImage imageNamed:@"ygprogress"];
       
        UILabel *unAllLab=[LJControl labelFrame:CGRectMake(ScreenFrame.size.width-100, cell.progressView.bottom+8, 100, 23) setText:[NSString stringWithFormat:@"剩余%@",model.purchased_left_times] setTitleFont:12 setbackgroundColor:nil setTextColor:[UIColor blackColor] textAlignment:(NSTextAlignmentRight)];
        [cell addSubview:unAllLab];
        NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
        CGSize size1 = [[NSString stringWithFormat:@"剩余%@",model.purchased_left_times] sizeWithAttributes:attr];
        unAllLab.frame=CGRectMake(cell.size.width-size1.width-9, cell.progressView.bottom+8, size1.width, 23);
        //设置不同字体颜色
        [self fuwenbenLabel:unAllLab FontNumber:[UIFont systemFontOfSize:12] AndRange:NSMakeRange(2, model.purchased_left_times.length) AndColor:UIColorFromRGB(0x007AFF)];
            return cell;
        
}
        
        if ([model.status isEqualToString:@"10"])//即将揭晓
        {
            numLab.hidden=YES;
            OneYuanGoodsClassCell3 *cell = [[[NSBundle mainBundle] loadNibNamed:@"OneYuanGoodsClassCell3" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.num.text=[NSString stringWithFormat:@"期号: %@",model.period];
            
            cell3jjjx = cell;
        
            
            [cell.JSBtn addTarget:self  action:@selector(checkFormula) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;

            
        }
        if ([model.status isEqualToString:@"15"])//已揭晓
        {
            
            OneYuanGoodsClassCell2 *cell = [[[NSBundle mainBundle] loadNibNamed:@"OneYuanGoodsClassCell2" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.checkJS addTarget:self  action:@selector(checkFormula) forControlEvents:UIControlEventTouchUpInside];
            cell.luckyNum.text = [NSString stringWithFormat:@"幸运号码：%@",lottery.lucky_code];
            cell.resultTime.text = [NSString stringWithFormat:@"揭晓时间：%@", lottery.announced_date];
            NSString *full = [NSString stringWithFormat:@"本期参与：%@人次", lottery.lucky_usertimes];
            NSAttributedString *str = [NSAttributedString stringWithFullStr:full attributedPart:lottery.lucky_usertimes attribute:@{NSForegroundColorAttributeName:[UIColor redColor]}];
            cell.attend.attributedText = str;
            cell.winner.text = [NSString stringWithFormat:@"本期参与：%@", lottery.lucky_username];
            [cell.avatar sd_setImageWithURL:[NSURL URLWithString:lottery.lucky_userphoto] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
            return cell;
            
        }
        
}
    if (indexPath.row == 2) {
        
        
        OneYuanGoodsLoginCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"OneYuanGoodsLoginCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        loginBtn=[LJControl buttonType:(UIButtonTypeSystem) setFrame:CGRectMake((cell.grayView.width-180)/2, 0, 30, 30) setNormalImage:nil setSelectedImage:nil setTitle:@"登录" setTitleFont:12 setbackgroundColor:nil];
        [loginBtn addTarget:self action:@selector(loginClick) forControlEvents:(UIControlEventTouchUpInside)];
        //loginBtn.hidden=YES;

        CGSize sizeBtn = [@"登录" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        [cell.grayView addSubview:loginBtn];
        
        lab=[LJControl labelFrame:CGRectMake(loginBtn.right, 0, 150, 30) setText:@"以查看您的夺宝号码~" setTitleFont:12 setbackgroundColor:nil setTextColor:[UIColor grayColor] textAlignment:(NSTextAlignmentLeft)];
        CGSize sizeLab = [@"以查看您的夺宝号码~" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        [cell.grayView addSubview:lab];

        loginBtn.frame=CGRectMake((ScreenFrame.size.width-20-sizeBtn.width-sizeLab.width)/2, 0, sizeBtn.width, 30);
        lab.frame=CGRectMake(loginBtn.right, 0, sizeLab.width, 30);
        //lab.hidden=YES;
        
        
        loginLab=[LJControl labelFrame:CGRectMake(0, 0, ScreenFrame.size.width-20, cell.grayView.size.height) setText:@"您没有参与本次夺宝哦!" setTitleFont:12 setbackgroundColor:nil setTextColor:[UIColor grayColor] textAlignment:(NSTextAlignmentCenter)];
        
        loginLab.hidden=YES;
        [cell.grayView addSubview:loginLab];
        
        
        checkNum=[LJControl buttonType:(UIButtonTypeSystem) setFrame:CGRectMake(0, 0, ScreenFrame.size.width-20, cell.grayView.size.height) setNormalImage:nil setSelectedImage:nil setTitle:@"点击查看您的夺宝号码" setTitleFont:12 setbackgroundColor:nil];
        [checkNum addTarget:self action:@selector(checkNumClick) forControlEvents:(UIControlEventTouchUpInside)];
        checkNum.hidden=YES;
        [cell.grayView addSubview:checkNum];
        
        BOOL login;
        [SYObject hasUserLogedIn:&login];
        if (login) {
            
            loginBtn.hidden=YES;
            lab.hidden=YES;
            loginLab.hidden=NO;
            if (codesArray.count>0)
            {
                
                checkNum.hidden=NO;
                loginLab.hidden=YES;
                
            }else
            {
                checkNum.hidden=YES;
                loginLab.hidden=NO;
                
                
            }
            
        }else{
            loginBtn.hidden=NO;
            lab.hidden=NO;
            loginLab.hidden=YES;
            checkNum.hidden=YES;
            
            
        }
        return cell;
        
    }
    if (indexPath.row == 3||indexPath.row==6)
    {
        cell.backgroundColor=UIColorFromRGB(0xf5f5f5);
        
    }
    if (indexPath.row == 4) {
       
        cell.textLabel.text=@"图文详情 (建议在wifi下查看)";
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        UIView *grayLine=[LJControl viewFrame:CGRectMake(0, 44, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe3e3e3)];
        [cell addSubview:grayLine];
        [self fuwenbenLabel:cell.textLabel FontNumber:[UIFont systemFontOfSize:13] AndRange:NSMakeRange(4, cell.textLabel.text.length-4) AndColor:[UIColor grayColor]];
        
    }
    if (indexPath.row == 5)
    {
        
        cell.textLabel.text=@"往期揭晓";
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        UIView *grayLine=[LJControl viewFrame:CGRectMake(0, 44, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe3e3e3)];
        [cell addSubview:grayLine];
        
    }
    
    if (indexPath.row == 7) {
        
        cell.textLabel.text=@"所有参与记录";
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        UIView *grayLine=[LJControl viewFrame:CGRectMake(0, 44, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe3e3e3)];
        [cell addSubview:grayLine];
//        [self fuwenbenLabel:cell.textLabel FontNumber:[UIFont systemFontOfSize:13] AndRange:NSMakeRange(6, cell.textLabel.text.length-6) AndColor:[UIColor grayColor]];
        
    }
    if (indexPath.row>7) {
        
        GoodsDetailRecord *record=[listDataArray objectAtIndex:indexPath.row-8];
        OneYuanDetailListCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"OneYuanDetailListCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=UIColorFromRGB(0xf5f5f5);
        cell.userName.text=record.user_name;
        cell.content.text=[NSString stringWithFormat:@"参与了%@人次  %@",record.purchased_times,record.addTime];
        //设置不同字体颜色
        [self fuwenbenLabel:cell.content FontNumber:[UIFont systemFontOfSize:12] AndRange:NSMakeRange(3, record.purchased_times.length) AndColor:[UIColor redColor]];
        
        [cell.img sd_setImageWithURL:[NSURL URLWithString:record.user_photo]];
        return cell;
        
    }
    return cell;

}
//倒计时结束
-(void)timeUp
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,CLOUDPURCHASE_GOODSDETAIL_TIMEUP_URL];
    NSDictionary *par = @{
                          
                          @"lottery_id":[NSString stringWithFormat:@"%@",purchased_id]
                  
                          };
    NSLog(@"par////%@",par);
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * resultDict = responseObject;
        NSInteger code=[resultDict[@"code"] integerValue];
        
        if(code ==10001)
        {
             NSLog(@"商品详情开奖请求******%@",resultDict);
            
            timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getNetworking1) userInfo:nil repeats:YES];
       
            
        }else
        {
            [SYObject failedPrompt:@"请求失败"];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:@"请求失败"];
        NSLog(@"%@",[error localizedDescription]);
    }];
    
  
}
-(void)getNetworking2
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,CLOUDPURCHASE_GOODSDETAIL_URL];
    NSDictionary *par = @{
                          
                          @"lottery_id":[NSString stringWithFormat:@"%@",self.ID]
                          };
    NSLog(@"par////%@",par);
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * resultDict = responseObject;
        NSInteger code=[resultDict[@"code"] integerValue];
        
        if(code ==10001)
        {
            NSLog(@"商品详情******%@",resultDict);
            NSDictionary *dict=[resultDict objectForKey:@"data"];
            dataArray=[[NSMutableArray alloc]init];
            arrImage=[[NSMutableArray alloc]init];
            
            lottery = [CloudPurchaseLottery yy_modelWithDictionary:dict];
            CloudPurchaseGoodsModel *model=[[CloudPurchaseGoodsModel alloc]init];
            model.period=[NSString stringWithFormat:@"%@",[dict objectForKey:@"period"]];
            model.purchased_id=[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
            //            purchased_id=model.purchased_id;
            model.purchased_left_times=[NSString stringWithFormat:@"%@",[dict objectForKey:@"purchased_left_times"]];
            model.status=[NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
            model.purchased_times=[NSString stringWithFormat:@"%@",[dict objectForKey:@"purchased_times"]];
            model.addTime=[NSString stringWithFormat:@"%@",[dict objectForKey:@"addTime"]];
            
            model.purchased_left_times=[NSString stringWithFormat:@"%@",[dict objectForKey:@"purchased_left_times"]];
            if ([[dict objectForKey:@"announced_date"]length]>0)
            {
                model.announced_date=[NSString stringWithFormat:@"%@",[dict objectForKey:@"announced_date"]];
                
            }
            NSDictionary *d=[dict objectForKey:@"cloudPurchaseGoods"];
            
            model.goods_name=[d objectForKey:@"goods_name"];
            model.goods_description=[d objectForKey:@"goods_description"];
            model.goods_price=[NSString stringWithFormat:@"%@",[d objectForKey:@"goods_price"]];
            model.least_rmb=[NSString stringWithFormat:@"%@",[d objectForKey:@"least_rmb"]];
            model.pictureID=[NSString stringWithFormat:@"%@",[d objectForKey:@"id"]];
            model.primary_photo=[d objectForKey:@"primary_photo"];
            
            [arrImage addObject:model.primary_photo];
            model.secondary_photo=[d objectForKey:@"secondary_photo"];
            
            NSMutableArray *ary1=(NSMutableArray *)[model.secondary_photo componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[],"]];
            [ary1 removeObjectAtIndex:0];
            [ary1 removeLastObject];
            for (int i=0; i<ary1.count; i++) {
                
                NSString *img=[[[ary1 objectAtIndex:i]componentsSeparatedByString:@"\""]objectAtIndex:1];
                [arrImage addObject:img];
                
            }
            [dataArray addObject:model];
            [goodsTabView reloadData];
            
            if (model.status.integerValue==5) {
                bottomView.hidden=NO;
                bottomView1.hidden=YES;
                
            }else
            {
                bottomView.hidden=YES;
                bottomView1.hidden=NO;
                
            }
            
        }else
        {
            [SYObject failedPrompt:@"请求失败"];
            
        }
     
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:@"请求失败"];
        NSLog(@"%@",[error localizedDescription]);
    }];
  
}
-(void)getNetworking1
{
    [SYObject startLoading];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,CLOUDPURCHASE_GOODSDETAIL_URL];
    NSDictionary *par = @{
                
                          @"lottery_id":[NSString stringWithFormat:@"%@",self.ID]
                        };
    NSLog(@"par////%@",par);
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * resultDict = responseObject;
        NSInteger code=[resultDict[@"code"] integerValue];
        
        if(code ==10001)
        {
            NSLog(@"商品详情******%@",resultDict);
            NSDictionary *dict=[resultDict objectForKey:@"data"];
            dataArray=[[NSMutableArray alloc]init];
            arrImage=[[NSMutableArray alloc]init];
            
            lottery = [CloudPurchaseLottery yy_modelWithDictionary:dict];
            CloudPurchaseGoodsModel *model=[[CloudPurchaseGoodsModel alloc]init];
            model.period=[NSString stringWithFormat:@"%@",[dict objectForKey:@"period"]];
            model.purchased_id=[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
//            purchased_id=model.purchased_id;
            model.purchased_left_times=[NSString stringWithFormat:@"%@",[dict objectForKey:@"purchased_left_times"]];
            model.status=[NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
            status=model.status;
            model.purchased_times=[NSString stringWithFormat:@"%@",[dict objectForKey:@"purchased_times"]];
            model.addTime=[NSString stringWithFormat:@"%@",[dict objectForKey:@"addTime"]];
            
            model.purchased_left_times=[NSString stringWithFormat:@"%@",[dict objectForKey:@"purchased_left_times"]];
            if ([[dict objectForKey:@"announced_date"]length]>0)
            {
                model.announced_date=[NSString stringWithFormat:@"%@",[dict objectForKey:@"announced_date"]];
                
            }
            NSDictionary *d=[dict objectForKey:@"cloudPurchaseGoods"];
            
            model.goods_name=[d objectForKey:@"goods_name"];
            model.goods_description=[d objectForKey:@"goods_description"];
            model.goods_price=[NSString stringWithFormat:@"%@",[d objectForKey:@"goods_price"]];
            model.least_rmb=[NSString stringWithFormat:@"%@",[d objectForKey:@"least_rmb"]];
            model.pictureID=[NSString stringWithFormat:@"%@",[d objectForKey:@"id"]];
            model.primary_photo=[d objectForKey:@"primary_photo"];
            
            [arrImage addObject:model.primary_photo];
            model.secondary_photo=[d objectForKey:@"secondary_photo"];
            NSMutableArray *ary1=(NSMutableArray *)[model.secondary_photo componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[],"]];
            [ary1 removeObjectAtIndex:0];
            [ary1 removeLastObject];
            for (int i=0; i<ary1.count; i++) {
                
                NSString *img=[[[ary1 objectAtIndex:i]componentsSeparatedByString:@"\""]objectAtIndex:1];
                [arrImage addObject:img];
                
            }
            [dataArray addObject:model];
            
            if ([status isEqualToString:@"15"])
            {
                
                [goodsTabView reloadData];
                [SYObject endLoading];
                [timer invalidate];
                timer=nil;
            }
           
            if (model.status.integerValue==5) {
                bottomView.hidden=NO;
                bottomView1.hidden=YES;
                
            } else {
                bottomView.hidden=YES;
                bottomView1.hidden=NO;
                
            }
            
        }else
        {
            [SYObject failedPrompt:@"请求失败"];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:@"请求失败"];
        NSLog(@"%@",[error localizedDescription]);
    }];
  
}
- (NSString *)intervalSinceNow: (NSString *) theDate
{
    NSArray *timeArray=[theDate componentsSeparatedByString:@"."];
    theDate=[timeArray objectAtIndex:0];
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    NSDate* dat = [NSDate date];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=late-now;
    
    NSLog(@"时间差%f",cha);
    timeString=[NSString stringWithFormat:@"%f",cha];
    
    
    
    return timeString;
}

- (NSString *)intervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2
{
    NSArray *timeArray1=[dateString1 componentsSeparatedByString:@"."];
    dateString1=[timeArray1 objectAtIndex:0];
    
    NSArray *timeArray2=[dateString2 componentsSeparatedByString:@"."];
    dateString2=[timeArray2 objectAtIndex:0];
    
    NSLog(@"%@.....%@",dateString1,dateString2);
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *d1=[date dateFromString:dateString1];
    
    NSTimeInterval late1=[d1 timeIntervalSince1970]*1;
    
    NSDate *d2=[date dateFromString:dateString2];
    
    NSTimeInterval late2=[d2 timeIntervalSince1970]*1;
    
    NSTimeInterval cha=late2-late1;
    NSString *timeString=@"";
    timeString=[NSString stringWithFormat:@"%f",cha];
    
    return timeString;
    
}

//点击查看夺宝号码
-(void)checkNumClick
{
    
    CloudPurchaseGoodsModel *model=[dataArray firstObject];

    NSString *number=[codesArray componentsJoinedByString:@" "];
    [WDAlertView showOneButtonWithTitle:model.goods_name Message:[NSString stringWithFormat:@"共参与%lu人次，夺宝号码:\n%@",(unsigned long)codesArray.count,number]  ButtonTitle:@"确定" Click:^{
        NSLog(@"夺宝号码");
    
    }];

}
//点击登录
-(void)loginClick
{

    NewLoginViewController *loginVC = [[NewLoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];


}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger index=scrollView.contentOffset.x/scrollView.frame.size.width;
    
    //设置当前的点,用来指示当前页面
    pageControl.currentPage=index;
    
}
//设置不同字体颜色
-(void)fuwenbenLabel:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labell.text];
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    labell.attributedText = str;
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

-(void)toBtnClick //立即前往
{
   
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,CLOUDPURCHASE_GOODSDETAILCURRENT_URL];
    NSDictionary *par = @{
                          //                          @"user_id":[MyNetTool currentUserID],
                          //                          @"token":[MyNetTool currentToken],
                          @"lottery_id":[NSString stringWithFormat:@"%@",self.ID]
                          
                          
                          };
    NSLog(@"par////%@",par);
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * resultDict = responseObject;
        NSInteger code=[resultDict[@"code"] integerValue];
       
        if(code ==10001)
        {
            NSLog(@"商品详情最新******%@",resultDict);
            NSDictionary *dict=[resultDict objectForKey:@"data"];
            if ([dict objectForKey:@"id"]) {
                NSString *currentID=[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
                
                CloudPurchaseGoodsDetailViewController *detail=[[CloudPurchaseGoodsDetailViewController alloc]init];
                detail.ID=currentID;
                [self.navigationController pushViewController:detail animated:YES];
                
            }else
            {
            [OHAlertView showAlertWithTitle:@"提示" message:@"抱歉，该商品已库存不足" cancelButton:@"确定" otherButtons:nil buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                
            }];
            
            
            }
                  
        }else
        {
            [SYObject failedPrompt:@"请求失败"];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:@"请求失败"];
        NSLog(@"%@",[error localizedDescription]);
    }];
    

       
}

@end
