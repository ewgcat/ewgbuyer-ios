//
//  zeroApplyAddressViewController.m
//  My_App
//
//  Created by apple on 15-1-5.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "zeroApplyAddressViewController.h"
#import "NilCell.h"
#import "ASIFormDataRequest.h"
#import "LoginViewController.h"
#import "AddAdminViewController.h"
#import "ThirdViewController.h"
#import "FirstViewController.h"

@interface zeroApplyAddressViewController (){
    ASIFormDataRequest *request105;
    ASIFormDataRequest *request101;
}

@end

@implementation zeroApplyAddressViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request101 clearDelegatesAndCancel];
    [request105 clearDelegatesAndCancel];
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillAppear:YES];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,DEFAULTADDRESSFIND_URL]];
    request105 = [ASIFormDataRequest requestWithURL:url];
    [request105 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request105 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    
    [request105 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request105.tag = 105;
    request105.delegate =self;
    [request105 setDidFailSelector:@selector(urlRequestFailed:)];
    [request105 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [request105 startAsynchronous];
}
//-(void)failedPrompt:(NSString *)prompt{
//    loadingV.hidden = YES;
//    labelTi.hidden = NO;
//    labelTi.text = prompt;
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
//}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
    [SYObject endLoading];
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
       [SYObject endLoading];
        NSDictionary *dicBig = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig1:%@",dicBig);
        if(dataArray.count!=0){
            [dataArray removeAllObjects];
        }
        if (dicBig) {
            if ([[dicBig allKeys] containsObject:@"addr_id"]){
                topWhiteTi.hidden = YES;
                ClassifyModel *classM = [[ClassifyModel alloc]init];
                classM.manager_addr_id = [dicBig objectForKey:@"addr_id"];
                classM.manager_area = [dicBig objectForKey:@"area"];
                classM.manager_areaInfo = [dicBig objectForKey:@"areaInfo"];
                classM.manager_mobile = [dicBig objectForKey:@"mobile"];
                classM.manager_telephone = [dicBig objectForKey:@"telephone"];
                classM.manager_trueName = [dicBig objectForKey:@"trueName"];
                classM.manager_zip = [dicBig objectForKey:@"zip"];
                [dataArray addObject:classM];
            }else{//则是提示用户没有创建地址
                topWhiteTi.hidden = NO;
            }
        }
       [SYObject endLoading];
        [MyTableView reloadData];
    }
    
}

-(void)createRealBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backRealBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}

-(void)backRealBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"0元购申请";
    [self createRealBackBtn];
    dataArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    if (ScreenFrame.size.height>480) {//说明是5 5s
        MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    }else{
        MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    }
    MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MyTableView.delegate = self;
    MyTableView.dataSource=  self;
    MyTableView.showsVerticalScrollIndicator=NO;
    MyTableView.showsHorizontalScrollIndicator = NO;
    MyTableView.backgroundColor = [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1];
    [self.view addSubview:MyTableView];
    
    topWhiteTi = [[UIView alloc]initWithFrame:CGRectMake(5, 5, ScreenFrame.size.width-10, 230)];
    topWhiteTi.backgroundColor = [UIColor whiteColor];
    topWhiteTi.layer.borderWidth = 0.5;
    topWhiteTi.layer.borderColor = [[UIColor grayColor] CGColor];
    [MyTableView addSubview:topWhiteTi];
    UIImageView *imageNext = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-30, (topWhiteTi.frame.size.height-11)/2, 7, 11)];
    imageNext.image = [UIImage imageNamed:@"dis_indicator"];
    [topWhiteTi addSubview:imageNext];
    UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, topWhiteTi.frame.size.height)];
    la.text=@"        还没有收货人信息,快去添加吧!";
    la.backgroundColor=[UIColor clearColor];
    la.textColor=[UIColor darkGrayColor];
    la.font=[UIFont systemFontOfSize:14];
    [topWhiteTi addSubview:la];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
    button.frame =CGRectMake(0, 0, ScreenFrame.size.width, topWhiteTi.frame.size.height);
    button.tag = 108;
    [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font  = [UIFont systemFontOfSize:14];
    [topWhiteTi addSubview:button];
    
    UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backRealBtnClicked)];
    rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
    [MyTableView addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];
//    loadingV=[self loadingView:CGRectMake((ScreenFrame.size.width-100)/2, (ScreenFrame.size.height-100)/2, 100, 100)];
//    [self.view addSubview:loadingV];
    
//    labelTi = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 30)];
//    labelTi.center = CGPointMake(ScreenFrame.size.width/2, 240);
//    CALayer *lay2  = labelTi.layer;
//    [lay2 setMasksToBounds:YES];
//    [lay2 setCornerRadius:4.0];
//    labelTi.font = [UIFont systemFontOfSize:14];
//    labelTi.backgroundColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
//    labelTi.alpha = 1;
//    labelTi.textColor = [UIColor whiteColor];
//    labelTi.textAlignment = NSTextAlignmentCenter;
//    labelTi.hidden = YES;
//    [self.view addSubview:labelTi];
}

//-(UIView *)loadingView:(CGRect)rect
//{
//    UIView *loadV=[[UIView alloc]initWithFrame:rect];
//    loadV.backgroundColor=[UIColor blackColor];
//    loadV.alpha = 0.8;
//    UIActivityIndicatorView *activityIndicatorV=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    activityIndicatorV.center=CGPointMake(rect.size.width/2, rect.size.height/2-10);
//    [activityIndicatorV startAnimating];
//    
//    [loadV addSubview:activityIndicatorV];
//    UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(0, 70, 100, 30)];
//    la.text=@"正在加载...";
//    la.backgroundColor=[UIColor clearColor];
//    la.textAlignment=NSTextAlignmentCenter;
//    la.textColor=[UIColor whiteColor];
//    la.font=[UIFont boldSystemFontOfSize:15];
//    [loadV addSubview:la];
//    loadV.layer.cornerRadius=4;
//    loadV.layer.masksToBounds=YES;
//    return loadV;
//}
//TODO:tabelView方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 400;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NilCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NilCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1];
    }
    if (indexPath.row == 0) {
        laLiuyan=[[UILabel alloc]initWithFrame:CGRectMake(3+10, 110, 304, 28)];
        laLiuyan.text=@"填写留言可提高审核通过率,请认真填写";
        laLiuyan.backgroundColor=[UIColor clearColor];
        laLiuyan.textColor=[UIColor darkGrayColor];
        laLiuyan.font=[UIFont systemFontOfSize:13];
        [cell addSubview:laLiuyan];
        if (dataArray.count!=0) {
            
            ClassifyModel *da = [dataArray objectAtIndex:0];
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, ScreenFrame.size.width-10, 70)];
            view.backgroundColor = [UIColor whiteColor];
            [cell addSubview:view];
            view.layer.borderWidth = 0.5;
            view.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, view.frame.size.width/2-30, 30)];
            labelName.text =[NSString stringWithFormat:@" %@",da.manager_trueName];
            [view addSubview:labelName];
            
            UIImageView *icon=[LJControl imageViewFrame:CGRectMake(10, 5, 20, 20) setImage:@"iconNew.png" setbackgroundColor:[UIColor whiteColor]];
            [view addSubview:icon];
            UILabel *labelP = [[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width/2+20, 0, view.frame.size.width/2-20, 30)];
            [view addSubview:labelP];
            UIImageView *phoneImg=[LJControl imageViewFrame:CGRectMake(view.frame.size.width/2, 5, 20, 20) setImage:@"iphone.png" setbackgroundColor:[UIColor whiteColor]];
            [view addSubview:phoneImg];

            if (da.manager_mobile.length == 0) {
                labelP.text = [NSString stringWithFormat:@"%@",da.manager_telephone];
            }else {
                labelP.text = [NSString stringWithFormat:@"%@",da.manager_mobile];
            }
            UILabel *labeladds = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, view.frame.size.width-20, 40)];
            labeladds.text = [NSString stringWithFormat:@"%@ %@",da.manager_area,da.manager_areaInfo];
            labeladds.numberOfLines = 2;
            labeladds.font = [UIFont systemFontOfSize:15];
            labeladds.textColor=UIColorFromRGB(0x666666);
            [view addSubview:labeladds];
            
            UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(5, 80, ScreenFrame.size.width-10, 110)];
            view2.backgroundColor = [UIColor whiteColor];
            [cell addSubview:view2];
            view2.layer.borderWidth = 0.5;
            view2.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            UILabel *labelName2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view2.frame.size.width, 30)];
            labelName2.text = @"    申请留言";
            labelName2.backgroundColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1];
            [view2 addSubview:labelName2];
            myTextView = [[UITextView alloc]initWithFrame:CGRectMake(3+5, 110, ScreenFrame.size.width-20, 77)];
            myTextView.backgroundColor = [UIColor clearColor];
            myTextView.delegate = self;
            if (liuyanStr.length == 0) {
                myTextView.text = @"";
            }else{
                myTextView.text = liuyanStr;
            }
            [cell addSubview:myTextView];
            if (myTextView.text.length == 0) {
                laLiuyan.hidden = NO;
            }else{
                laLiuyan.hidden = YES;
            }
           
            
            WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"取消" leftTarget:self leftAction:@selector(dismissKeyBoard) rightTitle:@"完成" rightTarget:self rightAction:@selector(dismissKeyBoard)];
            [myTextView setInputAccessoryView:inputView];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
            button.frame =CGRectMake(0, 0, ScreenFrame.size.width, 75);
            button.tag = 101;
            [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.alpha = 0.6;
            button.titleLabel.font  = [UIFont systemFontOfSize:14];
            [cell addSubview:button];
            
            UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom ];
            button3.frame =CGRectMake(15, 198, ScreenFrame.size.width-30, 44);
            button3.tag = 103;
            button3.backgroundColor = UIColorFromRGB(0xf15353);
            [button3.layer setMasksToBounds:YES];
            [button3.layer setCornerRadius:4.0f];
            [button3 setTitle:@"提交申请" forState:UIControlStateNormal];
            [button3 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            button3.titleLabel.font  = [UIFont systemFontOfSize:17];
            [cell addSubview:button3];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)btnClicked:(UIButton *)btn{
    if(btn.tag == 101){
        AddAdminViewController *rrr = [[AddAdminViewController alloc]init];
        [self.navigationController pushViewController:rrr animated:YES];
    }
    if(btn.tag == 103){
        [SYObject startLoading];
        //发起请求
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ZERO_DETAIL_SUPPLY_URL]];
        request101 = [ASIFormDataRequest requestWithURL:url];
        [request101 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
        [request101 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
        FirstViewController *log = [FirstViewController sharedUserDefault];
        [request101 setPostValue:log.Detailfree_id forKey:@"id"];
        [request101 setPostValue:myTextView.text forKey:@"apply_reason"];
        ClassifyModel *class = [dataArray objectAtIndex:0];
        [request101 setPostValue:class.manager_addr_id forKey:@"addr_id"];
        
        [request101 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request101.tag = 105;
        request101.delegate = self;
        [request101 setDidFailSelector:@selector(supply_urlRequestFailed:)];
        [request101 setDidFinishSelector:@selector(supply_urlRequestSucceeded:)];
        [request101 startAsynchronous];
    }
    if(btn.tag == 108){
        AddAdminViewController *ma = [[AddAdminViewController alloc]init];
        [self.navigationController pushViewController:ma animated:YES];
    }
}
-(void)supply_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
    [SYObject endLoading];
}
-(void)supply_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"提交申请:%@",dicBig);
        if (dicBig) {
            if ([[dicBig objectForKey:@"code"] intValue] == 100) {
                [SYObject failedPrompt:@"申请0元购成功！" complete:^{
                     [self.navigationController popViewControllerAnimated:YES];
                }];
            }else if ([[dicBig objectForKey:@"code"] intValue] == -100){
                [SYObject failedPrompt:@"您申请过当前0元购与尚有未评价0元购!"];
            }
        }
    }else{
        
    }
    [SYObject endLoading];
    
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    laLiuyan.hidden = YES;
    if (ScreenFrame.size.height==480) {
        [UIView animateWithDuration:0.5 animations:^{
            
            MyTableView.frame = CGRectMake(0, -70, ScreenFrame.size.width, ScreenFrame.size.height-64);
        }];
    }
   
    return YES;
}
-(void)dismissKeyBoard
{
    [myTextView resignFirstResponder];
    if (ScreenFrame.size.height==480) {
        [UIView animateWithDuration:0.5 animations:^{
            
            MyTableView.frame=CGRectMake(0, ScreenFrame.origin.y, ScreenFrame.size.width, ScreenFrame.size.height-64);
            
        }];

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

@end
