//
//  TopicViewController.m
//  My_App
//
//  Created by barney on 15/11/25.
//  Copyright © 2015年 barney. All rights reserved.
//

#import "TopicViewController.h"
#import "ASIFormDataRequest.h"
#import "UIImageView+WebCache.h"
#import "TSTopic.h"
#import "TopicCell.h"
#import "SingleOC.h"
@interface TopicViewController ()<UITableViewDataSource,UITabBarDelegate,UITableViewDelegate,ASIHTTPRequestDelegate>

@end

@implementation TopicViewController
{
    
    UITableView *_tabView;
    NSMutableArray *dataArray;
    ASIFormDataRequest *request_1;

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"主题";
    dataArray = [[NSMutableArray alloc]init];
    [self createView];
    [self createBackBtn];
    [self downloadData];
    
}
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createView
{
    _tabView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-64) style:(UITableViewStylePlain)];
    _tabView.delegate =self;
    _tabView.dataSource= self;
    _tabView.showsVerticalScrollIndicator=NO;
    _tabView.showsHorizontalScrollIndicator = NO;
    
    _tabView.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    _tabView.separatorColor=[UIColor clearColor];
    
    [self.view addSubview:_tabView];
    
}

#pragma mark- ASIrequest
-(void) downloadData
{
    [SYObject startLoading];
    NSURL *url = [NSURL URLWithString:
                   [NSString stringWithFormat:@"%@%@",
                    FIRST_URL,
                    TSTopic_URL
                    ]];
    request_1=[ASIFormDataRequest requestWithURL:url];
    //[request_1 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_1.delegate =self;
    [request_1 setDidFailSelector:@selector(my_urlRequestFailed:)];
    [request_1 setDidFinishSelector:@selector(my_urlRequestSucceeded:)];
    [request_1 startAsynchronous];
}

// 请求成功(第一次进入页面的请求)
-(void)my_urlRequestSucceeded:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"投诉主题===========%@", dicBig);
        // 每次请求都清空数据源
        if (dataArray.count!=0)
        {
            [dataArray removeAllObjects];
        }
        if (dicBig) {
            
            NSArray *arr = [dicBig objectForKey:@"datas"];
            for(NSDictionary *dic in arr){
                TSTopic *clas = [[TSTopic alloc]init];
                clas.content = [dic objectForKey:@"content"];
                clas.title = [dic objectForKey:@"title"];
                clas.cs_id=[dic objectForKey:@"id"];
                [dataArray addObject:clas];
                
            }
            if (dataArray.count ==0) {
                _tabView.hidden = YES;
                [SYObject failedPrompt:@"抱歉,系统未设主题,暂不可投诉"];
                
            }else{
                _tabView.hidden = NO;
               
            }
            
            // 下载成功刷新数据源
            [_tabView reloadData];
            
        }
        
        else
        {
            [SYObject failedPrompt:@"请求出错"];
        }
    }
}
-(void)my_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
    
}
//失败调用
-(void)failedPrompt:(NSString *)prompt
{
    [SYObject endLoading];
    [SYObject failedPrompt:prompt];
}
#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Cell = @"TopicCell";
    TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
    
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TopicCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (dataArray.count !=0) {
        
        TSTopic *cla = [dataArray objectAtIndex:indexPath.row];
    
        cell.titleLab.text=cla.title;
        cell.contentLab.text=cla.content;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController popViewControllerAnimated:YES];
    TSTopic *cla = [dataArray objectAtIndex:indexPath.row];
    [SingleOC share].topic=cla.title;
    [SingleOC share].topicID=cla.cs_id;


}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request_1 clearDelegatesAndCancel];

    
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
