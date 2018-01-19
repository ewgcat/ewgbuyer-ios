//
//  MyorderDetailViewController.m
//  SellerApp
//
//  Created by apple on 15/5/13.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MyorderDetailViewController.h"
#import "payoffDetailCell.h"
#import "MyOrderViewController.h"

@interface MyorderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UILabel *label_prompt;//提示label
    UIView *loadingV;//正在加载视图
    UIView *faildV;//加载失败视图
    UITableView *myTableView;
    myselfParse *_myParse;
    NSMutableArray *dataArray;
}

@end



@implementation MyorderDetailViewController

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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"账单详情";
    [self createBackBtn];
    if (UIDeviceSystem>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    dataArray = [[NSMutableArray alloc]init];
    if (ScreenFrame.size.height>480) {//说明是5 5s
        myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    }else{
        myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    }
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    myTableView.delegate = self;
    myTableView.dataSource=  self;
    myTableView.backgroundColor = GRAY_COLOR;
    myTableView.showsVerticalScrollIndicator=NO;
    myTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:myTableView];
    
    [self noticeCreate];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self netJson];
}
#pragma mark - 提示
-(void)noticeCreate{
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
    
    loadingV=[LJControl loadingView:CGRectMake((self.view.frame.size.width-100)/2, (self.view.frame.size.height-59-100)/2, 100, 100)];
    [self.view addSubview:loadingV];
    
    label_prompt =[LJControl labelFrame:CGRectMake(50, self.view.frame.size.height-100, self.view.frame.size.width-100, 30) setText:@"" setTitleFont:17 setbackgroundColor:[UIColor blackColor] setTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    [label_prompt.layer setMasksToBounds:YES];
    [label_prompt.layer setCornerRadius:4.0];
    label_prompt.alpha = 0.8;
    label_prompt.hidden = YES;
    [self.view addSubview:label_prompt];
}
-(void)loadingNet{
    loadingV.hidden = NO;
    [self netJson];
}
#pragma mark -  请求
-(void)netJson{
    MyOrderViewController *mm = [MyOrderViewController sharedUserDefault];
    NSArray *fileContent2 = USER_INFORMATION;
    NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&id=%@",SELLER_URL,PAYOFFLOG_DETAIL_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],mm.order_id];
    [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
        loadingV.hidden = YES;
        faildV.hidden = YES;
        _myParse = myParse;
        [self analyze:_myParse.dicBig];
    } failure:^(){
        loadingV.hidden = YES;
        faildV.hidden = NO;
    } ];
}
#pragma mark -  数据解析
-(void)analyze:(NSDictionary *)dicBig{
    MyOrderViewController *order = [MyOrderViewController sharedUserDefault];
    [dataArray removeAllObjects];
    Model *mm = [[Model alloc]init];
    if (order.payoffTag == 0 || order.payoffTag == 1) {
        mm.addTime = [dicBig objectForKey:@"addTime"];
        mm.commission_amount = [dicBig objectForKey:@"commission_amount"];
        mm.o_id = [dicBig objectForKey:@"o_id"];
        mm.order_total_price = [dicBig objectForKey:@"order_total_price"];
        mm.payoff_type = [dicBig objectForKey:@"payoff_type"];
        mm.pl_info = [dicBig objectForKey:@"pl_info"];
        mm.pl_sn = [dicBig objectForKey:@"pl_sn"];
        mm.total_amount = [dicBig objectForKey:@"total_amount"];
    }else if (order.payoffTag == 3){
        mm.apply_time = [dicBig objectForKey:@"apply_time"];
        mm.addTime = [dicBig objectForKey:@"addTime"];
        mm.commission_amount = [dicBig objectForKey:@"commission_amount"];
        mm.o_id = [dicBig objectForKey:@"o_id"];
        mm.order_total_price = [dicBig objectForKey:@"order_total_price"];
        mm.payoff_type = [dicBig objectForKey:@"payoff_type"];
        mm.pl_info = [dicBig objectForKey:@"pl_info"];
        mm.pl_sn = [dicBig objectForKey:@"pl_sn"];
        mm.total_amount = [dicBig objectForKey:@"total_amount"];
    }else if (order.payoffTag == 6){
        mm.apply_time = [dicBig objectForKey:@"apply_time"];
        mm.addTime = [dicBig objectForKey:@"addTime"];
        mm.commission_amount = [dicBig objectForKey:@"commission_amount"];
        mm.complete_time = [dicBig objectForKey:@"complete_time"];
        mm.o_id = [dicBig objectForKey:@"o_id"];
        mm.order_total_price = [dicBig objectForKey:@"order_total_price"];
        mm.payoff_remark = [dicBig objectForKey:@"payoff_remark"];
        mm.payoff_type = [dicBig objectForKey:@"payoff_type"];
        mm.pl_info = [dicBig objectForKey:@"pl_info"];
        mm.pl_sn = [dicBig objectForKey:@"pl_sn"];
        mm.reality_amount = [dicBig objectForKey:@"reality_amount"];
        mm.total_amount = [dicBig objectForKey:@"total_amount"];
    }
    [dataArray addObject:mm];
    [myTableView reloadData];
}
#pragma mark -  tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrderViewController *order = [MyOrderViewController sharedUserDefault];
    if(order.payoffTag == 0 || order.payoffTag == 1){
        return 7*44+40;
    }else if (order.payoffTag == 3){
        return 9*44+40;
    }else{
        return 12*44+40;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"payoffDetailCell";
    payoffDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"payoffDetailCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = GRAY_COLOR;
    }
    if (dataArray.count!=0) {
        Model *mmm = [dataArray objectAtIndex:0];
        [cell my_cell:mmm];
    }
    return cell;
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
