    //
//  DetailViewController.m
//  My_App
//
//  Created by apple on 14-7-30.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "DetailViewController.h"
#import "SecondViewController.h"
#import "ASIFormDataRequest.h"
#import "RegionCell.h"
#import "EstimateViewController.h"
#import "ConsultViewController.h"
#import "writeViewController.h"
#import "DDPageControl.h"
#import "StoreHomeViewController2.h"
#import "FirstViewController.h"
#import "ChatViewController.h"
#import "NilCell.h"
#import "NewLoginViewController.h"
#import "AppDelegate.h"

#import "EvaModel.h"
#import "MoreButton.h"
#import "ThreeDotView.h"
#import "CartViewController.h"
#import "GoodsDetailCell1.h"
#import "GoodsDetailCell2.h"
#import "GoodsDetailCell3.h"
#import "GoodsDetailCell4.h"
#import "GoodsDetailCell5.h"
#import "GoodsDetailCell6.h"
#import "GoodsDetailCell7.h"
#import "GoodsDetailCell8.h"
#import "CombinedViewController.h"

static float reload_distance = 80;//拖拽切换界面允许的距离
static NSTimeInterval animeDuration = 0.5;//界面切换动画时长

@interface DetailViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,SYDetailCellViewDelegate,WDAlertViewDatasource,WDAlertViewDelegate>
//虚拟
//视图
@property (nonatomic, weak)UIScrollView *containerScrollView;//总的滚动视图
@property (nonatomic, weak)UITableView *evaluateTableView;//评价表视图
@property (nonatomic, weak)UIScrollView *headNaviScrollView;//导航栏里的滚动视图
@property (nonatomic, weak)UIView *headNaviView;//导航栏头视图1
@property (nonatomic, weak)UIView *headNaviView2;//导航栏头视图2
@property (nonatomic, weak)UIButton *goodsHomePageBtn;//导航栏-商品
@property (nonatomic, weak)UIButton *detailBtn;//导航栏-详情
@property (nonatomic, weak)UIButton *evaluateBtn;//导航栏-评价
@property (nonatomic, weak)UIView *whiteView;//黄色滚动条
@property (nonatomic, weak)UIButton *currentBtn;//导航栏内部三个按钮中的一个
@property (nonatomic, weak)UIButton *currentEvaBtn;//当前评价按钮
@property (nonatomic, weak)UIButton *currentSpecBtn;//当前规格按钮
@property (nonatomic, weak)UIStackView *headStackView;
@property (nonatomic, assign)BOOL showDiscountTicket;//是否可以使用优惠券
@property (nonatomic, weak)UIView *evaluateHeaderView;//红粉评价按钮的父视图
@property (nonatomic, strong)SYObject *detailCellView;//视图工厂类
@property (nonatomic, strong)UIView *noDataView;//无数据视图
//数组和字典
@property (nonatomic, strong)NSArray *evaluateArray;//评价数组
@property (nonatomic, strong)NSMutableArray *imageSizeArray;//图片尺寸的数组
@property (nonatomic, strong)NSMutableDictionary *imageSizeDictNormal;//图片尺寸的字典
@property (nonatomic, strong)NSMutableDictionary *imageSizeDictAdd;//图片尺寸的字典
//其他
@property (nonatomic, weak)ThreeDotView *tdv;
//规格页面
@property (nonatomic, strong)UIView *semiTransparentView;
@property (nonatomic, strong)UIView *specifView;
@property (nonatomic, strong)UITableView *specTableView;
@property (nonatomic, strong)UIView *BottomViewSpec;
@property (nonatomic, strong)NSMutableArray *specArray;
@property (nonatomic, strong)NSMutableString *specIdsString;
@property (nonatomic, strong)NSMutableArray *specIdsArray;

@end

@implementation DetailViewController
{
    WDAlertView * alertList;
    NSString *stateNew;
    NSString *cityNew;
    NSString *subCityNew;
    
    
}
- (void)viewDidLoad{
    specSelectBool = NO;
    [super viewDidLoad];
    [self createNoDataView];
    [self createBackBtn];
    
    [self getReloadData];
    
    indexPath1Bool = NO;
    indexPath2Bool = NO;
    selectRegionIndex = -1;
    // Do any additional setup after loading the view from its nib.
    specSelectArray = [[NSMutableArray alloc]init];
    maylikeArray = [[NSMutableArray alloc]init];
    dataArray  = [[NSMutableArray alloc]init];
    specificationsArray = [[NSMutableArray alloc]init];
    regionArray = [[NSMutableArray alloc]init];
    zuheArray = [[NSMutableArray alloc]init];
    zuhePeijianArray = [[NSMutableArray alloc]init];
    peijianSelectArray = [[NSMutableArray alloc]init];
    _specIdsArray=[[NSMutableArray alloc]init];
    selectBool = NO;
    tableBool = NO;
    scrollBool = NO;
    muchView.hidden = YES;
    muchBool = NO;
    [grayMuchImage.layer setMasksToBounds:YES];
    [grayMuchImage.layer setCornerRadius:4];

    
}
-(void)viewDidLayoutSubviews{
    [self createMoreBtn];
}
-(void)createMoreBtn{
    ThreeDotView *tdv = [[ThreeDotView alloc]initWithButtonCount:2 nc:self.navigationController];
    self.tdv = tdv;
    tdv.dataArray = dataArray;
    tdv.vc = self;
    [tdv insertMoreBtn:[tdv homeBtn]];
    [tdv insertMoreBtn:[tdv shareBtn]];
    tdv.hidden = YES;
}
- (void)didReceiveMemoryWarningƒ
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
-(void)dealloc {
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    labelTi = nil;
//    btn2Qing = nil;
    btnAddCar = nil;
    MyTableView = nil;
    RegoinTableView = nil;
    dataArray = nil;
    specificationsArray = nil;
    maylikeArray = nil;
    arrImage = nil;
    morenSpec = nil;
    labelinventory = nil;
    regionArray = nil;
    regionView = nil;
    selectRegion = nil;
    regionStr = nil;
    btnSC = nil;
    feetext = nil;
    cuPrice = nil;
    status = nil;
    myWebView = nil;
    myWebView1 = nil;
}
#pragma mark - 初始化代码
-(void)createNoDataView{
    //无数据视图 526*419图片尺寸
    UIView *noDataView = [[UIView alloc]init];
    UIImageView *noDataIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"seller_center_nothing"]];
//    noDataIV.frame = CGRectMake(20.f/568.f*ScreenFrame.size.height, 80.f/568.f*ScreenFrame.size.height, 0.5*526.f/568.f*ScreenFrame.size.height, 0.5*419.f/568.f*ScreenFrame.size.height);
     noDataIV.frame = CGRectMake(100.f/568.f*ScreenFrame.size.height, 80.f/568.f*ScreenFrame.size.height, 0.5*314.f/568.f*ScreenFrame.size.height, 0.5*314.f/568.f*ScreenFrame.size.height);
    [noDataView addSubview: noDataIV];
    UILabel *noDataLabel = [[UILabel alloc]init];
    noDataLabel.text = @"抱歉，并没有数据可以显示";
    noDataLabel.textAlignment = NSTextAlignmentCenter;
    noDataLabel.frame = CGRectMake(0, 300.f/568.f*ScreenFrame.size.height, ScreenFrame.size.width, 20.f/568.f*ScreenFrame.size.height);
    [noDataView addSubview:noDataLabel];
    _noDataView = noDataView;
    noDataView.backgroundColor = BACKGROUNDCOLOR;
}
-(void)loadEvaluateView{
    //评价数量显示
    if (_evaluateHeaderView) {
        //更新评价数据
        [SYShopAccessTool getEvaluateNumUseGoodsID:self.detail_id.integerValue success:^(NSDictionary *dict) {
            NSLog(@"好中差%@",dict);
            NSString *num1 = [[(NSString*)dict[@"well"] componentsSeparatedByString:@"-"]objectAtIndex:0];
            NSString *num2 = [[(NSString*)dict[@"middle"] componentsSeparatedByString:@"-"]objectAtIndex:0];
            NSString *num3 = [[(NSString*)dict[@"bad"] componentsSeparatedByString:@"-"]objectAtIndex:0];
            NSString *num0 = [NSString stringWithFormat:@"%ld",(unsigned long)(num1.integerValue+num2.integerValue+num3.integerValue)];
            NSString *str0 = [NSString stringWithFormat:@"全部 %@",num0];
            NSString *str1 = [NSString stringWithFormat:@"好评 %@",num1];
            NSString *str2 = [NSString stringWithFormat:@"中评 %@",num2];
            NSString *str3 = [NSString stringWithFormat:@"差评 %@",num3];
            NSArray *evaluateBtnTitleArr = @[@"",str0,str1,str2,str3];
            for (int i=0;i<_evaluateHeaderView.subviews.count;i++) {
                NSInteger tag = _evaluateHeaderView.subviews[i].tag;
                if (tag>=514&&tag<=517) {
                    UIButton *btn = (UIButton *)_evaluateHeaderView.subviews[i];
                    [btn setTitle:evaluateBtnTitleArr[i] forState:UIControlStateNormal];
                }
            }
        } fail:^(NSString *errStr) {
            //if fail on request
            NSLog(@"error:%@, func name:loadEvaluateView",errStr);
        }];
        return;
    }
    CGFloat tv2X = ScreenFrame.size.width*2;
    CGFloat tv2Y = ScreenFrame.size.height* 64.f/667.f;
    UIView *evaluateHeaderView = [[UIView alloc]initWithFrame:CGRectMake(tv2X, 0, ScreenFrame.size.width, tv2Y)];
    //添加分隔线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, tv2Y, evaluateHeaderView.frame.size.width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [evaluateHeaderView addSubview:line];
    _evaluateHeaderView = evaluateHeaderView;
    [SYShopAccessTool getEvaluateNumUseGoodsID:self.detail_id.integerValue success:^(NSDictionary *dict) {
        NSString *num1 = [[(NSString*)dict[@"well"] componentsSeparatedByString:@"-"]objectAtIndex:0];
        NSString *num2 = [[(NSString*)dict[@"middle"] componentsSeparatedByString:@"-"]objectAtIndex:0];
        NSString *num3 = [[(NSString*)dict[@"bad"] componentsSeparatedByString:@"-"]objectAtIndex:0];
        NSString *num0 = [NSString stringWithFormat:@"%ld",(unsigned long)(num1.integerValue+num2.integerValue+num3.integerValue)];
        NSString *str0 = [NSString stringWithFormat:@"全部 %@",num0];
        NSString *str1 = [NSString stringWithFormat:@"好评 %@",num1];
        NSString *str2 = [NSString stringWithFormat:@"中评 %@",num2];
        NSString *str3 = [NSString stringWithFormat:@"差评 %@",num3];
        NSArray *evaluateBtnTitleArr = @[str0,str1,str2,str3];
        for (int i=0; i<4; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            //按钮tag:全部，514，好评，515，中评516，差评，517。
            btn.tag = 514+i;
            [btn setTitle:evaluateBtnTitleArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:_K_Color(77, 77, 77) forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
            CGFloat w = (ScreenFrame.size.width-12*2-6*3)*0.25;
            CGFloat h = w/85.f*35.f;
            CGFloat y = (tv2Y-h)*0.5;
            
            CGFloat x = 12+i*(w+6);
            btn.frame = CGRectMake(x, y, w, h);
            [evaluateHeaderView addSubview:btn];
            [btn addTarget:self action:@selector(evaBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn setBackgroundColor:_K_Color(255.f, 239.f, 242.f)];
            btn.layer.cornerRadius = btn.frame.size.height*0.5;
        }
        UIButton *allBtn = evaluateHeaderView.subviews[1];
        if (!_currentEvaBtn) {
            [self evaBtnClicked:allBtn];
        }
    } fail:^(NSString *errStr) {
        //if fail on request
        NSLog(@"error:%@, func name:loadEvaluateView",errStr);
    }];
    [_containerScrollView addSubview:evaluateHeaderView];
}

#pragma mark - 懒加载
-(NSArray *)evaluateArray{
    if (!_evaluateArray) {
        _evaluateArray = [NSArray array];
    }
    return _evaluateArray;
}

-(SYObject *)detailCellView{
    if (!_detailCellView) {
        _detailCellView = [[SYObject alloc]init];
        _detailCellView.delegate = self;
    }
    return _detailCellView;
}
-(NSMutableArray *)imageSizeArray{
    if (!_imageSizeArray) {
        _imageSizeArray = [NSMutableArray array];
    }
    return _imageSizeArray;
}
-(NSMutableDictionary *)imageSizeDictNormal{
    if (!_imageSizeDictNormal) {
        _imageSizeDictNormal = [NSMutableDictionary dictionary];
    }
    return _imageSizeDictNormal;
}
-(NSMutableDictionary *)imageSizeDictAdd{
    if (!_imageSizeDictAdd) {
        _imageSizeDictAdd = [NSMutableDictionary dictionary];
    }
    return _imageSizeDictAdd;
}
#pragma mark - 初始化黄条
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!_whiteView) {
        CGRect f = self.goodsHomePageBtn.frame;
        CGFloat h = self.headNaviView.frame.size.height * 0.05;
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, self.headNaviView.frame.size.height*0.95, f.size.width, h)];
        whiteView.backgroundColor = [UIColor yellowColor];
        _whiteView = whiteView;
        [self.navigationItem.titleView addSubview:_whiteView];
       
    }
    [self specificationInformation];
}
#pragma mark - 评论图片代理方法
//拿到了图片尺寸(每下载成功一个图片就会被调用一次)
-(void)imageSizeAcquired:(SYObject *)detailCellView size:(CGSize)size index:(NSInteger)index cellIndex:(NSInteger)cellIndex type:(SY_PHOTO_TYPE)type{
    if (type==SY_PHOTO_TYPE_NORMAL) {
        NSArray *indexArray = @[@(cellIndex),@(index)];
        [self.imageSizeDictNormal setObject:[NSValue valueWithCGSize:size] forKey:indexArray];
    }else if(type==SY_PHOTO_TYPE_ADD){
        NSArray *addIndexArray = @[@(cellIndex),@(index)];
        [self.imageSizeDictAdd setObject:[NSValue valueWithCGSize:size] forKey:addIndexArray];
    }else{
    }
}
//评价-晒单-图片被点击
-(void)imageBtnIsClicked:(SYObject *)detailCellView indexOfImage:(NSInteger)index cellIndex:(NSInteger)cellIndex type:(SY_PHOTO_TYPE)type{
    EvaModel *evaModel = self.evaluateArray[cellIndex];
    NSArray *photoArr;
    NSDictionary *photoSizeDict;
    if (type == SY_PHOTO_TYPE_NORMAL) {
        photoArr = (NSArray *)evaModel.evaluate_photos;
        photoSizeDict = self.imageSizeDictNormal;
    }else{
        photoArr = (NSArray *)evaModel.add_evaluate_photos;
        photoSizeDict = self.imageSizeDictAdd;
    }
    UIScrollView *shadowScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height)];
    shadowScrollView.contentSize = CGSizeMake(photoArr.count*ScreenFrame.size.width, ScreenFrame.size.height);
    shadowScrollView.pagingEnabled = YES;
    for (int i=0; i<photoArr.count; i++) {
        NSArray *indexArray = @[@(cellIndex),@(i)];
        NSValue *value = [photoSizeDict objectForKey:indexArray];
        CGSize size = value.CGSizeValue;
        CGFloat w,h;
        if (size.width<=0) {
            return;
        }
        h=size.height/size.width*ScreenFrame.size.width;
        w=ScreenFrame.size.width;
        CGPoint centerP = CGPointMake(ScreenFrame.size.width*0.5, ScreenFrame.size.height*0.5);
        UIButton *shadowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shadowBtn.frame = CGRectMake(i*ScreenFrame.size.width, 0, ScreenFrame.size.width, ScreenFrame.size.height);
        shadowBtn.backgroundColor = [UIColor blackColor];
        UIImageView *iv = [[UIImageView alloc]init];
        iv.center = centerP;
        iv.bounds = CGRectMake(0, 0, w, h);
        NSString *imageStr = photoArr[i];
        NSURL *imageURL = [NSURL URLWithString:imageStr];
        [iv sd_setImageWithURL:imageURL];
        [shadowBtn addSubview:iv];
        [shadowBtn addTarget:self action:@selector(syShadowClicked:) forControlEvents:UIControlEventTouchUpInside];
        shadowScrollView.contentOffset = CGPointMake(index*ScreenFrame.size.width, 0);
        [shadowScrollView addSubview:shadowBtn];
        UILabel *pageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.45*ScreenFrame.size.width, 0.9*ScreenFrame.size.height, 100, 20)];
        pageLabel.text = [NSString stringWithFormat:@"%ld/%lu",(unsigned long)i+1,(unsigned long)photoArr.count];
        pageLabel.textColor = [UIColor whiteColor];
        [shadowBtn addSubview:pageLabel];
    }
    [self.navigationController.view addSubview:shadowScrollView];
}
#pragma mark - 刷新界面
-(void)getReloadData{
    
//    [standard setObject:state forKey:@"stateNew"];
//    [standard setObject:city forKey:@"cityNew"];
//    [standard setObject:subCity forKey:@"subCityNew"];
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
   stateNew=[standard objectForKey:@"stateNew"];
    cityNew=[standard objectForKey:@"cityNew"];
    subCityNew=[standard objectForKey:@"subCityNew"];
    
    [standard synchronize];
    
    SecondViewController *sec = [SecondViewController sharedUserDefault];
    self.detail_id = sec.detail_id;
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
    
    if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
        [SYObject startLoading];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,DETAIL_URL]];
        request_19=[ASIFormDataRequest requestWithURL:url];
        [request_19 setPostValue:sec.detail_id forKey:@"id"];
        [request_19 setPostValue:[NSString stringWithFormat:@"%@%@",stateNew,cityNew] forKey:@"cityName"];
        NSArray *arrObjc;
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:filePathDong];
        if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
            arrObjc = [[NSArray alloc]initWithObjects:@"", nil];
        }else{
            [request_19 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
            [request_19 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
            
            
            arrObjc = [[NSArray alloc]initWithObjects:[fileContent2 objectAtIndex:4], nil];
        }
        NSArray *arrKey = [[NSArray alloc]initWithObjects:VERIFY, nil];
        NSMutableDictionary *dicMy = [[NSMutableDictionary alloc]initWithObjects:arrObjc forKeys:arrKey];
        [request_19 setRequestHeaders:dicMy];
        request_19.tag = 101;
        request_19.delegate = self;
        [request_19 setDidFailSelector:@selector(init_urlRequestFailed:)];
        [request_19 setDidFinishSelector:@selector(init_urlRequestSucceeded:)];
        [request_19 startAsynchronous];
    }else{
        [SYObject startLoading];
        NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,DETAIL_URL]];
        request_20=[ASIFormDataRequest requestWithURL:url2];
        [request_20 setPostValue:sec.detail_id forKey:@"id"];
         [request_20 setPostValue:[NSString stringWithFormat:@"%@%@",stateNew,cityNew] forKey:@"cityName"];
        NSArray *arrObjc2;
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:filePathDong];
        if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
            arrObjc2 = [[NSArray alloc]initWithObjects:@"", nil];
        }else{
            [request_20 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
            [request_20 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
            
            arrObjc2 = [[NSArray alloc]initWithObjects:[fileContent2 objectAtIndex:4], nil];
        }
        NSArray *arrKey2 = [[NSArray alloc]initWithObjects:VERIFY, nil];
        NSMutableDictionary *dicMy2 = [[NSMutableDictionary alloc]initWithObjects:arrObjc2 forKeys:arrKey2];
        [request_20 setRequestHeaders:dicMy2];
        request_20.tag = 101;
        request_20.delegate =self;
        [request_20 setDidFailSelector:@selector(detailOn_urlRequestFailed:)];
        [request_20 setDidFinishSelector:@selector(detailOn_urlRequestSucceeded:)];
        [request_20 startAsynchronous];
        [SYObject startLoading];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,MEMBERPRICE_URL]];
        request_21=[ASIFormDataRequest requestWithURL:url];
        [request_21 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
        [request_21 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
        [request_21 setPostValue:sec.detail_id forKey:@"goods_id"];
        
        [request_21 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request_21.tag = 107;
        request_21.delegate = self;
        [request_21 setDidFailSelector:@selector(userlevel2_urlRequestFailed:)];
        [request_21 setDidFinishSelector:@selector(userlevel2_urlRequestSucceeded:)];
        [request_21 startAsynchronous];
    }


}

#pragma mark - 构造方法
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //[self createRootView];
        SecondViewController *sec = [SecondViewController sharedUserDefault];
        self.title = @"商品详情";
        self.detail_id = sec.detail_id;
        [self loadEvaluateView];
        self.view.backgroundColor = [UIColor whiteColor];
        
        if (UIDeviceHao>=7.0) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }else{
            
        }
        regionView = [[UIImageView alloc]init];
        if (ScreenFrame.size.height>480) {//说明是5 5s
            MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -1, ScreenFrame.size.width, ScreenFrame.size.height-44-60) style:UITableViewStylePlain];
            regionView.frame = CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height);
            RegoinTableView = [[UITableView alloc]initWithFrame:CGRectMake(36, 20+25+80,ScreenFrame.size.width-72, ScreenFrame.size.height-64-44-30-160) style:UITableViewStylePlain];
        }else{
            MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -1, ScreenFrame.size.width, ScreenFrame.size.height-44-60) style:UITableViewStylePlain];
            regionView.frame = CGRectMake(0,0, ScreenFrame.size.width, ScreenFrame.size.height);
            RegoinTableView = [[UITableView alloc]initWithFrame:CGRectMake(36, 20+25+80,ScreenFrame.size.width-72, ScreenFrame.size.height-64-44-30-160) style:UITableViewStylePlain];
        }
        MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MyTableView.delegate = self;
        MyTableView.dataSource=  self;
        MyTableView.showsVerticalScrollIndicator=NO;
        MyTableView.showsHorizontalScrollIndicator = NO;
        
        //@shiyuwudi,将tableView添加到scrollView中:
        UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-44)];
        _containerScrollView = sv;
        _containerScrollView.bounces = NO;
        [self.view addSubview:_containerScrollView];
        _containerScrollView.pagingEnabled = YES;
        _containerScrollView.showsVerticalScrollIndicator = NO;
        _containerScrollView.showsHorizontalScrollIndicator = YES;
        _containerScrollView.delegate = self;
        _containerScrollView.contentSize = CGSizeMake(ScreenFrame.size.width*3, ScreenFrame.size.height-44);
        [_containerScrollView addSubview:MyTableView];
        //详情、评价
        CGFloat tv2X = ScreenFrame.size.width*2;
        CGFloat tv2Y = ScreenFrame.size.height* 64.f/667.f;
        UITableView *tv2 = [[UITableView alloc]initWithFrame:CGRectMake(tv2X, tv2Y, ScreenFrame.size.width, ScreenFrame.size.height-tv2Y-64-44) style:UITableViewStyleGrouped];
        _evaluateTableView = tv2;
        _evaluateTableView.backgroundColor = BACKGROUNDCOLOR;
        _evaluateTableView.delegate = self;
        _evaluateTableView.dataSource = self;
        _evaluateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //导航栏内嵌视图
        CGFloat ww1 = ScreenFrame.size.width*0.5;
        UIView *headNaviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ww1,44)];
        
        UIScrollView *headNaviScrollView = [LJControl scrollViewFrame:headNaviView.frame contentSize:CGSizeMake(0, 88) showsVertical:NO showsHorizontal:NO paging:NO canScroll:NO];
        [headNaviScrollView addSubview:headNaviView];
        
        UILabel *headNaviView2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, ww1,44)];
        headNaviView2.text = @"图文详情";
        headNaviView2.textColor = [UIColor whiteColor];
        headNaviView2.textAlignment = NSTextAlignmentCenter;
        [headNaviScrollView addSubview:headNaviView2];
        self.headNaviScrollView = headNaviScrollView;
        self.headNaviView2 = headNaviView2;
        self.navigationItem.titleView = headNaviScrollView;
        headNaviView.userInteractionEnabled = YES;
        _headNaviView = headNaviView;
        
        UIButton *goodsHomePageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [goodsHomePageBtn setTitle:@"商品" forState:UIControlStateNormal];
        [goodsHomePageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [goodsHomePageBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
        _goodsHomePageBtn = goodsHomePageBtn;
        _goodsHomePageBtn.selected = YES;
        _currentBtn = _goodsHomePageBtn;
        
        UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [detailBtn setTitle:@"详情" forState:UIControlStateNormal];
        [detailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [detailBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
        _detailBtn = detailBtn;
        
        UIButton *evaluateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [evaluateBtn setTitle:@"评价" forState:UIControlStateNormal];
        [evaluateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [evaluateBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
        _evaluateBtn = evaluateBtn;

        UIFont *tFont = [UIFont systemFontOfSize:15.0];
        _goodsHomePageBtn.titleLabel.font = tFont;
        _detailBtn.titleLabel.font = tFont;
        _evaluateBtn.titleLabel.font = tFont;
        
        [goodsHomePageBtn addTarget:self action:@selector(naviButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [detailBtn addTarget:self action:@selector(naviButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [evaluateBtn addTarget:self action:@selector(naviButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        goodsHomePageBtn.frame = CGRectMake(0, 0, ww1 / 3, 44);
        detailBtn.frame = CGRectMake(ww1 /3, 0, ww1 / 3, 44);
        evaluateBtn.frame = CGRectMake(2 * ww1 / 3, 0, ww1 /3, 44);
        
        [headNaviView addSubview:goodsHomePageBtn];
        [headNaviView addSubview:detailBtn];
        [headNaviView addSubview:evaluateBtn];
        
        regionView.hidden = YES;
        regionView.userInteractionEnabled = YES;
        [self.view addSubview:regionView];
        
        myWebView=[[UIWebView alloc] initWithFrame:CGRectMake(0, MyTableView.frame.size.height+MyTableView.frame.origin.y, ScreenFrame.size.width, MyTableView.frame.size.height)];
        myWebView.backgroundColor = [UIColor whiteColor];
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
        NSURL *url32;
        if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
            url32=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%@&user_id=",FIRST_URL,DETAIL_URL2,sec.detail_id]];
        }else{
            url32=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%@&user_id=%@",FIRST_URL,DETAIL_URL2,sec.detail_id,[fileContent2 objectAtIndex:3]]];
        }
        NSURLRequest *requestweb=[[NSURLRequest alloc] initWithURL:url32];
        [myWebView loadRequest:requestweb];
        myWebView.delegate = self;
        [self.view addSubview:myWebView];
        
        myWebView1=[[UIWebView alloc] initWithFrame:CGRectMake(0, MyTableView.frame.size.height+MyTableView.frame.origin.y, ScreenFrame.size.width, MyTableView.frame.size.height)];
        myWebView1.backgroundColor = [UIColor whiteColor];
        [myWebView1 loadRequest:requestweb];
        myWebView1.delegate = self;
        myWebView1.frame = CGRectMake(ScreenFrame.size.width, 0, ScreenFrame.size.width, ScreenFrame.size.height-44);
        [_containerScrollView addSubview:myWebView1];
        [_containerScrollView addSubview:_evaluateTableView];
        
        _refreshHeaderView = [[EGORefreshTableHeaderView1 alloc] initWithFrame:CGRectMake(0, -myWebView.scrollView.bounds.size.height, myWebView.scrollView.frame.size.width, myWebView.scrollView.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        myWebView.scrollView.delegate = self;
        [myWebView.scrollView addSubview:_refreshHeaderView];
        [_refreshHeaderView refreshLastUpdatedDate];
        
        [self createBottomView];
        
        myViewBI = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height)];
        myViewBI.backgroundColor = [UIColor blackColor];
        myViewBI.hidden = YES;
        [self.view addSubview:myViewBI];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, myViewBI.frame.size.width, myViewBI.frame.size.height)];
        image.backgroundColor = [UIColor clearColor];
        image.userInteractionEnabled = YES;
        [myViewBI addSubview:image];
        
        FCodeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-64)];
        FCodeView.hidden = YES;
        [self.view addSubview:FCodeView];
        
        zuheView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-64)];
        zuheView.hidden = YES;
        [self.view addSubview:zuheView];
        
        NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,MAYLIKE_URL]];
        request_22=[ASIFormDataRequest requestWithURL:url2];
        [request_22 setPostValue:sec.detail_id forKey:@"id"];
        
        [request_22 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request_22.tag = 106;
        request_22.delegate =self;
        [request_22 setDidFailSelector:@selector(maylike_urlRequestFailed:)];
        [request_22 setDidFinishSelector:@selector(maylike_urlRequestSucceeded:)];
        [request_22 startAsynchronous];
        
//        //发起请求规格
//        
//        NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,SPECIFICATIONS_URL]];
//        request_23=[ASIFormDataRequest requestWithURL:url3];
//        [request_23 setPostValue:sec.detail_id forKey:@"id"];
//        
//        [request_23 setRequestHeaders:[LJControl requestHeaderDictionary]];
//        request_23.tag = 102;
//        request_23.delegate = self;
//        [request_23 setDidFailSelector:@selector(spec2_urlRequestFailed:)];
//        [request_23 setDidFinishSelector:@selector(spec2_urlRequestSucceeded:)];
//        [request_23 startAsynchronous];
        
        labelTi = [[UILabel alloc] initWithFrame:CGRectMake(50, ScreenFrame.size.height-100, ScreenFrame.size.width-100, 30)];
        CALayer *lay2  = labelTi.layer;
        [lay2 setMasksToBounds:YES];
        [lay2 setCornerRadius:4.0];
        labelTi.font = [UIFont systemFontOfSize:14];
        labelTi.backgroundColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
        labelTi.alpha = 1;
        labelTi.textColor = [UIColor whiteColor];
        labelTi.textAlignment = NSTextAlignmentCenter;
        labelTi.hidden = YES;
        [self.view addSubview:labelTi];
    }
    
    return self;
}
#pragma mark -规格信息
-(void)specificationInformation{
    _semiTransparentView=[LJControl viewFrame:CGRectMake(0,0,ScreenFrame.size.width, ScreenFrame.size.height) backgroundColor:[UIColor blackColor]];
    _semiTransparentView.alpha=0.6;
    [self.navigationController.view addSubview:_semiTransparentView];
    
    _specifView=[LJControl viewFrame:CGRectMake(0,  ScreenFrame.size.height-400, ScreenFrame.size.width,400) backgroundColor:[UIColor whiteColor]];
    [self.navigationController.view addSubview:_specifView];
    
    UIImageView *photoImageView=[LJControl imageViewFrame:CGRectMake(10,90-(ScreenFrame.size.width/2-30), ScreenFrame.size.width/2-30,ScreenFrame.size.width/2-30) setImage:@"" setbackgroundColor:[UIColor whiteColor]];
    photoImageView.tag=1000;
    photoImageView.layer.borderWidth = 1;
    photoImageView.layer.borderColor = [UIColorFromRGB(0Xd7d7d7) CGColor];
    [_specifView addSubview:photoImageView];
    
    UILabel *pricelabel=[LJControl labelFrame:CGRectMake(ScreenFrame.size.width/2-10, 5, ScreenFrame.size.width/2, 25) setText:@"  ￥--.--" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0Xef0000) textAlignment:NSTextAlignmentLeft];
    pricelabel.tag=1001;
    [_specifView addSubview:pricelabel];
    
    UILabel *stocklabel=[LJControl labelFrame:CGRectMake(ScreenFrame.size.width/2-10, 30, ScreenFrame.size.width/2, 25) setText:@"库存:----" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor blackColor]textAlignment:NSTextAlignmentLeft];
    stocklabel.tag=1002;
    [_specifView addSubview:stocklabel];
    
    UILabel *choicelabel=[LJControl labelFrame:CGRectMake(ScreenFrame.size.width/2-10, 55, ScreenFrame.size.width/2, 40) setText:@"已选:" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor blackColor]textAlignment:NSTextAlignmentLeft];
    choicelabel.numberOfLines=2;
    choicelabel.tag=1003;
    [_specifView addSubview:choicelabel];
    
    _specTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,100,ScreenFrame.size.width,200) style:UITableViewStyleGrouped];
    _specTableView.backgroundColor=[UIColor clearColor];
    _specTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _specTableView.delegate = self;
    _specTableView.dataSource=  self;
    _specTableView.showsVerticalScrollIndicator=NO;
    _specTableView.showsHorizontalScrollIndicator = NO;
    [_specifView addSubview:_specTableView];
    
    //底部轻松购视图、可输入数量(30,specifView.bounds.size.height-50,ScreenFrame.size.width-60,40)
    _BottomViewSpec = [[UIView alloc]initWithFrame:CGRectMake(0, _specifView.bounds.size.height-100, ScreenFrame.size.width, 100)];
    [_specifView addSubview:_BottomViewSpec];
   
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 26)];
    label.textColor = [UIColor darkGrayColor];
    label.text = @"购买数量:";
    label.font = [UIFont systemFontOfSize:15];
    [_BottomViewSpec addSubview:label];
    //数量框架
    UILabel *labelB = [[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-180, 10, 170, 26)];
    labelB.textColor = [UIColor darkGrayColor];
    labelB.text = @"";
    CALayer *lay = labelB.layer;
    [lay setMasksToBounds:YES];
    [lay setCornerRadius:5.0f];
    labelB.font = [UIFont systemFontOfSize:14];
    labelB.layer.borderWidth = 1;
    labelB.userInteractionEnabled = YES;
    labelB.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [_BottomViewSpec addSubview:labelB];
    labelB.backgroundColor = [UIColor whiteColor];
    _BottomViewSpec.backgroundColor = [UIColor whiteColor];
    //减号标签
    UILabel *labelMinus = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(labelB.frame), 9, 26, 26)];
    labelMinus.textColor = [UIColor darkGrayColor];
    labelMinus.text = @"－";
    labelMinus.font = [UIFont systemFontOfSize:18];
    labelMinus.textAlignment = NSTextAlignmentCenter;
    [_BottomViewSpec addSubview:labelMinus];
    //加减号附近的竖线
    UIImageView *imageShu1 = [[UIImageView alloc]initWithFrame:CGRectMake(26, 0, 1, 26)];
    imageShu1.backgroundColor = [UIColor lightGrayColor];
    [labelB addSubview:imageShu1];
    UIImageView *imageShu2 = [[UIImageView alloc]initWithFrame:CGRectMake(170-26, 0, 1, 26)];
    imageShu2.backgroundColor = [UIColor lightGrayColor];
    [labelB addSubview:imageShu2];
    //减号按钮
    UIButton *buttonMinus = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonMinus.frame =labelMinus.frame;
    [buttonMinus addTarget:self action:@selector(newbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    buttonMinus.titleLabel.font  = [UIFont systemFontOfSize:14];
    buttonMinus.tag = 103;
    [_BottomViewSpec addSubview:buttonMinus];
    //加号标签
    UILabel *labelPlus = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(labelB.frame)-26, 9, 26, 26)];
    labelPlus.textColor = [UIColor darkGrayColor];
    labelPlus.text = @"+";
    labelPlus.font = [UIFont systemFontOfSize:18];
    labelPlus.textAlignment = NSTextAlignmentCenter;
    [_BottomViewSpec addSubview:labelPlus];
    //加号按钮
    UIButton *buttonPlus = [UIButton buttonWithType:UIButtonTypeCustom ];
    buttonPlus.frame = labelPlus.frame;
    [buttonPlus addTarget:self action:@selector(newbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    buttonPlus.tag = 104;
    buttonPlus.titleLabel.font  = [UIFont systemFontOfSize:14];
    [_BottomViewSpec addSubview:buttonPlus];
    //购买数量输入框(text field)
    countField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(buttonMinus.frame), 10, CGRectGetMinX(buttonPlus.frame)-CGRectGetMaxX(buttonMinus.frame), labelB.frame.size.height)];
    countField.textAlignment = NSTextAlignmentCenter ;
    countField.text = @"1";
    if (_cartDictionary!=nil) {
        countField.text = [NSString stringWithFormat:@"%@",[_cartDictionary objectForKey:@"goods_count"]];
    }
//    countField.backgroundColor = [[UIColor blueColor]colorWithAlphaComponent:0.3];
    countField.font = [UIFont systemFontOfSize:15];
    countField.delegate = self;
    [_BottomViewSpec addSubview:countField];
    
    
    countField.keyboardType= UIKeyboardTypeNumberPad;
    UIView *cc=[LJControl viewFrame:CGRectMake(0, 0,ScreenFrame.size.width, 44) backgroundColor:UIColorFromRGB(0Xf2f2f2)];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 26)];
    label1.textColor = [UIColor darkGrayColor];
    label1.text = @"购买数量:";
    label1.font = [UIFont systemFontOfSize:15];
    [cc addSubview:label1];
    
    UILabel *labelB1 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-180, 10, 170, 26)];
    labelB1.textColor = [UIColor darkGrayColor];
    labelB1.text = @"";
    
    CALayer *lay1 = labelB1.layer;
    [lay1 setMasksToBounds:YES];
    [lay1 setCornerRadius:5.0f];
    labelB1.font = [UIFont systemFontOfSize:14];
    labelB1.layer.borderWidth = 1;
    labelB1.userInteractionEnabled = YES;
    labelB1.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//    [cc addSubview:labelB1];
    labelB1.backgroundColor = [UIColor whiteColor];
    
    UILabel *labelMinus1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(labelB1.frame), 9, 26, 26)];
    labelMinus1.textColor = [UIColor darkGrayColor];
    labelMinus1.text = @"－";
    labelMinus1.font = [UIFont systemFontOfSize:18];
    labelMinus1.textAlignment = NSTextAlignmentCenter;
//    [cc addSubview:labelMinus1];
    UIImageView *imageShu11 = [[UIImageView alloc]initWithFrame:CGRectMake(26, 0, 1, 26)];
    imageShu11.backgroundColor = [UIColor lightGrayColor];
//    [labelB1 addSubview:imageShu11];
    UIImageView *imageShu21 = [[UIImageView alloc]initWithFrame:CGRectMake(170-26, 0, 1, 26)];
    imageShu21.backgroundColor = [UIColor lightGrayColor];
//    [labelB1 addSubview:imageShu21];
    UIButton *buttonMinus1 = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonMinus1.frame =labelMinus.frame;
    [buttonMinus1 addTarget:self action:@selector(newbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    buttonMinus1.titleLabel.font  = [UIFont systemFontOfSize:14];
    buttonMinus1.tag = 103;
//    [cc addSubview:buttonMinus1];
    UILabel *labelPlus1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(labelB.frame)-26, 9, 26, 26)];
    labelPlus1.textColor = [UIColor darkGrayColor];
    labelPlus1.text = @"+";
    labelPlus1.font = [UIFont systemFontOfSize:18];
    labelPlus1.textAlignment = NSTextAlignmentCenter;
//    [cc addSubview:labelPlus1];
    UIButton *buttonPlus1 = [UIButton buttonWithType:UIButtonTypeCustom ];
    buttonPlus1.frame = labelPlus.frame;
    [buttonPlus1 addTarget:self action:@selector(newbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    buttonPlus1.tag = 104;
    buttonPlus1.titleLabel.font  = [UIFont systemFontOfSize:14];
//    [cc addSubview:buttonPlus1];
    
    countField1 = [[UITextField alloc]initWithFrame:CGRectMake(label1.right + 10 , 10, 120, labelB1.frame.size.height)];
    countField1.textAlignment = NSTextAlignmentCenter ;
    countField1.text=countField.text;
    countField1.font = [UIFont systemFontOfSize:15];
    countField1.keyboardType= UIKeyboardTypeNumberPad;
    countField1.delegate=self;
    countField1.backgroundColor = [UIColor whiteColor];
    
    CGFloat cw = 50;
    CGFloat ch = countField1.height;
    CGFloat cy = countField1.top;
    CGFloat cx = ScreenFrame.size.width - 10 - cw;
    
    UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(cx, cy, cw, ch)];
    [cc addSubview:confirmBtn];
    [confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(countField1Resign) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    CALayer *layC1 = countField1.layer;
    layC1.borderColor = [[UIColor lightGrayColor]CGColor];
    layC1.borderWidth = 1;
    layC1.cornerRadius = 5;
    [layC1 setMasksToBounds:YES];
    
    [cc addSubview:countField1];
    
    countField.inputAccessoryView=cc;
    [MyTableView reloadData];
    //右按钮
    
    btn2Qing = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2Qing.frame = CGRectMake(0.5*ScreenFrame.size.width, _BottomViewSpec.frame.size.height-44, _BottomViewSpec.frame.size.width*0.5, 44);
    btn2Qing.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [btn2Qing setTitle:@"立即购买" forState:UIControlStateNormal];
    btn2Qing.backgroundColor = MY_COLOR;
    btn2Qing.tag = 102;
    btn2Qing.layer.masksToBounds  = YES;
//    btn2Qing.backgroundColor = [UIColor orangeColor];
    btn2Qing.enabled = YES;
    btn2Qing.titleLabel.textColor = [UIColor whiteColor];
    [btn2Qing addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_BottomViewSpec addSubview:btn2Qing];
    
    
    //左按钮
    button2add = [UIButton buttonWithType:UIButtonTypeCustom ];
    button2add.frame =CGRectMake(0,_BottomViewSpec.frame.size.height-44, 0.5*ScreenFrame.size.width, 44);
    [button2add setTitle:@"加入购物车" forState:UIControlStateNormal];
    [button2add addTarget:self action:@selector(newbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    button2add.tag = 106;
    button2add.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    button2add.layer.masksToBounds  = YES;
//    
    button2add.backgroundColor = [UIColor orangeColor];
    
    ClassifyModel *classify = [dataArray firstObject];
    NSString *statu = classify.detail_goodsstatus_info;
    BOOL preOrder = [statu hasPrefix:@"预售商品"];
    //如果是预售商品，不让加入购物车.
    if (!preOrder) {
        [_BottomViewSpec addSubview:button2add];
        [btn2Qing setTitle:@"立即购买" forState:UIControlStateNormal];
    }else {
        [btn2Qing setTitle:@"立即付定金" forState:UIControlStateNormal];
        btn2Qing.frame = CGRectMake(0, _BottomViewSpec.frame.size.height-44, _BottomViewSpec.frame.size.width, 44);
    }
    
    

//    ClassifyModel *class = [dataArray objectAtIndex:0];
//    if ([class.detail_goods_inventory intValue]>0) {
//            btn2Qing.backgroundColor = MY_COLOR;
//         button2add.backgroundColor = [UIColor orangeColor];
//    }else{
//        btn2Qing.enabled = NO;
//        btn2Qing.backgroundColor = [UIColor lightGrayColor];
//        button2add.enabled = NO;
//        button2add.backgroundColor = [UIColor lightGrayColor];
//    }

    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
    [_semiTransparentView addGestureRecognizer:tap];
    
    _semiTransparentView.hidden=YES;
    _specifView.hidden=YES;
}
-(void)countField1Resign {
    NSString *str = countField1.text;
    [countField endEditing:YES];
    countField.text = str;
}
-(void)tapClick:(UITapGestureRecognizer *)tap{
    //隐藏属性
    [countField1 resignFirstResponder];
    [countField resignFirstResponder];
    [SYObject endLoading];
    _semiTransparentView.hidden=YES;
    _specifView.hidden=YES;
    [MyTableView reloadData];
}


#pragma mark - 导航栏按钮被点击
-(IBAction)naviButtonClicked:(id)sender{
    UIButton *btn = sender;
    
    self.currentBtn.selected = NO;
    self.currentBtn = btn;
    self.currentBtn.selected = YES;
    NSString *title = btn.currentTitle;
    //按钮被点击需要做两个动作：按钮白条到相应位置；底部tableView跟着切换
    if ([title isEqualToString:@"商品"]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.whiteView.transform = CGAffineTransformIdentity;
            self.containerScrollView.contentOffset = CGPointMake(0, 0);
        }];
    }else if ([title isEqualToString:@"详情"]){
        [UIView animateWithDuration:0.3 animations:^{
            self.whiteView.transform = CGAffineTransformMakeTranslation(0.5 * (self.headNaviView.frame.size.width-self.goodsHomePageBtn.frame.size.width),0);
            self.containerScrollView.contentOffset = CGPointMake(ScreenFrame.size.width, 0);
        }];
    }else if ([title isEqualToString:@"评价"]){
        [self loadEvaluateView];
        [UIView animateWithDuration:0.3 animations:^{
            self.whiteView.transform = CGAffineTransformMakeTranslation(1.0 * (self.headNaviView.frame.size.width-self.goodsHomePageBtn.frame.size.width),0);
            self.containerScrollView.contentOffset = CGPointMake(ScreenFrame.size.width*2, 0);
        }];
    }
}

#pragma mark - tabelView数据源方法
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==_evaluateTableView) {
        return 1.f;
    }
    if (tableView==_specTableView) {
        return 20;
    }
    return 1.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView==_evaluateTableView) {
        return 1.f;
    }
    return 1.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView==_specTableView){
        UIView *view=[LJControl viewFrame:CGRectMake(0, 0,ScreenFrame.size.width, 30) backgroundColor:[UIColor clearColor]];
        UILabel *l=[LJControl labelFrame:CGRectMake(0,0, ScreenFrame.size.width, 1) setText:@"" setTitleFont:0 setbackgroundColor:UIColorFromRGB(0xcecece) setTextColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        [view addSubview:l];
        NSDictionary *dic=[_specArray objectAtIndex:section];
        UILabel *label=[LJControl labelFrame:CGRectMake(10,2,ScreenFrame.size.width-10,28) setText:[dic objectForKey:@"spec_key"] setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        [view addSubview:label];
        return view;
    }
    return nil;
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView==_specTableView) {
        return _specArray.count;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _evaluateTableView) {
        return [_detailCellView evaCellHeightByModel:self.evaluateArray[indexPath.row]];
    }
    if (tableView == MyTableView) {
        if (indexPath.row == 0) {
            if (dataArray.count!=0) {
                ClassifyModel *class = [dataArray objectAtIndex:0];
                NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:17]};
                CGRect requiredSize = [class.detail_goods_name boundingRectWithSize:CGSizeMake(ScreenFrame.size.width-20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
                return ScreenFrame.size.width+10+requiredSize.size.height+20+35;
            }
            return 0;
        }
        if (indexPath.row == 1) {
            if (dataArray.count!=0) {
                ClassifyModel *class = [dataArray objectAtIndex:0];
                if (class.detail_status.length == 0) {
                    return 0;
                }
                return 55;
            }
            return 0;
        }
        if (indexPath.row == 2) {
            return 55;
        }
        if (indexPath.row == 3) {
            if (dataArray.count!=0) {
                ClassifyModel *class = [dataArray objectAtIndex:0];
                if ([class.detail_choice_type integerValue]==1) {
                    return 0;
                }
                return 110;
            }
            return 0;
            
        }
        if (indexPath.row == 4) {
            return 55+10;
        }
        if (indexPath.row == 5) {
            if (self.evaluateArray.count>0) {
                return 80;
            }
            return 0;
        }
        if (indexPath.row == 6) {
            if (self.evaluateArray.count>1) {
                return 80;
            }
            return 0;
        }
        if (indexPath.row == 7) {
            if (self.evaluateArray.count>2) {
                return 80;
            }
            return 0;
        }
        if (indexPath.row == 8) {
            return 50;
        }
        if (indexPath.row == 9) {
            if (dataArray.count!=0) {
                ClassifyModel *class = [dataArray objectAtIndex:0];
                if ([class.detail_goods_type integerValue]==1) {
                    return 170;
                }
                return 0;
            }
            return 0;
        }
        if (indexPath.row == 10) {
            if (dataArray.count!=0) {
                ClassifyModel *class = [dataArray objectAtIndex:0];
                if ([class.detail_goods_type integerValue]==1) {
                    return 50;
                }
                return 0;
            }
            return 0;
        }
        if (indexPath.row == 11){
            return 60;
        }
    }
    if (tableView == RegoinTableView) {
        return 40;
    }
    if (tableView == zuheTableView){
        return 84;
    }
    if (tableView == zuhepeijianTableView){
        return 94;
    }
    if (tableView == _specTableView) {
        NSDictionary *dict=[_specArray objectAtIndex:indexPath.section];
        NSArray *array=[dict objectForKey:@"spec_values"];
        if([[dict objectForKey:@"spec_type"]isEqualToString:@"text"]||[[dict objectForKey:@"spec_type"]isEqualToString:@"img"]){
            //规格是文字
            CGFloat lastW = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
            CGFloat lasth = array.count>0?65:20;//用来控制button距离父视图的高
            for (int i=0; i<array.count; i++) {
                NSDictionary *diction=[array objectAtIndex:i];
                NSString *val=[diction objectForKey:@"val"];
                
                CGFloat WIDTH=ScreenFrame.size.width-20;
                CGRect rect=[val boundingRectWithSize:CGSizeMake(WIDTH, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
                CGFloat minLeng=WIDTH/4-5;
                CGFloat length =rect.size.width>minLeng?rect.size.width+20:minLeng;
                NSLog(@"%.2f",length);
                CGFloat x=10 + lastW;
                CGFloat w=length;
                CGFloat h=45;
                if(10 + lastW + length + 15 >=WIDTH){
                    lastW = 0; //换行时将w置为0
                    x=10 + lastW;
                    lasth = lasth + h + 10;//距离父视图也变化
                }
                 lastW = w + x;
            }
            return lasth;
        }else if ([[dict objectForKey:@"spec_type"]isEqualToString:@"img"]){
            //规格是是图片
        }
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _evaluateTableView) {
        return self.evaluateArray.count;
    }
    if (tableView == MyTableView) {
        return 12;
    }
    if (tableView==_specTableView) {
        return 1;
    }
    if (tableView == RegoinTableView) {
        if (regionArray.count != 0) {
            return regionArray.count;
        }
    }
    if (tableView == zuheTableView) {
        if (zuheArray.count!=0) {
            return zuheArray.count;
        }
    }
    if (tableView == zuhepeijianTableView) {
        if (zuhePeijianArray.count!=0) {
            return zuhePeijianArray.count;
        }
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _evaluateTableView) {
        if (dataArray.count!=0) {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            EvaModel *model = self.evaluateArray[indexPath.row];
            UIView *cellView = [self.detailCellView evaCellViewWithEvaModel:model cellIndex:indexPath.row];
            [cell addSubview:cellView];
            return cell;
        }
        else{
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            return cell;
        }
    }
    if (tableView == MyTableView) {
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
        if (dataArray.count!=0) {
            ClassifyModel *classify = [dataArray objectAtIndex:0];
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
                _myScrollView2 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.width)];
                _myScrollView2.tag = 102;
                _myScrollView2.bounces = YES;
                _myScrollView2.delegate = self;
                _myScrollView2.pagingEnabled = YES;
                _myScrollView2.userInteractionEnabled = YES;
                _myScrollView2.showsHorizontalScrollIndicator = NO;
                _myScrollView2.contentSize=CGSizeMake(ScreenFrame.size.width*arrImage.count,ScreenFrame.size.width);
                [cell addSubview:_myScrollView2];
                
                for(int i=0;i<arrImage.count;i++){
                    UIImageView *imageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width*i, 0, ScreenFrame.size.width, ScreenFrame.size.width)];
                    [imageVIew sd_setImageWithURL: [NSURL URLWithString:[arrImage objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
                    [_myScrollView2 addSubview:imageVIew];
                }
                pagelabel=[LJControl labelFrame:CGRectMake(ScreenFrame.size.width-60, ScreenFrame.size.width-60, 50, 50) setText:[NSString stringWithFormat:@"1/%ld",(long)arrImage.count] setTitleFont:16 setbackgroundColor:UIColorFromRGB(0X808A87) setTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
                pagelabel.alpha=0.8;
                pagelabel.layer.cornerRadius = 25;
                pagelabel.layer.masksToBounds = YES;
                [cell addSubview:pagelabel];
                
                UILabel *ll=[LJControl labelFrame:CGRectMake(10, ScreenFrame.size.width, ScreenFrame.size.width-10, 1) setText:@"" setTitleFont:0 setbackgroundColor:UIColorFromRGB(0XF2F2F2) setTextColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
                [cell addSubview:ll];
                
                UILabel *labelPrice222 = [[UILabel alloc]initWithFrame:CGRectMake(10, ScreenFrame.size.width+10, ScreenFrame.size.width-20, 46)];
                labelPrice222.font = [UIFont systemFontOfSize:15];
                labelPrice222.text = classify.detail_goods_name;
                [cell addSubview:labelPrice222];
                labelPrice222.numberOfLines = 0;
                NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:17]};
                CGRect requiredSize = [classify.detail_goods_name boundingRectWithSize:CGSizeMake(ScreenFrame.size.width-20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
                labelPrice222.frame = CGRectMake(10, ScreenFrame.size.width+10, ScreenFrame.size.width-20, requiredSize.size.height+10);
                //是自营还是第三方 标示
                if([classify.detail_goods_type intValue] == 1){//不是商城的
                   
                }else{
                    UILabel *labelRed = [[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-60, ScreenFrame.size.width+10+requiredSize.size.height+22, 40, 20)];
                    labelRed.numberOfLines = 2;
                    labelRed.backgroundColor = [UIColor redColor];
                    labelRed.font = [UIFont boldSystemFontOfSize:15];
                    labelRed.text = @"自营";
                    labelRed.textAlignment = NSTextAlignmentCenter;
                    labelRed.textColor=[UIColor whiteColor];
                    [labelRed.layer setMasksToBounds:YES];
                    [labelRed.layer setCornerRadius:2.0];
                    [cell addSubview:labelRed];
                }
                
             
                //价钱
                UILabel *money = [[UILabel alloc]initWithFrame:CGRectMake(10, ScreenFrame.size.width+10+requiredSize.size.height+20, 20, 24)];
                money.text = @"￥";
                money.textColor = SY_PRICE_COLOR;
                money.font = [UIFont boldSystemFontOfSize:15];
                [cell addSubview:money];
                
                NSString *text = [NSString stringWithFormat:@"%0.2f",[classify.detail_goods_current_price floatValue]];
                CGFloat priceW = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:24]}].width;
                UILabel *labelcurrent_price = [[UILabel alloc]initWithFrame:CGRectMake(32, ScreenFrame.size.width+10+requiredSize.size.height+20, priceW, 20)];
                labelcurrent_price.font = [UIFont boldSystemFontOfSize:20];
                labelcurrent_price.text = [NSString stringWithFormat:@"%0.2f",[classify.detail_goods_current_price floatValue]];
                labelcurrent_price.textColor = SY_PRICE_COLOR;
                [cell addSubview:labelcurrent_price];
               
            
                NSString *statu = classify.detail_goodsstatus_info;
                BOOL preOrder = [statu hasPrefix:@"预售商品"];
                //如果是预售商品，不让加入购物车.
                if (!preOrder) {
                    
                }else {
                    //预售商品
                    NSString *text = [NSString stringWithFormat:@"%0.2f",[classify.detail_advance_ding floatValue]];
                    CGFloat priceW = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:24]}].width;
                    labelcurrent_price.frame=CGRectMake(32, ScreenFrame.size.width+10+requiredSize.size.height+20, priceW, 20);
                   
                    labelcurrent_price.text = [NSString stringWithFormat:@"%0.2f",classify.detail_advance_ding.floatValue];
                    
                }
               
                
                //限购
                NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *documentsPath = [docPath objectAtIndex:0];
                NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
                NSFileManager *fileManagerDong = [NSFileManager defaultManager];
                if([fileManagerDong fileExistsAtPath:filePathDong] == NO){
                }else{
                    if ([classify.detail_goods_limit integerValue]==0) {
                    }else{
                        
                        CGFloat limitLabelX = labelcurrent_price.right;
                        int lim = classify.detail_goods_all_count.intValue;
                        int bal = classify.detail_goods_buy_count.intValue;
                        int buyed = lim - bal;
                        UILabel *limitLabel = [LJControl labelFrame:CGRectMake(limitLabelX, labelcurrent_price.top + 5, ScreenFrame.size.width - limitLabelX, 10) setText:[NSString stringWithFormat:@"(限购%@件,已购%d件)",classify.detail_goods_all_count,buyed] setTitleFont:15 setbackgroundColor:nil setTextColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentLeft ];
                        [cell addSubview:limitLabel];
                    }
                }
                
                return cell;
            }
            if (indexPath.row == 1) {
               
                if (classify.detail_status.length == 0) {
                }else{
                    GoodsDetailCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsDetailCell1"];
                    if(cell == nil){
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsDetailCell1" owner:self options:nil] lastObject];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                    }
                    NSString *statu = classify.detail_goodsstatus_info;
                    BOOL preOrder = [statu hasPrefix:@"预售商品"];
                    if (preOrder)
                    {
                        cell.arrow.hidden=NO;
                        
                    }else
                    {
                     cell.arrow.hidden=YES;
                    
                    }
                    cell.activityNameLabel.text=[NSString stringWithFormat:@"%@",classify.detail_status];
                    if ([classify.detail_status isEqualToString:@"促销"]) {
                        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                        NSString *documentsPath = [docPath objectAtIndex:0];
                        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
                        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
                        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
                            cell.activityNameInfo.text = [NSString stringWithFormat:@"当前商品为促销商品，用户登录后方可享受促销价格！"];
                        }else{
                            if ([userLeve isEqualToString:@""]) {
                                cell.activityNameInfo.text = [NSString stringWithFormat:@"您当前为普通用户,享受商城价格%0.2f折的优惠",act_rate];
                            }else{
                                cell.activityNameInfo.text = [NSString stringWithFormat:@"您当前为%@,享受商城价格%0.2f折的优惠",userLeve,act_rate];
                            }
                            
                        }

                    }else if([classify.detail_status isEqualToString:@"组合"]){
                            cell.activityNameInfo.text = @"点击查看组合套装的完整信息";
//                            cell.activityNameInfo.font=[UIFont systemFontOfSize:17];
                           cell.arrow.hidden=NO;
                    
                    }else if([classify.detail_status isEqualToString:@"满减"]){
                        cell.activityNameInfo.text =[NSString stringWithFormat:@"%@", classify.detail_goodsstatus_info];
//                        cell.activityNameInfo.font=[UIFont systemFontOfSize:17];
                        
                    }else{
                        cell.activityNameInfo.text =[NSString stringWithFormat:@"%@", classify.detail_goodsstatus_info];
                    
                    }
                    return cell;
                }
            }
            if (indexPath.row == 2) {
                GoodsDetailCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsDetailCell3"];
                if(cell == nil){
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsDetailCell3" owner:self options:nil] lastObject];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else{
                }
                UILabel *choicelabel=(UILabel *)[_specifView viewWithTag:1003];
                if (_cartDictionary==nil) {
                    if (specSelectArray.count!=0) {
                        NSString *str;
                        for(int i=0;i<specSelectArray.count;i++){
                            if (str.length == 0) {
                                str = [NSString stringWithFormat:@"%@",[[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:1]];
                            }else{
                                str = [NSString stringWithFormat:@"%@ %@",str,[NSString stringWithFormat:@"%@",[[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:1]]];
                            }
                        }
                        cell.specificationsLabel.text = [NSString stringWithFormat:@"%@ %@件",str,countField.text];
                        choicelabel.text=[NSString stringWithFormat:@"已选:%@ %@件",str,countField.text];
                    }else{
                        cell.specificationsLabel.text = [NSString stringWithFormat:@"%@件",countField.text];
                        choicelabel.text = [NSString stringWithFormat:@"已选:%@件",countField.text];

                    }

                }else{
                    NSString *str=[NSString stringWithFormat:@"%@",[_cartDictionary objectForKey:@"goods_spec"]];
                    if (str.length>0) {
                        NSArray *array=[str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" ："]];
                        NSMutableArray *mArray=[[NSMutableArray alloc]init];
                        for (int i=0; i<array.count; i++) {
                            if (i%2==1) {
                                NSString *string=[NSString stringWithFormat:@"\"%@\"",[array objectAtIndex:i]];
                                [mArray addObject:string];
                            }
                        }
                        cell.specificationsLabel.text=[NSString stringWithFormat:@"%@ %@件",[mArray componentsJoinedByString:@","],countField.text];
                        choicelabel.text=[NSString stringWithFormat:@"已选:%@ %@件",[mArray componentsJoinedByString:@","],countField.text];
                    }else{
                        cell.specificationsLabel.text = [NSString stringWithFormat:@"%@件",countField.text];
                        choicelabel.text = [NSString stringWithFormat:@"已选:%@件",countField.text];
                    }
                }
                return cell;
            }
            if (indexPath.row == 3) {
                if ([classify.detail_choice_type integerValue]==1) {
                }else{
                    GoodsDetailCell4 *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsDetailCell4"];
                    if(cell == nil){
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsDetailCell4" owner:self options:nil] lastObject];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                    }
                    cell.areaSelectionButton.tag = 3;
                    [cell.areaSelectionButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
                    if (regionStr.length>0) {
                        cell.areaSelectionString=[NSString stringWithFormat:@"%@",regionStr];
                        cell.areaSelectionLabel.text=[NSString stringWithFormat:@"%@",regionStr];
                    }
 //                   else{
//                        if (classify.detail_current_city.length>0) {
//                            cell.areaSelectionString=[NSString stringWithFormat:@"%@",classify.detail_current_city];
//                            cell.areaSelectionLabel.text=[NSString stringWithFormat:@"%@",classify.detail_current_city];
//                        }else
//                        {
//                            cell.areaSelectionString=@"区域未知";
//                            cell.areaSelectionLabel.text=@"区域未知";
//                        
//                        
//                        }
//                       
//                    }
                    else{
                        
                        if (stateNew.length>0) {
                            cell.areaSelectionString=[NSString stringWithFormat:@"%@>%@>%@",stateNew,cityNew,subCityNew];
                            cell.areaSelectionLabel.text=[NSString stringWithFormat:@"%@>%@>%@",stateNew,cityNew,subCityNew];
                        }else
                        {
                            cell.areaSelectionString=@"区域未知";
                            cell.areaSelectionLabel.text=@"区域未知";
                        
                        }
                        
                    }
                    
                    if ([classify.detail_goods_inventory intValue]>0) {
                        cell.cargoVolumeLabel.text = [NSString stringWithFormat:@"现货"];
                    }else {
                        cell.cargoVolumeLabel.text = [NSString stringWithFormat:@"缺货"];
                    }
                    if (feetext.length>0) {
                        cell.postageLabel.text=[NSString stringWithFormat:@"%@",feetext];
                    }else{
                        cell.postageLabel.text=[NSString stringWithFormat:@"%@",classify.detail_trans_information];
                    }
                    return cell;
                }
            }
            if (indexPath.row == 4) {
                GoodsDetailCell5 *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsDetailCell5"];
                if(cell == nil){
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsDetailCell5" owner:self options:nil] lastObject];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else{
                }
                cell.highPraiseLabel.text=[NSString stringWithFormat:@"%@人评价",classify.detail_evaluate_count];
                cell.highLabel.text=[NSString stringWithFormat:@"%@",classify.detail_goods_well_evaluate];
                return cell;
            }
            if (indexPath.row == 5) {
                if (self.evaluateArray.count>0) {
                    GoodsDetailCell6 *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsDetailCell6"];
                    if(cell == nil){
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsDetailCell6" owner:self options:nil] lastObject];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                    }
                    EvaModel *model = self.evaluateArray[indexPath.row-5];
                    [cell.userImgView sd_setImageWithURL:[NSURL URLWithString:model.user_img] placeholderImage:[UIImage imageNamed: @"kong" ]];
                    if (model.user.length>0) {
                       cell.userName.text=[NSString stringWithFormat:@"%@",model.user];
                    }else
                    {
                       cell.userName.text=@"未知";
                    }
                   
                    cell.addTime.text=[NSString stringWithFormat:@"%@",model.addTime];
                    if (model.content.length>0) {
                      cell.contentLabel.text=[NSString stringWithFormat:@"%@",model.content];
                    }else
                    {
                     cell.contentLabel.text=@"这个人很懒,什么评论也没留下";
                    }
                   
                    return cell;
                }else{
                }
            }
            if (indexPath.row == 6) {
                if (self.evaluateArray.count>1) {
                    GoodsDetailCell6 *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsDetailCell6"];
                    if(cell == nil){
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsDetailCell6" owner:self options:nil] lastObject];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                    }
                    EvaModel *model = self.evaluateArray[indexPath.row-5];
                    [cell.userImgView sd_setImageWithURL:[NSURL URLWithString:model.user_img] placeholderImage:[UIImage imageNamed: @"kong" ]];
                    
                    if (model.user.length>0) {
                        cell.userName.text=[NSString stringWithFormat:@"%@",model.user];
                    }else
                    {
                        cell.userName.text=@"未知";
                    }

                    cell.addTime.text=[NSString stringWithFormat:@"%@",model.addTime];
                    if (model.content.length>0) {
                        cell.contentLabel.text=[NSString stringWithFormat:@"%@",model.content];
                    }else
                    {
                        cell.contentLabel.text=@"这个人很懒,什么评论也没留下";
                    }
                    
                    return cell;
                    
                }else{
                    
                }

            }
            if (indexPath.row == 7) {
                if (self.evaluateArray.count>2) {
                    GoodsDetailCell6 *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsDetailCell6"];
                    if(cell == nil){
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsDetailCell6" owner:self options:nil] lastObject];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                    }
                    EvaModel *model = self.evaluateArray[indexPath.row-5];
                    [cell.userImgView sd_setImageWithURL:[NSURL URLWithString:model.user_img] placeholderImage:[UIImage imageNamed: @"kong" ]];
                    if (model.user.length>0) {
                        cell.userName.text=[NSString stringWithFormat:@"%@",model.user];
                    }else
                    {
                        cell.userName.text=@"未知";
                    }

                    cell.addTime.text=[NSString stringWithFormat:@"%@",model.addTime];
                    if (model.content.length>0) {
                        cell.contentLabel.text=[NSString stringWithFormat:@"%@",model.content];
                    }else
                    {
                        cell.contentLabel.text=@"这个人很懒,什么评论也没留下";
                    }
                    
                    return cell;
                    
                }else{
                }
            }
            if (indexPath.row == 8) {
                GoodsDetailCell7 *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsDetailCell7"];
                if(cell == nil){
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsDetailCell7" owner:self options:nil] lastObject];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else{
                }
                cell.liftStr=@"更多评价";
                cell.rightStr=[NSString stringWithFormat:@"购买咨询(%@)",classify.detail_consult_count];
                cell.liftbutton.tag=100;
                [cell.liftbutton addTarget:self action:@selector(goodsDetailCellClicked:) forControlEvents:UIControlEventTouchUpInside];
                cell.rightbutton.tag=101;
                [cell.rightbutton addTarget:self action:@selector(goodsDetailCellClicked:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
            if (indexPath.row == 9) {
                if([classify.detail_goods_type intValue] == 1){//不是商城的
                    GoodsDetailCell8 *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsDetailCell8"];
                    if(cell == nil){
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsDetailCell8" owner:self options:nil] lastObject];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                    }
                    
                    cell.storeInfoDictionary=[[NSDictionary alloc]initWithDictionary:classify.detail_store_info];
                    return cell;
                }else{
                }
            }
            if (indexPath.row == 10) {
                if([classify.detail_goods_type intValue] == 1){//不是商城的
                    GoodsDetailCell7 *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsDetailCell7"];
                    if(cell == nil){
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsDetailCell7" owner:self options:nil] lastObject];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                    }
                    cell.lineLabel.hidden=YES;
                    cell.liftStr=@"联系客服";
                    cell.rightStr=@"进店逛逛";
                    cell.liftbutton.tag=102;
                    [cell.liftbutton addTarget:self action:@selector(chat) forControlEvents:UIControlEventTouchUpInside];
                    cell.rightbutton.tag=103;
                    [cell.rightbutton addTarget:self action:@selector(goodsDetailCellClicked:) forControlEvents:UIControlEventTouchUpInside];
                    return cell;
                }else{
                }
            }
            if (indexPath.row == 11) {
                cell.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];

                CGFloat space = 10;
                UIView *line = [UIView new];
                line.backgroundColor = [UIColor lightGrayColor];
                line.frame = CGRectMake(space, 30, ScreenFrame.size.width - 2 * space, 1);
                [cell addSubview:line];
                
                UILabel *label = [[UILabel alloc]init];
                label.backgroundColor = cell.backgroundColor;
                label.text = @"上拉查看图文详情          ";
                label.font = [UIFont systemFontOfSize:13];
                CGFloat labelW = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}].width;
                label.frame = CGRectMake((ScreenFrame.size.width - labelW) * 0.5, 0, labelW, 60);
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor darkGrayColor];
                [cell addSubview:label];
            }
        }
        return cell;
    }
    if (tableView == RegoinTableView) {
        static NSString *myTabelviewCell = @"RegionCell";
        RegionCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RegionCell" owner:self options:nil] lastObject];
        }
        if (indexPath.row == selectRegionIndex) {
            cell.yesImage.image = [UIImage imageNamed:@"checkbox_yes.png"];
        }else{
            cell.yesImage.image = [UIImage imageNamed:@"checkbox_no"];
        }
        if (regionArray.count!=0) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, tableView.frame.size.width-20, 0.5)];
            imageView.backgroundColor = [UIColor lightGrayColor];
            [cell addSubview:imageView];
            ClassifyModel *classify = [regionArray objectAtIndex:indexPath.row];
            cell.regionLabel.text = classify.region_name;
        }
        return cell;
    }
    if(tableView==_specTableView){
        NilCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NilCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor whiteColor];
        }else{
            for (UIView *subView in cell.contentView.subviews)
            {
                [subView removeFromSuperview];
            }
        }
        NSArray *spdIds=[[NSMutableArray alloc]initWithArray:[_specIdsString componentsSeparatedByString:@","]];
        NSDictionary *dict=[_specArray objectAtIndex:indexPath.section];
        NSArray *array=[dict objectForKey:@"spec_values"];
       
        if([[dict objectForKey:@"spec_type"]isEqualToString:@"text"]||[[dict objectForKey:@"spec_type"]isEqualToString:@"img"]){
            //规格是文字
            CGFloat lastW = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
            CGFloat lasth = 10;//用来控制button距离父视图的高
            for (int i=0; i<array.count; i++) {
                NSDictionary *diction=[array objectAtIndex:i];
                NSString *val=[diction objectForKey:@"val"];
                
                CGFloat WIDTH=ScreenFrame.size.width-20;
                CGRect rect=[val boundingRectWithSize:CGSizeMake(WIDTH, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
                CGFloat minLeng=WIDTH/4-5;
                CGFloat length =rect.size.width>minLeng?rect.size.width+20:minLeng;
                length=length>WIDTH?WIDTH:length;
//                NSLog(@"%d~~~%.2f",i,length);
                
                CGFloat x=10 + lastW;
                CGFloat y=lasth;
                CGFloat w=length;
                CGFloat h=45;
            
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(x, y, w, h);
                button.tag=indexPath.section *1000+i;
                button.backgroundColor = [UIColor clearColor];//[UIColor clearColor]
                [button addTarget:self action:@selector(spcClick:) forControlEvents:UIControlEventTouchUpInside];
                
                UILabel *label=[LJControl labelFrame:CGRectMake(0, 5, w, 35) setText:val setTitleFont:13 setbackgroundColor:[UIColor whiteColor] setTextColor:UIColorFromRGB(0X686868) textAlignment:NSTextAlignmentCenter];
                label.numberOfLines=2;
                label.tag=indexPath.section *1000+i;
                [label.layer  setCornerRadius:6.0];
                [label.layer setMasksToBounds:YES];
                label.layer.borderColor = [UIColorFromRGB(0Xdfdfdf) CGColor];
                label.layer.borderWidth =0.5;
                
                [button addSubview:label];
                
                if(10 + lastW + length + 15 >WIDTH){
                    lastW = 0; //换行时将w置为0
                    x=10 + lastW;
                    lasth = lasth + h + 10;//距离父视图也变化
                    button.frame = CGRectMake(x, lasth,w, h);//重设button的frame
                }
                
                lastW = w + x;
                [cell.contentView addSubview:button];
                if(_specIdsArray.count>0){
                    if ([[_specIdsArray objectAtIndex:indexPath.section]intValue]==[[diction objectForKey:@"id"]intValue]) {
                        button.selected=YES;
                        label.textColor=[UIColor whiteColor];
                        label.backgroundColor=UIColorFromRGB(0Xef0000);
                        label.layer.borderColor = [UIColorFromRGB(0Xef0000) CGColor];
                    }else if([[_specIdsArray objectAtIndex:indexPath.section]isEqualToString:@""]){
                        for (NSString *ids in spdIds) {
                            if ([ids intValue]==[[diction objectForKey:@"id"]intValue]) {
                                button.selected=YES;
                                label.textColor=[UIColor whiteColor];
                                label.backgroundColor=UIColorFromRGB(0Xef0000);
                                label.layer.borderColor = [UIColorFromRGB(0Xef0000) CGColor];
                            }
                        }
                    }
                }else{
                    for (NSString *ids in spdIds) {
                        if ([ids intValue]==[[diction objectForKey:@"id"]intValue]) {
                            button.selected=YES;
                            label.textColor=[UIColor whiteColor];
                            label.backgroundColor=UIColorFromRGB(0Xef0000);
                            label.layer.borderColor = [UIColorFromRGB(0Xef0000) CGColor];
                        }
                    }
                }
            }
            return cell;

        }else if ([[dict objectForKey:@"spec_type"]isEqualToString:@"img"]){
           //规格是是图片
        }

    }
    if (tableView == zuheTableView){
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
        if (zuheArray.count!=0) {
            
            NSArray *arr = (NSArray *)[[zuheArray objectAtIndex:indexPath.row] objectForKey:@"goods_list"];
            
            UIScrollView *ScrollView2 = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 10, zuheTableView.frame.size.width-20, 70)];
            ScrollView2.bounces = YES;
            ScrollView2.delegate = self;
            ScrollView2.userInteractionEnabled = YES;
            ScrollView2.showsHorizontalScrollIndicator = NO;
            ScrollView2.contentSize=CGSizeMake(arr.count*80+100,70);
            [cell addSubview:ScrollView2];
            
            UIView *labelLL = [[UIView alloc]initWithFrame:CGRectMake(0, 80, zuheTableView.frame.size.width, 0.5)];
            labelLL.backgroundColor = [UIColor grayColor];
            [cell addSubview:labelLL];
            
            for(int j=0;j<arr.count;j++){
                UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(20+j*60, 2, 40, 40)];
                [image sd_setImageWithURL:[NSURL URLWithString:[[[[zuheArray objectAtIndex:indexPath.row] objectForKey:@"goods_list"] objectAtIndex:j] objectForKey:@"goods_img"]] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
                [ScrollView2 addSubview:image];
                
                UILabel *labelN = [[UILabel alloc]initWithFrame:CGRectMake(10+j*60, 40, 60, 30)];
                labelN.text =[[[[zuheArray objectAtIndex:indexPath.row] objectForKey:@"goods_list"] objectAtIndex:j] objectForKey:@"goods_name"];
                labelN.font = [UIFont boldSystemFontOfSize:10];
                labelN.numberOfLines = 2;
                labelN.textAlignment = NSTextAlignmentCenter;
                [ScrollView2 addSubview:labelN];
                
                UILabel *labelNj = [[UILabel alloc]initWithFrame:CGRectMake(60+j*60, 0, 20, 40)];
                labelNj.text =@"+";
                labelNj.textAlignment = NSTextAlignmentCenter;
                labelNj.font = [UIFont boldSystemFontOfSize:15];
                [ScrollView2 addSubview:labelNj];
                
                if (j==arr.count-1) {
                    labelNj.text =@"=";
                    UILabel *labelMPy = [[UILabel alloc]initWithFrame:CGRectMake(60+j*60+20, 0, 120, 20)];
                    labelMPy.text =[NSString stringWithFormat:@"原价:￥%@",[[zuheArray objectAtIndex:indexPath.row] objectForKey:@"all_price"]];
                    labelMPy.font = [UIFont boldSystemFontOfSize:11];
                    [ScrollView2 addSubview:labelMPy];
                    
                    UILabel *labelMPPP = [[UILabel alloc]initWithFrame:CGRectMake(60+j*60+20, 20, 120, 20)];
                    labelMPPP.text =[NSString stringWithFormat:@"组合价:￥%@",[[zuheArray objectAtIndex:indexPath.row] objectForKey:@"plan_price"]];
                    labelMPPP.textColor = MY_COLOR;
                    labelMPPP.font = [UIFont boldSystemFontOfSize:14];
                    [ScrollView2 addSubview:labelMPPP];
                    
                    UIButton *buttonC = [UIButton buttonWithType:UIButtonTypeCustom ];
                    buttonC.frame =CGRectMake(60+j*60+19, 41, 66, 26);
                    [buttonC setTitle:@"购买套装" forState:UIControlStateNormal];
                    [buttonC addTarget:self action:@selector(zuheBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                    buttonC.tag = 100+indexPath.row;
                    buttonC.backgroundColor = MY_COLOR;
                    buttonC.titleLabel.font = [UIFont boldSystemFontOfSize:14];
                    [buttonC.layer setMasksToBounds:YES];
                    [buttonC.layer setCornerRadius:4.0];
                    [ScrollView2 addSubview:buttonC];
                }
            }
        }
        return cell;
    }
    
    if (tableView == zuhepeijianTableView){
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
        if (zuhePeijianArray.count!=0) {
        }
        return cell;
    }
    UITableViewCell *cell;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == MyTableView) {
        SecondViewController *sec = [SecondViewController sharedUserDefault];
        ClassifyModel *classify = [dataArray objectAtIndex:0];
        
        NSString *statu = classify.detail_goodsstatus_info;
        BOOL preOrder = [statu hasPrefix:@"预售商品"];
        if (indexPath.row == 0) {
        }
        if (indexPath.row == 1) {
            if([classify.detail_status isEqualToString:@"组合"]){
            //组合商品路口
                CombinedViewController *cvc=[[CombinedViewController alloc]init];
                cvc.model=classify;
                cvc.goodsCount=countField.text;
                [self.navigationController pushViewController:cvc animated:YES];
            }else if (preOrder)
            {

                
                alertList = [[WDAlertView alloc] initWithFrame:CGRectMake(0, 0, 300, 248)buttonSty:WDAlertViewTypeOneAnother title:@"预售详情" doneButtonTitle:@"确定" andCancelButtonTitle:nil];
                alertList.datasource = self;
                alertList.delegate=self;
                __unsafe_unretained typeof(self) blockSelf = self;
                //更改收货地址
                [alertList setDoneButtonWithBlock:^{
                    [blockSelf->alertList dismiss];
                   
                    
                }];
                
                 [alertList showAlertListView];
               }
            else{
           
            }
        }

        if (indexPath.row == 2) {
            ClassifyModel *classify = [dataArray objectAtIndex:0];
            UIImageView *iamgeView=(UIImageView *)[_specifView viewWithTag:1000];
            [iamgeView sd_setImageWithURL:[NSURL URLWithString:[arrImage objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"kong"]];
            UILabel *pricelabel=(UILabel *)[_specifView viewWithTag:1001];
            pricelabel.text=[NSString stringWithFormat:@"￥:%0.2f",[classify.detail_goods_current_price floatValue]];
            UILabel *stocklabel=(UILabel *)[_specifView viewWithTag:1002];
            stocklabel.text=[NSString stringWithFormat:@"库存:%@件",classify.detail_goods_inventory];
            
            if ([classify.detail_goods_inventory intValue]>0) {
                btn2Qing.backgroundColor = MY_COLOR;
                button2add.backgroundColor = [UIColor orangeColor];
            }else{
                btn2Qing.enabled = NO;
                btn2Qing.backgroundColor = [UIColor lightGrayColor];
                button2add.enabled = NO;
                button2add.backgroundColor = [UIColor lightGrayColor];
                
            }
            if (!_specIdsString) {
                _specIdsString=[[NSMutableString alloc]init];
            }
            if (_cartDictionary!=nil) {
                [_specIdsString setString:(NSString *)[_cartDictionary objectForKey:@"goods_spec_ids"]];
            }
            NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,SPECIFICATIONS_URL]];
            request_48=[ASIFormDataRequest requestWithURL:url3];
            [request_48 setPostValue:sec.detail_id forKey:@"id"];
            [request_48 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request_48.tag = 102;
            request_48.delegate = self;
            [request_48 setDidFailSelector:@selector(spec_urlRequestFailed:)];
            [request_48 setDidFinishSelector:@selector(spec_urlRequestSucceeded:)];
            [request_48 startAsynchronous];

        }
        if (indexPath.row == 3) {
        }
        if (indexPath.row == 4||indexPath.row == 5||indexPath.row == 6||indexPath.row == 7) {
            [self naviButtonClicked:_evaluateBtn];
        }
        if (indexPath.row == 9) {
            ThirdViewController *th = [ThirdViewController sharedUserDefault];
            th.store_id = [classify.detail_store_info objectForKey:@"store_id"];
            StoreHomeViewController2 *storeVC = [[StoreHomeViewController2 alloc]init];
            [self.navigationController pushViewController:storeVC animated:YES];
        }

    }
    if (tableView == RegoinTableView) {
        //发起请求下一地区
        buttonNext.enabled = YES;
        buttonNext.backgroundColor = MY_COLOR;
        selectRegionIndex = indexPath.row;
        [RegoinTableView reloadData];
    }
}
#pragma mark -设置行数
- (NSInteger)alertListTableView:(WDAlertView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)alertListTableView:(WDAlertView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 38;
    }else
        return 25;
    
}
- (UITableViewCell *)alertListTableView:(WDAlertView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{  ClassifyModel *classify = [dataArray objectAtIndex:0];
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.row==0) {
        
        NSString *red1 = classify.detail_advance_ding;
        NSString *red2 = classify.detail_advance_wei;
        NSString *full = [NSString stringWithFormat:@" 定金 : %@     尾款 : %@",red1,red2];
        if (red1 && red2) {
            NSRange range1 = [full rangeOfString:red1];
            NSRange range2 = [full rangeOfString:red2];
            
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:full];
            [attr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xf15353) range:range1];
            [attr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xf15353) range:range2];
            
            cell.textLabel.attributedText = attr;
            cell.textLabel.font=[UIFont systemFontOfSize:15];
        }
        
    }else if (indexPath.row==1)
    {cell.textLabel.text=[NSString stringWithFormat:@" 1.付定金: 现在 - %@",classify.detail_ding_pay_end];
        cell.textLabel.textColor=[UIColor colorWithRed:0.54f green:0.54f blue:0.54f alpha:1.00f];
        cell.textLabel.font=[UIFont systemFontOfSize:15];
    
    
    }else if (indexPath.row==2)
    {
        cell.textLabel.text=[NSString stringWithFormat:@" 2.付尾款: %@ ~ %@",classify.detail_ding_pay_end,classify.detail_wei_pay_end];
        cell.textLabel.textColor=[UIColor colorWithRed:0.54f green:0.54f blue:0.54f alpha:1.00f];
        cell.textLabel.font=[UIFont systemFontOfSize:15];

        
    }else if (indexPath.row==3)
    {
        cell.textLabel.text=[NSString stringWithFormat:@" 3.生产: 生产中，请耐心等待"];
        cell.textLabel.textColor=[UIColor colorWithRed:0.54f green:0.54f blue:0.54f alpha:1.00f];
        cell.textLabel.font=[UIFont systemFontOfSize:15];

        
    }else if (indexPath.row==4)
    {
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(15, 33, 270, 1)];
        line.backgroundColor=UIColorFromRGB(0xe3e3e3);
        [cell addSubview:line];

        cell.textLabel.text=[NSString stringWithFormat:@" 4.发货: %@",classify.detail_ship_Date];
        cell.textLabel.textColor=[UIColor colorWithRed:0.54f green:0.54f blue:0.54f alpha:1.00f];
        cell.textLabel.font=[UIFont systemFontOfSize:15];
        
    }
    

    return cell;
    
    
}
- (void)alertListTableView:(WDAlertView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)alertListTableView:(WDAlertView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark -规格选择
-(void)spcClick:(UIButton *)btn{
    NSDictionary *dict=[_specArray objectAtIndex:btn.tag/1000];
    NSArray *array=[dict objectForKey:@"spec_values"];
    NSDictionary *dic=[array objectAtIndex:btn.tag%1000];
    //存在选择规格的ID
    NSArray *spdIds=[[NSMutableArray alloc]initWithArray:[_specIdsString componentsSeparatedByString:@","]];
    for (int i=0; i<_specArray.count; i++) {
        NSDictionary *diction=[_specArray objectAtIndex:i];
        NSArray *spArray=[diction objectForKey:@"spec_values"];
        for (int j=0;j<spArray.count;j++) {
            NSDictionary *ddict=[spArray objectAtIndex:j];
            for (NSString *specIdsStr in spdIds) {
                if ([specIdsStr intValue]==[[ddict objectForKey:@"id"]intValue]) {
                    [_specIdsArray replaceObjectAtIndex:i withObject:specIdsStr];
                }
            }
        }
    }
    [_specIdsArray replaceObjectAtIndex:btn.tag/1000 withObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
    [_specIdsString setString:[_specIdsArray componentsJoinedByString:@","]];
    [_specTableView reloadData];
    NSString *str=[NSString stringWithFormat:@"%@~%@~%@",[dict objectForKey:@"spec_key"],[dic objectForKey:@"val"],[dic objectForKey:@"id"]];
    [specSelectArray replaceObjectAtIndex:btn.tag/1000 withObject:[NSString stringWithFormat:@"%@",str]];
   
    if (_specIdsArray.count>0) {
        NSString *string=[_specIdsArray componentsJoinedByString:@","];
        [_cartDictionary setValue:string forKey:@"goods_spec_ids"];
    }
   
    if (specSelectArray.count>0) {
         NSMutableArray *mArray=[[NSMutableArray alloc]init];
        for (NSString *string in specSelectArray) {
            NSArray *arr=[string componentsSeparatedByString:@"~"];
            NSString *strr=[NSString stringWithFormat:@"%@：%@",[arr objectAtIndex:0],[arr objectAtIndex:1]];
            [mArray addObject:strr];
        }
        NSString *goods_spec_string=[mArray componentsJoinedByString:@" "];
        [_cartDictionary setValue:goods_spec_string forKey:@"goods_spec"];
    }
    
    //取出第一个之后 发起请求库存
    SecondViewController *sec = [SecondViewController sharedUserDefault];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,SPECIFICATIONSBACK_URL]];
    request_24=[ASIFormDataRequest requestWithURL:url];
    if (specSelectArray.count!=0) {
        NSString *str;
        for(int i=0;i<specSelectArray.count;i++){
            if (str.length == 0) {
                str = [[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2];
            }else{
                str = [NSString stringWithFormat:@"%@,%@",str,[[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2]];
            }
        }
        [request_24 setPostValue:str forKey:@"gsp"];
    }
    
    [request_24 setPostValue:sec.detail_id forKey:@"id"];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:readPath];
    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
    if([fileManagerDong fileExistsAtPath:readPath] == NO){
        
        [request_24 setPostValue:@"" forKey:@"user_id"];
        [request_24 setPostValue:@"" forKey:@"token"];
    }else{
        [request_24 setPostValue:[fileContent objectAtIndex:3] forKey:@"user_id"];
        [request_24 setPostValue:[fileContent objectAtIndex:1] forKey:@"token"];
    }
//                    读取本地id
     NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    NSString *areaId=[standard objectForKey:@"area_id"];
    [request_24 setPostValue:areaId forKey:@"area_id"];

    [request_24 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_24.tag = 114;
    request_24.delegate =self;
    [request_24 setDidFailSelector:@selector(spec3_urlRequestFailed:)];
    [request_24 setDidFinishSelector:@selector(spec3_urlRequestSucceeded:)];
    [request_24 startAsynchronous];

    [MyTableView reloadData];
    
}

//-(void)failedPrompt:(NSString *)prompt{
//    [SYObject endLoading];
//    labelTi.hidden = NO;
//    labelTi.text = prompt;
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
//}
#pragma mark - 网络
-(void)on_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
    bottomView.hidden = YES;
    MyTableView.hidden = YES;
    
}
-(void)on_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"6-dicBig:%@",dicBig);
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        //存本地area_id
        NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
        
        [standard setObject:[dicBig objectForKey:@"area_id"] forKey:@"area_id"];
        [standard synchronize];
        
        ClassifyModel *classify = [[ClassifyModel alloc]init];
        //预售商品
        if ([dicBig objectForKey:@"advance_ding"]) {
            classify.detail_advance_ding =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"advance_ding"]];
        }
        if ([dicBig objectForKey:@"advance_ding_pay"]) {
            classify.detail_advance_ding_pay =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"advance_ding_pay"]];
            
        }
        if ([dicBig objectForKey:@"advance_wei"]) {
            classify.detail_advance_wei =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"advance_wei"]];
            
        }
        if ([dicBig objectForKey:@"ding_pay_end"]) {
            classify.detail_ding_pay_end =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"ding_pay_end"]];
            
        }
        if ([dicBig objectForKey:@"wei_pay_end"]) {
            classify.detail_wei_pay_end =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"wei_pay_end"]];
            
        }
        if ([dicBig objectForKey:@"ship_Date"]) {
            classify.detail_ship_Date =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"ship_Date"]];
            
        }

        classify.detail_goods_limit =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"goods_limit"]];
        classify.detail_goods_all_count = [dicBig objectForKey:@"all_count"];
        classify.detail_goods_buy_count = [dicBig objectForKey:@"buy_count"];
        classify.detail_current_city = [dicBig objectForKey:@"current_city"];
        classify.detail_inventory_type = [dicBig objectForKey:@"inventory_type"];
        classify.detail_id = [dicBig objectForKey:@"id"];
        classify.detail_goods_salenum = [dicBig objectForKey:@"goods_salenum"];
        classify.detail_goods_type = [dicBig objectForKey:@"goods_type"];
        classify.detail_goods_price = [dicBig objectForKey:@"goods_price"];
        arrImage = [dicBig objectForKey:@"goods_photos"];
        classify.detail_goods_photos = [dicBig objectForKey:@"goods_photos"];
        classify.detail_goods_name = [dicBig objectForKey:@"goods_name"];
        classify.detail_goods_inventory = [dicBig objectForKey:@"goods_inventory"];
        classify.detail_choice_type = [dicBig objectForKey:@"goods_choice_type"];
        classify.detail_goods_details = [dicBig objectForKey:@"goods_details"];
        classify.detail_goods_current_price = [dicBig objectForKey:@"goods_current_price"];
        classify.detail_status = [dicBig objectForKey:@"status"];
        classify.detail_goodsstatus_info = [dicBig objectForKey:@"status_info"];
        classify.detail_store_info = [dicBig objectForKey:@"store_info"];
        classify.detail_goods_well_evaluate = [dicBig objectForKey:@"goods_well_evaluate"];
        classify.detail_consult_count = [dicBig objectForKey:@"consult_count"];
        classify.detail_goods_bad_evaluate = [dicBig objectForKey:@"goods_well_evaluate"];
        classify.detail_goods_bad_evaluate = [dicBig objectForKey:@"goods_well_evaluate"];
        classify.detail_goods_middle_evaluate = [dicBig objectForKey:@"goods_middle_evaluate"];
        classify.detail_evaluate_count = [dicBig objectForKey:@"evaluate_count"];
        classify.detail_trans_information = [dicBig objectForKey:@"trans_information"];
        if ([[dicBig objectForKey:@"favorite"] isEqualToString:@"false"]) {
            favouiteBool = NO;
            labeHeart2.image = [UIImage imageNamed:@"sc_new"];
            labeHeart3.image = [UIImage imageNamed:@"sc_new"];
        }else{
            favouiteBool = YES;
            labeHeart2.image = [UIImage imageNamed:@"qx_new"];
            labeHeart3.image = [UIImage imageNamed:@"qx_new"];
        }
        if ([[dicBig objectForKey:@"goods_type"] intValue]==0) {
            bottomView.hidden=YES;
            bottomView1.hidden=NO;
        }else{
            bottomView.hidden=NO;
            bottomView1.hidden=YES;
        }

        status = [dicBig objectForKey:@"status"];
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
            if ([[dicBig objectForKey:@"goods_inventory"] intValue]<=0) {
                btnAddCar.backgroundColor = [UIColor lightGrayColor];
                btnAddCar.enabled = NO;
                btnAddCar2.backgroundColor = [UIColor lightGrayColor];
                btnAddCar2.enabled = NO;
                button2add.backgroundColor = [UIColor lightGrayColor];
                button2add.enabled = NO;
                btn2Qing.enabled = NO;
                btn2Qing.backgroundColor = [UIColor lightGrayColor];
                btn22Qing.enabled = NO;
                btn22Qing.backgroundColor = [UIColor lightGrayColor];
                btn22Qing2.enabled = NO;
                btn22Qing2.backgroundColor = [UIColor lightGrayColor];
            }else{
                btnAddCar.backgroundColor = [UIColor orangeColor];
                btnAddCar.enabled = YES;
                btnAddCar2.backgroundColor = [UIColor orangeColor];
                btnAddCar2.enabled = YES;
                button2add.backgroundColor = [UIColor orangeColor];
                button2add.enabled = YES;
                btn2Qing.enabled = YES;
                btn2Qing.backgroundColor = MY_COLOR;
                btn22Qing.enabled = YES;
                btn22Qing.backgroundColor = MY_COLOR;
                btn22Qing2.enabled = YES;
                btn22Qing2.backgroundColor = MY_COLOR;
            }
        }else{
            if ([[dicBig objectForKey:@"goods_inventory"] intValue]<=0) {
                btnAddCar.backgroundColor = [UIColor lightGrayColor];
                btnAddCar.enabled = NO;
                btnAddCar2.backgroundColor = [UIColor lightGrayColor];
                btnAddCar2.enabled = NO;
                btn2Qing.backgroundColor = [UIColor lightGrayColor];
                btn2Qing.enabled = NO;
                btn22Qing.backgroundColor = [UIColor lightGrayColor];
                btn22Qing.enabled = NO;
                btn22Qing2.backgroundColor = [UIColor lightGrayColor];
                btn22Qing2.enabled = NO;
                button2add.backgroundColor = [UIColor lightGrayColor];
                button2add.enabled = NO;
            }else{
                btnAddCar.backgroundColor = [UIColor orangeColor];
                btnAddCar.enabled = YES;
                btnAddCar2.backgroundColor = [UIColor orangeColor];
                btnAddCar2.enabled = YES;
                btn2Qing.backgroundColor = MY_COLOR;
                btn2Qing.enabled = YES;
                btn22Qing.backgroundColor = MY_COLOR;
                btn22Qing.enabled = YES;
                btn22Qing2.backgroundColor = MY_COLOR;
                btn22Qing2.enabled = YES;
                button2add.backgroundColor = [UIColor orangeColor];
                button2add.enabled = YES;
            }
        }
        [dataArray addObject:classify];
    }
    
    [MyTableView reloadData];
    
    //发起请求运费
    SecondViewController *sec = [SecondViewController sharedUserDefault];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,TRANS_FEE_URL]];
    request_4=[ASIFormDataRequest requestWithURL:url];
    NSArray * array = [regionStr componentsSeparatedByString:@">"];
    NSString *di = [NSString stringWithFormat:@"%@%@%@",[array objectAtIndex:0],[array objectAtIndex:1],[array objectAtIndex:2]];
    [request_4 setPostValue:sec.detail_id forKey:@"goods_id"];
    [request_4 setPostValue:(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)di,NULL,NULL,kCFStringEncodingUTF8)) forKey:@"current_city"];
    
    [request_4 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_4.delegate = self;
    [request_4 setDidFailSelector:@selector(transfee_urlRequestFailed:)];
    [request_4 setDidFinishSelector:@selector(transfee_urlRequestSucceeded:)];
    [request_4 startAsynchronous];
    
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request
{
    [SYObject failedPrompt:@"网络请求失败"];
    MyTableView.hidden = YES;
    bottomView.hidden = YES;
}
-(void)urlRequestSucceeded:(ASIHTTPRequest *)request
{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"7-dicBig:%@",dicBig);
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        //存本地area_id
        NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
        
        [standard setObject:[dicBig objectForKey:@"area_id"] forKey:@"area_id"];
        [standard synchronize];
        
        ClassifyModel *classify = [[ClassifyModel alloc]init];
        //预售商品
        if ([dicBig objectForKey:@"advance_ding"]) {
            classify.detail_advance_ding =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"advance_ding"]];
        }
        if ([dicBig objectForKey:@"advance_ding_pay"]) {
            classify.detail_advance_ding_pay =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"advance_ding_pay"]];
            
        }
        if ([dicBig objectForKey:@"advance_wei"]) {
            classify.detail_advance_wei =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"advance_wei"]];
            
        }
        if ([dicBig objectForKey:@"ding_pay_end"]) {
            classify.detail_ding_pay_end =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"ding_pay_end"]];
            
        }
        if ([dicBig objectForKey:@"wei_pay_end"]) {
            classify.detail_wei_pay_end =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"wei_pay_end"]];
            
        }
        if ([dicBig objectForKey:@"ship_Date"]) {
            classify.detail_ship_Date =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"ship_Date"]];
            
        }

        classify.detail_goods_limit =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"goods_limit"]];
        classify.detail_goods_all_count = [dicBig objectForKey:@"all_count"];
        classify.detail_goods_buy_count = [dicBig objectForKey:@"buy_count"];
        classify.detail_current_city = [dicBig objectForKey:@"current_city"];
        classify.detail_inventory_type = [dicBig objectForKey:@"inventory_type"];
        classify.detail_id = [dicBig objectForKey:@"id"];
        classify.detail_goods_salenum = [dicBig objectForKey:@"goods_salenum"];
        classify.detail_goods_type = [dicBig objectForKey:@"goods_type"];
        classify.detail_goods_price = [dicBig objectForKey:@"goods_price"];
        arrImage = [dicBig objectForKey:@"goods_photos"];
        classify.detail_goods_photos = [dicBig objectForKey:@"goods_photos"];
        classify.detail_goods_name = [dicBig objectForKey:@"goods_name"];
        classify.detail_goods_inventory = [dicBig objectForKey:@"goods_inventory"];
        classify.detail_choice_type = [dicBig objectForKey:@"goods_choice_type"];
        classify.detail_goods_details = [dicBig objectForKey:@"goods_details"];
        classify.detail_goods_current_price = [dicBig objectForKey:@"goods_current_price"];
        classify.detail_status = [dicBig objectForKey:@"status"];//status_info
        classify.detail_goodsstatus_info = [dicBig objectForKey:@"status_info"];
        classify.detail_store_info = [dicBig objectForKey:@"store_info"];
        classify.detail_goods_well_evaluate = [dicBig objectForKey:@"goods_well_evaluate"];
        classify.detail_consult_count = [dicBig objectForKey:@"consult_count"];
        classify.detail_goods_bad_evaluate = [dicBig objectForKey:@"goods_well_evaluate"];
        classify.detail_goods_bad_evaluate = [dicBig objectForKey:@"goods_well_evaluate"];
        classify.detail_goods_middle_evaluate = [dicBig objectForKey:@"goods_middle_evaluate"];
        classify.detail_evaluate_count = [dicBig objectForKey:@"evaluate_count"];
        classify.detail_trans_information = [dicBig objectForKey:@"trans_information"];
        if ([[dicBig objectForKey:@"favorite"] isEqualToString:@"false"]) {
            favouiteBool = NO;
            labeHeart2.image = [UIImage imageNamed:@"sc_new"];
            labeHeart3.image = [UIImage imageNamed:@"sc_new"];
        }else{
            favouiteBool = YES;
            labeHeart2.image = [UIImage imageNamed:@"qx_new"];
            labeHeart3.image = [UIImage imageNamed:@"qx_new"];
        }
        if ([[dicBig objectForKey:@"goods_type"] intValue]==0) {
            bottomView.hidden=YES;
            bottomView1.hidden=NO;
        }else{
            bottomView.hidden=NO;
            bottomView1.hidden=YES;
        }

        status = [dicBig objectForKey:@"status"];
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
            if ([[dicBig objectForKey:@"goods_inventory"] intValue]<=0) {
                btnAddCar.backgroundColor = [UIColor lightGrayColor];
                btnAddCar.enabled = NO;
                btnAddCar2.backgroundColor = [UIColor lightGrayColor];
                btnAddCar2.enabled = NO;
                button2add.enabled = NO;
                button2add.backgroundColor = [UIColor lightGrayColor];
                btn2Qing.enabled = NO;
                btn2Qing.backgroundColor = [UIColor lightGrayColor];
                btn22Qing.enabled = NO;
                btn22Qing.backgroundColor = [UIColor lightGrayColor];
                btn22Qing2.enabled = NO;
                btn22Qing2.backgroundColor = [UIColor lightGrayColor];
            }else{
                btnAddCar.backgroundColor = [UIColor orangeColor];
                btnAddCar.enabled = YES;
                btnAddCar.backgroundColor = [UIColor orangeColor];
                btnAddCar.enabled = YES;
                button2add.enabled = YES;
                button2add.backgroundColor = [UIColor orangeColor];
                btn2Qing.backgroundColor = MY_COLOR;
                btn2Qing.enabled = YES;
                btn22Qing.backgroundColor = MY_COLOR;
                btn22Qing.enabled = YES;
                btn22Qing2.backgroundColor = MY_COLOR;
                btn22Qing2.enabled = YES;
            }
        }else{
            if ([[dicBig objectForKey:@"goods_inventory"] intValue]<=0) {
                btnAddCar.backgroundColor = [UIColor lightGrayColor];
                btnAddCar.enabled = NO;
                btnAddCar2.backgroundColor = [UIColor lightGrayColor];
                btnAddCar2.enabled = NO;
                btn2Qing.enabled = NO;
                btn2Qing.backgroundColor = [UIColor lightGrayColor];
                btn22Qing.enabled = NO;
                btn22Qing.backgroundColor = [UIColor lightGrayColor];
                btn22Qing2.enabled = NO;
                btn22Qing2.backgroundColor = [UIColor lightGrayColor];
                button2add.enabled = NO;
                button2add.backgroundColor = [UIColor lightGrayColor];
            }else{
                btnAddCar.backgroundColor = [UIColor orangeColor];
                btnAddCar.enabled = YES;
                btnAddCar2.backgroundColor = [UIColor orangeColor];
                btnAddCar2.enabled = YES;
                btn2Qing.backgroundColor = MY_COLOR;
                btn2Qing.enabled = YES;
                btn22Qing.backgroundColor = MY_COLOR;
                btn22Qing.enabled = YES;
                btn22Qing2.backgroundColor = MY_COLOR;
                btn22Qing2.enabled = YES;
                button2add.enabled = YES;
                button2add.backgroundColor = [UIColor orangeColor];
            }
        }
        [dataArray addObject:classify];
    }
    
    [MyTableView reloadData];
    
    //发起请求运费
    SecondViewController *sec = [SecondViewController sharedUserDefault];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,TRANS_FEE_URL]];
    request_5=[ASIFormDataRequest requestWithURL:url];
    NSArray * array = [regionStr componentsSeparatedByString:@">"];
    NSString *di = [NSString stringWithFormat:@"%@%@%@",[array objectAtIndex:0],[array objectAtIndex:1],[array objectAtIndex:2]];
    [request_5 setPostValue:sec.detail_id forKey:@"goods_id"];
    [request_5 setPostValue:(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)di,NULL,NULL,kCFStringEncodingUTF8)) forKey:@"current_city"];
    
    [request_5 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_5.delegate = self;
    [request_5 setDidFailSelector:@selector(transfee_urlRequestFailed:)];
    [request_5 setDidFinishSelector:@selector(transfee_urlRequestSucceeded:)];
    [request_5 startAsynchronous];
    
}
-(void)init_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"8-dicBig:%@",dicBig);
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        //存本地area_id
        NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
        
        [standard setObject:[dicBig objectForKey:@"area_id"] forKey:@"area_id"];
        [standard synchronize];
        ClassifyModel *classify = [[ClassifyModel alloc]init];
        //预售商品
        if ([dicBig objectForKey:@"advance_ding"]) {
            classify.detail_advance_ding =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"advance_ding"]];
        }
        if ([dicBig objectForKey:@"advance_ding_pay"]) {
            classify.detail_advance_ding_pay =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"advance_ding_pay"]];
            
        }
        if ([dicBig objectForKey:@"advance_wei"]) {
            classify.detail_advance_wei =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"advance_wei"]];
            
        }
        if ([dicBig objectForKey:@"ding_pay_end"]) {
            classify.detail_ding_pay_end =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"ding_pay_end"]];
            
        }
        if ([dicBig objectForKey:@"wei_pay_end"]) {
            classify.detail_wei_pay_end =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"wei_pay_end"]];
            
        }
        if ([dicBig objectForKey:@"ship_Date"]) {
            classify.detail_ship_Date =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"ship_Date"]];
            
        }


        classify.detail_goods_limit =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"goods_limit"]];
        classify.detail_goods_all_count = [dicBig objectForKey:@"all_count"];
        classify.detail_goods_buy_count = [dicBig objectForKey:@"buy_count"];
        classify.detail_current_city = [dicBig objectForKey:@"current_city"];
        classify.detail_inventory_type = [dicBig objectForKey:@"inventory_type"];
        classify.detail_id = [dicBig objectForKey:@"id"];
        classify.detail_goods_salenum = [dicBig objectForKey:@"goods_salenum"];
        classify.detail_goods_type = [dicBig objectForKey:@"goods_type"];
        classify.detail_goods_price = [dicBig objectForKey:@"goods_price"];
        classify.detail_goods_photos_small = [dicBig objectForKey:@"goods_photos_small"];
        arrImage = [dicBig objectForKey:@"goods_photos"];
        classify.detail_goods_photos = [dicBig objectForKey:@"goods_photos"];
        classify.detail_goods_name = [dicBig objectForKey:@"goods_name"];
        classify.detail_goods_inventory = [dicBig objectForKey:@"goods_inventory"];
        classify.detail_choice_type = [dicBig objectForKey:@"goods_choice_type"];
        classify.detail_goods_details = [dicBig objectForKey:@"goods_details"];
        classify.detail_goods_current_price = [dicBig objectForKey:@"goods_current_price"];
        classify.detail_status = [dicBig objectForKey:@"status"];
        classify.detail_goodsstatus_info = [dicBig objectForKey:@"status_info"];
        classify.detail_store_info = [dicBig objectForKey:@"store_info"];
        classify.detail_goods_well_evaluate = [dicBig objectForKey:@"goods_well_evaluate"];
        classify.detail_consult_count = [dicBig objectForKey:@"consult_count"];
        classify.detail_goods_bad_evaluate = [dicBig objectForKey:@"goods_well_evaluate"];
        classify.detail_goods_bad_evaluate = [dicBig objectForKey:@"goods_well_evaluate"];
        classify.detail_goods_middle_evaluate = [dicBig objectForKey:@"goods_middle_evaluate"];
        classify.detail_evaluate_count = [dicBig objectForKey:@"evaluate_count"];
        classify.detail_trans_information = [dicBig objectForKey:@"trans_information"];
        if ([[dicBig objectForKey:@"favorite"] isEqualToString:@"false"]) {
            favouiteBool = NO;
            labeHeart2.image = [UIImage imageNamed:@"sc_new"];
            labeHeart3.image = [UIImage imageNamed:@"sc_new"];
        }else{
            favouiteBool = YES;
            labeHeart2.image = [UIImage imageNamed:@"qx_new"];
            labeHeart3.image = [UIImage imageNamed:@"qx_new"];
        }
        if ([[dicBig objectForKey:@"goods_type"] intValue]==0) {
            bottomView.hidden=YES;
            bottomView1.hidden=NO;
        }else{
            bottomView.hidden=NO;
            bottomView1.hidden=YES;
        }
        
        
        status = [dicBig objectForKey:@"status"];
        if([status isEqualToString:@"F码"]){
            FCode_bottomView.hidden = NO;
            FBuyView.hidden = NO;
        }else{
            FCode_bottomView.hidden = YES;
            FBuyView.hidden = YES;
        }
        
        //发起组合的请iu
        if ([classify.detail_status isEqualToString:@"组合"]) {
            NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,COMBINATION_URL]];
            request_6=[ASIFormDataRequest requestWithURL:url3];
            [request_6 setPostValue:classify.detail_id forKey:@"id"];
            
            request_6.delegate =self;
            [request_6 setDidFailSelector:@selector(zuhe_urlRequestFailed:)];
            [request_6 setDidFinishSelector:@selector(zuhe_urlRequestSucceeded:)];
            [request_6 setRequestHeaders:[LJControl requestHeaderDictionary]];
            [request_6 startAsynchronous];
            
            NSURL *url32 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,COMBINATION_PARTS_URL]];
            request_7=[ASIFormDataRequest requestWithURL:url32];
            [request_7 setPostValue:classify.detail_id forKey:@"id"];
            [request_7 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request_7.delegate =self;
            [request_7 setDidFailSelector:@selector(zuhepeijian_urlRequestFailed:)];
            [request_7 setDidFinishSelector:@selector(zuhepeijian_urlRequestSucceeded:)];
            [request_7 startAsynchronous];
        }
        
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
            if ([[dicBig objectForKey:@"goods_inventory"] intValue]<=0) {
                btnAddCar.backgroundColor = [UIColor lightGrayColor];
                btnAddCar.enabled = NO;
                button2add.enabled = NO;
                button2add.backgroundColor = [UIColor lightGrayColor];
                btn2Qing.enabled = NO;
                btn2Qing.backgroundColor = [UIColor lightGrayColor];
                btn22Qing.enabled = NO;
                btn22Qing.backgroundColor = [UIColor lightGrayColor];
            }else{
                btnAddCar.backgroundColor = [UIColor orangeColor];
                btnAddCar.enabled = YES;
                button2add.enabled = YES;
                button2add.backgroundColor = [UIColor orangeColor];
                btn2Qing.backgroundColor = MY_COLOR;
                btn2Qing.enabled = YES;
                btn22Qing.backgroundColor = MY_COLOR;
                btn22Qing.enabled = YES;
            }
        }else{
            if ([[dicBig objectForKey:@"goods_inventory"] intValue]<=0) {
                btnAddCar.backgroundColor = [UIColor lightGrayColor];
                btnAddCar.enabled = NO;
                button2add.enabled = NO;
                button2add.backgroundColor = [UIColor lightGrayColor];
                btn2Qing.enabled = NO;
                btn2Qing.backgroundColor = [UIColor lightGrayColor];
                btn22Qing.enabled = NO;
                btn22Qing.backgroundColor = [UIColor lightGrayColor];
            }else{
                btnAddCar.backgroundColor = [UIColor orangeColor];
                btnAddCar.enabled = YES;
                button2add.enabled = YES;
                button2add.backgroundColor = [UIColor orangeColor];
                btn2Qing.backgroundColor = MY_COLOR;
                btn2Qing.enabled = YES;
                btn22Qing.backgroundColor = MY_COLOR;
                btn22Qing.enabled = YES;
            }
        }
        [dataArray addObject:classify];
    }
    [MyTableView reloadData];
    
    //发起请求运费
    SecondViewController *sec = [SecondViewController sharedUserDefault];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,TRANS_FEE_URL]];
    request_8=[ASIFormDataRequest requestWithURL:url];
    NSArray * array = [regionStr componentsSeparatedByString:@">"];
    NSString *di = [NSString stringWithFormat:@"%@%@%@",[array objectAtIndex:0],[array objectAtIndex:1],[array objectAtIndex:2]];
    [request_8 setPostValue:sec.detail_id forKey:@"goods_id"];
    [request_8 setPostValue:(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)di,NULL,NULL,kCFStringEncodingUTF8)) forKey:@"current_city"];
    
    [request_8 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_8.delegate = self;
    [request_8 setDidFailSelector:@selector(transfee_urlRequestFailed:)];
    [request_8 setDidFinishSelector:@selector(transfee_urlRequestSucceeded:)];
    [request_8 startAsynchronous];
    
}
-(void)zuhe_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)zuhe_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig：%@",dicBig);
        if (zuheArray.count!=0) {
            [zuheArray removeAllObjects];
        }
        NSArray *arr = [dicBig objectForKey:@"plan_list"];
        for(NSDictionary *dic in arr){
            [zuheArray addObject:dic];
        }
        
        [MyTableView reloadData];
        
        [SYObject endLoading];
    }
    else{
        [SYObject failedPrompt:@"请求出错"];
    }
    
}
-(void)zuhepeijian_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)zuhepeijian_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig：%@",dicBig);
        if (zuhePeijianArray.count!=0) {
            [zuhePeijianArray removeAllObjects];
        }
        if (peijianSelectArray.count!=0) {
            [peijianSelectArray removeAllObjects];
        }
        NSArray *arr = [dicBig objectForKey:@"plan_list"];
        for(NSDictionary *dic in arr){
            [zuhePeijianArray addObject:dic];
            NSArray *myArr = (NSArray *)[dic objectForKey:@"goods_list"];
            NSMutableArray *AAA= [[NSMutableArray alloc]init];
            for(int i=0;i<myArr.count;i++){
                [AAA addObject:@""];
            }
            [peijianSelectArray addObject:AAA];
        }
        
        [MyTableView reloadData];
        [SYObject endLoading];
    }
    else{
        [SYObject failedPrompt:@"请求出错"];
    }
}
-(void)init_urlRequestFailed:(ASIFormDataRequest *)request{
    MyTableView.hidden = YES;
    bottomView.hidden = YES;
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)Userlevel_urlRequestFailed:(ASIHTTPRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)Userlevel_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"9-dicBig:%@",dicBig);
        act_rate = [[dicBig objectForKey:@"act_rate"] floatValue];
    }
    [MyTableView reloadData];
    
}
-(void)spec_urlRequestFailed:(ASIHTTPRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)spec_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"10-dicBig:%@",dicBig);
        NSArray *array=[dicBig objectForKey:@"spec_list"];
        if (!_specArray) {
            _specArray=[[NSMutableArray alloc]init];
        }else if (_specArray.count>0){
            [_specArray removeAllObjects];
        }
        for (NSDictionary *dict in array) {
            [_specArray addObject:dict];
        }
        NSInteger count;
        count=0;
        for (int i=0; i<_specArray.count; i++) {
            NSDictionary *dict=[_specArray objectAtIndex:i];
            NSArray *array=[dict objectForKey:@"spec_values"];
            if (array.count==0) {
                count +=count;
            }else{
                count +=array.count/4+1;
            }
        }
        
        if (100*count+100+60>400) {
            _specifView.frame=CGRectMake(0,  ScreenFrame.size.height-400, ScreenFrame.size.width,400);
            _specTableView.frame=CGRectMake(0,100,ScreenFrame.size.width,200);
            _BottomViewSpec.frame=CGRectMake(0, _specifView.bounds.size.height-100, ScreenFrame.size.width, 100);
            
        }else{
            _specifView.frame=CGRectMake(0, ScreenFrame.size.height-(100*count+100+100),  ScreenFrame.size.width,100*count+100+100);
            _specTableView.frame=CGRectMake(0, 100,  ScreenFrame.size.width, count *100);
            _BottomViewSpec.frame=CGRectMake(0, _specifView.bounds.size.height-100, ScreenFrame.size.width, 100);
        }
        //清空选择的规格数组
//        _specIdsArray=[[NSMutableArray alloc]init];
        for (NSDictionary *d in _specArray) {
            NSLog(@"%@",d);
            [_specIdsArray addObject:@""];
        }
        
        [_specTableView reloadData];
        _semiTransparentView.hidden=NO;
        _specifView.hidden=NO;
        [self.navigationController.view bringSubviewToFront:_semiTransparentView];
        [self.navigationController.view bringSubviewToFront:_specifView];
    }
    
}
-(void)detailOn_urlRequestFailed:(ASIHTTPRequest *)request{
    MyTableView.hidden = YES;
    bottomView.hidden = YES;
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)detailOn_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"11-dicBig:%@",dicBig);
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        //存本地area_id
        NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
        
        [standard setObject:[dicBig objectForKey:@"area_id"] forKey:@"area_id"];
        [standard synchronize];
       
        
        ClassifyModel *classify = [[ClassifyModel alloc]init];
        //预售商品
        if ([dicBig objectForKey:@"advance_ding"]) {
             classify.detail_advance_ding =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"advance_ding"]];
        }
        if ([dicBig objectForKey:@"advance_ding_pay"]) {
             classify.detail_advance_ding_pay =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"advance_ding_pay"]];
            
        }
        if ([dicBig objectForKey:@"advance_wei"]) {
            classify.detail_advance_wei =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"advance_wei"]];
            
        }
        if ([dicBig objectForKey:@"ding_pay_end"]) {
            classify.detail_ding_pay_end =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"ding_pay_end"]];
            
        }
        if ([dicBig objectForKey:@"wei_pay_end"]) {
            classify.detail_wei_pay_end =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"wei_pay_end"]];
            
        }
        if ([dicBig objectForKey:@"ship_Date"]) {
            classify.detail_ship_Date =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"ship_Date"]];
            
        }

        classify.detail_goods_limit =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"goods_limit"]];
        classify.detail_goods_all_count = [dicBig objectForKey:@"all_count"];
        classify.detail_goods_buy_count = [dicBig objectForKey:@"buy_count"];
        classify.detail_current_city = [dicBig objectForKey:@"current_city"];
        classify.detail_inventory_type = [dicBig objectForKey:@"inventory_type"];
        classify.detail_id = [dicBig objectForKey:@"id"];
        classify.detail_goods_salenum = [dicBig objectForKey:@"goods_salenum"];
        classify.detail_goods_type = [dicBig objectForKey:@"goods_type"];
        classify.detail_goods_price = [dicBig objectForKey:@"goods_price"];
        arrImage = [dicBig objectForKey:@"goods_photos"];
        classify.detail_goods_photos = [dicBig objectForKey:@"goods_photos"];
        classify.detail_goods_name = [dicBig objectForKey:@"goods_name"];
        classify.detail_goods_inventory = [dicBig objectForKey:@"goods_inventory"];
        classify.detail_choice_type = [dicBig objectForKey:@"goods_choice_type"];
        classify.detail_goods_details = [dicBig objectForKey:@"goods_details"];
        classify.detail_goods_current_price = [dicBig objectForKey:@"goods_current_price"];
        classify.detail_status = [dicBig objectForKey:@"status"];
        classify.detail_goodsstatus_info = [dicBig objectForKey:@"status_info"];
        classify.detail_store_info = [dicBig objectForKey:@"store_info"];
        classify.detail_goods_well_evaluate = [dicBig objectForKey:@"goods_well_evaluate"];
        classify.detail_consult_count = [dicBig objectForKey:@"consult_count"];
        classify.detail_goods_bad_evaluate = [dicBig objectForKey:@"goods_well_evaluate"];
        classify.detail_goods_bad_evaluate = [dicBig objectForKey:@"goods_well_evaluate"];
        classify.detail_goods_middle_evaluate = [dicBig objectForKey:@"goods_middle_evaluate"];
        classify.detail_evaluate_count = [dicBig objectForKey:@"evaluate_count"];
        classify.detail_trans_information = [dicBig objectForKey:@"trans_information"];
        if ([[dicBig objectForKey:@"favorite"] isEqualToString:@"false"]) {
            favouiteBool = NO;
            labeHeart2.image = [UIImage imageNamed:@"sc_new"];
            labeHeart3.image = [UIImage imageNamed:@"sc_new"];
        }else{
            favouiteBool = YES;
            labeHeart2.image = [UIImage imageNamed:@"qx_new"];
            labeHeart3.image = [UIImage imageNamed:@"qx_new"];
        }
        if ([[dicBig objectForKey:@"goods_type"] intValue]==0) {
            bottomView.hidden=YES;
            bottomView1.hidden=NO;
        }else{
            bottomView.hidden=NO;
            bottomView1.hidden=YES;
        }
        //发起组合的请iu
        if ([classify.detail_status isEqualToString:@"组合"]) {
            NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,COMBINATION_URL]];
            request_9=[ASIFormDataRequest requestWithURL:url3];
            [request_9 setPostValue:classify.detail_id forKey:@"id"];
            
            [request_9 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request_9.delegate =self;
            [request_9 setDidFailSelector:@selector(zuhe_urlRequestFailed:)];
            [request_9 setDidFinishSelector:@selector(zuhe_urlRequestSucceeded:)];
            [request_9 startAsynchronous];
            
            NSURL *url32 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,COMBINATION_PARTS_URL]];
            request_10=[ASIFormDataRequest requestWithURL:url32];
            [request_10 setPostValue:classify.detail_id forKey:@"id"];
            [request_10 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request_10.delegate =self;
            [request_10 setDidFailSelector:@selector(zuhepeijian_urlRequestFailed:)];
            [request_10 setDidFinishSelector:@selector(zuhepeijian_urlRequestSucceeded:)];
            [request_10 startAsynchronous];
        }
        
        //AFTERSUPPLY_COUNT
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,AFTERSUPPLY_COUNT]];
        request_11=[ASIFormDataRequest requestWithURL:url];
        [request_11 setPostValue:classify.detail_id forKey:@"goods_ids"];
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        
        [request_11 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request_11.tag = 114;
        request_11.delegate =self;
        [request_11 setDidFailSelector:@selector(after_urlRequestFailed:)];
        [request_11 setDidFinishSelector:@selector(after_urlRequestSucceeded:)];
        [request_11 startAsynchronous];
        
        status = [dicBig objectForKey:@"status"];
        if([status isEqualToString:@"F码"]){
            FCode_bottomView.hidden = NO;
            FBuyView.hidden = NO;
        }else{
            FCode_bottomView.hidden = YES;
            FBuyView.hidden = YES;
        }
        
        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
            if ([[dicBig objectForKey:@"goods_inventory"] intValue]<=0) {
                btnAddCar.backgroundColor = [UIColor lightGrayColor];
                btnAddCar.enabled = NO;
                button2add.enabled = NO;
                button2add.backgroundColor = [UIColor lightGrayColor];
                btn2Qing.enabled = NO;
                btn2Qing.backgroundColor = [UIColor lightGrayColor];
                btn22Qing.enabled = NO;
                btn22Qing.backgroundColor = [UIColor lightGrayColor];
            }else{
                btnAddCar.backgroundColor = [UIColor orangeColor];
                btnAddCar.enabled = YES;
                button2add.enabled = YES;
                button2add.backgroundColor = [UIColor orangeColor];
                btn2Qing.backgroundColor = MY_COLOR;
                btn2Qing.enabled = YES;
                btn22Qing.backgroundColor = MY_COLOR;
                btn22Qing.enabled = YES;
            }
        }else{
            if ([[dicBig objectForKey:@"goods_inventory"] intValue]<=0) {
                btnAddCar.backgroundColor = [UIColor lightGrayColor];
                btnAddCar.enabled = NO;
                button2add.enabled = NO;
                button2add.backgroundColor = [UIColor lightGrayColor];
                btn2Qing.enabled = NO;
                btn2Qing.backgroundColor = [UIColor lightGrayColor];
                btn22Qing.enabled = NO;
                btn22Qing.backgroundColor = [UIColor lightGrayColor];
            }else{
                btnAddCar.backgroundColor = [UIColor orangeColor];
                btnAddCar.enabled = YES;
                button2add.enabled = YES;
                button2add.backgroundColor = [UIColor orangeColor];
                btn2Qing.backgroundColor = MY_COLOR;
                btn2Qing.enabled = YES;
                btn22Qing.backgroundColor = MY_COLOR;
                btn22Qing.enabled = YES;
            }
        }
        [dataArray addObject:classify];
    }
    [self checkPreorder];
    [MyTableView reloadData];
    
    //发起请求运费
    SecondViewController *sec = [SecondViewController sharedUserDefault];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,TRANS_FEE_URL]];
    request_12=[ASIFormDataRequest requestWithURL:url];
    NSArray * array = [regionStr componentsSeparatedByString:@">"];
    NSString *di = [NSString stringWithFormat:@"%@%@%@",[array objectAtIndex:0],[array objectAtIndex:1],[array objectAtIndex:2]];
    [request_12 setPostValue:sec.detail_id forKey:@"goods_id"];
    [request_12 setPostValue:(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)di,NULL,NULL,kCFStringEncodingUTF8)) forKey:@"current_city"];
    
    [request_12 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_12.delegate = self;
    [request_12 setDidFailSelector:@selector(transfee_urlRequestFailed:)];
    [request_12 setDidFinishSelector:@selector(transfee_urlRequestSucceeded:)];
    [request_12 startAsynchronous];
    
}
-(void)after_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)after_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"付款判断:%@",dicBig);
        if([[dicBig objectForKey:@"can_pay" ] intValue] == 1){
            afterTag =[[dicBig objectForKey:@"can_pay" ] intValue];
        }else{
            afterTag =[[dicBig objectForKey:@"can_pay" ] intValue];
        }
        [SYObject endLoading];
    }
    
}
-(void)userlevel2_urlRequestFailed:(ASIHTTPRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)userlevel2_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"会员等级:%@",dicBig);
        userLeve = [dicBig objectForKey:@"level_name"];
        act_rate = [[dicBig objectForKey:@"act_rate"] floatValue];
    }
    [MyTableView reloadData];
    
}
-(void)maylike_urlRequestFailed:(ASIHTTPRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)maylike_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"12-dicBig:%@",dicBig);
        if (dicBig) {
            if (maylikeArray.count!=0) {
                [maylikeArray removeAllObjects];
            }
            NSArray *arrList = [dicBig objectForKey:@"goods_list"];
            for(NSDictionary *dic in arrList){
                ClassifyModel *class = [[ClassifyModel alloc]init];
                class.detail_goods_main_photo = [dic objectForKey:@"goods_main_photo"];
                class.detail_goods_name = [dic objectForKey:@"name"];
                class.detail_goods_main_name = [dic objectForKey:@"name"];
                class.detail_goods_main_id = [dic objectForKey:@"id"];
                [maylikeArray addObject:class];
            }
        }
    }
    [MyTableView reloadData];
}
-(void)my213_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"result=%@", dicBig);
        if (regionArray.count!=0) {
            [regionArray removeAllObjects];
        }
        if (dicBig) {
            [SYObject endLoading];
            RegoinTableView.userInteractionEnabled = YES;
            NSArray *arr = [dicBig objectForKey:@"area_list"];
            if (arr.count==0) {
                //消失
                regionView.hidden = YES;
                
//                存本地area_id
                NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
                NSArray *array=[regionIdStr componentsSeparatedByString:@","];
                if (array.count>2) {
                    [standard setObject:array[2] forKey:@"area_id"];
                    [standard synchronize];
                }
                //取出第一个之后 发起请求库存
                SecondViewController *sec = [SecondViewController sharedUserDefault];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,SPECIFICATIONSBACK_URL]];
                request_24=[ASIFormDataRequest requestWithURL:url];
                if (specSelectArray.count!=0) {
                    NSString *str;
                    for(int i=0;i<specSelectArray.count;i++){
                        if (str.length == 0) {
                            str = [[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2];
                        }else{
                            str = [NSString stringWithFormat:@"%@,%@",str,[[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2]];
                        }
                    }
                    [request_24 setPostValue:str forKey:@"gsp"];
                }
                
                [request_24 setPostValue:sec.detail_id forKey:@"id"];
                NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *documentsPath = [docPath objectAtIndex:0];
                NSString *readPath = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:readPath];
                NSFileManager *fileManagerDong = [NSFileManager defaultManager];
                if([fileManagerDong fileExistsAtPath:readPath] == NO){
                    
                    [request_24 setPostValue:@"" forKey:@"user_id"];
                    [request_24 setPostValue:@"" forKey:@"token"];
                }else{
                    [request_24 setPostValue:[fileContent objectAtIndex:3] forKey:@"user_id"];
                    [request_24 setPostValue:[fileContent objectAtIndex:1] forKey:@"token"];
                }
                

                //                读取本地id
                //                NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
                NSString *areaId=[standard objectForKey:@"area_id"];
                [request_24 setPostValue:areaId forKey:@"area_id"];
                
                [request_24 setRequestHeaders:[LJControl requestHeaderDictionary]];
                request_24.tag = 114;
                request_24.delegate =self;
                [request_24 setDidFailSelector:@selector(spec3_urlRequestFailed:)];
                [request_24 setDidFinishSelector:@selector(spec3_urlRequestSucceeded:)];
                [request_24 startAsynchronous];
                
                //发起请求运费
                NSArray *arr = [regionStr componentsSeparatedByString:@">"];
//                SecondViewController *sec = [SecondViewController sharedUserDefault];
                NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,TRANS_FEE_URL]];
                request_14=[ASIFormDataRequest requestWithURL:url1];
                [request_14 setPostValue:sec.detail_id forKey:@"goods_id"];
                [request_14 setPostValue:[arr objectAtIndex:1] forKey:@"current_city"];
                
                [request_14 setRequestHeaders:[LJControl requestHeaderDictionary]];
                request_14.tag = 109;
                request_14.delegate = self;
                [request_14 setDidFailSelector:@selector(transfee_urlRequestFailed:)];
                [request_14 setDidFinishSelector:@selector(transfee_urlRequestSucceeded:)];
                [request_14 startAsynchronous];
            }else{
                for(NSDictionary *dic in arr){
                    ClassifyModel *model = [[ClassifyModel alloc]init];
                    model.region_name = [dic objectForKey:@"name"];
                    model.region_id = [dic objectForKey:@"id"];
                    [regionArray addObject:model];
                }
            }
        }
        selectRegionIndex = -1;
        [RegoinTableView reloadData];
        
    }
    else{
        [SYObject failedPrompt:@"请求出错"];
    }
}
-(void)my213_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)attentiondel_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)attentiondel_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"5-dicBig:%@",dicBig);
        if ([[dicBig objectForKey:@"code"] intValue]==100) {
            favouiteBool = NO;
            labeHeart2.image = [UIImage imageNamed:@"sc_new"];
            labeHeart3.image = [UIImage imageNamed:@"sc_new"];
            [SYObject failedPrompt:@"操作成功"];
            favouiteBool = NO;
        }else if ([[dicBig objectForKey:@"code"] intValue]==-500){
            //-500请求错误
            labeHeart2.image = [UIImage imageNamed:@"qx_new"];
            labeHeart3.image = [UIImage imageNamed:@"qx_new"];
            favouiteBool = YES;
            [SYObject failedPrompt:@"请求出错"];
        }else if ([[dicBig objectForKey:@"code"] intValue]==-400){
            //--400用户信息错误
            labeHeart2.image = [UIImage imageNamed:@"qx_new"];
            labeHeart3.image = [UIImage imageNamed:@"qx_new"];
            favouiteBool = YES;
            [SYObject failedPrompt:@"用户信息错误"];
        }
        else if ([[dicBig objectForKey:@"code"] intValue]==300){
            //300删除成功
            labeHeart2.image = [UIImage imageNamed:@"sc_new"];
            labeHeart3.image = [UIImage imageNamed:@"sc_new"];
            [SYObject failedPrompt:@"取消收藏"];
            favouiteBool = NO;
        }
      [SYObject endLoading];
    }
    else{
        [SYObject endLoading];
    }
}
-(void)spec2_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}

-(void)spec2_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"13-dicBig:%@",dicBig);
        if (specificationsArray.count!=0) {
            [specificationsArray removeAllObjects];
        }
        if (specSelectArray.count!=0) {
            [specSelectArray removeAllObjects];
        }
        if (!_specIdsString) {
            _specIdsString=[[NSMutableString alloc]init];
        }
        NSArray *arr = [dicBig objectForKey:@"spec_list"];
        NSString *spec;
        for(NSDictionary *dic in arr){
            ClassifyModel *classify = [[ClassifyModel alloc]init];
            classify.specifications_spec_key = [dic objectForKey:@"spec_key"];
            if (spec.length == 0) {
                spec = [NSString stringWithFormat:@"%@",[[[dic objectForKey:@"spec_values"] objectAtIndex:0] objectForKey:@"id"]];
            }else{
                spec = [NSString stringWithFormat:@"%@,%@",spec,[[[dic objectForKey:@"spec_values"] objectAtIndex:0] objectForKey:@"id"]];
            }
            classify.specifications_spec_type =  [dic objectForKey:@"spec_type"];
            classify.specifications_spec_values =  [dic objectForKey:@"spec_values"];
            
            NSString *str = [NSString stringWithFormat:@"%@~%@~%@",[dic objectForKey:@"spec_key"],[[classify.specifications_spec_values objectAtIndex:0]objectForKey:@"val"],[[classify.specifications_spec_values objectAtIndex:0]objectForKey:@"id"]];
            [specSelectArray addObject:str];
            
            [specificationsArray addObject:classify];
            
            if (_specIdsString.length == 0) {
                [_specIdsString  setString:[NSString stringWithFormat:@"%@",[[[dic objectForKey:@"spec_values"] objectAtIndex:0] objectForKey:@"id"]]];
            }else{
                [_specIdsString  setString:[NSString stringWithFormat:@"%@,%@",_specIdsString,[[[dic objectForKey:@"spec_values"] objectAtIndex:0] objectForKey:@"id"]]];
            }
            
        }
        //00025
        SecondViewController *sec = [SecondViewController sharedUserDefault];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,SPECIFICATIONSBACK_URL]];
        request_24=[ASIFormDataRequest requestWithURL:url];
        if (specSelectArray.count!=0) {
            NSString *str;
            for(int i=0;i<specSelectArray.count;i++){
                if (str.length == 0) {
                    str = [[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2];
                }else{
                    str = [NSString stringWithFormat:@"%@,%@",str,[[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2]];
                }
            }
            [request_24 setPostValue:str forKey:@"gsp"];
        }
        
        [request_24 setPostValue:sec.detail_id forKey:@"id"];
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *readPath = [documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:readPath];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        if([fileManagerDong fileExistsAtPath:readPath] == NO){
           
            [request_24 setPostValue:@"" forKey:@"user_id"];
            [request_24 setPostValue:@"" forKey:@"token"];
        }else{
            [request_24 setPostValue:[fileContent objectAtIndex:3] forKey:@"user_id"];
            [request_24 setPostValue:[fileContent objectAtIndex:1] forKey:@"token"];
        }
       
        
       
        ///读取本地id
        NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
        NSString *areaId=[standard objectForKey:@"area_id"];
        [request_24 setPostValue:areaId forKey:@"area_id"];
        
        [request_24 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request_24.tag = 114;
        request_24.delegate =self;
        [request_24 setDidFailSelector:@selector(spec3_urlRequestFailed:)];
        [request_24 setDidFinishSelector:@selector(spec3_urlRequestSucceeded:)];
        [request_24 startAsynchronous];

        
        
    }
    [MyTableView reloadData];
    [SYObject endLoading];
}
-(void)spec3_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)spec3_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"14-dicBig:%@",dicBig);
        if (dataArray.count!= 0) {
            ClassifyModel *class = [dataArray objectAtIndex:0];
            class.detail_goods_inventory = [dicBig objectForKey:@"count"];
            if ([[dicBig objectForKey:@"act_price"]integerValue]<=0) {
                 class.detail_goods_current_price = [dicBig objectForKey:@"price"];
            }else{
                class.detail_goods_current_price = [dicBig objectForKey:@"act_price"];
            }
            
            if ([[dicBig objectForKey:@"count"]intValue]>0) {
                btnAddCar.enabled = YES;
                btnAddCar.backgroundColor = [UIColor orangeColor];
                button2add.enabled = YES;
                button2add.backgroundColor = [UIColor orangeColor];
                btn2Qing.backgroundColor = MY_COLOR;
                btn2Qing.enabled = YES;
                btn22Qing.backgroundColor = MY_COLOR;
                btn22Qing.enabled = YES;
            }else{
                btnAddCar.enabled = NO;
                btnAddCar.backgroundColor = [UIColor lightGrayColor];
                button2add.enabled = NO;
                button2add.backgroundColor = [UIColor lightGrayColor];
                btn2Qing.backgroundColor = [UIColor lightGrayColor];
                btn2Qing.enabled = NO;
                btn22Qing.backgroundColor = [UIColor lightGrayColor];
                btn22Qing.enabled = NO;
            }
            UILabel *stocklabel=(UILabel *)[_specifView viewWithTag:1002];
            stocklabel.text=[NSString stringWithFormat:@"库存：%@件",class.detail_goods_inventory];
            UILabel *pricelabel=(UILabel *)[_specifView viewWithTag:1001];
            pricelabel.text=[NSString stringWithFormat:@"￥:%0.2f",[class.detail_goods_current_price floatValue]];
            [MyTableView reloadData];
        }
        [SYObject endLoading];
    }
    
}
-(void)addCaroff_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    btnAddCar.enabled = YES;
    button2add.enabled = YES;
    loadingV.hidden=YES;
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"15-dicBig:%@",dicBig);
        if (dicBig) {
            if ([[dicBig objectForKey:@"code"] intValue] ==0||[[dicBig objectForKey:@"code"] intValue] ==1||[[dicBig objectForKey:@"code"] intValue] ==2) {
                NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *documentsPath = [docPath objectAtIndex:0];
                NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
                NSFileManager *fileManagerDong = [NSFileManager defaultManager];
                if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
                    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                    NSString *filePaht = [documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
                    // NSArray *array = [NSArray arrayWithObjects:[dicBig objectForKey:@"cart_mobile_id"], nil];
                    NSArray *array = [NSArray arrayWithObjects:[dicBig objectForKey:@"cart_id"], nil];
                    [array writeToFile:filePaht atomically:NO];
                }else{
                    //遍历文件内容 进行跟新
                    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
                    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                    NSString *str = [fileContent2 objectAtIndex:0];
                    //                str = [NSString stringWithFormat:@"%@,%@",str,[dicBig objectForKey:@"cart_mobile_id"]];
                    str = [NSString stringWithFormat:@"%@,%@",str,[dicBig objectForKey:@"cart_id"]];
                    NSArray *array = [NSArray arrayWithObjects:str, nil];
                    [array writeToFile:readPath2 atomically:NO];
                }
                
                [OHAlertView showAlertWithTitle:@"添加成功！" message:@"已成功加入购物车" cancelButton:nil otherButtons:@[@"去购物车",@"再逛逛"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                    if(buttonIndex==0){
                        [self goCart];
                    }else{
                    }
                }];
                NSArray *docPath1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *documentsPath1 = [docPath1 objectAtIndex:0];
                NSString *filePathDong1=[documentsPath1 stringByAppendingPathComponent:@"information.txt"];
                NSFileManager *fileManagerDong1 = [NSFileManager defaultManager];
                if([fileManagerDong1 fileExistsAtPath:filePathDong1]==NO){
                    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,MYCAR_URL]];
                    request_27=[ASIFormDataRequest requestWithURL:url3];
                    [request_27 setPostValue:@"" forKey:@"user_id"];
                    [request_27 setPostValue:@"" forKey:@"token"];
                    
                    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
                    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
                    if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
                        [request_27 setPostValue:@"" forKey:@"cart_mobile_ids"];
                    }else{
                        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
                        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                        [request_27 setPostValue:[fileContent2 objectAtIndex:0] forKey:@"cart_mobile_ids"];
                    }
                    
                    [request_27 setRequestHeaders:[LJControl requestHeaderDictionary]];
                    request_27.tag = 101;
                    request_27.delegate =self;
                    [request_27 setDidFailSelector:@selector(carCountoff_urlRequestFailed:)];
                    [request_27 setDidFinishSelector:@selector(carCountoff_urlRequestSucceeded:)];
                    [request_27 startAsynchronous];
                    
                }else{
                    //发起得到购物车数量的请求
                    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,CARGOODS_COUNT]];
                    request_28=[ASIFormDataRequest requestWithURL:url2];
                    if([fileManagerDong fileExistsAtPath:filePathDong] == NO){
                        [request_28 setPostValue:@"" forKey:@"user_id"];
                        [request_28 setPostValue:@"" forKey:@"token"];
                    }else{
                        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                        [request_28 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
                        [request_28 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
                    }
                    [request_28 setRequestHeaders:[LJControl requestHeaderDictionary]];
                    request_28.tag = 102;
                    request_28.delegate =self;
                    [request_28 setDidFailSelector:@selector(carCounton_urlRequestFailed:)];
                    [request_28 setDidFinishSelector:@selector(carCounton_urlRequestSucceeded:)];
                    [request_28 startAsynchronous];
                }
            }else if([[dicBig objectForKey:@"code"] intValue] ==-1){
                [SYObject failedPrompt:@"添加失败"];
            }else if([[dicBig objectForKey:@"code"] intValue] ==-2){
                [SYObject failedPrompt:@"商品下架，添加失败"];
            }else if([[dicBig objectForKey:@"code"] intValue] ==-3){
                [SYObject failedPrompt:@"库存不足，添加失败"];
            }else if([[dicBig objectForKey:@"code"] intValue] ==-4){
                [SYObject failedPrompt:@"超过限购数量，添加失败"];
            }else if([[dicBig objectForKey:@"code"] intValue] ==-5){
                [OHAlertView showAlertWithTitle:@"温馨提示" message:@"该商品为限购商品，请登录" cancelButton:nil otherButtons:@[@"登录",@"取消"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                    if(buttonIndex==0){
                        NewLoginViewController *new = [[NewLoginViewController alloc]initWithNibName:@"NewLoginViewController" bundle:nil];
                        [self.navigationController pushViewController:new animated:YES];
                    }else{
                    }
                }];

            }
        }
    }
    [SYObject endLoading];
    [MyTableView reloadData];
}
-(void)carCountoff_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)carCountoff_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSInteger countShu = 0;
        if (dicBig) {
            //拿到普通的没有活动的
            NSArray *arr = [dicBig objectForKey:@"cart_list"];
            countShu = countShu+arr.count;
            //拿到有活动的key
            NSArray *arrlist = [dicBig objectForKey:@"discount_list"];
            
            for(int i=0;i<arrlist.count;i++){
                NSDictionary *dic = [dicBig objectForKey:[arrlist objectAtIndex:i]];
                NSArray *arr2list = [dic objectForKey:@"goods_list"];
                countShu  = countShu + arr2list.count;
            }
        }
        
        UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:2];
        item.badgeValue = [NSString stringWithFormat:@"%ld",(long)countShu];
        //删除cart文件
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
            
        }else{
            //删除文件
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            NSString *MapLayerDataPath2 = [documentsDirectory stringByAppendingPathComponent:@"cart_mobile_id.txt"];
            BOOL bRet2 = [fileMgr fileExistsAtPath:MapLayerDataPath2];
            if (bRet2) {
                NSError *err;
                [fileMgr removeItemAtPath:MapLayerDataPath2 error:&err];
            }
        }
        
        [SYObject endLoading];
    }
    else{
        [SYObject endLoading];
    }
    
}
-(void)carCounton_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)carCounton_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"16-dicBig:%@",dicBig);
        UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:2];
        item.badgeValue = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"count"]];
        
    }
    loadingV.hidden= YES;
    
}
-(void)addCaroff_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)addCaron_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    btnAddCar.enabled = YES;
    button2add.enabled = YES;
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"17-dicBig:%@",dicBig);
        if (dicBig) {
            if ([[dicBig objectForKey:@"code"] intValue] ==0) {
                [OHAlertView showAlertWithTitle:@"添加成功！" message:@"已成功加入购物车" cancelButton:nil otherButtons:@[@"去购物车",@"再逛逛"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                    if(buttonIndex==0){
                        [self goCart];
                    }else{
                    }
                }];
                NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *documentsPath = [docPath objectAtIndex:0];
                NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
                NSFileManager *fileManagerDong = [NSFileManager defaultManager];
                if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
                    
                    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,MYCAR_URL]];
                    request_29=[ASIFormDataRequest requestWithURL:url3];
                    [request_29 setPostValue:@"" forKey:@"user_id"];
                    [request_29 setPostValue:@"" forKey:@"token"];
                    
                    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
                    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
                    if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
                        [request_29 setPostValue:@"" forKey:@"cart_mobile_ids"];
                    }else{
                        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
                        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                        [request_29 setPostValue:[fileContent2 objectAtIndex:0] forKey:@"cart_mobile_ids"];
                    }
                    
                    [request_29 setRequestHeaders:[LJControl requestHeaderDictionary]];
                    request_29.tag = 101;
                    request_29.delegate = self;
                    [request_29 setDidFailSelector:@selector(carCountoff_urlRequestFailed:)];
                    [request_29 setDidFinishSelector:@selector(carCountoff_urlRequestSucceeded:)];
                    [request_29 startAsynchronous];
                }else{
                    //发起得到购物车数量的请求
                    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,CARGOODS_COUNT]];
                    request_30=[ASIFormDataRequest requestWithURL:url2];
                    if([fileManagerDong fileExistsAtPath:filePathDong] == NO){
                        [request_30 setPostValue:@"" forKey:@"user_id"];
                        [request_30 setPostValue:@"" forKey:@"token"];
                    }else{
                        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                        [request_30 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
                        [request_30 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
                    }
                    
                    [request_30 setRequestHeaders:[LJControl requestHeaderDictionary]];
                    request_30.tag = 102;
                    request_30.delegate = self;
                    [request_30 setDidFailSelector:@selector(goodsCount_urlRequestFailed:)];
                    [request_30 setDidFinishSelector:@selector(goodsCount_urlRequestSucceeded:)];
                    [request_30 startAsynchronous];
                }
            }else if ([[dicBig objectForKey:@"code"] intValue] ==-1){
                [SYObject failedPrompt:@"加入购物车失败"];
            }else{
                [SYObject failedPrompt:@"添加失败"];
            }
        }
    }
    [MyTableView reloadData];
    [SYObject endLoading];
}
-(void)goodsCount_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)goodsCount_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if(statuscode2 == 200){
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"18-dicBig:%@",dicBig);
        UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:2];
        if ([[dicBig objectForKey:@"count"]integerValue] != 0) {
            item.badgeValue = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"count"]];
        }else {
            item.badgeValue = nil;
        }
        
    }
}
-(void)addCaron_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)Fcodeon_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)Fcodeon_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    btnAddCar.enabled = YES;
    button2add.enabled = YES;
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"19-dicBig:%@",dicBig);
        if (dicBig) {
            if ([[dicBig objectForKey:@"ret"] intValue] ==1) {
                [SYObject failedPrompt:@"已成功加入购物车"];
                //发起购物车数量的请求
                [OHAlertView showAlertWithTitle:@"添加成功！" message:@"已成功加入购物车" cancelButton:nil otherButtons:@[@"去购物车",@"再逛逛"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                    if(buttonIndex==0){
                        [self goCart];
                    }else{
                    }
                }];

                
                FCodeView.hidden = YES;
                for (UIView *subView in FCodeView.subviews)
                {
                    [subView removeFromSuperview];
                }
                
                NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *documentsPath = [docPath objectAtIndex:0];
                NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
                NSFileManager *fileManagerDong = [NSFileManager defaultManager];
                if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
                    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,MYCAR_URL]];
                    request_33=[ASIFormDataRequest requestWithURL:url3];
                    [request_33 setPostValue:@"" forKey:@"user_id"];
                    [request_33 setPostValue:@"" forKey:@"token"];
                    
                    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
                    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
                    if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
                        [request_33 setPostValue:@"" forKey:@"cart_mobile_ids"];
                    }else{
                        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
                        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                        [request_33 setPostValue:[fileContent2 objectAtIndex:0] forKey:@"cart_mobile_ids"];
                    }
                    
                    [request_33 setRequestHeaders:[LJControl requestHeaderDictionary]];
                    request_33.tag = 101;
                    request_33.delegate = self;
                    [request_33 setDidFailSelector:@selector(carCountoff_urlRequestFailed:)];
                    [request_33 setDidFinishSelector:@selector(carCountoff_urlRequestSucceeded:)];
                    [request_33 startAsynchronous];
                }else{
                    //发起得到购物车数量的请求
                    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,CARGOODS_COUNT]];
                    request_34=[ASIFormDataRequest requestWithURL:url2];
                    if([fileManagerDong fileExistsAtPath:filePathDong] == NO){
                        [request_34 setPostValue:@"" forKey:@"user_id"];
                        [request_34 setPostValue:@"" forKey:@"token"];
                    }else{
                        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                        [request_34 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
                        [request_34 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
                    }
                    
                    [request_34 setRequestHeaders:[LJControl requestHeaderDictionary]];
                    request_34.tag = 102;
                    request_34.delegate = self;
                    [request_34 setDidFailSelector:@selector(goodsCount_urlRequestFailed:)];
                    [request_34 setDidFinishSelector:@selector(goodsCount_urlRequestSucceeded:)];
                    [request_34 startAsynchronous];
                }
            }else{
                [SYObject failedPrompt:@"F码不正确"];
            }
        }
    }
    [MyTableView reloadData];
    
}
-(void)Fcodeoff_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)Fcodeoff_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    btnAddCar.enabled = YES;
    button2add.enabled = YES;
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"20-dicBig:%@",dicBig);
        if (dicBig) {
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
            NSFileManager *fileManagerDong = [NSFileManager defaultManager];
            if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
                NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                NSString *filePaht = [documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
                 NSArray *array = [NSArray arrayWithObjects:[dicBig objectForKey:@"cart_id"], nil];
                [array writeToFile:filePaht atomically:NO];
            }else{
                //遍历文件内容 进行跟新
                NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
                NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                NSString *str = [fileContent2 objectAtIndex:0];
                str = [NSString stringWithFormat:@"%@,%@",str,[dicBig objectForKey:@"cart_id"]];
                NSArray *array = [NSArray arrayWithObjects:str, nil];
                [array writeToFile:readPath2 atomically:NO];
            }
            if ([[dicBig objectForKey:@"ret"] intValue] ==0) {
                [SYObject failedPrompt:@"已成功加入购物车"];
                //
                [OHAlertView showAlertWithTitle:@"添加成功！" message:@"已成功加入购物车" cancelButton:nil otherButtons:@[@"去购物车",@"再逛逛"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                    if(buttonIndex==0){
                        [self goCart];
                    }else{
                    }
                }];

                
                FCodeView.hidden = YES;
                for (UIView *subView in FCodeView.subviews)
                {
                    [subView removeFromSuperview];
                }
                
                NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *documentsPath = [docPath objectAtIndex:0];
                NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
                NSFileManager *fileManagerDong = [NSFileManager defaultManager];
                if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
                    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,MYCAR_URL]];
                    request_35=[ASIFormDataRequest requestWithURL:url3];
                    [request_35 setPostValue:@"" forKey:@"user_id"];
                    [request_35 setPostValue:@"" forKey:@"token"];
                    
                    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
                    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
                    if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
                        [request_35 setPostValue:@"" forKey:@"cart_mobile_ids"];
                    }else{
                        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
                        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                        [request_35 setPostValue:[fileContent2 objectAtIndex:0] forKey:@"cart_mobile_ids"];
                    }
                    
                    [request_35 setRequestHeaders:[LJControl requestHeaderDictionary]];
                    request_35.tag = 101;
                    request_35.delegate = self;
                    [request_35 setDidFailSelector:@selector(carCountoff_urlRequestFailed:)];
                    [request_35 setDidFinishSelector:@selector(carCountoff_urlRequestSucceeded:)];
                    [request_35 startAsynchronous];
                    
                }else{
                    //发起得到购物车数量的请求
                    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,CARGOODS_COUNT]];
                    request_36=[ASIFormDataRequest requestWithURL:url2];
                    if([fileManagerDong fileExistsAtPath:filePathDong] == NO){
                        [request_36 setPostValue:@"" forKey:@"user_id"];
                        [request_36 setPostValue:@"" forKey:@"token"];
                    }else{
                        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                        [request_36 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
                        [request_36 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
                    }
                    
                    [request_36 setRequestHeaders:[LJControl requestHeaderDictionary]];
                    request_36.tag = 102;
                    [request_36 setDidFailSelector:@selector(goodsCount_urlRequestFailed:)];
                    [request_36 setDidFinishSelector:@selector(goodsCount_urlRequestSucceeded:)];
                    [request_36 startAsynchronous];
                }
            }else{
                [SYObject failedPrompt:@"F码不正确"];
            }
        }
    }
    [MyTableView reloadData];
    
}
-(void)esaypay_urlRequestSucceeded:(ASIFormDataRequest *)request{
     [SYObject endLoading];
    int statuscode2 = [request responseStatusCode];
    btn2Qing.enabled = YES;
    btn22Qing.enabled = YES;
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"1_dicBig:%@",dicBig);
        if (dicBig) {
            if ([[dicBig objectForKey:@"code"] intValue] ==0) {
                [self getSettlementProcessCartIds:[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"cart_id"]]];
                
            }else{
                [SYObject failedPrompt:@"该用户无法继续购买"];
            }
        }
    }
}
-(void)esaypay_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)attentionadd_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        [SYObject endLoading];
        NSLog(@"2-dicBig:%@",dicBig);
        if ([[dicBig objectForKey:@"code"]intValue] == 100) {
            [SYObject failedPrompt:@"已成功收藏"];
            labeHeart2.image = [UIImage imageNamed:@"qx_new"];
            labeHeart3.image = [UIImage imageNamed:@"qx_new"];
            favouiteBool = YES;
        }else if ([[dicBig objectForKey:@"code"]intValue] == -500) {
            [SYObject failedPrompt:@"收藏失败"];
        }else if ([[dicBig objectForKey:@"code"]intValue] == -400) {
            [SYObject failedPrompt:@"收藏失败"];
        }else if ([[dicBig objectForKey:@"code"]intValue] == -300) {
            [SYObject failedPrompt:@"已收藏过该商品"];
        }else{
            [SYObject failedPrompt:@"成功收藏"];
            labeHeart2.image = [UIImage imageNamed:@"qx_new"];
            labeHeart3.image = [UIImage imageNamed:@"qx_new"];

            favouiteBool = YES;
        }
        
    }
    [MyTableView reloadData];
}
-(void)attentionadd_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)region1_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)region1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"3-dicBig:%@",dicBig);
        if (regionArray.count!=0) {
            [regionArray removeAllObjects];
        }
        if (dicBig) {
            RegoinTableView.userInteractionEnabled = YES;
            NSArray *arr = [dicBig objectForKey:@"area_list"];
            if (arr.count==0) {
                //消失
                regionView.hidden = YES;
                
                //存本地area_id
                NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
                NSArray *array=[regionIdStr componentsSeparatedByString:@","];
                if (array.count>1) {
                    [standard setObject:array[1] forKey:@"area_id"];
                    [standard synchronize];
                }
                
                //取出第一个之后 发起请求库存
                SecondViewController *sec = [SecondViewController sharedUserDefault];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,SPECIFICATIONSBACK_URL]];
                request_24=[ASIFormDataRequest requestWithURL:url];
                if (specSelectArray.count!=0) {
                    NSString *str;
                    for(int i=0;i<specSelectArray.count;i++){
                        if (str.length == 0) {
                            str = [[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2];
                        }else{
                            str = [NSString stringWithFormat:@"%@,%@",str,[[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2]];
                        }
                    }
                    [request_24 setPostValue:str forKey:@"gsp"];
                }
                
                [request_24 setPostValue:sec.detail_id forKey:@"id"];
                NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *documentsPath = [docPath objectAtIndex:0];
                NSString *readPath = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:readPath];
                NSFileManager *fileManagerDong = [NSFileManager defaultManager];
                if([fileManagerDong fileExistsAtPath:readPath] == NO){
                    
                    [request_24 setPostValue:@"" forKey:@"user_id"];
                    [request_24 setPostValue:@"" forKey:@"token"];
                }else{
                    [request_24 setPostValue:[fileContent objectAtIndex:3] forKey:@"user_id"];
                    [request_24 setPostValue:[fileContent objectAtIndex:1] forKey:@"token"];
                }
                

//                读取本地id
//                NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
                NSString *areaId=[standard objectForKey:@"area_id"];
                [request_24 setPostValue:areaId forKey:@"area_id"];
                
                [request_24 setRequestHeaders:[LJControl requestHeaderDictionary]];
                request_24.tag = 114;
                request_24.delegate =self;
                [request_24 setDidFailSelector:@selector(spec3_urlRequestFailed:)];
                [request_24 setDidFinishSelector:@selector(spec3_urlRequestSucceeded:)];
                [request_24 startAsynchronous];

                
                //发起请求运费
                NSArray *arr = [regionStr componentsSeparatedByString:@">"];
//                SecondViewController *sec = [SecondViewController sharedUserDefault];
                NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,TRANS_FEE_URL]];
                request_47=[ASIFormDataRequest requestWithURL:url1];
                [request_47 setPostValue:sec.detail_id forKey:@"goods_id"];
                [request_47 setPostValue:[arr objectAtIndex:1] forKey:@"current_city"];
                
                [request_47 setRequestHeaders:[LJControl requestHeaderDictionary]];
                request_47.tag = 109;
                request_47.delegate = self;
                [request_47 setDidFailSelector:@selector(transfee_urlRequestFailed:)];
                [request_47 setDidFinishSelector:@selector(transfee_urlRequestSucceeded:)];
                [request_47 startAsynchronous];
            }else{
                for(NSDictionary *dic in arr){
                    ClassifyModel *model = [[ClassifyModel alloc]init];
                    model.region_name = [dic objectForKey:@"name"];
                    model.region_id = [dic objectForKey:@"id"];
                    [regionArray addObject:model];
                }
            }
        }
        selectRegionIndex = -1;
        [RegoinTableView reloadData];
    }
    [SYObject endLoading];
}
-(void)transfee_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)transfee_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"4-dicBig:%@",dicBig);
        feetext = [dicBig objectForKey:@"trans_information"];
        
    }
    [MyTableView reloadData];
}
-(void)getSettlementProcessCartIds:(NSString *)cartIds{
    //发起结算请求
    [SYObject startLoading];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,CAR_UP_ORDER_URL]];
    ASIFormDataRequest * request=[ASIFormDataRequest requestWithURL:url];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:readPath];
    [request setPostValue:[fileContent objectAtIndex:3] forKey:@"user_id"];
    [request setPostValue:[fileContent objectAtIndex:1] forKey:@"token"];
    [request setPostValue:cartIds forKey:@"cart_ids"];
    [request setRequestHeaders:[LJControl requestHeaderDictionary]];
    request.tag=1000;
    [request setDelegate:self];
    [request startAsynchronous];
}
#pragma mark- ASIHTTPRequestDelegate
-(void)requestFinished:(ASIHTTPRequest *)request{
    NSDictionary *dicBig=[NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
    NSLog(@"得到增值税、、、%@",dicBig);
    if (request.tag==1000) {
         ThirdViewController *third = [ThirdViewController sharedUserDefault];
        third.jie_cart_ids = [dicBig objectForKey:@"cart_ids"];
        
//        ClassifyModel *classify = [dataArray objectAtIndex:0];
        
        third.jie_order_goods_price = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"order_goods_price"]];
        if ([[dicBig allKeys] containsObject:@"reduce"]){
            third.jie_reduce = [[dicBig objectForKey:@"reduce"] intValue];
        }else{
           third.jie_reduce = 0;
        }
        third.jie_store_ids = [dicBig objectForKey:@"store_ids"];
        if([[dicBig allKeys]containsObject:@"vatInvoice"])
        {
            third.ticBOOL=YES;
            third.ticdic=[dicBig objectForKey:@"vatInvoice"];
        
        }else
        {
            third.ticBOOL=NO;
        
        }
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
//            third.jie_order_goods_price = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"order_goods_price"]];
            [self.navigationController popToRootViewControllerAnimated:YES];
            self.tabBarController.selectedIndex = 4;
        }else{
//            if ([classify.detail_status isEqualToString:@"促销"]) {
//                CGFloat rate=act_rate *0.1;
//                NSString *rate1=[NSString stringWithFormat:@"%0.2f",rate];
//                third.jie_order_goods_price = [NSString stringWithFormat:@"%0.2f",[[dicBig objectForKey:@"order_goods_price"] floatValue]* [rate1 floatValue]];
//            }else{
//                third.jie_order_goods_price = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"order_goods_price"]];
//            }
             ClassifyModel *classify = [dataArray objectAtIndex:0];
            third.jie_order_goods_price = [NSString stringWithFormat:@"%0.2f",[classify.detail_goods_current_price floatValue]];
            
            NSString *statu = classify.detail_goodsstatus_info;
            BOOL preOrder = [statu hasPrefix:@"预售商品"];
            if (preOrder)
            {
             third.jie_order_goods_price = [NSString stringWithFormat:@"%0.2f",[classify.detail_advance_ding floatValue]];
            
            }
            
            writeViewController *write = [[writeViewController alloc]init];
            [self.navigationController pushViewController:write animated:YES];
        }
    }
    [SYObject endLoading];
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"请求错误");
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络正在开小差~~"];
}

#pragma mark - 点击事件
-(IBAction)syShadowClicked:(id)sender{
    UIButton *shadowBtn = sender;
    [shadowBtn.superview removeFromSuperview];
}
//点击评价红粉胖按钮
-(IBAction)evaBtnClicked:(id)sender{
    [SYObject startLoading];
    //按钮tag:全部，514，好评，515，中评516，差评，517。
    UIButton *btn = sender;
    //自动回到顶部
    _evaluateTableView.contentOffset = CGPointMake(0, 0);
    if (_currentEvaBtn!=btn) {
        _currentEvaBtn.selected = NO;
        [_currentEvaBtn setBackgroundColor:_K_Color(255.f, 239.f, 242.f)];
        _currentEvaBtn = btn;
        _currentEvaBtn.selected = YES;
        [_currentEvaBtn setBackgroundColor:_K_Color(229.f, 0.f, 44.f)];
    }
    if (!self.detail_id) {
        return;
    }
    switch (btn.tag) {
        case 514:{
            [SYShopAccessTool getEvaArrUseDetailID:self.detail_id type:SY_SHOP_EVALUATE_TYPE_ALL s:^(NSArray *arr) {
                self.evaluateArray = arr;
                if(arr==nil||arr.count==0){
                    [_evaluateTableView reloadData];
                    _evaluateTableView.backgroundView = _noDataView;
                    [SYObject endLoading];
                }else{
                    _evaluateTableView.backgroundView = nil;
                    [_evaluateTableView reloadData];
                    [SYObject endLoading];
                }
            } f:^(NSString *errStr) {
                NSLog(@"func:evaBtnClicked err:%@",errStr);
            }];
            break;
        }
        case 515:{
            [SYShopAccessTool getEvaArrUseDetailID:self.detail_id type:SY_SHOP_EVALUATE_TYPE_WELL s:^(NSArray *arr) {
                self.evaluateArray = arr;
                if(arr==nil||arr.count==0){
                    [_evaluateTableView reloadData];
                    _evaluateTableView.backgroundView = _noDataView;
                    [SYObject endLoading];
                }else{
                    _evaluateTableView.backgroundView = nil;
                    [_evaluateTableView reloadData];
                    [SYObject endLoading];
                }
            } f:^(NSString *errStr) {
                NSLog(@"func:evaBtnClicked err:%@",errStr);
            }];
            break;
        }
        case 516:{
            [SYShopAccessTool getEvaArrUseDetailID:self.detail_id type:SY_SHOP_EVALUATE_TYPE_MIDDLE s:^(NSArray *arr) {
                self.evaluateArray = arr;
                if(arr==nil||arr.count==0){
                    [_evaluateTableView reloadData];
                    _evaluateTableView.backgroundView = _noDataView;
                    [SYObject endLoading];
                }else{
                    _evaluateTableView.backgroundView = nil;
                    [_evaluateTableView reloadData];
                    [SYObject endLoading];
                }
            } f:^(NSString *errStr) {
                NSLog(@"func:evaBtnClicked err:%@",errStr);
            }];
            break;
        }
        case 517:{
            [SYShopAccessTool getEvaArrUseDetailID:self.detail_id type:SY_SHOP_EVALUATE_TYPE_BAD s:^(NSArray *arr) {
                self.evaluateArray = arr;
                if(arr==nil||arr.count==0){
                    [_evaluateTableView reloadData];
                    _evaluateTableView.backgroundView = _noDataView;
                    [SYObject endLoading];
                }else{
                    _evaluateTableView.backgroundView = nil;
                    [_evaluateTableView reloadData];
                    [SYObject endLoading];
                }
            } f:^(NSString *errStr) {
                NSLog(@"func:evaBtnClicked err:%@",errStr);
            }];
            break;
        }
        default:{
            break;
        }
    }
    
}
-(void)singleTap{
    muchView.hidden = YES;
    muchBool = NO;
    
    myViewBI.hidden = NO;
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height)];
    image.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.8];
    image.userInteractionEnabled = YES;
    [myViewBI addSubview:image];
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    _myScrollView22 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, (ScreenFrame.size.height-340)/2, ScreenFrame.size.width, ScreenFrame.size.width)];
    _myScrollView22.tag = 102;
    _myScrollView22.bounces = YES;
    _myScrollView22.delegate = self;
    _myScrollView22.pagingEnabled = YES;
    _myScrollView22.userInteractionEnabled = YES;
    _myScrollView22.showsHorizontalScrollIndicator = NO;
    _myScrollView22.contentSize=CGSizeMake(ScreenFrame.size.width*arrImage.count,ScreenFrame.size.width);
    [myViewBI addSubview:_myScrollView22];
    
    pageControl = [[DDPageControl alloc] init] ;
    [pageControl setCenter: CGPointMake(self.view.center.x, _myScrollView22.frame.origin.y-20)] ;
    [pageControl setNumberOfPages: arrImage.count] ;
    [pageControl setCurrentPage: 0] ;
    [pageControl addTarget: self action: @selector(pageControlClicked:) forControlEvents: UIControlEventValueChanged] ;
    [pageControl setDefersCurrentPageDisplay: YES] ;
    [pageControl setType: DDPageControlTypeOnFullOffEmpty] ;
    [pageControl setOnColor: MY_COLOR] ;
    [pageControl setOffColor: [UIColor colorWithWhite: 0.7f alpha: 1.0f]] ;
    [pageControl setIndicatorDiameter: 10.0f] ;
    [pageControl setIndicatorSpace: 10.0f] ;
    [myViewBI addSubview: pageControl] ;
    
    for(int i=0;i<arrImage.count;i++){
        UIImageView *imageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width*i, 0, ScreenFrame.size.width, ScreenFrame.size.width)];
        [imageVIew sd_setImageWithURL:[NSURL URLWithString:[arrImage objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
        [_myScrollView22 addSubview:imageVIew];
    }
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap2)];
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    [myViewBI addGestureRecognizer:singleTapGestureRecognizer];
}

- (void)pageControlClicked:(id)sender
{
    DDPageControl *thePageControl = (DDPageControl *)sender ;
    [_myScrollView22 setContentOffset: CGPointMake(_myScrollView22.bounds.size.width * thePageControl.currentPage, _myScrollView22.contentOffset.y) animated: YES] ;
}
- (void)pageControlClicked2:(id)sender
{
    DDPageControl *thePageControl = (DDPageControl *)sender ;
    [_myScrollView2 setContentOffset: CGPointMake(_myScrollView2.bounds.size.width * thePageControl.currentPage, _myScrollView2.contentOffset.y) animated: YES] ;
}


-(void)singleTap2{
    myViewBI.hidden = YES;
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    for (UIView *subView in myViewBI.subviews)
    {
        [subView removeFromSuperview];
    }
}


-(void)newbtnClicked:(UIButton *)btn{
    SecondViewController *sec = [SecondViewController sharedUserDefault];
    if (btn.tag == 101) {
    }
    if (btn.tag == 102) {
        EstimateViewController *es = [[EstimateViewController alloc]init];
        [self.navigationController pushViewController:es animated:YES];
    }
    if (btn.tag == 103) {
        if ([countField.text intValue] == 1) {
            countField.text = @"1";
        }else if([countField.text intValue]<1){
            
        }else{
            countField.text = [NSString stringWithFormat:@"%d",[countField.text intValue]-1];
        }
        countField1.text=countField.text;
        [MyTableView reloadData];
    }
    if (btn.tag == 104) {
        if (dataArray.count!=0) {
            ClassifyModel *class = [dataArray objectAtIndex:0];
            if ([class.detail_goods_inventory intValue]<1) {
                 [SYObject failedPrompt:@"库存不足"];
            }else{
                NSLog(@"%@ %@",class.detail_goods_limit,class.detail_goods_buy_count);
                if ([class.detail_goods_limit integerValue]==1) {
                    if ([countField.text intValue]+1 > [class.detail_goods_buy_count intValue]) {
                        [SYObject failedPrompt:@"超出限购数量"];
                        countField.text = [NSString stringWithFormat:@"%@",class.detail_goods_buy_count];
                    }else{
                        if ([countField.text intValue]+1 > [class.detail_goods_inventory intValue]) {
                            [SYObject failedPrompt:@"库存不足"];
                            countField.text = [NSString stringWithFormat:@"%@",class.detail_goods_inventory];
                        }else{
                            countField.text = [NSString stringWithFormat:@"%d",[countField.text intValue]+1];
                        }
                    
                    }
                }else{
                    if ([countField.text intValue]+1 > [class.detail_goods_inventory intValue]) {
                        [SYObject failedPrompt:@"库存不足"];
                        countField.text = [NSString stringWithFormat:@"%@",class.detail_goods_inventory];
                    }else{
                        countField.text = [NSString stringWithFormat:@"%d",[countField.text intValue]+1];
                    }

                }
            }
            countField1.text=countField.text;
            [MyTableView reloadData];
        }
    }
    if (btn.tag == 105) {
    }
    if (btn.tag == 106) {
        [SYObject startLoading];
        button2add.enabled = NO;
        _semiTransparentView.hidden=YES;
        _specifView.hidden=YES;
        if (dataArray.count!=0) {
            ClassifyModel *classifyKu = [dataArray objectAtIndex:0];
            if ([classifyKu.detail_goods_inventory intValue]>0){
                
                if([status isEqualToString:@"F码"]){
//                    FCode_bottomView.hidden = NO;
//                    FBuyView.hidden = NO;
                    [SYObject endLoading];
                    FCodeView.hidden = NO;
                    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height)];
                    image.backgroundColor = [UIColor blackColor];
                    image.alpha = 0.5;
                    image.userInteractionEnabled = YES;
                    [FCodeView addSubview:image];
                    UITapGestureRecognizer *singleTapGestureRecognizer3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(FcodeDisappear)];
                    [singleTapGestureRecognizer3 setNumberOfTapsRequired:1];
                    [image addGestureRecognizer:singleTapGestureRecognizer3];
                    
                    UIView *whiteV = [[UIView alloc]initWithFrame:CGRectMake(20, 60, ScreenFrame.size.width-40, 135)];
                    whiteV.backgroundColor = [UIColor whiteColor];
                    [whiteV.layer setMasksToBounds:YES];
                    [whiteV.layer setCornerRadius:8.0];
                    [FCodeView addSubview:whiteV];
                    UILabel *labelT = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, whiteV.frame.size.width, 40)];
                    labelT.backgroundColor = UIColorFromRGB(0xf15353);
                    labelT.text = @"请输入F码";
                    labelT.textColor = [UIColor whiteColor];
                    labelT.font = [UIFont boldSystemFontOfSize:18];
                    labelT.textAlignment = NSTextAlignmentCenter;
                    [whiteV addSubview:labelT];
                    
                    phoneNumFieldFF = [[UITextField alloc] initWithFrame:CGRectMake(35, 110, whiteV.frame.size.width-30, 40)];
                    phoneNumFieldFF.layer.borderWidth = 1;
                    phoneNumFieldFF.layer.borderColor = [[UIColor grayColor] CGColor];
                    phoneNumFieldFF.placeholder = @"请输入F码";
                    phoneNumFieldFF.font = [UIFont systemFontOfSize:15];
                    phoneNumFieldFF.delegate = self;
                    [FCodeView addSubview:phoneNumFieldFF];
                    
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = CGRectMake(40, 160, 60, 26);
                    btn.tag = 101;
                    btn.backgroundColor =UIColorFromRGB(0xf15353);
                    [btn setTitle:@"确定" forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(btnFcodeClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [btn.layer setMasksToBounds:YES];
                    [btn.layer setCornerRadius:4.0];
                    [FCodeView addSubview:btn];
                    
                    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn2.frame = CGRectMake(whiteV.frame.size.width-60, 160, 60, 26);
                    btn2.tag = 102;
                    [btn2 setTitle:@"取消" forState:UIControlStateNormal];
                    [btn2 addTarget:self action:@selector(btnFcodeClicked:) forControlEvents:UIControlEventTouchUpInside];
                    btn2.backgroundColor = [UIColor grayColor];
                    [btn2.layer setMasksToBounds:YES];
                    [btn2.layer setCornerRadius:4.0];
                    [FCodeView addSubview:btn2];
                    
                }else{
                    FCode_bottomView.hidden = YES;
                    FBuyView.hidden = YES;
               
         
                //发起加入购物车请求
                NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *documentsPath = [docPath objectAtIndex:0];
                NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
                NSFileManager *fileManagerDong = [NSFileManager defaultManager];
                if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ADDCAR_URL]];
                    request_25=[ASIFormDataRequest requestWithURL:url];
                    [request_25 setPostValue:countField.text forKey:@"count"];
                    [request_25 setPostValue:classifyKu.detail_goods_current_price forKey:@"price"];
                    if (specSelectArray.count!=0) {
                        NSString *str;
                        for(int i=0;i<specSelectArray.count;i++){
                            if (str.length == 0) {
                                str = [[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2];
                            }else{
                                str = [NSString stringWithFormat:@"%@,%@",str,[[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2]];
                            }
                        }
                        [request_25 setPostValue:str forKey:@"gsp"];
                    }
                    [request_25 setPostValue:@"" forKey:@"cart_mobile_ids"];
                    [request_25 setPostValue:sec.detail_id forKey:@"goods_id"];
                    //加参数area_id
                    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
                    NSString *areaId=[standard objectForKey:@"area_id"];
                    [request_46 setPostValue:areaId forKey:@"area_id"];
                    
                    [request_25 setRequestHeaders:[LJControl requestHeaderDictionary]];
                    request_25.tag = 111;
                    request_25.delegate =self;
                    [request_25 setDidFailSelector:@selector(addCaroff_urlRequestFailed:)];
                    [request_25 setDidFinishSelector:@selector(addCaroff_urlRequestSucceeded:)];
                    [request_25 startAsynchronous];
                }else{
                    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ADDCAR_URL]];
                    request_26=[ASIFormDataRequest requestWithURL:url];
                    [request_26 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
                    [request_26 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
                    [request_26 setPostValue: self.detail_id forKey:@"goods_id"];
                    [request_26 setPostValue:countField.text forKey:@"count"];
                    if ([status isEqualToString:@"促销"]) {
                        NSString *str = [NSString stringWithFormat:@"%0.2f",act_rate*[classifyKu.detail_goods_current_price floatValue]];
                        [request_26 setPostValue:str forKey:@"price"];
                    }else{
                        [request_26 setPostValue:classifyKu.detail_goods_current_price forKey:@"price"];
                    }
                    if (specSelectArray.count!=0) {
                        NSString *str;
                        for(int i=0;i<specSelectArray.count;i++){
                            if (str.length == 0) {
                                str = [[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2];
                            }else{
                                str = [NSString stringWithFormat:@"%@,%@",str,[[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2]];
                            }
                        }
                        [request_26 setPostValue:str forKey:@"gsp"];
                    }
                    [request_26 setPostValue:@"" forKey:@"cart_mobile_ids"];
                    //加参数area_id
                    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
                    NSString *areaId=[standard objectForKey:@"area_id"];
                    [request_46 setPostValue:areaId forKey:@"area_id"];
                    
                    [request_26 setRequestHeaders:[LJControl requestHeaderDictionary]];
                    request_26.tag = 110;
                    request_26.delegate =self;
                    [request_26 setDidFailSelector:@selector(addCaron_urlRequestFailed:)];
                    [request_26 setDidFinishSelector:@selector(addCaron_urlRequestSucceeded:)];
                    [request_26 startAsynchronous];
                }
            }
            
            
        }
            else{
                [SYObject failedPrompt:@"库存不足，无法加入购物车"];
            }
        }
    }
}
-(void)scrollViewBack{
   
    myViewBI.hidden = YES;
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}

-(void)disappear{
    [MyTableView reloadData];
    indexPath2Bool = NO;
    imageViewDarkGray.hidden = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    CGRect frame = specView.frame;
    frame.origin.x += ScreenFrame.size.width;
    [specView setFrame:frame];
    [UIView commitAnimations];
}

-(void)regionCancel{
}
-(void)next:(UIButton *)btn{
    buttonNext.enabled = NO;
    buttonNext.backgroundColor = [UIColor grayColor];
   [SYObject startLoading];
    ClassifyModel *cla = [regionArray objectAtIndex:selectRegionIndex];
    if (regionStr.length == 0) {
        regionStr = [NSString stringWithFormat:@"%@",cla.region_name];
    }else{
        regionStr = [NSString stringWithFormat:@"%@>%@",regionStr,cla.region_name];
    }
    
    if (regionIdStr.length == 0) {
        regionIdStr = [NSString stringWithFormat:@"%@",cla.region_id];
    }else{
        regionIdStr = [NSString stringWithFormat:@"%@,%@",regionIdStr,cla.region_id];
    }
    
    [MyTableView reloadData];
    
    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%@",FIRST_URL,REGION_URL,cla.region_id]];
    request_13=[ASIFormDataRequest requestWithURL:url2];
    
    [request_13 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_13.tag = 102;
    request_13.delegate =self;
    [request_13 setDidFailSelector:@selector(my213_urlRequestFailed:)];
    [request_13 setDidFinishSelector:@selector(my213_urlRequestSucceeded:)];
    [request_13 startAsynchronous];
    
    RegoinTableView.userInteractionEnabled = NO;
}
-(IBAction)refreshClicked:(id)sender{
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    stateNew=[standard objectForKey:@"stateNew"];
    cityNew=[standard objectForKey:@"cityNew"];
    subCityNew=[standard objectForKey:@"subCityNew"];
    
    [standard synchronize];

    MyTableView.hidden = NO;
    bottomView.hidden = NO;
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
    SecondViewController *sec = [SecondViewController sharedUserDefault];
    if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,DETAIL_URL]];
        request_15=[ASIFormDataRequest requestWithURL:url];
        [request_15 setPostValue:sec.detail_id forKey:@"id"];
         [request_15 setPostValue:[NSString stringWithFormat:@"%@%@",stateNew,cityNew] forKey:@"cityName"];
        NSArray *arrObjc;
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:filePathDong];
        if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
            arrObjc = [[NSArray alloc]initWithObjects:@"", nil];
        }else{
            [request_15 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
            [request_15 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
            
            arrObjc = [[NSArray alloc]initWithObjects:[fileContent2 objectAtIndex:4], nil];
        }
        NSArray *arrKey = [[NSArray alloc]initWithObjects:VERIFY, nil];
        NSMutableDictionary *dicMy = [[NSMutableDictionary alloc]initWithObjects:arrObjc forKeys:arrKey];
        [request_15 setRequestHeaders:dicMy];
        request_15.tag = 101;
        [request_15 setDelegate:self];
        [request_15 setDidFailSelector:@selector(urlRequestFailed:)];
        [request_15 setDidFinishSelector:@selector(urlRequestSucceeded:)];
        [request_15 startAsynchronous];
    }else{
        NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,DETAIL_URL]];
        request_16=[ASIFormDataRequest requestWithURL:url2];
        [request_16 setPostValue:sec.detail_id forKey:@"id"];
         [request_16 setPostValue:[NSString stringWithFormat:@"%@%@",stateNew,cityNew] forKey:@"cityName"];
        NSArray *arrObjc2;
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:filePathDong];
        if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
            arrObjc2 = [[NSArray alloc]initWithObjects:@"", nil];
        }else{
            [request_16 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
            [request_16 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
            arrObjc2 = [[NSArray alloc]initWithObjects:[fileContent2 objectAtIndex:4], nil];
        }
        NSArray *arrKey2 = [[NSArray alloc]initWithObjects:VERIFY, nil];
        NSMutableDictionary *dicMy2 = [[NSMutableDictionary alloc]initWithObjects:arrObjc2 forKeys:arrKey2];
        [request_16 setRequestHeaders:dicMy2];
        request_16.tag = 101;
        request_16.delegate = self;
        [request_16 setDidFailSelector:@selector(on_urlRequestFailed:)];
        [request_16 setDidFinishSelector:@selector(on_urlRequestSucceeded:)];
        [request_16 startAsynchronous];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,MEMBERPRICE_URL]];
        request_17=[ASIFormDataRequest requestWithURL:url];
        [request_17 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
        [request_17 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
        [request_17 setPostValue:sec.detail_id forKey:@"goods_id"];
        
        [request_17 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request_17.tag = 107;
        request_17.delegate = self;
        [request_17 setDidFailSelector:@selector(Userlevel_urlRequestFailed:)];
        [request_17 setDidFinishSelector:@selector(Userlevel_urlRequestSucceeded:)];
        [request_17 startAsynchronous];
    }
}
-(void)goodsDetailCellClicked:(UIButton *)btn{
    if (btn.tag==100) {
        //更多评价
         [self naviButtonClicked:_evaluateBtn];
    }else if (btn.tag==101){
    //购买咨询
        EstimateViewController *EE = [[EstimateViewController alloc]init];
        [self.navigationController pushViewController:EE animated:YES];
    }else if (btn.tag==102){
    //联系客服，[self chat]
    }else if (btn.tag==103){
        //进店逛逛
        ClassifyModel *classify = [dataArray objectAtIndex:0];
        ThirdViewController *th = [ThirdViewController sharedUserDefault];
        th.store_id = [classify.detail_store_info objectForKey:@"store_id"];
        StoreHomeViewController2 *storeVC = [[StoreHomeViewController2 alloc]init];
        [self.navigationController pushViewController:storeVC animated:YES];
    }

}
#pragma mark - 左右滑动手势
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void)MyTableViewGestureRight{
    CGPoint p = self.containerScrollView.contentOffset;
    if (p.x<ScreenFrame.size.width*0.5) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)MyTableViewGestureLeft{
    //发起请求规格
    if (specSelectBool == NO) {
        SecondViewController *sec = [SecondViewController sharedUserDefault];
        NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,SPECIFICATIONS_URL]];
        request_18=[ASIFormDataRequest requestWithURL:url3];
        [request_18 setPostValue:sec.detail_id forKey:@"id"];
        
        [request_18 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request_18.tag = 102;
        request_18.delegate = self;
        [request_18 setDidFailSelector:@selector(spec_urlRequestFailed:)];
        [request_18 setDidFinishSelector:@selector(spec_urlRequestSucceeded:)];
        [request_18 startAsynchronous];
        specSelectBool = YES;
    }else{
        
    }
    indexPath2Bool = YES;
    imageViewDarkGray.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect frame = specView.frame;
    frame.origin.x -= ScreenFrame.size.width;
    [specView setFrame:frame];
    [UIView commitAnimations];
}

-(void)dismissKeyBoard{
    if ([self isMobileField:countField.text] == NO) {
        countField.text = @"1";
        [MyTableView reloadData];
        [countField resignFirstResponder];
        CGFloat keyboardHeight = 226.0f;
        if (self.view.frame.size.height - keyboardHeight <= countField.frame.origin.y + countField.frame.size.height) {
            [UIView beginAnimations:@"srcollView" context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.275f];
            self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
        }
    }else{
        [MyTableView reloadData];
        [countField resignFirstResponder];
        CGFloat keyboardHeight = 226.0f;
        if (self.view.frame.size.height - keyboardHeight <= countField.frame.origin.y + countField.frame.size.height) {
            [UIView beginAnimations:@"srcollView" context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.275f];
            self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
        }
    }
}
-(void)checkPreorder{
    ClassifyModel *classify = [dataArray firstObject];
    NSString *statu = classify.detail_goodsstatus_info;
    BOOL preOrder = [statu hasPrefix:@"预售商品"];
    //如果是预售商品，不让加入购物车.
    if (!preOrder) {
        bottomView2.hidden = YES;
    }else {
        //预售商品
        bottomView2.hidden = NO;
    }
}
#pragma mark -底部button
-(void)createBottomView{
    //普通商品
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenFrame.size.height-44-64, ScreenFrame.size.width, 44)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIImageView *imgeL = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 0.5)];
    imgeL.backgroundColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
    [bottomView addSubview:imgeL];
    
    
   UIImageView *labeHeartimage= [[UIImageView alloc]initWithFrame:CGRectMake(10, 6, 24, 34)];
    labeHeartimage.image = [UIImage imageNamed:@"customerservice.png"];
    [bottomView addSubview:labeHeartimage];
    
   UIButton * btnSCButton = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSCButton.frame = CGRectMake(0, 0, 44, 44);
    btnSCButton.alpha = 1;
    [btnSCButton setTitle:@"" forState:UIControlStateNormal];
    btnSCButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnSCButton addTarget:self action:@selector(chat) forControlEvents:UIControlEventTouchUpInside];
    btnSCButton.layer.cornerRadius = 4;
    btnSCButton.layer.masksToBounds  = YES;
    [bottomView addSubview:btnSCButton];
    
    UIImageView *labeHeartimage1 = [[UIImageView alloc]initWithFrame:CGRectMake(54, 6, 24, 34)];
    labeHeartimage1.image = [UIImage imageNamed:@"shopentrance.png"];
    [bottomView addSubview:labeHeartimage1];
     UIButton * btnSCButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSCButton1.frame = CGRectMake(44, 0, 44, 44);
    btnSCButton1.alpha = 1;
    [btnSCButton1 setTitle:@"" forState:UIControlStateNormal];
    btnSCButton1.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnSCButton1 addTarget:self action:@selector(goStore) forControlEvents:UIControlEventTouchUpInside];
    btnSCButton1.layer.cornerRadius = 4;
    btnSCButton1.layer.masksToBounds  = YES;
    [bottomView addSubview:btnSCButton1];

    labeHeart2 = [[UIImageView alloc]initWithFrame:CGRectMake(98, 6, 24, 34)];
    labeHeart2.image = [UIImage imageNamed:@"sc_new"];
    [bottomView addSubview:labeHeart2];
    
    btnSC = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSC.frame = CGRectMake(88, 0, 44, 44);
    btnSC.alpha = 1;
    [btnSC setTitle:@"" forState:UIControlStateNormal];
    btnSC.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnSC addTarget:self action:@selector(favourite) forControlEvents:UIControlEventTouchUpInside];
    btnSC.layer.cornerRadius = 4;
    btnSC.layer.masksToBounds  = YES;
    [bottomView addSubview:btnSC];
    
    
    btnAddCar = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAddCar.frame = CGRectMake(132, 0.5, (ScreenFrame.size.width-132)/2, 43.5);
    btnAddCar.tag = 101;
    btnAddCar.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [btnAddCar setTitle:@"加入购物车" forState:UIControlStateNormal];
    btnAddCar.backgroundColor = [UIColor orangeColor];
    btnAddCar.titleLabel.textColor = [UIColor whiteColor];
    [btnAddCar addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnAddCar addTarget:self action:@selector(buttonBackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
    [btnAddCar addTarget:self action:@selector(buttonBackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btnAddCar];
    
    btn22Qing = [UIButton buttonWithType:UIButtonTypeCustom];
    btn22Qing.frame = CGRectMake(ScreenFrame.size.width-(ScreenFrame.size.width-132)/2, 0.5, (ScreenFrame.size.width-132)/2, 43.5);
    btn22Qing.tag = 102;
    btn22Qing.backgroundColor = UIColorFromRGB(0xf15353);
    [btn22Qing addTarget:self action:@selector(buttonBackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
    [btn22Qing addTarget:self action:@selector(buttonBackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
    btn22Qing.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [btn22Qing setTitle:@"立即购买" forState:UIControlStateNormal];
    btn22Qing.titleLabel.textColor = [UIColor whiteColor];
    [btn22Qing addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btn22Qing];
    bottomView.hidden = YES;
    
    
    
    //自营商品
    bottomView1 = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenFrame.size.height-44-64, ScreenFrame.size.width, 44)];
    bottomView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView1];
    
    [bottomView1 addSubview:imgeL];
    
    UIImageView *labeHeartimage2= [[UIImageView alloc]initWithFrame:CGRectMake(10, 6, 24, 34)];
    labeHeartimage2.image = [UIImage imageNamed:@"customerservice.png"];
    [bottomView1 addSubview:labeHeartimage2];
    UIButton * btnSCButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSCButton2.frame = CGRectMake(0, 0, 44, 44);
    btnSCButton2.alpha = 1;
    [btnSCButton2 setTitle:@"" forState:UIControlStateNormal];
    btnSCButton2.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnSCButton2 addTarget:self action:@selector(chat) forControlEvents:UIControlEventTouchUpInside];
    btnSCButton2.layer.cornerRadius = 4;
    btnSCButton2.layer.masksToBounds  = YES;
    [bottomView1 addSubview:btnSCButton2];
    
    labeHeart3 = [[UIImageView alloc]initWithFrame:CGRectMake(54, 6, 24, 34)];
    labeHeart3.image = [UIImage imageNamed:@"sc_new"];
    [bottomView1 addSubview:labeHeart3];
    
    btnSC = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSC.frame = CGRectMake(44, 0, 44, 44);
    btnSC.alpha = 1;
    [btnSC setTitle:@"" forState:UIControlStateNormal];
    btnSC.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnSC addTarget:self action:@selector(favourite) forControlEvents:UIControlEventTouchUpInside];
    btnSC.layer.cornerRadius = 4;
    btnSC.layer.masksToBounds  = YES;
    [bottomView1 addSubview:btnSC];
    
    btnAddCar2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAddCar2.frame = CGRectMake(88, 0.5, (ScreenFrame.size.width-88)/2, 43.5);
    btnAddCar2.tag = 101;
    btnAddCar2.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [btnAddCar2 setTitle:@"加入购物车" forState:UIControlStateNormal];
    btnAddCar2.backgroundColor = [UIColor orangeColor];
    btnAddCar2.titleLabel.textColor = [UIColor whiteColor];
    [btnAddCar2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView1 addSubview:btnAddCar2];
    
    
    btn22Qing2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn22Qing2.frame = CGRectMake(ScreenFrame.size.width-(ScreenFrame.size.width-88)/2, 0.5, (ScreenFrame.size.width-88)/2, 43.5);
    btn22Qing2.tag = 102;
    btn22Qing2.backgroundColor = MY_COLOR;
    btn22Qing2.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [btn22Qing2 setTitle:@"立即购买" forState:UIControlStateNormal];
    btn22Qing2.titleLabel.textColor = [UIColor whiteColor];
    [btn22Qing2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView1 addSubview:btn22Qing2];
    bottomView1.hidden = YES;
//
    //F码商品
    FCode_bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,ScreenFrame.size.height-44-64, ScreenFrame.size.width, 44)];
    FCode_bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:FCode_bottomView];
    Fbtn2Qing = [UIButton buttonWithType:UIButtonTypeCustom];
    Fbtn2Qing.frame = CGRectMake(0, 0, FCode_bottomView.frame.size.width, 44);
    Fbtn2Qing.tag = 102;
    Fbtn2Qing.backgroundColor = MY_COLOR;
    Fbtn2Qing.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [Fbtn2Qing addTarget:self action:@selector(FCodebtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [Fbtn2Qing setTitle:@"立即购买" forState:UIControlStateNormal];
    [FCode_bottomView addSubview:Fbtn2Qing];
    FCode_bottomView.hidden=YES;
    
    //预售商品
    bottomView2 = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenFrame.size.height-44-64, ScreenFrame.size.width, 44)];
    bottomView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView2];
    
    [bottomView2 addSubview:imgeL];
    
    UIImageView *labeHeartimage4= [[UIImageView alloc]initWithFrame:CGRectMake(10, 6, 24, 34)];
    labeHeartimage4.image = [UIImage imageNamed:@"customerservice.png"];
    [bottomView2 addSubview:labeHeartimage4];
    
    UIButton * btnSCButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSCButton4.frame = CGRectMake(0, 0, 44, 44);
    btnSCButton4.alpha = 1;
    [btnSCButton4 setTitle:@"" forState:UIControlStateNormal];
    btnSCButton4.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnSCButton4 addTarget:self action:@selector(chat) forControlEvents:UIControlEventTouchUpInside];
    btnSCButton4.layer.cornerRadius = 4;
    btnSCButton4.layer.masksToBounds  = YES;
    [bottomView2 addSubview:btnSCButton4];
    
    UIImageView *labeHeartimage5 = [[UIImageView alloc]initWithFrame:CGRectMake(54, 6, 24, 34)];
    labeHeartimage5.image = [UIImage imageNamed:@"shopentrance.png"];
    [bottomView2 addSubview:labeHeartimage5];
    UIButton * btnSCButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSCButton3.frame = CGRectMake(44, 0, 44, 44);
    btnSCButton3.alpha = 1;
    [btnSCButton3 setTitle:@"" forState:UIControlStateNormal];
    btnSCButton3.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnSCButton3 addTarget:self action:@selector(goStore) forControlEvents:UIControlEventTouchUpInside];
    btnSCButton3.layer.cornerRadius = 4;
    btnSCButton3.layer.masksToBounds  = YES;
    [bottomView2 addSubview:btnSCButton3];
    
    labeHeart4 = [[UIImageView alloc]initWithFrame:CGRectMake(98, 6, 24, 34)];
    labeHeart4.image = [UIImage imageNamed:@"sc_new"];
    [bottomView2 addSubview:labeHeart4];
    
    btnSC1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSC1.frame = CGRectMake(88, 0, 44, 44);
    btnSC1.alpha = 1;
    [btnSC1 setTitle:@"" forState:UIControlStateNormal];
    btnSC1.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnSC1 addTarget:self action:@selector(favourite) forControlEvents:UIControlEventTouchUpInside];
    btnSC1.layer.cornerRadius = 4;
    btnSC1.layer.masksToBounds  = YES;
    [bottomView2 addSubview:btnSC1];
    
    btn22Qing1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn22Qing1.frame = CGRectMake(ScreenFrame.size.width-(ScreenFrame.size.width-132), 0.5, (ScreenFrame.size.width-132), 43.5);
    btn22Qing1.tag = 102;
    btn22Qing1.backgroundColor = MY_COLOR;
    btn22Qing1.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [btn22Qing1 setTitle:@"立即付定金" forState:UIControlStateNormal];
    btn22Qing1.titleLabel.textColor = [UIColor whiteColor];
    [btn22Qing1 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView2 addSubview:btn22Qing1];
    bottomView2.hidden = YES;
    
}
//  button普通状态下的背景色
- (void)buttonBackGroundNormal:(UIButton *)sender
{
    if (sender.tag==101) {
      sender.backgroundColor = [UIColor orangeColor];
    }else if (sender.tag==102)
    {
     sender.backgroundColor=UIColorFromRGB(0Xf15353);
    }
    
}
//  button高亮状态下的背景色
- (void)buttonBackGroundHighlighted:(UIButton *)sender
{
    if (sender.tag==101)
    {
    sender.backgroundColor = UIColorFromRGB(0XFE9900);
    }else if (sender.tag==102)
    {
        sender.backgroundColor=UIColorFromRGB(0Xd15353);
    }
}
-(void)FcodeDisappear{
    [phoneNumFieldFF resignFirstResponder];
}
-(void)FCodebtnClicked:(UIButton *)btn{
    if (btn.tag == 101) {
    }
    if (btn.tag == 102) {
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
            labelTi.hidden = NO;
            labelTi.text = @"登录后才可立即购买,请登录!";
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimerLogin) userInfo:nil repeats:NO];
        }else{
            FCodeView.hidden = NO;
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height)];
            image.backgroundColor = [UIColor blackColor];
            image.alpha = 0.5;
            image.userInteractionEnabled = YES;
            [FCodeView addSubview:image];
            UITapGestureRecognizer *singleTapGestureRecognizer3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(FcodeDisappear)];
            [singleTapGestureRecognizer3 setNumberOfTapsRequired:1];
            [image addGestureRecognizer:singleTapGestureRecognizer3];
            
            UIView *whiteV = [[UIView alloc]initWithFrame:CGRectMake(20, 60, ScreenFrame.size.width-40, 135)];
            whiteV.backgroundColor = [UIColor whiteColor];
            [whiteV.layer setMasksToBounds:YES];
            [whiteV.layer setCornerRadius:8.0];
            [FCodeView addSubview:whiteV];
            UILabel *labelT = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, whiteV.frame.size.width, 40)];
            labelT.backgroundColor = UIColorFromRGB(0xf15353);
            labelT.text = @"请输入F码";
            labelT.textColor = [UIColor whiteColor];
            labelT.font = [UIFont boldSystemFontOfSize:18];
            labelT.textAlignment = NSTextAlignmentCenter;
            [whiteV addSubview:labelT];
            
            phoneNumFieldFF = [[UITextField alloc] initWithFrame:CGRectMake(35, 110, whiteV.frame.size.width-30, 40)];
            phoneNumFieldFF.layer.borderWidth = 1;
            phoneNumFieldFF.layer.borderColor = [[UIColor grayColor] CGColor];
            phoneNumFieldFF.placeholder = @"请输入F码";
            phoneNumFieldFF.font = [UIFont systemFontOfSize:15];
            phoneNumFieldFF.delegate = self;
            [FCodeView addSubview:phoneNumFieldFF];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(40, 160, 60, 26);
            btn.tag = 101;
            btn.backgroundColor =UIColorFromRGB(0xf15353);
            [btn setTitle:@"确定" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnFcodeClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn.layer setMasksToBounds:YES];
            [btn.layer setCornerRadius:4.0];
            [FCodeView addSubview:btn];
            
            UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn2.frame = CGRectMake(whiteV.frame.size.width-60, 160, 60, 26);
            btn2.tag = 102;
            [btn2 setTitle:@"取消" forState:UIControlStateNormal];
            [btn2 addTarget:self action:@selector(btnFcodeClicked:) forControlEvents:UIControlEventTouchUpInside];
            btn2.backgroundColor = [UIColor grayColor];
            [btn2.layer setMasksToBounds:YES];
            [btn2.layer setCornerRadius:4.0];
            [FCodeView addSubview:btn2];
        }
    }
    if (btn.tag == 103) {
        
    }
}
//F码弹出窗口确定按钮的点击事件
-(void)btnFcodeClicked:(UIButton *)btn{
    if (btn.tag == 101) {
        if (phoneNumFieldFF.text.length == 0) {
            [SYObject failedPrompt:@"F码不能为空"];
        }else{
            if (dataArray.count!=0) {
                ClassifyModel *classifyKu = [dataArray objectAtIndex:0];
                SecondViewController *sec = [SecondViewController sharedUserDefault];
                NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *documentsPath = [docPath objectAtIndex:0];
                NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
                NSFileManager *fileManagerDong = [NSFileManager defaultManager];
                if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,FCODE_URL]];
                    request_31=[ASIFormDataRequest requestWithURL:url];
                    [request_31 setPostValue:countField.text forKey:@"count"];
                    if ([status isEqualToString:@"促销"]) {
                        NSString *str = [NSString stringWithFormat:@"%0.2f",act_rate*[classifyKu.detail_goods_current_price floatValue]];
                        [request_31 setPostValue:str forKey:@"price"];
                    }else{
                        [request_31 setPostValue:classifyKu.detail_goods_price forKey:@"price"];
                    }
                    if (specSelectArray.count!=0) {
                        NSString *str;
                        for(int i=0;i<specSelectArray.count;i++){
                            if (str.length == 0) {
                                str = [[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2];
                            }else{
                                str = [NSString stringWithFormat:@"%@,%@",str,[[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2]];
                            }
                        }
                        [request_31 setPostValue:str forKey:@"gsp"];
                    }
                    [request_31 setPostValue:@"" forKey:@"cart_mobile_ids"];
                    [request_31 setPostValue:sec.detail_id forKey:@"goods_id"];
                    [request_31 setPostValue:phoneNumFieldFF.text forKey:@"f_code"];
                    
                    [request_31 setRequestHeaders:[LJControl requestHeaderDictionary]];
                    request_31.tag = 111;
                    request_31.delegate =self;
                    [request_31 setDidFailSelector:@selector(Fcodeoff_urlRequestFailed:)];
                    [request_31 setDidFinishSelector:@selector(Fcodeoff_urlRequestSucceeded:)];
                    [request_31 startAsynchronous];
                }else{
                    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,FCODE_URL]];
                    request_32=[ASIFormDataRequest requestWithURL:url];
                    [request_32 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
                    [request_32 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
                    [request_32 setPostValue:sec.detail_id forKey:@"goods_id"];
                    [request_32 setPostValue:phoneNumFieldFF.text forKey:@"f_code"];
                    [request_32 setPostValue:countField.text forKey:@"count"];
                    if ([status isEqualToString:@"促销"]) {
                        NSString *str = [NSString stringWithFormat:@"%0.2f",act_rate*[classifyKu.detail_goods_current_price floatValue]];
                        [request_32 setPostValue:str forKey:@"price"];
                    }else{
                        [request_32 setPostValue:classifyKu.detail_goods_current_price forKey:@"price"];
                    }
                    if (specSelectArray.count!=0) {
                        NSString *str;
                        for(int i=0;i<specSelectArray.count;i++){
                            if (str.length == 0) {
                                str = [[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2];
                            }else{
                                str = [NSString stringWithFormat:@"%@,%@",str,[[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2]];
                            }
                        }
                        [request_32 setPostValue:str forKey:@"gsp"];
                    }
                    [request_32 setPostValue:@"" forKey:@"cart_mobile_ids"];
                    
                    [request_32 setRequestHeaders:[LJControl requestHeaderDictionary]];
                    request_32.tag = 110;
                    request_32.delegate =self;
                    [request_32 setDidFailSelector:@selector(Fcodeon_urlRequestFailed:)];
                    [request_32 setDidFinishSelector:@selector(Fcodeon_urlRequestSucceeded:)];
                    [request_32 startAsynchronous];
                }
            }
        }
        
    }
    if (btn.tag == 102) {
        //
        FCodeView.hidden = YES;
        for (UIView *subView in FCodeView.subviews)
        {
            [subView removeFromSuperview];
        }
    }
}
-(void)doTimerLogin{
    labelTi.hidden = YES;

    NewLoginViewController *new = [[NewLoginViewController alloc]initWithNibName:@"NewLoginViewController" bundle:nil];
    [self.navigationController pushViewController:new animated:YES];
}
-(void)zuheDismiss{
    zuheView.hidden = YES;
    for (UIView *subView in zuheView.subviews)
    {
        [subView removeFromSuperview];
    }
}
-(void)btnStatus{
    zuheView.hidden = NO;
    UIImageView *imageG = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, zuheView.frame.size.width, zuheView.frame.size.height)];
    imageG.backgroundColor = [UIColor blackColor];
    imageG.alpha = 0.5;
    imageG.userInteractionEnabled = YES;
    [zuheView addSubview:imageG];
    
    UITapGestureRecognizer *singleTapGestureRecognizer3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zuheDismiss)];
    [singleTapGestureRecognizer3 setNumberOfTapsRequired:1];
    [imageG addGestureRecognizer:singleTapGestureRecognizer3];
    
    if (ScreenFrame.size.height>480) {//说明是5 5s
        zuheTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 60, ScreenFrame.size.width-20,ScreenFrame.size.height-100) style:UITableViewStylePlain];
    }else{
        zuheTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 60, ScreenFrame.size.width-20,ScreenFrame.size.height-100) style:UITableViewStylePlain];
    }
    zuheTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    zuheTableView.delegate = self;
    zuheTableView.dataSource=  self;
    zuheTableView.showsVerticalScrollIndicator=NO;
    zuheTableView.showsHorizontalScrollIndicator = NO;
    [zuheTableView.layer setMasksToBounds:YES];
    [zuheTableView.layer setCornerRadius:8.0];
    [zuheView addSubview:zuheTableView];
    
    if (ScreenFrame.size.height>480) {//说明是5 5s
        zuhepeijianTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 60, ScreenFrame.size.width-20, ScreenFrame.size.height-100) style:UITableViewStylePlain];
    }else{
        zuhepeijianTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 60, ScreenFrame.size.width-20, ScreenFrame.size.height-100) style:UITableViewStylePlain];
    }
    zuhepeijianTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    zuhepeijianTableView.delegate = self;
    zuhepeijianTableView.dataSource=  self;
    zuhepeijianTableView.showsVerticalScrollIndicator=NO;
    zuhepeijianTableView.showsHorizontalScrollIndicator = NO;
    [zuhepeijianTableView.layer setMasksToBounds:YES];
    [zuhepeijianTableView.layer setCornerRadius:8.0];
    zuhepeijianTableView.hidden = YES;
    [zuheView addSubview:zuhepeijianTableView];
    
    if (zuhePeijianArray.count==0) {
        NSArray *array=@[@"组合套装"];
        UISegmentedControl *segmentControl=[[UISegmentedControl alloc]initWithItems:array];
        segmentControl.frame=CGRectMake(10, zuheTableView.frame.origin.y-23, zuheTableView.frame.size.width, 30);
        segmentControl.selectedSegmentIndex=0;
        segmentControl.tintColor = MY_COLOR;
        [segmentControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
        segmentControl.backgroundColor = [UIColor whiteColor];
        [segmentControl.layer setMasksToBounds:YES];
        [segmentControl.layer setCornerRadius:4.0];
        [zuheView addSubview:segmentControl];
    }
    else{
        NSArray *array=@[@"组合套装",@"组合配件"];
        UISegmentedControl *segmentControl=[[UISegmentedControl alloc]initWithItems:array];
        segmentControl.frame=CGRectMake(10, zuheTableView.frame.origin.y-23, zuheTableView.frame.size.width, 30);
        segmentControl.selectedSegmentIndex=0;
        segmentControl.tintColor = MY_COLOR;
        [segmentControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
        segmentControl.backgroundColor = [UIColor whiteColor];
        [segmentControl.layer setMasksToBounds:YES];
        [segmentControl.layer setCornerRadius:4.0];
        [zuheView addSubview:segmentControl];
    }
}
-(void)change:(UISegmentedControl *)segmentControl{
    if (segmentControl.selectedSegmentIndex == 0) {
        zuhepeijianTableView.hidden = YES;
        zuheTableView.hidden = NO;
    }
    else{
        zuhepeijianTableView.hidden = NO;
        zuheTableView.hidden = YES;
    }
}
-(void)zuhePeijiajBtnClicked:(UIButton *)btn{
    if (zuheArray.count!=0) {
        for(int i=0;i<zuheArray.count;i++){
            if (btn.tag-100 == i) {
                //发起加入购物车请求
                SecondViewController *sec = [SecondViewController sharedUserDefault];
                NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *documentsPath = [docPath objectAtIndex:0];
                NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
                NSFileManager *fileManagerDong = [NSFileManager defaultManager];
                if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ADDCAR_URL]];
                    request_37=[ASIFormDataRequest requestWithURL:url];
                    [request_37 setPostValue:@"" forKey:@"user_id"];
                    [request_37 setPostValue:@"" forKey:@"token"];
                    [request_37 setPostValue:sec.detail_id forKey:@"goods_id"];
                    [request_37 setPostValue:countField.text forKey:@"count"];
                    if(dataArray.count!=0){
                        ClassifyModel * classifyKu = [dataArray objectAtIndex:0];
                        [request_37 setPostValue:classifyKu.detail_goods_price forKey:@"price"];
                    }
                    if (specSelectArray.count!=0) {
                        NSString *str;
                        for(int i=0;i<specSelectArray.count;i++){
                            if (str.length == 0) {
                                str = [[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2];
                            }else{
                                str = [NSString stringWithFormat:@"%@,%@",str,[[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2]];
                            }
                        }
                        [request_37 setPostValue:str forKey:@"gsp"];
                    }
                    [request_37 setPostValue:@"parts" forKey:@"buy_type"];//part为配件购买
                    
                    NSMutableArray *aaa = [peijianSelectArray objectAtIndex:btn.tag-100];
                    NSString *str ;
                    for(int i=0;i<aaa.count;i++){
                        if (str.length == 0) {
                            if ([NSString stringWithFormat:@"%@",[aaa objectAtIndex:i]].length == 0) {
                                str = @"";
                            }else{
                                str = [NSString stringWithFormat:@"%@",[aaa objectAtIndex:i]];
                            }
                        }else{
                            if ([NSString stringWithFormat:@"%@",[aaa objectAtIndex:i]].length == 0){
                                
                            }else{
                                str = [NSString stringWithFormat:@"%@,%@",str,[aaa objectAtIndex:i]];
                            }
                        }
                    }
                    [request_37 setPostValue:str forKey:@"combin_ids"];
                    [request_37 setPostValue:@"" forKey:@"cart_mobile_ids"];
                    
                    //加参数area_id
                    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
                    NSString *areaId=[standard objectForKey:@"area_id"];
                    [request_46 setPostValue:areaId forKey:@"area_id"];
                    
                    [request_37 setRequestHeaders:[LJControl requestHeaderDictionary]];
                    request_37.tag = 111;
                    request_37.delegate =self;
                    [request_37 setDidFailSelector:@selector(addCaroff_urlRequestFailed:)];
                    [request_37 setDidFinishSelector:@selector(addCaroff_urlRequestSucceeded:)];
                    [request_37 startAsynchronous];
                }else{
                    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ADDCAR_URL]];
                    request_38=[ASIFormDataRequest requestWithURL:url];
                    [request_38 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
                    [request_38 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
                    
                    [request_38 setPostValue:sec.detail_id forKey:@"goods_id"];
                    [request_38 setPostValue:countField.text forKey:@"count"];
                    if(dataArray.count!=0){
                        ClassifyModel * classifyKu = [dataArray objectAtIndex:0];
                        [request_38 setPostValue:classifyKu.detail_goods_price forKey:@"price"];
                    }
                    if (specSelectArray.count!=0) {
                        NSString *str;
                        for(int i=0;i<specSelectArray.count;i++){
                            if (str.length == 0) {
                                str = [[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2];
                            }else{
                                str = [NSString stringWithFormat:@"%@,%@",str,[[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2]];
                            }
                        }
                        [request_38 setPostValue:str forKey:@"gsp"];
                    }
                    [request_38 setPostValue:@"parts" forKey:@"buy_type"];//part为配件购买
                    NSMutableArray *aaa = [peijianSelectArray objectAtIndex:btn.tag-100];
                    NSString *str ;
                    for(int i=0;i<aaa.count;i++){
                        if (str.length == 0) {
                            if ([NSString stringWithFormat:@"%@",[aaa objectAtIndex:i]].length == 0) {
                                str = @"";
                            }else{
                                str = [NSString stringWithFormat:@"%@",[aaa objectAtIndex:i]];
                            }
                        }else{
                            if ([NSString stringWithFormat:@"%@",[aaa objectAtIndex:i]].length == 0){
                                
                            }else{
                                str = [NSString stringWithFormat:@"%@,%@",str,[aaa objectAtIndex:i]];
                            }
                        }
                    }
                    [request_38 setPostValue:str forKey:@"combin_ids"];
                    [request_38 setPostValue:@"" forKey:@"cart_mobile_ids"];
                    //加参数area_id
                    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
                    NSString *areaId=[standard objectForKey:@"area_id"];
                    [request_46 setPostValue:areaId forKey:@"area_id"];
                    
                    [request_38 setRequestHeaders:[LJControl requestHeaderDictionary]];
                    request_38.tag = 110;
                    request_38.delegate =self;
                    [request_38 setDidFailSelector:@selector(addCaron_urlRequestFailed:)];
                    [request_38 setDidFinishSelector:@selector(addCaron_urlRequestSucceeded:)];
                    [request_38 startAsynchronous];
                }
                
            }
        }
    }
}

-(void)zuhePeijianIDBtnClicked:(UIButton *)btn{
    if (btn.tag<100) {//说明是第一行的
        if (zuhePeijianArray.count!=0) {
            NSDictionary *dic = [zuhePeijianArray objectAtIndex:0];
            NSArray *arr = [dic objectForKey:@"goods_list"];
            NSMutableArray *AA = [peijianSelectArray objectAtIndex:0];
            NSString *ID = [AA objectAtIndex:btn.tag];
            if ([NSString stringWithFormat:@"%@",ID].length == 0) {
                [AA replaceObjectAtIndex:btn.tag withObject:[[arr objectAtIndex:btn.tag] objectForKey:@"goods_id"]];
            }else{
                [AA replaceObjectAtIndex:btn.tag withObject:@""];
            }
        }
    }else{
        if (zuhePeijianArray.count!=0) {
            NSDictionary *dic = [zuhePeijianArray objectAtIndex:btn.tag/100];
            NSArray *arr = [dic objectForKey:@"goods_list"];
            NSMutableArray *AA = [peijianSelectArray objectAtIndex:btn.tag%100];
            NSString *ID = [AA objectAtIndex:btn.tag%100];
            if ([NSString stringWithFormat:@"%@",ID].length == 0) {
                [AA replaceObjectAtIndex:btn.tag%100 withObject:[[arr objectAtIndex:btn.tag%100] objectForKey:@"goods_id"]];
            }else{
                [AA replaceObjectAtIndex:btn.tag%100 withObject:@""];
            }
        }
    }
    [zuhepeijianTableView reloadData];
}

-(void)zuheBtnClicked:(UIButton *)btn{
    if (zuheArray.count!=0) {
        for(int i=0;i<zuheArray.count;i++){
            if (btn.tag-100 == i) {
                //发起加入购物车请求
                SecondViewController *sec = [SecondViewController sharedUserDefault];
                NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *documentsPath = [docPath objectAtIndex:0];
                NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
                NSFileManager *fileManagerDong = [NSFileManager defaultManager];
                if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ADDCAR_URL]];
                    request_39=[ASIFormDataRequest requestWithURL:url];
                    [request_39 setPostValue:@"" forKey:@"user_id"];
                    [request_39 setPostValue:@"" forKey:@"token"];
                    [request_39 setPostValue:sec.detail_id forKey:@"goods_id"];
                    [request_39 setPostValue:countField.text forKey:@"count"];
                    [request_39 setPostValue:@"" forKey:@"price"];
                    [request_39 setPostValue:@"" forKey:@"gsp"];
                    [request_39 setPostValue:[NSString stringWithFormat:@"%d",(int)btn.tag-100+1] forKey:@"combin_version"];
                    [request_39 setPostValue:@"suit" forKey:@"buy_type"];//part为配件购买
                    NSDictionary *dic = [zuheArray objectAtIndex:i];
                    NSArray *aaaa = (NSArray *)[dic objectForKey:@"goods_list"];
                    NSString *str;
                    for(int i=0;i<aaaa.count;i++){
                        if (str.length == 0) {
                            str = [NSString stringWithFormat:@",%@",[[aaaa objectAtIndex:i] objectForKey:@"goods_id"]];
                        }else{
                            str = [NSString stringWithFormat:@"%@,%@",str,[[aaaa objectAtIndex:i] objectForKey:@"goods_id"]];
                        }
                    }
                    [request_39 setPostValue:str forKey:@"combin_ids"];
                    [request_39 setPostValue:@"" forKey:@"cart_mobile_ids"];
                    
                    [request_39 setRequestHeaders:[LJControl requestHeaderDictionary]];
                    request_39.tag = 111;
                    request_39.delegate =self;
                    [request_39 setDidFailSelector:@selector(addCaroff_urlRequestFailed:)];
                    [request_39 setDidFinishSelector:@selector(addCaroff_urlRequestSucceeded:)];
                    [request_39 startAsynchronous];
                }else{
                    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ADDCAR_URL]];
                    request_40=[ASIFormDataRequest requestWithURL:url];
                    [request_40 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
                    [request_40 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
                    
                    [request_40 setPostValue:sec.detail_id forKey:@"goods_id"];
                    [request_40 setPostValue:countField.text forKey:@"count"];
                    [request_40 setPostValue:@"" forKey:@"price"];
                    [request_40 setPostValue:@"" forKey:@"gsp"];
                    [request_40 setPostValue:[NSString stringWithFormat:@"%d",(int)btn.tag-100+1] forKey:@"combin_version"];
                    [request_40 setPostValue:@"suit" forKey:@"buy_type"];//part为配件购买
                    NSDictionary *dic = [zuheArray objectAtIndex:i];
                    NSArray *aaaa = (NSArray *)[dic objectForKey:@"goods_list"];
                    NSString *str;
                    for(int i=0;i<aaaa.count;i++){
                        if (str.length == 0) {
                            str = [NSString stringWithFormat:@",%@",[[aaaa objectAtIndex:i] objectForKey:@"goods_id"]];
                        }else{
                            str = [NSString stringWithFormat:@"%@,%@",str,[[aaaa objectAtIndex:i] objectForKey:@"goods_id"]];
                        }
                    }
                    [request_40 setPostValue:str forKey:@"combin_ids"];
                    [request_40 setPostValue:@"" forKey:@"cart_mobile_ids"];
                    //加参数area_id
                    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
                    NSString *areaId=[standard objectForKey:@"area_id"];
                    [request_46 setPostValue:areaId forKey:@"area_id"];
                    
                    [request_40 setRequestHeaders:[LJControl requestHeaderDictionary]];
                    request_40.tag = 110;
                    request_40.delegate =self;
                    [request_40 setDidFailSelector:@selector(addCaron_urlRequestFailed:)];
                    [request_40 setDidFinishSelector:@selector(addCaron_urlRequestSucceeded:)];
                    [request_40 startAsynchronous];
                }
            }
        }
    }
}


-(void)specBtnClicked:(UIButton *)btn{
    _currentSpecBtn.selected = NO;
    _currentSpecBtn = btn;
    _currentSpecBtn.selected = YES;
    NSString *str = [specSelectArray objectAtIndex:btn.tag/100-1];
    NSArray *arr = [str componentsSeparatedByString:@"~"];
    NSString *newStr = [NSString stringWithFormat:@"%@~",[arr objectAtIndex:0]];
    //拿到点击那个按钮的id
    ClassifyModel *class = [specificationsArray objectAtIndex:btn.tag/100-1];
    NSArray *arrSpec = (NSArray *)class.specifications_spec_values;
    newStr = [NSString stringWithFormat:@"%@%@~",newStr,[[arrSpec objectAtIndex:btn.tag%100] objectForKey:@"val"]];
    newStr = [NSString stringWithFormat:@"%@%@",newStr,[[arrSpec objectAtIndex:btn.tag%100] objectForKey:@"id"]];
    [specSelectArray replaceObjectAtIndex:btn.tag/100-1 withObject:newStr];
    [SpecTableView reloadData];
    
    //发起请求库存
    SecondViewController *sec = [SecondViewController sharedUserDefault];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,SPECIFICATIONSBACK_URL]];
    request_41=[ASIFormDataRequest requestWithURL:url];
    if (specSelectArray.count!=0) {
        NSString *str;
        for(int i=0;i<specSelectArray.count;i++){
            if (str.length == 0) {
                str = [[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2];
            }else{
                str = [NSString stringWithFormat:@"%@,%@",str,[[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2]];
            }
        }
        [request_41 setPostValue:str forKey:@"gsp"];
    }
    [request_41 setPostValue:sec.detail_id forKey:@"id"];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:readPath];
    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
    if([fileManagerDong fileExistsAtPath:readPath] == NO){
        
        [request_24 setPostValue:@"" forKey:@"user_id"];
        [request_24 setPostValue:@"" forKey:@"token"];
    }else{
        [request_24 setPostValue:[fileContent objectAtIndex:3] forKey:@"user_id"];
        [request_24 setPostValue:[fileContent objectAtIndex:1] forKey:@"token"];
    }
    

    
    ///读取本地id
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    NSString *areaId=[standard objectForKey:@"area_id"];
    [request_24 setPostValue:areaId forKey:@"area_id"];
    
    [request_41 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_41.tag = 114;
    request_41.delegate =self;
    [request_41 setDidFailSelector:@selector(spec3_urlRequestFailed:)];
    [request_41 setDidFinishSelector:@selector(spec3_urlRequestSucceeded:)];
    [request_41 startAsynchronous];
}
-(void)disappearRegion{
    regionView.hidden = YES;
   
    for (UIView *subView in regionView.subviews)
    {
        [subView removeFromSuperview];
    }
}
-(void)btnClicked:(UIButton *)btn{
    SecondViewController *sec = [SecondViewController sharedUserDefault];
    for(int i=0;i<maylikeArray.count;i++){
        ClassifyModel *ccc = [maylikeArray objectAtIndex:i];
        if (i==btn.tag-1100) {
            sec.detail_id = ccc.detail_goods_main_id;
            DetailViewController *detauk = [[DetailViewController alloc]init];
            [self.navigationController pushViewController:detauk animated:YES];
        }
    }
    
    if(btn.tag == 3){
        [SYObject startLoading];
        regionStr = @"";
        regionIdStr=@"";
        
        UIImageView *alphView2 = [[UIImageView alloc]initWithFrame:CGRectMake(regionView.frame.origin.x, regionView.frame.origin.y, regionView.frame.size.width, regionView.frame.size.height)];
        alphView2.backgroundColor = [UIColor colorWithRed:44/255.0f green:44/255.0f blue:44/255.0f alpha:1];
        alphView2.alpha = 0.7;
        alphView2.userInteractionEnabled = YES;
        [regionView addSubview:alphView2];
        
        UITapGestureRecognizer *singleTapGestureRecognizer3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappearRegion)];
        [singleTapGestureRecognizer3 setNumberOfTapsRequired:1];
        [alphView2 addGestureRecognizer:singleTapGestureRecognizer3];
        
        RegoinTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        RegoinTableView.delegate = self;
        RegoinTableView.dataSource=  self;
        RegoinTableView.alpha = 1;
        RegoinTableView.showsVerticalScrollIndicator=NO;
        RegoinTableView.showsHorizontalScrollIndicator = NO;
        
        //顶部 请选择地区label；底部下一步按钮
        UILabel *labelPleaseSelect = [[UILabel alloc]initWithFrame:CGRectMake(36, RegoinTableView.frame.origin.y-40, RegoinTableView.frame.size.width, 45)];
        labelPleaseSelect.text = @"请选择地区";
        labelPleaseSelect.textColor = MY_COLOR;
        labelPleaseSelect.font = [UIFont systemFontOfSize:15];
        labelPleaseSelect.textAlignment = NSTextAlignmentCenter;
        labelPleaseSelect.backgroundColor = [UIColor whiteColor];
        CALayer *layPS = labelPleaseSelect.layer;
        [layPS setMasksToBounds:YES];
        [layPS setCornerRadius:5.0f];
        [regionView addSubview:labelPleaseSelect];
        UIButton *buttonC = [UIButton buttonWithType:UIButtonTypeCustom ];
//        buttonC.frame =CGRectMake(215, 5, 30, 30);
        buttonC.frame =CGRectMake(RegoinTableView.frame.size.width-40, 5, 30, 30);
        [buttonC setTitle:@"❌" forState:UIControlStateNormal];
        [buttonC addTarget:self action:@selector(regionCancel) forControlEvents:UIControlEventTouchUpInside];
        [labelPleaseSelect addSubview:buttonC];
        //下一步
        UIImageView *nextView = [[UIImageView alloc]initWithFrame:CGRectMake(36, RegoinTableView.frame.origin.y+RegoinTableView.frame.size.height-5, RegoinTableView.frame.size.width, 40)];
        nextView.backgroundColor = [UIColor whiteColor];
        nextView.userInteractionEnabled = YES;
        CALayer *layNV = nextView.layer;
        [layNV setMasksToBounds:YES];
        [layNV setCornerRadius:5.0f];
        [regionView addSubview:nextView];
        buttonNext = [UIButton buttonWithType:UIButtonTypeCustom ];
        buttonNext.frame =CGRectMake(10, 10, RegoinTableView.frame.size.width-20, 25);
        [buttonNext setTitle:@"下一步" forState:UIControlStateNormal];
        [buttonNext addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
        buttonNext.enabled = NO;
        buttonNext.backgroundColor = [UIColor grayColor];
        [nextView addSubview:buttonNext];
        
        [regionView addSubview:RegoinTableView];
        
        regionView.hidden = NO;
        NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,REGION_URL]];
        request_43=[ASIFormDataRequest requestWithURL:url2];
        
        [request_43 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request_43.tag = 103;
        request_43.delegate =self;
        [request_43 setDidFailSelector:@selector(region1_urlRequestFailed:)];
        [request_43 setDidFinishSelector:@selector(region1_urlRequestSucceeded:)];
        [request_43 startAsynchronous];
    }
    if (btn.tag == 101) {
        [SYObject startLoading];
        btnAddCar.enabled = NO;
        button2add.enabled = NO;
       
        if (dataArray.count!=0) {
            ClassifyModel *classifyKu = [dataArray objectAtIndex:0];
            if ([classifyKu.detail_goods_inventory intValue]>0){
                //发起加入购物车请求
                NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *documentsPath = [docPath objectAtIndex:0];
                NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
                NSFileManager *fileManagerDong = [NSFileManager defaultManager];
                if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ADDCAR_URL]];
                    request_44=[ASIFormDataRequest requestWithURL:url];
                    [request_44 setPostValue:countField.text forKey:@"count"];
                    if ([status isEqualToString:@"促销"]) {
                        [request_44 setPostValue:classifyKu.detail_goods_current_price forKey:@"price"];
                    }else{
                        [request_44 setPostValue:classifyKu.detail_goods_current_price forKey:@"price"];
                    }
                    if (specSelectArray.count!=0) {
                        NSString *str;
                        for(int i=0;i<specSelectArray.count;i++){
                            if (str.length == 0) {
                                str = [[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2];
                            }else{
                                str = [NSString stringWithFormat:@"%@,%@",str,[[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2]];
                            }
                        }
                        [request_44 setPostValue:str forKey:@"gsp"];
                    }
                    [request_44 setPostValue:@"" forKey:@"cart_mobile_ids"];
                    [request_44 setPostValue:sec.detail_id forKey:@"goods_id"];
                    //加参数area_id
                    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
                    NSString *areaId=[standard objectForKey:@"area_id"];
                    [request_46 setPostValue:areaId forKey:@"area_id"];
                    
                    [request_44 setRequestHeaders:[LJControl requestHeaderDictionary]];
                    request_44.tag = 111;
                    request_44.delegate =self;
                    [request_44 setDidFailSelector:@selector(addCaroff_urlRequestFailed:)];
                    [request_44 setDidFinishSelector:@selector(addCaroff_urlRequestSucceeded:)];
                    [request_44 startAsynchronous];
                }else{
                    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ADDCAR_URL]];
                    request_45=[ASIFormDataRequest requestWithURL:url];
                    [request_45 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
                    [request_45 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
                    [request_45 setPostValue:sec.detail_id forKey:@"goods_id"];
                    [request_45 setPostValue:countField.text forKey:@"count"];
                    if ([status isEqualToString:@"促销"]) {
                        NSString *str = [NSString stringWithFormat:@"%0.2f",act_rate*[classifyKu.detail_goods_current_price floatValue]];
                        [request_45 setPostValue:str forKey:@"price"];
                    }else{
                        [request_45 setPostValue:classifyKu.detail_goods_current_price forKey:@"price"];
                    }
                    if (specSelectArray.count!=0) {
                        NSString *str;
                        for(int i=0;i<specSelectArray.count;i++){
                            if (str.length == 0) {
                                str = [[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2];
                            }else{
                                str = [NSString stringWithFormat:@"%@,%@",str,[[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2]];
                            }
                        }
                        [request_45 setPostValue:str forKey:@"gsp"];
                    }
                    [request_45 setPostValue:@"" forKey:@"cart_mobile_ids"];
                    
                    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
                    NSString *areaId=[standard objectForKey:@"area_id"];
                    [request_45 setPostValue:areaId forKey:@"area_id"];
                    
                    [request_45 setRequestHeaders:[LJControl requestHeaderDictionary]];
                    request_45.tag = 110;
                    request_45.delegate =self;
                     NSLog(@"%@",request_45);
                    [request_45 setDidFailSelector:@selector(addCaron_urlRequestFailed:)];
                    [request_45 setDidFinishSelector:@selector(addCaron_urlRequestSucceeded:)];
                    [request_45 startAsynchronous];
                   
                }
            }else{
                [SYObject endLoading];
                [SYObject failedPrompt:@"库存不足"];
                
            }
        }
    }
    if (btn.tag == 102) {
        //若没有登录应该跳转到登录页面 若已登录则判断库存够不够
        _semiTransparentView.hidden=YES;
        _specifView.hidden=YES;
        
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
            labelTi.hidden = NO;
            labelTi.text = @"登录后才可立即购买,请登录!";
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimerLogin) userInfo:nil repeats:NO];
        }else{
//            btn.enabled = NO;
            if (dataArray.count!=0) {
                ClassifyModel *classifyKu = [dataArray objectAtIndex:0];
                if ([classifyKu.detail_goods_inventory intValue]>0){
                   
                    
                    
                    NSString *statu = classifyKu.detail_goodsstatus_info;
                    BOOL preOrder = [statu hasPrefix:@"预售商品"];
                    //如果是预售商品，不让加入购物车.
                    if (!preOrder) {
    
                        if([status isEqualToString:@"F码"]){
//                            FCode_bottomView.hidden = NO;
//                            FBuyView.hidden = NO;
                            FCodeView.hidden = NO;
                            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height)];
                            image.backgroundColor = [UIColor blackColor];
                            image.alpha = 0.5;
                            image.userInteractionEnabled = YES;
                            [FCodeView addSubview:image];
                            UITapGestureRecognizer *singleTapGestureRecognizer3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(FcodeDisappear)];
                            [singleTapGestureRecognizer3 setNumberOfTapsRequired:1];
                            [image addGestureRecognizer:singleTapGestureRecognizer3];
                            
                            UIView *whiteV = [[UIView alloc]initWithFrame:CGRectMake(20, 60, ScreenFrame.size.width-40, 135)];
                            whiteV.backgroundColor = [UIColor whiteColor];
                            [whiteV.layer setMasksToBounds:YES];
                            [whiteV.layer setCornerRadius:8.0];
                            [FCodeView addSubview:whiteV];
                            UILabel *labelT = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, whiteV.frame.size.width, 40)];
                            labelT.backgroundColor = UIColorFromRGB(0xf15353);
                            labelT.text = @"请输入F码";
                            labelT.textColor = [UIColor whiteColor];
                            labelT.font = [UIFont boldSystemFontOfSize:18];
                            labelT.textAlignment = NSTextAlignmentCenter;
                            [whiteV addSubview:labelT];
                            
                            phoneNumFieldFF = [[UITextField alloc] initWithFrame:CGRectMake(35, 110, whiteV.frame.size.width-30, 40)];
                            phoneNumFieldFF.layer.borderWidth = 1;
                            phoneNumFieldFF.layer.borderColor = [[UIColor grayColor] CGColor];
                            phoneNumFieldFF.placeholder = @"请输入F码";
                            phoneNumFieldFF.font = [UIFont systemFontOfSize:15];
                            phoneNumFieldFF.delegate = self;
                            [FCodeView addSubview:phoneNumFieldFF];
                            
                            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            btn.frame = CGRectMake(40, 160, 60, 26);
                            btn.tag = 101;
                            btn.backgroundColor =UIColorFromRGB(0xf15353);
                            [btn setTitle:@"确定" forState:UIControlStateNormal];
                            [btn addTarget:self action:@selector(btnFcodeClicked:) forControlEvents:UIControlEventTouchUpInside];
                            [btn.layer setMasksToBounds:YES];
                            [btn.layer setCornerRadius:4.0];
                            [FCodeView addSubview:btn];
                            
                            UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
                            btn2.frame = CGRectMake(whiteV.frame.size.width-60, 160, 60, 26);
                            btn2.tag = 102;
                            [btn2 setTitle:@"取消" forState:UIControlStateNormal];
                            [btn2 addTarget:self action:@selector(btnFcodeClicked:) forControlEvents:UIControlEventTouchUpInside];
                            btn2.backgroundColor = [UIColor grayColor];
                            [btn2.layer setMasksToBounds:YES];
                            [btn2.layer setCornerRadius:4.0];
                            [FCodeView addSubview:btn2];
                            
                            
                        }else{
                            FCode_bottomView.hidden = YES;
                            FBuyView.hidden = YES;
                            
                            //发起轻松购请求
                            [SYObject startLoading];
                            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ADDCAR_URL]];
                            request_46=[ASIFormDataRequest requestWithURL:url];
                            [request_46 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
                            [request_46 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
                            [request_46 setPostValue:sec.detail_id forKey:@"goods_id"];
                            [request_46 setPostValue:countField.text forKey:@"count"];
                            if ([status isEqualToString:@"促销"]) {
                                CGFloat rate=act_rate *0.1;
                                NSString *rate1=[NSString stringWithFormat:@"%0.2f",rate];
                                [request_46 setPostValue:[NSString stringWithFormat:@"%0.2f",[classifyKu.detail_goods_current_price floatValue]* [rate1 floatValue]] forKey:@"price"];
                            }else{
                                [request_46 setPostValue:classifyKu.detail_goods_current_price forKey:@"price"];
                            }
                            if (specSelectArray.count!=0) {
                                NSString *str;
                                for(int i=0;i<specSelectArray.count;i++){
                                    if (str.length == 0) {
                                        str = [[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2];
                                    }else{
                                        str = [NSString stringWithFormat:@"%@,%@",str,[[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2]];
                                    }
                                }
                                [request_46 setPostValue:str forKey:@"gsp"];
                            }
                            [request_46 setPostValue:@"" forKey:@"cart_mobile_ids"];
                            //加参数area_id
                            NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
                            NSString *areaId=[standard objectForKey:@"area_id"];
                            [request_46 setPostValue:areaId forKey:@"area_id"];
                            
                            [request_46 setRequestHeaders:[LJControl requestHeaderDictionary]];
                            request_46.delegate =self;
                            [request_46 setDidFailSelector:@selector(esaypay_urlRequestFailed:)];
                            [request_46 setDidFinishSelector:@selector(esaypay_urlRequestSucceeded:)];
                            [request_46 startAsynchronous];
                    }
                    
                    }else
                    {
                        
                        if ([classifyKu.detail_advance_ding_pay isEqualToString:@"0"]) {
                            [SYObject failedPrompt:@"抱歉,该商品已超出预付定金的期限"];
                            
                        }else if([classifyKu.detail_advance_ding_pay isEqualToString:@"1"]){
                            
                            //发起轻松购请求
                            [SYObject startLoading];
                            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ADDCAR_URL]];
                            request_46=[ASIFormDataRequest requestWithURL:url];
                            [request_46 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
                            [request_46 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
                            [request_46 setPostValue:sec.detail_id forKey:@"goods_id"];
                            [request_46 setPostValue:countField.text forKey:@"count"];
                            if ([status isEqualToString:@"促销"]) {
                                CGFloat rate=act_rate *0.1;
                                NSString *rate1=[NSString stringWithFormat:@"%0.2f",rate];
                                [request_46 setPostValue:[NSString stringWithFormat:@"%0.2f",[classifyKu.detail_goods_current_price floatValue]* [rate1 floatValue]] forKey:@"price"];
                            }else{
//                                [request_46 setPostValue:classifyKu.detail_goods_current_price forKey:@"price"];
                                 [request_46 setPostValue:classifyKu.detail_advance_ding forKey:@"price"];
                                
                            }
                            if (specSelectArray.count!=0) {
                                NSString *str;
                                for(int i=0;i<specSelectArray.count;i++){
                                    if (str.length == 0) {
                                        str = [[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2];
                                    }else{
                                        str = [NSString stringWithFormat:@"%@,%@",str,[[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:2]];
                                    }
                                }
                                [request_46 setPostValue:str forKey:@"gsp"];
                            }
                            [request_46 setPostValue:@"" forKey:@"cart_mobile_ids"];
                            //加参数area_id
                            NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
                            NSString *areaId=[standard objectForKey:@"area_id"];
                            [request_46 setPostValue:areaId forKey:@"area_id"];
                            
                            [request_46 setRequestHeaders:[LJControl requestHeaderDictionary]];
                            request_46.delegate =self;
                            [request_46 setDidFailSelector:@selector(esaypay_urlRequestFailed:)];
                            [request_46 setDidFinishSelector:@selector(esaypay_urlRequestSucceeded:)];
                            [request_46 startAsynchronous];
                        }
                    
                    
                    }
                    
                }
                else
                {
                [SYObject failedPrompt:@"库存不足"];
                
                }
                
                
            }else{
                //[SYObject failedPrompt:@"库存不足"];
            }
       }
    }
}

-(void)doTimer
{
    [SYObject endLoading];
    labelTi.hidden = YES;
}

-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
    
    UIButton *buttonChat = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonChat.frame =CGRectMake(0, 0, 18, 18);
    [buttonChat setBackgroundImage:[UIImage imageNamed:@"point"] forState:UIControlStateNormal];
    [buttonChat addTarget:self action:@selector(More) forControlEvents:UIControlEventTouchUpInside];
    UIButton *buttonMore = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonMore.frame =CGRectMake(0, 0, 18, 18);
    [buttonMore setBackgroundImage:[UIImage imageNamed:@"cart_icon.png"] forState:UIControlStateNormal];
    [buttonMore addTarget:self action:@selector(goCart) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *bar2 = [[UIBarButtonItem alloc]initWithCustomView:buttonChat];
    UIBarButtonItem *bar3 = [[UIBarButtonItem alloc]initWithCustomView:buttonMore];
    NSArray *arr = [[NSArray alloc]initWithObjects:bar2,bar3, nil];
    self.navigationItem.rightBarButtonItems =arr;
}

- (IBAction)mainBtnClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:NO];
    UIButton *btn = (UIButton *)sender;
    FirstViewController *first = [FirstViewController sharedUserDefault];
    
    if (btn.tag == 101) {
        [first tabbarIndex:0];
    }else if (btn.tag == 102) {
        [first tabbarIndex:1];
    }else if (btn.tag == 103) {
        [first tabbarIndex:2];
    }else if (btn.tag == 104) {
        [first tabbarIndex:3];
    }else{
        [first tabbarIndex:4];
    }
}
#pragma mark - 下拉菜单
-(void)More{
    self.tdv.hidden = NO;
    self.tdv.tri.hidden=NO;
}
-(void)chat{
    if (dataArray.count!=0) {
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
            [self.navigationController popToRootViewControllerAnimated:YES];
            self.tabBarController.selectedIndex = 4;
        }else{
            ClassifyModel *class = [dataArray objectAtIndex:0];
            SecondViewController *sec  = [SecondViewController sharedUserDefault];
            NSLog(@"%@",class.detail_id);
            sec.detail_id = class.detail_id;
            ChatViewController *chat = [[ChatViewController alloc]init];
            [self.navigationController pushViewController:chat animated:YES];
        }
    }
}
-(void)goCart{
    NSMutableArray *oldVCs = [self.navigationController.viewControllers mutableCopy];
    for (int i=0; i<oldVCs.count; i++) {
        UIViewController *vc=[oldVCs objectAtIndex:i];
        if ([vc isKindOfClass:[CartViewController class]]) {
            [oldVCs removeObjectAtIndex:i];
            [oldVCs removeObjectAtIndex:i-1];
        }
    }
    self.navigationController.viewControllers = oldVCs;
    CartViewController *car=[[CartViewController alloc]init];
    [self.navigationController pushViewController:car animated:YES];
 
}
-(void)goStore{
    ClassifyModel *classify = [dataArray objectAtIndex:0];
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    th.store_id = [classify.detail_store_info objectForKey:@"store_id"];
    StoreHomeViewController2 *storeVC = [[StoreHomeViewController2 alloc]init];
    [self.navigationController pushViewController:storeVC animated:YES];
}
-(void)favourite{
    if (favouiteBool == NO) {
        [SYObject startLoading];
        SecondViewController *sec = [SecondViewController sharedUserDefault];
        //发起关注请求 并将按钮设置成红色 GUANZHU_URL
        NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ATTENTION_URL]];
        request_49=[ASIFormDataRequest requestWithURL:url2];
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
            labelTi.hidden = NO;
            labelTi.text = @"登录后才可收藏,请登录!";
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimerLogin) userInfo:nil repeats:NO];
        }else{
            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
            [request_49 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
            [request_49 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
            [request_49 setPostValue:sec.detail_id forKey:@"goods_id"];
            [request_49 setPostValue:@"add" forKey:@"type"];
            
            [request_49 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request_49.tag = 105;
            request_49.delegate = self;
            [request_49 setDidFailSelector:@selector(attentionadd_urlRequestFailed:)];
            [request_49 setDidFinishSelector:@selector(attentionadd_urlRequestSucceeded:)];
            [request_49 startAsynchronous];
        }
    }else{
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
        NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ATTENTION_URL]];
        request_1=[ASIFormDataRequest requestWithURL:url3];
        [request_1 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
        [request_1 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];//goods_id
        SecondViewController *sec = [SecondViewController sharedUserDefault];
        [request_1 setPostValue:sec.detail_id forKey:@"goods_id"];
        [request_1 setPostValue:@"del" forKey:@"type"];
        
        [request_1 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request_1.tag = 101;
        request_1.delegate =self;
        [request_1 setDidFailSelector:@selector(attentiondel_urlRequestFailed:)];
        [request_1 setDidFinishSelector:@selector(attentiondel_urlRequestSucceeded:)];
        [request_1 startAsynchronous];
    }
}

-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - textfield delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField==countField) {
//        [countField resignFirstResponder];
//        [countField1 becomeFirstResponder];
    }
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (textField==countField) {
//        [countField endEditing:YES];
//        [countField1 becomeFirstResponder];
//    }
    if (string.length == 0) {
        //说明是删除的操作
    }else{
        //说明是在添加的操作
        if (dataArray.count!=0) {
            ClassifyModel *class = [dataArray objectAtIndex:0];
            CountExchange = [NSString stringWithFormat:@"%@%@",textField.text,string];
            if([CountExchange intValue]>[class.detail_goods_inventory intValue] && textField != phoneNumFieldFF){
                [textField resignFirstResponder];
                [UIView beginAnimations:@"srcollView" context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:0.275f];
                self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
                [UIView commitAnimations];
                countField.text = [NSString stringWithFormat:@"%@",class.detail_goods_inventory];
            }
        }
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
}
//判断是不是数字
- (BOOL)isMobileField:(NSString *)phoneNumber
{
    if (countField.text.length == 0) {
        return YES;
    }
    NSString *phoneRegex = @"^[0-9]*$";//判断是不是数字的正则表达式
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",phoneRegex];
    
    BOOL isMatch = [phoneTest evaluateWithObject:phoneNumber];
    if (!isMatch) {
        [SYObject failedPrompt:@"请输入数字"];
        return NO;
    }
    return YES;
}
//数量判断
-(NSString *)isNumberField:(NSString *)number{
    NSString *numberString;
    if (dataArray.count!=0) {
        ClassifyModel *class = [dataArray objectAtIndex:0];
        if ([class.detail_goods_inventory intValue]<1) {
            [SYObject failedPrompt:@"库存不足"];
        }else{
            NSLog(@"%@ %@",class.detail_goods_limit,class.detail_goods_buy_count);
            if ([class.detail_goods_limit integerValue]==1) {
                if ([number intValue] > [class.detail_goods_buy_count intValue]) {
                    [SYObject failedPrompt:@"超出限购数量"];
                    numberString = [NSString stringWithFormat:@"%@",class.detail_goods_buy_count];
                }else{
                    if ([number intValue] > [class.detail_goods_inventory intValue]) {
                        [SYObject failedPrompt:@"库存不足"];
                        numberString = [NSString stringWithFormat:@"%@",class.detail_goods_inventory];
                    }else{
                        numberString = [NSString stringWithFormat:@"%d",[number intValue]];
                    }
                    
                }
            }else{
                if ([number intValue] > [class.detail_goods_inventory intValue]) {
                    [SYObject failedPrompt:@"库存不足"];
                    numberString = [NSString stringWithFormat:@"%@",class.detail_goods_inventory];
                }else{
                    numberString = [NSString stringWithFormat:@"%d",[number intValue]];
                }                
            }
        }

    }
    return numberString;

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == countField) {
        //在这里应该判断输入的内容是不是数字
        countField.text=[NSString stringWithFormat:@"%d",[countField.text intValue]];
        if ([self isMobileField:countField.text] == NO) {
            countField.text = @"1";
            countField1.text = @"1";
            [MyTableView reloadData];
            [countField resignFirstResponder];
            [countField1 resignFirstResponder];
        }else{
            if ([countField.text integerValue]==0) {
                countField.text = @"1";
            }
            countField.text=[self isNumberField:countField.text];
            countField1.text = countField.text;
            [MyTableView reloadData];
            [countField resignFirstResponder];
            [countField1 resignFirstResponder];
        }
    }
    if (textField == countField1) {
        countField1.text=[NSString stringWithFormat:@"%d",[countField1.text intValue]];
        //在这里应该判断输入的内容是不是数字
        if ([self isMobileField:countField1.text] == NO) {
            countField.text = @"1";
            countField1.text = @"1";
            [MyTableView reloadData];
            [countField1 resignFirstResponder];
            [countField resignFirstResponder];
        }else{
            if ([countField1.text integerValue]==0) {
                countField1.text = @"1";
            }
            countField1.text=[self isNumberField:countField1.text];
            countField.text=countField1.text;
            [MyTableView reloadData];
            [countField1 resignFirstResponder];
            [countField resignFirstResponder];
        }
    }

    if (textField == phoneNumFieldFF) {
        [textField resignFirstResponder];
        CGFloat keyboardHeight = 226.0f;
        if (self.view.frame.size.height - keyboardHeight <= textField.frame.origin.y + textField.frame.size.height) {
            [UIView beginAnimations:@"srcollView" context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.275f];
            self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
        }
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == countField) {
        //在这里应该判断输入的内容是不是数字
        countField.text=[NSString stringWithFormat:@"%d",[countField.text intValue]];
        if ([self isMobileField:countField.text] == NO) {
            countField.text = @"1";
            countField1.text = @"1";
            [MyTableView reloadData];
            [countField resignFirstResponder];
            [countField1 resignFirstResponder];
        }else{
            if ([countField.text integerValue]==0) {
                countField.text = @"1";
            }
            countField.text=[self isNumberField:countField.text];
            countField1.text = countField.text;
            [MyTableView reloadData];
            [countField resignFirstResponder];
            [countField1 resignFirstResponder];
        }
        
    }
    if (textField == countField1) {
        countField1.text=[NSString stringWithFormat:@"%d",[countField1.text intValue]];
        //在这里应该判断输入的内容是不是数字
        if ([self isMobileField:countField1.text] == NO) {
            countField.text = @"1";
            countField1.text = @"1";
            [MyTableView reloadData];
            [countField1 resignFirstResponder];
            [countField resignFirstResponder];
        }else{
            if ([countField1.text integerValue]==0) {
                countField1.text = @"1";
            }
            countField1.text=[self isNumberField:countField1.text];
            countField.text=countField1.text;
            [MyTableView reloadData];
            [countField1 resignFirstResponder];
            [countField resignFirstResponder];
        }
    }

}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

#pragma mark - webview delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    _reloading = YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:myWebView.scrollView];
    [SYObject endLoading];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:myWebView.scrollView];
    [SYObject endLoading];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request_1 clearDelegatesAndCancel];
    [request_2 clearDelegatesAndCancel];
    [request_3 clearDelegatesAndCancel];
    [request_4 clearDelegatesAndCancel];
    [request_5 clearDelegatesAndCancel];
    [request_6 clearDelegatesAndCancel];
    [request_7 clearDelegatesAndCancel];
    [request_8 clearDelegatesAndCancel];
    [request_9 clearDelegatesAndCancel];
    [request_10 clearDelegatesAndCancel];
    [request_11 clearDelegatesAndCancel];
    [request_12 clearDelegatesAndCancel];
    [request_13 clearDelegatesAndCancel];
    [request_14 clearDelegatesAndCancel];
    [request_15 clearDelegatesAndCancel];
    [request_16 clearDelegatesAndCancel];
    [request_17 clearDelegatesAndCancel];
    [request_18 clearDelegatesAndCancel];
    [request_19 clearDelegatesAndCancel];
    [request_20 clearDelegatesAndCancel];
    [request_21 clearDelegatesAndCancel];
    [request_22 clearDelegatesAndCancel];
    [request_23 clearDelegatesAndCancel];
    [request_24 clearDelegatesAndCancel];
    [request_25 clearDelegatesAndCancel];
    [request_26 clearDelegatesAndCancel];
    [request_27 clearDelegatesAndCancel];
    [request_28 clearDelegatesAndCancel];
    [request_29 clearDelegatesAndCancel];
    [request_30 clearDelegatesAndCancel];
    [request_31 clearDelegatesAndCancel];
    [request_32 clearDelegatesAndCancel];
    [request_33 clearDelegatesAndCancel];
    [request_34 clearDelegatesAndCancel];
    [request_35 clearDelegatesAndCancel];
    [request_36 clearDelegatesAndCancel];
    [request_37 clearDelegatesAndCancel];
    [request_38 clearDelegatesAndCancel];
    [request_39 clearDelegatesAndCancel];
    [request_40 clearDelegatesAndCancel];
    [request_41 clearDelegatesAndCancel];
    [request_42 clearDelegatesAndCancel];
    [request_43 clearDelegatesAndCancel];
    [request_44 clearDelegatesAndCancel];
    [request_45 clearDelegatesAndCancel];
    [request_46 clearDelegatesAndCancel];
    [request_47 clearDelegatesAndCancel];
    [request_48 clearDelegatesAndCancel];
    [request_49 clearDelegatesAndCancel];
    [SYObject endLoading];
}
-(void)viewWillAppear:(BOOL)animated{
       [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden = YES;
    
//    //刷新商品详情页
//    [self getReloadData];
    //发起得到购物车数量的请求
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
    if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
        NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,MYCAR_URL]];
        request_2=[ASIFormDataRequest requestWithURL:url3];
        [request_2 setPostValue:@"" forKey:@"user_id"];
        [request_2 setPostValue:@"" forKey:@"token"];
        
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
            [request_2 setPostValue:@"" forKey:@"cart_mobile_ids"];
        }else{
            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
            [request_2 setPostValue:[fileContent2 objectAtIndex:0] forKey:@"cart_mobile_ids"];
           
        }
        
        [request_2 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request_2.tag = 101;
        request_2.delegate = self;
        [request_2 setDidFailSelector:@selector(carCountoff_urlRequestFailed:)];
        [request_2 setDidFinishSelector:@selector(carCountoff_urlRequestSucceeded:)];
        [request_2 startAsynchronous];
    }else{
        //已经登录
        //发起得到购物车数量的请求
        NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,CARGOODS_COUNT]];
        request_3=[ASIFormDataRequest requestWithURL:url2];
        if([fileManagerDong fileExistsAtPath:filePathDong] == NO){
            [request_3 setPostValue:@"" forKey:@"user_id"];
            [request_3 setPostValue:@"" forKey:@"token"];
        }else{
            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
            [request_3 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
            [request_3 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
        }
        
        [request_3 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request_3.tag = 102;
        [request_3 setDidFailSelector:@selector(goodsCount_urlRequestFailed:)];
        [request_3 setDidFinishSelector:@selector(goodsCount_urlRequestSucceeded:)];
        [request_3 startAsynchronous];
        
    }
 
    
    //发起请求规格
     SecondViewController *sec = [SecondViewController sharedUserDefault];
    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,SPECIFICATIONS_URL]];
    request_23=[ASIFormDataRequest requestWithURL:url3];
    [request_23 setPostValue:sec.detail_id forKey:@"id"];
    
    [request_23 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_23.tag = 102;
    request_23.delegate = self;
    [request_23 setDidFailSelector:@selector(spec2_urlRequestFailed:)];
    [request_23 setDidFinishSelector:@selector(spec2_urlRequestSucceeded:)];
    [request_23 startAsynchronous];
}

#pragma mark UIScrollViewDelegate Methods
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView==_containerScrollView) {
        CGPoint p = scrollView.contentOffset;
        if (p.x == ScreenFrame.size.width) {
            //详情页面
            [self naviButtonClicked:self.detailBtn];
        }else if (p.x == 2*ScreenFrame.size.width){
            //评价页面
            [self naviButtonClicked:self.evaluateBtn];
        }else{
            //第一个页面
            [self naviButtonClicked:self.goodsHomePageBtn];
        }
    }else if (scrollView==_myScrollView2){
        CGPoint p = scrollView.contentOffset;
        NSInteger count=p.x/ScreenFrame.size.width+1;
        pagelabel.text=[NSString stringWithFormat:@"%ld/%ld",(long)count,(long)arrImage.count];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == myWebView.scrollView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    if (aScrollView==_containerScrollView) {
        //控制黄块滑动
        CGPoint p = aScrollView.contentOffset;
        CGFloat rate = p.x/(ScreenFrame.size.width*2);
        //rate从0.0->0.5->1.0渐变
        CGFloat tx = rate * (self.headNaviView.frame.size.width-self.goodsHomePageBtn.frame.size.width);
        self.whiteView.transform = CGAffineTransformMakeTranslation(tx, 0);
        //利用方向和当前位置rate来判断三个按钮的颜色
        if (rate>0&&rate<0.5) {
            _goodsHomePageBtn.selected = NO;
            _detailBtn.selected = NO;
            _evaluateBtn.selected = NO;
            CGFloat g = rate*255.f/0.5f;
            CGFloat f = 255.f-rate*255.f/0.5f;
            [_goodsHomePageBtn setTitleColor:_K_Color(255.f, 255.f, g) forState:UIControlStateNormal];
            [_detailBtn setTitleColor:_K_Color(255.f, 255.f, f) forState:UIControlStateNormal];
        }
        else if (rate>0.5&&rate<1.0) {
            _goodsHomePageBtn.selected = NO;
            _detailBtn.selected = NO;
            _evaluateBtn.selected = NO;
            CGFloat h = rate*510.f-255.f;
            CGFloat i = 255.f-rate*510.f+255.f;
            [_detailBtn setTitleColor:_K_Color(255.f, 255.f, h) forState:UIControlStateNormal];
            [_evaluateBtn setTitleColor:_K_Color(255.f, 255.f, i) forState:UIControlStateNormal];
        }
        else{
            [_goodsHomePageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_goodsHomePageBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
            [_detailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_detailBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
            [_evaluateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_evaluateBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
        }
    }
    if (aScrollView == myWebView.scrollView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:aScrollView];
    }
    if (aScrollView == _myScrollView22) {
        CGFloat pageWidth = _myScrollView22.bounds.size.width ;
        float fractionalPage = _myScrollView22.contentOffset.x / pageWidth ;
        NSInteger nearestNumber = lround(fractionalPage) ;
        if (pageControl.currentPage != nearestNumber)
        {
            pageControl.currentPage = nearestNumber ;
            
            if (_myScrollView22.dragging)
                [pageControl updateCurrentPageDisplay] ;
        }
    }
    if (aScrollView == _myScrollView2) {
        CGFloat pageWidth = _myScrollView2.bounds.size.width ;
        float fractionalPage = _myScrollView2.contentOffset.x / pageWidth ;
        NSInteger nearestNumber = lround(fractionalPage) ;
        if (page2Control.currentPage != nearestNumber)
        {
            page2Control.currentPage = nearestNumber ;
            
            if (_myScrollView2.dragging)
                [page2Control updateCurrentPageDisplay] ;
        }
    }
    if(aScrollView == MyTableView){
        CGPoint offset = aScrollView.contentOffset;  // 当前滚动位移
        CGRect bounds = aScrollView.bounds;          // UIScrollView 可视高度
        CGSize size = aScrollView.contentSize;         // 滚动区域
        UIEdgeInsets inset = aScrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        
        if (y > (h + reload_distance)) {
            if (scrollBool == NO) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:animeDuration];
                CGRect frame = MyTableView.frame;
                frame.origin.y -= ScreenFrame.size.height-44-60;
                [MyTableView setFrame:frame];
                
                CGRect frame2 = myWebView.frame;
                frame2.origin.y -= ScreenFrame.size.height-44-60;
                [myWebView setFrame:frame2];
                
                [_headNaviScrollView setContentOffset:CGPointMake(0, 44)];
                [UIView commitAnimations];
                scrollBool = YES;
            }else{
            }
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)aScrollView
{
    // if we are animating (triggered by clicking on the page control), we update the page control
    if (aScrollView == _myScrollView22) {
        [pageControl updateCurrentPageDisplay] ;
    }
    if (aScrollView == _myScrollView2) {
        [page2Control updateCurrentPageDisplay] ;
    }
    if (aScrollView == myWebView.scrollView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:aScrollView];
    }
}
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    scrollBool = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animeDuration];
    if (MyTableView.frame.origin.y == 64) {
        
    }else{
        CGRect frame = MyTableView.frame;
        frame.origin.y += MyTableView.frame.size.height;
        [MyTableView setFrame:frame];
        
        CGRect frame2 = myWebView.frame;
        frame2.origin.y += MyTableView.frame.size.height;
        [myWebView setFrame:frame2];
        
        [_headNaviScrollView setContentOffset:CGPointMake(0, 0)];
    }
    [UIView commitAnimations];
    
    SecondViewController *sec = [[SecondViewController alloc]init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%@",FIRST_URL,DETAIL_URL2,sec.detail_id]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [myWebView loadRequest:request];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return [NSDate date]; // should return date data source was last changed
}

@end
