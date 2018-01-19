//
//  RewardTableViewController.m
//  My_App
//
//  Created by 邱炯辉 on 16/5/26.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "RewardTableViewController.h"
#import "RewardTableViewCell.h"
@interface RewardTableViewController ()
{
    int _start;


}
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation RewardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _start=0;
    _dataArr =[[NSMutableArray alloc]init];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RewardTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"RewardTableViewCell"];
    //上拉刷新、下拉加载
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.estimatedRowHeight= 70;
    self.tableView.rowHeight= 70;
    self.tableView.tableFooterView =[[UIView alloc]init];
    [self getData];
    [SYObject startLoading];

}



///这种afn也能请求的
#pragma mark 获取数据
-(void)getData{
    
    NSString *str=[NSString stringWithFormat:@"%d",_start];

    NSString *urlStr= [NSString stringWithFormat:@"%@%@",FIRST_URL,JIANGLI_URL];

    NSArray *fileContent2 = [MyUtil returnLocalUserFile];

    NSDictionary *par=@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1],@"begincount":str ,@"selectcount":@"10"};
    __weak typeof(self) ws= self;
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *arr= responseObject;
        if (arr.count==0&&ws.dataArr.count==0) {
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
    RewardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RewardTableViewCell" forIndexPath:indexPath];
    if (ScreenFrame.size.width  ==320) {//说明是4 4s 5 5s
        cell.nickNameLabel.font =[UIFont systemFontOfSize:15];
        cell.moneyLabel.font =[UIFont systemFontOfSize:13];
        cell.timeLabel.font =[UIFont systemFontOfSize:13];
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    // Configure the cell...
    
    NSDictionary *dic =self.dataArr[indexPath.row];
    //头像直接从plist文件取就可以了
//    NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
//    NSString *photo_url=[d valueForKey:@"photo_url"];
    
    NSString *photo_url=dic[@"photo"];
    [cell.headImageview sd_setImageWithURL:[NSURL URLWithString:photo_url]];

    cell.nickNameLabel.text =dic[@"userName"];
    
    float money=[dic[@"reward_money"] floatValue];
    cell.moneyLabel.text = [NSString stringWithFormat:@"%@%.2f",@"奖励金额：¥",money];
    cell.timeLabel.text =[NSString stringWithFormat:@"%@%@",@"奖励时间：",dic[@"add_time"]];
    cell.linquButton.tag=indexPath.row;
    if ([dic[@"vip_reward_state"] isEqualToString:@"RECEIVED"]) {
        [cell.linquButton setTitle:@"已领取" forState:UIControlStateNormal];
        
    }else if ([dic[@"vip_reward_state"] isEqualToString:@"WAITING_RECEIVE"]){
        [cell.linquButton setTitle:@"领取" forState:UIControlStateNormal];
            
    }else if ([dic[@"vip_reward_state"] isEqualToString:@"WAITING_RECEIVE"]){
        [cell.linquButton setTitle:@"领取" forState:UIControlStateNormal];
        
    }else if ([dic[@"vip_reward_state"] isEqualToString:@"SEND_UNUSUAL"]){
        [cell.linquButton setTitle:@"发放异常" forState:UIControlStateNormal];
        
    }else if ([dic[@"vip_reward_state"] isEqualToString:@"CANCELLED"]){
        [cell.linquButton setTitle:@"已取消" forState:UIControlStateNormal];
    }else if ([dic[@"vip_reward_state"] isEqualToString:@"SEND_OUT"]){
        [cell.linquButton setTitle:@"已领取" forState:UIControlStateNormal];
    }
    [cell.linquButton addTarget:self action:@selector(lingqu:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
-(void)lingqu:(UIButton *)sender{
    NSLog(@"indexPath==%ld",(long)sender.tag);
//    [SYObject startLoading];

    NSDictionary *dic =self.dataArr[sender.tag];
//    NSLog(@"NSDictionary=%@",dic);
    NSString *ID= dic[@"id"];
    NSLog(@"ID=%@",ID);
    //领取钱币
    NSString *urlStr= [NSString stringWithFormat:@"%@%@",FIRST_URL,LINGQU_URL];
    
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    
    NSDictionary *par=@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1],@"id":ID};
    __weak typeof(self) ws= self;
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSLog(@"======%@",dic);
            NSString *ret=[NSString stringWithFormat:@"%@",dic[@"ret"]];
        if ([ret isEqualToString:@"RECEIVED"]) {
            [SYObject failedPrompt:@"已领取"];
//            [ws getData];
        }else if ([ret isEqualToString:@"WAITING_RECEIVE"]){
            [SYObject failedPrompt:@"等待领取"];

        }else if ([ret isEqualToString:@"SEND_OUT"]){
            [SYObject failedPrompt:@"奖励已发放到我的红包"];
            [ws getData];
            
        }else if ([ret isEqualToString:@"0"]) {
            [SYObject failedPrompt:@"该奖励已被领取"];
        }
//        if ([ret isEqualToString:@"-3"]) {
//            [SYObject startLoadingWithTitle:@"领取太频繁了"];
//            [ws getData];
//        }else if ([ret isEqualToString:@"-1"]){
//            [SYObject startLoadingWithTitle:@"ID错误,奖励记录不存在"];
//
//        }else if ([ret isEqualToString:@"5"]){
//            [SYObject failedPrompt:@"已领取"];
//            
//        }else if ([ret isEqualToString:@"4"]){
//            [SYObject failedPrompt:@"奖励已发放到我的红包"];
//            
//        }else if ([ret isEqualToString:@"-2"]){
//            [SYObject failedPrompt:@"异常领取,只能领取自己的奖励"];
//            
//        }else if ([ret isEqualToString:@"-4"]){
//        
//            [SYObject failedPrompt:@"系统异常"];
//            
//        }else if ([ret isEqualToString:@"0"]){
//            [SYObject failedPrompt:@"该奖励已被领取"];
//            
//        }
        [SYObject endLoading];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        [SYObject endLoading];

    }];

}
#pragma mark 保存奖励到余额中
-(void)sendToAccount:(NSString *)ID{

    NSString *urlStr= [NSString stringWithFormat:@"%@%@",FIRST_URL,SAVE_TO_ACCOUNT_URL];
    
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    
    NSDictionary *par=@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1],@"id":ID};
    __weak typeof(self) ws= self;
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSLog(@"+++==%@",dic);
        if ([dic[@"ret"] isEqualToString:@"1"]) {
            [SYObject startLoadingWithTitle:@"领取成功"];
            [ws getData];
        }else if ([dic[@"ret"] isEqualToString:@"-1"]){
            [SYObject startLoadingWithTitle:@"奖励记录不存在"];
            
        }else if ([dic[@"ret"] isEqualToString:@"0"]){
            [SYObject failedPrompt:@"该奖励已被领取"];
            
        }else if ([dic[@"ret"] isEqualToString:@"-4"]){
            [SYObject failedPrompt:@"该奖励状态异常,只有未领取的奖励才能领取"];
            
        }else if ([dic[@"ret"] isEqualToString:@"-3"]){
            [SYObject failedPrompt:@"异常领取,只能领取自己的奖励"];
            
        }else if ([dic[@"ret"] isEqualToString:@"-2"]){
           
            [SYObject failedPrompt:@"此用户不存在"];
            
        }
        [SYObject endLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        [SYObject endLoading];
        
    }];
    
}
@end
