//
//  MyCollectViewController.m
//  
//
//  Created by apple on 15/10/19.
//
//

#import "MyCollectViewController.h"
#import "SecondViewController.h"
#import "DetailViewController.h"
#import "FavoriteGoodsTableViewCell.h"
#import "FavoriteStopsTableViewCell.h"
#import "Model.h"
#import "ThirdViewController.h"
#import "FGTableViewCell.h"
#import "StoreHomeViewController2.h"
//#import "UIScrollView+UITouch.h"

@interface MyCollectViewController ()<UITableViewDataSource,UITableViewDelegate,DNSSwipeableCellDelegate, DNSSwipeableCellDataSource,UIGestureRecognizerDelegate>
{
    __weak IBOutlet UIView *NoDataView;
  
    NSMutableArray *goodsArray;
    UITableView *goodsTableview;
    
    NSMutableArray *stopArray;
    UITableView *stopTableview;
    int  count;
    int  count1;
    
    NSUInteger lastCount1;
    NSUInteger lastCount2;
    
    Model *Openmodel;
    DNSSwipeableCell *qCell;
    
    BOOL refreshBool;
    NSMutableArray *openedCells;
}
@end

@implementation MyCollectViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    [[self navigationController] setNavigationBarHidden:YES animated:NO];

}
- (void)viewWillDisappear:(BOOL)animated
{
     [super viewWillDisappear:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    count=1;
    count1=1;
    goodsArray=[[NSMutableArray alloc]init];
    stopArray=[[NSMutableArray alloc]init];
    Openmodel=[[Model alloc]init];
    qCell=[[DNSSwipeableCell alloc]init];
    openedCells = [NSMutableArray array];
//    [self setupGestures];
    [self designPage];
}
#pragma mark -上拉刷新、下拉加载
-(void)headerRereshing{
   [self getFavoriteGoodsBeginCoun:@"0" andEndCount:@"10"];
    [goodsTableview headerEndRefreshing];
}
-(void)footerRereshing{
    count++;
    [self getFavoriteGoodsBeginCoun:@"0" andEndCount:[NSString stringWithFormat:@"%d",count *10]];
    [goodsTableview footerEndRefreshing];
}
-(void)headerRereshing1{
    [self getFavoriteStopsBeginCoun:@"0" andEndCount:@"10"];
    [stopTableview headerEndRefreshing];
}
-(void)footerRereshing1{
    count1++;
    [self getFavoriteStopsBeginCoun:@"0" andEndCount:[NSString stringWithFormat:@"%d",count1 *10]];
    [stopTableview footerEndRefreshing];
}
#pragma mark -界面
-(void)createNavigation{
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0Xdf0000);
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }

    NSArray *arr=@[@"商品",@"店铺"];
    CGFloat w = 200;
    UISegmentedControl *sgc=[[UISegmentedControl alloc]initWithItems:arr];
    sgc.frame=CGRectMake(0, 0,w, 30);
    [sgc addTarget:self action:@selector(segmentedClicked:) forControlEvents:UIControlEventValueChanged];
    if ([self.flay integerValue]==2) {
        //关注店铺
           sgc.selectedSegmentIndex=1;
        [self getFavoriteStopsBeginCoun:@"0" andEndCount:@"10"];
    }else if ([self.flay integerValue]==3) {
        //关注商品
           sgc.selectedSegmentIndex=0;
        [self getFavoriteGoodsBeginCoun:@"0" andEndCount:@"10"];
    }else{
        //我的关注
        sgc.selectedSegmentIndex=0;
        [self getFavoriteGoodsBeginCoun:@"0" andEndCount:@"10"];
    }
    sgc.tintColor=[UIColor whiteColor];
    UIView *bgView=[LJControl viewFrame:CGRectMake(0, 0, w, 30) backgroundColor:[UIColor clearColor]];
    [bgView addSubview:sgc];
    self.navigationItem.titleView=bgView;
    
    UIButton *backButton = [LJControl backBtn];
    backButton.tag=1000;
    [backButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem =bar;
    

}
#pragma mark - 手势识别，关闭单元格
//-(void)setupGestures{
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touched11)];
//    tap.delegate = self;
//    [self.view addGestureRecognizer:tap];
//}
//-(void)touched11{
//    if (openedCells.count > 0) {
//        [self closeOpenedCells];
//    }
//}
-(void)closeOpenedCells {
    for (DNSSwipeableCell *cell in openedCells) {
        [cell closeCell:YES];
    }
    [openedCells removeAllObjects];
}
#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1){  //关闭主界面的右滑返回
        return NO;
    }else{
        return YES;
    }
}
-(void)designPage{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }

    //导航栏
    UIView *bgView=[LJControl viewFrame:CGRectMake(0,0,ScreenFrame.size.width, 64) backgroundColor:UIColorFromRGB(0Xdf0000)];
    [self.view addSubview:bgView];
    NSArray *arr=@[@"商品",@"店铺"];
    UISegmentedControl *sgc=[[UISegmentedControl alloc]initWithItems:arr];
    sgc.frame=CGRectMake(ScreenFrame.size.width/2-70,27,140, 30);
    [sgc addTarget:self action:@selector(segmentedClicked:) forControlEvents:UIControlEventValueChanged];
    if ([self.flay integerValue]==2) {
        //关注店铺
        sgc.selectedSegmentIndex=1;
        [self getFavoriteStopsBeginCoun:@"0" andEndCount:@"10"];
    }else if ([self.flay integerValue]==3) {
        //关注商品
        sgc.selectedSegmentIndex=0;
        [self getFavoriteGoodsBeginCoun:@"0" andEndCount:@"10"];
    }else{
        //我的关注
        sgc.selectedSegmentIndex=0;
        [self getFavoriteGoodsBeginCoun:@"0" andEndCount:@"10"];
    }
    sgc.tintColor=[UIColor whiteColor];
    [bgView addSubview:sgc];
    
    UIButton *backButton = [LJControl backBtn];
//    backButton.frame=CGRectMake(16,20,44,44);
    backButton.frame=CGRectMake(15,30,15,23.5);
    backButton.tag=1000;
    [backButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:backButton];

    
    
    //暂无分类
    UIImageView *noDataImage=[LJControl imageViewFrame:CGRectMake(ScreenFrame.size.width/2-131,20, 263,263) setImage:@"seller_center_nothing.png" setbackgroundColor:[UIColor clearColor]];
    [NoDataView addSubview:noDataImage];
    NoDataView.hidden=YES;
    //商品
    if ([self.flay integerValue]==1) {
        goodsTableview=[[UITableView alloc]initWithFrame:CGRectMake(0,64, ScreenFrame.size.width, ScreenFrame.size.height-64) style:UITableViewStylePlain];
        stopTableview=[[UITableView alloc]initWithFrame:CGRectMake(0,64, ScreenFrame.size.width, ScreenFrame.size.height-64) style:UITableViewStylePlain];
    }else{
        goodsTableview=[[UITableView alloc]initWithFrame:CGRectMake(0,64, ScreenFrame.size.width, ScreenFrame.size.height-64) style:UITableViewStylePlain];
        stopTableview=[[UITableView alloc]initWithFrame:CGRectMake(0,64, ScreenFrame.size.width, ScreenFrame.size.height-64) style:UITableViewStylePlain];
    }
    goodsTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    goodsTableview.delegate=self;
    goodsTableview.dataSource=self;
    goodsTableview.hidden=YES;
    [self.view addSubview:goodsTableview];
    [goodsTableview addHeaderWithTarget:self action:@selector(headerRereshing)];
    goodsTableview.showsVerticalScrollIndicator = YES;
//    [goodsTableview addFooterWithTarget:self action:@selector(footerRereshing)];
    
    //店铺
    stopTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    stopTableview.delegate=self;
    stopTableview.dataSource=self;
    stopTableview.hidden=YES;
    [self.view addSubview:stopTableview];
    [stopTableview addHeaderWithTarget:self action:@selector(headerRereshing1)];
    stopTableview.showsVerticalScrollIndicator = YES;
//    [stopTableview addFooterWithTarget:self action:@selector(footerRereshing1)];
    
    //提示
   
}
-(void)btnClicked:(UIButton *)btn{
    NSLog(@"%ld",(long)btn.tag);
    if (btn.tag==1000) {
        //返回
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void)segmentedClicked:(UISegmentedControl *)sgc{
    if (sgc.selectedSegmentIndex==0) {
    //商品
        [self getFavoriteGoodsBeginCoun:@"0" andEndCount:@"10"];
    }else if (sgc.selectedSegmentIndex==1){
    //店铺
        [self getFavoriteStopsBeginCoun:@"0" andEndCount:@"10"];
    }
}
#pragma mark -数据
//商品
-(void)getFavoriteGoodsBeginCoun:(NSString *)beginCoun andEndCount:(NSString *)endCount{
    [SYObject startLoading];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:filePathDong];
    NSLog(@"%@",fileContent);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,MYCOLLECTGOODS_URL]];
    ASIFormDataRequest * request=[ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[fileContent objectAtIndex:3] forKey:@"user_id"];
    [request setPostValue:[fileContent objectAtIndex:1] forKey:@"token"];
    [request setPostValue:beginCoun forKey:@"beginCount"];
    [request setPostValue:endCount forKey:@"endCount"];
    [request setRequestHeaders:[LJControl requestHeaderDictionary]];
    request.tag=1000;
    [request setDelegate:self];
    [request startAsynchronous];
}
//店铺
-(void)getFavoriteStopsBeginCoun:(NSString *)beginCoun andEndCount:(NSString *)endCount{
    [SYObject startLoading];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:filePathDong];
    NSLog(@"%@",fileContent);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,MYCOLLECTSTOPS_URL]];
    ASIFormDataRequest * request=[ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[fileContent objectAtIndex:3] forKey:@"user_id"];
    [request setPostValue:[fileContent objectAtIndex:1] forKey:@"token"];
    [request setPostValue:beginCoun forKey:@"beginCount"];
    [request setPostValue:endCount forKey:@"endCount"];
    [request setRequestHeaders:[LJControl requestHeaderDictionary]];
    request.tag=1001;
    [request setDelegate:self];
    [request startAsynchronous];
}
//取消收藏
-(void)getFavoriteDeletelMulitId:(NSString *)mulitId andType:(NSString *)type{
    [SYObject startLoading];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:filePathDong];
    NSLog(@"%@",fileContent);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,MYCOLLECTDELETE_URL]];
    ASIFormDataRequest * request=[ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[fileContent objectAtIndex:3] forKey:@"user_id"];
    [request setPostValue:[fileContent objectAtIndex:1] forKey:@"token"];
    [request setPostValue:mulitId forKey:@"mulitId"];
    [request setPostValue:type forKey:@"type"];
    [request setRequestHeaders:[LJControl requestHeaderDictionary]];
    request.tag=1002;
    [request setDelegate:self];
    [request startAsynchronous];
}
//加入购物车
-(void)getAddGoodsCart:(Model *)model{
    [SYObject startLoading];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:filePathDong];
    NSLog(@"%@",fileContent);
    //参数user_id, token,cart_mobile_ids, goods_id, count（数量）, price（价钱）,gsp（规格格式：99,96,）
    NSString *urlstr=[NSString stringWithFormat:@"%@%@",FIRST_URL,ADDCAR_URL];
    NSLog(@"%@",urlstr);
    NSURL *url=[NSURL URLWithString:urlstr];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    [request setRequestHeaders:[LJControl requestHeaderDictionary]];
    request.tag=1003;
    [request setPostValue:[fileContent objectAtIndex:3] forKey:@"user_id"];
    [request setPostValue:[fileContent objectAtIndex:1] forKey:@"token"];
    [request setPostValue:model.goodsId forKey:@"goods_id"];
    [request setPostValue:@"1" forKey:@"count"];
    [request setPostValue:[NSString stringWithFormat:@"%0.2f",[model.good_price floatValue]] forKey:@"price"];
    [request setPostValue:@"" forKey:@"cart_mobile_ids"];
    [request setPostValue:@"" forKey:@"gsp"];
    request.delegate=self;
    [request startAsynchronous];
}
#pragma mark- ASIHTTPRequestDelegate
-(void)requestFinished:(ASIHTTPRequest *)request{
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
    if (request.tag==1000) {
        NSLog(@"0%@",dic);
        if (goodsArray.count>0) {
            [goodsArray removeAllObjects];
        }
        NSArray *array=[dic objectForKey:@"favorite_list"];
        for (NSDictionary *dict in array) {
            Model *model=[[Model alloc]init];
            model.addTime=[dict objectForKey:@"addTime"];
            model.big_photo=[dict objectForKey:@"big_photo"];
            model.good_price=[dict objectForKey:@"good_price"];
            model.goodsId=[dict objectForKey:@"goods_id"];
            model.goods_inventory=[dict objectForKey:@"goods_inventory"];
            model.favoriteId=[dict objectForKey:@"id"];
            model.name=[dict objectForKey:@"name"];
            model.photo_ext=[dict objectForKey:@"photo_ext"];
            model.photo_name=[dict objectForKey:@"photo_name"];
            model.small_photo=[dict objectForKey:@"small_photo"];
            [goodsArray addObject:model];
            
        }
        if (goodsArray.count==0) {
            NoDataView.hidden=NO;
            goodsTableview.hidden=YES;
            stopTableview.hidden=YES;
        }else{
            NoDataView.hidden=YES;
            goodsTableview.hidden=NO;
            stopTableview.hidden=YES;
            [goodsTableview reloadData];
        }
    }else if (request.tag==1001) {
         NSLog(@"1%@",dic);
        
        if (stopArray.count>0) {
            [stopArray removeAllObjects];
        }
        NSArray *array=[dic objectForKey:@"favorite_list"];
        for (NSDictionary *dict in array) {
            Model *model=[[Model alloc]init];
            model.addTime=[dict objectForKey:@"addTime"];
            model.favorite_count=[dict objectForKey:@"favorite_count"];
            model.favoriteId=[dict objectForKey:@"id"];
            model.storeId=[dict objectForKey:@"store_id"];
            model.store_name=[dict objectForKey:@"store_name"];
            model.store_photo=[dict objectForKey:@"store_photo"];
            [stopArray addObject:model];
            
        }
        if (stopArray.count==0) {
            NoDataView.hidden=NO;
            goodsTableview.hidden=YES;
            stopTableview.hidden=YES;
        }else{
            NoDataView.hidden=YES;
            goodsTableview.hidden=YES;
            stopTableview.hidden=NO;
            [stopTableview reloadData];
        }
    }else if (request.tag==1002) {
         NSLog(@"2%@",dic);
        if ([[dic objectForKey:@"verify"]integerValue]==1) {
            if (!goodsTableview.hidden) {
                [self getFavoriteGoodsBeginCoun:@"0" andEndCount:@"10"];
            }else if (!stopTableview.hidden){
                [self getFavoriteStopsBeginCoun:@"0" andEndCount:@"10"];
            }
        }else{
            [SYObject failedPrompt:@"操作失败，请稍后再试！"];
        }
    }else if (request.tag==1003) {
        NSLog(@"3%@",dic);
        if ([[dic objectForKey:@"code"]integerValue]==0) {
             [SYObject failedPrompt:@"成功加入购物车，请查看购物车！"];
            [goodsTableview reloadData];
        }else if ([[dic objectForKey:@"code"]integerValue]==-1){
            [SYObject failedPrompt:@"添加失败，请稍后再试！"];
        }else{
            [SYObject failedPrompt:@"操作失败，请稍后再试！"];
        }

    
    }
    [SYObject endLoading];
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    [SYObject endLoading];
   [SYObject failedPrompt:@"网络正在开小差~~~"];
    NSLog(@"请求错误");
    
}

#pragma mark- UITableViewDataSource & UITableViewDelegate
//自动加载更多数据
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:goodsTableview] && indexPath.row ==goodsArray.count - 1 && goodsArray.count != 0 && lastCount1 != goodsArray.count) {
        [self footerRereshing];
        lastCount1 = goodsArray.count;
    }else if ([tableView isEqual:stopTableview] && indexPath.row ==stopArray.count - 1 && stopArray.count != 0 && lastCount2 != stopArray.count) {
        [self footerRereshing1];
        lastCount2 = stopArray.count;
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:stopTableview]) {
        return YES;
    }
    return NO;
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:stopTableview]) {
        return @"取消关注";
    }

    return @"";
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:stopTableview]) {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:stopTableview]) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            // Delete the row from the data source.
            NSLog(@"要删除啦~~~~~");
            Model *model=[stopArray objectAtIndex:indexPath.row];
            [self getFavoriteDeletelMulitId:model.favoriteId andType:@"1"];
        }else{
        }
    }

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:goodsTableview]) {
        return goodsArray.count;
    }else if ([tableView isEqual:stopTableview]) {
        return stopArray.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:goodsTableview]) {
        return 130;
    }else if ([tableView isEqual:stopTableview]) {
        return 100;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:goodsTableview]) {
        FGTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell==nil) {
            cell=[[FGTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
        }
        Model *model=[goodsArray objectAtIndex:indexPath.row];
        cell.model=model;
        cell.indexPath = indexPath;
        cell.dataSource = self;
        cell.delegate = self;
        
        [cell setNeedsUpdateConstraints];
        
        return cell;
    }else{
        static NSString *myTabelviewCell = @"FavoriteStopsTableViewCell";
        FavoriteStopsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FavoriteStopsTableViewCell" owner:self options:nil] lastObject];
        }
        Model *model=[stopArray objectAtIndex:indexPath.row];
        cell.model=model;
        return cell;
    
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:goodsTableview]) {
        if (openedCells.count > 0) {
            [self closeOpenedCells];
            return;
        }else {
        //商品详情
            Model *shjM = [goodsArray objectAtIndex:indexPath.row];
            SecondViewController *sec = [SecondViewController sharedUserDefault];
            sec.detail_id = shjM.goodsId;
            DetailViewController *dVC = [[DetailViewController alloc]init];
            [self.navigationController pushViewController:dVC animated:YES];
        }
    }else if ([tableView isEqual:stopTableview]){
        //店铺详情
        Model *shjM = [stopArray objectAtIndex:indexPath.row];
        ThirdViewController *th = [ThirdViewController sharedUserDefault];
        th.store_id = shjM.storeId;
        StoreHomeViewController2 *storeVC = [[StoreHomeViewController2 alloc]init];
        [self.navigationController pushViewController:storeVC animated:YES];
    }
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:goodsTableview]) {
       
        
    }

}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ([scrollView isEqual:goodsTableview]) {
      
        
    }
}
#pragma mark -DNSSwipeableCellDelegate&DNSSwipeableCellDataSource
#pragma mark - DNSSwipeableCellDataSource

#pragma mark Required Methods
-(CGFloat)widthForButtons{
    return 77;
}
- (NSInteger)numberOfButtonsInSwipeableCellAtIndexPath:(NSIndexPath *)indexPath
{
    return 2;
}

- (NSString *)titleForButtonAtIndex:(NSInteger)index inCellAtIndexPath:(NSIndexPath *)indexPath
{
    switch (index) {
        case 0:
            return NSLocalizedString(@"取消关注", @"取消关注");
            break;
        case 1:
            return NSLocalizedString(@"加入购物车", @"加入购物车");
            break;
        default:
            break;
    }
    
    return nil;
}

- (UIColor *)backgroundColorForButtonAtIndex:(NSInteger)index inCellAtIndexPath:(NSIndexPath *)indexPath
{
    switch (index) {
        case 0:
            return UIColorFromRGB(0xf15353);
            break;
        default: {
            //Note that the random index means colors won't persist after recycling.
            return UIColorFromRGB(0XDCDCDC);
        }
            break;
    }
}

- (UIColor *)textColorForButtonAtIndex:(NSInteger)index inCellAtIndexPath:(NSIndexPath *)indexPath
{
    if (index == 0) {
        return [UIColor whiteColor];
    }else {
        return UIColorFromRGB(0x707070);
    }
    
}
-(CGFloat)fontSizeForButtonAtIndex:(NSInteger)index inCellAtIndexPath:(NSIndexPath *)indexPath{
    return 12.f;
}

-(void)attract:(UIButton *)btn{
    //取消关注
    Model *model=[goodsArray objectAtIndex:btn.tag-100];
    [self getFavoriteDeletelMulitId:model.favoriteId andType:@"0"];
    
}
-(void)shoppingCart:(UIButton *)btn{
    //加入购物车
    Model *model=[goodsArray objectAtIndex:btn.tag-200];
    [self getAddGoodsCart:model];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - DNSSwipeableCellDelegate

- (void)swipeableCell:(DNSSwipeableCell *)cell didSelectButtonAtIndex:(NSInteger)index
{
    if (index == 0) {
        [self getFavoriteDeletelMulitId:Openmodel.favoriteId andType:@"0"];

    } else {
        [self getAddGoodsCart:Openmodel];
    }
}

- (void)swipeableCellDidOpen:(DNSSwipeableCell *)cell
{
    Model *model=[goodsArray objectAtIndex:cell.indexPath.row];
    Openmodel.addTime=model.addTime;
    Openmodel.big_photo=model.big_photo;
    Openmodel.good_price=model.good_price;
    Openmodel.goodsId=model.goodsId;
    Openmodel.goods_inventory=model.goods_inventory;
    Openmodel.favoriteId=model.favoriteId;
    Openmodel.name=model.name;
    Openmodel.photo_ext=model.photo_ext;
    Openmodel.photo_name=model.photo_name;
    Openmodel.small_photo=model.small_photo;
    
    [qCell closeCell:YES];
     qCell=cell;
    
    [openedCells addObject:cell];
}

- (void)swipeableCellDidClose:(DNSSwipeableCell *)cell
{
    Model *model=[[Model alloc]init];
    Openmodel.addTime=model.addTime;
    Openmodel.big_photo=model.big_photo;
    Openmodel.good_price=model.good_price;
    Openmodel.goodsId=model.goodsId;
    Openmodel.goods_inventory=model.goods_inventory;
    Openmodel.favoriteId=model.favoriteId;
    Openmodel.name=model.name;
    Openmodel.photo_ext=model.photo_ext;
    Openmodel.photo_name=model.photo_name;
    Openmodel.small_photo=model.small_photo;
    
    [openedCells removeObject:cell];
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
