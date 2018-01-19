//
//  DetailViewController.m
//  My_App
//
//  Created by apple on 14-7-30.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "storegoodsDetailViewController.h"
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

@interface storegoodsDetailViewController (){
    ASIFormDataRequest *request_1;
    ASIFormDataRequest *request_2;
    ASIFormDataRequest *request_3;
    ASIFormDataRequest *request_4;
    ASIFormDataRequest *request_5;
    ASIFormDataRequest *request_6;
    ASIFormDataRequest *request_7;
    ASIFormDataRequest *request_8;
    ASIFormDataRequest *request_9;
    ASIFormDataRequest *request_10;
    ASIFormDataRequest *request_11;
    ASIFormDataRequest *request_12;
    ASIFormDataRequest *request_13;
    ASIFormDataRequest *request_14;
    ASIFormDataRequest *request_15;
    ASIFormDataRequest *request_16;
    ASIFormDataRequest *request_17;
    ASIFormDataRequest *request_18;
    ASIFormDataRequest *request_19;
    ASIFormDataRequest *request_20;
    ASIFormDataRequest *request_21;
    ASIFormDataRequest *request_22;
    ASIFormDataRequest *request_23;
    ASIFormDataRequest *request_24;
    ASIFormDataRequest *request_25;
    ASIFormDataRequest *request_26;
    ASIFormDataRequest *request_27;
    ASIFormDataRequest *request_28;
    ASIFormDataRequest *request_29;
    ASIFormDataRequest *request_30;
    ASIFormDataRequest *request_31;
    ASIFormDataRequest *request_32;
    ASIFormDataRequest *request_33;
    ASIFormDataRequest *request_34;
    ASIFormDataRequest *request_35;
    ASIFormDataRequest *request_36;
    ASIFormDataRequest *request_37;
    ASIFormDataRequest *request_38;
    ASIFormDataRequest *request_39;
    ASIFormDataRequest *request_40;
    ASIFormDataRequest *request_41;
    ASIFormDataRequest *request_42;
    ASIFormDataRequest *request_43;
    ASIFormDataRequest *request_44;
    ASIFormDataRequest *request_45;
    ASIFormDataRequest *request_46;
    ASIFormDataRequest *request_47;
    ASIFormDataRequest *request_48;
    ASIFormDataRequest *request_49;
}

@end

@implementation storegoodsDetailViewController
- (void)viewDidLoad{
    specSelectBool = NO;
    [super viewDidLoad];
    [self createBackBtn];
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
    selectBool = NO;
    tableBool = NO;
    scrollBool = NO;
    muchBool = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
}
-(void)dealloc {
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    labelTi = nil;
    btn2Qing = nil;
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
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //[self createRootView];
        SecondViewController *sec = [SecondViewController sharedUserDefault];
        self.title = @"商品详情";
        self.view.backgroundColor = [UIColor whiteColor];
        
        if (UIDeviceHao>=7.0) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }else{
            
        }
        regionView = [[UIImageView alloc]init];
        if (ScreenFrame.size.height>480) {//说明是5 5s
            MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ScreenFrame.origin.y+44+20, ScreenFrame.size.width, ScreenFrame.size.height-64-44) style:UITableViewStylePlain];
            regionView.frame = CGRectMake(0, ScreenFrame.origin.y+20, ScreenFrame.size.width, ScreenFrame.size.height);
            RegoinTableView = [[UITableView alloc]initWithFrame:CGRectMake(36, 20+25+80, 248, ScreenFrame.size.height-64-44-30-160) style:UITableViewStylePlain];
        }else{
            MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ScreenFrame.origin.y+44+20, ScreenFrame.size.width, ScreenFrame.size.height-64-44) style:UITableViewStylePlain];
            regionView.frame = CGRectMake(0, ScreenFrame.origin.y+12+20, ScreenFrame.size.width, ScreenFrame.size.height);
            RegoinTableView = [[UITableView alloc]initWithFrame:CGRectMake(36, 20+25+80, 248, ScreenFrame.size.height-64-44-30-160) style:UITableViewStylePlain];
        }
        MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MyTableView.delegate = self;
        MyTableView.dataSource=  self;
        MyTableView.showsVerticalScrollIndicator=NO;
        MyTableView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:MyTableView];
        //添加手势
        UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(MyTableViewGestureRight)];
        rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
        [MyTableView addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];
        UISwipeGestureRecognizer *LeftSwipeGestureRecognizerS = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(MyTableViewGestureLeft)];
        LeftSwipeGestureRecognizerS.direction = UISwipeGestureRecognizerDirectionLeft;
        [MyTableView addGestureRecognizer:LeftSwipeGestureRecognizerS];
        
        regionView.hidden = YES;
        regionView.userInteractionEnabled = YES;
        [self.view addSubview:regionView];
        
        myWebView=[[UIWebView alloc] initWithFrame:CGRectMake(0, MyTableView.frame.size.height+64, ScreenFrame.size.width, ScreenFrame.size.height-64-44)];
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
        
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -180-myWebView.scrollView.bounds.size.height, myWebView.scrollView.frame.size.width, myWebView.scrollView.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        myWebView.scrollView.delegate = self;
        [myWebView.scrollView addSubview:_refreshHeaderView];
        [_refreshHeaderView refreshLastUpdatedDate];
        
        [self createBottomView];
        
        imageViewDarkGray = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height)];
        imageViewDarkGray.backgroundColor = [UIColor blackColor];
        imageViewDarkGray.alpha = 0.7;
        imageViewDarkGray.hidden = YES;
        imageViewDarkGray.userInteractionEnabled = YES;
        [self.view addSubview:imageViewDarkGray];
        //添加手势 轻触后消失
        UITapGestureRecognizer *singleTapGestureRecognizer3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappear)];
        [singleTapGestureRecognizer3 setNumberOfTapsRequired:1];
        [imageViewDarkGray addGestureRecognizer:singleTapGestureRecognizer3];
        UISwipeGestureRecognizer *rightSwipeGestureRecognizerS = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(disappear)];
        rightSwipeGestureRecognizerS.direction = UISwipeGestureRecognizerDirectionRight;
        [imageViewDarkGray addGestureRecognizer:rightSwipeGestureRecognizerS];
        
        specView = [[UIView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width, ScreenFrame.origin.y+44+20, ScreenFrame.size.width, ScreenFrame.size.height-64)];
        [self.view addSubview:specView];
        
        //底部轻松购视图、可输入数量
        UIView *BottomViewSpec = [[UIView alloc]initWithFrame:CGRectMake(00, specView.frame.size.height-44-40, ScreenFrame.size.width-60, 84)];
        BottomViewSpec.backgroundColor = [UIColor whiteColor];
        [specView addSubview:BottomViewSpec];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 26)];
        label.textColor = [UIColor darkGrayColor];
        label.text = @"数量";
        label.font = [UIFont systemFontOfSize:15];
        [BottomViewSpec addSubview:label];
        UILabel *labelB = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 170, 26)];
        labelB.textColor = [UIColor darkGrayColor];
        labelB.text = @"";
        CALayer *lay = labelB.layer;
        [lay setMasksToBounds:YES];
        [lay setCornerRadius:5.0f];
        labelB.font = [UIFont systemFontOfSize:14];
        labelB.layer.borderWidth = 1;
        labelB.userInteractionEnabled = YES;
        labelB.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        [BottomViewSpec addSubview:labelB];
        
        UILabel *labelMinus = [[UILabel alloc]initWithFrame:CGRectMake(50, 9, 26, 26)];
        labelMinus.textColor = [UIColor darkGrayColor];
        labelMinus.text = @"－";
        labelMinus.font = [UIFont systemFontOfSize:18];
        labelMinus.textAlignment = NSTextAlignmentCenter;
        [BottomViewSpec addSubview:labelMinus];
        
        UIImageView *imageShu1 = [[UIImageView alloc]initWithFrame:CGRectMake(26, 0, 1, 26)];
        imageShu1.backgroundColor = [UIColor lightGrayColor];
        [labelB addSubview:imageShu1];
        UIImageView *imageShu2 = [[UIImageView alloc]initWithFrame:CGRectMake(170-26, 0, 1, 26)];
        imageShu2.backgroundColor = [UIColor lightGrayColor];
        [labelB addSubview:imageShu2];
        UIButton *buttonMinus = [UIButton buttonWithType:UIButtonTypeCustom ];
        buttonMinus.frame =CGRectMake(36, 0, 44, 44);
        [buttonMinus addTarget:self action:@selector(newbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        buttonMinus.titleLabel.font  = [UIFont systemFontOfSize:14];
        buttonMinus.tag = 103;
        [BottomViewSpec addSubview:buttonMinus];
        UILabel *labelPlus = [[UILabel alloc]initWithFrame:CGRectMake(250-30-26, 9, 26, 26)];
        labelPlus.textColor = [UIColor darkGrayColor];
        labelPlus.text = @"+";
        labelPlus.font = [UIFont systemFontOfSize:18];
        labelPlus.textAlignment = NSTextAlignmentCenter;
        [BottomViewSpec addSubview:labelPlus];
        UIButton *buttonPlus = [UIButton buttonWithType:UIButtonTypeCustom ];
        buttonPlus.frame =CGRectMake(250-30-26-5, 0, 44, 44);
        [buttonPlus addTarget:self action:@selector(newbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        buttonPlus.tag = 104;
        buttonPlus.titleLabel.font  = [UIFont systemFontOfSize:14];
        [BottomViewSpec addSubview:buttonPlus];
        
        UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, 300, 0.5)];
        imageLine.backgroundColor = [UIColor lightGrayColor];
        [BottomViewSpec addSubview:imageLine];
        
        btn2Qing = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2Qing.frame = CGRectMake(20, 49, 100, 30);
        btn2Qing.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [btn2Qing setTitle:@"立即购买" forState:UIControlStateNormal];
        btn2Qing.backgroundColor = MY_COLOR;
        btn2Qing.tag = 102;
        btn2Qing.layer.cornerRadius = 4;
        btn2Qing.layer.masksToBounds  = YES;
        
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        btn2Qing.backgroundColor = MY_COLOR;
        btn2Qing.enabled = YES;
        btn2Qing.titleLabel.textColor = [UIColor whiteColor];
        [btn2Qing addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [BottomViewSpec addSubview:btn2Qing];
        
        button2add = [UIButton buttonWithType:UIButtonTypeCustom ];
        button2add.frame =CGRectMake(140, 49, 100, 30);
        [button2add setTitle:@"加入购物车" forState:UIControlStateNormal];
        [button2add addTarget:self action:@selector(newbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        button2add.backgroundColor = MY_COLOR;
        button2add.tag = 106;
        button2add.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        button2add.layer.cornerRadius = 4;
        button2add.layer.masksToBounds  = YES;
        [BottomViewSpec addSubview:button2add];
        
        FBuyView = [[UIView alloc]initWithFrame:CGRectMake(0, 44.5, ScreenFrame.size.width, 40)];
        FBuyView.backgroundColor = [UIColor whiteColor];
        [BottomViewSpec addSubview:FBuyView];
        Fbtn2Qing = [UIButton buttonWithType:UIButtonTypeCustom];
        Fbtn2Qing.frame = CGRectMake(40, 5, 200, 30);
        Fbtn2Qing.tag = 102;
        CALayer *layF  = Fbtn2Qing.layer;
        [layF setMasksToBounds:YES];
        [layF setCornerRadius:4.0];
        Fbtn2Qing.backgroundColor = MY_COLOR;
        Fbtn2Qing.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [Fbtn2Qing addTarget:self action:@selector(FCodebtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [Fbtn2Qing setTitle:@"立即购买" forState:UIControlStateNormal];
        [FBuyView addSubview:Fbtn2Qing];
        
        SpecTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,specView.frame.size.width-60,specView.frame.size.height-44-40) style:UITableViewStylePlain];
        SpecTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        SpecTableView.delegate = self;
        SpecTableView.dataSource=  self;
        SpecTableView.showsVerticalScrollIndicator=NO;
        SpecTableView.showsHorizontalScrollIndicator = NO;
        [specView addSubview:SpecTableView];
        UISwipeGestureRecognizer *rightSwipeGestureRecognizerSwip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(disappear)];
        rightSwipeGestureRecognizerSwip.direction = UISwipeGestureRecognizerDirectionRight;
        [SpecTableView addGestureRecognizer:rightSwipeGestureRecognizerSwip];
        //可输入的textfield
        countField = [[UITextField alloc]initWithFrame:CGRectMake(76, BottomViewSpec.frame.origin.y+10, 200-30-52, 26)];
        countField.textAlignment = NSTextAlignmentCenter ;
        countField.text = @"1";
        countField.backgroundColor = [UIColor clearColor];
        countField.font = [UIFont systemFontOfSize:15];
        countField.delegate = self;
        [specView addSubview:countField];
       
        
        WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"取消" leftTarget:self leftAction:@selector(dismissKeyBoard1) rightTitle:@"完成" rightTarget:self rightAction:@selector(dismissKeyBoard)];
        [countField setInputAccessoryView:inputView];
        
        myViewBI = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height)];
        myViewBI.backgroundColor = [UIColor blackColor];
        myViewBI.hidden = YES;
        [self.view addSubview:myViewBI];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, myViewBI.frame.size.width, myViewBI.frame.size.height)];
        image.backgroundColor = [UIColor clearColor];
        image.userInteractionEnabled = YES;
        [myViewBI addSubview:image];
        
        FCodeView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
        FCodeView.hidden = YES;
        [self.view addSubview:FCodeView];
        
        zuheView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
        zuheView.hidden = YES;
        [self.view addSubview:zuheView];
        
        loadingV=[self loadingView:CGRectMake((ScreenFrame.size.width-100)/2, (ScreenFrame.size.height-100)/2, 100, 100)];
        [self.view addSubview:loadingV];
        
        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,DETAIL_URL]];
            request_19=[ASIFormDataRequest requestWithURL:url];
            [request_19 setPostValue:sec.detail_id forKey:@"id"];
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
            NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,DETAIL_URL]];
            request_20=[ASIFormDataRequest requestWithURL:url2];
            [request_20 setPostValue:sec.detail_id forKey:@"id"];
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
        NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,MAYLIKE_URL]];
        request_22=[ASIFormDataRequest requestWithURL:url2];
        [request_22 setPostValue:sec.detail_id forKey:@"id"];
        
        [request_22 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request_22.tag = 106;
        request_22.delegate =self;
        [request_22 setDidFailSelector:@selector(maylike_urlRequestFailed:)];
        [request_22 setDidFinishSelector:@selector(maylike_urlRequestSucceeded:)];
        [request_22 startAsynchronous];
        
        //发起请求规格
        NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,SPECIFICATIONS_URL]];
        request_23=[ASIFormDataRequest requestWithURL:url3];
        [request_23 setPostValue:sec.detail_id forKey:@"id"];
        
        [request_23 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request_23.tag = 102;
        request_23.delegate = self;
        [request_23 setDidFailSelector:@selector(spec2_urlRequestFailed:)];
        [request_23 setDidFinishSelector:@selector(spec2_urlRequestSucceeded:)];
        [request_23 startAsynchronous];
        
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
        [self create_leftUI];
    }
    return self;
}

-(UIView *)loadingView:(CGRect)rect
{
    UIView *loadV=[[UIView alloc]initWithFrame:rect];
    loadV.backgroundColor=[UIColor blackColor];
    loadV.alpha = 0.8;
    UIActivityIndicatorView *activityIndicatorV=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorV.center=CGPointMake(rect.size.width/2, rect.size.height/2-10);
    [activityIndicatorV startAnimating];
    
    [loadV addSubview:activityIndicatorV];
    UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(0, 70, 100, 30)];
    la.text=@"正在加载...";
    la.backgroundColor=[UIColor clearColor];
    la.textAlignment=NSTextAlignmentCenter;
    la.textColor=[UIColor whiteColor];
    la.font=[UIFont boldSystemFontOfSize:15];
    [loadV addSubview:la];
    loadV.layer.cornerRadius=4;
    loadV.layer.masksToBounds=YES;
    return loadV;
}
-(void)create_leftUI{
    muchView = [LJControl MuchView:CGRectMake(self.view.frame.size.width-136, 64, 126, 220)];
    [self.view addSubview:muchView];
    muchView.hidden = YES;
    for (int i=0; i<5; i++) {
        UIButton *btn = [LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(0, 10+i*40, 126, 40) setNormalImage:[UIImage imageNamed:@""] setSelectedImage:[UIImage imageNamed:@""] setTitle:@"" setTitleFont:10 setbackgroundColor:[UIColor clearColor]];
        btn.tag = 101+i;
        [btn addTarget:self action:@selector(mainBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [muchView addSubview:btn];
    }
}
- (void)mainBtnClicked:(id)sender {
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
//TODO:tabelView方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == MyTableView) {
        if (indexPath.row == 0) {
            if (dataArray.count!=0) {
                ClassifyModel *class = [dataArray objectAtIndex:0];
                UILabel *labelPrice222 = [[UILabel alloc]initWithFrame:CGRectMake(10, 340, ScreenFrame.size.width-40, 40)];
                labelPrice222.numberOfLines = 2;
                labelPrice222.font = [UIFont systemFontOfSize:17];
                labelPrice222.text = class.detail_goods_name;
                labelPrice222.numberOfLines = 0;
                
                NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:13]};
                CGRect requiredCGrect = [labelPrice222.text boundingRectWithSize:CGSizeMake(ScreenFrame.size.width-40, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
                
                CGSize requiredSize = requiredCGrect.size;
                return requiredSize.height+20+50+ScreenFrame.size.width+70+50+10;
            }
            return ScreenFrame.size.width+104;
        }
        if (indexPath.row == 1) {
            if (dataArray.count!=0) {
                ClassifyModel *class = [dataArray objectAtIndex:0];
                if (class.detail_status.length == 0) {
                    return 0;
                }
                return 60+10;
            }
            return 90;
        }
        if (indexPath.row == 2) {
            return 44+10;
        }
        if (indexPath.row == 3) {
            if (dataArray.count!=0) {
                ClassifyModel *class = [dataArray objectAtIndex:0];
                if ([class.detail_choice_type intValue]== 1) {
                    return 30+10;
                }else{
                    return 110+10;
                }
            }
            return 0;
        }
        if (indexPath.row == 4) {
            return 44+10;
        }
        if (indexPath.row == 5) {
            return 44+10;
        }
        if (indexPath.row == 6) {
            return 0;
        }
        if (indexPath.row == 7) {
            if (maylikeArray.count!=0) {
                return 140.5+10;
            }else{
                return 0;
            }
        }
        if (indexPath.row == 8){
            return 60;
        }
    }
    if (tableView == RegoinTableView) {
        return 40;
    }
    if (tableView == SpecTableView) {
        if (specificationsArray.count!=0) {
            if (indexPath.row == 0) {
                return 61;
            }else{
                ClassifyModel *class = [specificationsArray objectAtIndex:indexPath.row - 1];
                NSArray *specValues = (NSArray *)class.specifications_spec_values;
                if (specValues.count%2==0) {//说明没有单
                    return 25+35*specValues.count/2;
                }else{
                    if (indexPath.row == 0) {
                        return 61;
                    }else{
                        return 140;
                    }
                }
            }
        }
        return 61;
    }
    if (tableView == zuheTableView){
        return 84;
    }
    if (tableView == zuhepeijianTableView){
        return 94;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == MyTableView) {
        return 9;
    }
    if (tableView == SpecTableView) {
        if (specificationsArray.count!=0) {
            return specificationsArray.count+1;
        }
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
                    [imageVIew sd_setImageWithURL:[NSURL URLWithString:[arrImage objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
                    [_myScrollView2 addSubview:imageVIew];
                }
                page2Control = [[DDPageControl alloc] init] ;
                if (ScreenFrame.size.height<=480) {
                    [page2Control setCenter: CGPointMake(self.view.center.x, self.view.bounds.size.height-235+85)] ;
                }else if (ScreenFrame.size.height>480&&ScreenFrame.size.height<=568){
                    [page2Control setCenter: CGPointMake(self.view.center.x, self.view.bounds.size.height-235)] ;
                }else if (ScreenFrame.size.height>568&&ScreenFrame.size.height<=1334/2){
                    [page2Control setCenter: CGPointMake(self.view.center.x, self.view.bounds.size.height-280)] ;
                }else{
                    [page2Control setCenter: CGPointMake(self.view.center.x, self.view.bounds.size.height-310)] ;
                }
                
                [page2Control setNumberOfPages: arrImage.count] ;
                [page2Control setCurrentPage: 0] ;
                [page2Control addTarget: self action: @selector(pageControlClicked2:) forControlEvents: UIControlEventValueChanged] ;
                [page2Control setDefersCurrentPageDisplay: YES] ;
                [page2Control setType: DDPageControlTypeOnFullOffEmpty] ;
                [page2Control setOnColor: MY_COLOR] ;
                [page2Control setOffColor: [UIColor grayColor]] ;
                [page2Control setIndicatorDiameter: 10.0f] ;
                [page2Control setIndicatorSpace: 10.0f] ;
                [cell addSubview: page2Control] ;
                
                UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap)];
                [singleTapGestureRecognizer setNumberOfTapsRequired:1];
                [_myScrollView2 addGestureRecognizer:singleTapGestureRecognizer];
                UIView *grayView = [[UIView alloc]init];
                grayView.backgroundColor = BACKGROUNDCOLOR;
                [cell addSubview:grayView];
                UILabel *labelPrice222 = [[UILabel alloc]initWithFrame:CGRectMake(10, ScreenFrame.size.width+20, ScreenFrame.size.width-40, 46)];
                labelPrice222.numberOfLines = 2;
                labelPrice222.font = [UIFont systemFontOfSize:17];
                labelPrice222.text = classify.detail_goods_name;
                [cell addSubview:labelPrice222];
                labelPrice222.backgroundColor = BACKGROUNDCOLOR;
                labelPrice222.numberOfLines = 0;
                
                NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:17]};
                CGRect requiredCGrect = [labelPrice222.text boundingRectWithSize:CGSizeMake(ScreenFrame.size.width-40, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
                
                CGSize requiredSize = requiredCGrect.size;
                labelPrice222.frame = CGRectMake(10, ScreenFrame.size.width+20, ScreenFrame.size.width-40, requiredSize.height+10);
                grayView.frame = CGRectMake(0, ScreenFrame.size.width+20, ScreenFrame.size.width, requiredSize.height+10);
                //是自营还是第三方 标示
                if([classify.detail_goods_type intValue] == 1){//不是商城的
                    
                }else{
                    UILabel *labelRed = [[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-32, ScreenFrame.size.width+20+(requiredSize.height-16)/2, 22, 13)];
                    labelRed.numberOfLines = 2;
                    labelRed.backgroundColor = [UIColor redColor];
                    labelRed.font = [UIFont boldSystemFontOfSize:10];
                    labelRed.text = @"自营";
                    labelRed.textAlignment = NSTextAlignmentCenter;
                    labelRed.textColor=[UIColor whiteColor];
                    [cell addSubview:labelRed];
                }
                
                //价钱
                UILabel *money = [[UILabel alloc]initWithFrame:CGRectMake(10, ScreenFrame.size.width+30+requiredSize.height+10, 20, 24)];
                money.text = @"￥";
                money.textColor = [UIColor redColor];
                money.font = [UIFont boldSystemFontOfSize:15];
                [cell addSubview:money];
                UILabel *labelcurrent_price = [[UILabel alloc]initWithFrame:CGRectMake(32, ScreenFrame.size.width+30+requiredSize.height+10, ScreenFrame.size.width-30, 20)];
                labelcurrent_price.font = [UIFont boldSystemFontOfSize:22];
                labelcurrent_price.text = [NSString stringWithFormat:@"%@",classify.detail_goods_current_price];
                labelcurrent_price.textColor = [UIColor redColor];
                if (act_rate==0) {
                    
                }else{
                    //在这个位置是折后的价格
                    labelcurrent_price.text = [NSString stringWithFormat:@"%0.2f",[classify.detail_goods_current_price floatValue]*act_rate];
                }
                [cell addSubview:labelcurrent_price];
                UILabel *labelO = [[UILabel alloc]initWithFrame:CGRectMake(10, labelcurrent_price.frame.origin.y+labelcurrent_price.frame.size.height, 100, 30)];
                labelO.text = @"价格:";
                labelO.font = [UIFont systemFontOfSize:13];
                labelO.textColor = [UIColor lightGrayColor];
                [cell addSubview:labelO];
                UILabel *labelOp = [[UILabel alloc]initWithFrame:CGRectMake(40, labelcurrent_price.frame.origin.y+labelcurrent_price.frame.size.height, 100, 30)];
                labelOp.text = @"￥199.00";
                labelOp.font = [UIFont systemFontOfSize:13];
                labelOp.textColor = [UIColor lightGrayColor];
                [cell addSubview:labelOp];
                UIImageView *imageL = [[UIImageView alloc]initWithFrame:CGRectMake(15, labelOp.frame.origin.y+labelOp.frame.size.height, ScreenFrame.size.width-30, 0.5)];
                imageL.backgroundColor = [UIColor lightGrayColor];
                [cell addSubview:imageL];
                UIImageView *imageL2 = [[UIImageView alloc]initWithFrame:CGRectMake(15, labelOp.frame.origin.y+labelOp.frame.size.height+40, ScreenFrame.size.width-30, 0.5)];
                imageL2.backgroundColor = [UIColor lightGrayColor];
                [cell addSubview:imageL2];
                //销量啥的
                UILabel *labelSale = [[UILabel alloc]initWithFrame:CGRectMake(0, labelOp.frame.origin.y+labelOp.frame.size.height, ScreenFrame.size.width/3, 40)];
                labelSale.text = @"总销量10000";
                labelSale.font = [UIFont systemFontOfSize:13];
                labelSale.textColor = [UIColor darkGrayColor];
                labelSale.textAlignment = NSTextAlignmentCenter;
                [cell addSubview:labelSale];
                UILabel *labele = [[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width/3, labelOp.frame.origin.y+labelOp.frame.size.height, ScreenFrame.size.width/3, 40)];
                labele.text = @"累计评价10000";
                labele.font = [UIFont systemFontOfSize:13];
                labele.textColor = [UIColor darkGrayColor];
                labele.textAlignment = NSTextAlignmentCenter;
                [cell addSubview:labele];
                UILabel *labelI = [[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width/3*2, labelOp.frame.origin.y+labelOp.frame.size.height, ScreenFrame.size.width/3, 40)];
                labelI.text = @"送积分10000";
                labelI.font = [UIFont systemFontOfSize:13];
                labelI.textColor = [UIColor darkGrayColor];
                labelI.textAlignment = NSTextAlignmentCenter;
                [cell addSubview:labelI];
                
                //服务描述
                UIView *DesView = [[UIView alloc]initWithFrame:CGRectMake(0, labelI.frame.origin.y+labelI.frame.size.height, ScreenFrame.size.width, 60)];
                [cell addSubview:DesView];
                NSArray *arr = [[NSArray alloc]initWithObjects:@"服务支持",@"货到付款",@"正品保证",@"差价返还",@"15天质量问题换货",@"支持7天无理由退货", nil];
                for(int i=0;i<4;i++){
                    UILabel *labelServer = [[UILabel alloc]initWithFrame:CGRectMake(15+12+(ScreenFrame.size.width-20)/4*i, 5, 54, 24)];
                    labelServer.text = [arr objectAtIndex:i];
                    labelServer.font = [UIFont systemFontOfSize:13];
                    labelServer.textColor = [UIColor darkGrayColor];
                    labelServer.textAlignment = NSTextAlignmentCenter;
                    [DesView addSubview:labelServer];
                    UIImageView *imm = [[UIImageView alloc]initWithFrame:CGRectMake(15 + (ScreenFrame.size.width-20)/4*i, 11, 12, 12)];
                    imm.image  = [UIImage imageNamed:[NSString stringWithFormat:@"show_merchant_center_main_%d",i+1]];
                    [DesView addSubview:imm];
                }
                for(int i=0;i<2;i++){
                    UILabel *labelServer = [[UILabel alloc]initWithFrame:CGRectMake(15+12+(ScreenFrame.size.width-20)/2*i, 30, 120, 24)];
                    labelServer.text = [arr objectAtIndex:i+4];
                    labelServer.font = [UIFont systemFontOfSize:13];
                    labelServer.textColor = [UIColor darkGrayColor];
                    labelServer.textAlignment = NSTextAlignmentCenter;
                    [DesView addSubview:labelServer];
                    UIImageView *imm = [[UIImageView alloc]initWithFrame:CGRectMake(15 + (ScreenFrame.size.width-20)/2*i, 36, 12, 12)];
                    imm.image  = [UIImage imageNamed:[NSString stringWithFormat:@"show_merchant_center_main_%d",i+5]];
                    [DesView addSubview:imm];
                }
            }
            if (indexPath.row == 1) {
                if (classify.detail_status.length == 0) {
                    
                }else{
                    UIView *GrayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 10)];
                    GrayView.backgroundColor = BACKGROUNDCOLOR;
                    [cell addSubview:GrayView];
                    
                    UILabel *labelPrice2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 5+10, ScreenFrame.size.width, 25)];
                    labelPrice2.textColor = [UIColor darkGrayColor];
                    labelPrice2.font = [UIFont systemFontOfSize:15];
                    labelPrice2.text = @"活动:";
                    [cell addSubview:labelPrice2];
                    
                    UILabel *labelA = [[UILabel alloc]initWithFrame:CGRectMake(10, 30+10, 60, 18)];
                    labelA.textColor = [UIColor whiteColor];
                    labelA.backgroundColor = MY_COLOR;
                    labelA.font = [UIFont boldSystemFontOfSize:14];
                    labelA.text = [NSString stringWithFormat:@"%@",classify.detail_status];
                    labelA.textAlignment = NSTextAlignmentCenter;
                    [cell addSubview:labelA];
                    
                    UILabel *labelInfo = [[UILabel alloc]initWithFrame:CGRectMake(75, 30+10, ScreenFrame.size.width-80, 18)];
                    labelInfo.textColor = [UIColor redColor];
                    labelInfo.font = [UIFont systemFontOfSize:12];
                    if([labelA.text isEqualToString:@"促销"]){
                        //判断是否登录 登录了则提示
                        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                        NSString *documentsPath = [docPath objectAtIndex:0];
                        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
                        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
                        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
                            labelInfo.text = [NSString stringWithFormat:@"当前商品为促销商品，用户登录后方可享受促销价格！"];
                        }else{
                            labelInfo.text = [NSString stringWithFormat:@"您当前为%@,享受商城价格%0.2f折的优惠",userLeve,act_rate*10];
                        }
                        labelInfo.frame = CGRectMake(75, 24+10, ScreenFrame.size.width-80, 30);
                    }else{
                        labelInfo.text = classify.detail_goodsstatus_info;
                    }
                    labelInfo.numberOfLines = 0;
                    [cell addSubview:labelInfo];
                    
                    if ([classify.detail_status isEqualToString:@"组合"]) {
                        UIImageView *imageN = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-15, 30+10, 6, 10)];
                        imageN.image = [UIImage imageNamed:@"dis_indicator"];
                        [cell addSubview:imageN];
                        
                        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
                        btn2.frame = CGRectMake(0, 26+10, ScreenFrame.size.width, 32);
                        
                        btn2.tag = 102;
                        [btn2 addTarget:self action:@selector(btnStatus) forControlEvents:UIControlEventTouchUpInside];
                        [btn2.layer setMasksToBounds:YES];
                        [btn2.layer setCornerRadius:4.0];
                        [cell addSubview:btn2];
                    }
                }
            }
            if (indexPath.row == 2) {
                UIView *GrayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 10)];
                GrayView.backgroundColor = BACKGROUNDCOLOR;
                [cell addSubview:GrayView];
                
                UILabel *labelPrice2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0+10, ScreenFrame.size.width, 44)];
                labelPrice2.textColor = [UIColor darkGrayColor];
                labelPrice2.font = [UIFont systemFontOfSize:17];
                labelPrice2.text = @"规格";
                [cell addSubview:labelPrice2];
                
                morenSpec = [[UILabel alloc]initWithFrame:CGRectMake(53, 0+10, ScreenFrame.size.width-80, 44)];
                morenSpec.numberOfLines = 2;
                morenSpec.textColor = [UIColor blackColor];
                morenSpec.font = [UIFont boldSystemFontOfSize:14];
                
                if (specSelectArray.count!=0) {
                    NSString *str;
                    for(int i=0;i<specSelectArray.count;i++){
                        if (str.length == 0) {
                            str = [NSString stringWithFormat:@"%@:%@",[[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:0],[[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:1]];
                        }else{
                            str = [NSString stringWithFormat:@"%@  %@",str,[NSString stringWithFormat:@"%@:%@",[[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:0],[[[specSelectArray objectAtIndex:i] componentsSeparatedByString:@"~"] objectAtIndex:1]]];
                        }
                    }
                    morenSpec.text = [NSString stringWithFormat:@"%@    %@件",str,countField.text];
                }else{
                    morenSpec.text = [NSString stringWithFormat:@"%@件",countField.text];
                }
                [cell addSubview:morenSpec];
                
                UIImageView *imageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-15, 17+10, 6, 10)];
                imageVIew.image = [UIImage imageNamed:@"dis_indicator.png"];
                [cell addSubview:imageVIew];
            }
            if (indexPath.row == 3) {
                UIView *GrayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 10)];
                GrayView.backgroundColor = BACKGROUNDCOLOR;
                [cell addSubview:GrayView];
                if ([classify.detail_choice_type intValue] == 1) {
                    labelinventory = [[UILabel alloc]initWithFrame:CGRectMake(10, 5+10, ScreenFrame.size.width-20, 25)];
                    labelinventory.textColor = [UIColor lightGrayColor];
                    labelinventory.font = [UIFont boldSystemFontOfSize:13];
                    if ([classify.detail_goods_inventory intValue]>0) {
                        labelinventory.text = [NSString stringWithFormat:@"商品库存：  %@",classify.detail_goods_inventory ];
                    }else{
                        labelinventory.text = @"商品库存：  缺货";
                    }
                    labelinventory.textColor = [UIColor darkGrayColor];
                    [cell addSubview:labelinventory];
                }else{
                    UIImageView *imageDing = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-30, 8+10, 16, 16)];
                    imageDing.image = [UIImage imageNamed:@"ding"];
                    [cell addSubview:imageDing];
                    UILabel *peisong = [[UILabel alloc]initWithFrame:CGRectMake(10, 0+10, 64, 35)];
                    peisong.text = @"配  送  至:";
                    peisong.textColor = [UIColor darkGrayColor];
                    peisong.font = [UIFont boldSystemFontOfSize:13];
                    [cell addSubview:peisong];
                    UILabel *labelPrice2 = [[UILabel alloc]initWithFrame:CGRectMake(82, 0+10, ScreenFrame.size.width-100, 35)];
                    labelPrice2.numberOfLines = 2;
                    labelPrice2.textColor = [UIColor darkGrayColor];
                    labelPrice2.font = [UIFont boldSystemFontOfSize:13];
                    if (regionStr.length == 0) {
                        labelPrice2.text = [NSString stringWithFormat:@"%@",classify.detail_current_city];
                    }else{
                        labelPrice2.text = [NSString stringWithFormat:@"%@",regionStr];
                    }
                    [cell addSubview:labelPrice2];
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = CGRectMake(0, 0+10, ScreenFrame.size.width, 30);
                    btn.tag = indexPath.row;
                    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    
                    UILabel *labelPriceyyy = [[UILabel alloc]initWithFrame:CGRectMake(10, 30+10,300, 25)];
                    labelPriceyyy.textColor = [UIColor darkGrayColor];
                    labelPriceyyy.font = [UIFont boldSystemFontOfSize:13];
                    labelPriceyyy.text = @"物流运费:";
                    if (feetext.length ==0) {
                        labelPriceyyy.text = [NSString stringWithFormat:@"物流运费：  %@",classify.detail_trans_information];
                    }else{
                        labelPriceyyy.text = [NSString stringWithFormat:@"物流运费：  %@",feetext];
                    }
                    [cell addSubview:labelPriceyyy];
                    
                    labelinventory = [[UILabel alloc]initWithFrame:CGRectMake(10, 55+10, ScreenFrame.size.width-20, 25)];
                    labelinventory.textColor = [UIColor lightGrayColor];
                    labelinventory.font = [UIFont boldSystemFontOfSize:13];
                    if ([classify.detail_goods_inventory intValue]>0) {
                        labelinventory.text = [NSString stringWithFormat:@"商品库存：  %@",classify.detail_goods_inventory ];
                    }else{
                        labelinventory.text = @"商品库存：  缺货";
                    }
                    labelinventory.textColor = [UIColor darkGrayColor];
                    [cell addSubview:labelinventory];
                    
                    UILabel *afterType = [[UILabel alloc]initWithFrame:CGRectMake(10, 80+10, 300, 20)];
                    
                    afterType.textColor = [UIColor darkGrayColor];
                    afterType.font = [UIFont boldSystemFontOfSize:13];
                    [cell addSubview:afterType];
                    if (afterTag == 1) {
                        afterType.text = @"货到付款:    支持货到付款";
                    }else{
                        afterType.text = @"货到付款:    不支持货到付款";
                    }
                }
            }
            if (indexPath.row == 4) {
                UIView *GrayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 10)];
                GrayView.backgroundColor = BACKGROUNDCOLOR;
                [cell addSubview:GrayView];
                
                UILabel *labelPrice2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0+10, ScreenFrame.size.width, 44)];
                labelPrice2.textColor = [UIColor darkGrayColor];
                labelPrice2.font = [UIFont systemFontOfSize:17];
                labelPrice2.text = [NSString stringWithFormat:@"商品评价(%@)",classify.detail_evaluate_count];
                [cell addSubview:labelPrice2];
                
                UILabel *labelPrice = [[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-200, 0+10, 180, 44)];
                labelPrice.textColor = [UIColor darkGrayColor];
                labelPrice.font = [UIFont systemFontOfSize:17];
                labelPrice.text = [NSString stringWithFormat:@"%@好评率",classify.detail_goods_well_evaluate];
                labelPrice.textAlignment = NSTextAlignmentRight;
                [cell addSubview:labelPrice];
                
                UIImageView *imageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-15, 17+10, 6, 10)];
                imageVIew.image = [UIImage imageNamed:@"dis_indicator.png"];
                [cell addSubview:imageVIew];
            }
            if (indexPath.row == 5) {
                UIView *GrayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 10)];
                GrayView.backgroundColor = BACKGROUNDCOLOR;
                [cell addSubview:GrayView];
                
                UILabel *labelPrice2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0+10, ScreenFrame.size.width, 44)];
                labelPrice2.textColor = [UIColor darkGrayColor];
                labelPrice2.font = [UIFont systemFontOfSize:17];
                labelPrice2.text = @"商品咨询";
                [cell addSubview:labelPrice2];
                
                UIImageView *imageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-15, 17+10, 6, 10)];
                imageVIew.image = [UIImage imageNamed:@"dis_indicator.png"];
                [cell addSubview:imageVIew];
            }
            if (indexPath.row == 6) {
                
            }
            if (indexPath.row == 7) {
                if (maylikeArray.count!=0) {
                    UILabel *myLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 0.5)];
                    myLine.backgroundColor = [UIColor lightGrayColor];
                    [cell addSubview:myLine];
                    
                    UILabel *myLine2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 140, ScreenFrame.size.width, 0.5)];
                    myLine2.backgroundColor = [UIColor lightGrayColor];
                    [cell addSubview:myLine2];
                    
                    UILabel *labelPrice3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, 150, 25)];
                    labelPrice3.textColor = [UIColor darkGrayColor];
                    labelPrice3.font = [UIFont systemFontOfSize:16];
                    labelPrice3.text = @"猜你喜欢:";
                    [cell addSubview:labelPrice3];
                    
                    if (maylikeArray.count!=0) {
                        UIScrollView *ScrollView2 = [[UIScrollView alloc]initWithFrame:CGRectMake(6, 38, ScreenFrame.size.width-12, 140)];
                        ScrollView2.bounces = YES;
                        ScrollView2.delegate = self;
                        ScrollView2.userInteractionEnabled = YES;
                        ScrollView2.showsHorizontalScrollIndicator = NO;
                        ScrollView2.contentSize=CGSizeMake(76.25*maylikeArray.count+15,110);
                        [cell addSubview:ScrollView2];
                        
                        for (int i=0; i<maylikeArray.count; i++) {
                            ClassifyModel *cll = [maylikeArray objectAtIndex:i];
                            UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(15+i*76.25, 0, 61.25, 61.25)];
                            imageLine.userInteractionEnabled = YES;
                            imageLine.backgroundColor = [UIColor redColor];
                            [imageLine sd_setImageWithURL:[NSURL URLWithString:cll.detail_goods_main_photo] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
                            imageLine.backgroundColor = [UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1];
                            [ScrollView2 addSubview:imageLine];
                            
                            UILabel *labelPrice = [[UILabel alloc]initWithFrame:CGRectMake(10+i*76.25, 65, 72.25, 28)];
                            labelPrice.numberOfLines = 2;
                            labelPrice.textAlignment = NSTextAlignmentCenter;
                            labelPrice.font = [UIFont boldSystemFontOfSize:10];
                            labelPrice.text = cll.detail_goods_main_name;
                            labelPrice.textColor = [UIColor darkGrayColor];
                            [ScrollView2 addSubview:labelPrice];
                            
                            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            btn.frame = CGRectMake(15+i*76.25, 0, 61.25, 121.25);
                            btn.tag = i+1100;
                            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
                            [ScrollView2 addSubview:btn];
                            
                        }
                    }
                }
            }
            if (indexPath.row == 8) {
                cell.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 60)];
                label.text = @"👆继续拖动,查看图文详情";
                label.font = [UIFont systemFontOfSize:13];
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
    if (tableView == SpecTableView) {
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
        if (indexPath.row == 0) {
            if(dataArray.count!=0){
                ClassifyModel *classssss = [dataArray objectAtIndex:0];
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];//detail_goods_photos
                [imageView sd_setImageWithURL:[NSURL URLWithString:[arrImage objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
                [cell addSubview:imageView];
                UILabel *labelPrice = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 200, 20)];
                labelPrice.text = [NSString stringWithFormat:@"%@",classssss.detail_goods_current_price];
                labelPrice.textColor = [UIColor redColor];
                if (act_rate==0) {
                    
                }else{
                    //在这个位置是折后的价格
                    labelPrice.text = [NSString stringWithFormat:@"%0.2f",[classssss.detail_goods_current_price floatValue]*act_rate];
                }
                labelPrice.textColor = [UIColor redColor];
                labelPrice.font = [UIFont boldSystemFontOfSize:15];
                [cell addSubview:labelPrice];
                UILabel *labelNumKucun = [[UILabel alloc]initWithFrame:CGRectMake(60, 30, 200, 20)];
                labelNumKucun.text = [NSString stringWithFormat:@"库存:%@",classssss.detail_goods_inventory] ;
                labelNumKucun.textColor = [UIColor blackColor];
                labelNumKucun.font = [UIFont systemFontOfSize:13];
                [cell addSubview:labelNumKucun];
            }
            UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, 300, 0.5)];
            imageLine.backgroundColor = [UIColor lightGrayColor];
            [cell addSubview:imageLine];
        }else{
            //则正常显示了
            if(specificationsArray.count!=0){
                if (specSelectArray.count!=0) {
                    NSString *str = [specSelectArray objectAtIndex:indexPath.row-1];
                    NSArray *arr = [str componentsSeparatedByString:@"~"];
                    UILabel *labelKey =  [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 240, 20)];
                    labelKey.text = [arr objectAtIndex:0];
                    labelKey.textColor = [UIColor darkGrayColor];
                    labelKey.font = [UIFont systemFontOfSize:14];
                    [cell addSubview:labelKey];
                    
                    ClassifyModel *class = [specificationsArray objectAtIndex:indexPath.row - 1];
                    NSArray *specValues = (NSArray *)class.specifications_spec_values;
                    if (specValues.count%2==0) {//说明没有单
                        for(int i=0;i<specValues.count/2;i++){
                            for(int j=0;j<2;j++){
                                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
                                button.frame =CGRectMake(10+j*120, 25+35*i, 115, 28);
                                button.tag = indexPath.row*100 +i*2+j;
                                [button setTitle:[[specValues objectAtIndex:i*2+j] objectForKey:@"val"] forState:UIControlStateNormal];
                                if ([[[specValues objectAtIndex:i*2+j] objectForKey:@"id"] intValue] == [[arr objectAtIndex:2] intValue]) {
                                    button.backgroundColor = [UIColor redColor];
                                }else{
                                    button.backgroundColor = [UIColor grayColor];
                                }
                                CALayer *lay2  = button.layer;
                                [lay2 setMasksToBounds:YES];
                                [lay2 setCornerRadius:6.0];
                                [button addTarget:self action:@selector(specBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                                button.titleLabel.font  = [UIFont boldSystemFontOfSize:11];
                                [cell addSubview:button];
                            }
                        }
                    }else{
                        for(int i=0;i<specValues.count/2+1;i++){
                            for(int j=0;j<2;j++){
                                if (i==specValues.count/2+1&&j==1) {
                                    
                                }else if(i==specValues.count/2&&j==1){
                                    
                                }else{
                                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
                                    button.frame =CGRectMake(10+j*120, 25+35*i, 115, 28);
                                    button.tag = indexPath.row*100 +i*2+j;
                                    [button setTitle:[[specValues objectAtIndex:i*2+j] objectForKey:@"val"] forState:UIControlStateNormal];
                                    if ([[[specValues objectAtIndex:i*2+j] objectForKey:@"id"] intValue] == [[arr objectAtIndex:2] intValue]) {
                                        button.backgroundColor = [UIColor redColor];
                                    }else{
                                        button.backgroundColor = [UIColor grayColor];
                                    }
                                    CALayer *lay2  = button.layer;
                                    [lay2 setMasksToBounds:YES];
                                    [lay2 setCornerRadius:6.0];
                                    [button addTarget:self action:@selector(specBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                                    button.titleLabel.font  = [UIFont boldSystemFontOfSize:11];
                                    [cell addSubview:button];
                                }
                            }
                        }
                    }
                }
            }
        }
        return cell;
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
            NSArray *arr = (NSArray *)[[zuhePeijianArray objectAtIndex:indexPath.row] objectForKey:@"goods_list"];
            
            UIScrollView *ScrollView2 = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 10, zuheTableView.frame.size.width-20, 80)];
            ScrollView2.bounces = YES;
            ScrollView2.delegate = self;
            ScrollView2.userInteractionEnabled = YES;
            ScrollView2.showsHorizontalScrollIndicator = NO;
            ScrollView2.contentSize=CGSizeMake(arr.count*80+100,80);
            [cell addSubview:ScrollView2];
            
            UIView *labelLL = [[UIView alloc]initWithFrame:CGRectMake(0, 92, zuheTableView.frame.size.width, 0.5)];
            labelLL.backgroundColor = [UIColor grayColor];
            [cell addSubview:labelLL];
            
            for(int j=0;j<arr.count;j++){
                UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(20+j*60, 12, 40, 40)];
                [image sd_setImageWithURL:[NSURL URLWithString:[[[[zuhePeijianArray objectAtIndex:indexPath.row] objectForKey:@"goods_list"] objectAtIndex:j] objectForKey:@"goods_img"]] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
                [ScrollView2 addSubview:image];
                
                UILabel *labelN = [[UILabel alloc]initWithFrame:CGRectMake(10+j*60, 50, 60, 30)];
                labelN.text =[[[[zuhePeijianArray objectAtIndex:indexPath.row] objectForKey:@"goods_list"] objectAtIndex:j] objectForKey:@"goods_name"];
                labelN.font = [UIFont boldSystemFontOfSize:10];
                labelN.numberOfLines = 2;
                labelN.textAlignment = NSTextAlignmentCenter;
                [ScrollView2 addSubview:labelN];
                
                UILabel *labelNj = [[UILabel alloc]initWithFrame:CGRectMake(60+j*60, 10, 20, 40)];
                labelNj.text =@"+";
                labelNj.textAlignment = NSTextAlignmentCenter;
                labelNj.font = [UIFont boldSystemFontOfSize:15];
                [ScrollView2 addSubview:labelNj];
                
                UIButton *buttonG = [UIButton buttonWithType:UIButtonTypeCustom ];
                buttonG.frame =CGRectMake(20+j*60, 0, 60, 30);
                
                NSMutableArray *AAA = [peijianSelectArray objectAtIndex:indexPath.row];
                if ([[[[[zuhePeijianArray objectAtIndex:indexPath.row] objectForKey:@"goods_list"] objectAtIndex:j] objectForKey:@"goods_id"] intValue]  == [[AAA objectAtIndex:j] intValue]) {
                    [buttonG setTitle:@"    ✅" forState:UIControlStateNormal];
                }else{
                    [buttonG setTitle:@"    ☑️" forState:UIControlStateNormal];
                }
                [buttonG addTarget:self action:@selector(zuhePeijianIDBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                buttonG.tag = 100*indexPath.row +j;
                buttonG.titleLabel.textAlignment = NSTextAlignmentRight;
                buttonG.titleLabel.font = [UIFont boldSystemFontOfSize:16];
                [buttonG.layer setMasksToBounds:YES];
                [buttonG.layer setCornerRadius:4.0];
                [ScrollView2 addSubview:buttonG];
                
                if (j==arr.count-1) {
                    labelNj.text =@"=";
                    UILabel *labelMPy = [[UILabel alloc]initWithFrame:CGRectMake(60+j*60+20, 10, 120, 20)];
                    labelMPy.text =[NSString stringWithFormat:@"原价:￥%@",[[zuhePeijianArray objectAtIndex:indexPath.row] objectForKey:@"all_price"]];
                    labelMPy.font = [UIFont boldSystemFontOfSize:11];
                    [ScrollView2 addSubview:labelMPy];
                    
                    UILabel *labelMPPP = [[UILabel alloc]initWithFrame:CGRectMake(60+j*60+20, 30, 120, 20)];
                    labelMPPP.text =[NSString stringWithFormat:@"组合价:￥%@",[[zuhePeijianArray objectAtIndex:indexPath.row] objectForKey:@"plan_price"]];
                    labelMPPP.textColor = MY_COLOR;
                    labelMPPP.font = [UIFont boldSystemFontOfSize:14];
                    [ScrollView2 addSubview:labelMPPP];
                    
                    UIButton *buttonC = [UIButton buttonWithType:UIButtonTypeCustom ];
                    buttonC.frame =CGRectMake(60+j*60+19, 51, 66, 26);
                    [buttonC setTitle:@"购买配件" forState:UIControlStateNormal];
                    [buttonC addTarget:self action:@selector(zuhePeijiajBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
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
    UITableViewCell *cell;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == MyTableView) {
        SecondViewController *sec = [SecondViewController sharedUserDefault];
        ClassifyModel *classify = [dataArray objectAtIndex:0];
        if (indexPath.row == 0) {
        }
        if (indexPath.row == 1) {
            if (indexPath1Bool == NO) {
                indexPath1Bool = YES;
            }else{
                indexPath1Bool = NO;
            }
            [MyTableView reloadData];
        }
        if (indexPath.row == 2) {
            if (indexPath2Bool == NO) {
                loadingV.hidden = NO;
                //发起请求规格
                specSelectBool = YES;
                NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,SPECIFICATIONS_URL]];
                request_48=[ASIFormDataRequest requestWithURL:url3];
                [request_48 setPostValue:sec.detail_id forKey:@"id"];
                
                [request_48 setRequestHeaders:[LJControl requestHeaderDictionary]];
                request_48.tag = 102;
                request_48.delegate = self;
                [request_48 setDidFailSelector:@selector(spec_urlRequestFailed:)];
                [request_48 setDidFinishSelector:@selector(spec_urlRequestSucceeded:)];
                [request_48 startAsynchronous];
                
                indexPath2Bool = YES;
                imageViewDarkGray.hidden = NO;
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                CGRect frame = specView.frame;
                frame.origin.x -= 260;
                [specView setFrame:frame];
                [UIView commitAnimations];
            }else{
                indexPath2Bool = NO;
                imageViewDarkGray.hidden = YES;
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                CGRect frame = specView.frame;
                frame.origin.x += 260;
                [specView setFrame:frame];
                [UIView commitAnimations];
            }
        }
        if (indexPath.row == 3) {
        }
        if (indexPath.row == 4) {
            ConsultViewController *es = [[ConsultViewController alloc]init];
            [self.navigationController pushViewController:es animated:YES];
        }
        if (indexPath.row == 5) {
            EstimateViewController *EE = [[EstimateViewController alloc]init];
            [self.navigationController pushViewController:EE animated:YES];
        }
        if (indexPath.row == 6) {
            ThirdViewController *th = [ThirdViewController sharedUserDefault];
            th.store_id = [classify.detail_store_info objectForKey:@"store_id"];
            StoreHomeViewController2 *storeVC = [[StoreHomeViewController2 alloc]init];
            [self.navigationController pushViewController:storeVC animated:YES];
        }
        if (indexPath.row == 7) {
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
-(void)failedPrompt:(NSString *)prompt{
    loadingV.hidden = YES;
    labelTi.hidden = NO;
    labelTi.text = prompt;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
}
#pragma mark - 网络
-(void)on_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
    loadingV.hidden = YES;
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
        ClassifyModel *classify = [[ClassifyModel alloc]init];
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
        }else{
            favouiteBool = YES;
            labeHeart2.image = [UIImage imageNamed:@"qx_new"];
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
                button2add.backgroundColor = [UIColor lightGrayColor];
                button2add.enabled = NO;
                btn2Qing.enabled = NO;
                btn2Qing.backgroundColor = [UIColor lightGrayColor];
                btn22Qing.enabled = NO;
                btn22Qing.backgroundColor = [UIColor lightGrayColor];
            }else{
                btnAddCar.backgroundColor = [UIColor orangeColor];
                btnAddCar.enabled = YES;
                button2add.backgroundColor = [UIColor orangeColor];
                button2add.enabled = YES;
                btn2Qing.enabled = YES;
                btn2Qing.backgroundColor = MY_COLOR;
                btn22Qing.enabled = YES;
                btn22Qing.backgroundColor = MY_COLOR;
            }
        }else{
            if ([[dicBig objectForKey:@"goods_inventory"] intValue]<=0) {
                btnAddCar.backgroundColor = [UIColor lightGrayColor];
                btnAddCar.enabled = NO;
                btn2Qing.backgroundColor = [UIColor lightGrayColor];
                btn2Qing.enabled = NO;
                btn22Qing.backgroundColor = [UIColor lightGrayColor];
                btn22Qing.enabled = NO;
                button2add.backgroundColor = [UIColor lightGrayColor];
                button2add.enabled = NO;
            }else{
                btnAddCar.backgroundColor = [UIColor orangeColor];
                btnAddCar.enabled = YES;
                btn2Qing.backgroundColor = MY_COLOR;
                btn2Qing.enabled = YES;
                btn22Qing.backgroundColor = MY_COLOR;
                btn22Qing.enabled = YES;
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
    [self failedPrompt:@"网络请求失败"];
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
        ClassifyModel *classify = [[ClassifyModel alloc]init];
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
        }else{
            favouiteBool = YES;
            labeHeart2.image = [UIImage imageNamed:@"qx_new"];
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
                btn2Qing.enabled = NO;
                btn2Qing.backgroundColor = [UIColor lightGrayColor];
                btn22Qing.enabled = NO;
                btn22Qing.backgroundColor = [UIColor lightGrayColor];
                button2add.enabled = NO;
                button2add.backgroundColor = [UIColor lightGrayColor];
            }else{
                btnAddCar.backgroundColor = [UIColor orangeColor];
                btnAddCar.enabled = YES;
                
                btn2Qing.backgroundColor = MY_COLOR;
                btn2Qing.enabled = YES;
                btn22Qing.backgroundColor = MY_COLOR;
                btn22Qing.enabled = YES;
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
        ClassifyModel *classify = [[ClassifyModel alloc]init];
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
        }else{
            favouiteBool = YES;
            labeHeart2.image = [UIImage imageNamed:@"qx_new"];
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
    [self failedPrompt:@"网络请求失败"];
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
        loadingV.hidden = YES;
    }
    else{
        [self failedPrompt:@"请求出错"];
    }
    
}
-(void)zuhepeijian_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
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
        loadingV.hidden = YES;
    }
    else{
        [self failedPrompt:@"请求出错"];
    }
}
-(void)init_urlRequestFailed:(ASIFormDataRequest *)request{
    MyTableView.hidden = YES;
    bottomView.hidden = YES;
    [self failedPrompt:@"网络请求失败"];
}
-(void)Userlevel_urlRequestFailed:(ASIHTTPRequest *)request{
    [self failedPrompt:@"网络请求失败"];
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
    [self failedPrompt:@"网络请求失败"];
}
-(void)spec_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"10-dicBig:%@",dicBig);
        if (specificationsArray.count!=0) {
            [specificationsArray removeAllObjects];
        }
        if (specSelectArray.count!=0) {
            [specSelectArray removeAllObjects];
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
        }
    }
    [SpecTableView reloadData];
    [MyTableView reloadData];
    loadingV.hidden = YES;
    
}
-(void)detailOn_urlRequestFailed:(ASIHTTPRequest *)request{
    MyTableView.hidden = YES;
    bottomView.hidden = YES;
    [self failedPrompt:@"网络请求失败"];
}
-(void)detailOn_urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"11-dicBig:%@",dicBig);
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        ClassifyModel *classify = [[ClassifyModel alloc]init];
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
        }else{
            favouiteBool = YES;
            labeHeart2.image = [UIImage imageNamed:@"qx_new"];
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
    [self failedPrompt:@"网络请求失败"];
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
        loadingV.hidden = YES;
    }
    
}
-(void)userlevel2_urlRequestFailed:(ASIHTTPRequest *)request{
    [self failedPrompt:@"网络请求失败"];
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
    [self failedPrompt:@"网络请求失败"];
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
            loadingV.hidden = YES;
            RegoinTableView.userInteractionEnabled = YES;
            NSArray *arr = [dicBig objectForKey:@"area_list"];
            if (arr.count==0) {
                //消失
                regionView.hidden = YES;
               
                
                //发起请求运费
                NSArray *arr = [regionStr componentsSeparatedByString:@">"];
                SecondViewController *sec = [SecondViewController sharedUserDefault];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,TRANS_FEE_URL]];
                request_14=[ASIFormDataRequest requestWithURL:url];
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
        [self failedPrompt:@"请求出错"];
    }
}
-(void)my213_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)attentiondel_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)attentiondel_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"5-dicBig:%@",dicBig);
        if ([[dicBig objectForKey:@"code"] intValue]==100) {
            favouiteBool = NO;
            labeHeart2.image = [UIImage imageNamed:@"sc_new"];
            [self failedPrompt:@"操作成功"];
            favouiteBool = NO;
        }else if ([[dicBig objectForKey:@"code"] intValue]==-500){
            //-500请求错误
            labeHeart2.image = [UIImage imageNamed:@"qx_new"];
            favouiteBool = YES;
            [self failedPrompt:@"请求出错"];
        }else if ([[dicBig objectForKey:@"code"] intValue]==-400){
            //--400用户信息错误
            labeHeart2.image = [UIImage imageNamed:@"qx_new"];
            favouiteBool = YES;
            [self failedPrompt:@"用户信息错误"];
        }
        else if ([[dicBig objectForKey:@"code"] intValue]==300){
            //300删除成功
            labeHeart2.image = [UIImage imageNamed:@"sc_new"];
            [self failedPrompt:@"取消收藏"];
            favouiteBool = NO;
        }
        loadingV.hidden = YES;
    }
    else{
        loadingV.hidden = YES;
    }
}
-(void)spec2_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
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
        
        [request_24 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request_24.tag = 114;
        request_24.delegate =self;
        [request_24 setDidFailSelector:@selector(spec3_urlRequestFailed:)];
        [request_24 setDidFinishSelector:@selector(spec3_urlRequestSucceeded:)];
        [request_24 startAsynchronous];
    }
    [MyTableView reloadData];
    loadingV.hidden = YES;
}
-(void)spec3_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)spec3_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"14-dicBig:%@",dicBig);
        if (dataArray.count!= 0) {
            ClassifyModel *class = [dataArray objectAtIndex:0];
            class.detail_goods_inventory = [dicBig objectForKey:@"count"];
            class.detail_goods_current_price = [dicBig objectForKey:@"price"];
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
            [MyTableView reloadData];
        }
        loadingV.hidden = YES;
    }
    
}
-(void)addCaroff_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    btnAddCar.enabled = YES;
    button2add.enabled = YES;
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"15-dicBig:%@",dicBig);
        if (dicBig) {
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
            NSFileManager *fileManagerDong = [NSFileManager defaultManager];
            if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
                NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                NSString *filePaht = [documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
                NSArray *array = [NSArray arrayWithObjects:[dicBig objectForKey:@"cart_mobile_id"], nil];
                [array writeToFile:filePaht atomically:NO];
            }else{
                //遍历文件内容 进行跟新
                NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
                NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                NSString *str = [fileContent2 objectAtIndex:0];
                str = [NSString stringWithFormat:@"%@,%@",str,[dicBig objectForKey:@"cart_mobile_id"]];
                NSArray *array = [NSArray arrayWithObjects:str, nil];
                [array writeToFile:readPath2 atomically:NO];
            }
            if ([[dicBig objectForKey:@"code"] intValue] ==100) {
                [self failedPrompt:@"已成功加入购物车"];
                
                NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *documentsPath = [docPath objectAtIndex:0];
                NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
                NSFileManager *fileManagerDong = [NSFileManager defaultManager];
                if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
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
            }
        }
    }
    [MyTableView reloadData];
}
-(void)carCountoff_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
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
        
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)countShu];
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
        
        loadingV.hidden = YES;
    }
    else{
        loadingV.hidden = YES;
    }
    
}
-(void)carCounton_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)carCounton_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"16-dicBig:%@",dicBig);
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"count"]];
        
    }
    loadingV.hidden= YES;
    
}
-(void)addCaroff_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)addCaron_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    btnAddCar.enabled = YES;
    button2add.enabled = YES;
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"17-dicBig:%@",dicBig);
        if (dicBig) {
            if ([[dicBig objectForKey:@"code"] intValue] ==100) {
                [self failedPrompt:@"已成功添加到购物车"];
                
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
            }else if ([[dicBig objectForKey:@"code"] intValue] ==-100){
                [self failedPrompt:@"加入购物车失败，用户信息错误，请重新登录"];
            }
        }
    }
    [MyTableView reloadData];
    
}
-(void)goodsCount_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)goodsCount_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if(statuscode2 == 200){
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"18-dicBig:%@",dicBig);
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"count"]];
        
    }
}
-(void)addCaron_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)Fcodeon_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
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
                [self failedPrompt:@"已成功添加到购物车"];
                //发起购物车数量的请求
                
                
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
                [self failedPrompt:@"F码不正确"];
            }
        }
    }
    [MyTableView reloadData];
    
}
-(void)Fcodeoff_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
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
                NSArray *array = [NSArray arrayWithObjects:[dicBig objectForKey:@"cart_mobile_id"], nil];
                [array writeToFile:filePaht atomically:NO];
            }else{
                //遍历文件内容 进行跟新
                NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"cart_mobile_id.txt"];
                NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                NSString *str = [fileContent2 objectAtIndex:0];
                str = [NSString stringWithFormat:@"%@,%@",str,[dicBig objectForKey:@"cart_mobile_id"]];
                NSArray *array = [NSArray arrayWithObjects:str, nil];
                [array writeToFile:readPath2 atomically:NO];
            }
            if ([[dicBig objectForKey:@"ret"] intValue] ==1) {
                [self failedPrompt:@"已成功加入购物车"];
                //
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
                [self failedPrompt:@"F码不正确"];
            }
        }
    }
    [MyTableView reloadData];
    
}
-(void)esaypay_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    btn2Qing.enabled = YES;
    btn22Qing.enabled = YES;
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"1_dicBig:%@",dicBig);
        loadingV.hidden = YES;
        if (dicBig) {
            ThirdViewController *third = [ThirdViewController sharedUserDefault];
            third.jie_cart_ids = [dicBig objectForKey:@"cart_ids"];
            third.jie_order_goods_price = [dicBig objectForKey:@"order_goods_price"];
            third.jie_store_ids = [dicBig objectForKey:@"store_ids"];
            writeViewController *www = [[writeViewController alloc]init];
            [self.navigationController pushViewController:www animated:YES];
        }
    }
}
-(void)esaypay_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)attentionadd_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        loadingV.hidden = YES;
        NSLog(@"2-dicBig:%@",dicBig);
        if ([[dicBig objectForKey:@"code"]intValue] == 100) {
            labeHeart2.image = [UIImage imageNamed:@"qx_new"];
            [self failedPrompt:@"已成功收藏"];
            favouiteBool = YES;
        }else if ([[dicBig objectForKey:@"code"]intValue] == -500) {
            [self failedPrompt:@"收藏失败"];
        }else if ([[dicBig objectForKey:@"code"]intValue] == -400) {
            [self failedPrompt:@"收藏失败，用户信息不正确"];
        }else if ([[dicBig objectForKey:@"code"]intValue] == -300) {
            [self failedPrompt:@"您已经收藏过该商品"];
        }else{
            [self failedPrompt:@"已成功收藏"];
            labeHeart2.image = [UIImage imageNamed:@"qx_new"];
            favouiteBool = YES;
        }
        
    }
    [MyTableView reloadData];
}
-(void)attentionadd_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)region1_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
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
               
                //发起请求运费
                NSArray *arr = [regionStr componentsSeparatedByString:@">"];
                SecondViewController *sec = [SecondViewController sharedUserDefault];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,TRANS_FEE_URL]];
                request_47=[ASIFormDataRequest requestWithURL:url];
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
    loadingV.hidden = YES;
}
-(void)transfee_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
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
#pragma mark - 点击事件
-(void)singleTap{
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
    if (ScreenFrame.size.height<=480) {
        [pageControl setCenter: CGPointMake(self.view.center.x, self.view.bounds.size.height-480+60)] ;
    }else if (ScreenFrame.size.height>480&&ScreenFrame.size.height<=568){
        [pageControl setCenter: CGPointMake(self.view.center.x, self.view.bounds.size.height-480)] ;
    }else{
        [pageControl setCenter: CGPointMake(self.view.center.x, self.view.bounds.size.height-480)] ;
    }
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
    }
    if (btn.tag == 104) {
        if (dataArray.count!=0) {
            ClassifyModel *class = [dataArray objectAtIndex:0];
            if ([class.detail_goods_inventory intValue]<1) {
                
            }else{
                if ([countField.text intValue] == [class.detail_goods_inventory intValue]) {
                    countField.text = [NSString stringWithFormat:@"%@",class.detail_goods_inventory];
                }else{
                    countField.text = [NSString stringWithFormat:@"%d",[countField.text intValue]+1];
                }
            }
        }
    }
    if (btn.tag == 105) {
    }
    if (btn.tag == 106) {
        loadingV.hidden = NO;
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
                    [request_26 setPostValue:sec.detail_id forKey:@"goods_id"];
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
                    
                    [request_26 setRequestHeaders:[LJControl requestHeaderDictionary]];
                    request_26.tag = 110;
                    request_26.delegate =self;
                    [request_26 setDidFailSelector:@selector(addCaron_urlRequestFailed:)];
                    [request_26 setDidFinishSelector:@selector(addCaron_urlRequestSucceeded:)];
                    [request_26 startAsynchronous];
                }
            }else{
                [self failedPrompt:@"库存不足，无法加入购物车"];
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
    frame.origin.x += 260;
    [specView setFrame:frame];
    [UIView commitAnimations];
}

-(void)regionCancel{
}
-(void)next:(UIButton *)btn{
    buttonNext.enabled = NO;
    buttonNext.backgroundColor = [UIColor grayColor];
    loadingV.hidden = NO;
    ClassifyModel *cla = [regionArray objectAtIndex:selectRegionIndex];
    if (regionStr.length == 0) {
        regionStr = [NSString stringWithFormat:@"%@",cla.region_name];
    }else{
        regionStr = [NSString stringWithFormat:@"%@>%@",regionStr,cla.region_name];
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

-(void)MyTableViewGestureRight{
    [self.navigationController popViewControllerAnimated:YES];
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
    [UIView setAnimationDuration:1];
    CGRect frame = specView.frame;
    frame.origin.x -= 260;
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

-(void)dismissKeyBoard1{
   
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
-(void)createBottomView{
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenFrame.size.height-44, ScreenFrame.size.width, 44)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIImageView *imgeL = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 0.5)];
    imgeL.backgroundColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
    [bottomView addSubview:imgeL];
    
    btnAddCar = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAddCar.frame = CGRectMake(60, 0.5, (ScreenFrame.size.width-60)/2, 43.5);
    btnAddCar.tag = 101;
    btnAddCar.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [btnAddCar setTitle:@"加入购物车" forState:UIControlStateNormal];
    btnAddCar.backgroundColor = [UIColor orangeColor];
    btnAddCar.titleLabel.textColor = [UIColor whiteColor];
    [btnAddCar addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btnAddCar];
    
    labeHeart2 = [[UIImageView alloc]initWithFrame:CGRectMake(18, 6, 24, 34)];
    labeHeart2.image = [UIImage imageNamed:@"sc_new"];
    [bottomView addSubview:labeHeart2];
    
    btnSC = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSC.frame = CGRectMake(0, 0, 60, 44);
    btnSC.alpha = 1;
    [btnSC setTitle:@"" forState:UIControlStateNormal];
    btnSC.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnSC addTarget:self action:@selector(favourite) forControlEvents:UIControlEventTouchUpInside];
    btnSC.layer.cornerRadius = 4;
    btnSC.layer.masksToBounds  = YES;
    [bottomView addSubview:btnSC];
    
    btn22Qing = [UIButton buttonWithType:UIButtonTypeCustom];
    btn22Qing.frame = CGRectMake(ScreenFrame.size.width-(ScreenFrame.size.width-60)/2, 0.5, (ScreenFrame.size.width-60)/2, 43.5);
    btn22Qing.tag = 102;
    btn22Qing.backgroundColor = MY_COLOR;
    btn22Qing.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [btn22Qing setTitle:@"立即购买" forState:UIControlStateNormal];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
    if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
        //在这里应该跳转进入登录也
        
    }else{
        
    }
    btn22Qing.titleLabel.textColor = [UIColor whiteColor];
    [btn22Qing addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btn22Qing];
    
    FCode_bottomView = [[UIView alloc]initWithFrame:CGRectMake(60, ScreenFrame.size.height-43.5, ScreenFrame.size.width-60, 44)];
    FCode_bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:FCode_bottomView];
    Fbtn2Qing = [UIButton buttonWithType:UIButtonTypeCustom];
    Fbtn2Qing.frame = CGRectMake(0, 0, FCode_bottomView.frame.size.width, 44);
    Fbtn2Qing.tag = 102;
    Fbtn2Qing.backgroundColor = MY_COLOR;
    Fbtn2Qing.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [Fbtn2Qing addTarget:self action:@selector(FCodebtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [Fbtn2Qing setTitle:@"立即购买" forState:UIControlStateNormal];
    [FCode_bottomView addSubview:Fbtn2Qing];
    FCode_bottomView.hidden = YES;
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
            
            UIView *whiteV = [[UIView alloc]initWithFrame:CGRectMake(20, 60, ScreenFrame.size.width-40, 100)];
            whiteV.backgroundColor = [UIColor whiteColor];
            [whiteV.layer setMasksToBounds:YES];
            [whiteV.layer setCornerRadius:8.0];
            [FCodeView addSubview:whiteV];
            UILabel *labelT = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, whiteV.frame.size.width, 40)];
            labelT.backgroundColor = MY_COLOR;
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
            btn.frame = CGRectMake(40, whiteV.frame.size.height+whiteV.frame.origin.y+10, 60, 26);
            btn.tag = 101;
            btn.backgroundColor = MY_COLOR;
            [btn setTitle:@"确定" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnFcodeClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn.layer setMasksToBounds:YES];
            [btn.layer setCornerRadius:4.0];
            [FCodeView addSubview:btn];
            
            UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn2.frame = CGRectMake(whiteV.frame.size.width-60, whiteV.frame.size.height+whiteV.frame.origin.y+10, 60, 26);
            btn2.tag = 102;
            [btn2 setTitle:@"取消" forState:UIControlStateNormal];
            [btn2 addTarget:self action:@selector(btnFcodeClicked:) forControlEvents:UIControlEventTouchUpInside];
            btn2.backgroundColor = [UIColor darkGrayColor];
            [btn2.layer setMasksToBounds:YES];
            [btn2.layer setCornerRadius:4.0];
            [FCodeView addSubview:btn2];
        }
    }
    if (btn.tag == 103) {
        
    }
}
-(void)btnFcodeClicked:(UIButton *)btn{
    if (btn.tag == 101) {
        if (phoneNumFieldFF.text.length == 0) {
            [self failedPrompt:@"F码不能为空"];
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
    FirstViewController  *fir = [FirstViewController sharedUserDefault];
    fir.loginBool = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
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
        zuheTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 60, ScreenFrame.size.width-20, 280) style:UITableViewStylePlain];
    }else{
        zuheTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 60, ScreenFrame.size.width-20, 280) style:UITableViewStylePlain];
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
        zuhepeijianTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 60, ScreenFrame.size.width-20, 280) style:UITableViewStylePlain];
    }else{
        zuhepeijianTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 60, ScreenFrame.size.width-20, 280) style:UITableViewStylePlain];
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
    NSString *str = [specSelectArray objectAtIndex:btn.tag/100-1];
    NSArray *arr = [str componentsSeparatedByString:@"~"];
    NSString *newStr = [NSString stringWithFormat:@"%@~",[arr objectAtIndex:0    ]];
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
            storegoodsDetailViewController *detauk = [[storegoodsDetailViewController alloc]init];
            [self.navigationController pushViewController:detauk animated:YES];
        }
    }
    
    if(btn.tag == 3){
        loadingV.hidden = NO;
        regionStr = @"";
        
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
        labelPleaseSelect.font = [UIFont systemFontOfSize:17];
        labelPleaseSelect.textAlignment = NSTextAlignmentCenter;
        labelPleaseSelect.backgroundColor = [UIColor whiteColor];
        CALayer *layPS = labelPleaseSelect.layer;
        [layPS setMasksToBounds:YES];
        [layPS setCornerRadius:5.0f];
        [regionView addSubview:labelPleaseSelect];
        UIButton *buttonC = [UIButton buttonWithType:UIButtonTypeCustom ];
        buttonC.frame =CGRectMake(215, 5, 30, 30);
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
        loadingV.hidden = NO;
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
                    
                    [request_45 setRequestHeaders:[LJControl requestHeaderDictionary]];
                    request_45.tag = 110;
                    request_45.delegate =self;
                    [request_45 setDidFailSelector:@selector(addCaron_urlRequestFailed:)];
                    [request_45 setDidFinishSelector:@selector(addCaron_urlRequestSucceeded:)];
                    [request_45 startAsynchronous];
                }
            }else{
                [self failedPrompt:@"库存不足"];
            }
        }
    }
    if (btn.tag == 102) {
        //若没有登录应该跳转到登录页面 若已登录则判断库存够不够
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
            labelTi.hidden = NO;
            labelTi.text = @"登录后才可立即购买,请登录!";
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimerLogin) userInfo:nil repeats:NO];
        }else{
            loadingV.hidden = NO;
            btn.enabled = NO;
            if (dataArray.count!=0) {
                ClassifyModel *classifyKu = [dataArray objectAtIndex:0];
                if ([classifyKu.detail_goods_inventory integerValue]>0){
                    //发起轻松购请求
                    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                    NSString *documentsPath = [docPath objectAtIndex:0];
                    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ESAYPAY_URL]];
                    request_46=[ASIFormDataRequest requestWithURL:url];
                    [request_46 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
                    [request_46 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
                    [request_46 setPostValue:sec.detail_id forKey:@"goods_id"];
                    [request_46 setPostValue:countField.text forKey:@"count"];
                    
                    if (act_rate==0) {
                        [request_46 setPostValue:[NSString stringWithFormat:@"%@",classifyKu.detail_goods_current_price] forKey:@"price"];
                    }else{
                        [request_46 setPostValue:[NSString stringWithFormat:@"%0.2f",[classifyKu.detail_goods_current_price floatValue]*act_rate] forKey:@"price"];
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
                    
                    [request_46 setRequestHeaders:[LJControl requestHeaderDictionary]];
                    request_46.tag = 112;
                    request_46.delegate =self;
                    [request_46 setDidFailSelector:@selector(esaypay_urlRequestFailed:)];
                    [request_46 setDidFinishSelector:@selector(esaypay_urlRequestSucceeded:)];
                    [request_46 startAsynchronous];
                }else{
                    [self failedPrompt:@"库存不足"];
                }
            }
        }
    }
}


-(void)doTimer
{
    loadingV.hidden = YES;
    labelTi.hidden = YES;
}

-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
    
    UIButton *buttonChat = [UIButton buttonWithType:UIButtonTypeCustom ];
    buttonChat.frame =CGRectMake(0, 0, 24, 24);
    [buttonChat setBackgroundImage:[UIImage imageNamed:@"point"] forState:UIControlStateNormal];
    [buttonChat addTarget:self action:@selector(More) forControlEvents:UIControlEventTouchUpInside];
    UIButton *buttonMore = [UIButton buttonWithType:UIButtonTypeCustom ];
    buttonMore.frame =CGRectMake(0, 0, 25, 21);
    [buttonMore setBackgroundImage:[UIImage imageNamed:@"kefu_lj"] forState:UIControlStateNormal];
    [buttonMore addTarget:self action:@selector(chat) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *bar2 = [[UIBarButtonItem alloc]initWithCustomView:buttonChat];
    UIBarButtonItem *bar3 = [[UIBarButtonItem alloc]initWithCustomView:buttonMore];
    NSArray *arr = [[NSArray alloc]initWithObjects:bar2,bar3, nil];
    self.navigationItem.rightBarButtonItems =arr;
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
            sec.detail_id = class.detail_id;
            ChatViewController *chat = [[ChatViewController alloc]init];
            [self.navigationController pushViewController:chat animated:YES];
        }
    }
}
-(void)favourite{
    if (favouiteBool == NO) {
        loadingV.hidden = NO;
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
-(void)More{
    if (muchBool == NO) {
        muchView.hidden = NO;
        muchBool = YES;
    }else{
        muchView.hidden = YES;
        muchBool = NO;
    }
}
-(void)backBtnClicked{
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
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - teztfield delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string.length == 0) {
        //说明是删除的操作
    }else{
        //说明是在添加的操作
        if (dataArray.count!=0) {
            ClassifyModel *class = [dataArray objectAtIndex:0];
            CountExchange = [NSString stringWithFormat:@"%@%@",textField.text,string];
            if([CountExchange intValue]>[class.detail_goods_inventory intValue]){
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
    CGFloat keyboardHeight = 226.0f;
    if (self.view.frame.size.height - keyboardHeight <= textField.frame.origin.y + textField.frame.size.height) {
        CGFloat y = textField.frame.origin.y - (self.view.frame.size.height - keyboardHeight - textField.frame.size.height -125);
        [UIView beginAnimations:@"srcollView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.275f];
        self.view.frame = CGRectMake(self.view.frame.origin.x, -y, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}
- (BOOL)isMobileField:(NSString *)phoneNumber
{
    if (countField.text.length == 0) {
        return YES;
    }
    NSString *phoneRegex = @"^[0-9]*$";//判断是不是数字的正则表达式
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",phoneRegex];
    
    BOOL isMatch = [phoneTest evaluateWithObject:phoneNumber];
    if (!isMatch) {
        [self failedPrompt:@"请输入数字"];
        return NO;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == countField) {
        //在这里应该判断输入的内容是不是数字
        if ([self isMobileField:countField.text] == NO) {
            countField.text = @"1";
            [MyTableView reloadData];
            [textField resignFirstResponder];
            CGFloat keyboardHeight = 226.0f;
            if (self.view.frame.size.height - keyboardHeight <= textField.frame.origin.y + textField.frame.size.height) {
                [UIView beginAnimations:@"srcollView" context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:0.275f];
                self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
                [UIView commitAnimations];
            }
        }else{
            [MyTableView reloadData];
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
    loadingV.hidden = YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:myWebView.scrollView];
    //若不存在网络 则需要影藏webview 并提示用户点击屏幕进行刷新
    loadingV.hidden = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
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
    [super viewWillAppear:YES];
}

#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == myWebView.scrollView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
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
        
        float reload_distance = 10;
        if (y > (h + reload_distance)) {
            // 滚动到底部
            if (scrollBool == NO) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                CGRect frame = MyTableView.frame;
                frame.origin.y -= MyTableView.frame.size.height;
                [MyTableView setFrame:frame];
                
                CGRect frame2 = myWebView.frame;
                frame2.origin.y -= myWebView.frame.size.height;
                [myWebView setFrame:frame2];
                
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
    [UIView setAnimationDuration:1];
    if (MyTableView.frame.origin.y == 64) {
        
    }else{
        CGRect frame = MyTableView.frame;
        frame.origin.y += MyTableView.frame.size.height;
        [MyTableView setFrame:frame];
        
        CGRect frame2 = myWebView.frame;
        frame2.origin.y += myWebView.frame.size.height;
        [myWebView setFrame:frame2];
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
