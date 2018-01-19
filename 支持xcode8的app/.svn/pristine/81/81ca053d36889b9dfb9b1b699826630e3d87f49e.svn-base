//
//  PositionViewController.m
//  
//
//  Created by apple on 15/10/21.
//
//

#import "PositionViewController.h"
#import "DemoSectionItemSubclass.h"
#import "PositionsCell.h"
#import "AreaModel.h"
#import <CoreLocation/CoreLocation.h>
@interface PositionViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchResultsUpdating,CLLocationManagerDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray *dataArray;
    NSMutableArray *resultArray;
    UITableView *tableview;
    NSMutableArray *letterMarray;
    CLLocationManager *_manager;//定位
    AreaModel *locationCity;
    UISearchController *searchC;
//    __weak IBOutlet UIView *longv;
     UILabel *labelTi;
}
@end

@implementation PositionViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    [self getCoreLocation];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (searchC.active) {
        searchC.active = NO;
        [searchC.searchBar removeFromSuperview];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    locationCity=[[AreaModel alloc]init];
    resultArray=[[NSMutableArray alloc]init];
    [self designPage];
    [self createNavigation];
    [self getAreaIndex];
   
}
#pragma mark -数据
-(void)getAreaIndex{
//    longv.hidden=NO;
    [SYObject startLoading];
    NSString *urlstr=[NSString stringWithFormat:@"%@%@",FIRST_URL,CITY_AREA_URL];
    NSURL *url=[NSURL URLWithString:urlstr];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    request.tag=1000;
    request.delegate=self;
    [request startAsynchronous];
}
-(void)getAreaByGgrphy:(NSString *)lat andLongitude:(NSString *)lng{
//    longv.hidden=NO;
    [SYObject startLoading];
    NSString *urlstr=[NSString stringWithFormat:@"%@%@?lat=%@&lng=%@",FIRST_URL,AREA_BYGGRPHY_URL,lat,lng];
    NSURL *url=[NSURL URLWithString:urlstr];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    request.tag=1001;
    request.delegate=self;
    [request startAsynchronous];
}
#pragma mark- ASIHTTPRequestDelegate
-(void)requestFinished:(ASIHTTPRequest *)request{
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
    if (request.tag==1000) {
        NSLog(@"0%@",dic);
        letterMarray=[[NSMutableArray alloc]init];
        [letterMarray addObject:@"当前定位信息"];
        dataArray=[[NSMutableArray alloc]init];
        NSMutableArray *mArr=[[NSMutableArray alloc]init];
        [dataArray addObject:mArr];
        for (NSDictionary *dict in [dic objectForKey:@"area_list"]) {
            [letterMarray addObject:[dict objectForKey:@"word"]];
             NSMutableArray *mArray=[[NSMutableArray alloc]init];
            for (NSDictionary *dictt in [dict objectForKey:@"area_list"]) {
                AreaModel *model=[[AreaModel alloc]init];
                model.areaName=[dictt objectForKey:@"areaName"];
                model.areaID=[dictt objectForKey:@"id"];
                [mArray addObject:model];
            }
      
            [dataArray addObject:mArray];
        }
       
    [tableview reloadData];
    }else if (request.tag==1001) {
        NSLog(@"1%@",dic);
        if ([[dic objectForKey:@"code"]integerValue]==200) {
            NSDictionary *dict=[dic objectForKey:@"result"];
            locationCity.areaName=[dict objectForKey:@"areaName"];
            locationCity.areaID=[dict objectForKey:@"areaId"];
            [tableview reloadData];
        }else if ([[dic objectForKey:@"code"]integerValue]==404) {
            locationCity.areaName=@"无法获得准确地理信息";
            locationCity.areaID=@"";
//            longv.hidden=YES;
            [SYObject endLoading];
            labelTi.hidden = NO;
            [self.view bringSubviewToFront:labelTi];
            labelTi.text = @"无法获得准确地理信息";
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
        }
    }else if (request.tag==1002) {
        NSLog(@"2%@",dic);
    }
//    longv.hidden=YES;
    [SYObject endLoading];
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"请求错误");
//    longv.hidden=YES;
    [SYObject endLoading];
    labelTi.hidden = NO;
    [self.view bringSubviewToFront:labelTi];
    labelTi.text = @"网络在开小差，请检查后再试吧！";
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
    
}
-(void)doTimer{
    labelTi.hidden = YES;
}

#pragma mark -界面
-(void)createNavigation{
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0Xdf0000);
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    UILabel *titleLabel=[LJControl labelFrame:CGRectMake(0, 0, 100, 40) setText:@"选择城市" setTitleFont:20 setbackgroundColor:[UIColor clearColor] setTextColor: [UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    self.navigationItem.titleView=titleLabel;
    
    UIButton *backButton = [LJControl backBtn];
    backButton.tag=1000;
    [backButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem =bar;
    
}
-(void)designPage{
    self.view.backgroundColor=UIColorFromRGB(0Xf0f0f0);
    
    //加载圆圈
    UIView *la=[LJControl viewFrame:CGRectMake(ScreenFrame.size.width/2-50, 80, 100, 100) backgroundColor:[UIColor       blackColor]];
    la.alpha=0.8;
    [la.layer setCornerRadius:8.0];
    [la.layer setMasksToBounds:YES];
//    
//    UIActivityIndicatorView *testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    [testActivityIndicator setFrame:CGRectMake(0, 0,44, 44)];
//    testActivityIndicator.center = CGPointMake(50.0f, 40.0f);//只能设置中心，不能设置大小
//    //[testActivityIndicator setFrame = CGRectMack(100, 100, 100, 100)];//不建议这样设置，因为UIActivityIndicatorView是不能改变大小只能改变位置，这样设置得到的结果是控件的中心在（100，100）上，而不是和其他控件的frame一样左上角在（100， 100）长为100，宽为100.
//    [la addSubview:testActivityIndicator];
//    testActivityIndicator.color = [UIColor whiteColor]; // 改变圈圈的颜色为红色； iOS5引入
//    [testActivityIndicator startAnimating]; // 开始旋转
//    //[testActivityIndicator stopAnimating]; // 结束旋转
//    //[testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
//    UILabel *label=[LJControl labelFrame:CGRectMake(0, 80, 100,20) setText:@"正在加载....." setTitleFont:14 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
//    [la addSubview:label];
//    [longv addSubview:la];
//    longv.hidden=YES;

    //tableview
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenFrame.size.width, ScreenFrame.size.height-64) style:UITableViewStyleGrouped];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.delegate=self;
    tableview.dataSource=self;
    //搜索栏
    searchC = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchC.searchResultsUpdater = self;
    searchC.dimsBackgroundDuringPresentation = NO;
    searchC.hidesNavigationBarDuringPresentation = NO;
    searchC.searchBar.frame = CGRectMake(searchC.searchBar.frame.origin.x,searchC.searchBar.frame.origin.y, searchC.searchBar.frame.size.width, 44.0);
    if(ScreenFrame.size.height<=480){
        tableview.tableHeaderView = searchC.searchBar;
    }else{
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenFrame.size.width,44)];
            tableview.tableHeaderView = view;//searchC.searchBar;
            [tableview.tableHeaderView addSubview:searchC.searchBar];
    }
    tableview.sectionIndexBackgroundColor = [UIColor clearColor];
    tableview.sectionIndexColor = UIColorFromRGB(0X717171);
    [self.view addSubview:tableview];
    
    //提示
    labelTi = [[UILabel alloc]initWithFrame:CGRectMake(30, ScreenFrame.size.height-100, ScreenFrame.size.width-60, 30)];
    [labelTi.layer setMasksToBounds:YES];
    [labelTi.layer setCornerRadius:4.0];
    labelTi.textAlignment = NSTextAlignmentCenter;
    labelTi.backgroundColor = [UIColor blackColor];
    labelTi.alpha = 0.8;
    [self.view addSubview:labelTi];
    labelTi.hidden = YES;
    labelTi.textColor = [UIColor whiteColor];
}
#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1){  //关闭主界面的右滑返回
        return NO;
    }else{
        return YES;
    }
    
    
}

-(void)buttonClicked:(UIButton *)btn{
    NSLog(@"%ld",(long)btn.tag);
    if (btn.tag==1000) {
        //返回
        [self.navigationController popViewControllerAnimated:YES];
    }else if (btn.tag==1001) {
        //刷新定位
        [self getCoreLocation];
        
    }
}
#pragma mark- UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!searchC.active) {
        return letterMarray.count;
    } else {
        return 1;
    }
  
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!searchC.active) {
        if (section==0) {
            return 1;
        }
        NSMutableArray *marray=[dataArray objectAtIndex:section];
        return marray.count;
    } else {
        return resultArray.count;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!searchC.active) {
        UIView *headerView=[LJControl viewFrame:CGRectMake(0,0,ScreenFrame.size.width, 40) backgroundColor:UIColorFromRGB(0Xf0f0f0)];
        if (section==0) {
            UILabel * headerLabel=[LJControl labelFrame:CGRectMake(10, 10, ScreenFrame.size.width-60, 20) setText:[letterMarray objectAtIndex:section] setTitleFont:16 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0X545454) textAlignment:NSTextAlignmentLeft];
            [headerView addSubview:headerLabel];
            UIButton *but=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(ScreenFrame.size.width-70, 10, 20, 20) setNormalImage:[UIImage imageNamed:@"refresh.png"] setSelectedImage:nil setTitle:@"" setTitleFont:0 setbackgroundColor:[UIColor clearColor]];
            but.tag=1001;
            [but addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:but];
        }else{
            UILabel * headerLabel=[LJControl labelFrame:CGRectMake(10, 10, ScreenFrame.size.width-20-30, 20) setText:[letterMarray objectAtIndex:section] setTitleFont:16 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0X545454) textAlignment:NSTextAlignmentLeft];
            [headerView addSubview:headerLabel];
            
            
        }
        return headerView;

    
    }else{
        UIView *headerView=[LJControl viewFrame:CGRectMake(0, 0,0,0) backgroundColor:[UIColor clearColor]];
        return headerView;
    }
    
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (!searchC.active) {
        return 40;
    } else {
        return 0.0001;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PositionsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PositionsCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (!searchC.active) {
        if (indexPath.section>0) {
            NSMutableArray *marray=[dataArray objectAtIndex:indexPath.section];
            AreaModel *model=[marray objectAtIndex:indexPath.row];
            cell.nameLabel.text=[NSString stringWithFormat:@"  %@",model.areaName];
        }else{
            if ([locationCity.areaName isEqualToString:@"无法获得准确地理信息"]) {
                cell.userInteractionEnabled=NO;
            }else{
                cell.userInteractionEnabled=YES;
            }
            cell.nameLabel.text=[NSString stringWithFormat:@"  %@",locationCity.areaName];
        }

    }else{
        AreaModel *model=[resultArray objectAtIndex:indexPath.row];
        cell.nameLabel.text=[NSString stringWithFormat:@"  %@",model.areaName];
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!searchC.active) {
        if (indexPath.section==0) {
            [self.delegate ChangedLocationCity:locationCity];
        }else{
            NSMutableArray *marray=[dataArray objectAtIndex:indexPath.section];
            AreaModel *model=[marray objectAtIndex:indexPath.row];
            [self.delegate ChangedLocationCity:model];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        AreaModel *model=[resultArray objectAtIndex:indexPath.row];
        [self.delegate ChangedLocationCity:model];
        [self.navigationController popViewControllerAnimated:YES];
        
    }

    
}
#pragma mark - searchController delegate
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [searchC.searchBar text];
    NSLog(@"%@",searchString);
    [resultArray removeAllObjects];
    for (NSMutableArray *dmArray in dataArray) {
        for (AreaModel *model in dmArray) {
            NSRange r=[model.areaName rangeOfString:searchString];
            if (r.length) {
                [resultArray addObject:model];
            }
        }
    }
    [tableview reloadData];
}
//通过这个方法设置索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
   NSMutableArray *Marray=[[NSMutableArray alloc]init];
    [Marray addObject:@"定位"];
    for (int i='A'; i<='Z'; i++) {
        [Marray addObject:[NSString stringWithFormat:@"%c",i]];
    }
    return Marray;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index-1;
    
}
#pragma mark -定位
- (void)getCoreLocation{
//    longv.hidden=NO;
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
//    longv.hidden=YES;
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
