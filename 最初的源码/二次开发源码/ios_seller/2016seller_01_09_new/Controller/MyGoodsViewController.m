//
//  MyGoodsViewController.m
//  SellerApp
//
//  Created by barney on 15/12/31.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MyGoodsViewController.h"
#import "StatusModel.h"
#import "goodsListCell.h"
#import "goodsModel.h"
#import "statusCell.h"
#import "LeftRightButton.h"
#import "StatusDoubleModel.h"
#import "UIImageView+WebCache.h"
#import "SearchGoodsViewController.h"
#import "classCell.h"
#import "GoodsPreviewViewController.h"
#import "goodseditViewController.h"
@interface MyGoodsViewController ()
{
    NSMutableArray *dataArray;//商品列表数据源
    UITableView *goodsTabView;//商品列表
    //下拉菜单
    UIImageView *optionImageview;
    UIView *optionBg;
    //商品状态
    UIView *statusView;
    NSMutableArray *statusArray;
    UITableView *statusTableview;
    //商品分类
    UIView *classifyView;
    NSMutableArray *classifyArray;
    UITableView *classifyTableview;
    NSMutableArray *classifyArray1;
    UITableView *classifyTableview1;
    //排序方式
    UIView *priceView;
    NSMutableArray *priceArray;
    UITableView *priceTableview;
    
    NSMutableString *orderBy;//参数：排序方式
    NSMutableString *status;//参数：商品状态
    NSMutableString *classID;//参数：商品二级分类id
    BOOL flag;//正反排序标志
    int count;//用于列表下拉加载计数
    UIView *nodata;//空状态视图
    
}

@end

@implementation MyGoodsViewController

-(void)viewWillDisappear:(BOOL)animated
{
    //隐藏下拉菜单
    optionImageview.hidden=YES;
    optionBg.hidden=YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=NO;
    //数据初始化
    status=[[NSMutableString alloc]init];
    classID=[[NSMutableString alloc]init];
    orderBy=[[NSMutableString alloc]init];
    dataArray = [NSMutableArray array];
    statusArray = [NSMutableArray array];
    classifyArray = [NSMutableArray array];
    classifyArray1 = [NSMutableArray array];
    priceArray = [NSMutableArray array];
    
    UILabel *lab1=(UILabel *)[self.view viewWithTag:100];
    lab1.text=@"商品状态";
    UILabel *lab2=(UILabel *)[self.view viewWithTag:101];
    lab2.text=@"商品分类";
    UILabel *lab3=(UILabel *)[self.view viewWithTag:102];
    lab3.text=@"排序方式";
    flag=NO;
    count=1;
    //商品列表 网络请求数据
    [self getIndex:orderBy andorderType:@"asc" andGoods_status:status andUser_goodsclass_id:classID andGoods_name:@"" andBegincount:@"0" andSelectcount:[NSString stringWithFormat:@"%d",count*10]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (UIDeviceSystem>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else
    {
    }
    
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x2196f3);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.title = @"商品"; //标题栏
    [self designPage];
    
}
-(void)designPage   //设计页面
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    //导航栏右侧搜索按钮
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemSearch) target:self action:@selector(searchBtn)];
    //条件
    UIView *bgView=[LJControl viewFrame:CGRectMake(0,67,ScreenFrame.size.width,52) backgroundColor:[UIColor whiteColor]];
    //上灰线
    UILabel*bl=[LJControl labelFrame:CGRectMake(0,0,ScreenFrame.size.width, 1) setText:@"" setTitleFont:0 setbackgroundColor:UIColorFromRGB(0Xe3e3e3) setTextColor:nil textAlignment:NSTextAlignmentCenter];
    [bgView addSubview:bl];
    //下灰线
    UILabel*bll=[LJControl labelFrame:CGRectMake(0,bgView.bounds.size.height-1,ScreenFrame.size.width, 1) setText:@"" setTitleFont:0 setbackgroundColor:UIColorFromRGB(0Xe3e3e3) setTextColor:nil textAlignment:NSTextAlignmentCenter];
    [bgView addSubview:bll];
    
    //两条竖线
    UILabel*l=[LJControl labelFrame:CGRectMake(ScreenFrame.size.width/3-1, 11, 1, 30) setText:@"" setTitleFont:0 setbackgroundColor:UIColorFromRGB(0Xe6e6e6) setTextColor:nil textAlignment:NSTextAlignmentCenter];
    [bgView addSubview:l];
    UILabel*ll=[LJControl labelFrame:CGRectMake(ScreenFrame.size.width/3*2-1, 11, 1, 30) setText:@"" setTitleFont:0 setbackgroundColor:UIColorFromRGB(0Xe6e6e6) setTextColor:nil textAlignment:NSTextAlignmentCenter];
    [bgView addSubview:ll];
    
    NSArray *labeArr=@[@"商品状态",@"商品分类",@"排序方式"];
    for (int i=0; i<3; i++) {
        UIButton *button=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(ScreenFrame.size.width/3*i+5, 11, ScreenFrame.size.width/3-10, 30) setNormalImage:nil setSelectedImage:nil setTitle:@"" setTitleFont:0 setbackgroundColor:[UIColor clearColor]];
        button.tag=1003+i;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label=[LJControl labelFrame:CGRectMake(15, 5, button.bounds.size.width-30, button.bounds.size.height-10) setText:[labeArr objectAtIndex:i] setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0X5c5c5c) textAlignment:NSTextAlignmentCenter];
        label.tag=100+i;
        [button addSubview:label];
       
        
        UIImageView *image=[LJControl imageViewFrame:CGRectMake(label.bounds.size.width+15, button.bounds.size.height-15, 10, 10) setImage:@"more.png" setbackgroundColor:[UIColor clearColor]];
        [button addSubview:image];
        [bgView addSubview:button];
   
    }
    [self.view addSubview:bgView];
    
    //商品列表
    goodsTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 52+67, ScreenFrame.size.width, ScreenFrame.size.height-67-52-49) style:UITableViewStylePlain];
    //调用空状态视图
    nodata = [MyObject noDataViewForTableView:goodsTabView];
    goodsTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    goodsTabView.delegate = self;
    goodsTabView.dataSource=  self;
    goodsTabView.showsVerticalScrollIndicator=NO;
    goodsTabView.showsHorizontalScrollIndicator = NO;
    //goodsTabView.backgroundColor = [UIColor clearColor];
    goodsTabView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    goodsTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    goodsTabView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [self.view addSubview:goodsTabView];
    

    //弹出下拉  52+67
    optionImageview=[LJControl imageViewFrame:CGRectMake(0, 52+67,ScreenFrame.size.width, ScreenFrame.size.height-52-67)  setImage:@"" setbackgroundColor:[UIColor blackColor]];
    optionBg=[LJControl viewFrame:CGRectMake(0, 52+67,ScreenFrame.size.width, ScreenFrame.size.height-52-67) backgroundColor:[UIColor clearColor]];
    optionImageview.hidden=YES;
    optionBg.hidden=YES;
    optionImageview.alpha=0.8;
    [self.view addSubview:optionImageview];
    [self.view addSubview:optionBg];
    
       //商品状态
    statusView=[LJControl viewFrame:CGRectMake(0,0, ScreenFrame.size.width,ScreenFrame.size.height-52-67) backgroundColor:[UIColor whiteColor]];
    statusTableview=[[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenFrame.size.width,ScreenFrame.size.height-52-67) style:UITableViewStylePlain];
    statusTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    statusTableview.delegate=self;
    statusTableview.dataSource=self;
    [statusView addSubview:statusTableview];
    statusView.hidden=YES;
    [optionBg addSubview:statusView];
    
    //分类
    classifyView=[LJControl viewFrame:CGRectMake(0,0, ScreenFrame.size.width,ScreenFrame.size.height-52-67) backgroundColor:[UIColor whiteColor]];
    classifyTableview=[[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenFrame.size.width/2,ScreenFrame.size.height-52-67) style:UITableViewStylePlain];
    classifyTableview.delegate=self;
    classifyTableview.dataSource=self;
    classifyTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [classifyView addSubview:classifyTableview];
    
    
    classifyTableview1=[[UITableView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width/2,0, ScreenFrame.size.width/2,ScreenFrame.size.height-52-67) style:UITableViewStylePlain];
    classifyTableview1.delegate=self;
    classifyTableview1.dataSource=self;
    classifyTableview1.backgroundColor=UIColorFromRGB(0Xeaeaea);
    classifyTableview1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [classifyView addSubview:classifyTableview1];
    
    classifyView.hidden=YES;
    [optionBg addSubview:classifyView];
    
    //排序方式
    priceView=[LJControl viewFrame:CGRectMake(0,0, ScreenFrame.size.width,ScreenFrame.size.height-52-67) backgroundColor:[UIColor whiteColor]];
    priceTableview=[[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenFrame.size.width,ScreenFrame.size.height-52-67) style:UITableViewStylePlain];
     priceTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    priceTableview.delegate=self;
    priceTableview.dataSource=self;
    [priceView addSubview:priceTableview];
    priceView.hidden=YES;
    [optionBg addSubview:priceView];



}
#pragma mark -上拉刷新、下拉加载
-(void)headerRereshing{
    [self getIndex:orderBy andorderType:@"asc" andGoods_status:status andUser_goodsclass_id:classID andGoods_name:@"" andBegincount:@"0" andSelectcount:[NSString stringWithFormat:@"%d",count*10]];
    [goodsTabView.mj_header endRefreshing];
}
-(void)footerRereshing{
    count ++;
    [self getIndex:orderBy andorderType:@"asc" andGoods_status:status andUser_goodsclass_id:classID andGoods_name:@"" andBegincount:@"0" andSelectcount:[NSString stringWithFormat:@"%d",count*10]];
    [goodsTabView.mj_footer endRefreshing];
}
-(void)searchBtn
{
    SearchGoodsViewController *sear = [[SearchGoodsViewController alloc]init];
    [self.navigationController pushViewController:sear animated:YES];
}
//三个筛选条件的点击事件
-(void)buttonClicked:(UIButton *)btn
{
    if (btn.tag==1003){
        //状态
        [self getGoodsStatus];
        statusView.hidden=NO;
        classifyView.hidden=YES;
        priceView.hidden=YES;
        btn.selected=!btn.selected;
        if (btn.selected) {
            optionImageview.hidden=NO;
            optionBg.hidden=NO;
            
        }else{
            optionImageview.hidden=YES;
            optionBg.hidden=YES;
        }
        
    }
    else if (btn.tag==1004){
        //分类
        [self getClass];
        statusView.hidden=YES;
        classifyView.hidden=NO;
        priceView.hidden=YES;
        btn.selected=!btn.selected;
        if (btn.selected) {
            optionImageview.hidden=NO;
            optionBg.hidden=NO;
        }else{
            optionImageview.hidden=YES;
            optionBg.hidden=YES;
        }
        
    }
    else if (btn.tag==1005){
        //排序方式
        [self getPrice];
        statusView.hidden=YES;
        classifyView.hidden=YES;
        priceView.hidden=NO;
        btn.selected=!btn.selected;
        if (btn.selected) {
            optionImageview.hidden=NO;
            optionBg.hidden=NO;
        }else{
            optionImageview.hidden=YES;
            optionBg.hidden=YES;
        }
        
    }

}
#pragma mark -数据
//商品状态的下拉菜单
-(void)getGoodsStatus
{
    NSArray * nArray=@[@"全部",@"出售中",@"仓库中",@"违规下架"];
    NSArray *iArray=@[@"10",@"0",@"1",@"-2"];
    NSArray *imgArray=@[@"all",@"onsale",@"inStore",@"offSale"];
    statusArray=[[NSMutableArray alloc]init];
    for (int i=0; i<nArray.count; i++) {
        StatusModel *model=[[StatusModel alloc]init];
        model.statusID=[iArray objectAtIndex:i];
        model.statusName=[nArray objectAtIndex:i];
        model.img=[imgArray objectAtIndex:i];
        [statusArray addObject:model];
    }
    [statusTableview reloadData];
}
// 分类的下拉菜单
-(void)getClass{
    [MyObject startLoading];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,GOODS_CLASS_URL];
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken],
                          };
   [[MyNetTool managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
       [MyObject endLoading];
       NSDictionary * dicBig=responseObject;
       NSLog(@"/////商品分类%@",dicBig);
       
       if (dicBig)
       {
           //一级分类数据源
           classifyArray=[NSMutableArray arrayWithObject:@"全部"];
           NSArray *ary=[dicBig objectForKey:@"class_list"];
           for (NSDictionary *dic in ary)
           {
               StatusDoubleModel *model=[[StatusDoubleModel alloc]init];
               model.statusName=[dic objectForKey:@"className"];
               model.statusID=[dic objectForKey:@"id"];
               [classifyArray addObject:model.statusName];
           }
           
           [classifyTableview reloadData];
           //二级分类的数据源初始化
           classifyArray1=[[NSMutableArray alloc]init];
           [classifyTableview1 reloadData];
           
        }

       
       
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       NSLog(@"%@",[error localizedDescription]);
       classifyView.hidden=YES;
       [MyObject endLoading];
       

   }];
    
}
//分类的二级菜单
-(void)getNextClass:(NSInteger)amount
{
    [MyObject startLoading];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,GOODS_CLASS_URL];
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken],
                          };
    [[MyNetTool managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MyObject endLoading];
        NSDictionary * dicBig=responseObject;
        NSLog(@"/////二级分类%@",dicBig);
        
        if (dicBig)
        {
            classifyArray1=[[NSMutableArray alloc]init];//二级分类菜单的数据源初始化
            NSArray *ary=[dicBig objectForKey:@"class_list"];
            NSDictionary *d=[ary objectAtIndex:amount];
            for (NSDictionary *finalDic in [d objectForKey:@"child_list"])
            {
                StatusDoubleModel *model=[[StatusDoubleModel alloc]init];
                model.statusDoubleName=[finalDic objectForKey:@"className"];
                model.statusDoubleID=[finalDic objectForKey:@"id"];
                [classifyArray1 addObject:model];
                
            }
            
            [classifyTableview1 reloadData];//二级分类菜单刷新列表
           
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"%@",[error localizedDescription]);
        classifyView.hidden=YES;//商品分类界面隐藏
        [MyObject endLoading];
        
    }];
    
}
//排序的下拉菜单
-(void)getPrice{
    NSArray * nArray=@[@"添加时间",@"销量",@"库存"];
    NSArray *iArray=@[@"addTime",@"goods_salenum",@"goods_inventory"];
    priceArray=[[NSMutableArray alloc]init];
    for (int i=0; i<nArray.count; i++) {
        StatusModel *model=[[StatusModel alloc]init];
        model.statusName=[nArray objectAtIndex:i];
        model.statusID=[iArray objectAtIndex:i];
        [priceArray addObject:model];
    }
    [priceTableview reloadData];
}
//商品列表的网络请求
-(void)getIndex:(NSString *)orderBY andorderType:(NSString *)orderType andGoods_status:(NSString *)goods_status andUser_goodsclass_id:(NSString *)user_goodsclass_id andGoods_name:(NSString *)goods_name  andBegincount:(NSString *)begincount andSelectcount:(NSString *)selectcount {
    [MyObject startLoading];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,GOODS_LIST_URL];
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken],
                          @"goods_status":[NSString stringWithFormat:@"%@",goods_status],
                          @"orderby":orderBY,
                          @"ordertype":orderType,
                          @"begin_count":begincount,
                          @"select_count":[NSString stringWithFormat:@"%@",selectcount],
                          @"user_goodsclass_id":[NSString stringWithFormat:@"%@",user_goodsclass_id],
                          @"goods_name":goods_name
                          
                          };
    NSLog(@"par////%@",par);
    [[MyNetTool managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MyObject endLoading];
        NSDictionary * dicBig=responseObject;
        NSLog(@"/////////商品列%@",dicBig);
        
        if (dicBig)
        {
            dataArray=[[NSMutableArray alloc]init];
         for (NSDictionary *dictt in [dicBig objectForKey:@"goods_list"])
         {
             goodsModel *model=[[goodsModel alloc]init];
             //kvc 模型赋值
             [model setValuesForKeysWithDictionary:dictt];
            [dataArray addObject:model];
             
         }
            [goodsTabView reloadData];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        goodsTabView.hidden=YES;
        [MyObject endLoading];
        
        
    }];
    
}
#pragma mark- UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:goodsTabView])//商品列表
    {
       
        if (dataArray.count!=0)
        {
            tableView.backgroundView = nil;
            return dataArray.count;
        }
        else{
            tableView.backgroundView = nodata;
            return 0;
        }

       
    }else if ([tableView isEqual:statusTableview])//商品状态
    {
        return  statusArray.count;
    }else if ([tableView isEqual:classifyTableview])//商品一级分类
    {
        return  classifyArray.count;
        
    }else if ([tableView isEqual:classifyTableview1])//商品二级分类
    {
        return  classifyArray1.count;
    }else if ([tableView isEqual:priceTableview])//排序方式
    {
        return  priceArray.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:goodsTabView]) //商品列表
    {
        return  190;
    }else if ([tableView isEqual:statusTableview]) //商品状态
    {
        return  44;
    }else if ([tableView isEqual:classifyTableview]) //商品一级分类
    {
        return  44;
    }else if ([tableView isEqual:classifyTableview1]) //商品二级分类
    {
        return  44;
    }else if ([tableView isEqual:priceTableview]) //排序方式
    {
        return  44;
    }
    
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:goodsTabView]) {
       static NSString *myTabelviewCell =@"goodsListCell";//[NSString stringWithFormat:@"goodsListCell%d",indexPath.row] ;
       goodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"goodsListCell" owner:self options:nil] lastObject];
            
        }
        goodsModel *model=[dataArray objectAtIndex:indexPath.row];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.title.text=model.goods_name;
        [cell.img sd_setImageWithURL:[NSURL URLWithString:model.goods_main_photo]placeholderImage:[UIImage imageNamed:@"loading"]];
        cell.price.text=[NSString stringWithFormat:@"￥%@",model.goods_current_price];
        cell.didSale.text=[NSString stringWithFormat:@"已售 %@",model.goods_salenum];
        cell.kc.text=[NSString stringWithFormat:@"库存 %@",model.goods_inventory];
        cell.edit.tag=10000+indexPath.row;
        [cell.edit addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"model.goods_status=%@",model.goods_status);
        if ([model.goods_status integerValue]==1||[model.goods_status integerValue]==2||[model.goods_status integerValue]==-1||[model.goods_status integerValue]==-2||[model.goods_status integerValue]==-5||[model.goods_status integerValue]==-6) {
            cell.saleOffLabel.text=@"上架";
        }else{
            cell.saleOffLabel.text=@"下架";
        }
        cell.saleOff.tag=20000+indexPath.row;
        [cell.saleOff addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.share.tag=30000+indexPath.row;
        [cell.share addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.del.tag=40000+indexPath.row;
        [ cell.del addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else if ([tableView isEqual:statusTableview]) {
        static NSString *myTabelviewCell = @"statusCell";
        statusCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"statusCell" owner:self options:nil] lastObject];
           
        }
        StatusModel *model=[statusArray objectAtIndex:indexPath.row];
        cell.model=model;
        return cell;
    }else if ([tableView isEqual:classifyTableview]) {
        static NSString *myTabelviewCell = @"classCell";
        classCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"classCell" owner:self options:nil] lastObject];
            
        }
        NSString *str=[classifyArray objectAtIndex:indexPath.row];
        cell.titleLab.text=str;
        return cell;
    }else if ([tableView isEqual:classifyTableview1]) {
        static NSString *myTabelviewCell = @"classCell";
        classCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"classCell" owner:self options:nil] lastObject];
            
        }
        StatusDoubleModel *model=[classifyArray1 objectAtIndex:indexPath.row];
        cell.titleLab.text=model.statusDoubleName;
        cell.right.hidden=YES;
        return cell;
    }else if ([tableView isEqual:priceTableview]) {
        static NSString *myTabelviewCell = @"classCell";
        classCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"classCell" owner:self options:nil] lastObject];
            
        }

        StatusModel *model=[priceArray objectAtIndex:indexPath.row];
        cell.titleLab.text=model.statusName;
        cell.right.hidden=YES;
        return cell;
    }
    
    return nil;
    
}
-(void)cellButtonClick:(UIButton *)btn{
    NSLog(@"btn.tag=%ld",(long)btn.tag);
    NSInteger theFew=btn.tag/10000;
    goodsModel *model=[dataArray objectAtIndex:btn.tag%10000];
    if (theFew==1) {
        //编辑
        goodseditViewController *gvc=[[goodseditViewController alloc]init];
        gvc.model=model;
        [self.navigationController pushViewController:gvc animated:YES];
    }else if (theFew==2) {
        //下架
//        NSIndexPath *index = [NSIndexPath indexPathForItem:btn.tag%10000 inSection:0];
//        goodsListCell *cell = [goodsTabView cellForRowAtIndexPath:index];
        NSInteger s=[model.goods_status integerValue];
        if (s==0) {
            //0为上架
            [OHAlertView showAlertWithTitle:@"确定下架此商品？" message:@"" cancelButton:nil otherButtons:@[@"取消",@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                if(buttonIndex==0){
                }else{
                    [self getGoodsSaleMulitId:model];
                  
                }
            }];

        }else if (s==1){
            //1为在仓库中
            [OHAlertView showAlertWithTitle:@"确定上架此商品？" message:@"" cancelButton:nil otherButtons:@[@"取消",@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                if(buttonIndex==0){
                }else{
                    [self getGoodsSaleMulitId:model];
                }
            }];
        }else if (s==2){
            //2为定时自动上架
            [OHAlertView showAlertWithTitle:@"该商品已经定时自动上架" message:@"是否提前手动上架？" cancelButton:nil otherButtons:@[@"取消",@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                if(buttonIndex==0){
                }else{
                    [self getGoodsSaleMulitId:model];
                }
            }];
        }else if (s==3){
            //3为店铺过期自动下架
            [OHAlertView showAlertWithTitle:@"该商品店铺过期会自动下架" message:@"是否提前手动下架？" cancelButton:nil otherButtons:@[@"取消",@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                if(buttonIndex==0){
                }else{
                    [self getGoodsSaleMulitId:model];
                }
            }];
        }else if (s==-1){
            //-1为手动下架状态
            [OHAlertView showAlertWithTitle:@"确定上架此商品？" message:@"" cancelButton:nil otherButtons:@[@"取消",@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                if(buttonIndex==0){
                }else{
                    [self getGoodsSaleMulitId:model];
                }
            }];

        }else if (s==-2){
            //-2为违规下架状态
            [OHAlertView showAlertWithTitle:@"提示" message:@"该商品违规下架" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            }];

        }else if (s==-5){
            //-5为平台未审核
            [OHAlertView showAlertWithTitle:@"该商品上架申请已经提交后台审核。" message:@"请等待。" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            }];
        }else if (s==-6){
            //-6平台审核拒绝
            [OHAlertView showAlertWithTitle:@"提示" message:@"该商品上架申请被后台拒绝。" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            }];
        }
    }else if (theFew==3) {
        //分享
    }else if (theFew==4) {
        //删除
        [OHAlertView showAlertWithTitle:@"确定删除此商品？" message:@"" cancelButton:nil otherButtons:@[@"取消",@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            if(buttonIndex==0){
            }else{
                [self getGoodsDeleteMulitId:model.goods_id];
            }
        }];
    }
}
#pragma mark -下架请求
-(void)getGoodsSaleMulitId:(goodsModel *)model{
    [MyObject startLoading];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,STORE_GOODS_DOWN_SHELVES_URL];
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken],
                          @"mulitId":model.goods_id
                          };
    [myAfnetwork netWorkingURL:urlStr parameters:par andWay:@"post" getParseSuccess:^(myselfParse *parse) {
        NSDictionary *dicBig=parse.dicBig;
        NSLog(@"%@",dicBig);
        NSString *str=[dicBig objectForKey:@"success"];
        if (str) {
            NSInteger s=[model.goods_status intValue];
            if (s==1||s==2||s==-1) {
                [MyObject failedPrompt:@"上架成功"];
                 [self getIndex:orderBy andorderType:@"asc" andGoods_status:status andUser_goodsclass_id:classID andGoods_name:@"" andBegincount:@"0" andSelectcount:[NSString stringWithFormat:@"%d",count*10]];
            }else{
                [MyObject failedPrompt:@"下架成功"];
                [self getIndex:orderBy andorderType:@"asc" andGoods_status:status andUser_goodsclass_id:classID andGoods_name:@"" andBegincount:@"0" andSelectcount:[NSString stringWithFormat:@"%d",count*10]];
            }
        }
        [MyObject endLoading];
    }getParsefailure:^{
        [MyObject failedPrompt:@"网络这在开小差"];
        [MyObject endLoading];
    }];
}
#pragma mark -删除请求
-(void)getGoodsDeleteMulitId:(NSString *)mulitId{
    [MyObject startLoading];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,STORE_GOODS_DELETE_URL];
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken],
                          @"mulitId":mulitId
                          };
    [myAfnetwork netWorkingURL:urlStr parameters:par andWay:@"post" getParseSuccess:^(myselfParse *parse) {
        NSDictionary *dicBig=parse.dicBig;
        NSLog(@"%@",dicBig);
        NSString *str=[dicBig objectForKey:@"success"];
        if (str) {
            [MyObject failedPrompt:@"删除成功"];
            [self headerRereshing];
        }
        [MyObject endLoading];
    }getParsefailure:^{
        [MyObject failedPrompt:@"网络这在开小差"];
        [MyObject endLoading];
    }];
}
-(void)tapClick //三个状态按钮的点击事件
{
    for (int i=0; i<3; i++)
    {
        UIButton *btn=(UIButton *)[self.view viewWithTag:1003+i];
        btn.selected=NO;
        
    }
    optionImageview.hidden=YES;
    optionBg.hidden=YES;
}
//各个tableView里cell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:goodsTabView])//商品列表
    {
        goodsModel *model=[dataArray objectAtIndex:indexPath.row];
        NSLog(@"%@",model);
        GoodsPreviewViewController *gpvc=[[GoodsPreviewViewController alloc]init];
        gpvc.model=model;
        [self.navigationController pushViewController:gpvc animated:YES];
        
    }else if ([tableView isEqual:statusTableview])//商品状态列表
    {
        StatusModel *model=[statusArray objectAtIndex:indexPath.row];
        [status setString:model.statusID];
        [self getIndex:orderBy andorderType:@"asc" andGoods_status:status andUser_goodsclass_id:classID andGoods_name:@"" andBegincount:@"0" andSelectcount:@"10"];
        
        UILabel *lab=(UILabel *)[self.view viewWithTag:100];
        lab.text=model.statusName;
        [tableView reloadData];
        [self tapClick];
        
    }else if ([tableView isEqual:classifyTableview])//商品分类一级列表
    {
        UITableViewCell *cell = [classifyTableview cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor=UIColorFromRGB(0X4c4c4c);
        NSString *str=[classifyArray objectAtIndex:indexPath.row];
        UILabel *lab=(UILabel *)[self.view viewWithTag:101];
        lab.text=str;
        
        if (indexPath.row==0) {
        classID=[[NSMutableString alloc]init];
        [self getIndex:orderBy andorderType:@"asc" andGoods_status:status andUser_goodsclass_id:classID andGoods_name:@"" andBegincount:@"0" andSelectcount:@"10"];
            [self tapClick];
        }else{
        
            [self getNextClass:indexPath.row-1];
            
        }
    }else if ([tableView isEqual:classifyTableview1])//商品分类二级列表
    {
        StatusDoubleModel *model=[classifyArray1 objectAtIndex:indexPath.row];
        [classID setString:[NSString stringWithFormat:@"%@",model.statusDoubleID]];
        [self getIndex:orderBy andorderType:@"asc" andGoods_status:status andUser_goodsclass_id:classID andGoods_name:@"" andBegincount:@"0" andSelectcount:@"10"];
        [self tapClick];
    }else if ([tableView isEqual:priceTableview])//排序方式列表
    {
        
        flag=!flag;
        StatusModel *model=[priceArray objectAtIndex:indexPath.row];
        [orderBy setString:model.statusID];
        if (flag==NO) {
            [self getIndex:orderBy andorderType:@"asc" andGoods_status:status andUser_goodsclass_id:classID andGoods_name:@"" andBegincount:@"0" andSelectcount:@"10"];
        }else
        {
        [self getIndex:orderBy andorderType:@"desc" andGoods_status:status andUser_goodsclass_id:classID andGoods_name:@"" andBegincount:@"0" andSelectcount:@"10"];
        
        }
        
        [self tapClick];
        UILabel *lab=(UILabel *)[self.view viewWithTag:102];
        lab.text=model.statusName;
    }
    
    
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
