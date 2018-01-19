//
//  TeamTableViewController.m
//  My_App
//
//  Created by 邱炯辉 on 16/5/26.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "TeamManagerTableViewController.h"

#import "Team2222TableViewCell.h"
#import "SubTeamTableViewController.h"
@interface TeamManagerTableViewController ()
{
    int _start;
    
    NSString *longStr;
}
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation  TeamManagerTableViewController 


- (void)viewDidLoad {
    [super viewDidLoad];
    _start=0;
    _dataArr =[[NSMutableArray alloc]init];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"Team2222TableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Team2222TableViewCell"];
 
    self.tableView.estimatedRowHeight= 70;
    self.tableView.rowHeight= 70;
    
    self.tableView.tableFooterView =[[UIView alloc]init];
    [SYObject startLoading];
    [self getData];
    
}


///app/buyer/vip_team_manage.htm
#pragma mark 获取数据
-(void)getData{
    
    
    NSString *urlStr= [NSString stringWithFormat:@"%@%@",FIRST_URL,@"/app/buyer/userpromotionteam.htm"];
    
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    
    NSDictionary *par=@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1]};
    //
    __weak typeof(self) ws= self;
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
     
            NSArray *arr =responseObject[@"userPromotionTeam"];
            NSLog(@"arr==%@",arr);
        if(arr.count==0){
            [SYObject failedPrompt:@"暂无记录"];
        }
            [ws.dataArr removeAllObjects];
        
            [ws.dataArr addObjectsFromArray:arr];
            [ws.tableView reloadData];
    
        [SYObject endLoading];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Team2222TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Team2222TableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
 
    if (indexPath.row>=0 && indexPath.row<=2) {
 
        cell.label1.textColor=cell.label2.textColor=cell.label3.textColor=[UIColor redColor];

        cell.label1.font=cell.label2.font=cell.label3.font=[UIFont systemFontOfSize:19];
        
    }else{
        
        cell.label1.textColor=cell.label2.textColor=cell.label3.textColor=[UIColor blackColor];
        cell.label1.font=cell.label2.font=cell.label3.font=[UIFont systemFontOfSize:16];
    }
    
    
    NSDictionary *dic=self.dataArr[indexPath.row];
  
    cell.label1.text =[NSString stringWithFormat:@"%zd",indexPath.row+1];

    cell.label3.text =[NSString stringWithFormat:@"%@%@",@"等级：",dic[@"grade_name"]];
    
    cell.label2.text =[NSString stringWithFormat:@"名字：%@",dic[@"team_username"]]; 
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


@end
