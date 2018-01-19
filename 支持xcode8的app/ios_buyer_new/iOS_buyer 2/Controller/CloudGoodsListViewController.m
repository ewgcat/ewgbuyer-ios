//
//  CloudGoodsListViewController.m
//  My_App
//
//  Created by shiyuwudi on 16/2/23.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

#import "CloudGoodsListViewController.h"

#import "OneYuanViewController.h"
#import "OneYuanModel.h"
#import "OneYuanClassCell.h"
#import "OneYuanGoodsCell.h"
#import "OneYuanClassModel.h"
#import "CloudPurchaseGoods.h"
#import "BundlingViewController.h"
#import "OneYuanCartTableViewController.h"
#import "CloudPurchaseGoodsModel.h"
#import "CloudPurchaseGoodsDetailViewController.h"
#import "SwiftHeader.h"
#import "IndianaRecordsViewController.h"

static CGFloat upShowDistance = 200;//回到顶部按钮出现距离
//static CGFloat addToCartAnimationDuration = 1.0;//添加购物车动画持续时间
static NSInteger goodsCount = 4;//每次加载的热门商品数量

@interface CloudGoodsListViewController ()<UITableViewDataSource,UITableViewDelegate,SYDetailCellViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong)UITableView *allGoodsTableView;
@property (nonatomic,strong)UITableView *showPhotosTableView;
@property (nonatomic,strong)NSArray *array1;//最新揭晓
@property (nonatomic,strong)NSArray *array2;//上架新品
@property (nonatomic,strong)NSArray *array3;//今日热门商品
@property (nonatomic,weak)UILabel *numLabel;
@property (nonatomic,weak)UIButton *upBtn;
@property (nonatomic,weak)UIButton *cartBtn;
@property (nonatomic,assign)NSInteger lastCount;
@property (nonatomic,assign)BOOL noMore;


@end

@implementation CloudGoodsListViewController

{
    UIButton *likeBtn;//人气
    UIButton *latestBtn;//最新
    UIButton *unAllBtn;//剩余人次
    UIButton *allBtn;//总需人次
    UIButton *goodsClassBtn;//商品分类
    NSMutableArray *classArray;//分类数据源
    NSMutableArray *OneYuanGoodsArray;//一元商品数据源
    UITableView *classTableview;//分类Tableview
    
    NSMutableString *orderBy;//参数：排序方式
    // NSMutableString *orderType;//参数：正序逆序
    // NSMutableString *keyword;//参数：搜索关键字
    NSMutableString *classID;//参数：商品分类id
    BOOL flag;//正反排序标志
    UIView *TopView;
    UIImageView *img;
    UIImageView *imageNothing;
    UILabel *labelNothing;
    UIView *optionBg;
    int count;//用于列表下拉加载计数
    UIImageView *arrowView;
    
}


#pragma mark - 视图生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initArray];
    [self setupUI];
    [self setupListPage];
    [self netRequest];
    [self createRightBtn];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)createRightBtn{
    //cart_icon search setting
//    UIButton *buttonRecord = [UIButton buttonWithType:UIButtonTypeCustom];
//    buttonRecord.frame =CGRectMake(0, 0, 18, 18);
//    [buttonRecord setBackgroundImage:[UIImage imageNamed:@"ygavatar"] forState:UIControlStateNormal];
//    [buttonRecord addTarget:self action:@selector(personalCenterListPageClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonSearch.frame =CGRectMake(0, 0, 18, 18);
    [buttonSearch setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [buttonSearch addTarget:self action:@selector(searchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonCart = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonCart.frame =CGRectMake(0, 0, 18, 18);
    [buttonCart setBackgroundImage:[UIImage imageNamed:@"cart_icon"] forState:UIControlStateNormal];
    [buttonCart addTarget:self action:@selector(cartBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIBarButtonItem *bar1 = [[UIBarButtonItem alloc]initWithCustomView:buttonRecord];
    UIBarButtonItem *bar2 = [[UIBarButtonItem alloc]initWithCustomView:buttonCart];
    UIBarButtonItem *bar3 = [[UIBarButtonItem alloc]initWithCustomView:buttonSearch];
    self.navigationItem.rightBarButtonItems = @[bar2,bar3];
}
#pragma mark - 网络请求
//初始化数组
-(void)initArray{
    _array1 = [NSArray array];
    _array2 = [NSArray array];
    _array3 = [NSArray array];
}
//今日热门商品
-(void)netRequestForPopGoodsWithBeginCount:(NSInteger)beginCount SelectCount:(NSInteger)selectCount{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,CLOUDPURCHASE_GOODSLIST_URL];
    NSDictionary *par = @{
                          @"orderby":@"popularity",
                          @"ordertype":@"asc",
                          @"begin_count":[NSString stringWithFormat:@"%ld",(long)beginCount],
                          @"select_count":[NSString stringWithFormat:@"%ld",(long)selectCount],
                          @"class_id":@"",
                          };
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"今日热门商品******%@",responseObject);
        NSDictionary *dict = responseObject;
        NSArray *arr = dict[@"data"];
        NSMutableArray *tempArr = [NSMutableArray new];
        for (NSDictionary *dict1 in arr) {
            OneYuanModel *model = [OneYuanModel yy_modelWithDictionary:dict1];
            [tempArr addObject:model];
        }
        if(tempArr.count != 0){
            _array3 = [_array3 arrayByAddingObjectsFromArray:tempArr];
        }
        [[self currentTableView] reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:[error localizedDescription]];
    }];
}
//上架新品
-(void)netRequestForNewGoods{
    [SYObject startLoading];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,CLOUDPURCHASE_GOODSLIST_URL];
    NSDictionary *par = @{
                          @"orderby":@"addTime",
                          @"ordertype":@"asc",
                          @"begin_count":@"0",
                          @"select_count":@"3",
                          @"class_id":@"",
                          };
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"上架新品******%@",responseObject);
        [SYObject endLoading];
        NSDictionary *dict = responseObject;
        NSArray *arr = dict[@"data"];
        NSMutableArray *tempArr = [NSMutableArray new];
        for (NSDictionary *dict1 in arr) {
            OneYuanModel *model = [OneYuanModel yy_modelWithDictionary:dict1];
            [tempArr addObject:model];
        }
        _array2 = [tempArr copy];
        [[self currentTableView] reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject endLoading];
        [SYObject failedPrompt:[error localizedDescription]];
    }];
}
//最新揭晓
-(void)netRequestForNewPrizeWinner{
    [SYObject startLoading];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,CLOUDPURCHASE_NEW_WINNER_URL];
    NSDictionary *par = @{
                          @"begin_count":@"0",
                          @"select_count":@"3"
                          };
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SYObject endLoading];
        NSLog(@"最新揭晓:%@",responseObject);
        NSDictionary *dict = responseObject;
        NSArray *arr = dict[@"data"];
        NSMutableArray *tempArr = [NSMutableArray new];
        for (NSDictionary *dict1 in arr) {
            OneYuanModel *model = [OneYuanModel yy_modelWithDictionary:dict1];
            [tempArr addObject:model];
        }
        _array1 = [tempArr copy];
        [[self currentTableView] reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject endLoading];
        [SYObject failedPrompt:error.localizedDescription];
    }];
}
//商品分类
-(void)getGoodsClass
{
    //[SYObject startLoading];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,CLOUDPURCHASE_CLASS_URL];
    
    [[Requester managerWithHeader]POST:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SYObject endLoading];
        NSDictionary * resultDict = responseObject;
        NSInteger code=[resultDict[@"code"] integerValue];
        if(code ==10000)
        {
            OneYuanClassModel *model1=[[OneYuanClassModel alloc]init];
            model1.className=@"全部商品";
            model1.classID=@"";
            model1.classImg=@"";
            classArray=[NSMutableArray arrayWithObject:model1];
            
            NSLog(@"分类******%@",resultDict);
            NSArray *ary=[resultDict objectForKey:@"data"];
            for (NSDictionary *dic in ary)
            {
                OneYuanClassModel *model=[[OneYuanClassModel alloc]init];
                model.className=[dic objectForKey:@"class_name"];
                model.classID=[dic objectForKey:@"id"];
                model.classImg=[dic objectForKey:@"img_url"];
                [classArray addObject:model];
            }
            
            [classTableview reloadData];
            NSLog(@"分类数量、、、、、%ld",(unsigned long)classArray.count);
            
            
        }else
        {
            [SYObject failedPrompt:@"请求失败"];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject endLoading];
        [SYObject failedPrompt:@"请求失败"];
        NSLog(@"%@",[error localizedDescription]);
    }];
    
}
//商品列表的网络请求
-(void)getIndex:(NSString *)orderBY andorderType:(NSString *)orderType andUser_goodsclass_id:(NSString *)user_goodsclass_id andBegincount:(NSString *)begincount andSelectcount:(NSString *)selectcount {
    [SYObject startLoading];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,CLOUDPURCHASE_GOODSLIST_URL];
    NSDictionary *par = @{
                          
                          @"orderby":orderBY,
                          @"ordertype":orderType,
                          @"begin_count":begincount,
                          @"select_count":selectcount,
                          @"class_id":[NSString stringWithFormat:@"%@",user_goodsclass_id],
                          
                          };
    NSLog(@"par////%@",par);
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SYObject endLoading];
        NSDictionary * resultDict = responseObject;
        NSInteger code=[resultDict[@"code"] integerValue];
        NSLog(@"商品******%@",resultDict);
        if(code ==10000)
        {
            NSLog(@"云购商品******%@",resultDict);
            NSArray *ary=[resultDict objectForKey:@"data"];
            
            OneYuanGoodsArray=[[NSMutableArray alloc]init];
            for (NSDictionary *dic in ary)
            {
                CloudPurchaseGoodsModel *model=[[CloudPurchaseGoodsModel alloc]init];
                model.purchased_times=[NSString stringWithFormat:@"%@",[dic objectForKey:@"purchased_times"]];
                model.purchased_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                
                NSDictionary *d=[dic objectForKey:@"cloudPurchaseGoods"];
                model.goods_name=[d objectForKey:@"goods_name"];
                model.goods_price=[NSString stringWithFormat:@"%@",[d objectForKey:@"goods_price"]];
                model.least_rmb=[NSString stringWithFormat:@"%@",[d objectForKey:@"least_rmb"]];
                model.primary_photo=[d objectForKey:@"primary_photo"];
                [OneYuanGoodsArray addObject:model];
            }
            if (OneYuanGoodsArray.count ==0) {
                self.allGoodsTableView.hidden = YES;
                labelNothing.hidden=NO;
                imageNothing.hidden=NO;
                
            }else{
                self.allGoodsTableView.hidden = NO;
                
                labelNothing.hidden=YES;
                imageNothing.hidden=YES;
            }
            [self.allGoodsTableView reloadData];
            
            
            
        }else
        {
            self.allGoodsTableView.hidden = YES;
            labelNothing.hidden=NO;
            imageNothing.hidden=NO;
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:@"请求失败"];
        [SYObject endLoading];
        NSLog(@"%@",[error localizedDescription]);
        self.allGoodsTableView.hidden = YES;
        labelNothing.hidden=NO;
        imageNothing.hidden=NO;
        
    }];
    
}
-(void)netRequest{
    _array3 = [NSArray array];
    [self netRequestForNewPrizeWinner];
    [self netRequestForNewGoods];
    [self netRequestForPopGoodsWithBeginCount:0 SelectCount:goodsCount];
    self.lastCount = 0;
}
#pragma mark - 页面框架
-(void)setupListPage{
    classArray = [NSMutableArray array];
    OneYuanGoodsArray = [NSMutableArray array];
    //keyword=[[NSMutableString alloc]init];
    classID=[[NSMutableString alloc]init];
    orderBy=[[NSMutableString alloc]init];
    [orderBy setString:@"popularity"];
    flag=NO;
    count=1;
    if (self.mark==NO)
    {
        optionBg.hidden=YES;
        classTableview.hidden=YES;
        [arrowView setImage:[UIImage imageNamed:@"pull_down"]];
        [likeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [latestBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [unAllBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [allBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [orderBy setString:@"addTime"];
        [self getIndex:orderBy andorderType:@"desc" andUser_goodsclass_id:classID andBegincount:@"0" andSelectcount:@"20"];
        [self tapClick];
        [img setImage:[UIImage imageNamed:@"priceno"]];
        
    }
    else
    {
    //商品列表 网络请求数据
    [self getIndex:orderBy andorderType:@"desc" andUser_goodsclass_id:classID andBegincount:@"0" andSelectcount:@"20"];
    }
    [self getGoodsClass];
    imageNothing = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenFrame.size.width-200)/2, (ScreenFrame.size.height-250)/4, 200, 250)];
    imageNothing.image = [UIImage imageNamed:@"seller_center_nothing.png"];
    [self.allGoodsTableView addSubview:imageNothing];
    labelNothing = [[UILabel alloc]initWithFrame:CGRectMake(0, imageNothing.frame.origin.y+imageNothing.frame.size.height, ScreenFrame.size.width, 30)];
    labelNothing.text = @"抱歉，没有找到相关数据";
    labelNothing.textAlignment = NSTextAlignmentCenter;
    labelNothing.hidden=YES;
    imageNothing.hidden=YES;
    [self.allGoodsTableView addSubview:labelNothing];
}
-(void)setupUI{
    self.title = @"全部商品";
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    UIView *nodata = [SYObject noDataView];
    nodata.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:nodata];

    UITableView *tv = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    [self.view addSubview:tv];
    
    tv.delegate = self;
    tv.dataSource = self;
    tv.tableFooterView = [UIView new];
    tv.tableFooterView.backgroundColor = BACKGROUNDCOLOR;
    tv.backgroundColor = BACKGROUNDCOLOR;
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tv addHeaderWithTarget:self action:@selector(headerRefresh)];
    
    _allGoodsTableView = tv;
    [_allGoodsTableView addFooterWithTarget:self action:@selector(footerRefresh1)];
    
    
    [self createBackBtn];
    [self createRightBtn];
    
    self.allGoodsTableView.frame=CGRectMake(0, 38, ScreenFrame.size.width, ScreenFrame.size.height-64-44+6);
    self.allGoodsTableView.delegate=self;
    self.allGoodsTableView.dataSource=self;
    self.allGoodsTableView.showsVerticalScrollIndicator =NO;
    TopView=[LJControl viewFrame:CGRectMake(0, 0, ScreenFrame.size.width, 38) backgroundColor:[UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f]];
    //TopView.hidden=YES;
    [self.view addSubview:TopView];
    UIButton *firstBtn=[LJControl buttonType:(UIButtonTypeCustom) setFrame:CGRectMake(0, 0, ScreenFrame.size.width/5, 38) setNormalImage:nil setSelectedImage:nil setTitle:@"商品分类" setTitleFont:14 setbackgroundColor:[UIColor clearColor]];
    goodsClassBtn=firstBtn;
    [firstBtn setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateNormal)];
    firstBtn.tag=50;
    [firstBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [TopView addSubview:firstBtn];
    
    arrowView=[LJControl imageViewFrame:CGRectMake(firstBtn.right-2, 18, 7, 4) setImage:@"pull_down" setbackgroundColor:nil];
    [TopView addSubview:arrowView];
    
    
    UIView *grayLine=[LJControl viewFrame:CGRectMake(firstBtn.right+10, 4, 1, 30) backgroundColor:UIColorFromRGB(0xe3e3e3)];
    [TopView addSubview:grayLine];
    
    NSArray *titleAry=@[@"人气",@"最新",@"剩余人次",@"总需人次"];
    NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGSize size1 = [titleAry[0] sizeWithAttributes:attr];
    CGSize size2 = [titleAry[1] sizeWithAttributes:attr];
    CGSize size3 = [titleAry[2] sizeWithAttributes:attr];
    CGSize size4 = [titleAry[3] sizeWithAttributes:attr];
    
    for (int i=0; i<4;i++ )
    {
        UIButton *btn=[LJControl buttonType:(UIButtonTypeCustom) setFrame:CGRectMake(grayLine.right+(ScreenFrame.size.width-grayLine.right-15)/4*i, 0, (ScreenFrame.size.width-grayLine.right-15)/4, 38) setNormalImage:nil setSelectedImage:nil setTitle:titleAry[i] setTitleFont:14 setbackgroundColor:[UIColor clearColor]];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateNormal)];
        btn.tag=100+i;
        
        
        if (i==0) {
            
            likeBtn=btn;
            [btn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
            btn.frame=CGRectMake(grayLine.right+5, 0, size1.width, 38);
            
        }else if (i==1)
        {
            latestBtn=btn;
            self.latest=latestBtn;
            btn.frame=CGRectMake(grayLine.right+5+size1.width+(ScreenFrame.size.width-grayLine.right-5-15-size1.width-size2.width-size3.width-size4.width)/3, 0, size2.width, 38);
        }else if (i==2)
        {
            unAllBtn=btn;
            btn.frame=CGRectMake(grayLine.right+5+size1.width+size2.width+(ScreenFrame.size.width-5-grayLine.right-15-size1.width-size2.width-size3.width-size4.width)/3*2, 0, size3.width, 38);
        }else if (i==3)
        {
            allBtn=btn;
            btn.frame=CGRectMake(grayLine.right+5+size1.width+size2.width+size3.width+(ScreenFrame.size.width-5-grayLine.right-15-size1.width-size2.width-size3.width-size4.width), 0, size4.width, 38);
        }
        [TopView addSubview:btn];
    }
    
    
    img=[LJControl imageViewFrame:CGRectMake(ScreenFrame.size.width-15, 12, 10, 14) setImage:@"priceno" setbackgroundColor:nil];
    [TopView addSubview:img];
    
    optionBg=[LJControl viewFrame:CGRectMake(0, 44+44*3-6,ScreenFrame.size.width, ScreenFrame.size.height-44-64-44*3+6) backgroundColor:[UIColor blackColor]];
    optionBg.alpha=0.7;
    optionBg.hidden=YES;
    optionBg.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
    [optionBg addGestureRecognizer:tap];
    [self.view addSubview:optionBg];
    
    classTableview=[[UITableView alloc]initWithFrame:CGRectMake(0,44-6, ScreenFrame.size.width,44*3) style:UITableViewStylePlain];
    
    classTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    classTableview.delegate=self;
    classTableview.dataSource=self;
    classTableview.alpha=1;
    [self.view addSubview:classTableview];
    classTableview.hidden=YES;
}
-(void)tapView
{
    
    optionBg.hidden=YES;
    classTableview.hidden=YES;
    [arrowView setImage:[UIImage imageNamed:@"pull_down"]];
    goodsClassBtn.selected=!goodsClassBtn.selected;
    
}
//-(void)createRightBtn{
//    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBtnClicked)];
//    //     self.navigationItem.rightBarButtonItem =bar;
//    UIBarButtonItem *bar1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(personalCenterListPageClicked)];
//    self.navigationItem.rightBarButtonItems =@[bar,bar1];
//}
-(void)createCartIcon{
    UIButton *cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat h = 40;
    CGFloat w = h;
    CGFloat x = 10;
    CGFloat y = ScreenFrame.size.height - 10 - h;
    cartBtn.frame = CGRectMake(x, y, w, h);
    UIImage *cartImg = [UIImage imageNamed:@"ygcart"];
    [cartBtn setImage:cartImg forState:UIControlStateNormal];
    
    cartBtn.layer.cornerRadius = h / 2;
    cartBtn.alpha = 0.6;
    cartBtn.backgroundColor = UIColorFromRGB(0xf15353);
    
    [self.navigationController.view addSubview:cartBtn];
    [cartBtn addTarget:self action:@selector(cartBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _cartBtn = cartBtn;
    
    CGFloat w1 = 15;
    CGFloat h1 = 15;
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(w - w1, 0, w1, h1)];
    _numLabel = numLabel;
    numLabel.textColor = [UIColor whiteColor];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.font = [UIFont systemFontOfSize:14];
    numLabel.layer.cornerRadius = w1 / 2;
    numLabel.layer.masksToBounds = YES;
    [cartBtn addSubview:numLabel];
    numLabel.backgroundColor = [UIColor blackColor];
    
    UIButton *upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat h2 = 40;
    CGFloat w2 = h;
    CGFloat x2 = ScreenFrame.size.width - 10 - w2;
    CGFloat y2 = ScreenFrame.size.height - 10 - h2;
    upBtn.frame = CGRectMake(x2, y2, w2, h2);
    [upBtn setImage:[UIImage imageNamed:@"arrow_top"] forState:UIControlStateNormal];
    [self.navigationController.view addSubview:upBtn];
    [upBtn addTarget:self action:@selector(upBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _upBtn = upBtn;
    upBtn.hidden = YES;
    
    [self updateCartCount];
}


-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
#pragma mark - scrollView
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > upShowDistance) {
        _upBtn.hidden = NO;
    }else{
        _upBtn.hidden = YES;
    }
}
#pragma mark - 购物车逻辑
-(void)addCartWithItem:(OneYuanModel *)item{
    [SYShopAccessTool addToCartWithLotteryID:item.id count:item.cloudPurchaseGoods.least_rmb];
}
#pragma mark - 点击事件
//主页商品点击事件
-(void)mainGoodsClicked:(UIButton *)btn {
    NSInteger tag = btn.tag;
    OneYuanModel *model = nil;
    if (tag < 10) {
        model = _array1[tag - 00];
    }else if (tag < 20){
        model = _array2[tag - 10];
    }else{
        model = _array3[tag - 20];
    }
    
    CloudPurchaseGoodsDetailViewController *detail=[[CloudPurchaseGoodsDetailViewController alloc]init];
    detail.ID = model.id;
    [self.navigationController pushViewController:detail animated:YES];
}
//点击搜索按钮
-(void)searchBtnClicked{
//    CloudSearchViewController *search = [[CloudSearchViewController alloc]init];
//    [self.navigationController pushViewController:search animated:YES];
    //    [self presentViewController:search animated:true completion:nil];
}
//个人中心列表页
-(void)personalCenterListPageClicked{
    //个人中心列表页 测试00025
    [SYObject checkLogin:self.navigationController s:^(BOOL login) {
        if (login)
        {
            IndianaRecordsViewController *irvc=[[IndianaRecordsViewController alloc]init];
            [self.navigationController pushViewController:irvc animated:NO];
            
        }
    }];}
//分类点击事件
-(void)cellButtonClick:(UIButton *)btn
{
    NSLog(@"btn.tag=%ld",(long)btn.tag);
    optionBg.hidden=YES;
    classTableview.hidden=YES;
    [arrowView setImage:[UIImage imageNamed:@"pull_down"]];
    OneYuanClassModel *model=[classArray objectAtIndex:btn.tag];
    [classID setString:[NSString stringWithFormat:@"%@",model.classID]];
    [self getIndex:orderBy andorderType:@"desc" andUser_goodsclass_id:classID andBegincount:@"0" andSelectcount:@"20"];
    [self tapClick];
    UIButton *titleBtn=(UIButton *)[self.view viewWithTag:50];
    [titleBtn setTitle:model.className forState:(UIControlStateNormal)];
}
-(void)tapClick
{
    
    UIButton *btn=(UIButton *)[self.view viewWithTag:50];
    btn.selected=NO;
    
}

-(void)btnClick:(UIButton *)btn
{
    NSLog(@"%ld",(long)btn.tag);
    if (btn.tag==50)//商品分类
    {
        
        // [self getGoodsClass];//发网络请求
        btn.selected=!btn.selected;
        if (btn.selected) {
            optionBg.hidden=NO;
            classTableview.hidden=NO;
            [arrowView setImage:[UIImage imageNamed:@"pull_up"]];
        }else{
            optionBg.hidden=YES;
            classTableview.hidden=YES;
            [arrowView setImage:[UIImage imageNamed:@"pull_down"]];
        }
        [img setImage:[UIImage imageNamed:@"priceno"]];
        
        
    }else if (btn.tag==100)//人气
    {
        optionBg.hidden=YES;
        classTableview.hidden=YES;
        [arrowView setImage:[UIImage imageNamed:@"pull_down"]];
        [likeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [latestBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [unAllBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [allBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [orderBy setString:@"popularity"];
        [self getIndex:orderBy andorderType:@"desc" andUser_goodsclass_id:classID andBegincount:@"0" andSelectcount:@"20"];
        [self tapClick];
        [img setImage:[UIImage imageNamed:@"priceno"]];
        
    }else if (btn.tag==101)//最新
    {
        optionBg.hidden=YES;
        classTableview.hidden=YES;
        [arrowView setImage:[UIImage imageNamed:@"pull_down"]];
        [likeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [latestBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [unAllBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [allBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [orderBy setString:@"addTime"];
        [self getIndex:orderBy andorderType:@"desc" andUser_goodsclass_id:classID andBegincount:@"0" andSelectcount:@"20"];
        [self tapClick];
        [img setImage:[UIImage imageNamed:@"priceno"]];
        
    }else if (btn.tag==102)//剩余人次
    {
        optionBg.hidden=YES;
        classTableview.hidden=YES;
        [arrowView setImage:[UIImage imageNamed:@"pull_down"]];
        [likeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [latestBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [unAllBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [allBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [orderBy setString:@"purchased_times"];
        [self getIndex:orderBy andorderType:@"desc" andUser_goodsclass_id:classID andBegincount:@"0" andSelectcount:@"20"];
        [self tapClick];
        [img setImage:[UIImage imageNamed:@"priceno"]];
        
        
    }else if (btn.tag==103)//总需人次
    {
        flag=!flag;
        optionBg.hidden=YES;
        classTableview.hidden=YES;
        [arrowView setImage:[UIImage imageNamed:@"pull_down"]];
        [likeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [latestBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [unAllBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [allBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [orderBy setString:@"goods_price"];
        if (flag==YES) {
            [self getIndex:orderBy andorderType:@"desc" andUser_goodsclass_id:classID andBegincount:@"0" andSelectcount:@"20"];
            [img setImage:[UIImage imageNamed:@"pricedown"]];
            
        }else
        {
            [self getIndex:orderBy andorderType:@"asc" andUser_goodsclass_id:classID andBegincount:@"0" andSelectcount:@"20"];
            [img setImage:[UIImage imageNamed:@"priceup"]];
            
            
        }
        [self tapClick];
        
    }
    
}

-(void)addBtnClicked:(UIButton *)addBtn{
    NSInteger idx = addBtn.tag;
    OneYuanModel *model = _array3[idx];
    model.addedToCart = YES;
    [[self currentTableView] reloadData];
    [self addCartWithItem:model];
    [self updateCartCount];
//    CGRect frame = CGRectZero;
//    UIImage *goodsImage = nil;
//    UITableViewCell *cell = (UITableViewCell *)addBtn.superview.superview.superview;
//    UIView *holder = nil;
//    if (idx % 2 == 0) {
//        //是左边的商品
//        holder = cell.contentView.subviews[0];
//    }else {
//        holder = cell.contentView.subviews[2];
//    }
//    for (UIView *subview in holder.subviews) {
//        if ([subview isKindOfClass:[UIImageView class]] && subview.tag >= 400) {
//            UIImageView *imageView = (UIImageView *)subview;
//            frame = imageView.frame;
//            if (idx % 2 == 1) {
//                UIView *leftHolder = cell.contentView.subviews[0];
//                CGFloat offset = holder.left - leftHolder.left;
//                frame.origin.x += offset;
//            }
//            goodsImage = imageView.image;
//        }
//    }
//    //加车动画效果
//    if (goodsImage) {
//        frame = [cell.contentView convertRect:frame toView:self.navigationController.view];
//        UIImageView *imageCopy = [[UIImageView alloc]initWithFrame:frame];
//        imageCopy.image = goodsImage;
//        [self.navigationController.view addSubview:imageCopy];
//        [UIView animateWithDuration:addToCartAnimationDuration animations:^{
//            CGPoint center = _cartBtn.center;
//            imageCopy.frame = CGRectMake(center.x, center.y, 1, 1);
//        } completion:^(BOOL finished) {
//            [imageCopy removeFromSuperview];
//        }];
//    }
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:NO];
}
-(IBAction)cartBtnClicked:(id)sender{
    [SYObject checkLogin:self.navigationController s:^(BOOL login) {
        OneYuanCartTableViewController *cart = [[OneYuanCartTableViewController alloc]init];
        [self.navigationController pushViewController:cart animated:YES];
    }];
}
-(IBAction)upBtnClicked:(id)sender{
    [[self currentTableView] setContentOffset:CGPointZero animated:YES];
}
-(void)naviButtonClicked:(SYObject *)selff index:(NSInteger)index{
    if (index == 1) {
        TopView.hidden=NO;
    }else if(index==0)
    {
        TopView.hidden=YES;
        optionBg.hidden=YES;
        classTableview.hidden=YES;
        [arrowView setImage:[UIImage imageNamed:@"pull_down"]];
    }else
    {
        
        TopView.hidden=YES;
        optionBg.hidden=YES;
        classTableview.hidden=YES;
        [arrowView setImage:[UIImage imageNamed:@"pull_down"]];
    }
}
#pragma mark - 便民方法
-(UITableView *)currentTableView {
    return self.allGoodsTableView;
}
-(void)updateCartCount{
    [SYObject checkLogin:self.navigationController s:^(BOOL login) {
        [SYShopAccessTool checkCart:^(NSArray *items) {
            if (items.count == 0) {
                _numLabel.hidden = YES;
                _numLabel.text = @"0";
            }else{
                _numLabel.hidden = NO;
                _numLabel.text = [NSString stringWithFormat:@"%ld",(long)items.count];
            }
        }];
    }];
}
-(NSInteger)cartCount{
    return _numLabel.text.integerValue;
}
#pragma mark - 下拉刷新,上拉自动刷新
-(void)headerRefresh{
    [[self currentTableView] headerEndRefreshing];
    [self updateCartCount];
    [self netRequest];
    [self getIndex:orderBy andorderType:@"desc" andUser_goodsclass_id:classID andBegincount:@"0" andSelectcount:@"20"];
    
}
-(void)footerRefresh{
    [self netRequestForPopGoodsWithBeginCount:self.lastCount SelectCount:goodsCount];
}
-(void)footerRefresh1
{
    count++;
    [self getIndex:orderBy andorderType:@"desc" andUser_goodsclass_id:classID andBegincount:@"0" andSelectcount:[NSString stringWithFormat:@"%d",count*20]];
    [self.allGoodsTableView footerEndRefreshing];
    
}

#pragma mark - tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView==self.allGoodsTableView){
        return OneYuanGoodsArray.count;
    }else if (tableView==classTableview) {
        
        if (classArray.count%3<3&&classArray.count%3!=0) {
            return classArray.count/3+1;
        }else
            return classArray.count/3;
        
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==classTableview) {
        return 44;
    }
    else if(tableView==self.allGoodsTableView){
        return 100;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:classTableview]) {
        static NSString *myTabelviewCell =@"classCell";
        OneYuanClassCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"OneYuanClassCell" owner:self options:nil] lastObject];
            
        }
        if (classArray.count%3!=0) {
            if (indexPath.row<=classArray.count/3-1) {
                OneYuanClassModel *classModel1=[classArray objectAtIndex:indexPath.row+2*indexPath.row];
                [cell.firstBtn setTitle:classModel1.className forState:UIControlStateNormal];
                if (classModel1.classImg.length>0) {
                    NSData *imgData1=[NSData dataWithContentsOfURL:[NSURL URLWithString:classModel1.classImg]];
                    [cell.firstBtn setImage:[UIImage imageWithData:imgData1] forState:UIControlStateNormal];
                }else
                {
                    [cell.firstBtn setImage:[UIImage imageNamed:@"kong_lj"] forState:(UIControlStateNormal)];
                    
                }
                
                
                cell.firstBtn.tag=indexPath.row+2*indexPath.row;
                [cell.firstBtn addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                
                
                OneYuanClassModel *classModel2=[classArray objectAtIndex:indexPath.row+2*indexPath.row+1];
                [cell.secondBtn setTitle:classModel2.className forState:UIControlStateNormal];
                if (classModel2.classImg.length>0)
                {
                    NSData *imgData2=[NSData dataWithContentsOfURL:[NSURL URLWithString:classModel2.classImg]];
                    [cell.secondBtn setImage:[UIImage imageWithData:imgData2] forState:UIControlStateNormal];
                }else
                {
                    [cell.secondBtn setImage:[UIImage imageNamed:@"kong_lj"] forState:(UIControlStateNormal)];
                    
                }
                cell.secondBtn.tag=indexPath.row+2*indexPath.row+1;
                [cell.secondBtn addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                
                OneYuanClassModel *classModel3=[classArray objectAtIndex:indexPath.row+2*indexPath.row+2];
                [cell.thirdBtn setTitle:classModel3.className forState:UIControlStateNormal];
                if (classModel3.classImg.length>0)
                {
                    NSData *imgData3=[NSData dataWithContentsOfURL:[NSURL URLWithString:classModel3.classImg]];
                    [cell.thirdBtn setImage:[UIImage imageWithData:imgData3] forState:UIControlStateNormal];
                }else
                {
                    [cell.thirdBtn setImage:[UIImage imageNamed:@"kong_lj"] forState:(UIControlStateNormal)];
                    
                }
                cell.thirdBtn.tag=indexPath.row+2*indexPath.row+2;
                [cell.thirdBtn addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                
            }else
            {
                
                if (classArray.count%3==1) {
                    OneYuanClassModel *classModel1=[classArray objectAtIndex:indexPath.row+2*indexPath.row];
                    [cell.firstBtn setTitle:classModel1.className forState:UIControlStateNormal];
                    if (classModel1.classImg.length>0) {
                        NSData *imgData1=[NSData dataWithContentsOfURL:[NSURL URLWithString:classModel1.classImg]];
                        [cell.firstBtn setImage:[UIImage imageWithData:imgData1] forState:UIControlStateNormal];
                    }else
                    {
                        [cell.firstBtn setImage:[UIImage imageNamed:@"kong_lj"] forState:(UIControlStateNormal)];
                        
                    }
                    cell.firstBtn.tag=indexPath.row+2*indexPath.row;
                    [cell.firstBtn addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                }else if (classArray.count%3==2)
                {
                    OneYuanClassModel *classModel1=[classArray objectAtIndex:indexPath.row+2*indexPath.row];
                    [cell.firstBtn setTitle:classModel1.className forState:UIControlStateNormal];
                    if (classModel1.classImg.length>0) {
                        NSData *imgData1=[NSData dataWithContentsOfURL:[NSURL URLWithString:classModel1.classImg]];
                        [cell.firstBtn setImage:[UIImage imageWithData:imgData1] forState:UIControlStateNormal];
                    }else
                    {
                        [cell.firstBtn setImage:[UIImage imageNamed:@"kong_lj"] forState:(UIControlStateNormal)];
                        
                    }
                    cell.firstBtn.tag=indexPath.row+2*indexPath.row;
                    [cell.firstBtn addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                    OneYuanClassModel *classModel2=[classArray objectAtIndex:indexPath.row+2*indexPath.row+1];
                    [cell.secondBtn setTitle:classModel2.className forState:UIControlStateNormal];
                    if (classModel2.classImg.length>0)
                    {
                        NSData *imgData2=[NSData dataWithContentsOfURL:[NSURL URLWithString:classModel2.classImg]];
                        [cell.secondBtn setImage:[UIImage imageWithData:imgData2] forState:UIControlStateNormal];
                    }else
                    {
                        [cell.secondBtn setImage:[UIImage imageNamed:@"kong_lj"] forState:(UIControlStateNormal)];
                        
                    }
                    cell.secondBtn.tag=indexPath.row+2*indexPath.row+1;
                    [cell.secondBtn addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                }
                
            }
            
            
        }
        else{
            
            OneYuanClassModel *classModel1=[classArray objectAtIndex:indexPath.row+2*indexPath.row];
            [cell.firstBtn setTitle:classModel1.className forState:UIControlStateNormal];
            if (classModel1.classImg.length>0) {
                NSData *imgData1=[NSData dataWithContentsOfURL:[NSURL URLWithString:classModel1.classImg]];
                [cell.firstBtn setImage:[UIImage imageWithData:imgData1] forState:UIControlStateNormal];
            }else
            {
                [cell.firstBtn setImage:[UIImage imageNamed:@"kong_lj"] forState:(UIControlStateNormal)];
                
            }
            cell.firstBtn.tag=indexPath.row+2*indexPath.row;
            [cell.firstBtn addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
            OneYuanClassModel *classModel2=[classArray objectAtIndex:indexPath.row+2*indexPath.row+1];
            [cell.secondBtn setTitle:classModel2.className forState:UIControlStateNormal];
            if (classModel2.classImg.length>0)
            {
                NSData *imgData2=[NSData dataWithContentsOfURL:[NSURL URLWithString:classModel2.classImg]];
                [cell.secondBtn setImage:[UIImage imageWithData:imgData2] forState:UIControlStateNormal];
            }else
            {
                [cell.secondBtn setImage:[UIImage imageNamed:@"kong_lj"] forState:(UIControlStateNormal)];
                
            }
            cell.secondBtn.tag=indexPath.row+2*indexPath.row+1;
            [cell.secondBtn addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            OneYuanClassModel *classModel3=[classArray objectAtIndex:indexPath.row+2*indexPath.row+2];
            [cell.thirdBtn setTitle:classModel3.className forState:UIControlStateNormal];
            if (classModel3.classImg.length>0)
            {
                NSData *imgData3=[NSData dataWithContentsOfURL:[NSURL URLWithString:classModel3.classImg]];
                [cell.thirdBtn setImage:[UIImage imageWithData:imgData3] forState:UIControlStateNormal];
            }else
            {
                [cell.thirdBtn setImage:[UIImage imageNamed:@"kong_lj"] forState:(UIControlStateNormal)];
                
            }
            cell.thirdBtn.tag=indexPath.row+2*indexPath.row+2;
            [cell.thirdBtn addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        // }
        
        return cell;
    }else if ([tableView isEqual:self.allGoodsTableView])
    {
        if (OneYuanGoodsArray.count>0) {
            
            
            static NSString *myTabelviewCell =@"OneYuanGoodsCell";
            OneYuanGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
            if(cell == nil){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"OneYuanGoodsCell" owner:self options:nil] lastObject];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
            }
            CloudPurchaseGoodsModel *model=[OneYuanGoodsArray objectAtIndex:indexPath.row];
            cell.goodsName.text=model.goods_name;
            [cell.img sd_setImageWithURL:[NSURL URLWithString:model.primary_photo]placeholderImage:[UIImage imageNamed:@"kong_lj.png"]];
            cell.img.tag=indexPath.row+900;
            cell.allPeople.text=[NSString stringWithFormat:@"总需%@人次",model.goods_price];
            
            NSInteger unall= model.goods_price.integerValue - model.purchased_times.integerValue;
            cell.unAll.text=[NSString stringWithFormat:@"%ld",(long)unall];
            cell.progressView.progress=model.purchased_times.floatValue/model.goods_price.floatValue;
            cell.progressView.progressImage = [UIImage imageNamed:@"ygprogress"];
            [cell.addBtn addTarget:self action:@selector(addPurcher:) forControlEvents:(UIControlEventTouchUpInside)];
            cell.addBtn.tag=indexPath.row+300;
            if (model.least_rmb.integerValue==1) {
                cell.specialImg.hidden=YES;
                
            }else
            {
                cell.specialImg.hidden=NO;
                
            }
            
            return cell;
            
        }
        
    }
    return [UITableViewCell new];
}
//全部商品列表加入购物车点击方法
-(void)addPurcher:(UIButton *)btn
{
    CloudPurchaseGoodsModel *model=[OneYuanGoodsArray objectAtIndex:btn.tag-300];
    [SYShopAccessTool addToCartWithLotteryID:model.purchased_id count:[NSString stringWithFormat:@"%@",model.least_rmb]];
    
    [self updateCartCount];
    [[self currentTableView] reloadData];
    
//    CGRect frame = CGRectZero;
//    UIImage *goodsImage = nil;
//    UITableViewCell *cell = (UITableViewCell *)btn.superview.superview;
//    frame = ((UIImageView *)[self.view viewWithTag:btn.tag-300+900]).frame;
//    goodsImage = ((UIImageView *)[self.view viewWithTag:btn.tag-300+900]).image;
    //加车动画效果
//    if (goodsImage) {
//        frame = [cell.contentView convertRect:frame toView:self.navigationController.view];
//        UIImageView *imageCopy = [[UIImageView alloc]initWithFrame:frame];
//        imageCopy.image = goodsImage;
//        [self.navigationController.view addSubview:imageCopy];
//        [UIView animateWithDuration:addToCartAnimationDuration animations:^{
//            CGPoint center = _cartBtn.center;
//            imageCopy.frame = CGRectMake(center.x, center.y, 1, 1);
//        } completion:^(BOOL finished) {
//            [imageCopy removeFromSuperview];
//        }];
//    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.allGoodsTableView])
    {
        CloudPurchaseGoodsModel *model=[OneYuanGoodsArray objectAtIndex:indexPath.row];
        CloudPurchaseGoodsDetailViewController *detail=[[CloudPurchaseGoodsDetailViewController alloc]init];
        detail.ID=model.purchased_id;
        [self.navigationController pushViewController:detail animated:YES];
        
        
    }
    
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
