//
//  ThirdSubTableViewController.m
//  My_App
//
//  Created by 邱炯辉 on 16/6/23.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "ThirdSubTableViewController.h"

#import "ThirdSubTableViewController.h"
#import "TeamTableViewCell.h"
#import "SubTeamTableViewController.h"
@interface ThirdSubTableViewController ()
{
    int _start;
    
    
}
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation ThirdSubTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _start=0;
    _dataArr =[[NSMutableArray alloc]init];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TeamTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TeamTableViewCell"];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.estimatedRowHeight= 70;
    self.tableView.rowHeight= 70;
    
    self.tableView.tableFooterView =[[UIView alloc]init];
    [self getData];
    
}


///app/buyer/vip_team_manage.htm
#pragma mark 获取数据
-(void)getData{
    
    NSString *str=[NSString stringWithFormat:@"%d",_start];
    
    NSString *urlStr= [NSString stringWithFormat:@"%@%@",FIRST_URL,TEAM_URL];
    
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    
    NSDictionary *par=@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1],@"begincount":str ,@"selectcount":@"10",@"select_user_id":_userId};
    //
    __weak typeof(self) ws= self;
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"ret"] isEqualToString:@"-4"]) {
            [SYObject failedPrompt:@"系统异常"];
        }else if ([responseObject[@"ret"] isEqualToString:@"1"]) {
            NSArray *arr =responseObject[@"teamlist"];
            NSLog(@"arr==%@",arr);
            if (_start==0) {
                [ws.dataArr removeAllObjects];
            }
            [ws.dataArr addObjectsFromArray:arr];
            
            
        }
        UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 60)];
        
        UILabel *line1=[[UILabel alloc]initWithFrame:CGRectMake(5, 31, ScreenFrame.size.width-10, 1)];
        line1.backgroundColor=[UIColor colorWithRed:214/255.0 green:216/255.0 blue:213/255.0 alpha:1];
        
        [header addSubview:line1];
        
        UILabel *line2=[[UILabel alloc]initWithFrame:CGRectMake(5, 60, ScreenFrame.size.width-10, 1)];
        line2.backgroundColor=[UIColor colorWithRed:214/255.0 green:216/255.0 blue:213/255.0 alpha:1];
        
        [header addSubview:line2];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 30)];
        label.textAlignment=NSTextAlignmentCenter;
        [header addSubview:label];
        label.text=[NSString stringWithFormat:@"梦想e+:%@人 激情e+:%@人 疯狂e+:%@人",responseObject[@"child_one_total"],responseObject[@"child_two_total"],responseObject[@"child_three_total"]];
        
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(0, 30, ScreenFrame.size.width, 30)];
        label2.textAlignment=NSTextAlignmentCenter;
        [header addSubview:label2];
        
        label2.text=[NSString stringWithFormat:@"疯狂e+"];
        self.tableView.tableHeaderView=header;
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
    TeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamTableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    if (ScreenFrame.size.width  ==320) {//说明是4 4s 5 5s
        cell.nickNameLabel.font =[UIFont systemFontOfSize:15];
        cell.relationshipLabel.font =[UIFont systemFontOfSize:13];
        cell.timeLabel.font =[UIFont systemFontOfSize:13];
        
    }
    
    
    NSDictionary *dic=self.dataArr[indexPath.row];
    [cell.headImageview sd_setImageWithURL:[NSURL URLWithString:dic[@"photo_url"]]];
    cell.nickNameLabel.text =dic[@"userName"];
//    cell.relationshipLabel.text =[NSString stringWithFormat:@"%@%@ %@人",@"层级关系：",dic[@"linkname"],dic[@"child_size"]];
    
    cell.relationshipLabel.text =[NSString stringWithFormat:@" %@人",dic[@"child_size"]];

    cell.timeLabel.text =[NSString stringWithFormat:@"%@%@",@"加入时间：",dic[@"addTime"]];
    NSString *icon=[NSString stringWithFormat:@"%@%@",FIRST_URL,dic[@"gradeName"][@"icon"]];
    cell.rankImageview.contentMode=UIViewContentModeScaleAspectFit;
    [cell.rankImageview sd_setImageWithURL:[NSURL URLWithString:icon]];
    
    cell.rankDetailLabel.text =dic[@"gradeName"][@"name"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


@end
