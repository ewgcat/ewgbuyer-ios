//
//  MyMessageViewController.m
//  My_App
//
//  Created by apple on 14-8-6.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "MyMessageViewController.h"
#import "ASIFormDataRequest.h"
#import "MyMessageModel.h"
#import "FirstViewController.h"
#import "ThreeDotView.h"


@interface MyMessageViewController ()<UIGestureRecognizerDelegate>

@property (assign)NSUInteger lastCount;

@end

@implementation MyMessageViewController
- (IBAction)tabbarBtnClicked:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:NO];
    UIButton *btn = (UIButton *)sender;
    FirstViewController *first = [FirstViewController sharedUserDefault];
    if (btn.tag == 101) {
        [first tabbarIndex:0];
    }else if (btn.tag == 102) {
        [first tabbarIndex:1];
    }else if (btn.tag == 103) {
        [first tabbarIndex:2];
    }else if (btn.tag == 104) {
        [first tabbarIndex:3];
    }else{
        [first tabbarIndex:4];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [requestMessage1 clearDelegatesAndCancel];
    [requestMessage2 clearDelegatesAndCancel];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    promptView.hidden=YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    requestBool = NO;
    secondBtn.hidden=YES;
    thirdBtn.hidden=YES;
    fouthBtn.hidden=YES;
    fifthBtn.hidden=YES;
    [self createBackBtn];
    [self createBackBtn1];
    dataArrShangla = [[NSMutableArray alloc]init];
    dataArr = [[NSMutableArray alloc]init];
    self.title = @"我的消息";
    self.view.backgroundColor = UIColorFromRGB(0Xf0f0f0);
    
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    
    shjTableView.backgroundColor = [UIColor clearColor];
    shjTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    shjTableView.delegate = self;
    shjTableView.dataSource= self;
    shjTableView.showsVerticalScrollIndicator = YES;
    shjTableView.showsHorizontalScrollIndicator = NO;
    [shjTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [SYObject startLoading];
    
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    if (!readPath2) {
        return;
    }
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,MESSAGE_URL]];
    requestMessage1 = [ASIFormDataRequest requestWithURL:url];
    [requestMessage1 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [requestMessage1 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    
    [requestMessage1 setPostValue:@"0" forKey:@"beginCount"];
    [requestMessage1 setPostValue:@"20" forKey:@"selectCount"];
    
    [requestMessage1 setRequestHeaders:[LJControl requestHeaderDictionary]];
    requestMessage1.tag = 101;
    [requestMessage1 setDelegate:self];
    [requestMessage1 setDidFailSelector:@selector(urlRequestFailed:)];
    [requestMessage1 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [requestMessage1 startAsynchronous];
    muchBool = NO;
    muchView.hidden = YES;
    [grayMuchImage.layer setMasksToBounds:YES];
    [grayMuchImage.layer setCornerRadius:4];
    
    //[SYObject startLoading];
//    [SYObject checkLogin:self.navigationController s:^(BOOL login) {
        //[SYObject endLoading];
        
//        if (login) {
        
//        }
        
        
//    }];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
       if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    requestBool = NO;
    secondBtn.hidden=YES;
    thirdBtn.hidden=YES;
    fouthBtn.hidden=YES;
    fifthBtn.hidden=YES;
    [self createBackBtn];
    [self createBackBtn1];
    dataArrShangla = [[NSMutableArray alloc]init];
    dataArr = [[NSMutableArray alloc]init];
    self.title = @"我的消息";
    self.view.backgroundColor = UIColorFromRGB(0Xf0f0f0);
   
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    shjTableView.backgroundColor = [UIColor clearColor];
    shjTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    shjTableView.delegate = self;
    shjTableView.dataSource= self;
    shjTableView.showsVerticalScrollIndicator = YES;
    shjTableView.showsHorizontalScrollIndicator = NO;
    [shjTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //[SYObject startLoading];
    
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,MESSAGE_URL]];
    requestMessage1 = [ASIFormDataRequest requestWithURL:url];
    [requestMessage1 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [requestMessage1 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    
    [requestMessage1 setPostValue:@"0" forKey:@"beginCount"];
    [requestMessage1 setPostValue:@"20" forKey:@"selectCount"];
    
    [requestMessage1 setRequestHeaders:[LJControl requestHeaderDictionary]];
    requestMessage1.tag = 101;
    [requestMessage1 setDelegate:self];
    [requestMessage1 setDidFailSelector:@selector(urlRequestFailed:)];
    [requestMessage1 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [requestMessage1 startAsynchronous];
    muchBool = NO;
    muchView.hidden = YES;
    [grayMuchImage.layer setMasksToBounds:YES];
    [grayMuchImage.layer setCornerRadius:4];
  
}
-(void)headerRereshing
{
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,MESSAGE_URL]];
    requestMessage1 = [ASIFormDataRequest requestWithURL:url];
    [requestMessage1 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [requestMessage1 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    
    [requestMessage1 setPostValue:@"0" forKey:@"beginCount"];
    [requestMessage1 setPostValue:@"20" forKey:@"selectCount"];
    
    [requestMessage1 setRequestHeaders:[LJControl requestHeaderDictionary]];
    requestMessage1.tag = 101;
    [requestMessage1 setDelegate:self];
    [requestMessage1 setDidFailSelector:@selector(urlRequestFailed:)];
    [requestMessage1 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [requestMessage1 startAsynchronous];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tdv.hidden = YES;

}

//重写返回按钮
-(void)createBackBtn1{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1){
        //关闭主界面的右滑返回
        return NO;
    }else{
        
        return YES;
    }
}
#pragma mark - tableView delegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == dataArr.count - 1 && dataArr.count != 0 && dataArr.count != self.lastCount) {
        [self footerRereshing];
        self.lastCount = dataArr.count;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArr.count != 0) {
        return dataArr.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell%ld_%ld", (long)indexPath.section, (long)indexPath.row]];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:[NSString stringWithFormat:@"cell%ld_%ld", (long)indexPath.section, (long)indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        for (UIView *subView in cell.contentView.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    if(dataArr.count != 0){
        MyMessageModel *shjmsm = [dataArr objectAtIndex:indexPath.row];
        UIImageView *imgBG = [[UIImageView alloc]init];

        [imgBG.layer setMasksToBounds:YES];
        [imgBG.layer setCornerRadius:4.0];
        [cell addSubview:imgBG];
        UIView *whiteView=[LJControl viewFrame:CGRectMake(10, 10, ScreenFrame.size.width-20, cell.frame.size.height-5) backgroundColor:[UIColor whiteColor]];
        [whiteView.layer setMasksToBounds:YES];
        [whiteView.layer setCornerRadius:4.0];
        [cell addSubview:whiteView];
        UILabel *lblFromUser = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, ScreenFrame.size.width-40, 21)];
        lblFromUser.backgroundColor = [UIColor clearColor];
        lblFromUser.text = [NSString stringWithFormat:@"%@",shjmsm.msm_fromUser];
        
        lblFromUser.textAlignment = NSTextAlignmentLeft;
        lblFromUser.font = [UIFont fontWithName:@"Arial" size:15.0f];
        [cell addSubview:lblFromUser];
        
        UILabel *lbladdTime = [[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-222, 21, 200, 21)];
        lbladdTime.backgroundColor = [UIColor clearColor];
        lbladdTime.text = [NSString stringWithFormat:@"%@",shjmsm.msm_addTime];
        lbladdTime.textColor=UIColorFromRGB(0x999999);
        lbladdTime.textAlignment = NSTextAlignmentRight;
        lbladdTime.font = [UIFont fontWithName:@"Arial" size:15.0f];
        [cell addSubview:lbladdTime];
        
        UILabel *lblContent = [[UILabel alloc]init ];
        lblContent.backgroundColor = [UIColor clearColor];
        lblContent.text = [NSString stringWithFormat:@"%@",shjmsm.msm_content];
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:16]};
        CGRect requiredSize = [lblContent.text boundingRectWithSize:CGSizeMake(ScreenFrame.size.width-20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        
        CGRect rect = cell.frame;
        rect.size.height = requiredSize.size.height+30;
        cell.frame = rect;
        lblContent.frame = CGRectMake(20, 51, ScreenFrame.size.width-40, requiredSize.size.height);
       
        lblContent.textAlignment = NSTextAlignmentLeft;
        lblContent.font = [UIFont fontWithName:@"Arial" size:15.0f];
        lblContent.numberOfLines = 0;
        [cell addSubview:lblContent];
        
        imgBG.frame =CGRectMake(10, 10, ScreenFrame.size.width-20, cell.frame.size.height-2);
        cell.backgroundColor = [UIColor clearColor];
        whiteView.frame=CGRectMake(10, 10, ScreenFrame.size.width-20, cell.frame.size.height+25-2);
      
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [ self tableView:tableView cellForRowAtIndexPath:indexPath ];
    return cell.frame.size.height+35;
}

#pragma mark - 返回按钮
-(void)createBackBtn{
    UIButton *buttonChat = [UIButton buttonWithType:UIButtonTypeCustom ];
    buttonChat.frame =CGRectMake(0, 0, 24, 24);
    [buttonChat setBackgroundImage:[UIImage imageNamed:@"roundPoint"] forState:UIControlStateNormal];
    [buttonChat addTarget:self action:@selector(More) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar2 = [[UIBarButtonItem alloc]initWithCustomView:buttonChat];
    self.navigationItem.rightBarButtonItem =bar2;
}


-(void)viewDidLayoutSubviews{
    [self createMoreBtn];
}
-(void)createMoreBtn{
    ThreeDotView *tdv = [[ThreeDotView alloc]initWithButtonCount:1 nc:self.navigationController];
    self.tdv = tdv;
    tdv.vc = self;
    [tdv insertMoreBtn:[tdv homeBtn]];
    tdv.hidden = YES;
}
-(void)More{
    self.tdv.hidden = NO;
    self.tdv.tri.hidden=NO;
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 上拉刷新
-(void)footerRereshing{
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,MESSAGE_URL]];
    requestMessage2 = [ASIFormDataRequest requestWithURL:url];
    [requestMessage2 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [requestMessage2 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    
    [requestMessage2 setPostValue:[NSString stringWithFormat:@"%lu",(unsigned long)dataArr.count] forKey:@"beginCount"];
    [requestMessage2 setPostValue:@"20" forKey:@"selectCount"];
    
    [requestMessage2 setRequestHeaders:[LJControl requestHeaderDictionary]];
    requestMessage2.tag = 102;
    [requestMessage2 setDelegate:self];
    [requestMessage2 setDidFailSelector:@selector(my1_urlRequestFailed:)];
    [requestMessage2 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
    [requestMessage2 startAsynchronous];
    
}
#pragma mark -网络
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode3 = [request responseStatusCode];
    if (statuscode3 == 200) {
        NSDictionary *dicBig = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig:%@",dicBig);
        NSArray *array = [dicBig objectForKey:@"msg_list"];
        if (dataArrShangla.count!=0) {
            [dataArrShangla removeAllObjects];
        }
        for (NSDictionary *dic in array) {
            MyMessageModel *shjmsm = [[MyMessageModel alloc]init];
            shjmsm.msm_fromUser = [dic objectForKey:@"fromUser"];
            shjmsm.msm_addTime = [dic objectForKey:@"addTime"];
            shjmsm.msm_content = [dic objectForKey:@"content"];
            arr2 = [dic objectForKey:@"msg_list"];
            [dataArrShangla addObject:shjmsm];
        }
    }
    [dataArr addObjectsFromArray:dataArrShangla];
//    requestBool = YES;
    dispatch_queue_t mainQ = dispatch_get_main_queue();
    dispatch_async(mainQ, ^{
        [shjTableView reloadData];
    });
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
//        [shjTableView reloadData];
    
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//        [shjTableView footerEndRefreshing];
//    });
}
-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    promptView.hidden=NO;
    int statuscode3 = [request responseStatusCode];
    if (statuscode3 == 200) {
        [SYObject endLoading];
        NSDictionary *dicBig = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"我的消息:%@",dicBig);
        NSArray *array = [dicBig objectForKey:@"msg_list"];
        if (dataArr.count!=0)
        {
            [dataArr removeAllObjects];
        }
        if (dicBig) {
            if ([[dicBig objectForKey:@"ret"] isEqualToString:@"false"]) {
            }else{
                for (NSDictionary *dic in array) {
                    MyMessageModel *shjmsm = [[MyMessageModel alloc]init];
                    shjmsm.msm_fromUser = [dic objectForKey:@"fromUser"];
                    shjmsm.msm_addTime = [dic objectForKey:@"addTime"];
                    shjmsm.msm_content = [dic objectForKey:@"content"];
                    arr2 = [dic objectForKey:@"msg_list"];
                    [dataArr addObject:shjmsm];
                }
            }
        }
    }
    if (dataArr.count==0) {
        shjTableView.hidden = YES;
        promptView.hidden=NO;
        
    }else{
        shjTableView.hidden = NO;
        promptView.hidden=YES;
    }
    [shjTableView reloadData];
    [shjTableView headerEndRefreshing];
    
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
}

@end
