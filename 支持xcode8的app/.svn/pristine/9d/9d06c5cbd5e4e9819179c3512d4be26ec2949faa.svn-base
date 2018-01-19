//
//  EBiRecordTableViewController.m
//  My_App
//
//  Created by 邱炯辉 on 16/6/24.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "EBiRecordTableViewController.h"
#import "EBIRecordTableViewCell.h"
@interface EBiRecordTableViewController ()
{
    
    NSMutableArray *_dataArr;
    
    int _start;
}
@end


@implementation EBiRecordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"提现记录";
    _dataArr =[NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:@"EBIRecordTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"EBIRecordTableViewCell"];
    [self getData];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];

    self.tableView.estimatedRowHeight=50;
    self.tableView.rowHeight=50;
    self.tableView.tableFooterView=[[UIView alloc]init];
}

-(void)getData{
    
    [SYObject startLoading];
    
    NSString *str=[NSString stringWithFormat:@"%d",_start];
    
    ASIFormDataRequest *request102;
    
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,@"/app/buyer/egoldapply_list_item.htm"]];
    request102=[ASIFormDataRequest requestWithURL:url];
    [request102 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request102 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    [request102 setPostValue:str forKey:@"begincount"];
    
    [request102 setPostValue:@"10" forKey:@"selectcount"];
    
    
    [request102 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request102.tag = 102;
    [request102 setDelegate:self];
    [request102 setDidFailSelector:@selector(urlRequestFailed:)];
    [request102 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [request102 startAsynchronous];
    
}

#pragma mark - 网络
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary*dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig:%@",dicBig);
        
        if (_start==0) {
            [_dataArr removeAllObjects];
        }
        NSString *ret=[NSString stringWithFormat:@"%@", dicBig[@"ret"]];
        if ([ret isEqualToString:@"1"]) {
            
            if ([dicBig[@"list"] count]==0) {
                [SYObject failedPrompt:@"暂无记录"];
            }
            if (dicBig[@"list"]) {
                [_dataArr addObjectsFromArray:dicBig[@"list"]];

            }
        }
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
            
            
      
    }
    [SYObject endLoading];
}

-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
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
    EBIRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EBIRecordTableViewCell"];
    
    NSDictionary *dic=_dataArr[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if(dic[@"money"]) {
          cell.moneyLabel.text=[NSString stringWithFormat:@"¥%@", dic[@"money"]];

    }
    if (dic[@"check_status"]) {
        if ([dic[@"check_status"] isEqualToString:@"NO_CHECK"]) {
            cell.stateLabel.text=@"未审核";

        }else if([dic[@"check_status"] isEqualToString:@"CHECKED"]){
            cell.stateLabel.text=@"已审核";

        }else if([dic[@"check_status"] isEqualToString:@"CHECKED_IN"]){
            cell.stateLabel.text=@"已审核 -已到账";
            if (dic[@"check_time"]) {
                cell.timeLabel.text=dic[@"check_time"];
                
            }
            
        }else if([dic[@"check_status"] isEqualToString:@"CHECKED_NO"]){
            cell.stateLabel.text=@"已审核 -未到账";
            if (dic[@"check_time"]) {
                cell.timeLabel.text=dic[@"check_time"];
                
            }
            
        }else if([dic[@"check_status"] isEqualToString:@"CHECKED_OUT"]){
            if (dic[@"remark"]) {
                cell.stateLabel.text=[NSString stringWithFormat:@"审核未通过:%@",dic[@"remark"]];

            }else{
                cell.stateLabel.text=@"审核未通过";

            }
            
            if (dic[@"check_time"]) {
                cell.timeLabel.text=dic[@"check_time"];

            }
        }
        
    }

    // Configure the cell...
    
    return cell;
}




@end
