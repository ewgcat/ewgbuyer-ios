//
//  MyOrderViewController.m
//  SellerApp
//
//  Created by apple on 15-3-24.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MyOrderViewController.h"
#import "PayofflogCell.h"
#import "MyorderDetailViewController.h"
#import "MJRefresh.h"
#import "sqlService.h"

@interface MyOrderViewController (){
    myselfParse *_myParse;
    UIView *nodata;//空状态视图
    NSMutableDictionary *cellDict;//记录cell的选中状态
    BOOL allBool;
}

@end

static MyOrderViewController *singleInstance=nil;

@implementation MyOrderViewController

@synthesize payoffTag;

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
    [self createMultiSel];
    myOrderTableView.allowsMultipleSelectionDuringEditing = YES;
    dataArray = [[NSMutableArray alloc]init];
    dataPullArray = [[NSMutableArray alloc]init];
    payoffTag = 0;
    btnClickedBool = NO;
    requestBool = NO;
    allBool = NO;
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    self.title = @"我的账单";
    self.view.backgroundColor = GRAY_COLOR;
    [self createBackBtn];
    
    NSArray *array=@[@"未结算",@"可结算",@"结算中",@"已结算"];
    UISegmentedControl *segmentControl=[[UISegmentedControl alloc]initWithItems:array];
    segmentControl.frame=CGRectMake(10, 74, ScreenFrame.size.width-20, 40);
    segmentControl.selectedSegmentIndex=0;
    segmentControl.tintColor = NAV_COLOR;
    [segmentControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    segmentControl.backgroundColor = [UIColor whiteColor];
    _segmentControl = segmentControl;
    [self.view addSubview:segmentControl];
    
    if (UIDeviceSystem>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    myOrderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+124, ScreenFrame.size.width, ScreenFrame.size.height-124)];
    //添加空状态视图
    nodata = [MyObject noDataViewForTableView:myOrderTableView];
    myOrderTableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    myOrderTableView.delegate = self;
    myOrderTableView.dataSource=  self;
    myOrderTableView.backgroundColor = GRAY_COLOR;
    myOrderTableView.showsVerticalScrollIndicator=NO;
    myOrderTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:myOrderTableView];
    
    myOrderTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    myOrderTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    
    faildV = [LJControl netFaildView];
    faildV.hidden = YES;
    [self.view addSubview:faildV];
    UIButton *buttonR = [LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake((ScreenFrame.size.width-100)/2, 370, 100, 44) setNormalImage:[UIImage imageNamed:@""] setSelectedImage:[UIImage imageNamed:@""] setTitle:@"重新加载" setTitleFont:17 setbackgroundColor:[UIColor clearColor]];
    [buttonR addTarget:self action:@selector(loadingNet) forControlEvents:UIControlEventTouchUpInside];
    [buttonR setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [buttonR.layer setMasksToBounds:YES];
    [buttonR.layer setCornerRadius:8];
    buttonR.layer.borderWidth = 1;
    buttonR.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [faildV addSubview:buttonR];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    _segmentControl.selectedSegmentIndex = 0;
    [self change:_segmentControl];
    [self clearAll];
    [self netJson];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _multiSelectBar.hidden = YES;
}
#pragma mark - 多选相关
//点击全选
-(void)multiSelClicked:(MultiSelectBar *)multiSelectBar{
    allBool = !allBool;
    if (!dataArray||dataArray.count == 0||payoffTag != 1) {
        return;
    }
    
    for (NSInteger i =0; i<dataArray.count; i ++) {
        [self markRow:i sel:allBool];
    }
    [self refreshTotal];
    [myOrderTableView reloadData];
}
//点击结算
-(void)payOffClicked:(MultiSelectBar *)multiSelectBar{
    //拼接结算单ID
    NSString *str = @"";
    NSArray *rows = [self selectedRows];
    for (NSString *row in rows) {
        NSInteger row1 = row.integerValue;
        Model *model = dataArray[row1];
        NSString *str1 = [NSString stringWithFormat:@"%@",model.goods_id];
        str = [[str stringByAppendingString:str1]stringByAppendingString:@","];
    }
    
    if ([str isEqualToString:@""]) {
        [MyObject failedPrompt:@"没有选择订单!"];
    }else{
        NSInteger len = str.length;
        str = [str substringToIndex:len-1];
        NSLog(@"点击结算...%@",str);
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,PAYOFFLOG_COMMIT];
        NSDictionary *par = @{
                              @"user_id":[MyNetTool currentUserID],
                              @"token":[MyNetTool currentToken],
                              @"mulitId":str
                              };
        [MyObject startLoading];
        [[MyNetTool managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dict = responseObject;
            NSString *ret = dict[@"ret"];
            if (ret.intValue == 100) {
                //提交成功,刷新列表
                [MyObject failedPrompt:@"提交成功!"];
                [self clearAmount];
                [self netJson];
            }else if (ret.intValue == -200){
                [MyObject failedPrompt:@"非结算日"];
            }else if (ret.intValue == -300){
                [MyObject failedPrompt:@"订单状态错误"];
            }else if (ret.intValue == -100){
                [MyObject failedPrompt:@"提交失败"];
            }else {
                [MyObject failedPrompt:@"未知错误"];
            }
            [MyObject endLoading];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\nerror:%@\n",NSStringFromClass([self class]),__func__,__LINE__,[error localizedDescription]);
            [MyObject endLoading];
        }];
    }
    cellDict = [NSMutableDictionary new];
}
//创建底部全选栏
-(void)createMultiSel{
    MultiSelectBar *multiSelectBar = [[[NSBundle mainBundle]loadNibNamed:@"MultiSelectBar" owner:nil options:nil]lastObject];
    CGFloat h = 44.f;
    multiSelectBar.frame = CGRectMake(0, ScreenFrame.size.height - h, ScreenFrame.size.width, h);
    _multiSelectBar = multiSelectBar;
    multiSelectBar.delegate = self;
    multiSelectBar.hidden = YES;
    [self.navigationController.view addSubview:multiSelectBar];
}
//清除全选栏金额
-(void)clearAmount{
    cellDict = [NSMutableDictionary dictionary];
    _multiSelectBar.payOffAmountLabel.text = @"结算金额:￥0.00";
    _multiSelectBar.multiSelectBtn.selected = NO;
}
//标记是否选择
-(void)markRow:(NSInteger)row sel:(BOOL)sel{
    NSString *key = [NSString stringWithFormat:@"%ld",(long)row];
    NSString *value;
    if (sel) {
        value = @"yes";
    }else {
        value = @"no";
    }
    cellDict[key] = value;
}
//判断该列是否被选择
-(BOOL)rowIsSelected:(NSInteger)row{
    NSString *key = [NSString stringWithFormat:@"%ld",(long)row];
    NSString *value = cellDict[key];
    if ([value isEqualToString:@"yes"]) {
        return YES;
    }
    return NO;
}
//取得所有选择的列
-(NSArray *)selectedRows {
    NSArray *arr = [cellDict allKeysForObject:@"yes"];
    return arr;
}

//刷新当前总价
-(void)refreshTotal{

    NSArray *selRows = [self selectedRows];
    float total = 0;
    if (dataArray == nil || dataArray.count == 0||payoffTag != 1) {
        _multiSelectBar.payOffAmountLabel.text = [NSString stringWithFormat:@"结算金额:¥0.00"];
        return;
    }
    for (NSString *row1 in selRows) {
        NSInteger row = row1.integerValue;
        Model *model = [dataArray objectAtIndex:row];
        float price = model.totalPrice.floatValue;
        total += price;
    }
    _multiSelectBar.payOffAmountLabel.text = [NSString stringWithFormat:@"结算金额:¥%.2f",total];
}
//点单选
-(IBAction)checkBtnClicked:(UIButton *)btn flag:(BOOL)flag{
    btn.selected = !btn.isSelected;
    [self markRow:btn.tag sel:btn.selected];
    if (allBool) {
        allBool = NO;
        _multiSelectBar.multiSelectBtn.selected = NO;
    }
    NSArray *rows = [self selectedRows];
    if (rows.count == dataArray.count) {
        allBool = YES;
        _multiSelectBar.multiSelectBtn.selected = YES;
    }
    
    [myOrderTableView reloadData];
    [self refreshTotal];
}
-(void)clearAll{
    _multiSelectBar.multiSelectBtn.selected = NO;
    allBool = NO;
    cellDict = [NSMutableDictionary dictionary];
    [self refreshTotal];
    [myOrderTableView reloadData];
}
#pragma mark - seg点击事件
-(void)change:(UISegmentedControl *)segmentControl{
    btnClickedBool = YES;
    [MyObject startLoading];
    if (segmentControl.selectedSegmentIndex == 0) {
        payoffTag = 0;
        lblWeijiesuan.textColor = [UIColor redColor];
        lblKejiesuan.textColor = [UIColor blackColor];
        lblJiesuanzhong.textColor = [UIColor blackColor];
        lblYijiesuan.textColor = [UIColor blackColor];
        [self netJson];
    }else if(segmentControl.selectedSegmentIndex == 1){
        //可结算
        payoffTag = 1;
        lblWeijiesuan.textColor = [UIColor blackColor];
        lblKejiesuan.textColor = [UIColor redColor];
        lblJiesuanzhong.textColor = [UIColor blackColor];
        lblYijiesuan.textColor = [UIColor blackColor];
        [self clearAll];
        [self netJson];
    }else if(segmentControl.selectedSegmentIndex == 2){
        payoffTag = 3;
        lblWeijiesuan.textColor = [UIColor blackColor];
        lblKejiesuan.textColor = [UIColor blackColor];
        lblJiesuanzhong.textColor = [UIColor redColor];
        lblYijiesuan.textColor = [UIColor blackColor];
        [self netJson];
    }else{
        payoffTag = 6;
        lblWeijiesuan.textColor = [UIColor blackColor];
        lblKejiesuan.textColor = [UIColor blackColor];
        lblJiesuanzhong.textColor = [UIColor blackColor];
        lblYijiesuan.textColor = [UIColor redColor];
        [self netJson];
    }
}
#pragma mark -  网络
-(void)netJson{
    NSArray *fileContent2 = USER_INFORMATION;
    NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&begin_count=%d&select_count=%d&status=%@",SELLER_URL,PAYOFFLOG_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],0,10,[NSString stringWithFormat:@"%d",(int)payoffTag]];
    [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
        [MyObject endLoading];
        faildV.hidden = YES;
        _myParse = myParse;
        [self analyze:_myParse.dicBig];
    } failure:^(){
        [MyObject endLoading];
        faildV.hidden = NO;
    } ];
}
-(void)loadingNet{
    [MyObject startLoading];
    [self netJson];
}
-(void)analyze:(NSDictionary *)dicBig{
    [dataArray removeAllObjects];
    NSLog(@"dicBig:%@",dicBig);
    NSArray *arr = [_myParse.dicBig objectForKey:@"payofflog_list"];
    
    float amount = 0;
    for(NSDictionary *dic in arr){
        Model *mmm = [[Model alloc]init];
        mmm.addTime = [dic objectForKey:@"addTime"];
        mmm.goods_id = [dic objectForKey:@"id"];
        mmm.invoiceType = [dic objectForKey:@"payoff_type"];
        mmm.order_num = [dic objectForKey:@"pl_sn"];
        mmm.totalPrice = [dic objectForKey:@"total_amount"];
        float price = mmm.totalPrice.floatValue;
        amount += price;
        mmm.order_status = [NSString stringWithFormat:@"%d",(int)payoffTag];
        [dataArray addObject:mmm];
    }
    if (amount != 0 && payoffTag == 1) {
        _multiSelectBar.hidden = NO;
    }else{
        _multiSelectBar.hidden = YES;
    }
    [myOrderTableView.mj_header endRefreshing];
    [myOrderTableView reloadData];
    

}
#pragma mark -  tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return dataArray.count;
    if (dataArray.count!=0)
    {
        tableView.backgroundView = nil;
        return dataArray.count;
    }
    else{
        tableView.backgroundView = nodata;
        return 0;
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"PayofflogCell";

    PayofflogCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PayofflogCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        for (UIView *subView in cell.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    if (dataArray.count!=0) {
        Model *mmm = [dataArray objectAtIndex:indexPath.row];
        [cell my_cell:mmm];
        cell.checkBtn.tag = indexPath.row;
        
        
        NSString *key = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        NSNumber *num = [cellDict valueForKey:key];
        if (num) {
            BOOL sel = num.boolValue;
            cell.checkBtn.selected = sel;
        }else {
            cell.checkBtn.selected = NO;
        }
        if (allBool) {
            cell.checkBtn.selected = YES;
            [self markRow:indexPath.row sel:YES];
        }
        
        [cell.checkBtn addTarget:self action:@selector(checkBtnClicked:flag:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self refreshTotal];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (dataArray.count!=0) {
        Model *mode = [dataArray objectAtIndex:indexPath.row];
        _order_id = [NSString stringWithFormat:@"%@",mode.goods_id];
        MyorderDetailViewController *detail = [[MyorderDetailViewController alloc]init];
        [self.navigationController pushViewController:detail animated:YES];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selected = NO;
    }
}

#pragma mark - 返回按钮
-(void)createBackBtn{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
    button.frame =CGRectMake(0, 0, 44, 44);
    [button setBackgroundImage:[UIImage imageNamed:@"back_lj"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font  = [UIFont systemFontOfSize:14];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 上拉刷新
-(void)footerRereshing{
    [self pullNet];
}
-(void)headerRefresh{
    allBool = NO;
    [self netJson];
    [self clearAmount];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)analyzePull:(NSDictionary *)dicBig{
    if (dicBig) {
        if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"]){
            [self.navigationController popToRootViewControllerAnimated:NO];
            //登录过期 提示重新登录
            [MyObject failedPrompt:@"用户登录已过期，请重新登录"];
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
        }else{
            [dataPullArray removeAllObjects];
            NSArray *arr = [_myParse.dicBig objectForKey:@"payofflog_list"];
            for(NSDictionary *dic in arr){
                Model *mmm = [[Model alloc]init];
                mmm.addTime = [dic objectForKey:@"addTime"];
                mmm.goods_id = [dic objectForKey:@"id"];
                mmm.invoiceType = [dic objectForKey:@"payoff_type"];
                mmm.order_num = [dic objectForKey:@"pl_sn"];
                mmm.totalPrice = [dic objectForKey:@"total_amount"];
                mmm.order_status = [NSString stringWithFormat:@"%d",(int)payoffTag];
                [dataPullArray addObject:mmm];
            }
            [dataArray addObjectsFromArray:dataPullArray];
            [myOrderTableView reloadData];
            requestBool = YES;
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [myOrderTableView reloadData];
        [myOrderTableView.mj_footer endRefreshing];
    });
}
-(void)doTimer_signout{
    [LJControl cleanAll];
    AppDelegate *app = [AppDelegate sharedUserDefault];
    app.log_View.hidden = NO;
}
-(void)clearCacheSuccessOut{
    NSLog(@"成功");
}

//上拉刷新请求
-(void)pullNet{
    NSArray *fileContent2 = USER_INFORMATION;
    NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&begin_count=%d&select_count=%d&status=%@",SELLER_URL,PAYOFFLOG_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],(int)dataArray.count,10,[NSString stringWithFormat:@"%d",(int)payoffTag]];
    [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
        [MyObject endLoading];
        faildV.hidden = YES;
        _myParse = myParse;
        [self analyzePull:_myParse.dicBig];
    } failure:^(){
        [MyObject endLoading];
        faildV.hidden = NO;
    } ];
}

@end
