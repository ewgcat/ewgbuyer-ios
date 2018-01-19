//
//  LifeGroupHomeViewController.m
//  My_App
//
//  Created by apple on 15-1-6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LifeGroupHomeViewController.h"
#import "GoodsGroupDetailViewController.h"
#import "DetailViewController.h"
#import "IntegralCell.h"
#import "ASIFormDataRequest.h"
#import "Model.h"
#import "MJRefresh.h"



@interface LifeGroupHomeViewController ()

@end

static LifeGroupHomeViewController *singleInstance = nil;

@implementation LifeGroupHomeViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:255/255.0f];
    
    ClassifySelectTag_goods = 1;
    PriceSelectTag_goods = 0;
    _type = @"goods";
    
    UIImageView *imageZanwu = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenFrame.size.width-100)/2, 170, 100, 100)];
    imageZanwu.image= [UIImage imageNamed:@"seller_center_nothing"];
    [self.view addSubview:imageZanwu];
    UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(0, 300, ScreenFrame.size.width, 30)];
    la.text=@"抱歉,暂无团购商品";
    la.backgroundColor=[UIColor clearColor];
    la.textAlignment=NSTextAlignmentCenter;
    la.textColor=[UIColor darkGrayColor];
    la.font=[UIFont systemFontOfSize:17];
    [self.view addSubview:la];
    if (ScreenFrame.size.height<=480) {
        imageZanwu.frame =CGRectMake((ScreenFrame.size.width-100)/2, 150, 100, 100);
        la.frame = CGRectMake(0, 300, ScreenFrame.size.width, 22);
    }else if (ScreenFrame.size.height>480&&ScreenFrame.size.height<=568){
        imageZanwu.frame =CGRectMake((ScreenFrame.size.width-100)/2, 170, 100, 100);
        la.frame = CGRectMake(0, 320, ScreenFrame.size.width, 22);
    }else if (ScreenFrame.size.height>568&&ScreenFrame.size.height<=1334/2){
        imageZanwu.frame =CGRectMake((ScreenFrame.size.width-100)/2, 220, 100, 100);
        la.frame = CGRectMake(0, 370, ScreenFrame.size.width, 22);
    }else{
        imageZanwu.frame =CGRectMake((ScreenFrame.size.width-100)/2, 240, 100, 100);
        la.frame = CGRectMake(0, 380, ScreenFrame.size.width, 22);
    }
    dataArr_life= [[NSMutableArray alloc]init];
    dataArr = [[NSMutableArray alloc]init];
    dataArr2 = [[NSMutableArray alloc]init];
    dataArr3 = [[NSMutableArray alloc]init];
    dataArrShangla = [[NSMutableArray alloc]init];
    dataArrShangla2 = [[NSMutableArray alloc]init];
    dataArr5 = [[NSMutableArray alloc]init];
    dataArr_life_P = [[NSMutableArray alloc]init];
    NSArray *array=@[@"商品惠",@"生活惠"];
    MsegmentControl=[[UISegmentedControl alloc]initWithItems:array];
    MsegmentControl.frame=CGRectMake(5, 67, ScreenFrame.size.width - 10, 24);
    MsegmentControl.selectedSegmentIndex=0;
    MsegmentControl.tintColor = MY_COLOR;
    [MsegmentControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:MsegmentControl];
    
    [self createCollectionView];
    [self createViewType];
    [self createTopView];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        MsegmentControl.selectedSegmentIndex=0;
        lifeCollectionView.hidden = YES;
        LifeGroupHomeViewController *lgh = [LifeGroupHomeViewController sharedUserDefault];
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL, GROUPHOME_URL]];
        request_1 = [ASIFormDataRequest requestWithURL:url];
        [request_1 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
        [request_1 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
        [request_1 setPostValue:lgh.gg_id forKey:@"id"];
        [request_1 setPostValue:@"0" forKey:@"begincount"];
        [request_1 setPostValue:@"10" forKey:@"selectcount"];
        [request_1 setPostValue:@"goods" forKey:@"type"];
        
        [request_1 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request_1.tag = 102;
        request_1.delegate = self;
        [request_1 setDidFailSelector:@selector(urlRequestFailed:)];
        [request_1 setDidFinishSelector:@selector(lifeGroupHomeurlRequestSucceeded:)];
        [request_1 startAsynchronous];
        
        NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL, TYPEGROUP_URL]];
        request_2 = [ASIFormDataRequest requestWithURL:url3];
        [request_2 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
        [request_2 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
        [request_2 setPostValue:@"goods" forKey:@"type"];
        [request_2 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request_2.tag = 104;
        [request_2 setDelegate:self];
        [request_2 setDidFailSelector:@selector(my1_urlRequestFailed:)];
        [request_2 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
        [request_2 startAsynchronous];
        
        //在这里获得筛选列表的数据 发起请求
        NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL, TYPEGROUP_URL]];
        
        request_3 = [ASIFormDataRequest requestWithURL:url2];
        [request_3 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
        [request_3 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
        [request_3 setPostValue:@"life" forKey:@"type"];
        if([msg isEqualToString:@"不限"]){
            [request_3 setPostValue:@"" forKey:@"gc_id"];
        }else{
            [request_3 setPostValue:msg forKey:@"gc_id"];
        }
        if([msc isEqualToString:@"不限"]){
            [request_3 setPostValue:@"" forKey:@"gpr_id"];
        }else{
            [request_3 setPostValue:msc forKey:@"gpr_id"];
        }
        [request_3 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request_3.tag = 201;
        request_3.delegate = self;
        [request_3 setDidFailSelector:@selector(my2_urlRequestFailed:)];
        [request_3 setDidFinishSelector:@selector(my2_urlRequestSucceeded:)];
        [request_3 startAsynchronous];
    }
    return self;
}

-(void)my4_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"4life_dibBig-->>%@",dicBig);
        if (dicBig) {
            NSArray *array = [dicBig objectForKey:@"area_list"];
            if (dataArr5.count != 0) {
                [dataArr5 removeAllObjects];
            }
            for (NSDictionary *dic in array) {
                Model *shjm = [[Model alloc]init];
                shjm.classify_className = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
                shjm.classify_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                [dataArr5 addObject:shjm];
            }
            [areaTableView reloadData];
        }
    }
}
-(void)my4_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
}
-(void)my3_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        [SYObject endLoading];
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"2life_dibBig-->>%@",dicBig);
        if (dicBig) {
            NSArray *array = [dicBig objectForKey:@"grouplist"];
            if (dataArr.count != 0) {
                [dataArr removeAllObjects];
            }
            for (NSDictionary *dic in array) {
                Model *shjm = [[Model alloc]init];
                shjm.gg_img = [dic objectForKey:@"gg_img"];
                shjm.gg_name = [dic objectForKey:@"gg_name"];
                shjm.gg_price = [dic objectForKey:@"gg_price"];
                shjm.gg_selled_count = [dic objectForKey:@"gg_selled_count"];
                shjm.gg_id = [dic objectForKey:@"id"];
                [dataArr addObject:shjm];
            }
            if (dataArr.count == 0) {
                lifeCollectionView.hidden = YES;
            }
            else{
                lifeCollectionView.hidden = NO;
            }
            [lifeCollectionView reloadData];
        }
    }
}
-(void)my3_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
}
-(void)my2_urlRequestSucceeded:(ASIFormDataRequest *)request{
    ClassifySelectTag_life = 1;
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig-->>%@",dicBig);
        if (dicBig) {
            NSArray *array = [dicBig objectForKey:@"gc_list"];
            if (dataArr_life.count != 0) {
                [dataArr_life removeAllObjects];
            }
            for (NSDictionary *dic in array) {
                Model *shjm = [[Model alloc]init];
                shjm.classify_className = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
                shjm.classify_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                [dataArr_life addObject:shjm];
            }
            [typeTableView2 reloadData];
            NSArray *array2 = [dicBig objectForKey:@"gp_list"];
            
            PriceSelectTag_life = dataArr_life.count+2;
            if (dataArr_life_P.count != 0) {
                [dataArr_life_P removeAllObjects];
            }
            for (NSDictionary *dic in array2) {
                Model *shjm = [[Model alloc]init];
                shjm.classify_className = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
                shjm.classify_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                [dataArr_life_P addObject:shjm];
            }
            [dataArr_life addObjectsFromArray:dataArr_life_P];
            [typeTableView2 reloadData];
        }
    }
}
-(void)my2_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
}
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig-->>%@",dicBig);
        if (dicBig) {
            NSArray *array = [dicBig objectForKey:@"gc_list"];
            if (dataArr2.count != 0) {
                [dataArr2 removeAllObjects];
            }
            for (NSDictionary *dic in array) {
                Model *shjm = [[Model alloc]init];
                shjm.classify_className = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
                shjm.classify_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                [dataArr2 addObject:shjm];
            }
            NSArray *array2 = [dicBig objectForKey:@"gp_list"];
            PriceSelectTag_goods = dataArr2.count+2;
            if (dataArr3.count != 0) {
                [dataArr3 removeAllObjects];
            }
            for (NSDictionary *dic in array2) {
                Model *shjm = [[Model alloc]init];
                shjm.classify_className = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
                shjm.classify_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                [dataArr3 addObject:shjm];
            }
            [dataArr2 addObjectsFromArray:dataArr3];
            [typeTableView reloadData];
        }
    }
}
-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
}
-(void)lifeGroupHomeurlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        [SYObject endLoading];
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"nnnn1goods_dibBig-->>%@",dicBig);
        if (dicBig) {
            NSArray *array = [dicBig objectForKey:@"grouplist"];
            if (dataArr.count != 0) {
                [dataArr removeAllObjects];
            }
            for (NSDictionary *dic in array) {
                Model *shjm = [[Model alloc]init];
                shjm.gg_img = [dic objectForKey:@"gg_img"];
                shjm.gg_name = [dic objectForKey:@"gg_name"];
                shjm.gg_price = [dic objectForKey:@"gg_price"];
                shjm.gg_selled_count = [dic objectForKey:@"gg_selled_count"];
                shjm.gg_id = [dic objectForKey:@"id"];
                [dataArr addObject:shjm];
            }
            if (dataArr.count == 0) {
                goodCollectionView.hidden = YES;
            }
            else{
                goodCollectionView.hidden = NO;
            }
            [goodCollectionView reloadData];
        }
    }
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
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
-(void)createTopView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 64)];
    view.backgroundColor = MY_COLOR;
    [self.view addSubview:view];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
    button.frame =CGRectMake(10, 20, 44, 44);
    [button setBackgroundImage:[UIImage imageNamed:@"back_lj"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font  = [UIFont systemFontOfSize:14];
    [view addSubview:button];
    
    btnArea = [UIButton buttonWithType:UIButtonTypeCustom];
    btnArea.frame = CGRectMake(0, 0, 130, 35);
    btnArea.center = CGPointMake(ScreenFrame.size.width/2, 44);
    btnArea.tag = 202;
    [btnArea addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnArea];
    _labelArea = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 35)];
    _labelArea.text = @"全国";
    _labelArea.textAlignment = NSTextAlignmentCenter;
    _labelArea.textColor = [UIColor whiteColor];
    _labelArea.font = [UIFont systemFontOfSize:21];
    [btnArea addSubview:_labelArea];
    UILabel *labelArea2 = [[UILabel alloc]initWithFrame:CGRectMake(100, 13, 15, 10)];
    labelArea2.text = @"▼";
    labelArea2.textAlignment = NSTextAlignmentCenter;
    labelArea2.textColor = [UIColor whiteColor];
    labelArea2.font = [UIFont systemFontOfSize:12];
    [btnArea addSubview:labelArea2];
    
    btnType = [UIButton buttonWithType:UIButtonTypeCustom];
    btnType.frame = CGRectMake(ScreenFrame.size.width - 70, 25, 60, 40);
    btnType.tag = 201;
    [btnType setTitle:@"筛选" forState:UIControlStateNormal];
    [btnType addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnType.titleLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:btnType];
    
    btnType2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnType2.frame = CGRectMake(ScreenFrame.size.width - 70, 25, 60, 40);
    btnType2.tag = 301;
    btnType2.hidden = YES;
    [btnType2 setTitle:@"筛选" forState:UIControlStateNormal];
    [btnType2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnType2.titleLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:btnType2];
}
-(void)backBtnClicked{
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    [tempWindow setAlpha:1];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) createCollectionView{
    //初始化
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc]init];
    [flowLayOut setScrollDirection:UICollectionViewScrollDirectionVertical];
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    if (ScreenFrame.size.height >480) {
        goodCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, ScreenFrame.origin.y+96, ScreenFrame.size.width, ScreenFrame.size.height-96)collectionViewLayout:flowLayOut];
    }else{
        goodCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, ScreenFrame.origin.y+96, ScreenFrame.size.width, ScreenFrame.size.height-96)collectionViewLayout:flowLayOut];
    }
    goodCollectionView.backgroundColor = [UIColor whiteColor];
    [goodCollectionView registerClass:[IntegralCell class] forCellWithReuseIdentifier:@"IntegralCell"];
    goodCollectionView.delegate = self;
    goodCollectionView.dataSource = self;
    [goodCollectionView addFooterWithTarget:self action:@selector(addFooter2)];
    [self.view addSubview:goodCollectionView];
    
    if (ScreenFrame.size.height >480) {
        lifeCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, ScreenFrame.origin.y+96, ScreenFrame.size.width, ScreenFrame.size.height-96)collectionViewLayout:flowLayOut];
    }else{
        lifeCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, ScreenFrame.origin.y+96, ScreenFrame.size.width, ScreenFrame.size.height-96)collectionViewLayout:flowLayOut];
    }
    lifeCollectionView.backgroundColor = [UIColor whiteColor];
    [lifeCollectionView registerClass:[IntegralCell class] forCellWithReuseIdentifier:@"IntegralCell"];
    lifeCollectionView.delegate = self;
    lifeCollectionView.dataSource = self;
    lifeCollectionView.hidden = YES;
    [lifeCollectionView addFooterWithTarget:self action:@selector(addFooter3)];
    [self.view addSubview:lifeCollectionView ];
}
-(void) createViewType{
    viewTypeBG = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    viewTypeBG.backgroundColor = [UIColor blackColor];
    viewTypeBG.alpha = 0.7f;
    viewTypeBG.hidden = YES;
    [self.view addSubview:viewTypeBG];
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    if (ScreenFrame.size.height>480) {//说明是5 5s
        typeTableView = [[UITableView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-150, 64, 150, ScreenFrame.size.height-64) style:UITableViewStylePlain];
    }else{
        typeTableView = [[UITableView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-150, 64, 150, ScreenFrame.size.height-64) style:UITableViewStylePlain];
    }
    typeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    typeTableView.backgroundColor = [UIColor clearColor];
    typeTableView.delegate = self;
    typeTableView.dataSource = self;
    typeTableView.hidden = YES;
    typeTableView.showsVerticalScrollIndicator= NO;
    typeTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:typeTableView];
    if (ScreenFrame.size.height>480) {//说明是5 5s
        typeTableView2 = [[UITableView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-150, 64, 150, ScreenFrame.size.height-64) style:UITableViewStylePlain];
    }else{
        typeTableView2 = [[UITableView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-150, 64, 150, ScreenFrame.size.height-64) style:UITableViewStylePlain];
    }
    viewTypeBG3 = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    viewTypeBG3.backgroundColor = [UIColor blackColor];
    viewTypeBG3.alpha = 0.7f;
    viewTypeBG3.hidden = YES;
    [self.view addSubview:viewTypeBG3];
    typeTableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    typeTableView2.backgroundColor = [UIColor clearColor];
    typeTableView2.delegate = self;
    typeTableView2.dataSource = self;
    typeTableView2.hidden = YES;
    typeTableView2.showsVerticalScrollIndicator= NO;
    typeTableView2.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:typeTableView2];
    
    viewTypeBG2 = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    viewTypeBG2.backgroundColor = [UIColor blackColor];
    viewTypeBG2.alpha = 0.7f;
    viewTypeBG2.hidden = YES;
    [self.view addSubview:viewTypeBG2];
    if (ScreenFrame.size.height>480) {//说明是5 5s
        areaTableView = [[UITableView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-240, 76, 160, 240) style:UITableViewStylePlain];
    }else{
        areaTableView = [[UITableView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-240, 76, 160, 240) style:UITableViewStylePlain];
    }
    areaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    areaTableView.layer.cornerRadius = 10;
    areaTableView.layer.masksToBounds = YES;
    areaTableView.layer.borderWidth = 2;
    areaTableView.layer.borderColor = [[UIColor blackColor] CGColor];
    areaTableView.delegate = self;
    areaTableView.dataSource = self;
    areaTableView.hidden = YES;
    areaTableView.showsVerticalScrollIndicator= NO;
    areaTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:areaTableView];
    
    _labelArea2 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width - 165, 68, 15, 10)];
    _labelArea2.text = @"▲";
    _labelArea2.textColor = [UIColor whiteColor];
    _labelArea2.alpha = 100;
    _labelArea2.hidden = YES;
    [self.view addSubview:_labelArea2];
}

-(void)change:(UISegmentedControl *)segmentControl{
    if (segmentControl.selectedSegmentIndex == 0) {
        btnType2.hidden = YES;
        btnType.hidden = NO;
        goodCollectionView.hidden = NO;
        lifeCollectionView.hidden = YES;
        PriceSelectTag_goods = dataArr2.count-dataArr3.count+2;
        ClassifySelectTag_goods = 1;
        [typeTableView reloadData];
        msc = @"";
        msg = @"";
        _type = @"goods";
        [SYObject startLoadingInSuperview:self.view];
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL, GROUPHOME_URL]];
        request_4 = [ASIFormDataRequest requestWithURL:url];
        [request_4 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
        [request_4 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
        [request_4 setPostValue:@"goods" forKey:@"type"];
        [request_4 setPostValue:areafl forKey:@"ga_id"];
        [request_4 setPostValue:@"0" forKey:@"begincount"];
        [request_4 setPostValue:@"10" forKey:@"selectcount"];
        
        [request_4 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request_4.tag = 102;
        request_4.delegate = self;
        [request_4 setDidFailSelector:@selector(urlRequestFailed:)];
        [request_4 setDidFinishSelector:@selector(lifeGroupHomeurlRequestSucceeded:)];
        [request_4 startAsynchronous];
    }
    else{
        msc = @"";
        msg = @"";
        btnType2.hidden = NO;
        btnType.hidden = YES;
        ClassifySelectTag_life = 1;
        PriceSelectTag_life = dataArr_life.count-dataArr_life_P.count+2;
        [typeTableView2 reloadData];
        goodCollectionView.hidden = YES;
        lifeCollectionView.hidden = NO;
        _type = @"life";
        [SYObject startLoadingInSuperview:self.view];
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL, GROUPHOME_URL]];
        request_5 = [ASIFormDataRequest requestWithURL:url];
        [request_5 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
        [request_5 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
        [request_5 setPostValue:@"life" forKey:@"type"];
        [request_5 setPostValue:areafl forKey:@"ga_id"];
        [request_5 setPostValue:@"0" forKey:@"begincount"];
        [request_5 setPostValue:@"10" forKey:@"selectcount"];
        
        [request_5 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request_5.tag = 103;
        request_5.delegate = self;
        [request_5 setDidFailSelector:@selector(my3_urlRequestFailed:)];
        [request_5 setDidFinishSelector:@selector(my3_urlRequestSucceeded:)];
        [request_5 startAsynchronous];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == typeTableView) {
        if (dataArr2.count != 0) {
            return dataArr2.count+3;
        }
    }
    if (tableView == typeTableView2) {
        if (dataArr_life.count != 0) {
            return dataArr_life.count+3;
        }
    }
    if (tableView == areaTableView) {
        if (dataArr5.count != 0) {
            return dataArr5.count +1;
        }
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView ==typeTableView) {
        if(dataArr2.count != 0){
            if (indexPath.row == dataArr2.count-dataArr3.count+2) {
                return 60;
            }
        }
    }
    if (tableView == typeTableView2) {
        if(dataArr_life.count != 0){
            if (indexPath.row == dataArr_life.count-dataArr_life_P.count+2) {
                return 60;
            }
        }
    }
    if (tableView == areaTableView) {
        if (dataArr5.count != 0) {
            if (indexPath.row == 0) {
                return 30;
            }else{
                Model *shjm = [dataArr5 objectAtIndex:indexPath.row-1];
                if ([shjm.classify_className isEqualToString:@"全国"]){
                    return 0;
                }else{
                    return 30;
                }
            }
        }
    }
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == typeTableView) {
        static NSString *typeTableViewCell = @"typeCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:typeTableViewCell];
            cell.selectionStyle = UITableViewCellEditingStyleNone;
        }
        if (indexPath.row == 0){
            cell.backgroundColor = SHJ_COLOR;
            UILabel *lblTitle2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
            lblTitle2.text = @"种类";
            lblTitle2.textAlignment = NSTextAlignmentCenter;
            lblTitle2.font = [UIFont systemFontOfSize:15.0f];
            [cell addSubview:lblTitle2];
        }else if(indexPath.row == 1){
            UIImageView *imgbg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 130, 25)];
            imgbg.alpha = 0.6;
            CALayer *lay = imgbg.layer;
            imgbg.layer.borderWidth = 1;
            if (indexPath.row == ClassifySelectTag_goods) {
                imgbg.layer.borderColor = [MY_COLOR CGColor];
            }else if(indexPath.row == PriceSelectTag_goods){
                imgbg.layer.borderColor = [MY_COLOR CGColor];
            }else{
                imgbg.layer.borderColor = [[UIColor lightGrayColor]CGColor];
            }
            [lay setMasksToBounds:YES];
            [lay setCornerRadius:6.0f];
            [cell addSubview:imgbg];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 130, 25)];
            label.text = @"不限";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont boldSystemFontOfSize:15];
            [cell addSubview:label];
        }
        else if (dataArr2.count != 0){
            if (indexPath.row == dataArr2.count-dataArr3.count+2) {
                UIImageView *imgbg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 130, 25)];
                imgbg.alpha = 0.6;
                CALayer *lay = imgbg.layer;
                imgbg.layer.borderWidth = 1;
                if (indexPath.row == ClassifySelectTag_goods) {
                    imgbg.layer.borderColor = [MY_COLOR CGColor];
                }else if(indexPath.row == PriceSelectTag_goods){
                    imgbg.layer.borderColor = [MY_COLOR CGColor];
                }else{
                    imgbg.layer.borderColor = [[UIColor lightGrayColor]CGColor];
                }
                [lay setMasksToBounds:YES];
                [lay setCornerRadius:6.0f];
                [cell addSubview:imgbg];
                
                imgbg.frame = CGRectMake(10, 35, 130, 25);
                UILabel *lblTitle2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
                lblTitle2.text = @"价格";
                lblTitle2.backgroundColor = SHJ_COLOR;
                lblTitle2.textAlignment = NSTextAlignmentCenter;
                lblTitle2.font = [UIFont systemFontOfSize:15.0f];
                [cell addSubview:lblTitle2];
                UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 130, 25)];
                label3.text = @"不限";
                label3.textAlignment = NSTextAlignmentCenter;
                label3.font = [UIFont boldSystemFontOfSize:15];
                [cell addSubview:label3];
            }else if (indexPath.row>dataArr2.count-dataArr3.count+2){
                UIImageView *imgbg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 130, 25)];
                imgbg.alpha = 0.6;
                CALayer *lay = imgbg.layer;
                imgbg.layer.borderWidth = 1;
                if (indexPath.row == ClassifySelectTag_goods) {
                    imgbg.layer.borderColor = [MY_COLOR CGColor];
                }else if(indexPath.row == PriceSelectTag_goods){
                    imgbg.layer.borderColor = [MY_COLOR CGColor];
                }else{
                    imgbg.layer.borderColor = [[UIColor lightGrayColor]CGColor];
                }
                [lay setMasksToBounds:YES];
                [lay setCornerRadius:6.0f];
                [cell addSubview:imgbg];
                
                Model *shjm = [dataArr2 objectAtIndex:indexPath.row-3];
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 130, 25)];
                label.text = [NSString stringWithFormat:@"%@",shjm.classify_className];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont boldSystemFontOfSize:15];
                [cell addSubview:label];
            }else{
                UIImageView *imgbg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 130, 25)];
                imgbg.alpha = 0.6;
                CALayer *lay = imgbg.layer;
                imgbg.layer.borderWidth = 1;
                if (indexPath.row == ClassifySelectTag_goods) {
                    imgbg.layer.borderColor = [MY_COLOR CGColor];
                }else if(indexPath.row == PriceSelectTag_goods){
                    imgbg.layer.borderColor = [MY_COLOR CGColor];
                }else{
                    imgbg.layer.borderColor = [[UIColor lightGrayColor]CGColor];
                }
                [lay setMasksToBounds:YES];
                [lay setCornerRadius:6.0f];
                [cell addSubview:imgbg];
                
                Model *shjm = [dataArr2 objectAtIndex:indexPath.row-2];
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 130, 25)];
                label.text = [NSString stringWithFormat:@"%@",shjm.classify_className];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont boldSystemFontOfSize:15];
                [cell addSubview:label];
            }
        }
        return cell;
    }
    if (tableView == typeTableView2) {
        static NSString *typeTableViewCell = @"typeCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:typeTableViewCell];
            cell.selectionStyle = UITableViewCellEditingStyleNone;
        }
        if (indexPath.row == 0){
            cell.backgroundColor = SHJ_COLOR;
            UILabel *lblTitle2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
            lblTitle2.text = @"种类";
            lblTitle2.textAlignment = NSTextAlignmentCenter;
            lblTitle2.font = [UIFont systemFontOfSize:15.0f];
            [cell addSubview:lblTitle2];
        }else if(indexPath.row == 1){
            UIImageView *imgbg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 130, 25)];
            imgbg.alpha = 0.6;
            CALayer *lay = imgbg.layer;
            imgbg.layer.borderWidth = 1;
            if (indexPath.row == ClassifySelectTag_life) {
                imgbg.layer.borderColor = [MY_COLOR CGColor];
            }else if(indexPath.row == PriceSelectTag_life){
                imgbg.layer.borderColor = [MY_COLOR CGColor];
            }else{
                imgbg.layer.borderColor = [[UIColor lightGrayColor]CGColor];
            }
            [lay setMasksToBounds:YES];
            [lay setCornerRadius:6.0f];
            [cell addSubview:imgbg];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 130, 25)];
            label.text = @"不限";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont boldSystemFontOfSize:15];
            [cell addSubview:label];
        }
        else if (dataArr_life.count != 0){
            if (indexPath.row == dataArr_life.count-dataArr_life_P.count+2) {
                UIImageView *imgbg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 130, 25)];
                imgbg.alpha = 0.6;
                CALayer *lay = imgbg.layer;
                imgbg.layer.borderWidth = 1;
                if (indexPath.row == ClassifySelectTag_life) {
                    imgbg.layer.borderColor = [MY_COLOR CGColor];
                }else if(indexPath.row == PriceSelectTag_life){
                    imgbg.layer.borderColor = [MY_COLOR CGColor];
                }else{
                    imgbg.layer.borderColor = [[UIColor lightGrayColor]CGColor];
                }
                [lay setMasksToBounds:YES];
                [lay setCornerRadius:6.0f];
                [cell addSubview:imgbg];
                
                imgbg.frame = CGRectMake(10, 35, 130, 25);
                UILabel *lblTitle2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
                lblTitle2.text = @"价格";
                lblTitle2.backgroundColor = SHJ_COLOR;
                lblTitle2.textAlignment = NSTextAlignmentCenter;
                lblTitle2.font = [UIFont systemFontOfSize:15.0f];
                [cell addSubview:lblTitle2];
                UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 130, 25)];
                label3.text = @"不限";
                label3.textAlignment = NSTextAlignmentCenter;
                label3.font = [UIFont boldSystemFontOfSize:15];
                [cell addSubview:label3];
            }else if (indexPath.row>dataArr_life.count-dataArr_life_P.count+2){
                UIImageView *imgbg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 130, 25)];
                imgbg.alpha = 0.6;
                CALayer *lay = imgbg.layer;
                imgbg.layer.borderWidth = 1;
                if (indexPath.row == ClassifySelectTag_life) {
                    imgbg.layer.borderColor = [MY_COLOR CGColor];
                }else if(indexPath.row == PriceSelectTag_life){
                    imgbg.layer.borderColor = [MY_COLOR CGColor];
                }else{
                    imgbg.layer.borderColor = [[UIColor lightGrayColor]CGColor];
                }
                [lay setMasksToBounds:YES];
                [lay setCornerRadius:6.0f];
                [cell addSubview:imgbg];
                
                Model *shjm = [dataArr_life objectAtIndex:indexPath.row-3];
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 130, 25)];
                label.text = [NSString stringWithFormat:@"%@",shjm.classify_className];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont boldSystemFontOfSize:15];
                [cell addSubview:label];
            }else{
                UIImageView *imgbg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 130, 25)];
                imgbg.alpha = 0.6;
                CALayer *lay = imgbg.layer;
                imgbg.layer.borderWidth = 1;
                if (indexPath.row == ClassifySelectTag_life) {
                    imgbg.layer.borderColor = [MY_COLOR CGColor];
                }else if(indexPath.row == PriceSelectTag_life){
                    imgbg.layer.borderColor = [MY_COLOR CGColor];
                }else{
                    imgbg.layer.borderColor = [[UIColor lightGrayColor]CGColor];
                }
                [lay setMasksToBounds:YES];
                [lay setCornerRadius:6.0f];
                [cell addSubview:imgbg];
                
                Model *shjm = [dataArr_life objectAtIndex:indexPath.row-2];
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 130, 25)];
                label.text = [NSString stringWithFormat:@"%@",shjm.classify_className];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont boldSystemFontOfSize:15];
                [cell addSubview:label];
            }
        }
        return cell;
    }
    if (tableView == areaTableView) {
        static NSString *areaTableViewCell = @"areaCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:areaTableViewCell];
            cell.selectionStyle = UITableViewCellEditingStyleNone;
        }
        UIImageView *imgbg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 2, 140, 25)];
        imgbg.alpha = 0.6;
        CALayer *lay = imgbg.layer;
        imgbg.layer.borderWidth = 0.5;
        imgbg.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        [lay setMasksToBounds:YES];
        [lay setCornerRadius:6.0f];
        [cell addSubview:imgbg];
        if (indexPath.row == 0){
            UILabel *lblTitle2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 160, 30)];
            lblTitle2.text = @"全国";
            lblTitle2.textAlignment = NSTextAlignmentCenter;
            lblTitle2.font = [UIFont systemFontOfSize:17.0f];
            [cell addSubview:lblTitle2];
        }
        else if (dataArr5.count != 0){
            Model *shjm = [dataArr5 objectAtIndex:indexPath.row-1];
            if ([shjm.classify_className isEqualToString:@"全国"]) {
                cell.textLabel.text = [NSString stringWithFormat:@""];
            }else{
                cell.textLabel.text = [NSString stringWithFormat:@"%@",shjm.classify_className];
            }
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        return cell;
    }
    
    UITableViewCell *cell;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == typeTableView) {
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 1) {
            ClassifySelectTag_goods = indexPath.row;
            msg = @"不限";
            if (PriceSelectTag_goods == dataArr2.count-dataArr3.count+2) {
                msc = @"不限";
            }else{
                Model *shhs= [dataArr2 objectAtIndex:PriceSelectTag_goods-3];
                msc =shhs.classify_id;
            }
            
            [typeTableView reloadData];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL, GROUPHOME_URL]];
            request_6 = [ASIFormDataRequest requestWithURL:url];
            [request_6 setPostValue:@"goods" forKey:@"type"];
            if([msg isEqualToString:@"不限"]){
                [request_6 setPostValue:@"" forKey:@"gc_id"];
            }else{
                [request_6 setPostValue:msg forKey:@"gc_id"];
            }
            if([msc isEqualToString:@"不限"]){
                [request_6 setPostValue:@"" forKey:@"gpr_id"];
            }else{
                [request_6 setPostValue:msc forKey:@"gpr_id"];
            }
            [request_6 setPostValue:@"0" forKey:@"begincount"];
            [request_6 setPostValue:@"10" forKey:@"selectcount"];
            
            [request_6 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request_6.tag = 102;
            request_6.delegate = self;
            [request_6 setDidFailSelector:@selector(urlRequestFailed:)];
            [request_6 setDidFinishSelector:@selector(lifeGroupHomeurlRequestSucceeded:)];
            [request_6 startAsynchronous];
        }else if(indexPath.row == dataArr2.count-dataArr3.count+2){
            PriceSelectTag_goods = indexPath.row;
            msc = @"不限";
            if (ClassifySelectTag_goods == 1) {
                msg = @"不限";
            }else{
                Model *ss = [dataArr2 objectAtIndex:ClassifySelectTag_goods-2];
                msg = ss.classify_id;
            }
            [typeTableView reloadData];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL, GROUPHOME_URL]];
            request_7 = [ASIFormDataRequest requestWithURL:url];
            [request_7 setPostValue:@"goods" forKey:@"type"];
            if([msg isEqualToString:@"不限"]){
                [request_7 setPostValue:@"" forKey:@"gc_id"];
            }else{
                [request_7 setPostValue:msg forKey:@"gc_id"];
            }
            if([msc isEqualToString:@"不限"]){
                [request_7 setPostValue:@"" forKey:@"gpr_id"];
            }else{
                [request_7 setPostValue:msc forKey:@"gpr_id"];
            }
            [request_7 setPostValue:@"0" forKey:@"begincount"];
            [request_7 setPostValue:@"10" forKey:@"selectcount"];
            
            [request_7 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request_7.tag = 102;
            request_7.delegate = self;
            [request_7 setDidFailSelector:@selector(urlRequestFailed:)];
            [request_7 setDidFinishSelector:@selector(lifeGroupHomeurlRequestSucceeded:)];
            [request_7 startAsynchronous];
        }else if(indexPath.row > dataArr2.count-dataArr3.count+2){
            PriceSelectTag_goods = indexPath.row;
            if (ClassifySelectTag_goods == 1) {
                msg = @"不限";
            }else{
                Model *ss = [dataArr2 objectAtIndex:ClassifySelectTag_goods-2];
                msg = ss.classify_id;
            }
            Model *ss = [dataArr2 objectAtIndex:PriceSelectTag_goods-3];
            msc = ss.classify_id;
            [typeTableView reloadData];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL, GROUPHOME_URL]];
            request_8 = [ASIFormDataRequest requestWithURL:url];
            [request_8 setPostValue:@"goods" forKey:@"type"];
            if([msg isEqualToString:@"不限"]){
                [request_8 setPostValue:@"" forKey:@"gc_id"];
            }else{
                [request_8 setPostValue:msg forKey:@"gc_id"];
            }
            if([msc isEqualToString:@"不限"]){
                [request_8 setPostValue:@"" forKey:@"gpr_id"];
            }else{
                [request_8 setPostValue:msc forKey:@"gpr_id"];
            }
            [request_8 setPostValue:@"0" forKey:@"begincount"];
            [request_8 setPostValue:@"10" forKey:@"selectcount"];
            
            [request_8 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request_8.tag = 102;
            request_8.delegate = self;
            [request_8 setDidFailSelector:@selector(urlRequestFailed:)];
            [request_8 setDidFinishSelector:@selector(lifeGroupHomeurlRequestSucceeded:)];
            [request_8 startAsynchronous];
        }else{
            ClassifySelectTag_goods = indexPath.row;
            [typeTableView reloadData];
            Model *shjm;
            if (PriceSelectTag_goods == dataArr2.count-dataArr3.count+2) {
                msc = @"不限";
            }
            if (indexPath.row>dataArr2.count-dataArr3.count+2){
                shjm = [dataArr2 objectAtIndex:indexPath.row-3];
                msc = shjm.classify_id;
            }
            if (ClassifySelectTag_goods == 1) {
                msg = @"不限";
            }
            if (indexPath.row == dataArr2.count-dataArr3.count+2) {
                msg = @"不限";
            }else{
                shjm = [dataArr2 objectAtIndex:indexPath.row-2];
                msg = shjm.classify_id;
            }
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL, GROUPHOME_URL]];
            request_9 = [ASIFormDataRequest requestWithURL:url];
            [request_9 setPostValue:@"goods" forKey:@"type"];
            if([msg isEqualToString:@"不限"]){
                [request_9 setPostValue:@"" forKey:@"gc_id"];
            }else{
                [request_9 setPostValue:msg forKey:@"gc_id"];
            }
            if([msc isEqualToString:@"不限"]){
                [request_9 setPostValue:@"" forKey:@"gpr_id"];
            }else{
                [request_9 setPostValue:msc forKey:@"gpr_id"];
            }
            [request_9 setPostValue:@"0" forKey:@"begincount"];
            [request_9 setPostValue:@"10" forKey:@"selectcount"];
            
            [request_9 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request_9.tag = 102;
            request_9.delegate = self;
            [request_9 setDidFailSelector:@selector(urlRequestFailed:)];
            [request_9 setDidFinishSelector:@selector(lifeGroupHomeurlRequestSucceeded:)];
            [request_9 startAsynchronous];
        }
    }
    if (tableView == typeTableView2) {
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 1) {
            ClassifySelectTag_life = indexPath.row;
            msg = @"不限";
            if (PriceSelectTag_life == dataArr_life.count-dataArr_life_P.count+2) {
                msc = @"不限";
            }else{
                Model *shhs= [dataArr_life objectAtIndex:PriceSelectTag_life-3];
                msc =shhs.classify_id;
            }
            
            [typeTableView2 reloadData];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL, GROUPHOME_URL]];
            request_10 = [ASIFormDataRequest requestWithURL:url];
            [request_10 setPostValue:@"life" forKey:@"type"];
            if([msg isEqualToString:@"不限"]){
                [request_10 setPostValue:@"" forKey:@"gc_id"];
            }else{
                [request_10 setPostValue:msg forKey:@"gc_id"];
            }
            if([msc isEqualToString:@"不限"]){
                [request_10 setPostValue:@"" forKey:@"gpr_id"];
            }else{
                [request_10 setPostValue:msc forKey:@"gpr_id"];
            }
            [request_10 setPostValue:@"0" forKey:@"begincount"];
            [request_10 setPostValue:@"10" forKey:@"selectcount"];
            
            [request_10 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request_10.tag = 103;
            request_10.delegate = self;
            [request_10 setDidFailSelector:@selector(my3_urlRequestFailed:)];
            [request_10 setDidFinishSelector:@selector(my3_urlRequestSucceeded:)];
            [request_10 startAsynchronous];
        }else if(indexPath.row == dataArr_life.count-dataArr_life_P.count+2){
            PriceSelectTag_life = indexPath.row;
            msc = @"不限";
            if (ClassifySelectTag_life == 1) {
                msg = @"不限";
            }else{
                Model *ss = [dataArr_life objectAtIndex:ClassifySelectTag_life-2];
                msg = ss.classify_id;
            }
            [typeTableView2 reloadData];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL, GROUPHOME_URL]];
            request_11 = [ASIFormDataRequest requestWithURL:url];
            [request_11 setPostValue:@"life" forKey:@"type"];
            if([msg isEqualToString:@"不限"]){
                [request_11 setPostValue:@"" forKey:@"gc_id"];
            }else{
                [request_11 setPostValue:msg forKey:@"gc_id"];
            }
            if([msc isEqualToString:@"不限"]){
                [request_11 setPostValue:@"" forKey:@"gpr_id"];
            }else{
                [request_11 setPostValue:msc forKey:@"gpr_id"];
            }
            [request_11 setPostValue:@"0" forKey:@"begincount"];
            [request_11 setPostValue:@"10" forKey:@"selectcount"];
            
            [request_11 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request_11.tag = 103;
            request_11.delegate = self;
            [request_11 setDidFailSelector:@selector(my3_urlRequestFailed:)];
            [request_11 setDidFinishSelector:@selector(my3_urlRequestSucceeded:)];
            [request_11 startAsynchronous];
        }else if(indexPath.row > dataArr_life.count-dataArr_life_P.count+2){
            PriceSelectTag_life = indexPath.row;
            if (ClassifySelectTag_life == 1) {
                msg = @"不限";
            }else{
                Model *ss = [dataArr_life objectAtIndex:ClassifySelectTag_life-2];
                msg = ss.classify_id;
            }
            Model *ss = [dataArr_life objectAtIndex:PriceSelectTag_life-3];
            msc = ss.classify_id;
            [typeTableView2 reloadData];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL, GROUPHOME_URL]];
            request_12 = [ASIFormDataRequest requestWithURL:url];
            [request_12 setPostValue:@"life" forKey:@"type"];
            if([msg isEqualToString:@"不限"]){
                [request_12 setPostValue:@"" forKey:@"gc_id"];
            }else{
                [request_12 setPostValue:msg forKey:@"gc_id"];
            }
            if([msc isEqualToString:@"不限"]){
                [request_12 setPostValue:@"" forKey:@"gpr_id"];
            }else{
                [request_12 setPostValue:msc forKey:@"gpr_id"];
            }
            [request_12 setPostValue:@"0" forKey:@"begincount"];
            [request_12 setPostValue:@"10" forKey:@"selectcount"];
            
            [request_12 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request_12.tag = 103;
            request_12.delegate = self;
            [request_12 setDidFailSelector:@selector(my3_urlRequestFailed:)];
            [request_12 setDidFinishSelector:@selector(my3_urlRequestSucceeded:)];
            [request_12 startAsynchronous];
        }else{
            ClassifySelectTag_life = indexPath.row;
            [typeTableView2 reloadData];
            Model *shjm;
            if (PriceSelectTag_life == dataArr_life.count-dataArr_life_P.count+2) {
                msc = @"不限";
            }
            if (indexPath.row>dataArr_life.count-dataArr_life_P.count+2){
                shjm = [dataArr_life objectAtIndex:indexPath.row-3];
                msc = shjm.classify_id;
            }
            if (ClassifySelectTag_life == 1) {
                msg = @"不限";
            }
            if (indexPath.row == dataArr_life.count-dataArr_life_P.count+2) {
                msg = @"不限";
            }else{
                shjm = [dataArr_life objectAtIndex:indexPath.row-2];
                msg = shjm.classify_id;
            }
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL, GROUPHOME_URL]];
            request_13 = [ASIFormDataRequest requestWithURL:url];
            [request_13 setPostValue:@"life" forKey:@"type"];
            if([msg isEqualToString:@"不限"]){
                [request_13 setPostValue:@"" forKey:@"gc_id"];
            }else{
                [request_13 setPostValue:msg forKey:@"gc_id"];
            }
            if([msc isEqualToString:@"不限"]){
                [request_13 setPostValue:@"" forKey:@"gpr_id"];
            }else{
                [request_13 setPostValue:msc forKey:@"gpr_id"];
            }
            [request_13 setPostValue:@"0" forKey:@"begincount"];
            [request_13 setPostValue:@"10" forKey:@"selectcount"];
            
            [request_13 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request_13.tag = 103;
            request_13.delegate = self;
            [request_13 setDidFailSelector:@selector(my3_urlRequestFailed:)];
            [request_13 setDidFinishSelector:@selector(my3_urlRequestSucceeded:)];
            [request_13 startAsynchronous];
        }
    }
    if (tableView == areaTableView) {
        if (indexPath.row == 0) {
            if ([_type isEqualToString:@"goods"]) {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL, GROUPHOME_URL]];
                request_14 = [ASIFormDataRequest requestWithURL:url];
                [request_14 setPostValue:@"0" forKey:@"begincount"];
                [request_14 setPostValue:@"10" forKey:@"selectcount"];
                [request_14 setPostValue:@"goods" forKey:@"type"];
                [request_14 setPostValue:@"" forKey:@"ga_id"];
                
                if([msg isEqualToString:@"不限"]){
                    [request_14 setPostValue:@"" forKey:@"gc_id"];
                }else{
                    [request_14 setPostValue:msg forKey:@"gc_id"];
                }
                if([msc isEqualToString:@"不限"]){
                    [request_14 setPostValue:@"" forKey:@"gpr_id"];
                }else{
                    [request_14 setPostValue:msc forKey:@"gpr_id"];
                }
                
                [request_14 setRequestHeaders:[LJControl requestHeaderDictionary]];
                request_14.tag = 102;
                request_14.delegate = self;
                [request_14 setDidFailSelector:@selector(urlRequestFailed:)];
                [request_14 setDidFinishSelector:@selector(lifeGroupHomeurlRequestSucceeded:)];
                [request_14 startAsynchronous];
                _labelArea.text = @"全国";
            }
            else{
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL, GROUPHOME_URL]];
                request_15 = [ASIFormDataRequest requestWithURL:url];
                [request_15 setPostValue:@"0" forKey:@"begincount"];
                [request_15 setPostValue:@"10" forKey:@"selectcount"];
                [request_15 setPostValue:@"life" forKey:@"type"];
                [request_15 setPostValue:@"" forKey:@"ga_id"];
                
                if([msg isEqualToString:@"不限"]){
                    [request_15 setPostValue:@"" forKey:@"gc_id"];
                }else{
                    [request_15 setPostValue:msg forKey:@"gc_id"];
                }
                if([msc isEqualToString:@"不限"]){
                    [request_15 setPostValue:@"" forKey:@"gpr_id"];
                }else{
                    [request_15 setPostValue:msc forKey:@"gpr_id"];
                }
                
                [request_15 setRequestHeaders:[LJControl requestHeaderDictionary]];
                request_15.tag = 103;
                request_15.delegate = self;
                [request_15 setDidFailSelector:@selector(my3_urlRequestFailed:)];
                [request_15 setDidFinishSelector:@selector(my3_urlRequestSucceeded:)];
                [request_15 startAsynchronous];
                _labelArea.text = @"全国";
            }
            
        }else{
            if ([_type isEqualToString:@"goods"]) {
                Model *shjm = [dataArr5 objectAtIndex:indexPath.row-1];
                areafl = shjm.classify_id;
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL, GROUPHOME_URL]];
                request_16 = [ASIFormDataRequest requestWithURL:url];
                [request_16 setPostValue:areafl forKey:@"ga_id"];
                [request_16 setPostValue:@"goods" forKey:@"type"];
                if([msg isEqualToString:@"不限"]){
                    [request_16 setPostValue:@"" forKey:@"gc_id"];
                }else{
                    [request_16 setPostValue:msg forKey:@"gc_id"];
                }
                if([msc isEqualToString:@"不限"]){
                    [request_16 setPostValue:@"" forKey:@"gpr_id"];
                }else{
                    [request_16 setPostValue:msc forKey:@"gpr_id"];
                }
                [request_16 setPostValue:@"0" forKey:@"begincount"];
                [request_16 setPostValue:@"10" forKey:@"selectcount"];
                
                [request_16 setRequestHeaders:[LJControl requestHeaderDictionary]];
                request_16.tag = 102;
                request_16.delegate = self;
                [request_16 setDidFailSelector:@selector(urlRequestFailed:)];
                [request_16 setDidFinishSelector:@selector(lifeGroupHomeurlRequestSucceeded:)];
                [request_16 startAsynchronous];
                _labelArea.text = shjm.classify_className;
            }
            else if([_type isEqualToString:@"life"]){
                Model *shjm = [dataArr5 objectAtIndex:indexPath.row-1];
                areafl = shjm.classify_id;
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL, GROUPHOME_URL]];
                request_17 = [ASIFormDataRequest requestWithURL:url];
                [request_17 setPostValue:areafl forKey:@"ga_id"];
                [request_17 setPostValue:@"life" forKey:@"type"];
                if([msg isEqualToString:@"不限"]){
                    [request_17 setPostValue:@"" forKey:@"gc_id"];
                }else{
                    [request_17 setPostValue:msg forKey:@"gc_id"];
                }
                if([msc isEqualToString:@"不限"]){
                    [request_17 setPostValue:@"" forKey:@"gpr_id"];
                }else{
                    [request_17 setPostValue:msc forKey:@"gpr_id"];
                }
                [request_17 setPostValue:@"0" forKey:@"begincount"];
                [request_17 setPostValue:@"10" forKey:@"selectcount"];
                
                [request_17 setRequestHeaders:[LJControl requestHeaderDictionary]];
                request_17.tag = 103;
                request_17.delegate = self;
                [request_17 setDidFailSelector:@selector(my3_urlRequestFailed:)];
                [request_17 setDidFinishSelector:@selector(my3_urlRequestSucceeded:)];
                [request_17 startAsynchronous];
                _labelArea.text = shjm.classify_className;
            }
        }
        _labelArea2.hidden = YES;
        _labelArea2.hidden = YES;
        viewTypeBG2.hidden = YES;
        areaTableView.hidden = YES;
    }
}

#pragma mark - collectionView delegate
//设置分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每个分区上的元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == goodCollectionView) {
        if (dataArr.count != 0) {
            return dataArr.count;
        }
        return 0;
    }
    if (collectionView == lifeCollectionView) {
        if (dataArr.count != 0) {
            return dataArr.count;
        }
        return 0;
    }
    return 0;
}
//设置元素内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == goodCollectionView) {
        static NSString *identify = @"IntegralCell";
        IntegralCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"IntegralCell" owner:self options:nil] lastObject];
        }else{
            for (UIView *subView in cell.contentView.subviews)
            {
                [subView removeFromSuperview];
            }
        }
        cell.backgroundColor = [UIColor whiteColor];
        CALayer *lay = cell.layer;
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        [lay setMasksToBounds:YES];
        [lay setCornerRadius:6.0f];
        CGRect rect = cell.frame;
        rect.size.width = 140;
        cell.frame = rect;
        if (dataArr.count != 0) {
            Model *shjm1231 = [dataArr objectAtIndex:indexPath.row];
            UIImageView *imgLog = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 120, 100)];
            [imgLog sd_setImageWithURL:[NSURL URLWithString:shjm1231.gg_img] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
            [cell addSubview:imgLog];
            UILabel *lblGoodsName = [[UILabel alloc]initWithFrame:CGRectMake(8, 105, 130, 44)];
            lblGoodsName.backgroundColor = [UIColor whiteColor];
            lblGoodsName.text = [NSString stringWithFormat:@"%@",shjm1231.gg_name];
            lblGoodsName.numberOfLines = 0;
            lblGoodsName.font = [UIFont systemFontOfSize:10];
            [cell addSubview:lblGoodsName];
            UILabel *lblXianjia = [[UILabel alloc]initWithFrame:CGRectMake(8, 150, 60, 20)];
            lblXianjia.backgroundColor = [UIColor whiteColor];
            lblXianjia.text = [NSString stringWithFormat:@"￥%@",shjm1231.gg_price];
            lblXianjia.textColor = [UIColor redColor];
            lblXianjia.font = [UIFont systemFontOfSize:12];
            [cell addSubview:lblXianjia];
            UILabel *lblYishouchu = [[UILabel alloc]initWithFrame:CGRectMake(70, 150, 60, 20)];
            lblYishouchu.backgroundColor = [UIColor whiteColor];
            lblYishouchu.text = [NSString stringWithFormat:@"已售出 %@",shjm1231.gg_selled_count];
            lblYishouchu.textAlignment = NSTextAlignmentRight;
            lblYishouchu.font = [UIFont systemFontOfSize:10];
            [cell addSubview:lblYishouchu];
        }
        return cell;
    }
    if (collectionView == lifeCollectionView) {
        static NSString *identify = @"IntegralCell";
        IntegralCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"IntegralCell" owner:self options:nil] lastObject];
        }
        cell.backgroundColor = [UIColor whiteColor];
        CALayer *lay = cell.layer;
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        [lay setMasksToBounds:YES];
        [lay setCornerRadius:6.0f];
        CGRect rect = cell.frame;
        rect.size.width = 140;
        cell.frame = rect;
        
        if (dataArr.count != 0) {
            Model *shjm = [dataArr objectAtIndex:indexPath.row];
            UIImageView *imgLog = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 120, 100)];
            [imgLog sd_setImageWithURL:[NSURL URLWithString:shjm.gg_img] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
            [cell addSubview:imgLog];
            UILabel *lblGoodsName = [[UILabel alloc]initWithFrame:CGRectMake(8, 105, 130, 44)];
            lblGoodsName.backgroundColor = [UIColor whiteColor];
            lblGoodsName.text = [NSString stringWithFormat:@"%@",shjm.gg_name];
            lblGoodsName.numberOfLines = 0;
            lblGoodsName.font = [UIFont systemFontOfSize:10];
            [cell addSubview:lblGoodsName];
            UILabel *lblXianjia = [[UILabel alloc]initWithFrame:CGRectMake(8, 150, 60, 20)];
            lblXianjia.backgroundColor = [UIColor whiteColor];
            lblXianjia.text = [NSString stringWithFormat:@"￥%@",shjm.gg_price];
            lblXianjia.textColor = [UIColor redColor];
            lblXianjia.font = [UIFont systemFontOfSize:12];
            [cell addSubview:lblXianjia];
            UILabel *lblYishouchu = [[UILabel alloc]initWithFrame:CGRectMake(70, 150, 60, 20)];
            lblYishouchu.backgroundColor = [UIColor whiteColor];
            lblYishouchu.text = [NSString stringWithFormat:@"已售出 %@",shjm.gg_selled_count];
            lblYishouchu.textAlignment = NSTextAlignmentRight;
            lblYishouchu.font = [UIFont systemFontOfSize:10];
            [cell addSubview:lblYishouchu];
        }
        return cell;
    }
    UICollectionViewCell *cell = [[UICollectionViewCell alloc] init];
    return cell;
}

//设置元素的的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets top = {5,ScreenFrame.size.width/2 - 145,5,ScreenFrame.size.width/2 - 145};
    return top;
}
//设置顶部的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={0,0};
    return size;
}
//设置元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(140,170);
}
//点击元素触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Model *shjm = [dataArr objectAtIndex:indexPath.row];
    LifeGroupHomeViewController *lgh = [LifeGroupHomeViewController sharedUserDefault];
    if ([_type isEqualToString:@"goods"]) {
        lgh.gg_id = shjm.gg_id;
        GoodsGroupDetailViewController *ggdVC = [[GoodsGroupDetailViewController alloc]init];
        [self.navigationController pushViewController:ggdVC animated:YES];
    }else{
        NSLog(@"shjm.gg_id:%@",shjm.gg_id);
        lgh.gg_id = shjm.gg_id;
        
    }
}

-(void)btnClicked:(UIButton *)btn{
    if (btn.tag == 301) {
        [typeTableView2 reloadData];
        if (viewTypeBG3.hidden == YES) {
            typeTableView2.hidden = NO;
            viewTypeBG3.hidden = NO;
            areaTableView.hidden = YES;
            viewTypeBG2.hidden = YES;
            _labelArea2.hidden = YES;
            UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImage:)];
            [viewTypeBG3 addGestureRecognizer:singleTap2];
        }else {
            viewTypeBG3.hidden = YES;
            typeTableView2.hidden = YES;
        }
    }
    if (btn.tag == 201) {
        if (viewTypeBG.hidden == YES) {
            typeTableView.hidden = NO;
            viewTypeBG.hidden = NO;
            areaTableView.hidden = YES;
            viewTypeBG2.hidden = YES;
            _labelArea2.hidden = YES;
            UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImage:)];
            [viewTypeBG addGestureRecognizer:singleTap2];
        }
        else {
            viewTypeBG.hidden = YES;
            typeTableView.hidden = YES;
        }
    }
    if (btn.tag == 202) {
        Model *shjm = [[Model alloc]init];
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL, AREA_URL]];
        request_18 = [ASIFormDataRequest requestWithURL:url];
        [request_18 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
        [request_18 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
        [request_18 setPostValue:shjm.classify_id forKey:@"ga_id"];
        
        [request_18 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request_18.tag = 107;
        [request_18 setDelegate:self];
        [request_18 setDidFailSelector:@selector(my4_urlRequestFailed:)];
        [request_18 setDidFinishSelector:@selector(my4_urlRequestSucceeded:)];
        [request_18 startAsynchronous];
        if ([_type isEqualToString:@"goods"]) {
            if (viewTypeBG2.hidden == YES) {
                areaTableView.hidden = NO;
                viewTypeBG2.hidden = NO;
                _labelArea2.hidden = NO;
                typeTableView.hidden = YES;
                viewTypeBG.hidden = YES;
                [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImage:)];
                [viewTypeBG2 addGestureRecognizer:singleTap];
            }
            else {
                viewTypeBG2.hidden = YES;
                areaTableView.hidden = YES;
                _labelArea2.hidden = YES;
            }
        }
        else if ([_type isEqualToString:@"life"]){
            if (viewTypeBG2.hidden == YES) {
                areaTableView.hidden = NO;
                viewTypeBG2.hidden = NO;
                _labelArea2.hidden = NO;
                typeTableView2.hidden = YES;
                viewTypeBG3.hidden = YES;
                [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImage:)];
                [viewTypeBG2 addGestureRecognizer:singleTap];
            }
            else {
                viewTypeBG2.hidden = YES;
                areaTableView.hidden = YES;
                _labelArea2.hidden = YES;
            }
        }
    }
}

-(void)clickImage:(UITapGestureRecognizer *)reconginzer{
    typeTableView.hidden = YES;
    typeTableView2.hidden = YES;
    viewTypeBG.hidden = YES;
    viewTypeBG3.hidden = YES;
    areaTableView.hidden = YES;
    viewTypeBG2.hidden = YES;
    _labelArea2.hidden = YES;
}

- (void)addFooter2
{
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL, GROUPHOME_URL]];
    request_19 = [ASIFormDataRequest requestWithURL:url];
    [request_19 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request_19 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    [request_19 setPostValue:@"goods" forKey:@"type"];
    [request_19 setPostValue:[NSString stringWithFormat:@"%lu",(unsigned long)dataArr.count] forKey:@"begincount"];
    [request_19 setPostValue:@"10" forKey:@"selectcount"];
    
    [request_19 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_19.tag = 105;
    request_19.delegate = self;
    [request_19 setDidFailSelector:@selector(my5_urlRequestFailed:)];
    [request_19 setDidFinishSelector:@selector(my5_urlRequestSucceeded:)];
    [request_19 startAsynchronous];
    
}
-(void)my5_urlRequestSucceeded:(ASIFormDataRequest *)request{
    
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"21goods_dibBig-->>%@",dicBig);
        if (dicBig) {
            NSArray *array = [dicBig objectForKey:@"grouplist"];
            if (dataArrShangla.count != 0) {
                [dataArrShangla removeAllObjects];
            }
            for (NSDictionary *dic in array) {
                Model *shjm = [[Model alloc]init];
                shjm.gg_img = [dic objectForKey:@"gg_img"];
                shjm.gg_name = [dic objectForKey:@"gg_name"];
                shjm.gg_price = [dic objectForKey:@"gg_price"];
                shjm.gg_selled_count = [dic objectForKey:@"gg_selled_count"];
                shjm.gg_id = [dic objectForKey:@"id"];
                [dataArrShangla addObject:shjm];
            }
            [dataArr addObjectsFromArray:dataArrShangla];
            [goodCollectionView reloadData];
            
            [SYObject endLoading];
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [goodCollectionView reloadData];
        // 结束刷新
        [goodCollectionView footerEndRefreshing];
    });
}
-(void)my5_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
}
- (void)addFooter3
{
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL, GROUPHOME_URL]];
    request_20 = [ASIFormDataRequest requestWithURL:url];
    [request_20 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request_20 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    [request_20 setPostValue:@"life" forKey:@"type"];
    if([msg isEqualToString:@"不限"]){
        [request_20 setPostValue:@"" forKey:@"gc_id"];
    }else{
        [request_20 setPostValue:msg forKey:@"gc_id"];
    }
    if([msc isEqualToString:@"不限"]){
        [request_20 setPostValue:@"" forKey:@"gpr_id"];
    }else{
        [request_20 setPostValue:msc forKey:@"gpr_id"];
    }
    [request_20 setPostValue:[NSString stringWithFormat:@"%lu",(unsigned long)dataArr.count] forKey:@"begincount"];
    [request_20 setPostValue:@"10" forKey:@"selectcount"];
    
    [request_20 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_20.tag = 106;
    request_20.delegate = self;
    [request_20 setDidFailSelector:@selector(my6_urlRequestFailed:)];
    [request_20 setDidFinishSelector:@selector(my6_urlRequestSucceeded:)];
    [request_20 startAsynchronous];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
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
    
}
-(void)my6_urlRequestSucceeded:(ASIFormDataRequest *)request{
    
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"my6_urlRequestSucceeded3life_dibBig-->>%@",dicBig);
        if (dicBig) {
            NSArray *array = [dicBig objectForKey:@"grouplist"];
            if (dataArrShangla2.count != 0) {
                [dataArrShangla2 removeAllObjects];
            }
            for (NSDictionary *dic in array) {
                Model *shjm = [[Model alloc]init];
                shjm.gg_img = [dic objectForKey:@"gg_img"];
                shjm.gg_name = [dic objectForKey:@"gg_name"];
                shjm.gg_price = [dic objectForKey:@"gg_price"];
                shjm.gg_selled_count = [dic objectForKey:@"gg_selled_count"];
                shjm.gg_id = [dic objectForKey:@"id"];
                [dataArrShangla2 addObject:shjm];
            }
            [dataArr addObjectsFromArray:dataArrShangla2];
            [lifeCollectionView reloadData];
            [SYObject endLoading];
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [lifeCollectionView reloadData];
        // 结束刷新
        [lifeCollectionView footerEndRefreshing];
    });
}
-(void)my6_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
}

#pragma mark - 用户信息调用
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

-(void)createBackBtn{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
    button.frame =CGRectMake(0, 0, 44, 44);
    [button setBackgroundImage:[UIImage imageNamed:@"back_lj"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font  = [UIFont systemFontOfSize:14];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = bar;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
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