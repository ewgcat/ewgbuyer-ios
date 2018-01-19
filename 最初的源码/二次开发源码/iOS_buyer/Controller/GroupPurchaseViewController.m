//
//  GroupPurchaseViewController.m
//  
//
//  Created by apple on 15/10/21.
//
//

#import "GroupPurchaseViewController.h"
#import "GroupPurchaseTableViewCell.h"
#import "ConditionTableViewCell.h"
#import "SearchViewController.h"
#import "PositionViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AreaModel.h"
#import "GroupModel.h"
#import "Model.h"
#import "SecondViewController.h"
#import "DetailViewController.h"
#import "GroupPurcheasTableViewController.h"

@interface GroupPurchaseViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,PostitionViewDelegate,UIGestureRecognizerDelegate>
{
    __weak IBOutlet UIView *noHaveView;
//    UIImageView *optionImageview;
    UIView *optionBg;
    
    NSMutableArray *dataArray;
    UITableView *tableview;
    UILabel *headerLabel;
   
    UIView *areaView;
    NSMutableArray *areaArray;
    UITableView *areaTableview;
   
    UIView *classifyView;
    NSMutableArray *classifyArray;
    UITableView *classifyTableview;
    NSMutableArray *classifyArray1;
    UITableView *classifyTableview1;
    
    UIView *priceView;
    NSMutableArray *priceArray;
    UITableView *priceTableview;
    
    __weak IBOutlet UIView *longv;
  
    
    CLLocationManager *_manager;//定位
    AreaModel *locationCity;
    
    NSMutableString *colng; //经度
    NSMutableString *colat; //纬度
    NSMutableString *gaiId; //常用地区 用户下拉选择详细地址之后产生的
    NSMutableString *gcId;  //分类的Id
    NSMutableString *rderBy;// 0:按照距离排序     1:按照销量排序  2:按照价格排序
    int count;
    UILabel *labelTi;
    
    
}

//@property (nonatomic, strong)NSMutableString *gcId;

@end

@implementation GroupPurchaseViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }

    
//    dataArray = [NSMutableArray array];
//    areaArray = [NSMutableArray array];
//    classifyArray = [NSMutableArray array];
//    classifyArray1 = [NSMutableArray array];
//    priceArray = [NSMutableArray array];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    locationCity=[[AreaModel alloc]init];
    colng=[[NSMutableString alloc]init];
    colat=[[NSMutableString alloc]init];
    gaiId=[[NSMutableString alloc]init];
    gcId=[[NSMutableString alloc]init];
    rderBy=[[NSMutableString alloc]init];
    
    count=1;
    [self createNavigation];
    [self designPage];
    [self getCoreLocation];
//    [self getGroupIndex:rderBy andorderType:@"" andGcId:self.gcId andGprId:@"" andGaId:@"" andGaiId:gaiId andType:@"" andBegincount:@"0" andSelectcount:@"10" andLng:colng andLat:colat andCityId:locationCity.areaID];
}
#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1){  //关闭主界面的右滑返回
        return NO;
    }else{
        
        return YES;
    }
}
#pragma mark -上拉刷新、下拉加载
-(void)headerRereshing{
//    [self getGroupIndex:rderBy andorderType:@"" andGcId:self.gcId andGprId:@"" andGaId:@"" andGaiId:gaiId andType:@"" andBegincount:@"0" andSelectcount:@"10" andLng:colng andLat:colat andCityId:locationCity.areaID];
    [self getGroupIndex:rderBy andorderType:@"" andGcId:gcId andBegincount:@"0" andSelectcount:@"10" andLng:colng andLat:colat andCityId:locationCity.areaID andGaiId:gaiId];
    [tableview headerEndRefreshing];
}
-(void)footerRereshing{
    count ++;
//    [self getGroupIndex:rderBy andorderType:@"" andGcId:self.gcId andGprId:@"" andGaId:@"" andGaiId:gaiId andType:@"" andBegincount:@"0" andSelectcount:[NSString stringWithFormat:@"%d",10*count] andLng:colng andLat:colat andCityId:locationCity.areaID];
     [self getGroupIndex:rderBy andorderType:@"" andGcId:gcId andBegincount:@"0" andSelectcount:[NSString stringWithFormat:@"%d",10*count] andLng:colng andLat:colat andCityId:locationCity.areaID andGaiId:gaiId];
    [tableview footerEndRefreshing];
}
#pragma mark -界面
-(void)createNavigation{
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0Xdf0000);
    //标题
    UILabel *titleLabel=[LJControl labelFrame:CGRectMake(0, 0, 100, 40) setText:@"团购" setTitleFont:20 setbackgroundColor:[UIColor clearColor] setTextColor: [UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    self.navigationItem.titleView=titleLabel;

    //返回按钮
    UIButton *backButton = [LJControl backBtn];
    backButton.tag=1000;
    [backButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem =bar;
    
    //定位按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
    button.frame =CGRectMake(0, 0, 25, 25);
    [button setBackgroundImage:[UIImage imageNamed:@"positionNew.png"] forState:UIControlStateNormal];
    button.tag=1002;
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar3 = [[UIBarButtonItem alloc]initWithCustomView:button];
  
    self.navigationItem.rightBarButtonItem = bar3;
}
-(void)designPage{
    self.view.backgroundColor=UIColorFromRGB(0Xf0f0f0);
    //暂无团购
    UIImageView *noDataImage=[LJControl imageViewFrame:CGRectMake(ScreenFrame.size.width/2-131,0, 263,263) setImage:@"seller_center_nothing.png" setbackgroundColor:[UIColor clearColor]];
    [noHaveView addSubview:noDataImage];
     noDataImage.frame = CGRectMake(100.f/568.f*ScreenFrame.size.height, 80.f/568.f*ScreenFrame.size.height, 0.5*314.f/568.f*ScreenFrame.size.height, 0.5*314.f/568.f*ScreenFrame.size.height);
    noHaveView.hidden=YES;
    //加载圆圈
    UIView *la=[LJControl viewFrame:CGRectMake(ScreenFrame.size.width/2-50, 80, 100, 100) backgroundColor:[UIColor blackColor]];
    la.alpha=0.8;
    [la.layer setCornerRadius:8.0];
    [la.layer setMasksToBounds:YES];
    longv.hidden=YES;
    
    //条件
    UIView *bgView=[LJControl viewFrame:CGRectMake(0,0,ScreenFrame.size.width,44) backgroundColor:UIColorFromRGB(0xfdfdfd)];
    //上灰线
    UILabel*bl=[LJControl labelFrame:CGRectMake(0,0,ScreenFrame.size.width, 0.5) setText:@"" setTitleFont:0 setbackgroundColor:UIColorFromRGB(0Xdcdcdc) setTextColor:nil textAlignment:NSTextAlignmentCenter];
    [bgView addSubview:bl];
    //下灰线
    UILabel*bll=[LJControl labelFrame:CGRectMake(0,bgView.bounds.size.height-0.5,ScreenFrame.size.width, 0.5) setText:@"" setTitleFont:0 setbackgroundColor:UIColorFromRGB(0Xdcdcdc) setTextColor:nil textAlignment:NSTextAlignmentCenter];
    [bgView addSubview:bll];
    
    //两条竖线
    UILabel*l=[LJControl labelFrame:CGRectMake(ScreenFrame.size.width/3-1, 7, 1, 30) setText:@"" setTitleFont:0 setbackgroundColor:UIColorFromRGB(0Xe6e6e6) setTextColor:nil textAlignment:NSTextAlignmentCenter];
    [bgView addSubview:l];
    UILabel*ll=[LJControl labelFrame:CGRectMake(ScreenFrame.size.width/3*2-1, 7, 1, 30) setText:@"" setTitleFont:0 setbackgroundColor:UIColorFromRGB(0Xe6e6e6) setTextColor:nil textAlignment:NSTextAlignmentCenter];
    [bgView addSubview:ll];
    
    NSArray *labeArr=@[@"地区",@"分类",@"排序"];
    for (int i=0; i<3; i++) {
        UIButton *button=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(ScreenFrame.size.width/3*i+5, 7, ScreenFrame.size.width/3-10, 30) setNormalImage:nil setSelectedImage:nil setTitle:@"" setTitleFont:0 setbackgroundColor:[UIColor clearColor]];
        button.tag=1003+i;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label=[LJControl labelFrame:CGRectMake(0, 0, button.bounds.size.width, button.bounds.size.height) setText:[labeArr objectAtIndex:i] setTitleFont:13 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0X505050) textAlignment:NSTextAlignmentCenter];
        label.tag=100+i;
        [button addSubview:label];
        
        UIImageView *image=[LJControl imageViewFrame:CGRectMake(label.width-6, label.height-6, 6, 6) setImage:@"sydownarrow.png" setbackgroundColor:[UIColor clearColor]];
        [label addSubview:image];
        [bgView addSubview:button];
        
        
    }
    [self.view addSubview:bgView];
   
    //tableview
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0,44, ScreenFrame.size.width, ScreenFrame.size.height-64-44) style:UITableViewStyleGrouped];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.delegate=self;
    tableview.dataSource=self;
    [tableview addHeaderWithTarget:self action:@selector(headerRereshing)];
    [tableview addFooterWithTarget:self action:@selector(footerRereshing)];
    [self.view addSubview:tableview];
    
    //弹出下拉
    optionBg=[LJControl viewFrame:CGRectMake(0, 44,ScreenFrame.size.width, ScreenFrame.size.height-44) backgroundColor:[UIColor clearColor]];
    optionBg.hidden=YES;
    optionBg.userInteractionEnabled=YES;
    [self.view addSubview:optionBg];
   
    
    //地区
    areaView=[LJControl viewFrame:CGRectMake(0,0, ScreenFrame.size.width,ScreenFrame.size.height-44-64) backgroundColor:[UIColor whiteColor]];
    areaTableview=[[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenFrame.size.width,ScreenFrame.size.height-44-64) style:UITableViewStylePlain];
    areaTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    areaTableview.delegate=self;
    areaTableview.dataSource=self;
    [areaView addSubview:areaTableview];
    areaView.hidden=YES;
    [optionBg addSubview:areaView];
    
    //分类
    classifyView=[LJControl viewFrame:CGRectMake(0,0, ScreenFrame.size.width,ScreenFrame.size.height-44) backgroundColor:[UIColor whiteColor]];
    classifyTableview=[[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenFrame.size.width/2,ScreenFrame.size.height-44) style:UITableViewStylePlain];
    classifyTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    classifyTableview.delegate=self;
    classifyTableview.dataSource=self;
    [classifyView addSubview:classifyTableview];
    
    classifyTableview1=[[UITableView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width/2,0, ScreenFrame.size.width/2,ScreenFrame.size.height-44) style:UITableViewStylePlain];
    classifyTableview1.separatorStyle = UITableViewCellSeparatorStyleNone;
    classifyTableview1.delegate=self;
    classifyTableview1.dataSource=self;
    classifyTableview1.backgroundColor=UIColorFromRGB(0Xeaeaea);
    [classifyView addSubview:classifyTableview1];

    classifyView.hidden=YES;
    [optionBg addSubview:classifyView];
    
    //价格
    priceView=[LJControl viewFrame:CGRectMake(0,0, ScreenFrame.size.width,ScreenFrame.size.height-44) backgroundColor:[UIColor whiteColor]];
    priceTableview=[[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenFrame.size.width,ScreenFrame.size.height-44) style:UITableViewStylePlain];
    priceTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    priceTableview.delegate=self;
    priceTableview.dataSource=self;
    [priceView addSubview:priceTableview];
    priceView.hidden=YES;
    [optionBg addSubview:priceView];
    
    //提示
    labelTi = [[UILabel alloc]initWithFrame:CGRectMake(30, ScreenFrame.size.height-160, ScreenFrame.size.width-60, 30)];
    [labelTi.layer setMasksToBounds:YES];
    [labelTi.layer setCornerRadius:4.0];
    labelTi.textAlignment = NSTextAlignmentCenter;
    labelTi.backgroundColor = [UIColor blackColor];
    labelTi.alpha = 0.8;
    [self.view addSubview:labelTi];
    labelTi.hidden = YES;
    labelTi.textColor = [UIColor whiteColor];
}
-(void)buttonClicked:(UIButton *)btn{
    NSLog(@"%ld",(long)btn.tag);
    if (btn.tag==1000) {
        //返回
        [self.navigationController popViewControllerAnimated:YES];
    }else if (btn.tag==1001){
        //搜索
        SearchViewController *ordrt = [[SearchViewController alloc]init];;
        [self.navigationController pushViewController:ordrt animated:YES];
    }else if (btn.tag==1002){
        //地址
        PositionViewController *ordrt = [[PositionViewController alloc]init];
        ordrt.delegate=self;
        [self.navigationController pushViewController:ordrt animated:YES];
    }else if (btn.tag==1003){
        //地区
        [self getAreaByCity:locationCity];
        areaView.hidden=NO;
        [self.view bringSubviewToFront:areaView];
        classifyView.hidden=YES;
        priceView.hidden=YES;
        noHaveView.hidden=YES;
        btn.selected=!btn.selected;
        if (btn.selected) {
            optionBg.hidden=NO;
        }else{
            optionBg.hidden=YES;
        }
        
    }else if (btn.tag==1004){
        //分类
        [self getGroupClass];
        areaView.hidden=YES;
        classifyView.hidden=NO;
        [self.view bringSubviewToFront:classifyView];
        priceView.hidden=YES;
        noHaveView.hidden=YES;
        btn.selected=!btn.selected;
        if (btn.selected) {
            optionBg.hidden=NO;
        }else{
            optionBg.hidden=YES;
        }

    }else if (btn.tag==1005){
        //价格
        [self getGroupPrice];
        areaView.hidden=YES;
        classifyView.hidden=YES;
        priceView.hidden=NO;
        [self.view bringSubviewToFront:priceView];
        noHaveView.hidden=YES;
        btn.selected=!btn.selected;
        if (btn.selected) {
            optionBg.hidden=NO;
        }else{
            optionBg.hidden=YES;

        }

    }else if (btn.tag==1006){
        //刷新
        [self getCoreLocation];
    }
}
-(void)tapClick{
    for (int i=0; i<3; i++) {
        UIButton *btn=(UIButton *)[self.view viewWithTag:1003+i];
        btn.selected=NO;
        
    }
    optionBg.hidden=YES;
}
#pragma mark -数据
-(void)getAreaByGgrphy:(NSString *)lat andLongitude:(NSString *)lng{
    [SYObject startLoading];
    NSString *urlstr=[NSString stringWithFormat:@"%@%@?lat=%@&lng=%@",FIRST_URL,AREA_BYGGRPHY_URL,lat,lng];
    NSURL *url=[NSURL URLWithString:urlstr];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    request.tag=1000;
    request.delegate=self;
    [request startAsynchronous];
}
-(void)getAreaByCity:(AreaModel *)model{
    [SYObject startLoading];
    NSString *urlstr=[NSString stringWithFormat:@"%@%@?cityId=%@",FIRST_URL,AREABYCITY,model.areaID];
    NSURL *url=[NSURL URLWithString:urlstr];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    request.tag=1001;
    request.delegate=self;
    [request startAsynchronous];
}
-(void)getGroupClass{
    [SYObject startLoading];
    NSString *urlstr=[NSString stringWithFormat:@"%@%@?type=life",FIRST_URL,GROUP_CLASS_URL];
    NSURL *url=[NSURL URLWithString:urlstr];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    request.tag=1002;
    request.delegate=self;
    [request startAsynchronous];
}
-(void)getNextClass:(NSString *)ClassId{
    [SYObject startLoading];
    NSString *urlstr=[NSString stringWithFormat:@"%@%@?id=%@",FIRST_URL,NEXT_CLASS_URL,ClassId];
    NSURL *url=[NSURL URLWithString:urlstr];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    request.tag=1003;
    request.delegate=self;
    [request startAsynchronous];
}
-(void)getGroupPrice{
   NSArray * nArray=@[@"全部",@"离我最近",@"人气最高",@"经济实惠"];
    NSArray *iArray=@[@"-1",@"0",@"1",@"2"];
    priceArray=[[NSMutableArray alloc]init];
    for (int i=0; i<nArray.count; i++) {
        AreaModel *model=[[AreaModel alloc]init];
        model.areaID=[iArray objectAtIndex:i];
        model.areaName=[nArray objectAtIndex:i];
        [priceArray addObject:model];
    }
    [priceTableview reloadData];
}
-(void)getGroupIndex:(NSString *)orderBy andorderType:(NSString *)orderType andGcId:(NSString *)gc_id andBegincount:(NSString *)begincount andSelectcount:(NSString *)selectcount andLng:(NSString *)lng andLat:(NSString *)lat andCityId:(NSString *)cityId andGaiId:(NSString *)gai_id{
    [SYObject startLoading];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,GROUP_INDEX_URL]];
    ASIFormDataRequest * request=[ASIFormDataRequest requestWithURL:url];
    request.tag=1004;
    [request setPostValue:orderBy forKey:@"orderBy"];
    [request setPostValue:orderType forKey:@"orderType"];
    [request setPostValue:gc_id forKey:@"gc_id"];
    [request setPostValue:@"life" forKey:@"type"];
    [request setPostValue:begincount forKey:@"begincount"];
    [request setPostValue:selectcount forKey:@"selectcount"];
    [request setPostValue:lng forKey:@"lng"];
    [request setPostValue:lat forKey:@"lat"];
    if ([gai_id isEqualToString:@""]||[gai_id isEqualToString:@"-1"]) {
        [request setPostValue:cityId forKey:@"cityId"];
    }else{
        [request setPostValue:gai_id forKey:@"cityId"];
    }
    [request setRequestHeaders:[LJControl requestHeaderDictionary]];
    [request setDelegate:self];
    [request startAsynchronous];
    
}
#pragma mark- ASIHTTPRequestDelegate
-(void)requestFinished:(ASIHTTPRequest *)request{
    NSError *error = nil;
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:&error];
    NSLog(@"搜索结果====%@",dic);
    if (request.tag==1000) {
        if ([[dic objectForKey:@"code"]integerValue]==200) {
            NSDictionary *dict=[dic objectForKey:@"result"];
            locationCity.areaName=[dict objectForKey:@"areaName"];
            locationCity.areaID=[dict objectForKey:@"areaId"];
            [self getGroupIndex:rderBy andorderType:@"" andGcId:@"" andBegincount:@"0" andSelectcount:@"10" andLng:colng andLat:colat andCityId:locationCity.areaID andGaiId:@""];
            
        }else if ([[dic objectForKey:@"code"]integerValue]==404) {
            locationCity.areaName=@"无法获得准确地理信息";
            locationCity.areaID=@"";
            [SYObject endLoading];
            noHaveView.hidden=NO;
            labelTi.hidden = NO;
            [self.view bringSubviewToFront:labelTi];
            labelTi.text = @"无法准确定位！请手动选择地理信息";
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
        }
    }else if (request.tag==1001){
        if ([[dic objectForKey:@"code"]integerValue]==200) {
            areaArray=[[NSMutableArray alloc]init];
            for (NSDictionary *dict in [dic objectForKey:@"result"]) {
                AreaModel *model=[[AreaModel alloc]init];
                model.areaID=[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
                model.areaName=[dict objectForKey:@"areaName"];
                [areaArray addObject:model];
            }
            NSLog(@"团购地区个数。。。。%lu",(unsigned long)areaArray.count);
            [areaTableview reloadData];
        }
    }else if (request.tag==1002){
        if (dic) {
            classifyArray=[[NSMutableArray alloc]init];
            NSDictionary *dict=[dic objectForKey:@"result"];
            for (NSDictionary *dictt in [dict objectForKey:@"gc_life"]) {
                AreaModel *model=[[AreaModel alloc]init];
                model.areaName=[dictt objectForKey:@"name"];
                model.areaID=[NSString stringWithFormat:@"%@",[dictt objectForKey:@"id"]];
                [classifyArray addObject:model];
            }
            [classifyTableview reloadData];
            //全部
            AreaModel *m=[classifyArray firstObject];
            [self getNextClass:m.areaID];
        }
    }else if (request.tag==1003){
        if (dic) {
            classifyArray1=[[NSMutableArray alloc]init];
            for (NSDictionary *dictt in [dic objectForKey:@"result"]) {
                AreaModel *model=[[AreaModel alloc]init];
                model.areaName=[dictt objectForKey:@"name"];
                model.areaID=[NSString stringWithFormat:@"%@",[dictt objectForKey:@"id"]];
                [classifyArray1 addObject:model];
            }
            [classifyTableview1 reloadData];
        }
    }else if (request.tag==1004){
        if (dic) {
            dataArray=[[NSMutableArray alloc]init];
            for (NSDictionary *dictt in [dic objectForKey:@"grouplist"]) {
                GroupModel *model=[[GroupModel alloc]init];
                model.gg_img=[dictt objectForKey:@"gg_img"];
                model.gg_name=[dictt objectForKey:@"gg_name"];
                model.gg_price=[dictt objectForKey:@"gg_price"];
                model.gg_selled_count=[dictt objectForKey:@"gg_selled_count"];
                model.gg_id=[NSString stringWithFormat:@"%@",[dictt objectForKey:@"id"]];
                [dataArray addObject:model];
            }
            if (dataArray.count>0) {
                tableview.hidden=NO;
                noHaveView.hidden=YES;
                [SYObject endLoading];
                [tableview reloadData];
            }else{
                tableview.hidden=YES;
                noHaveView.hidden=NO;
                [SYObject endLoading];
            }
        }
    }
    [SYObject endLoading];
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"请求错误");
    [SYObject endLoading];
    labelTi.hidden = NO;
    [self.view bringSubviewToFront:labelTi];
    labelTi.text = @"网络在开小差，请检查后再试吧！";
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];

}
-(void)doTimer{
    labelTi.hidden = YES;
}

#pragma mark- UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:tableview]) {
        return  dataArray.count;
    }else if ([tableView isEqual:areaTableview]) {
        return  areaArray.count;
    }else if ([tableView isEqual:classifyTableview]) {
        return  classifyArray.count;
    }else if ([tableView isEqual:classifyTableview1]) {
        return  classifyArray1.count;
    }else if ([tableView isEqual:priceTableview]) {
        return  priceArray.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:tableview]) {
        return  89;
    }else if ([tableView isEqual:areaTableview]) {
        return  30;
    }else if ([tableView isEqual:classifyTableview]) {
        return  30;
    }else if ([tableView isEqual:classifyTableview1]) {
        return  30;
    }else if ([tableView isEqual:priceTableview]) {
        return  30;
    }

    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([tableView isEqual:tableview]) {
        UIView *headerView=[LJControl viewFrame:CGRectMake(0, 0,ScreenFrame.size.width, 40) backgroundColor:UIColorFromRGB(0Xefefef)];
        UIView *view=[LJControl viewFrame:CGRectMake(0, headerView.bottom, ScreenFrame.size.width, 0.5) backgroundColor:UIColorFromRGB(0xe2e2e2)];
        [headerView addSubview:view];
        //显示定位城市
        headerLabel=[LJControl labelFrame:CGRectMake(10, 10, ScreenFrame.size.width-20-30, 20) setText:[NSString stringWithFormat:@"当前城市: %@",locationCity.areaName] setTitleFont:12 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0X999999) textAlignment:NSTextAlignmentLeft];
        [headerView addSubview:headerLabel];
        UIButton *but=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(ScreenFrame.size.width-20, 13, 14, 14) setNormalImage:[UIImage imageNamed:@"refresh.png"] setSelectedImage:nil setTitle:@"" setTitleFont:0 setbackgroundColor:[UIColor clearColor]];
        but.tag=1006;
        [but addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:but];
        return headerView;
    }else{
        UIView *headerView=[LJControl viewFrame:CGRectMake(0, 0,0, 0) backgroundColor:[UIColor clearColor]];
        return headerView;
    
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([tableView isEqual:tableview]) {
        return  40;
    }else {
        return 0.0001;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:tableview]) {
        static NSString *myTabelviewCell = @"GroupPurchaseTableViewCell";
        GroupPurchaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"GroupPurchaseTableViewCell" owner:self options:nil] lastObject];
         
        }
        GroupModel *model=[dataArray objectAtIndex:indexPath.row];
        cell.model=model;
        return cell;
    }else if ([tableView isEqual:areaTableview]) {
        static NSString *myTabelviewCell = @"ConditionTableViewCell1";
        ConditionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ConditionTableViewCell" owner:self options:nil] lastObject];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
        }
        AreaModel *model=[areaArray objectAtIndex:indexPath.row];
        cell.model=model;
        return cell;
    }else if ([tableView isEqual:classifyTableview]) {
        static NSString *cellName = @"cellId";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
        }
        AreaModel *model=[classifyArray objectAtIndex:indexPath.row];
        cell.textLabel.text=model.areaName;
        cell.textLabel.textColor=UIColorFromRGB(0X989898);
        return cell;
    }else if ([tableView isEqual:classifyTableview1]) {
        static NSString *myTabelviewCell = @"ConditionTableViewCell2";
        ConditionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ConditionTableViewCell" owner:self options:nil] lastObject];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
        }
        AreaModel *model=[classifyArray1 objectAtIndex:indexPath.row];
        cell.model=model;
        return cell;
    }else if ([tableView isEqual:priceTableview]) {
        static NSString *myTabelviewCell = @"ConditionTableViewCell3";
        ConditionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ConditionTableViewCell" owner:self options:nil] lastObject];
             cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
        }
        AreaModel *model=[priceArray objectAtIndex:indexPath.row];
        cell.model=model;
        return cell;
    }

    return nil;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:tableview]) {
        GroupModel *model=[dataArray objectAtIndex:indexPath.row];
        //商品详情
        Model *shjM=[[Model alloc]init];
        shjM.big_photo=model.gg_img;
        shjM.good_price=model.gg_price;
        shjM.goodsId=model.gg_id;
        shjM.name=model.gg_name;
        SecondViewController *sec = [SecondViewController sharedUserDefault];
        sec.detail_id = shjM.goodsId;
        //DetailViewController *dVC = [[DetailViewController alloc]init];
        //[self.navigationController pushViewController:dVC animated:YES];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"GroupPurchaseDetailStoryboard" bundle:nil];
        GroupPurcheasTableViewController *detailTVC = [sb instantiateViewControllerWithIdentifier:@"GroupPurchaseDetails"];
        detailTVC.group_id=model.gg_id;
        [self.navigationController pushViewController:detailTVC animated:YES];

    }else if ([tableView isEqual:areaTableview]) {
        AreaModel *model=[areaArray objectAtIndex:indexPath.row];
        [gaiId setString:model.areaID];
        //headerLabel.text=[NSString stringWithFormat:@"%@-%@",locationCity.areaName,model.areaName];
        [self getGroupIndex:rderBy andorderType:@"" andGcId:gcId andBegincount:@"0" andSelectcount:@"20" andLng:colng andLat:colat andCityId:locationCity.areaID andGaiId:gaiId];
        UILabel *lab=(UILabel *)[self.view viewWithTag:100];
        lab.text=model.areaName;
        [tableView reloadData];
        [self tapClick];
    }else if ([tableView isEqual:classifyTableview]) {
         UITableViewCell *cell = [classifyTableview cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor=UIColorFromRGB(0X4c4c4c);
        AreaModel *model=[classifyArray objectAtIndex:indexPath.row];
        UILabel *lab=(UILabel *)[self.view viewWithTag:101];
        lab.text=model.areaName;
        if ([model.areaID intValue]==-1) {
            [gcId setString:@""];
            [self getGroupIndex:rderBy andorderType:@"" andGcId:gcId andBegincount:@"0" andSelectcount:@"10" andLng:colng andLat:colat andCityId:locationCity.areaID andGaiId:gaiId];
            [self tapClick];
        }else{
            [self getNextClass:model.areaID];
        }
    }else if ([tableView isEqual:classifyTableview1]) {
        AreaModel *model=[classifyArray1 objectAtIndex:indexPath.row];
        [gcId setString:model.areaID];
        UILabel *lab=(UILabel *)[self.view viewWithTag:101];
        lab.text=model.areaName;
        [self getGroupIndex:rderBy andorderType:@"" andGcId:gcId andBegincount:@"0" andSelectcount:@"10" andLng:colng andLat:colat andCityId:locationCity.areaID andGaiId:gaiId];
        [self tapClick];
    }else if ([tableView isEqual:priceTableview]) {
        AreaModel *model=[priceArray objectAtIndex:indexPath.row];
        [rderBy setString:model.areaID];
        [self getGroupIndex:rderBy andorderType:@"" andGcId:gcId andBegincount:@"0" andSelectcount:@"10" andLng:colng andLat:colat andCityId:locationCity.areaID andGaiId:gaiId];
        [self tapClick];
        UILabel *lab=(UILabel *)[self.view viewWithTag:102];
        lab.text=model.areaName;
    }

    
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:classifyTableview]) {
        UITableViewCell *cell = [classifyTableview cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor=UIColorFromRGB(0X989898);
    }
}
#pragma mark -PostitionViewDelegate
-(void)ChangedLocationCity:(AreaModel *)model{
    locationCity.areaName=model.areaName;
    locationCity.areaID=model.areaID;
    [rderBy setString:@""];
    [gcId setString:@""];
    [colng setString:@""];
    [colat setString:@""];
    [gaiId setString:@""];
    NSArray *labeArr=@[@"地区",@"分类",@"排序"];
    for (int i=0; i<3; i++) {
        UIButton *button=(UIButton *)[self.view viewWithTag:1003+i];
        button.selected=NO;
        UILabel *lab=(UILabel *)[self.view viewWithTag:100+i];
        lab.text=labeArr[i];
    }
    [tableview reloadData];
    [self getGroupIndex:@"" andorderType:@"" andGcId:@"" andBegincount:@"0" andSelectcount:@"10" andLng:@"" andLat:@"" andCityId:locationCity.areaID andGaiId:@""];
}

#pragma mark -定位
- (void)getCoreLocation{
//    longv.hidden=YES;
    [SYObject endLoading];
    _manager=[[CLLocationManager alloc]init];
    _manager.delegate=self;
    
    [_manager requestAlwaysAuthorization];
    [_manager requestWhenInUseAuthorization];
    
    // 设置定位精度
    // kCLLocationAccuracyNearestTenMeters:精度10米
    // kCLLocationAccuracyHundredMeters:精度100 米
    // kCLLocationAccuracyKilometer:精度1000 米
    // kCLLocationAccuracyThreeKilometers:精度3000米
    // kCLLocationAccuracyBest:设备使用电池供电时候最高的精度
    // kCLLocationAccuracyBestForNavigation:导航情况下最高精度，一般要有外接电源时才能使用
    _manager.desiredAccuracy = kCLLocationAccuracyBest;
    //有的时候我们不需要频繁获得数据，比如高速行驶的时候 如果不设置间隔，会频繁的调用GPS，造成耗费电量
    _manager.distanceFilter = 1000.0f;
    
    //开启定位
    [_manager startUpdatingLocation];
    
}
//新定位方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *newLocation=[locations lastObject];
    NSLog(@"%f~~~~%f",newLocation.coordinate.longitude,newLocation.coordinate.latitude);
    [colat setString:[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude ]];
    [colng setString:[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude]];
    
    [self getAreaByGgrphy:[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude] andLongitude:[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude]];
    [_manager stopUpdatingLocation];
}
//定位失败
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
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
