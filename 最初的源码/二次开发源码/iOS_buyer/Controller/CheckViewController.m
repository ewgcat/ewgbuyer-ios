//
//  CheckViewController.m
//  My_App
//
//  Created by apple on 14-8-25.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "CheckViewController.h"
#import "ThirdViewController.h"
#import "NilCell.h"
#import "TransCell.h"

@interface CheckViewController ()

@end

@implementation CheckViewController
{
    UIImageView *imageNothing;
    UILabel *labelNothing;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request102 clearDelegatesAndCancel];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"查看物流";
        self.view.backgroundColor=UIColorFromRGB(0xf0f0f0);
       
        [SYObject startLoading];
        MyTableView.backgroundColor=[UIColor clearColor];
        MyTableView.hidden=YES;
        ThirdViewController *th = [ThirdViewController sharedUserDefault];
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
        NSURL *url4 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,FEEFIND_URL]];
        request102=[ASIFormDataRequest requestWithURL:url4];
        [request102 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
        [request102 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
        [request102 setPostValue:th.train_order_id forKey:@"order_id"];
        
        [request102 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request102.delegate = self;
        [request102 setDidFailSelector:@selector(urlRequestFailed:)];
        [request102 setDidFinishSelector:@selector(urlRequestSucceeded:)];
        [request102 startAsynchronous];
    }
    return self;
}

-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
     [SYObject endLoading];
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
       
        MyTableView.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
        MyTableView.hidden=NO;

        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"查看物流:%@",dicBig);
        NSArray *arr = [dicBig objectForKey:@"json_list"];
        NSDictionary *content = [arr objectAtIndex:0];
        NSArray *arr2 = [content objectForKey:@"content"];
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        for(NSDictionary *dic in arr2){
            ClassifyModel *class = [[ClassifyModel alloc]init];
            class.trans_time = [dic objectForKey:@"time"];
            class.trans_content = [dic objectForKey:@"content"];
            [dataArray addObject:class];
        }
        if (dataArray.count ==0) {
            MyTableView.hidden = YES;
            [SYObject failedPrompt:@"抱歉，暂无数据"];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, ScreenFrame.size.width, 75)];
            label.numberOfLines=2;
            label.textAlignment = NSTextAlignmentCenter;
            label.text = [content objectForKey:@"message"];
            [self.view addSubview:label];
        }else{
            MyTableView.hidden = NO;
        }
    }else{
        NSLog(@"!=200");
    
            [SYObject failedPrompt:@"请求失败"];
            [self createNothing];
        
    }
    [MyTableView reloadData];
    
}
-(void)createNothing
{

    imageNothing = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenFrame.size.width-200)/2, (ScreenFrame.size.height-250)/4, 200, 250)];
    imageNothing.image = [UIImage imageNamed:@"seller_center_nothing.png"];
    [self.view addSubview:imageNothing];
    labelNothing = [[UILabel alloc]initWithFrame:CGRectMake(0, imageNothing.frame.origin.y+imageNothing.frame.size.height, ScreenFrame.size.width, 30)];
    labelNothing.text = @"抱歉，没有找到相关数据";
    labelNothing.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labelNothing];


}
-(void)urlRequestFailed:(ASIFormDataRequest *)request
{      [SYObject endLoading];
       [SYObject failedPrompt:@"请求失败"];
       [self createNothing];
}

-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    [request102 cancel];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createBackBtn];
    [self createTableView];
    dataArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-tableView方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArray.count!=0) {
        return dataArray.count;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     TransCell *cell=[[[NSBundle mainBundle] loadNibNamed:@"TransCell" owner:self options:nil] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (dataArray.count!=0) {
        ClassifyModel *class = [dataArray objectAtIndex:indexPath.row];

        cell.timeLab.text=class.trans_time;
        cell.contentLab.text=class.trans_content;
        if (indexPath.row==0)
        {
            cell.timeLab.textColor=UIColorFromRGB(0X66cc00);//[UIColor redColor];
            cell.contentLab.textColor=UIColorFromRGB(0X66cc00);//[UIColor redColor];
            [cell.img setImage:[UIImage imageNamed:@"transNodeFinal.png"]];
        }
        
        
    }
    return cell;
}

-(void)createTableView{
    //iOS 适配加载视图
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    
    
    MyTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-64) style:(UITableViewStylePlain)];
    MyTableView.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MyTableView.delegate = self;
    MyTableView.dataSource = self;
    MyTableView.showsVerticalScrollIndicator=NO;
    MyTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:MyTableView];
    UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backBtnClicked)];
    rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
    [MyTableView addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];
}

@end
