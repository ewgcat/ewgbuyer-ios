//
//  getAllActivityNavViewController.m
//  My_App
//
//  Created by apple on 15/10/20.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "getAllActivityNavViewController.h"
#import "activity0Cell.h"
#import "getActivityGoodsViewController.h"

@interface getAllActivityNavViewController ()<UIGestureRecognizerDelegate>
{
    ASIFormDataRequest *RequestSave;
}

@end

static getAllActivityNavViewController *singleInstance=nil;

@implementation getAllActivityNavViewController

+(id)sharedUserDefault
{
    if(singleInstance==nil)
    {
        @synchronized(self)
        {
            if(singleInstance==nil)
            {
                singleInstance=[[[self class] alloc] init];
            }
        }
    }
    return singleInstance;
}

+ (id)allocWithZone:(NSZone *)zone;
{
    if(singleInstance==nil)
    {
        singleInstance=[super allocWithZone:zone];
    }
    return singleInstance;
}

-(id)copyWithZone:(NSZone *)zone
{
    
    return singleInstance;
}
#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1){  //关闭主界面的右滑返回
        return NO;
    }else{
        
        return YES;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [RequestSave clearDelegatesAndCancel];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"促销";
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    MyTableView.delegate = self;
    MyTableView.dataSource = self;
    
    dataArray = [[NSMutableArray alloc]init];
    [SYObject startLoading];
    RequestSave = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,GETALLACTIVITYNAV_URL] setKey:nil setValue:nil];
    RequestSave.delegate = self;
    [RequestSave setDidFailSelector:@selector(RequestFailed:)];
    [RequestSave setDidFinishSelector:@selector(GetuserMsgSucceeded:)];
    [RequestSave startAsynchronous];
    
   
}

-(void)GetuserMsgSucceeded:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    
    
    if ([request  responseStatusCode] == 200){
        [dataArray removeAllObjects];
        dataArray = [consultViewNetwork dataActivityData:request];
        if (dataArray.count == 0) {
            MyTableView.hidden = YES;
        }else{
            MyTableView.hidden = NO;
        }
        [MyTableView reloadData];
    }else{
        [SYObject endLoading];
        [SYObject failedPrompt:@"请求出错，请重试"];
    }
    
}
-(void)RequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
     
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArray.count!=0) {
        return dataArray.count ;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  32*ScreenFrame.size.width/95+35;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    activity0Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"activity0Cell"];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"activity0Cell" owner:self options:nil] lastObject];
    }
    if (dataArray.count!=0) {
        ClassifyModel *class = [dataArray objectAtIndex:indexPath.row];
        [cell setData:class];   
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (dataArray.count!=0) {
        _classifyModel = [dataArray objectAtIndex:indexPath.row];
        getActivityGoodsViewController *get = [[getActivityGoodsViewController alloc]init];
        [self.navigationController pushViewController:get animated:YES];
    }
}

@end
