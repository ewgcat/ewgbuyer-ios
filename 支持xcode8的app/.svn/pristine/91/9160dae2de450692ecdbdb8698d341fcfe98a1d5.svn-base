
//
//  EBiViewController.m
//  My_App
//
//  Created by 邱炯辉 on 16/6/23.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "EBiViewController.h"
#import "EBishenqingTableViewController.h"
@interface EBiViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    NSMutableArray *_dataArr;
    NSDictionary *_dic;
    
    int _start;
    
    NSString *_myEBi;
}
@property(nonatomic,strong)   UITableView *tableView;
@property(nonatomic,strong)   UIButton *mybutton;

@end

@implementation EBiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"E币";
    self.view.backgroundColor=[UIColor whiteColor];
    _dic=[[NSDictionary alloc]init];
    _dataArr=[NSMutableArray array];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getData];

}
-(void)getData{
    
    [SYObject startLoading];
    
    NSString *str=[NSString stringWithFormat:@"%d",_start];
    
    ASIFormDataRequest *request102;
    
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/app/buyer/egolddetails.htm",FIRST_URL]];
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
        _dic =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig:%@",_dic);
        
        NSString *ret=[NSString stringWithFormat:@"%@",_dic[@"ret"]];
        if([ret isEqualToString:@"1"]){
        
            
            if (_start==0) {
                [_dataArr removeAllObjects];
            }
            [_dataArr addObjectsFromArray: _dic[@"list"]];
            NSLog(@"_dataArr==%zd",_dataArr.count);
            [self createUI];
            
            [self.tableView reloadData];
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];

        
        }
        
        
    }
    [SYObject endLoading];
}

-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
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
-(UIView *)createHeaderview{
    UIView *headerview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width,180)];
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(20, 20, 200, 30)];
    if (_dic[@"e_gold"]) {
        label1.text=[NSString stringWithFormat:@"我的E币:%@ 个",_dic[@"e_gold"]];
        _myEBi=_dic[@"e_gold"];
    }
   
    [headerview addSubview:label1];
    
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(20, 60, 200, 30)];
    label2.text=[NSString stringWithFormat:@"冻结E币:%@个",_dic[@"freeze_e_gold"]];
    [headerview addSubview:label2];
    
    
   _mybutton=[[UIButton alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(label2.frame)+25, ScreenFrame.size.width-100, 30)];
    
    
    
    NSString *fff=[NSString stringWithFormat:@"%@", _dic[@"substate"]];
    if([fff isEqualToString:@"0"]){//未到提现日期
        
        NSString *s=[NSString stringWithFormat:@"每月提现日期:%@号", _dic[@"egoldsub"]];
        [self.mybutton setTitle:s forState:UIControlStateNormal];
        [self.mybutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.mybutton.backgroundColor=[UIColor whiteColor];
    }else{
        NSString *s=@"提现申请";
        [self.mybutton setTitle:s forState:UIControlStateNormal];
        self.mybutton.backgroundColor=[UIColor redColor];
          [_mybutton addTarget:self action:@selector(tixian) forControlEvents:UIControlEventTouchUpInside];
    }

  
    [headerview addSubview:_mybutton];
    
    headerview.userInteractionEnabled=YES;
    UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_mybutton.frame)+10, 200, 30)];
    label3.text=@"获取E币纪录";
    label3.textColor=[UIColor lightGrayColor];
    [headerview addSubview:label3];
    return headerview;

}
-(void)createUI{

    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableHeaderView=[self createHeaderview];
    _tableView.tableFooterView=[[UIView alloc]init];

    [self.view addSubview:_tableView];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.estimatedRowHeight= 44;
    self.tableView.rowHeight= 44;
    self.tableView.tableFooterView =[[UIView alloc]init];

}
-(void)tixian{
    
    if (_myEBi.intValue>0) {
        EBishenqingTableViewController *v=[[EBishenqingTableViewController alloc]init];
        [self.navigationController pushViewController:v animated:YES];
        
    }else{
        [SYObject failedPrompt:@"E币不足"];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        
        UILabel *s=[[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-50-10, 7, 50, 30)];
        cell.accessoryView=s;
    }
    NSDictionary *dic=_dataArr[indexPath.row];
    
    
    if ([dic[@"EGOLDSOURCE"] isEqualToString:@"CHILD_ACTIVATION"]){
        cell.textLabel.text=[NSString stringWithFormat:@"下级激活赠送"];
      UILabel *la=(UILabel *) cell.accessoryView;
        la.text=[NSString stringWithFormat:@"+%@",dic[@"e_gold"]];
        

    }else if ([dic[@"EGOLDSOURCE"] isEqualToString:@"CHILD_REGISTER"]){
        cell.textLabel.text=[NSString stringWithFormat:@"下级注册  赠送"];
        UILabel *la=(UILabel *) cell.accessoryView;
        la.text=[NSString stringWithFormat:@"+%@",dic[@"e_gold"]];

   
    }
    cell.detailTextLabel.text=dic[@"addTime"];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
