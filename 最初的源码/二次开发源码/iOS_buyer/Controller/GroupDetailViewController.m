//
//  GroupDetailViewController.m
//  My_App
//
//  Created by apple on 15-1-7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "GroupDetailViewController.h"
#import "SubmitOrdersViewController.h"
#import "LifeGroupHomeViewController.h"
#import "ASIFormDataRequest.h"
#import "NewLoginViewController.h"

@interface GroupDetailViewController ()

@end

@implementation GroupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    self.view.backgroundColor = [UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:255/255.0f];
    [self createBackBtn];
    [self createTableView];
    
    LifeGroupHomeViewController *lgh = [LifeGroupHomeViewController sharedUserDefault];
    
    myWebView=[[UIWebView alloc] initWithFrame:CGRectMake(0, shjTableView.frame.size.height+64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    myWebView.backgroundColor = [UIColor whiteColor];
    NSURL *url32=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%@",FIRST_URL,LIFEDETAILWEB_URL,lgh.gg_id]];
    NSURLRequest *requestweb=[[NSURLRequest alloc] initWithURL:url32];
    [myWebView loadRequest:requestweb];
    myWebView.delegate = self;
    [self.view addSubview:myWebView];
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -180-myWebView.scrollView.bounds.size.height, myWebView.scrollView.frame.size.width, myWebView.scrollView.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    myWebView.scrollView.delegate = self;
    [myWebView.scrollView addSubview:_refreshHeaderView];
    [_refreshHeaderView refreshLastUpdatedDate];
    // Do any additional setup after loading the view.
}

#pragma mark 创建TableView
-(void)createTableView{
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    
    if (ScreenFrame.size.height>480) {//说明是5 5s
        shjTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ScreenFrame.origin.y+44+20, ScreenFrame.size.width, ScreenFrame.size.height-64) style:UITableViewStylePlain];
    }else{
        shjTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ScreenFrame.origin.y+44+20, ScreenFrame.size.width, ScreenFrame.size.height-64) style:UITableViewStylePlain];
    }
    shjTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    shjTableView.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:242/255.0f];
    shjTableView.delegate = self;
    shjTableView.dataSource = self;
    shjTableView.allowsSelection = NO;
    shjTableView.showsVerticalScrollIndicator= NO;
    shjTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:shjTableView];
    UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backBtnClicked)];
    rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
    [shjTableView addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return ScreenFrame.size.width +190;
    }
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *shjTableViewCell = @"LifeGroupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell%ld_%ld", (long)indexPath.section, (long)indexPath.row]];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:shjTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 0) {
        self.imgLog = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.width-40)];
        self.imgLog.userInteractionEnabled = YES;
        [cell addSubview:self.imgLog];
        UIImageView *imgTitle = [[UIImageView alloc]initWithFrame:CGRectMake(0, ScreenFrame.size.width - 100, ScreenFrame.size.width,60)];
        imgTitle.backgroundColor = [UIColor blackColor];
        imgTitle.alpha = 0.7f;
        [self.imgLog addSubview:imgTitle];
        self.lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScreenFrame.size.width - 20, 60)];
        self.lblTitle.textColor = [UIColor whiteColor];
        self.lblTitle.numberOfLines = 0;
        self.lblTitle.font = [UIFont boldSystemFontOfSize:14];
        [imgTitle addSubview:self.lblTitle];
        
        self.lblPresentPrice = [[UILabel alloc]initWithFrame:CGRectMake(15, ScreenFrame.size.width - 20, 160, 30)];
        self.lblPresentPrice.textColor = [UIColor redColor];
        self.lblPresentPrice.font = [UIFont systemFontOfSize:24];
        [cell addSubview:self.lblPresentPrice];
        
        self.lblOriginalPrice = [[UILabel alloc]initWithFrame:CGRectMake(15, ScreenFrame.size.width + 20, 160, 20)];
        self.lblOriginalPrice.textColor = [UIColor lightGrayColor];
        self.lblOriginalPrice.font = [UIFont systemFontOfSize:13];
        [cell addSubview:self.lblOriginalPrice];
        UIImageView *imgLine = [[UIImageView alloc]initWithFrame:CGRectMake(-3, 255, 80, 0.5)];
        imgLine.backgroundColor = [UIColor lightGrayColor];
        [self.lblOriginalPrice addSubview:imgLine];
        self.lblSave = [[UILabel alloc]initWithFrame:CGRectMake(15, ScreenFrame.size.width +50, 160, 20)];
        self.lblSave.textColor = [UIColor lightGrayColor];
        self.lblSave.font = [UIFont systemFontOfSize:13];
        [cell addSubview:self.lblSave];
        
        UIButton *btnGroup = [UIButton buttonWithType:UIButtonTypeCustom];
        btnGroup.frame = CGRectMake(ScreenFrame.size.width -130, ScreenFrame.size.width , 110, 40);
        btnGroup.tag = 101;
        CALayer *lay2 = btnGroup.layer;
        [lay2 setMasksToBounds:YES];
        [lay2 setCornerRadius:5.0f];
        btnGroup.backgroundColor = MY_COLOR;
        [btnGroup setTitle:@"马上团" forState:UIControlStateNormal];
        btnGroup.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        btnGroup.titleLabel.textColor = [UIColor whiteColor];
        [btnGroup addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btnGroup];
        
        UIImageView *imgBG = [[UIImageView alloc]initWithFrame:CGRectMake(0, ScreenFrame.size.width + 90, ScreenFrame.size.width, 60)];
        imgBG.backgroundColor = [UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:255/255.0f];
        [cell addSubview:imgBG];
        self.lblCutOffTime = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 140, 30)];
        self.lblCutOffTime.font = [UIFont systemFontOfSize:13];
        [imgBG addSubview:self.lblCutOffTime];
        self.lblYishouchu = [[UILabel alloc]initWithFrame:CGRectMake(15, 30, 120, 30)];
        self.lblYishouchu.font = [UIFont systemFontOfSize:13];
        [imgBG addSubview:self.lblYishouchu];
    }
    if (indexPath.row == 1) {
        UIImageView *imgBG2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 60)];
        imgBG2.layer.borderWidth = 0.5;
        imgBG2.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        imgBG2.backgroundColor = [UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:255/255.0f];
        [cell addSubview:imgBG2];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, ScreenFrame.size.width-60, 60)];
        label.text = @"👆继续拖动,查看图文详情";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [imgBG2 addSubview:label];
    }
    return cell;
}
-(void)btnClicked:(UIButton *)btn{
    if (btn.tag == 101) {
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        if ([fileManagerDong fileExistsAtPath:readPath2]==NO) {
            [SYObject failedPrompt:@"您还未登录,请先登录"];
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(doTimerToLogin) userInfo:nil repeats:NO];
            
        }
        else{
            SubmitOrdersViewController *subOrdVC = [[SubmitOrdersViewController alloc]init];
            [self.navigationController pushViewController:subOrdVC animated:YES];
        }
    }
}

-(void)doTimerToLogin
{
    NewLoginViewController *new  = [[NewLoginViewController alloc]init];
    [self.navigationController pushViewController:new animated:YES];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (buttonIndex == 1){
        [self dismissViewControllerAnimated:YES completion:nil];
        NewLoginViewController *new = [[NewLoginViewController alloc]init];
        [self.navigationController pushViewController:new animated:YES];
    }
}


-(UIView *)loadingView:(CGRect)rect
{
    UIView *loadV=[[UIView alloc]initWithFrame:rect];
    loadV.backgroundColor=[UIColor blackColor];
    loadV.alpha = 0.8;
    UIActivityIndicatorView *activityIndicatorV=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorV.center=CGPointMake(rect.size.width/2, rect.size.height/2-10);
    [activityIndicatorV startAnimating];
    
    [loadV addSubview:activityIndicatorV];
    UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(0, 70, 100, 30)];
    la.text=@"正在加载...";
    la.backgroundColor=[UIColor clearColor];
    la.textAlignment=NSTextAlignmentCenter;
    la.textColor=[UIColor whiteColor];
    la.font=[UIFont boldSystemFontOfSize:15];
    [loadV addSubview:la];
    loadV.layer.cornerRadius=4;
    loadV.layer.masksToBounds=YES;
    return loadV;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request101 clearDelegatesAndCancel];
}
#pragma mark - 用户信息调用

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillAppear:YES];
    LifeGroupHomeViewController *lgh = [LifeGroupHomeViewController sharedUserDefault];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%@",FIRST_URL, LIFEGROUP_URL,lgh.gg_id]];
    request101 = [ASIFormDataRequest requestWithURL:url];
    
    [request101 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request101.tag = 101;
    request101.delegate = self;
    [request101 setDidFailSelector:@selector(urlRequestFailed:)];
    [request101 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [request101 startAsynchronous];
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        [SYObject endLoading];
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"grouplist_dibBig-->>%@",dicBig);
        if (dicBig) {
            [self.imgLog sd_setImageWithURL:[dicBig objectForKey:@"gg_img"] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
            self.lblTitle.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"gg_name"]];
            self.lblPresentPrice.text = [NSString stringWithFormat:@"￥%@",[dicBig objectForKey:@"gg_price"]];
            self.lblOriginalPrice.text = [NSString stringWithFormat:@"原价: ￥%@",[dicBig objectForKey:@"gg_store_price"]];
            self.lblSave.text = [NSString stringWithFormat:@"折扣 :%@折",[dicBig objectForKey:@"gg_rebate"]];
            self.lblCutOffTime.text = [NSString stringWithFormat:@"截止时间: %@",[dicBig objectForKey:@"gg_endTime"]];
            self.lblYishouchu.text = [NSString stringWithFormat:@"已售出 %@ 件",[dicBig objectForKey:@"gg_selled_count"]];
        }
    }
    
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    if (aScrollView == myWebView.scrollView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:aScrollView];
    }
    
    if(aScrollView == shjTableView){
        CGPoint offset = aScrollView.contentOffset;  // 当前滚动位移
        CGRect bounds = aScrollView.bounds;          // UIScrollView 可视高度
        CGSize size = aScrollView.contentSize;         // 滚动区域
        UIEdgeInsets inset = aScrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        
        float reload_distance = 10;
        if (y > (h + reload_distance)) {
            // 滚动到底部
            if (scrollBool == NO) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                CGRect frame = shjTableView.frame;
                frame.origin.y -= shjTableView.frame.size.height;
                [shjTableView setFrame:frame];
                
                CGRect frame2 = myWebView.frame;
                frame2.origin.y -= myWebView.frame.size.height;
                [myWebView setFrame:frame2];
                
                [UIView commitAnimations];
                scrollBool = YES;
            }else{
            }
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)aScrollView
{
    if (aScrollView == myWebView.scrollView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:aScrollView];
    }
}
#pragma mark - webview delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    _reloading = YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:myWebView.scrollView];
    [SYObject endLoading];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:myWebView.scrollView];
    //若不存在网络 则需要影藏webview 并提示用户点击屏幕进行刷新
    [SYObject endLoading];
}

#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == myWebView.scrollView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    scrollBool = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    if (shjTableView.frame.origin.y == 64) {
        
    }else{
        CGRect frame = shjTableView.frame;
        frame.origin.y += shjTableView.frame.size.height;
        [shjTableView setFrame:frame];
        
        CGRect frame2 = myWebView.frame;
        frame2.origin.y += myWebView.frame.size.height;
        [myWebView setFrame:frame2];
    }
    [UIView commitAnimations];
    
    LifeGroupHomeViewController *lgh = [[LifeGroupHomeViewController alloc]init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%@",FIRST_URL,LIFEDETAILWEB_URL,lgh.gg_id]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [myWebView loadRequest:request];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return [NSDate date]; // should return date data source was last changed
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
