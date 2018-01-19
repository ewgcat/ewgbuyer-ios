//
//  PreviousPrizeWinnerTableViewController.m
//  My_App
//
//  Created by shiyuwudi on 16/2/24.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

#import "PreviousPrizeWinnerTableViewController.h"
#import "PreviousWinnerRecord.h"
#import "PreviousRecordCell.h"
#import "CloudPurchaseLottery.h"

@interface PreviousPrizeWinnerTableViewController ()

@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, assign)NSInteger count;

@end

@implementation PreviousPrizeWinnerTableViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.count = 10;
    [self net];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
#pragma mark - net 
-(void)requestFrom:(NSInteger)from to:(NSInteger)to {
    [SYShopAccessTool resultHistoryByLotteryID:self.lotteryID beginCount:[SYObject toStr:from] selectCount:[SYObject toStr:to] result:^(NSArray *arr) {
        if (!arr || (arr && arr.count == 0)) {
            //没有更多数据
            [SYObject failedPrompt:@"没有更多数据"];
            self.tableView.footerHidden = true;
        } else {
            self.tableView.footerHidden = false;
        }
        for (CloudPurchaseLottery *lottery in arr) {
            PreviousWinnerRecord *record = [PreviousWinnerRecord recordWithLottery:lottery];
            if([Parser validModel:record]){
                [self.dataArray addObject:record];
            }
        }
        [self.tableView reloadData];
    }];
}
-(void)net {
    self.count = 10;
    [self.dataArray removeAllObjects];
    [self requestFrom:0 to:self.count];
}
#pragma mark - UI
-(void)setupUI {
    self.title = @"往期揭晓";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __unsafe_unretained PreviousPrizeWinnerTableViewController *weakSelf = self;
    [self.tableView addHeaderWithCallback:^{
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf net];
    }];
    [self.tableView addFooterWithCallback:^{
        [weakSelf.tableView footerEndRefreshing];
        [weakSelf requestFrom:weakSelf.count to:weakSelf.count + 10];
        weakSelf.count += 10;
    }];
}
#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [PreviousRecordCell cellHeight];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    PreviousRecordCell *cell = [PreviousRecordCell cellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
