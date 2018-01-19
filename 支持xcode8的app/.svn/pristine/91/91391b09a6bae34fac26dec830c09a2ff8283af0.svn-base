//
//  TSViewController.m
//  My_App
//
//  Created by barney on 15/11/23.
//  Copyright © 2015年 barney. All rights reserved.
//

#import "TSViewController.h"
#import "ASIFormDataRequest.h"
#import "UIImageView+WebCache.h"
#import "TSCell.h"
#import "TSModel.h"
#import "TSDetailViewController.h"
#import "MyTS.h"
#import "MyTSCell.h"
#import "MyTSDetailViewController.h"
#import "SingleOC.h"
#import "TSDoubleCell.h"
@interface TSViewController ()<UITableViewDataSource,UITabBarDelegate,UITableViewDelegate,ASIHTTPRequestDelegate,UIScrollViewDelegate,TSButtonCLickDelegate>
{
@private UIView * btnView;
@private UIButton * listBtn;
@private UIButton * myBtn;
@private UIView * redView;
}
@end

@implementation TSViewController
{
    UITableView *_tabView;
    UITableView *_tabView1;
    UIScrollView *_scroll;
    NSMutableArray *dataArray;
    NSMutableArray *dataArray1;
    ASIFormDataRequest *request_0;
    ASIFormDataRequest *request_1;
    ASIFormDataRequest *request_2;
    ASIFormDataRequest *request_3;
    UIImageView *imageNothing;
    UIImageView *imageNothing1;
    UILabel *labelNothing1;
    UILabel *labelNothing;
    int count;
    int count1;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"我的投诉";
    
    dataArray = [[NSMutableArray alloc]init];
    dataArray1 = [[NSMutableArray alloc]init];
    count=1;
    count1=1;
    
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 47, ScreenFrame.size.width, ScreenFrame.size.height-64-47)];
    
    _scroll.contentSize=CGSizeMake(ScreenFrame.size.width*2, 0);
    _scroll.pagingEnabled=YES;
    _scroll.showsHorizontalScrollIndicator=NO;
    _scroll.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_scroll];
    _scroll.delegate=self;
    self.nothingImage.hidden=YES;
    self.nothingLabel.hidden=YES;
    
    
    [self createBackBtn];
    [self createView];
//    [self downloadData];
//    [self downloadData1];
   
}
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_tabView) {
        return NO;
    }
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==_tabView1) {
        
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        NSLog(@"delete");
        [SYObject startLoading];
        MyTS *cla=[dataArray1 objectAtIndex:indexPath.row];
            //发起请求
            NSURL *url = [NSURL URLWithString:
                           [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&id=%@",
                            FIRST_URL,
                            MyTSCancle_URL,
                            [[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:3],
                            [[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:1],
                            cla.Id]];
            request_3=[ASIFormDataRequest requestWithURL:url];
            [request_3 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request_3.delegate =self;
            [request_3 setDidFailSelector:@selector(my_urlRequestFailed:)];
            [request_3 setDidFinishSelector:@selector(myzt_urlRequestSucceeded:)];
            [request_3 startAsynchronous];
            [dataArray1 removeObjectAtIndex:indexPath.row];
            [_tabView1 reloadData];
        }

        
        }
    
}
-(void)myzt_urlRequestSucceeded:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig2 =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"取消result===========%@", dicBig2);
        
        }
        
        else
        {
            [SYObject failedPrompt:@"请求出错"];
        }
   
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    if (scrollView==_scroll)
    {
        redView.frame=CGRectMake(20+scrollView.contentOffset.x/2, 45, ScreenFrame.size.width/2-40, 1);
        if (_scroll.contentOffset.x==ScreenFrame.size.width)
        {
            if (request_1.delegate)
            {
                [self downloadData1];
                [myBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [listBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }

        }if(_scroll.contentOffset.x==0){
            if (request_0.delegate)
            {
            [listBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [myBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self downloadData];
            }
            
        }

    }
    

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
-(void)createView
{
 
    /***************** 创建顶部按钮和滑动小条*******************/
    btnView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 47)];
    btnView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:btnView];
    CALayer * mylayer = [btnView layer];
    mylayer.borderColor = [UIColorFromRGB(0XDCDCDC) CGColor];
    mylayer.borderWidth = 1.0f;
    
    listBtn=[MyUtil createBtnFrame:CGRectMake(0, 0, ScreenFrame.size.width/2, 45) title:@"商品列表" image:nil highlighImage:nil selectImage:nil target:self action:@selector(topBtnClick:)];
    listBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [listBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    listBtn.tag=1001;
    [btnView addSubview:listBtn];
    
    myBtn=[MyUtil createBtnFrame:CGRectMake(ScreenFrame.size.width/2, 0, ScreenFrame.size.width/2, 45) title:@"我的投诉" image:nil highlighImage:nil selectImage:nil target:self action:@selector(topBtnClick:)];
    myBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    myBtn.tag=1002;
    [btnView addSubview:myBtn];
    
    redView=[[UIView alloc] initWithFrame:CGRectMake(20, 45, ScreenFrame.size.width/2-40, 1)];
    redView.backgroundColor=[UIColor redColor];
    [btnView addSubview:redView];
    
    /*****************  tableView 创建 上拉 手势 刷新圈*******************/
    _tabView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-47-64) style:(UITableViewStylePlain)];
    _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tabView.delegate =self;
    _tabView.dataSource= self;
    _tabView.showsVerticalScrollIndicator=NO;
    _tabView.showsHorizontalScrollIndicator = NO;
    
    [_tabView addFooterWithTarget:self action:@selector(footerRefresh)];
    [_tabView addHeaderWithTarget:self action:@selector(headerRefresh)];
    
    _tabView.rowHeight = UITableViewAutomaticDimension;
    _tabView.estimatedRowHeight = 44;
    
    _tabView.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    _tabView.tag=500;
    
    
    imageNothing = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenFrame.size.width-200)/2, (ScreenFrame.size.height-250)/4, 200, 250)];
    imageNothing.image = [UIImage imageNamed:@"seller_center_nothing.png"];
    [_scroll addSubview:imageNothing];
   labelNothing = [[UILabel alloc]initWithFrame:CGRectMake(0, imageNothing.frame.origin.y+imageNothing.frame.size.height, ScreenFrame.size.width, 30)];
    labelNothing.text = @"抱歉，没有找到相关数据";
    labelNothing.textAlignment = NSTextAlignmentCenter;
    [_scroll addSubview:labelNothing];
    [_scroll addSubview:_tabView];
    
    _tabView1=[[UITableView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width, 0, ScreenFrame.size.width, ScreenFrame.size.height-47-64) style:(UITableViewStylePlain)];
    _tabView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tabView1.delegate =self;
    _tabView1.dataSource= self;
    _tabView1.showsVerticalScrollIndicator=NO;
    _tabView1.showsHorizontalScrollIndicator = NO;
    _tabView1.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    _tabView1.tag=501;
    [_tabView1 addFooterWithTarget:self action:@selector(footerRefresh1)];
     [_tabView1 addHeaderWithTarget:self action:@selector(headerRefresh1)];
    
    _tabView1.rowHeight = UITableViewAutomaticDimension;
    _tabView1.estimatedRowHeight = 44;
    
    imageNothing1 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width+(ScreenFrame.size.width-200)/2, (ScreenFrame.size.height-250)/4, 200, 250)];
    imageNothing1.image = [UIImage imageNamed:@"seller_center_nothing.png"];
    [_scroll addSubview:imageNothing1];
    labelNothing1 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width, imageNothing1.frame.origin.y+imageNothing1.frame.size.height, ScreenFrame.size.width, 30)];
    labelNothing1.text = @"抱歉，没有找到相关数据";
    labelNothing1.textAlignment = NSTextAlignmentCenter;
    [_scroll addSubview:labelNothing1];
    labelNothing1.hidden=YES;
    imageNothing1.hidden=YES;
    
    [_scroll addSubview:_tabView1];
    
    
}
#pragma mark - 下拉刷新,上拉自动刷新
-(void)headerRefresh
{
    [_tabView headerEndRefreshing];
    [self downloadData];

}
-(void)headerRefresh1
{
    [_tabView1 headerEndRefreshing];
    [self downloadData1];
  
}
-(void)footerRefresh{
    [_tabView footerEndRefreshing];
    count++;
    [self downloadData];
   
    
}
-(void)footerRefresh1{
    [_tabView1 footerEndRefreshing];
    count1++;
    [self downloadData1];
    
    
}
-(void) topBtnClick:(UIButton *) btn
{
    // 商品列表
    if(btn.tag==1001)
    {
        [listBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [myBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            redView.frame=CGRectMake(20, 45, ScreenFrame.size.width/2-40, 1);
        }];
         _scroll.contentOffset=CGPointMake(0, 0);
        [self downloadData];
    }
    // 我的投诉
    if(btn.tag==1002)
    {
        [myBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [listBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            redView.frame=CGRectMake(20+ScreenFrame.size.width/2, 45, ScreenFrame.size.width/2-40, 1);
        }];
         _scroll.contentOffset=CGPointMake(ScreenFrame.size.width, 0);
    
        [self downloadData1];

    }
  
}
#pragma mark- ASIrequest
-(void) downloadData
{
    //发起请求
    [SYObject startLoading];
    NSURL *url = [NSURL URLWithString:
                   [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&beginCount=%d&selectCount=%@",
                    FIRST_URL,
                    TS_URL,
                    [[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:3],
                    [[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:1],
                    0,
                    [NSString stringWithFormat:@"%d",20*count]]];
    request_0=[ASIFormDataRequest requestWithURL:url];
    [request_0 setRequestHeaders:[LJControl requestHeaderDictionary]];
    
    request_0.delegate =self;
    [request_0 setDidFailSelector:@selector(my_urlRequestFailed:)];
    [request_0 setDidFinishSelector:@selector(my_urlRequestSucceeded:)];
    [request_0 startAsynchronous];
}

// 请求成功(第一次进入页面的请求)
-(void)my_urlRequestSucceeded:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
       
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"甄投诉result===========%@", dicBig);
        // 每次请求都清空数据源
        if (dataArray.count!=0)
        {
            [dataArray removeAllObjects];
        }
        if (dicBig) {
            
            NSArray *arr = [dicBig objectForKey:@"datas"];
            for(NSDictionary *dic in arr){
                TSModel *clas = [[TSModel alloc]init];
                clas.addTime = [dic objectForKey:@"addTime"];
                clas.order_id = [dic objectForKey:@"order_id"];
                clas.oid = [dic objectForKey:@"oid"];
                clas.goods_maps=[dic objectForKey:@"goods_maps"];
                [dataArray addObject:clas];
                
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:@"kTSTableViewCellShouldRefresh" object:nil userInfo:nil];
            
            if (dataArray.count ==0) {
                _tabView.hidden = YES;
                
                //                self.nothingImage.hidden = NO;
                //                self.nothingLabel.hidden = NO;
                labelNothing.hidden=NO;
                imageNothing.hidden=NO;
                
            }else{
                _tabView.hidden = NO;
                
                self.nothingImage.hidden = YES;
                self.nothingLabel.hidden = YES;
                labelNothing.hidden=YES;
                imageNothing.hidden=YES;
            }
            
            // 下载成功刷新数据源
            [_tabView reloadData];
            NSLog(@"投诉===========%ld", (unsigned long)dataArray.count);
            
        }
    
    else
    {
        [SYObject failedPrompt:@"请求出错"];
    }
    }
    
}
-(void)my_urlRequestFailed:(ASIFormDataRequest *)request
{
    [SYObject endLoading];
    [SYObject failedPrompt:@"请求失败"];
}


-(void) downloadData1
{
   
    //发起请求
    NSURL *url = [NSURL URLWithString:
                   [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&beginCount=%d&selectCount=%@",
                    FIRST_URL,
                    TSDid_URL,
                    [[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:3],
                    [[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:1],
                    0,
                    [NSString stringWithFormat:@"%d",count1*20]]];
    request_1=[ASIFormDataRequest requestWithURL:url];
    [request_1 setRequestHeaders:[LJControl requestHeaderDictionary]];
    
    request_1.delegate =self;
    [request_1 setDidFailSelector:@selector(my_urlRequestFailed:)];
    [request_1 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
    [request_1 startAsynchronous];
}

// 请求成功(第一次进入页面的请求)
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
   
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"我的投诉 旧的===========%@", dicBig);
        // 每次请求都清空数据源
        if (dataArray1.count!=0)
        {
            [dataArray1 removeAllObjects];
        }
        if (dicBig) {
            
            NSArray *arr = [dicBig objectForKey:@"datas"];
            for(NSDictionary *dic in arr){
                MyTS *clas = [[MyTS alloc]init];
                clas.addTime = [dic objectForKey:@"addTime"];
                clas.status = [dic objectForKey:@"status"];
                clas.store_name=[dic objectForKey:@"store_name"];
                clas.img=[dic objectForKey:@"img"];
                clas.Id=[dic objectForKey:@"id"];
                
                
                [dataArray1 addObject:clas];
                
            }
            if (dataArray1.count ==0) {
                _tabView1.hidden = YES;
                labelNothing1.hidden=NO;
                imageNothing1.hidden=NO;
            }else{
                
                self.nothingImage.hidden = YES;
                self.nothingLabel.hidden = YES;
                labelNothing1.hidden=YES;
                imageNothing1.hidden=YES;
                _tabView1.hidden = NO;
            }
// 下载成功刷新数据源
           [_tabView1 reloadData];
          
        }
        
        else
        {
            [SYObject failedPrompt:@"请求出错"];
        }
    }
    
}


#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_tabView) {
        
        if (dataArray.count!=0) {
            return dataArray.count;
        }
        return 0;
    }else if(tableView==_tabView1)
    {
        
            
            if (dataArray1.count!=0) {
                return dataArray1.count;
            }
            return 0;
        
    
    }
    return 0;
    
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (tableView==_tabView) {
//        return 132;
//    }
//    
//    return 100;
//   
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        
    if (tableView==_tabView) {
        
    
    static NSString *Cell = @"TSCell";
    TSCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
    
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TSCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (dataArray.count !=0)
    {
        
        TSModel *cla = [dataArray objectAtIndex:indexPath.row];
        cell.time.text =[NSString stringWithFormat:@"下单时间：%@",cla.addTime];
        cell.order.text = [NSString stringWithFormat:@"订单号：%@",cla.order_id];
        cell.oid=[NSString stringWithFormat:@"%@",cla.oid];
        cell.array=cla.goods_maps;
        cell.delegate=self;
        
        
    }
        return cell;
    }
    
    else if (tableView==_tabView1)
    {  static NSString *Cell = @"MyTSCell";
    MyTSCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
    
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyTSCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (dataArray1.count !=0) {
        MyTS *cla = [dataArray1 objectAtIndex:indexPath.row];
        NSLog(@"投诉===========%@", cla);
        if (cla.store_name) {
            cell.name.text = cla.store_name;
        }else
        {
        
        cell.name.text =@"暂无";
        }
        
        [cell.img sd_setImageWithURL:[NSURL URLWithString:cla.img]placeholderImage:[UIImage imageNamed:@"kong_lj"]];
        if ([cla.status intValue]==1) {
            cell.status.text=@"待申诉";
        }else if ([cla.status intValue]==0)
        {
        cell.status.text=@"新投诉";
        
        }else if ([cla.status intValue]==2)
        {
            cell.status.text=@"沟通中";
            
        }else if ([cla.status intValue]==3)
        {
            cell.status.text=@"待仲裁";
            
        }else if ([cla.status intValue]==4)
        {
            cell.status.text=@"投诉结束";
            
        }
        if (cla.addTime) {
            cell.time.text = [NSString stringWithFormat:@"%@",cla.addTime];
        }else
        {
            cell.time.text =@"暂无时间";
            
        }
        
       
        
    }
    return cell;
    }
    else{
    static NSString *cellName=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellName];
        
    }
    return cell;
    }
    
}

-(void)detailsButtonCLick:(NSDictionary *)sd WithOid:(NSString *)oid
{
    NSLog(@"我点了");
    TSDetailViewController *detail=[[TSDetailViewController alloc]init];
//    TSModel *cla = [dataArray objectAtIndex:btn.tag-10];
//    detail.model=cla;
    detail.goods_name=[sd objectForKey:@"goods_name"];
    detail.goods_img=[sd objectForKey:@"goods_img"];
    detail.goods_gsp_ids=[sd objectForKey:@"goods_gsp_ids"];
    detail.goods_id=[sd objectForKey:@"goods_id"];
    detail.oid=oid;
    [self.navigationController pushViewController:detail animated:YES];
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tabView1)
    {
        MyTSDetailViewController *my=[[MyTSDetailViewController alloc]init];
        [self.navigationController pushViewController:my animated:YES];
        MyTS *myTS=[dataArray1 objectAtIndex:indexPath.row];
        my.TSID=[NSString stringWithFormat:@"%@",myTS.Id];
        
        
    }
}

-(void)click:(UIButton *)btn
{ //跳转投诉详情界面
    TSDetailViewController *detail=[[TSDetailViewController alloc]init];
    TSModel *cla = [dataArray objectAtIndex:btn.tag-10];
    detail.model=cla;
    [self.navigationController pushViewController:detail animated:YES];
  
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    dataArray = [[NSMutableArray alloc]init];
    dataArray1 = [[NSMutableArray alloc]init];
    [self downloadData];
    [self downloadData1];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request_0 clearDelegatesAndCancel];
    [request_1 clearDelegatesAndCancel];
    [request_2 clearDelegatesAndCancel];
    [request_3 clearDelegatesAndCancel];
    
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
