//
//  zeroDetailViewController.m
//  My_App
//
//  Created by apple on 15-1-5.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "zeroDetailViewController.h"
#import "zeroDetailCell.h"
#import "ASIFormDataRequest.h"
#import "zeroApplyAddressViewController.h"
#import "NewLoginViewController.h"
#import "LoginViewController.h"
#import "zeroEstimateViewController.h"
#import "FirstViewController.h"
#import "DetailTableView.h"

@interface zeroDetailViewController (){
    ASIFormDataRequest *request_2;
    ASIFormDataRequest *request_1;
}

@end

@implementation zeroDetailViewController


-(void)createRealBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backRealBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
    
}


-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    FirstViewController *ol = [FirstViewController sharedUserDefault];
    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ZERO_DETAIL_URL]];
    request_1=[ASIFormDataRequest requestWithURL:url3];
    [request_1 setPostValue:ol.Detailfree_id forKey:@"id"];
   
    [request_1 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_1.tag = 101;
    request_1.delegate =self;
    [request_1 setDidFailSelector:@selector(urlRequestFailed:)];
    [request_1 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [request_1 startAsynchronous];
    [super viewWillAppear:YES];
    loadingV.hidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request_1 clearDelegatesAndCancel];
    [request_2 clearDelegatesAndCancel];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    scrollBool = NO;
    // Do any additional setup after loading the view.
    self.title = @"0元购详情";
    dataArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createRealBackBtn];
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    
    [freeBtn.layer setMasksToBounds:YES];
    [freeBtn.layer setCornerRadius:4];
    [freeBtn addTarget:self action:@selector(zeroBuy:) forControlEvents:UIControlEventTouchUpInside];
    
    //新建tableview 距离底部43
    MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height - 64- 43) style:UITableViewStylePlain];
    MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MyTableView.delegate = self;
    MyTableView.dataSource=  self;
    MyTableView.showsVerticalScrollIndicator=NO;
    MyTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:MyTableView];
    
    myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, ScreenFrame.size.height-40-43, ScreenFrame.size.width, ScreenFrame.size.height-40-43)];
    myWebView.backgroundColor = [UIColor whiteColor];
    myWebView.userInteractionEnabled = YES;
    myWebView.scalesPageToFit = true;
    
    FirstViewController *ol = [FirstViewController sharedUserDefault];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%@",FIRST_URL,ZERO_DETAIL_INTRODUCE_URL,ol.Detailfree_id]];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
    [myWebView loadRequest:request];
    myWebView.delegate = self;
    myWebView.scrollView.delegate = self;
    [self.view addSubview:myWebView];
    //初始化refreshView，添加到webview 的 scrollView子视图中
    if (_refreshHeaderView == nil) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0-myWebView.scrollView.bounds.size.height, myWebView.scrollView.frame.size.width, myWebView.scrollView.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        [myWebView.scrollView addSubview:_refreshHeaderView];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    
    UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backRealBtnClicked)];
    rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
    [MyTableView addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];
    [SYObject startLoading];
    
    
    labelTi.hidden = YES;
    
}


#pragma mark - tabelView方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 625;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    zeroDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zeroDetailCell"];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailTableView" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 0) {
        if (dataArray.count!=0) {
            ClassifyModel *class = [dataArray objectAtIndex:0];
            [cell.photoImage sd_setImageWithURL:(NSURL*)class.freeDetail_free_acc placeholderImage:[UIImage imageNamed:@"kong_lj"]];
            cell.name.text=class.freeDetail_free_name;
            NSLog(@"%@",cell.name.font);
            cell.name.font=[UIFont systemFontOfSize:16];
            
            cell.price.textColor=UIColorFromRGB(0xf15353);
            cell.price.text=[NSString stringWithFormat:@"市场价值: ￥%@",class.freeDetail_free_price];
            NSString *red1 = @"市场价值:";
            NSString *full = [NSString stringWithFormat:@"市场价值: ￥%@",class.freeDetail_free_price];
            if (red1) {
                NSRange range1 = [full rangeOfString:red1];
                NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:full];
                [attr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x666666) range:range1];
                cell.price.attributedText =attr;
            }
            
            cell.price.font=[UIFont systemFontOfSize:16];
            cell.publicCount.text=[NSString stringWithFormat:@"发布数量: %@",class.freeDetail_default_count];
             cell.publicCount.font=[UIFont systemFontOfSize:16];
            NSString *red2 = @"发布数量:";
            NSString *full2 = [NSString stringWithFormat:@"发布数量: %@",class.freeDetail_default_count];
            if (red2) {
                NSRange range2 = [full2 rangeOfString:red2];
                NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:full2];
                [attr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x666666) range:range2];
                cell.publicCount.attributedText =attr;
            }
        
            cell.remainCount.text=[NSString stringWithFormat:@"剩余数量: %@",class.freeDetail_current_count];
            cell.remainCount.font=[UIFont systemFontOfSize:16];
            NSString *red3 = @"剩余数量:";
            NSString *full3 = [NSString stringWithFormat:@"剩余数量: %@",class.freeDetail_current_count];
            if (red3) {
                NSRange range2 = [full3 rangeOfString:red3];
                NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:full3];
                [attr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x666666) range:range2];
                cell.remainCount.attributedText =attr;
            }
          
            
            cell.applyCount.text=[NSString stringWithFormat:@"申请人数: %@",class.freeDetail_apply_count];
             cell.applyCount.font=[UIFont systemFontOfSize:16];
            
            NSString *red4 = @"申请人数:";
            NSString *full4 = [NSString stringWithFormat:@"申请人数: %@",class.freeDetail_apply_count];
            if (red4) {
                NSRange range2 = [full4 rangeOfString:red4];
                NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:full4];
                [attr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x666666) range:range2];
                cell.applyCount.attributedText =attr;
            }

            
            NSArray *a=[class.freeDetail_endTime componentsSeparatedByString:@" "];
            cell.time.text=[NSString stringWithFormat:@"结束时间: %@",a[0]];
            cell.time.font=[UIFont systemFontOfSize:16];
            NSString *red5 = @"结束时间:";
            NSString *full5 = [NSString stringWithFormat:@"结束时间: %@",a[0]];
            if (red5) {
                NSRange range2 = [full5 rangeOfString:red5];
                NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:full5];
                [attr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x666666) range:range2];
                cell.time.attributedText =attr;
            }

            [cell.eveloateBtn addTarget:self action:@selector(estimateBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }
    return cell;
}
#pragma mark - 点击事件
-(void)backRealBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)estimateBtnClicked{
    zeroEstimateViewController *zero = [[zeroEstimateViewController alloc]init];
    [self.navigationController pushViewController:zero animated:YES];
}

-(void)zeroBuy:(UIButton *)btn{
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
    if([fileManagerDong fileExistsAtPath:filePathDong] == NO){
        //                    没登陆，跳转到登录页面。
        NewLoginViewController *new = [[NewLoginViewController alloc]init];
        [self.navigationController pushViewController:new animated:YES];
    }else{
        //首先，判断用户是否登录。若登录，（1）没有填写过收货地址信息时，则跳转到填写收货地址，并且提交申请页面（2）填写过收货地址，则直接拿到默认的收货地址，并且增加编辑、设为默认地址按钮
        //发起请求 判断用户是否可以申请免费试用
        NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ZERO_SUPPLY_VALIDATE_URL]];
        request_2=[ASIFormDataRequest requestWithURL:url3];
        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:filePathDong];
        [request_2 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
        [request_2 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
        
        [request_2 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request_2.tag = 101;
        request_2.delegate = self;
        [request_2 setDidFailSelector:@selector(supple_urlRequestFailed:)];
        [request_2 setDidFinishSelector:@selector(supple_urlRequestSucceeded:)];
        [request_2 startAsynchronous];
    }
}
-(void)failedPrompt:(NSString *)prompt{
    [SYObject endLoading];
    [SYObject failedPrompt:prompt];
}
#pragma mark - 网络
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig1:%@",dicBig);
        if (dicBig) {
            ClassifyModel *class = [[ClassifyModel alloc]init];
            class.freeDetail_free_price = [dicBig objectForKey:@"free_price"];
            class.freeDetail_free_name = [dicBig objectForKey:@"free_name"];
            class.freeDetail_free_id = [dicBig objectForKey:@"free_id"];
            class.freeDetail_free_details = [dicBig objectForKey:@"free_details"];
            class.freeDetail_free_acc = [dicBig objectForKey:@"free_acc"];
            class.freeDetail_endTime = [dicBig objectForKey:@"endTime"];
            class.freeDetail_default_count = [dicBig objectForKey:@"default_count"];
            class.freeDetail_current_count = [dicBig objectForKey:@"current_count"];
            class.freeDetail_apply_count = [dicBig objectForKey:@"apply_count"];
            [dataArray addObject:class];
        }
        [MyTableView reloadData];
        [SYObject endLoading];
    }
    else{
       [SYObject endLoading];
    }
    
}
-(void)supple_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)supple_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        [SYObject endLoading];
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([[dicBig objectForKey:@"code"] intValue] == -100) {
            //您有尚未评价的0元购或您申请过此0元购
            [SYObject failedPrompt:@"您有尚未评价的0元购或您申请过此0元购"];
        }else if ([[dicBig objectForKey:@"code"] intValue] == 100){
            zeroApplyAddressViewController *apply = [[zeroApplyAddressViewController alloc]init];
            [self.navigationController pushViewController:apply animated:YES];
        }
        [MyTableView reloadData];
       [SYObject endLoading];
    }else{
        [SYObject endLoading];
    }
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

//加载网页
- (void)loadPage {
    FirstViewController *ol = [FirstViewController sharedUserDefault];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%@",FIRST_URL,ZERO_DETAIL_INTRODUCE_URL,ol.Detailfree_id]];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
    [myWebView loadRequest:request];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    if (MyTableView.frame.origin.y == 0) {
        
    }else{
        CGRect frame = MyTableView.frame;
        frame.origin.y += MyTableView.frame.size.height;
        [MyTableView setFrame:frame];
        
        CGRect frame2 = myWebView.frame;
        frame2.origin.y += myWebView.frame.size.height;
        [myWebView setFrame:frame2];
    }
    [UIView commitAnimations];
}

#pragma mark - webview delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    _reloading = YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:myWebView.scrollView];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:myWebView.scrollView];
}


#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == MyTableView){
        CGPoint offset = scrollView.contentOffset;  // 当前滚动位移
        CGRect bounds = scrollView.bounds;          // UIScrollView 可视高度
        CGSize size = scrollView.contentSize;         // 滚动区域
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        
        float reload_distance = 10;
        if (y > (h + reload_distance)) {
            // 滚动到底部
            // ...
            if (scrollBool == NO) {
                //在这里将tableview的坐标上传
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                CGRect frame = MyTableView.frame;
                frame.origin.y -= MyTableView.frame.size.height;
                [MyTableView setFrame:frame];
                
                CGRect frame2 = myWebView.frame;
                frame2.origin.y -= myWebView.frame.size.height;
                [myWebView setFrame:frame2];
                
                [UIView commitAnimations];
                scrollBool = YES;
            }else{
                
            }
        }
    }else{
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(scrollView == MyTableView){
        
    }else{
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    scrollBool = NO;
    [self loadPage];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return [NSDate date]; // should return date data source was last changed
}

@end
