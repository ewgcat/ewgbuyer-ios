//
//  TeamTableViewController.m
//  My_App
//
//  Created by 邱炯辉 on 16/5/26.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "ManagerCarWeiTableViewController.h"

#import "CarWeiTableViewCell.h"
#import "SubTeamTableViewController.h"
@interface ManagerCarWeiTableViewController ()
{
    int _start;
    
    NSString *longStr;
}
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation ManagerCarWeiTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _start=0;
    _dataArr =[[NSMutableArray alloc]init];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CarWeiTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CarWeiTableViewCell"];
    self.tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.tableView.estimatedRowHeight= 170;
    self.tableView.rowHeight= 170;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableView.tableFooterView =[[UIView alloc]init];
    [SYObject startLoading];
    [self getData];
    
}


///app/buyer/vip_team_manage.htm
#pragma mark 获取数据
-(void)getData{
    
    
    NSString *urlStr= [NSString stringWithFormat:@"%@%@",FIRST_URL,@"/app/buyer/userpromotioncard.htm"];
    
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    
    NSDictionary *par=@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1]};
    //
    __weak typeof(self) ws= self;
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject==%@",responseObject);
        NSArray *arr=responseObject[@"queueCardInfo"];
        if (arr.count>0) {
            [ws.dataArr removeAllObjects];
            [ws.dataArr addObjectsFromArray:arr];
            [ws.tableView reloadData];
            
        }else{
            [SYObject failedPrompt:@"暂无记录"];
        }
        
        [SYObject endLoading];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"**%@",[error localizedDescription]);
        [SYObject endLoading];
        
    }];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CarWeiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CarWeiTableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
   
   
    cell.backgroundColor=[UIColor groupTableViewBackgroundColor];
    NSDictionary *dic=self.dataArr[indexPath.row];
 
    cell.baseView.layer.cornerRadius=10;
    cell.baseView.layer.masksToBounds=YES;
    cell.baseView.backgroundColor=[UIColor whiteColor];
    cell.label1.text =[NSString stringWithFormat:@"%@",dic[@"card_code"]];
    
    cell.label2.text =[NSString stringWithFormat:@"%@",dic[@"grade_name"]];
    cell.cardNumLabel.text=[NSString stringWithFormat:@"%@",dic[@"card_no"]];

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CarWeiTableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dic=self.dataArr[indexPath.row];

    cell.psaawordLabel.text=[NSString stringWithFormat:@"密码：%@",dic[@"expressly_password"]];

}

@end
