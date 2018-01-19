//
//  OneYuanCartTableViewController.m
//  My_App
//
//  Created by shiyuwudi on 16/2/16.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

#import "CloudPurchaseGoodsDetailViewController.h"
#import "OneYuanCartTableViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BundlingViewController.h"
#import "CloudCartCell.h"
#import "OneYuanModel.h"
#import "SYStepper.h"
#import "CloudCart.h"
#import "PaymentOrderViewController.h"

static CGFloat hh = 42;
static CGFloat ww = 42;
static CGFloat xx = 0;
static CGFloat yy = (50 - 40) / 2;
static CGFloat h = 50;

@interface OneYuanCartTableViewController ()

@property(nonatomic, strong)NSArray <CloudCart *> *cartItems;//装的是OneYuanModel

@property(nonatomic, strong)UIView *payoff1;
@property(nonatomic, strong)UIView *payoff2;
@property(nonatomic, weak)UILabel *label1;
@property(nonatomic, weak)UILabel *label2;
@property(nonatomic, weak)UIButton *payBtn1;
@property(nonatomic, weak)UILabel *label11;
@property(nonatomic, weak)UILabel *label22;
@property(nonatomic, weak)UIButton *payBtn2;
@property(nonatomic, assign)BOOL allSelected;
@property(nonatomic, assign, getter=isEditing)BOOL editing;
@property(nonatomic, weak)UIButton *selectAllBtn1;
@property(nonatomic, weak)UIButton *selectAllBtn2;

@property(nonatomic, strong)UIBarButtonItem *rightEditBtn;
@property(nonatomic, strong)UIBarButtonItem *rightCancelBtn;
@property(nonatomic, strong)NSMutableString *total;
@end

@implementation OneYuanCartTableViewController

#pragma mark - 视图的生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self net];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createPayoffView1];
    [self createPayoffView2];
    [self updatePayoffInfo];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_payoff1 removeFromSuperview];
    [_payoff2 removeFromSuperview];
}
#pragma mark - 网络请求和刷新
-(void)net {
    [SYShopAccessTool checkCart:^(NSArray *items) {
        self.cartItems = items;
        [self.tableView reloadData];
        [self updatePayoffInfo];
    }];
}
-(void)headerRefresh {
    [self.tableView headerEndRefreshing];
    [self net];
}
#pragma mark - UI
-(void)setupUI{
    self.title = @"清单";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(numberChanged:) name:[SYStepper notifName] object:nil];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self createRightBtn];
    [self createCancelBtn];
    self.tableView.backgroundColor = BACKGROUNDCOLOR;
    self.tableView.allowsMultipleSelectionDuringEditing = true;
    self.tableView.editing = true;
}
-(void)createPayoffView1{
    UIView *payoff = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenFrame.size.height - h, ScreenFrame.size.width, h)];
    payoff.backgroundColor = [UIColor whiteColor];
    _payoff1 = payoff;
    
    NSInteger amount = 100;//车内商品当前总价
    UIFont *font1 = [UIFont systemFontOfSize:13];
    UIColor *color1 = [UIColor grayColor];
    UIFont *font2 = [UIFont systemFontOfSize:12];
    
    UIButton *selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectAllBtn setImage:[UIImage imageNamed:@"checkbox_blue"] forState:UIControlStateSelected];
    [selectAllBtn setImage:[UIImage imageNamed:@"checkbox_no"] forState:UIControlStateNormal];
    [selectAllBtn addTarget:self action:@selector(selectAll:) forControlEvents:UIControlEventTouchUpInside];
    
    selectAllBtn.frame = CGRectMake(xx, yy, ww, hh);
    _selectAllBtn1 = selectAllBtn;
    [payoff addSubview:selectAllBtn];
    
    //(long)self.cartItems.count
    NSString *str0 = [NSString stringWithFormat:@"共0件商品,总计: %ld元",(long)amount];
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:str0];
    NSRange range = [str0 rangeOfString:[NSString stringWithFormat:@"%ld元",(long)amount]];
    [str1 setAttributes:@{NSForegroundColorAttributeName: [UIColor redColor]} range:range];
//    CGFloat w1 = [str0 sizeWithAttributes:@{NSFontAttributeName:font1}].width;
    
    CGFloat h1 = [str0 sizeWithAttributes:@{NSFontAttributeName:font1}].height;
    CGFloat h2 = h1;
    
    CGFloat y1 = h / 2 - h1;
    CGFloat y2 = h / 2;
    
    CGFloat w3 = 60;
    
    CGFloat space = 10;
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(selectAllBtn.right, y1, ScreenFrame.size.width - w3, h1)];
    _label1 = label1;
    label1.font = font1;
    label1.textColor = color1;
    label1.attributedText = str1;
    [payoff addSubview:label1];
    
    NSString *str2 = @"夺宝有风险，参与需谨慎";
    CGFloat w2 = [str2 sizeWithAttributes:@{NSFontAttributeName:font2}].width;
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(selectAllBtn.right, y2, w2, h2)];
    _label2 = label2;
    label2.font = font2;
    label2.textColor = color1;
    label2.text = str2;
    [payoff addSubview:label2];
    
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBtn1 = payBtn;
    payBtn.frame = CGRectMake(ScreenFrame.size.width - space - w3, h / 4, w3, h / 2);
    [payBtn setTitle:@"结算" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payBtn.backgroundColor = [UIColor colorWithRed:221.f/255.f green:30.f/255.f blue:38.f/255.f alpha:1];
    payBtn.layer.cornerRadius = 5.f;
    payBtn.layer.masksToBounds = true;
    [payoff addSubview:payBtn];
    [payBtn addTarget:self action:@selector(payoffBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 1)];
    line.backgroundColor = BACKGROUNDCOLOR;
    [payoff addSubview:line];
    
}
-(void)createPayoffView2{
    CGFloat space = 10;
    
    UIView *payoff = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenFrame.size.height - h, ScreenFrame.size.width, h)];
    payoff.backgroundColor = [UIColor whiteColor];
    _payoff2 = payoff;
    
    NSInteger amount = 100;//车内商品当前总价
    UIFont *font1 = [UIFont systemFontOfSize:13];
    UIColor *color1 = [UIColor grayColor];
    UIFont *font2 = [UIFont systemFontOfSize:12];
    
    UIButton *selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectAllBtn2 = selectAllBtn;
    [selectAllBtn setImage:[UIImage imageNamed:@"checkbox_blue"] forState:UIControlStateSelected];
    [selectAllBtn setImage:[UIImage imageNamed:@"checkbox_no"] forState:UIControlStateNormal];
    [selectAllBtn addTarget:self action:@selector(selectAll:) forControlEvents:UIControlEventTouchUpInside];
    
    selectAllBtn.frame = CGRectMake(xx, yy, ww, hh);
    [payoff addSubview:selectAllBtn];
    
    NSString *str0 = [NSString stringWithFormat:@"共0件商品,总计: %ld元",(long)amount];
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:str0];
    NSRange range = [str0 rangeOfString:[NSString stringWithFormat:@"%ld元",(long)amount]];
    [str1 setAttributes:@{NSForegroundColorAttributeName: [UIColor redColor]} range:range];
    CGFloat w1 = [str0 sizeWithAttributes:@{NSFontAttributeName:font1}].width;
    
    CGFloat h1 = [str0 sizeWithAttributes:@{NSFontAttributeName:font1}].height;
    CGFloat h2 = h1;
    CGFloat y1 = h / 2 - h1;
    CGFloat y2 = h / 2;
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(selectAllBtn.right, y1, w1, h1)];
    _label11 = label1;
    label1.font = font1;
    label1.textColor = color1;
    label1.attributedText = str1;
    [payoff addSubview:label1];
    
    NSString *str2 = @"夺宝有风险，参与需谨慎";
    CGFloat w2 = [str2 sizeWithAttributes:@{NSFontAttributeName:font2}].width;
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(selectAllBtn.right, y2, w2, h2)];
    _label22 = label2;
    label2.font = font2;
    label2.textColor = color1;
    label2.text = str2;
    [payoff addSubview:label2];
    
    CGFloat w3 = 60;
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBtn2 = payBtn;
    payBtn.frame = CGRectMake(ScreenFrame.size.width - space - w3, h / 4, w3, h / 2);
    [payBtn setTitle:@"删除" forState:UIControlStateNormal];
    UIColor *aRed = [UIColor colorWithRed:221.f/255.f green:30.f/255.f blue:38.f/255.f alpha:1];
    [payBtn setTitleColor:aRed forState:UIControlStateNormal];
    payBtn.layer.cornerRadius = 5.f;
    payBtn.layer.masksToBounds = true;
    payBtn.layer.borderColor = aRed.CGColor;
    payBtn.layer.borderWidth = 1;
    [payoff addSubview:payBtn];
    [payBtn addTarget:self action:@selector(payoffBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 1)];
    line.backgroundColor = BACKGROUNDCOLOR;
    [payoff addSubview:line];
}
-(void)createRightBtn {
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editBtnClicked)];
    self.navigationItem.rightBarButtonItem = bar;
    self.rightEditBtn = bar;
}
-(void)createCancelBtn {
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(editBtnClicked)];
    self.rightCancelBtn = bar;
}
-(void)updateBtnTitle{
    if (self.editing) {
        self.navigationItem.rightBarButtonItem = self.rightCancelBtn;
    }else {
        self.navigationItem.rightBarButtonItem = self.rightEditBtn;
    }
}
-(BOOL)allSelected{
    if (self.cartItems && self.cartItems.count != 0) {
        return [self selectedCount] == self.cartItems.count;
    }
    return false;
}
-(void)updatePayoffInfo{
    [_payoff1 removeFromSuperview];
    [_payoff2 removeFromSuperview];
    if (self.isEditing) {
        
        _label11.text = self.allSelected ? @"取消全选" : @"全选";
        _label22.text = [NSString stringWithFormat:@"共选中%ld件奖品",(long)[self selectedCount]];
        _selectAllBtn2.selected = self.allSelected;
        [self.navigationController.view addSubview:_payoff2];
    }else {
        long qty = [self selectedCount];
        long amount = 0;
        NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
        if (self.allSelected) {
            for (CloudCart *cart in self.cartItems) {
                NSInteger one = [cart userBuyedQty].integerValue;
                amount += one;
            }
        }else{
            for (NSIndexPath *path in indexPaths) {
                CloudCart *cart = self.cartItems[path.row];
                NSInteger one = [cart userBuyedQty].integerValue;
                amount += one;
            }
        }
        
//        for (CloudCart *cart in self.cartItems) {
//            NSInteger one = [cart userBuyedQty].integerValue;
//            amount += one;
//        }
        if (!_total) {
            _total=[[NSMutableString alloc]init];
        }else{
            [_total setString:[NSString stringWithFormat:@"%ld",amount]];
        }
        
        NSString *str0 = [NSString stringWithFormat:@"共%ld件商品,总计: %ld元",qty,amount];
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:str0];
        NSRange range = [str0 rangeOfString:[NSString stringWithFormat:@"%ld元",(long)amount]];
        [str1 setAttributes:@{NSForegroundColorAttributeName: [UIColor redColor]} range:range];
        _label1.attributedText = str1;
        
        _label2.text = @"夺宝有风险，参与需谨慎";
        _selectAllBtn1.selected = self.allSelected;
        [self.navigationController.view addSubview:_payoff1];
    }
}
-(NSInteger)selectedCount{
    NSArray <NSIndexPath *> *selectedRows = [self.tableView indexPathsForSelectedRows];
    NSInteger count = selectedRows.count;
    return count;
}
#pragma mark - 点击事件
-(NSArray <NSIndexPath *>*)allPaths{
    NSMutableArray *arr = [NSMutableArray new];
    for (NSInteger i=0;i<self.cartItems.count;i++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        [arr addObject:path];
    }
    return arr;
}
-(void)selectAll:(UIButton *)btn{
    btn.selected = !btn.isSelected;
    NSArray *arr = [self allPaths];
    if (self.allSelected) {
        //全不选
        for (NSIndexPath *path in arr) {
            [self.tableView deselectRowAtIndexPath:path animated:false];
            [self tableView:self.tableView didDeselectRowAtIndexPath:path];
        }
    }else {
        //全选
        for (NSIndexPath *path in arr) {
            [self.tableView selectRowAtIndexPath:path animated:false scrollPosition:UITableViewScrollPositionNone];
            [self tableView:self.tableView didSelectRowAtIndexPath:path];
        }
    }
    
    
}
-(void)payoffBtnClicked {
    //支付流程
    if (self.isEditing) {
        //删除操作
        NSString *cartID = [self deleteCartsID];
        if (cartID.length != 0) {
            [SYShopAccessTool cartDelByID:cartID result:^(BOOL success) {
                [self net];
            }];
        }
    }else {
        //结算操作
        NSArray <NSIndexPath *> *selectedRows = [self.tableView indexPathsForSelectedRows];
        if (selectedRows.count>0) {
            PaymentOrderViewController *povc=[[PaymentOrderViewController alloc]init];
            NSMutableArray *cloudCartArray=[[NSMutableArray alloc]init];
            for (NSIndexPath *index in selectedRows) {
                CloudCart *model=self.cartItems[index.row];
                [cloudCartArray addObject:model];
            }
            povc.cloudCartArray=cloudCartArray;
            povc.totalPrice=_total;
            [self.navigationController pushViewController:povc animated:YES];
        }else{
            [OHAlertView showAlertWithTitle:@"提示" message:@"请选择要结算的商品" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            }];
        }

    }
   
    
}
-(NSString *)deleteCartsID{
    NSArray <NSIndexPath *> *selectedRows = [self.tableView indexPathsForSelectedRows];
    NSMutableString *str = [@"" mutableCopy];
    for (NSIndexPath *indexPath in selectedRows) {
        NSInteger row = indexPath.row;
        CloudCart *cart = self.cartItems[row];
        NSString *cartID = cart.id;
        [str appendFormat:@",%@",cartID];
    }
    if ([str hasPrefix:@","]) {
        str = [[str substringFromIndex:1]mutableCopy];
    }
    return str;
}
-(void)editBtnClicked {
    self.editing = !self.isEditing;
    [self updateBtnTitle];
    [self updatePayoffInfo];
}
#pragma mark - 通知监听
-(void)numberChanged:(NSNotification *)notif {
    NSString *key1 = [SYStepper keyForSuperview];
    NSString *key2 = [SYStepper keyForNumber];
    CloudCartCell *cell = notif.userInfo[key1];
    CloudCart *model = cell.model;
    NSInteger row = [self.tableView indexPathForCell:cell].row;
    NSNumber *newValue = notif.userInfo[key2];
    model.purchased_times = (NSString *)newValue;
    [self updatePayoffInfo];
    
    NSLog(@"数量修改newValue:%@,row:%ld",newValue,(long)row);
    [SYObject checkLogin:self.navigationController s:^(BOOL login) {
        if (login) {
            
            
            [SYShopAccessTool modifyCartWithCartID:model.id toCount:(NSString *)newValue result:^(BOOL success) {
                if (!success) {
                    [SYObject failedPrompt:@"修改失败"];
                    
                }
                [self net];//交给后台校验
            }];
        
    }
    }];
}
#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [CloudCartCell cellHeight];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.cartItems) {
        return self.cartItems.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CloudCartCell *cell = [CloudCartCell cell];
    CloudCart *model = self.cartItems[indexPath.row];
    cell.model = model;
//    if (self.allSelected) {
//        cell.selected = true;
//    }
    return cell;
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self updatePayoffInfo];
    
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self updatePayoffInfo];
}


@end
