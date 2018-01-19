//
//  TeamTableViewController.m
//  My_App
//
//  Created by 邱炯辉 on 16/5/26.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "Record77TableViewController.h"

@interface Record77TableViewController ()
{
    int _start;
    
    NSString *longStr;
}
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation Record77TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _start=0;
    _dataArr =[[NSMutableArray alloc]init];
    
   
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.estimatedRowHeight= 70;
    self.tableView.rowHeight= 70;
    
    self.tableView.tableFooterView =[[UIView alloc]init];
    [SYObject startLoading];
    [self getData];
    
}


///app/buyer/vip_team_manage.htm
#pragma mark 获取数据
-(void)getData{
    
    NSString *str=[NSString stringWithFormat:@"%d",_start];
    
    NSString *urlStr= [NSString stringWithFormat:@"%@%@",FIRST_URL,@"/app/buyer/promotion_income_withdrawal_list.htm"];
    
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    
    NSDictionary *par=@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1],@"begin_count":str ,@"select_count":@"10"};
    //
    __weak typeof(self) ws= self;
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject==%@",responseObject);
       
            NSArray *arr =responseObject[@"withdrawal_list"];
            NSLog(@"arr==%@",arr);
        if(arr.count==0){
            [SYObject failedPrompt:@"暂无记录"];
        }
            if (_start==0) {
                [ws.dataArr removeAllObjects];
            }
        
            [ws.dataArr addObjectsFromArray:arr];
            
        
        [ws.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        [SYObject endLoading];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        [SYObject endLoading];
        
    }];
}
#pragma mark -上拉刷新、下拉加载
-(void)headerRereshing{
    NSLog(@"下拉加载");
    _start=0;
    [self getData];
    
}
-(void)footerRereshing{
    NSLog(@"上拉刷新");
    _start+=10;
    [self getData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID=@"jsodfosdhuodsf";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
   
    }
    
    
    
    NSDictionary *dic=self.dataArr[indexPath.row];
    
    
    cell.textLabel.text =[NSString stringWithFormat:@"%@  %@  %@",dic[@"time"],dic[@"withdrawal_amount"],dic[@"withdrawalState"]];
    
    return cell;
}


@end
