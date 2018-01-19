//
//  OneYuanViewController.m
//  My_App
//
//  Created by shiyuwudi on 16/2/14.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

#import "OneYuanViewController.h"
#import "OneYuanModel.h"
#import "OneYuanClassCell.h"
#import "OneYuanGoodsCell.h"
#import "OneYuanClassModel.h"
#import "CloudPurchaseGoods.h"
#import "BundlingViewController.h"
#import "OneYuanCartTableViewController.h"
#import "CloudPurchaseGoodsModel.h"
#import "CloudPurchaseGoodsDetailViewController.h"
#import "SwiftHeader.h"
#import "IndianaRecordsViewController.h"
#import "CloudGoodsListViewController.h"
#import "PreviousPrizeWinnerTableViewController.h"
#import "NewLoginViewController.h"

static CGFloat hHot = 175;//热门商品单元格高度
static CGFloat titleH = 44;//“今日热门商品”标题高度
static CGFloat upShowDistance = 200;//回到顶部按钮出现距离
static NSInteger goodsCount = 4;//每次加载的热门商品数量

@interface OneYuanViewController ()<UITableViewDataSource,UITableViewDelegate,SYDetailCellViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong)UITableView *mainTableview;
@property (nonatomic,strong)NSArray *array1;//最新揭晓
@property (nonatomic,strong)NSArray *array2;//上架新品
@property (nonatomic,strong)NSArray *array3;//今日热门商品
@property (nonatomic,weak)UILabel *numLabel;
@property (nonatomic,weak)UIButton *upBtn;
@property (nonatomic,assign)NSInteger lastCount;
@property (nonatomic,assign)BOOL noMore;

@end

@implementation OneYuanViewController

#pragma mark - 视图生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initArray];
    [self setupUI];
    [self netRequest];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.tabBarController.tabBar.hidden = NO;
    [_upBtn removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 网络请求
//初始化数组
-(void)initArray{
    _array1 = [NSArray array];
    _array2 = [NSArray array];
    _array3 = [NSArray array];
}
//今日热门商品
-(void)netRequestForPopGoodsWithBeginCount:(NSInteger)beginCount SelectCount:(NSInteger)selectCount{
    NSLog(@"count:%ld,%ld",(long)beginCount,(long)selectCount);
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,CLOUDPURCHASE_GOODSLIST_URL];
    NSDictionary *par = @{
                          @"orderby":@"popularity",
                          @"ordertype":@"asc",
                          @"begin_count":[NSString stringWithFormat:@"%ld",(long)beginCount],
                          @"select_count":[NSString stringWithFormat:@"%ld",(long)selectCount],
                          @"class_id":@"",
                          };
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"今日热门商品******%@",responseObject);
        NSDictionary *dict = responseObject;
        NSArray *arr = dict[@"data"];
        NSMutableArray *tempArr = [NSMutableArray new];
        for (NSDictionary *dict1 in arr) {
            OneYuanModel *model = [OneYuanModel yy_modelWithDictionary:dict1];
            [tempArr addObject:model];
        }
        if(tempArr.count != 0){
            _array3 = [_array3 arrayByAddingObjectsFromArray:tempArr];
        }
        
        [self performSelector:@selector(insertRows) withObject:nil afterDelay:0.5];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:[error localizedDescription]];
    }];
}
-(void)insertRows{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self currentTableView] reloadData];
    });
}
//上架新品
-(void)netRequestForNewGoods{
    [SYObject startLoading];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,CLOUDPURCHASE_GOODSLIST_URL];
    NSDictionary *par = @{
                          @"orderby":@"addTime",
                          @"ordertype":@"asc",
                          @"begin_count":@"0",
                          @"select_count":@"3",
                          @"class_id":@"",
                          };
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"上架新品******%@",responseObject);
        [SYObject endLoading];
        NSDictionary *dict = responseObject;
        NSArray *arr = dict[@"data"];
        NSMutableArray *tempArr = [NSMutableArray new];
        for (NSDictionary *dict1 in arr) {
            OneYuanModel *model = [OneYuanModel yy_modelWithDictionary:dict1];
            [tempArr addObject:model];
        }
        _array2 = [tempArr copy];
        [[self currentTableView] reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject endLoading];
        [SYObject failedPrompt:[error localizedDescription]];
    }];
}
//最新揭晓
-(void)netRequestForNewPrizeWinner{
    [SYObject startLoading];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,CLOUDPURCHASE_NEW_WINNER_URL];
    NSDictionary *par = @{
                          @"begin_count":@"0",
                          @"select_count":@"3"
                          };
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SYObject endLoading];
        NSLog(@"最新揭晓:%@",responseObject);
        NSDictionary *dict = responseObject;
        NSArray *arr = dict[@"data"];
        NSMutableArray *tempArr = [NSMutableArray new];
        for (NSDictionary *dict1 in arr) {
            OneYuanModel *model = [OneYuanModel yy_modelWithDictionary:dict1];
            [tempArr addObject:model];
        }
        _array1 = [tempArr copy];
        [[self currentTableView] reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject endLoading];
        [SYObject failedPrompt:error.localizedDescription];
    }];
}
-(void)netRequest{
    _array3 = [NSArray array];
    [self netRequestForNewPrizeWinner];
    [self netRequestForNewGoods];
    [self netRequestForPopGoodsWithBeginCount:0 SelectCount:goodsCount];
    self.lastCount = 0;
}
#pragma mark - 页面框架
-(void)setupUI{
    self.title = @"1元夺宝";
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    UITableView *tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height - 20)];
    [self.view addSubview:tv];
    
    tv.delegate = self;
    tv.dataSource = self;
    tv.tableFooterView = [UIView new];
    tv.tableFooterView.backgroundColor = BACKGROUNDCOLOR;
    tv.backgroundColor = BACKGROUNDCOLOR;
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tv addHeaderWithTarget:self action:@selector(headerRefresh)];
    
    _mainTableview = tv;
    [self createBackBtn];
    [self createRightBtn];
    
    
    UIButton *gotoRecord=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tv.frame)-80, CGRectGetMaxY(tv.frame)-90, 80, 30)];
    [gotoRecord setTitle:@"夺宝记录" forState:UIControlStateNormal];
    
    gotoRecord.backgroundColor=[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.9];
    [gotoRecord addTarget:self action:@selector(personalCenterListPageClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gotoRecord];
}

-(void)createRightBtn{
    //cart_icon search setting
    UIButton *buttonRecord = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonRecord.frame =CGRectMake(0, 0, 18, 18);
    [buttonRecord setBackgroundImage:[UIImage imageNamed:@"ygavatar"] forState:UIControlStateNormal];
    [buttonRecord addTarget:self action:@selector(personalCenterListPageClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonSearch.frame =CGRectMake(0, 0, 18, 18);
    [buttonSearch setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [buttonSearch addTarget:self action:@selector(searchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonCart = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonCart.frame =CGRectMake(0, 0, 18, 18);
    [buttonCart setBackgroundImage:[UIImage imageNamed:@"cart_icon"] forState:UIControlStateNormal];
    [buttonCart addTarget:self action:@selector(cartBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *bar1 = [[UIBarButtonItem alloc]initWithCustomView:buttonRecord];
    UIBarButtonItem *bar2 = [[UIBarButtonItem alloc]initWithCustomView:buttonCart];
    UIBarButtonItem *bar3 = [[UIBarButtonItem alloc]initWithCustomView:buttonSearch];
    self.navigationItem.rightBarButtonItems = @[bar2,bar3,bar1];
}
-(void)createCartIcon{
    UIButton *cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat h = 40;
    CGFloat w = h;
    CGFloat x = 10;
    CGFloat y = ScreenFrame.size.height - 10 - h;
    cartBtn.frame = CGRectMake(x, y, w, h);
    UIImage *cartImg = [UIImage imageNamed:@"ygcart"];
    [cartBtn setImage:cartImg forState:UIControlStateNormal];
    
    cartBtn.layer.cornerRadius = h / 2;
    cartBtn.alpha = 0.6;
    cartBtn.backgroundColor = UIColorFromRGB(0xf15353);
    
    [cartBtn addTarget:self action:@selector(cartBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat w1 = 15;
    CGFloat h1 = 15;
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(w - w1, 0, w1, h1)];
    _numLabel = numLabel;
    numLabel.textColor = [UIColor whiteColor];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.font = [UIFont systemFontOfSize:14];
    numLabel.layer.cornerRadius = w1 / 2;
    numLabel.layer.masksToBounds = YES;
    [cartBtn addSubview:numLabel];
    numLabel.backgroundColor = [UIColor blackColor];
    
    UIButton *upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat h2 = 40;
    CGFloat w2 = h;
    CGFloat x2 = ScreenFrame.size.width - 10 - w2;
    CGFloat y2 = ScreenFrame.size.height - 10 - h2;
    upBtn.frame = CGRectMake(x2, y2, w2, h2);
    [upBtn setImage:[UIImage imageNamed:@"arrow_top"] forState:UIControlStateNormal];
    [self.navigationController.view addSubview:upBtn];
    [upBtn addTarget:self action:@selector(upBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _upBtn = upBtn;
    upBtn.hidden = YES;
}
-(void)createBackBtn{
    
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;

    
}
#pragma mark - scrollView
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > upShowDistance) {
        _upBtn.hidden = NO;
    }else{
        _upBtn.hidden = YES;
    }
}
#pragma mark - 购物车逻辑
-(void)addCartWithItem:(OneYuanModel *)item{
    [SYObject checkLogin:self.navigationController s:^(BOOL login) {
        if (login) {
            [SYShopAccessTool addToCartWithLotteryID:item.id count:item.cloudPurchaseGoods.least_rmb];
        }
    }];
    
}
#pragma mark - 点击事件
//主页商品点击事件
-(void)mainGoodsClicked:(UIButton *)btn {
    NSInteger tag = btn.tag;
    OneYuanModel *model = nil;
    if (tag < 10) {
        model = _array1[tag - 00];
    }else if (tag < 20){
        model = _array2[tag - 10];
    }else{
        model = _array3[tag - 20];
    }
    
    CloudPurchaseGoodsDetailViewController *detail=[[CloudPurchaseGoodsDetailViewController alloc]init];
    detail.ID = model.id;
    [self.navigationController pushViewController:detail animated:YES];
}
//点击搜索按钮
-(void)searchBtnClicked{
//    CloudSearchViewController *search = [[CloudSearchViewController alloc]init];
//    [self.navigationController pushViewController:search animated:YES];
}
//个人中心列表页
-(void)personalCenterListPageClicked{
    //个人中心列表页 测试00025
    [SYObject checkLogin:self.navigationController s:^(BOOL login) {
        if (login)
        {
            IndianaRecordsViewController *irvc=[[IndianaRecordsViewController alloc]init];
            [self.navigationController pushViewController:irvc animated:NO];
            
        }
    }];
}
-(void)tapClick
{
    
    UIButton *btn=(UIButton *)[self.view viewWithTag:50];
    btn.selected=NO;
    
}

-(void)moreNewBtnClicked:(UIButton *)btn{
    CloudGoodsListViewController *listVC = [[CloudGoodsListViewController alloc]init];
    listVC.mark=NO;
    [self.navigationController pushViewController:listVC animated:true];

}
-(void)morePopBtnClicked:(UIButton *)btn{

    CloudGoodsListViewController *listVC = [[CloudGoodsListViewController alloc]init];
    listVC.mark=YES;
    [self.navigationController pushViewController:listVC animated:true];

}
-(void)addBtnClicked:(UIButton *)addBtn{
    NSInteger idx = addBtn.tag;
    OneYuanModel *model = _array3[idx];
    model.addedToCart = YES;
    [[self currentTableView] reloadData];
    [self addCartWithItem:model];
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)cartBtnClicked:(id)sender{
    [SYObject checkLogin:self.navigationController s:^(BOOL login) {
        if (login) {
            OneYuanCartTableViewController *cart = [[OneYuanCartTableViewController alloc]init];
            [self.navigationController pushViewController:cart animated:YES];
        }
    }];
}
-(IBAction)upBtnClicked:(id)sender{
    [[self currentTableView] setContentOffset:CGPointZero animated:YES];
}
#pragma mark - 便民方法
-(UITableView *)currentTableView {
    return self.mainTableview;
}
-(NSInteger)cartCount{
    return _numLabel.text.integerValue;
}
#pragma mark - 下拉刷新,上拉自动刷新
-(void)headerRefresh{
    [[self currentTableView] headerEndRefreshing];
    [self netRequest];
}
-(void)footerRefresh{
    [self netRequestForPopGoodsWithBeginCount:self.lastCount SelectCount:goodsCount];
}
#pragma mark - tableview
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _mainTableview) {
        NSInteger totalRows = [tableView numberOfRowsInSection:0];
        if (indexPath.row == totalRows - 1 && _array3.count != 0 && _array3.count != self.lastCount) {
            self.lastCount = _array3.count;
            [self footerRefresh];
            
        }
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array3.count % 2 == 0 ? 3 + _array3.count / 2 : 3 + _array3.count / 2 + 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:{
            return 180;
            break;
        }
        case 1:{
            return 180;
            break;
        }
        case 2:{
            return titleH;
            break;
        }
        default:{
            return hHot;
            break;
        }
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //分隔线
    UIColor *gray1 = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1];
    UIImage *emptyImg = [UIImage imageNamed:@"kong_lj"];
    CGFloat tenW = 22;
    CGFloat tenH = 27;
    CGFloat lineWidth = 0.5;
    
    if (tableView == _mainTableview) {
        switch (indexPath.row) {
            case 0:{
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
                if (!cell){
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                for (UIView *subview in cell.contentView.subviews) {
                    [subview removeFromSuperview];
                }
                UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 10)];
                grayView.backgroundColor = BACKGROUNDCOLOR;
                [cell.contentView addSubview:grayView];
                
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(grayView.frame), ScreenFrame.size.width, lineWidth)];
                lineView.backgroundColor = gray1;
                [cell.contentView addSubview:lineView];
                
                UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame), ScreenFrame.size.width, 180 - grayView.height - 2)];
                whiteView.backgroundColor = [UIColor whiteColor];
                [cell.contentView addSubview:whiteView];
                
                UILabel *nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 + lineView.bottom, 100, 20)];
                nameLbl.text = @"最新揭晓";
                [cell.contentView addSubview:nameLbl];
                
                for (int i=0; i<3 ; i++) {
                    CGFloat pad = 5;
                    CGFloat h2 = 20;
                    CGFloat w1 = (ScreenFrame.size.width - 6 * pad) / 3;
                    CGFloat h1 = 130 - h2 - 10;
                    CGFloat x1 = i * (w1 + 2 * pad) + pad;
                    CGFloat y1 = nameLbl.bottom + 10;
                    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(x1, y1, w1, h1)];
                    
                    CGFloat x2 = x1;
                    CGFloat y2 = iv.bottom;
                    CGFloat w2 = w1;
                    UILabel *winnerLbl = [[UILabel alloc]initWithFrame:CGRectMake(x2, y2, w2, h2)];
                    winnerLbl.textAlignment = NSTextAlignmentCenter;
                    winnerLbl.font = [UIFont systemFontOfSize:14.0];
                    [cell.contentView addSubview:winnerLbl];
                    
                    NSString *mars = @"火星中奖者";
                    if (i>=_array1.count) {
//                        iv.image = emptyImg;
                        winnerLbl.text = mars;
                    }else {
                        OneYuanModel *winnerModel = _array1[i];
                        NSURL *imageUrl = [NSURL URLWithString:winnerModel.cloudPurchaseGoods.primary_photo];
                        [iv sd_setImageWithURL:imageUrl placeholderImage:emptyImg];
                        
                        UIButton *btn = [[UIButton alloc]initWithFrame:iv.frame];
                        btn.tag = i;
                        [cell.contentView addSubview:btn];
                        [btn addTarget:self action:@selector(mainGoodsClicked:) forControlEvents:UIControlEventTouchUpInside];
                        
                        UIImageView *ivTen = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ygten"]];
                        ivTen.frame = CGRectMake(x1, y1, tenW, tenH);
                        
                        if (winnerModel.cloudPurchaseGoods.least_rmb.intValue == 10) {
                            [cell.contentView addSubview:ivTen];
                        }
                        if (winnerModel.lucky_username) {
                            NSString *full = [NSString stringWithFormat:@"恭喜%@获奖",winnerModel.lucky_username];
                            NSAttributedString *wi = [NSAttributedString stringWithFullStr:full attributedPart:winnerModel.lucky_username attribute:@{NSForegroundColorAttributeName:[UIColor blueColor]}];
                            winnerLbl.attributedText = wi;
                        } else {
                            winnerLbl.text = mars;
                        }
                        
                    }
                    [cell.contentView addSubview:iv];
                    
                    
                    
                    
                    
                    
                    if (i==2) {
                        break;
                    }
                    UIView *vLineView = [[UIView alloc]initWithFrame:CGRectMake(iv.right, iv.top, lineWidth, iv.height + h2)];
                    vLineView.backgroundColor = gray1;
                    [cell.contentView addSubview:vLineView];
                }
                UIView *hLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 179, ScreenFrame.size.width , lineWidth)];
                hLineView.backgroundColor = gray1;
                [cell.contentView addSubview:hLineView];
                
                return cell;
                break;
            }
            case 1:{
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
                if (!cell){
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                for (UIView *subview in cell.contentView.subviews) {
                    [subview removeFromSuperview];
                }
                UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 10)];
                grayView.backgroundColor = BACKGROUNDCOLOR;
                [cell.contentView addSubview:grayView];
                
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(grayView.frame), ScreenFrame.size.width, lineWidth)];
                lineView.backgroundColor = gray1;
                [cell.contentView addSubview:lineView];
                
                UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame), ScreenFrame.size.width, 180 - grayView.height - 2)];
                whiteView.backgroundColor = [UIColor whiteColor];
                [cell.contentView addSubview:whiteView];
                
                UILabel *nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 + lineView.bottom, 100, 20)];
                nameLbl.text = @"上架新品";
                [cell.contentView addSubview:nameLbl];
                
                UIButton *moreNewBtn = [LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(ScreenFrame.size.width - 10 - 50, nameLbl.top, 50, 20) setNormalImage:nil setSelectedImage:nil setTitle:@"更多" setTitleFont:15 setbackgroundColor:[UIColor whiteColor]];
                [moreNewBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
                [cell.contentView addSubview:moreNewBtn];
                [moreNewBtn addTarget:self action:@selector(moreNewBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                for (int i=0; i<3 ; i++) {
                    CGFloat pad = 5;
                    CGFloat h2 = 20;
                    CGFloat w1 = (ScreenFrame.size.width - 6 * pad) / 3;
                    CGFloat h1 = 130 - h2 - 10;
                    CGFloat x1 = i * (w1 + 2 * pad) + pad;
                    CGFloat y1 = nameLbl.bottom + 10;
                    
                    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(x1, y1, w1, h1)];
                    
                    CGFloat x2 = x1;
                    CGFloat y2 = iv.bottom;
                    CGFloat w2 = w1;
                    
                    UILabel *winnerLbl = [[UILabel alloc]initWithFrame:CGRectMake(x2, y2, w2, h2)];
                    winnerLbl.font = [UIFont systemFontOfSize:14.0];
                    if (i>=_array2.count) {
//                        iv.image = emptyImg;
                        winnerLbl.text = @"火星商品";
                    }else {
                        OneYuanModel *newGoodsModel = _array2[i];
                        NSURL *imageUrl = [NSURL URLWithString:newGoodsModel.cloudPurchaseGoods.primary_photo];
                        [iv sd_setImageWithURL:imageUrl placeholderImage:emptyImg];
                        winnerLbl.text = newGoodsModel.cloudPurchaseGoods.goods_name;
                        
                        UIButton *btn = [[UIButton alloc]initWithFrame:iv.frame];
                        btn.tag = i + 10;
                        [cell.contentView addSubview:btn];
                        [btn addTarget:self action:@selector(mainGoodsClicked:) forControlEvents:UIControlEventTouchUpInside];
                        
                        UIImageView *ivTen = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ygten"]];
                        ivTen.frame = CGRectMake(x1, y1, tenW, tenH);
                        
                        if (newGoodsModel.cloudPurchaseGoods.least_rmb.intValue == 10) {
                            [cell.contentView addSubview:ivTen];
                        }
                    }
                    [cell.contentView addSubview:iv];
                    [cell.contentView addSubview:winnerLbl];
                    winnerLbl.textAlignment = NSTextAlignmentCenter;
                    
                    if (i==2) {
                        break;
                    }
                    UIView *vLineView = [[UIView alloc]initWithFrame:CGRectMake(iv.right, iv.top, lineWidth, iv.height + h2)];
                    vLineView.backgroundColor = gray1;
                    [cell.contentView addSubview:vLineView];
                }
                UIView *hLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 179, ScreenFrame.size.width , lineWidth)];
                hLineView.backgroundColor = gray1;
                [cell.contentView addSubview:hLineView];
                return cell;
                break;
            }
            case 2:{
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
                if (!cell){
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                for (UIView *subview in cell.contentView.subviews) {
                    [subview removeFromSuperview];
                }
                UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, titleH)];
                titleLbl.backgroundColor = BACKGROUNDCOLOR;
                [cell.contentView addSubview:titleLbl];
                titleLbl.text = @"  今日热门商品";
                
                UIButton *morePopBtn = [LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(ScreenFrame.size.width - 10 - 50, 10, 50, 20) setNormalImage:nil setSelectedImage:nil setTitle:@"更多" setTitleFont:15 setbackgroundColor:BACKGROUNDCOLOR];
                [morePopBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
                [cell.contentView addSubview:morePopBtn];
                [morePopBtn addTarget:self action:@selector(morePopBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                return cell;
                break;
            }
            default:{
                //row从3开始
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
                if (!cell){
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell4"];
                }
                cell.contentView.backgroundColor = BACKGROUNDCOLOR;
                for (UIView *subview in cell.contentView.subviews) {
                    [subview removeFromSuperview];
                }
                CGFloat space = 5;
                
                int coun = 1;
                if (((indexPath.row - 3) + 1) * 2 <= _array3.count) {
                    coun = 2;
                }
                
                for (int i=0; i<coun; i++) {
                    NSInteger actualIndex = (indexPath.row - 3) * 2 + i;
                    if (actualIndex >= _array3.count) {
                        break;
                    }
                    OneYuanModel *model1 = _array3[actualIndex];
                    
                    CGFloat w0 = 0.5 *(ScreenFrame.size.width - 3 * space);
                    UIView *holder1 = [[UIView alloc]initWithFrame:CGRectMake(space + i * (space + w0), 0, w0, hHot - space)];
                    holder1.backgroundColor = [UIColor whiteColor];
                    [cell.contentView addSubview:holder1];
                    holder1.clipsToBounds = true;
                    
                    holder1.layer.borderColor = [gray1 CGColor];
                    holder1.layer.borderWidth = 0.5;
                    
                    //10元专区
                    UIImageView *ivTen = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ygten"]];
                    ivTen.frame = CGRectMake(0, 0, tenW, tenH);
                    if (model1.cloudPurchaseGoods.least_rmb.intValue == 10) {
                        [holder1 addSubview:ivTen];
                    }
                    
                    //商品图标
                    UIImageView *iv1 = [[UIImageView alloc]initWithFrame:CGRectMake(0.5 * (holder1.width - 100), space, 100, 100)];
                    [iv1 sd_setImageWithURL:[NSURL URLWithString:model1.cloudPurchaseGoods.primary_photo] placeholderImage:emptyImg];
                    [holder1 addSubview:iv1];
                    
                    CGRect btnFrame = [holder1 convertRect:iv1.frame toView:cell.contentView];
                    UIButton *btn = [[UIButton alloc]initWithFrame:btnFrame];
                    btn.tag = actualIndex + 20;
                    [cell.contentView addSubview:btn];
                    [btn addTarget:self action:@selector(mainGoodsClicked:) forControlEvents:UIControlEventTouchUpInside];
                    
                    //商品名
                    CGFloat x = space;
                    CGFloat y = iv1.bottom + space;
                    CGFloat w = holder1.width - 2 * space;
                    CGFloat h = 20;
                    UILabel *nameLbl = [LJControl labelFrame:CGRectMake(x, y, w, h) setText:model1.cloudPurchaseGoods.goods_name setTitleFont:17 setbackgroundColor:[UIColor whiteColor] setTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
                    [holder1 addSubview:nameLbl];
                    
                    CGFloat x1 = space;
                    CGFloat y1 = nameLbl.bottom + space;
                    NSString *prizeStr = @"开奖进度";
                    CGFloat w1 = [prizeStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}].width;
                    CGFloat h1 = 20;
                    UILabel *prizeLbl = [LJControl labelFrame:CGRectMake(x1, y1, w1, h1) setText:prizeStr setTitleFont:15 setbackgroundColor:[UIColor whiteColor] setTextColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentLeft];
                    [holder1 addSubview:prizeLbl];
                    
                    //开奖进度数字
                    CGFloat x2 = x1 + w1;
                    CGFloat y2 = y1;
                    float progress = model1.purchased_times.floatValue / model1.cloudPurchaseGoods.goods_price.floatValue;
                    
                    
                    model1.progress = [NSString stringWithFormat:@"%.2f",progress * 100];
                    NSLog(@"==%f---%f---%f",model1.purchased_times.floatValue ,model1.cloudPurchaseGoods.goods_price.floatValue,progress);

                    NSString *percentStr = [model1.progress stringByAppendingString:@"%"];
                    CGFloat h2 = h1;
                    UILabel *percentLbl = [LJControl labelFrame:CGRectMake(x2, y2, 200, h2) setText:percentStr setTitleFont:15 setbackgroundColor:[UIColor whiteColor] setTextColor:[UIColor blueColor] textAlignment:NSTextAlignmentLeft];
                    [holder1 addSubview:percentLbl];
                    CGFloat h4 = 25;
                    CGFloat w4 = h4;
                    
                    //加号
                    CGFloat x4 = holder1.width - space - w4;
                    CGFloat y4 = prizeLbl.top;
                    UIButton *addImageView = [[UIButton alloc]initWithFrame:CGRectMake(x4, y4, w4, h4)];
                    [addImageView setImage:[UIImage imageNamed:@"ygadd"] forState:UIControlStateNormal];
                    [holder1 addSubview:addImageView];
                    addImageView.tag = [_array3 indexOfObject:model1];
                    [addImageView addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchDown];
                    
                    iv1.tag = 400 + [_array3 indexOfObject:model1];
                    CGFloat x3 = space;
                    CGFloat y3 = percentLbl.bottom + space * 0.5;
                    CGFloat w3 = holder1.width - 2 * space - w4;
                    CGFloat h3 = 5;
                    UIProgressView *progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
                    progressView.progress = progress;
                    progressView.frame = CGRectMake(x3, y3, w3, h3);
                    progressView.progressImage = [UIImage imageNamed:@"ygprogress"];
                    [holder1 addSubview:progressView];
                }
                
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
                break;
            }
        }
    }
    
    return [UITableViewCell new];
}

@end
