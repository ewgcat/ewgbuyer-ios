//
//  ProfitTableViewController.m
//  My_App
//
//  Created by 邱炯辉 on 16/5/26.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "ProfitTableViewController.h"

#import "ProfitModel.h"
#import "ProfitTableViewCell.h"
@interface ProfitTableViewController ()
{

    NSMutableArray *_dataArr;
    
    int _start;
}
@end

@implementation ProfitTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _start=0;
    _dataArr =[[NSMutableArray alloc]init];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfitTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ProfitTableViewCell"];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.estimatedRowHeight= 70;
    self.tableView.rowHeight= 70;
    
    self.tableView.tableFooterView =[[UIView alloc]init];
    [self getData];
}

-(void)getData{
    
    [SYObject startLoading];
    
  
    
    NSString *str=[NSString stringWithFormat:@"%d",_start];
    NSString *urlStr= [NSString stringWithFormat:@"%@%@",FIRST_URL,FANYONG_URL];
    
    
        NSDictionary *par=@{@"user_id":[SYObject currentUserID],@"token":[SYObject currentToken],@"begincount":str ,@"selectcount":@"10"};
    __weak typeof(self)ws=self;
        [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
           
            [ws urlRequestSucceeded:responseObject];
    
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",[error localizedDescription]);
            [SYObject failedPrompt:@"网络请求失败"];

        }];
}

#pragma mark - 网络
-(void)urlRequestSucceeded:(NSArray *)arr{
//    int statuscode2 = [request responseStatusCode];
//    if (statuscode2 == 200) {
    NSArray *arrBig =arr;
        NSLog(@"dicBig:%@",arrBig);
        if (arrBig.count==0) {
            [SYObject failedPrompt:@"暂无记录"];
        }
        if (_start==0) {
            [_dataArr removeAllObjects];
        }
       
        if (arrBig) {
            for (NSDictionary *dic in arrBig) {
                ProfitModel *model=[[ProfitModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArr addObject:model];
                
            }
            [self.tableView reloadData];
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];


        }
//    }
    [SYObject endLoading];
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
    return _dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfitTableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    if (ScreenFrame.size.width  ==320) {//说明是4 4s 5 5s
        cell.nickname.font =[UIFont systemFontOfSize:15];
        cell.stateLabel.font =[UIFont systemFontOfSize:13];
        cell.timeLabel.font =[UIFont systemFontOfSize:13];
        
    }
//
//    
//
    ProfitModel *model=_dataArr[indexPath.row];
//    //头像直接从plist文件取就可以了
//    NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
//    NSString *photo_url=[d valueForKey:@"photo_url"];
    if (model.photo) {
        [cell.headImageview sd_setImageWithURL:[NSURL URLWithString:model.photo]];

    }
    cell.nickname.text =model.userName;
    NSString *str;
    if (model.commission_status ==0) {
        str=@"待返佣";
    }else if (model.commission_status ==1){
        str=@"已返佣";
    }else{
        str=@"已撤销";

    }
    cell.stateLabel.text =[NSString stringWithFormat:@"%@%@",@"返佣状态:",str];
    cell.timeLabel.text =[NSString stringWithFormat:@"%@%@",@"返佣时间:",model.addTime];
    cell.moneylabe.text =[NSString stringWithFormat:@"¥%.2f",model.commission_amount];

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}



@end
