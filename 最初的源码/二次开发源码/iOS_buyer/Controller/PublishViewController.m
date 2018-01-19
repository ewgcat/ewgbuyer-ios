//
//  PublishViewController.m
//  My_App
//
//  Created by apple on 14-8-8.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "PublishViewController.h"
#import "SecondViewController.h"
#import "ASIFormDataRequest.h"
#import "FirstViewController.h"

@interface PublishViewController (){
    ASIFormDataRequest *request_1;
}

@end

@implementation PublishViewController
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"发表咨询";
    }
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_myTextView resignFirstResponder];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)doTimer
{
    [self.navigationController popViewControllerAnimated:YES];
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
    _myTextView.delegate = self;
    [self createBackBtn];
    CategoryArray = [[NSArray alloc]initWithObjects:@"请选择咨询类型",@"产品咨询",@"库存及配送",@"支付及发票",@"售后咨询",@"促销活动", nil];
    categoryLabel.frame = CGRectMake(categoryLabel.frame.origin.x, categoryLabel.frame.origin.y, ScreenFrame.size.width-categoryLabel.frame.origin.x-20,categoryLabel.frame.size.height );
    _upBtn.frame = CGRectMake(_upBtn.frame.origin.x, _upBtn.frame.origin.y, ScreenFrame.size.width-_upBtn.frame.origin.x-20,_upBtn.frame.size.height );
    UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backBtnClicked)];
    rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];
    
    categoryView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height)];
    categoryView.hidden = YES;
    [self.view addSubview:categoryView];
    
    categoryLabel.text = [NSString stringWithFormat:@"%@",[CategoryArray objectAtIndex:1]];
    [categoryLabel.layer setMasksToBounds:YES];
    categoryLabel.textAlignment = NSTextAlignmentLeft;
    [categoryLabel.layer setCornerRadius:4.0f];
    [_upBtn.layer setMasksToBounds:YES];
    [_upBtn.layer setCornerRadius:4.0f];
    
   
}
-(void)setupUI{
    categoryLabel.layer.cornerRadius = 5.f;
    [categoryLabel.layer setMasksToBounds:YES];
    _myTextView.layer.cornerRadius = 5.f;
    [_myTextView.layer setMasksToBounds:YES];
    _upBtn.layer.cornerRadius = 5.f;
    [_upBtn.layer setMasksToBounds:YES];
}
-(void)disappear{
    categoryView.hidden = YES;
    for (UIView *subView in categoryView.subviews)
    {
        [subView removeFromSuperview];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
   
}
#pragma mark-alert方法
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (alertView.tag == 101) {
//        if (buttonIndex == 0) {
//            FirstViewController  *fir = [FirstViewController sharedUserDefault];
//            fir.loginBool = YES;
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }else if (buttonIndex == 1){
//        }
//    }
//}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request_1 clearDelegatesAndCancel];
}
- (IBAction)btnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 101) {
        if (_myTextView.text.length == 0 ) {
            [SYObject failedPrompt:@"咨询内容不能为空"];
           
        }else{
            [SYObject startLoading];
            SecondViewController *sec = [SecondViewController sharedUserDefault];
            //发起发表咨询的请求
            NSArray *keyArr;
            NSArray *valueArr;
            NSArray *fileContent2 = USER_INFORMATION;
            if([[NSFileManager defaultManager] fileExistsAtPath:INFORMATION_FILEPATH]==NO){
                keyArr = [[NSArray alloc]initWithObjects:@"user_id",@"token",@"content",@"consult_type",@"goods_id", nil];
                valueArr = [[NSArray alloc]initWithObjects:@"",@"",_myTextView.text,categoryLabel.text,sec.detail_id, nil];
            }else{
                keyArr = [[NSArray alloc]initWithObjects:@"user_id",@"token",@"content",@"consult_type",@"goods_id", nil];
                valueArr = [[NSArray alloc]initWithObjects:[fileContent2 objectAtIndex:3],[fileContent2 objectAtIndex:1],_myTextView.text,categoryLabel.text,sec.detail_id, nil];
            }
            request_1 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,ISSUANCE_URL] setKey:keyArr setValue:valueArr];
            request_1.delegate = self;
            [request_1 setDidFailSelector:@selector(urlRequestFailed:)];
            [request_1 setDidFinishSelector:@selector(urlRequestSucceeded:)];
            [request_1 startAsynchronous];
        }
    }
    if (btn.tag == 102) {
        categoryView.hidden = NO;
        UIImageView *vvv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, categoryView.frame.size.width, categoryView.frame.size.height)];
        vvv.backgroundColor = [UIColor blackColor];
        vvv.alpha = 0.5;
        vvv.userInteractionEnabled = YES;
        [categoryView addSubview:vvv];
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappear)];
        tapGr.cancelsTouchesInView = NO;
        [vvv addGestureRecognizer:tapGr];
        
        if (ScreenFrame.size.height>480) {//说明是5 5s
            MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(40, 44+20, ScreenFrame.size.width-80, 240)];
        }else{
            MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(40, 44+20, ScreenFrame.size.width-80, 240)];
        }
        MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MyTableView.delegate = self;
        MyTableView.dataSource=  self;
        MyTableView.showsVerticalScrollIndicator=NO;
        MyTableView.showsHorizontalScrollIndicator = NO;
        [MyTableView.layer setMasksToBounds:YES];
        [MyTableView.layer setCornerRadius:4.0];
        [categoryView addSubview:MyTableView];
    }
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"发表:%@",dicBig);
        if (dicBig) {
            if ([[dicBig objectForKey:@"ret"] isEqualToString:@"true"]) {
                [SYObject endLoading];
                [SYObject failedPrompt:@"已成功发表" complete:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        }
    }
}

-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
//TODO:tabelView方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdetify = @"SvTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
    }else{
        for (UIView *subView in cell.contentView.subviews)
        {
            [subView removeFromSuperview];
        }
    }
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
     UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((tableView.frame.size.width-75)*0.5, 0, 75, 40)];
    if (indexPath.row==0) {

        label.frame=CGRectMake(0, 0, tableView.frame.size.width, 40);
        label.textAlignment = NSTextAlignmentCenter;
    }else{

    label.textAlignment = NSTextAlignmentLeft;
    }
  
    label.font = [UIFont systemFontOfSize:15];
    label.text = [CategoryArray objectAtIndex:indexPath.row];
    [cell addSubview:label];
    if (indexPath.row == 0) {
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:16];
        label.backgroundColor = MY_COLOR;
    }else{
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
    }else{
        categoryLabel.text = [CategoryArray objectAtIndex:indexPath.row];
        categoryView.hidden = YES;
        for (UIView *subView in categoryView.subviews)
        {
            [subView removeFromSuperview];
        }
    }
}

-(void)dealloc {
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
 
    _myTextView = nil;
    _upBtn = nil;
}
@end
