//
//  MyConsultViewController.m
//  My_App
//
//  Created by shiyuwudi on 15/11/26.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import "MyConsultViewController.h"
#import "SecondViewController.h"
#import "ConsultFrameModel.h"
#import "ConsultModel.h"
#import "SYConsultCell.h"
#import "DetailViewController.h"

#define hasReplyKey @"hasReply"
#define hasNoReplyKey @"hasNoReply"

@interface MyConsultViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    ASIFormDataRequest *request_2;
    ASIFormDataRequest *request_3;
}

@property (nonatomic,weak)UIView *redBar;
@property (nonatomic, strong)NSMutableArray *tableViewArray;
@property (nonatomic, weak)UIScrollView *scrollView;
@property (nonatomic,strong)NSMutableDictionary * consultDict;
@property (nonatomic,strong)NSMutableArray *btnArray;
@property (nonatomic,weak)UIButton *currentBtn;

@end

@implementation MyConsultViewController

#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    _consultDict = [NSMutableDictionary dictionary];
    [self setupUI];
    [self netRequest];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
#pragma mark - 网络请求
-(void)netRequest{
    self.view.backgroundColor = [UIColor whiteColor];
    //取得用户信息
    BOOL login;
    NSArray *fileArray = [SYObject hasUserLogedIn:&login];
    if (login==NO) {
        return;
    }
    NSString *user_id = fileArray[3];
    NSString *token = fileArray[1];
    
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,MY_CONSULT_URL];
    NSURL *url = [NSURL URLWithString:urlStr];
    //已回复
    NSArray *keyArr = @[@"user_id",@"beginCount",@"selectCount",@"reply",@"token"];
    NSArray *valueArr = @[user_id,@"0",@"20",@"true", token];
    request_2 = [ASIFormDataRequest requestWithURL:url];
    for(int i=0;i<keyArr.count;i++){
        [request_2 setPostValue:[valueArr objectAtIndex:i] forKey:[keyArr objectAtIndex:i]];
    }
    request_2.delegate =self;
    [request_2 setRequestHeaders:[LJControl requestHeaderDictionary]];
    [request_2 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
    [request_2 startAsynchronous];
    //未回复
    keyArr = @[@"user_id",@"beginCount",@"selectCount",@"reply",@"token"];
    valueArr = @[user_id,@"0",@"20",@"false", token];
    request_3 = [ASIFormDataRequest requestWithURL:url];
    for(int i=0;i<keyArr.count;i++){
        [request_3 setPostValue:[valueArr objectAtIndex:i] forKey:[keyArr objectAtIndex:i]];
    }
    request_3.delegate =self;
    [request_3 setRequestHeaders:[LJControl requestHeaderDictionary]];
    [request_3 setDidFinishSelector:@selector(my2_urlRequestSucceeded:)];
    [request_3 startAsynchronous];
}
//已回复
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSArray *datas = dicBig[@"datas"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dict1 in datas) {
            ConsultModel *dataModel = [ConsultModel consultModelWithDict:dict1];
            ConsultFrameModel *frameModel = [[ConsultFrameModel alloc]init];
            [frameModel setDataAndCalcFrame:dataModel];
            [arr addObject:frameModel];
        }
        [_consultDict setObject:arr forKey:hasReplyKey];
        [_tableViewArray[0] reloadData];
        [_tableViewArray[1] reloadData];
        if (datas==nil||datas.count==0) {
            UITableView *tv = _tableViewArray[1];
            tv.backgroundView = [SYObject noDataView];
        }
    }
}
//未回复
-(void)my2_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSArray *datas = dicBig[@"datas"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dict1 in datas) {
            ConsultModel *dataModel = [ConsultModel consultModelWithDict:dict1];
            ConsultFrameModel *frameModel = [[ConsultFrameModel alloc]init];
            [frameModel setDataAndCalcFrame:dataModel];
            [arr addObject:frameModel];
        }
        [_consultDict setObject:arr forKey:hasNoReplyKey];
        [_tableViewArray[0] reloadData];
        [_tableViewArray[1] reloadData];
        if (datas==nil||datas.count==0) {
            UITableView *tv = _tableViewArray[0];
            tv.backgroundView = [SYObject noDataView];
        }
    }
}
#pragma mark - UI构建
-(void)setupUI{
    self.title = @"我的咨询";
    [self setupHeadNavi];
    [self setupTableView];
    [self createBackBtn];
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
-(void)setupHeadNavi{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 44)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    NSArray *titleArray = @[@"未回复咨询",@"已回复咨询"];
    NSMutableArray *btnArray = [NSMutableArray array];
    _btnArray = btnArray;
    for (int i=0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:SY_COLOR_RED forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:15];
        btn.frame = CGRectMake(i*headView.frame.size.width*0.5, 0, headView.frame.size.width*0.5, headView.frame.size.height);
        [btnArray addObject:btn];
        [headView addSubview:btn];
        [btn addTarget:self action:@selector(headNaviBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    _currentBtn = btnArray[0];
    UIView *redBar = [[UIView alloc]init];
    redBar.backgroundColor = SY_COLOR_RED;
    UIButton *btn1 = btnArray[0];
    redBar.frame = CGRectMake(btn1.frame.origin.x, 0.95*btn1.frame.size.height, btn1.frame.size.width, 0.05*btn1.frame.size.height);
    [headView addSubview:redBar];
    btn1.selected = YES;
    _redBar = redBar;
}
-(IBAction)headNaviBtnClicked:(id)sender{
    _currentBtn.selected = NO;
    _currentBtn = sender;
    _currentBtn.selected = YES;
    //移动提示条
    CGRect frame = _redBar.frame;
    CGFloat x = _currentBtn.frame.origin.x;
    frame.origin.x = x;
    NSInteger index = [_btnArray indexOfObject:sender];
    [UIView animateWithDuration:0.3 animations:^{
        _redBar.frame = frame;
    }];
    [_scrollView setContentOffset:CGPointMake(index * ScreenFrame.size.width,0) animated:YES];
}
-(void)setupTableView{
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, ScreenFrame.size.width, ScreenFrame.size.height-64-44)];
    _scrollView = scrollView;
    scrollView.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:scrollView];
    scrollView.delegate = self;
    
    NSMutableArray *tableViewArray = [NSMutableArray array];
    self.tableViewArray = tableViewArray;
    for (int i=0; i<2; i++) {
        CGRect frame = CGRectMake(i*ScreenFrame.size.width, 0, ScreenFrame.size.width, ScreenFrame.size.height-64-44);
        UITableView *tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableViewArray addObject:tableView];
        [scrollView addSubview:tableView];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = BACKGROUNDCOLOR;
    }
    scrollView.contentSize = CGSizeMake(tableViewArray.count*ScreenFrame.size.width, ScreenFrame.size.height-64-44);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
}

#pragma mark -tableView数据源方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SYConsultCell *cell = [SYConsultCell consultCellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([_tableViewArray indexOfObject:tableView]==0) {
        //未回复
        NSArray *arr = [_consultDict objectForKey:hasNoReplyKey];
        cell.frameModel = arr[indexPath.row];
    }else if ([_tableViewArray indexOfObject:tableView]==1){
        //已回复
        NSArray *arr = [_consultDict objectForKey:hasReplyKey];
        cell.frameModel = arr[indexPath.row];
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_tableViewArray indexOfObject:tableView]==0) {
        //未回复
        NSArray *noReplyArr = [self.consultDict objectForKey:hasNoReplyKey];
        return noReplyArr.count;
    }else if ([_tableViewArray indexOfObject:tableView]==1){
        //已回复
        NSArray *hasReplyArr = [self.consultDict objectForKey:hasReplyKey];
        return hasReplyArr.count;
    }else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_tableViewArray indexOfObject:tableView]==0) {
        //未回复
        NSArray *noReplyArr = [self.consultDict objectForKey:hasNoReplyKey];
        ConsultFrameModel *frameModel = noReplyArr[indexPath.row];
        return frameModel.cellHeight;
    }else if ([_tableViewArray indexOfObject:tableView]==1){
        //已回复
        NSArray *hasReplyArr = [self.consultDict objectForKey:hasReplyKey];
        ConsultFrameModel *frameModel = hasReplyArr[indexPath.row];
        return frameModel.cellHeight;
    }else{
        return 0;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //TODO:点击进入对应商品
    ConsultFrameModel *frameModel;
    if ([_tableViewArray indexOfObject:tableView]==0) {
        //未回复
        NSArray *noReplyArr = [self.consultDict objectForKey:hasNoReplyKey];
        frameModel = noReplyArr[indexPath.row];
    }else if ([_tableViewArray indexOfObject:tableView]==1){
        //已回复
        NSArray *hasReplyArr = [self.consultDict objectForKey:hasReplyKey];
        frameModel = hasReplyArr[indexPath.row];
    }
    ConsultModel *dataModel = frameModel.dataModel;
    DetailViewController *detailVC = [SYObject goodsDetailPageWithGoodsID:dataModel.goods_id];
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==_scrollView) {
        CGFloat x = scrollView.contentOffset.x;
        CGRect frame = _redBar.frame;
        CGFloat rate = x / ScreenFrame.size.width;
        frame.origin.x = rate * (ScreenFrame.size.width * 0.5);
        _redBar.frame = frame;
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView==_scrollView) {
        CGFloat x = scrollView.contentOffset.x;
        NSInteger index = x / ScreenFrame.size.width;
        [self headNaviBtnClicked:_btnArray[index]];
    }
}

@end
