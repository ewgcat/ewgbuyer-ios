//
//  SHJAddManageViewController.m
//  My_App
//
//  Created by apple on 14-8-18.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "SHJAddManageViewController2.h"
#import "ASIFormDataRequest.h"
#import "RegionCell.h"
#import "ThirdViewController.h"

@interface SHJAddManageViewController2 ()

@end

@implementation SHJAddManageViewController2

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [requestAddManage1 clearDelegatesAndCancel];
    [requestAddManage3 clearDelegatesAndCancel];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"修改收货信息";
        self.view.backgroundColor = [UIColor whiteColor];
        ThirdViewController *th = [ThirdViewController sharedUserDefault];
        _tureNameField = [[UITextField alloc]initWithFrame:CGRectMake(71, 89, ScreenFrame.size.width-90, 30)];
        self.tureNameField.backgroundColor = [UIColor clearColor];
        self.tureNameField.placeholder = @"收货人姓名";
        self.tureNameField.font = [UIFont fontWithName:@"Arial" size:15];
        self.tureNameField.textColor = [UIColor blackColor];
        self.tureNameField.textAlignment = NSTextAlignmentLeft;
        self.tureNameField.delegate = self;
        self.tureNameField.tag = 1002;
        self.tureNameField.clearButtonMode = YES;
        [self.view addSubview:self.tureNameField];
        _tureNameField.text  = th.xiu_trueName;
        
        _mobileField = [[UITextField alloc]initWithFrame:CGRectMake(71, 134, ScreenFrame.size.width-90, 30)];
        self.mobileField.backgroundColor = [UIColor clearColor];
        self.mobileField.placeholder = @"手机号";
        self.mobileField.font = [UIFont fontWithName:@"Arial" size:15];
        self.mobileField.textColor = [UIColor blackColor];
        self.mobileField.textAlignment = NSTextAlignmentLeft;
        self.mobileField.delegate = self;
        self.mobileField.tag = 1003;
        self.mobileField.clearButtonMode = YES;
        [self.view addSubview:self.mobileField];
        _mobileField.text  = th.xiu_mobile;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
        button.frame =CGRectMake(71, 180, ScreenFrame.size.width-90, 30);
        [button setTitle:@"点击选择省/市/区        ▼" forState:UIControlStateNormal];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:4.0f];
        button.backgroundColor = [UIColor lightGrayColor];
        [button addTarget:self action:@selector(btnprovince:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font  = [UIFont systemFontOfSize:14];
        [self.view addSubview:button];
        _zipField = [[UITextField alloc]initWithFrame:CGRectMake(71, 323, ScreenFrame.size.width-90, 30)];
        self.zipField.backgroundColor = [UIColor clearColor];
        self.zipField.placeholder = @"邮政编码(可选填)";
        self.zipField.font = [UIFont fontWithName:@"Arial" size:15];
        self.zipField.textColor = [UIColor blackColor];
        self.zipField.textAlignment = NSTextAlignmentLeft;
        self.zipField.delegate = self;
        self.zipField.clearButtonMode = YES;
        [self.view addSubview:_zipField];
        _zipField.text  = th.xiu_zip;
        _regionMyLable = [[UILabel alloc]initWithFrame:CGRectMake(71, 222, ScreenFrame.size.width-90, 21)];
        _xiu_area = th.xiu_area;
        [self.view addSubview:_regionMyLable];
        _addInfoText = [[UITextView alloc]initWithFrame:CGRectMake(71, 253, ScreenFrame.size.width-90, 57)];
        self.addInfoText.textColor = [UIColor blackColor];
        self.addInfoText.textAlignment = NSTextAlignmentLeft;
        self.addInfoText.font = [UIFont fontWithName:@"Arial" size:15];
        self.addInfoText.backgroundColor = [UIColor clearColor];
        self.addInfoText.delegate = self;
        self.addInfoText.tag = 1006;
        [self.view addSubview:self.addInfoText];
        _addInfoText.text  = th.xiu_areaInfo;
        
        regionView = [[UIImageView alloc]init];
        if (ScreenFrame.size.height>480) {//说明是5 5s
            regionView.frame = CGRectMake(0, ScreenFrame.origin.y+20, ScreenFrame.size.width, ScreenFrame.size.height);
            RegoinTableView = [[UITableView alloc]initWithFrame:CGRectMake(36, 20+25+10+40, ScreenFrame.size.width-36*2, ScreenFrame.size.height-64-49-44-30-10) style:UITableViewStylePlain];
        }else{
            regionView.frame = CGRectMake(0, ScreenFrame.origin.y+12+20, ScreenFrame.size.width, ScreenFrame.size.height);
            RegoinTableView = [[UITableView alloc]initWithFrame:CGRectMake(36, 20+25+40, ScreenFrame.size.width-36*2, ScreenFrame.size.height-64-49-44-24) style:UITableViewStylePlain];
        }
        
        regionView.hidden = YES;
        regionView.userInteractionEnabled = YES;
        [self.view addSubview:regionView];
        
        UIView *alphView = [[UIView alloc]initWithFrame:CGRectMake(regionView.frame.origin.x, regionView.frame.origin.y, regionView.frame.size.width, regionView.frame.size.height)];
        alphView.backgroundColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
        alphView.alpha = 0.7;
        [regionView addSubview:alphView];
        
        RegoinTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        RegoinTableView.delegate = self;
        RegoinTableView.dataSource=  self;
        RegoinTableView.alpha = 1;
        RegoinTableView.showsVerticalScrollIndicator=NO;
        RegoinTableView.showsHorizontalScrollIndicator = NO;
        [regionView addSubview:RegoinTableView];
        
        UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backBtnClicked)];
        rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];
        
        _tureNameField.layer.borderWidth = 0.5;
        _tureNameField.layer.borderColor = [[UIColor grayColor] CGColor];
        _mobileField.layer.borderWidth = 0.5;
        _mobileField.layer.borderColor = [[UIColor grayColor] CGColor];
        _zipField.layer.borderWidth = 0.5;
        _zipField.layer.borderColor = [[UIColor grayColor] CGColor];
        _addInfoText.layer.borderWidth = 0.5;
        _addInfoText.layer.borderColor = [[UIColor grayColor] CGColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createBackBtn];
    regionArray = [[NSMutableArray alloc]init];
}


-(void)doTimer8
{
    _regionMyLable.text =@"";
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)doTimer2{
    [requestAddManage1 cancel];
    [requestAddManage3 cancel];
    requestAddManage1.delegate = nil;
    requestAddManage3.delegate = nil;
    _regionMyLable.text =@"";
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)doTimer3{
    [requestAddManage1 cancel];
    [requestAddManage3 cancel];
    requestAddManage3.delegate = nil;
    requestAddManage1.delegate = nil;
    _regionMyLable.text =@"";
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tabelView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == RegoinTableView) {
        if (regionArray.count != 0) {
            return regionArray.count;
        }
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == RegoinTableView) {
        return 40;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myTabelviewCell = @"RegionCell";
    RegionCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RegionCell" owner:self options:nil] lastObject];
    }
    if (regionArray.count!=0) {
        ClassifyModel *classify = [regionArray objectAtIndex:indexPath.row];
        cell.regionLabel.text = classify.region_name;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == RegoinTableView) {
        //发起请求下一地区
        [SYObject startLoading];
        ClassifyModel *cla = [regionArray objectAtIndex:indexPath.row];
        if (regionStr.length == 0) {
            regionStr = [NSString stringWithFormat:@"%@",cla.region_name];
            
        }else{
            regionStr = [NSString stringWithFormat:@"%@%@",regionStr,cla.region_name];
        }
        if (regionID.length == 0) {
            regionID = [NSString stringWithFormat:@"%@",cla.region_id];
            
        }else{
            regionID = [NSString stringWithFormat:@"%@,%@",regionID,cla.region_id];
        }
        My_id = cla.region_id;
        
        _regionMyLable.text = regionStr;
        
        NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,REGION_URL]];
        requestAddManage3 = [ASIFormDataRequest requestWithURL:url2];
        [requestAddManage3 setPostValue:cla.region_id forKey:@"id"];
        
        [requestAddManage3 setRequestHeaders:[LJControl requestHeaderDictionary]];
        requestAddManage3.tag = 103;
        [requestAddManage3 setDelegate:self];
        [requestAddManage3 setDidFailSelector:@selector(urlRequestFailed:)];
        [requestAddManage3 setDidFinishSelector:@selector(urlRequestSucceeded:)];
        [requestAddManage3 startAsynchronous];
        RegoinTableView.userInteractionEnabled = NO;
    }
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    
    int statuscode2 = [request responseStatusCode];
    NSLog(@"新建收货人地区:%d",statuscode2);
    
    if (statuscode2 == 200) {
        [SYObject endLoading];
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"新建收货人地区:%@",dicBig);
        
        if (regionArray.count!=0) {
            [regionArray removeAllObjects];
        }
        if (dicBig) {
            NSArray *arr = [dicBig objectForKey:@"area_list"];
            if (arr.count==0) {
                regionView.hidden = YES;
                
            }else{
                for(NSDictionary *dic in arr){
                    ClassifyModel *model = [[ClassifyModel alloc]init];
                    model.region_name = [dic objectForKey:@"name"];
                    model.region_id = [dic objectForKey:@"id"];
                    [regionArray addObject:model];
                }
            }
        }
        [RegoinTableView reloadData];
    }
    RegoinTableView.userInteractionEnabled = YES;
}
-(void)failedPrompt:(NSString *)prompt{
    [SYObject endLoading];
    [SYObject failedPrompt:prompt];
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom ];
    button2.frame =CGRectMake(0, 0, 40, 40);
    [button2 setTitle:@"保存" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(safe) forControlEvents:UIControlEventTouchUpInside];
    button2.titleLabel.font  = [UIFont systemFontOfSize:14];
    UIBarButtonItem *bar2 = [[UIBarButtonItem alloc]initWithCustomView:button2];
    self.navigationItem.rightBarButtonItem =bar2;
    
}

-(void)backBtnClicked{
    [requestAddManage3 cancel];
    [requestAddManage1 cancel];
    requestAddManage3.delegate = nil;
    requestAddManage1.delegate = nil;
    _regionMyLable.text =@"";
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGFloat keyboardHeight = 216.0f;
    if (self.view.frame.size.height - keyboardHeight <= textField.frame.origin.y + textField.frame.size.height) {
        CGFloat y = textField.frame.origin.y - (self.view.frame.size.height - keyboardHeight - textField.frame.size.height - 35);
        
        [UIView beginAnimations:@"srcollView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.275f];
        self.view.frame = CGRectMake(self.view.frame.origin.x, -y, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self isMobileField:self.mobileField.text];
    [self isZipField:self.zipField.text];
    
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (BOOL)isMobileField:(NSString *)phoneNumber
{
    if (self.mobileField.text.length == 0) {
        return YES;
    }
    
    NSString *phoneRegex = @"[1][0-9]{10}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",phoneRegex];
    
    BOOL isMatch = [phoneTest evaluateWithObject:phoneNumber];
    if (!isMatch) {
        [self failedPrompt:@"请输入正确的手机号码!"];
        self.mobileField.text = 0;
        return NO;
    }
    
    return YES;
}

-(BOOL)isZipField:(NSString *)zip
{
    if (self.zipField.text.length == 0) {
        return YES;
    }
    else{
        NSString *zipRegex = @"[1-9]\\d{5}(?!\\d)";
        NSPredicate *zipTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",zipRegex];
        BOOL isMatch = [zipTest evaluateWithObject:zip];
        if (!isMatch) {
            [self failedPrompt:@"请输入正确的邮箱!"];
            self.zipField.clearsOnInsertion = YES;
            self.zipField.text = 0;
            return NO;
        }
    }
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    if (self.addInfoText.text.length==0){
        if ([text isEqualToString:@""]) {
            self.lblPrompt.hidden = NO;
        }else{
            self.lblPrompt.hidden=YES;
        }
    }else
    {
        if (self.addInfoText.text.length==1){
            if ([text isEqualToString:@""]) {
                self.lblPrompt.hidden=NO;
            }else{
                self.lblPrompt.hidden=YES;
            }
        }else{
            self.lblPrompt.hidden=YES;
        }
    }
    return YES;
}

//该方法为点击输入文本框要开始输入是调用的代理方法：就是把view上移到能看见文本框的地方
- (void)textViewDidBeginEditing:(UITextView *)textView{
    CGFloat keyboardHeight = 216.0f;
    if (self.view.frame.size.height - keyboardHeight <= textView.frame.origin.y + textView.frame.size.height) {
        CGFloat y = textView.frame.origin.y - (self.view.frame.size.height - keyboardHeight - textView.frame.size.height - 25);
        [UIView beginAnimations:@"srcollView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.275f];
        self.view.frame = CGRectMake(self.view.frame.origin.x, -y, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}
//该方法为点击虚拟键盘Return，要调用的代理方法：隐藏虚拟键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}
//该方法为完成输入后要调用的代理方法：虚拟键盘隐藏后，要恢复到之前的文本框地方
- (void)textViewDidEndEditing:(UITextView *)textView{
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark - 编辑页面中的保存按钮
-(void)safe{
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    if (self.tureNameField.text.length == 0){
        [self failedPrompt:@"收货人姓名不能为空!"];
    }
    else  if (self.mobileField.text.length == 0) {
        [self failedPrompt:@"手机号码不能为空!"];
    }
    else if ([self.mobileField.text isEqualToString:@" "]) {
        [self failedPrompt:@"不能输入空格"];
    }
    else if (self.addInfoText.text.length == 0){
        [self failedPrompt:@"详细地址不能为空!"];
    }else if (self.regionMyLable.text.length == 0){
        [self failedPrompt:@"地区不能为空"];
    }
    else{
        if ([self isMobileField:_mobileField.text] == NO) {
            
        }else{
            [UIView beginAnimations:@"srcollView" context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.275f];
            self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
            
            [SYObject startLoading];
            
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ADDNEW]];
            requestAddManage1 = [ASIFormDataRequest requestWithURL:url];
            [requestAddManage1 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
            [requestAddManage1 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
            
            [requestAddManage1 setPostValue:_zipField.text forKey:@"zip"];
            
            [requestAddManage1 setPostValue:My_id forKey:@"area_id"];
            [requestAddManage1 setPostValue:@"" forKey:@"mobile"];
            [requestAddManage1 setPostValue:_addInfoText.text forKey:@"area_info"];
            [requestAddManage1 setPostValue:_mobileField.text forKey:@"telephone"];
            [requestAddManage1 setPostValue:_tureNameField.text forKey:@"trueName"];
            [requestAddManage1 setPostValue:th.xiu_addr_id forKey:@"addr_id"];
            
            [requestAddManage1 setRequestHeaders:[LJControl requestHeaderDictionary]];
            requestAddManage1.tag = 101;
            [requestAddManage1 setDelegate: self];
            [requestAddManage1 setDidFailSelector:@selector(my1_urlRequestFailed:)];
            [requestAddManage1 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
            [requestAddManage1 startAsynchronous];
        }
    }
}
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    
    int statuscode2 = [request responseStatusCode];
    [SYObject endLoading];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"新建收货人3332 :%@",dicBig);
        [SYObject endLoading];
        if ([[dicBig objectForKey:@"verify"] isEqualToString:@"true"]) {
            //成功保存
            [SYObject failedPrompt:@"修改成功"];
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer3) userInfo:nil repeats:NO];
        }else{
            [self failedPrompt:@"修改失败"];
        }
        
        
    }
    
}
-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)tiaozhuan{
    
}
- (IBAction)btnprovince:(id)sender {
    My_id = @"";
    regionID = @"";
    regionStr = @"";
    regionView.hidden = NO;
    [SYObject startLoading];
    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,REGION_URL]];
    requestAddManage3 = [ASIFormDataRequest requestWithURL:url2];
    
    [requestAddManage3 setRequestHeaders:[LJControl requestHeaderDictionary]];
    requestAddManage3.tag = 103;
    [requestAddManage3 setDelegate:self];
    [requestAddManage3 setDidFailSelector:@selector(urlRequestFailed:)];
    [requestAddManage3 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [requestAddManage3 startAsynchronous];
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
}
- (IBAction)btnCity:(id)sender {
    UIButton *btn2 = (UIButton *)sender;
    if (btn2.tag == 300) {
        regionStr = @"";
        regionView.hidden = NO;
        NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,REGION_URL]];
        requestAddManage3 = [ASIFormDataRequest requestWithURL:url2];
        
        [requestAddManage3 setRequestHeaders:[LJControl requestHeaderDictionary]];
        requestAddManage3.tag = 103;
        [requestAddManage3 setDelegate:self];
        [requestAddManage3 startAsynchronous];
    }
    
}

- (IBAction)btnTown:(id)sender {
    UIButton *btn3 = (UIButton *)sender;
    if (btn3.tag == 600) {
        regionStr = @"";
        regionView.hidden = NO;
        NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,REGION_URL]];
        requestAddManage3 = [ASIFormDataRequest requestWithURL:url2];
        
        [requestAddManage3 setRequestHeaders:[LJControl requestHeaderDictionary]];
        requestAddManage3.tag = 103;
        [requestAddManage3 setDelegate:self];
        [requestAddManage3 startAsynchronous];
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


@end
