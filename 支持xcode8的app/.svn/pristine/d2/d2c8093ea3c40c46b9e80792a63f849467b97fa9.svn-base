//
//  SYEvaluateViewController.m
//  My_App
//
//  Created by shiyuwudi on 15/11/30.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import "SYEvaluateViewController.h"
#import "SYOrderDetailsTableViewController.h"
#import "WaitForEvaluateCell.h"
#import "EGORefreshTableHeaderView.h"
#import "ThirdViewController.h"
#import "OrderDetailsViewController.h"
#import "EnsureestimateViewController.h"
#import "EvaAddModel.h"
#import "YYModel.h"
#import "EvaDetailViewController.h"
#import "ModifyEvaTableViewController.h"
#import "AddEvaluatetTableViewController.h"

#define ITEM_NUMBER_PER_PAGE 20

@interface SYEvaluateViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong)SYObject *obj;
@property (nonatomic,weak)UITableView *waitForEvaluateTV;
@property (nonatomic,weak)UITableView *finishedTV;
@property (nonatomic,strong)NSArray * waitForEvaluateArr;
@property (nonatomic,strong)NSArray * finishedArr;
@property (nonatomic,assign)NSInteger currentPart;

@end

@implementation SYEvaluateViewController

#pragma mark - 生命周期方法
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
     [self netRequestWithBeginCount:0 selectCount:ITEM_NUMBER_PER_PAGE];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    [self setupUI];
//    [self netRequestWithBeginCount:0 selectCount:ITEM_NUMBER_PER_PAGE];
    _currentPart = 0;
    [self createBackBtn];
}
#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1){  //关闭主界面的右滑返回
        return NO;
    }else{
        
        return YES;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//重写返回按钮
-(void)createBackBtn{
//    UIButton *button = [LJControl backBtn];
//    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem =bar;
}
//-(void)backBtnClicked{
//    [self.navigationController popViewControllerAnimated:YES];
//}
#pragma mark - 初始化操作
-(void)setupUI{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"订单评价";
    _waitForEvaluateArr = [NSArray array];
    _finishedArr = [NSArray array];
    _obj = [[SYObject alloc]init];
    NSArray *titleArr = @[@"待评价",@"已完成"];
    [_obj sy_addHeadNaviTitleArray:titleArr toContainerViewWithFrameSetted:self.view headerHeight:44.0 topMargin:0 testColor:NO normalFontSize:15.f selectedFontSize:15.f];
    _waitForEvaluateTV = _obj.tableViewArray[0];
    _finishedTV = _obj.tableViewArray[1];

    for (int i=0;i<_obj.tableViewArray.count;i++) {
        UITableView *tv = _obj.tableViewArray[i];
        tv.dataSource = self;
        tv.delegate = self;
        tv.frame = CGRectMake(i * ScreenFrame.size.width, 0, ScreenFrame.size.width, ScreenFrame.size.height - 44 -64);
        [tv addHeaderWithTarget:self action:@selector(headerRereshing)];
        [tv addFooterWithTarget:self action:@selector(footerRereshing)];
        // tv.separatorStyle = UITableViewCellSeparatorStyleNone;
        tv.tableFooterView = [UIView new];
    }
}


-(void)netRequestWithBeginCount:(NSInteger)beginCount selectCount:(NSInteger)selectCount{
//    loadingV.hidden = NO;
    [SYObject startLoading];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,ORDER_URL];
    //待评价
    NSDictionary *par = @{
                          @"user_id":[SYObject currentUserID],
                          @"token":[SYObject currentToken],
                          @"order_cat":@"0",
                          @"beginCount":@(beginCount),
                          @"selectCount":@(selectCount),
                          @"order_status":@"40"
                          };
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        NSArray *arr = dict[@"order_list"];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            Model *model = [[Model alloc]init];
            model.order_addTime = [dic objectForKey:@"addTime"];
            model.order_id = [dic objectForKey:@"order_id"];
            model.order_num = [dic objectForKey:@"order_num"];
            model.order_status = [dic objectForKey:@"order_status"];
            model.order_total_price = [dic objectForKey:@"order_total_price"];
            model.order_photo_list = [dic objectForKey:@"photo_list"];
            model.order_name_list = [dic objectForKey:@"name_list"];
            model.order_ship_price = [dic objectForKey:@"ship_price"];
            model.order_paytype = [dic objectForKey:@"payType"];
            [tempArr addObject:model];
        }
        _waitForEvaluateArr = tempArr;
        [_waitForEvaluateTV reloadData];
        if (tempArr==nil||tempArr.count==0) {
            _waitForEvaluateTV.backgroundView = [SYObject noDataView];
        }else{
            _waitForEvaluateTV.backgroundView = nil;
        }
        [SYObject endLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:@"请求出错，请重试"];
        [SYObject endLoading];
        _waitForEvaluateTV.backgroundView = [SYObject noDataView];
    }];
    //已完成
    NSString *urlStr1 = [NSString stringWithFormat:@"%@%@",FIRST_URL,EVA_ADD_URL];
    par = @{
            @"user_id":[SYObject currentUserID],
            @"token":[SYObject currentToken],
            @"beginCount":@(beginCount),
            @"selectCount":@(selectCount)
            };
    [[Requester managerWithHeader]POST:urlStr1 parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"已完成列表:%@",responseObject);
        NSDictionary *dict = responseObject;
        NSArray *arr = dict[@"data"];
        if ([dict[@"code"]intValue] == 10000 && [dict[@"result"] isEqualToString:@"SUCCESS"]&&arr&&arr.count>0) {
            NSMutableArray *tempArr = [NSMutableArray array];
            for (NSDictionary *eva in arr) {
                EvaAddModel *model = [EvaAddModel yy_modelWithDictionary:eva];
                [tempArr addObject:model];
            }
            _finishedArr = tempArr;
            [_finishedTV reloadData];
            _finishedTV.backgroundView = nil;
        }else{
            _finishedTV.backgroundView = [SYObject noDataView];
        }
        [SYObject endLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:@"请求出错，请重试"];
        _finishedTV.backgroundView = [SYObject noDataView];
        [SYObject endLoading];
    }];
}
-(void)headerRereshing{
    [self netRequestWithBeginCount:0 selectCount:ITEM_NUMBER_PER_PAGE];
    [_waitForEvaluateTV headerEndRefreshing];
    [_finishedTV headerEndRefreshing];
}
-(void)footerRereshing{
    self.currentPart += 1;
    [self netRequestWithBeginCount:0 selectCount:_currentPart*ITEM_NUMBER_PER_PAGE];
    [_waitForEvaluateTV footerEndRefreshing];
    [_finishedTV footerEndRefreshing];
}

//点击跳转订单详情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _waitForEvaluateTV) {
        NSArray *arr;
        arr = _waitForEvaluateArr;
        Model *model = arr[indexPath.row];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SYOrderStoryboard" bundle:nil];
        SYOrderDetailsTableViewController *or = [sb instantiateViewControllerWithIdentifier:@"orderDetails"];
        or.orderID = model.order_id;
        [self.navigationController pushViewController:or animated:YES];
    }else {
        //评价详情
        EvaDetailViewController *detailVC = [EvaDetailViewController evaDetailViewController];
        EvaAddModel *model = (EvaAddModel *)_finishedArr[indexPath.row];
        detailVC.model = model;
        detailVC.evaID = [NSString stringWithFormat:@"%ld",(long)model.evaluate_id];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 226.f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_waitForEvaluateTV) {
        return _waitForEvaluateArr.count;
    }else if (tableView==_finishedTV){
        return _finishedArr.count;
    }else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseid = @"WaitForEvaluateCell";
    WaitForEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseid];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"WaitForEvaluateCell" owner:self options:nil]lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (tableView==_waitForEvaluateTV) {
        
        Model *model = _waitForEvaluateArr[indexPath.row];
        cell.status.text = @"已收货";
        cell.orderNum.text = [NSString stringWithFormat:@"订单号 : %@",model.order_num];
        
        NSArray *list = (NSArray *)model.order_photo_list;
        NSArray *list1 = (NSArray *)model.order_name_list;
        
        CGFloat ww1 = 100;
        for (int i=0; i<list.count; i++) {
            NSString *name = list[i];
            NSURL *url = [NSURL URLWithString:name];
            UIImageView *iv = [[UIImageView alloc]init];
            UIImage *noData = [UIImage imageNamed:@"kong_lj"];
            [iv sd_setImageWithURL:url placeholderImage:noData];
            if (list.count == 1) {
                UILabel *label = [UILabel new];
                label.text = list1.firstObject;
                label.frame = CGRectMake(10+ww1+10, 20, ScreenFrame.size.width -10-10-ww1-10, 80);
                label.font=[UIFont systemFontOfSize:13];
                label.numberOfLines = 0;
                [cell.scrollView addSubview:label];
            }
            iv.frame = CGRectMake(10 +(ww1+10)*i, 10, ww1, ww1);
            [cell.scrollView addSubview:iv];
        }
        CGFloat ww2 = list.count * (ww1+10)+10;
        if (ww2 < ScreenFrame.size.width) {
            ww2 = ScreenFrame.size.width;
        }
        cell.scrollView .contentSize = CGSizeMake(ww2, cell.scrollView.height);
        
        cell.price.text = [NSString stringWithFormat:@"订单金额:￥%.2f",model.order_total_price.floatValue];
        [cell.button setTitle:@"立即评价" forState:UIControlStateNormal];
        [cell.button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.button.tag = 101;
        cell.order_id = model.order_id;
    }else if (tableView==_finishedTV){
        //TODO: 修改已完成列表
        EvaAddModel *model = _finishedArr[indexPath.row];
        NSString *val = nil;
        switch (model.evaluate_buyer_val) {
            case 1:{
                val = @"好评";
                break;
            }
            case 0:{
                val = @"中评";
                break;
            }
            case -1:{
                val = @"差评";
                break;
            }
            default:{
                val = @"未知";
                break;
            }
        }
        cell.status.text = val;
        cell.orderNum.text = model.addTime;
        
        CGRect scrollF = cell.scrollView.frame;
        cell.scrollView.hidden = YES;
        cell.button.hidden = YES;
        cell.price.hidden = YES;
        
        CGFloat space = 10;
        UIImageView *iv = [[UIImageView alloc]init];
        iv.frame = CGRectMake(space, scrollF.origin.y + space, scrollF.size.height - 2 * space, scrollF.size.height - 2 * space);
        [iv sd_setImageWithURL:[NSURL URLWithString:model.goods_main_photo] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
        [cell.contentView addSubview:iv];
        
        CGFloat lblW = ScreenFrame.size.width - 3 * space - iv.width;

        UILabel *nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(iv.right + space, 25+cell.scrollView.top, lblW, 70)];
        nameLbl.text = model.goods_name;
        nameLbl.numberOfLines = 0;
        nameLbl.font=[UIFont systemFontOfSize:14];
        [cell.contentView addSubview:nameLbl];
        
        CGFloat space1 = 10;
        UIColor *aRed = UIColorFromRGB(0xf15353);
        void(^addBtn)(NSInteger,NSString *,NSInteger) = ^(NSInteger index, NSString *tit,NSInteger tag){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat btnW = 60;
            CGFloat btnX = ScreenFrame.size.width - (space1 + btnW) * (index + 1);
            CGFloat btnH = cell.contentView.height - cell.line.bottom - 2 * space1;
            CGFloat btnY = cell.line.bottom + space1;
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
            
            btn.layer.cornerRadius = 5.0;
            btn.layer.masksToBounds = YES;
            btn.layer.borderColor = aRed.CGColor;
            btn.layer.borderWidth = 1;
            [btn setTitle:tit forState:UIControlStateNormal];
            [btn setTitleColor:aRed forState:UIControlStateNormal];
            btn.tag= tag;
            
            [btn addTarget:self action:@selector(addEva:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:btn];
        };
        
        if(model.evaluate_add_able){
            addBtn(0,@"追加",414);
            if (model.evaluate_able) {
                addBtn(1,@"删除",415);
                addBtn(2,@"修改",416);
            }
        }else if (model.evaluate_able){
            addBtn(0,@"删除",415);
            addBtn(1,@"修改",416);
        }
        cell.goods_id = model.goods_id;
    }else{
        
    }
    
    return cell;
}
#pragma mark - 点击方法
-(IBAction)addEva:(UIButton *)button{
    NSLog(@"%ld",(long)button.tag);
    switch (button.tag) {
        case 414:{
            //追加
            AddEvaluatetTableViewController *add = [[UIStoryboard storyboardWithName:@"WaitForEvaluateStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"add"];
            UITableViewCell *cell = (UITableViewCell *)button.superview.superview;
            NSInteger row = [_finishedTV indexPathForCell:cell].row;
            EvaAddModel *model = _finishedArr[row];
            add.model = model;
            add.evaID = [NSString stringWithFormat:@"%ld",(long)model.evaluate_id];
            [self.navigationController pushViewController:add animated:YES];
            break;
        }case 415:{
            //删除
            
            [OHAlertView showAlertWithTitle:@"删除" message:@"确定要删除这条评价？" cancelButton:nil otherButtons:@[@"确定",@"取消"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    //确定
                    NSString *url = [NSString stringWithFormat:@"%@%@",FIRST_URL,EVA_DEL_URL];
                    UITableViewCell *cell = (UITableViewCell *)button.superview.superview;
                    NSInteger row = [_finishedTV indexPathForCell:cell].row;
                    EvaAddModel *model = _finishedArr[row];
                    NSDictionary *par = @{
                                          @"user_id":[SYObject currentUserID],
                                          @"token":[SYObject currentToken],
                                          @"evaluate_id":[NSString stringWithFormat:@"%ld",(long)model.evaluate_id]
                                          };
                    [SYObject startLoading];
                    [[Requester managerWithHeader]POST:url parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSDictionary *dict = responseObject;
                        if ([dict[@"result"] isEqualToString:@"SUCCESS"]) {
                            //refresh
                            [self headerRereshing];
                        }else {
                            [SYObject failedPrompt:@"删除失败"];
                        }
                        [SYObject endLoading];
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [SYObject endLoading];
                        [SYObject failedPrompt:error.localizedDescription];
                    }];
                    
                }else{
                    
                }
                
            }];
            break;
        }case 416:{
            //修改
            ModifyEvaTableViewController *modify = [[UIStoryboard storyboardWithName:@"WaitForEvaluateStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"modify"];
            UITableViewCell *cell = (UITableViewCell *)button.superview.superview;
            NSInteger row = [_finishedTV indexPathForCell:cell].row;
            EvaAddModel *model = _finishedArr[row];
            modify.model = model;
            modify.evaID = [NSString stringWithFormat:@"%ld",(long)model.evaluate_id];
            [self.navigationController pushViewController:modify animated:YES];
            break;
        }
        default:{
            break;
        }
    }
}
-(IBAction)btnClicked:(id)sender{
    UIButton *btn =  sender;
    WaitForEvaluateCell *cell = (WaitForEvaluateCell *)btn.superview.superview;
    NSString *order_id = [SYObject stringByNumber:cell.order_id];
    if ([cell.status.text isEqualToString:@"已收货"]) {
        //立即评价
        ThirdViewController *th = [ThirdViewController sharedUserDefault];
        th.ding_order_id = order_id;
        EnsureestimateViewController *ensur = [[EnsureestimateViewController alloc]init];
        [self.navigationController pushViewController:ensur animated:YES];
    }else if ([cell.status.text isEqualToString:@"交易完毕"]){
        //追加晒单
        
    }
}

@end
