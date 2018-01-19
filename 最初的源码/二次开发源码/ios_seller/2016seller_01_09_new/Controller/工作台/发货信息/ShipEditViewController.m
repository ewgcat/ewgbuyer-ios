//
//  ShipEditViewController.m
//  SellerApp
//
//  Created by apple on 15-3-17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ShipEditViewController.h"
#import "regionCell.h"
#import "ShjModel.h"
#import "AppDelegate.h"

@interface ShipEditViewController (){
    myselfParse *_myParse;
}

@end

@implementation ShipEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增发货地址";
    self.view.backgroundColor = GRAY_COLOR;
    regionArray = [[NSMutableArray alloc]init];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    UILabel *lblShipAddr = [[UILabel alloc]initWithFrame:CGRectMake(0, 69, self.view.frame.size.width, 38)];
    lblShipAddr.text = @"     地址名称:";
    lblShipAddr.textColor = [UIColor grayColor];
    lblShipAddr.backgroundColor = [UIColor whiteColor];
    lblShipAddr.layer.borderWidth = 1.0f;
    lblShipAddr.layer.borderColor = [LINE_COLOR CGColor];
    [self.view addSubview:lblShipAddr];
    _shipAddrField = [[UITextField alloc]initWithFrame:CGRectMake(110, 69, ScreenFrame.size.width - 127, 38)];
    _shipAddrField.placeholder = @"请输入地址名称";
    _shipAddrField.delegate = self;
    [self.view addSubview:_shipAddrField];
    
    UILabel *lblShipAddrNum = [[UILabel alloc]initWithFrame:CGRectMake(0, 111, self.view.frame.size.width, 38)];
    lblShipAddrNum.text = @"     地址序号:";
    lblShipAddrNum.textColor = [UIColor grayColor];
    lblShipAddrNum.backgroundColor = [UIColor whiteColor];
    lblShipAddrNum.layer.borderWidth = 1.0f;
    lblShipAddrNum.layer.borderColor = [LINE_COLOR CGColor];
    [self.view addSubview:lblShipAddrNum];
    _addrNumField = [[UITextField alloc]initWithFrame:CGRectMake(110, 111, ScreenFrame.size.width - 127, 38)];
    _addrNumField.placeholder = @"请输入地址序号";
    _addrNumField.delegate = self;
    _addrNumField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_addrNumField];
    
    UILabel *lblShipName = [[UILabel alloc]initWithFrame:CGRectMake(0, 153, self.view.frame.size.width, 38)];
    lblShipName.text = @"     联系人:";
    lblShipName.textColor = [UIColor grayColor];
    lblShipName.backgroundColor = [UIColor whiteColor];
    lblShipName.layer.borderWidth = 1.0f;
    lblShipName.layer.borderColor = [LINE_COLOR CGColor];
    [self.view addSubview:lblShipName];
    _consigneeField = [[UITextField alloc]initWithFrame:CGRectMake(110, 153, ScreenFrame.size.width - 127, 38)];
    _consigneeField.placeholder = @"请输入联系人姓名";
    _consigneeField.delegate = self;
    [self.view addSubview:_consigneeField];
    
    UILabel *lblShipTel = [[UILabel alloc]initWithFrame:CGRectMake(0, 195, self.view.frame.size.width, 38)];
    lblShipTel.text = @"     联系电话:";
    lblShipTel.textColor = [UIColor grayColor];
    lblShipTel.backgroundColor = [UIColor whiteColor];
    lblShipTel.layer.borderWidth = 1.0f;
    lblShipTel.layer.borderColor = [LINE_COLOR CGColor];
    [self.view addSubview:lblShipTel];
    _shipTelField = [[UITextField alloc]initWithFrame:CGRectMake(110, 195, ScreenFrame.size.width - 127, 38)];
    _shipTelField.placeholder = @"请输入联系电话";
    _shipTelField.delegate = self;
    _shipTelField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_shipTelField];
    
    UILabel *lblShipCompany = [[UILabel alloc]initWithFrame:CGRectMake(0, 237, self.view.frame.size.width, 38)];
    lblShipCompany.text = @"     发货公司:";
    lblShipCompany.textColor = [UIColor grayColor];
    lblShipCompany.backgroundColor = [UIColor whiteColor];
    lblShipCompany.layer.borderWidth = 1.0f;
    lblShipCompany.layer.borderColor = [LINE_COLOR CGColor];
    [self.view addSubview:lblShipCompany];
    _shipCompanyField = [[UITextField alloc]initWithFrame:CGRectMake(110, 237, ScreenFrame.size.width - 127, 38)];
    _shipCompanyField.placeholder = @"请输入发货公司";
    _shipCompanyField.delegate = self;
    [self.view addSubview:_shipCompanyField];
    
    UILabel *lblShipAreaCode = [[UILabel alloc]initWithFrame:CGRectMake(0, 279, self.view.frame.size.width, 38)];
    lblShipAreaCode.text = @"     发货区号:";
    lblShipAreaCode.textColor = [UIColor grayColor];
    lblShipAreaCode.backgroundColor = [UIColor whiteColor];
    lblShipAreaCode.layer.borderWidth = 1.0f;
    lblShipAreaCode.layer.borderColor = [LINE_COLOR CGColor];
    [self.view addSubview:lblShipAreaCode];
    _shipAreaCodeField = [[UITextField alloc]initWithFrame:CGRectMake(110, 279, ScreenFrame.size.width - 127, 38)];
    _shipAreaCodeField.placeholder = @"请输入发货区号";
    _shipAreaCodeField.delegate = self;
    _shipAreaCodeField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_shipAreaCodeField];
    
    UILabel *lblShipHostCity = [[UILabel alloc]initWithFrame:CGRectMake(0, 321, self.view.frame.size.width, 38)];
    lblShipHostCity.text = @"     所在城市:";
    lblShipHostCity.textColor = [UIColor grayColor];
    lblShipHostCity.backgroundColor = [UIColor whiteColor];
    lblShipHostCity.layer.borderWidth = 1.0f;
    lblShipHostCity.layer.borderColor = [LINE_COLOR CGColor];
    [self.view addSubview:lblShipHostCity];
    UIButton *btnCity = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCity.frame = CGRectMake(105, 321, ScreenFrame.size.width - 120, 38);
    [btnCity addTarget:self action:@selector(btnCity) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCity];
    _lblCity = [[UILabel alloc]initWithFrame:CGRectMake(3, 0, ScreenFrame.size.width - 130, 38)];
    _lblCity.text = @"请选择所在城市";
    [btnCity addSubview:_lblCity];
    UIImageView *imgNext = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width - 136, 13, 7, 13)];
    imgNext.image = [UIImage imageNamed:@"next"];
    [btnCity addSubview:imgNext];
    
    UILabel *lblshipStreetAddr = [[UILabel alloc]initWithFrame:CGRectMake(0, 363, self.view.frame.size.width, 75)];
    lblshipStreetAddr.text = @"     详细地址:";
    lblshipStreetAddr.textColor = [UIColor grayColor];
    lblshipStreetAddr.backgroundColor = [UIColor whiteColor];
    lblshipStreetAddr.layer.borderWidth = 1.0f;
    lblshipStreetAddr.layer.borderColor = [LINE_COLOR CGColor];
    [self.view addSubview:lblshipStreetAddr];
    _shipStreetAddrField = [[UITextView alloc]initWithFrame:CGRectMake(110, 363, ScreenFrame.size.width - 127, 73)];
    _shipStreetAddrField.backgroundColor = [UIColor clearColor];
    _shipStreetAddrField.font = [UIFont systemFontOfSize:17];
    _shipStreetAddrField.delegate = self;
    [self.view addSubview:_shipStreetAddrField];
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 30)];
    [topView setBarStyle:UIBarStyleBlack];
    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
    [topView setItems:buttonsArray];
    [_shipStreetAddrField setInputAccessoryView:topView];
    _lblTVTishi = [[UILabel alloc]initWithFrame:CGRectMake(112, 363, ScreenFrame.size.width - 127, 34)];
    _lblTVTishi.text = @"请输入详细地址";
    _lblTVTishi.textColor = [UIColor lightGrayColor];
    _lblTVTishi.hidden = YES;
    [self.view addSubview:_lblTVTishi];
    
    regionView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    regionView.backgroundColor = [UIColor blackColor];
    regionView.alpha = 0.7f;
    regionView.hidden = YES;
    [self.view addSubview:regionView];
    
    if (UIDeviceSystem>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    if (ScreenFrame.size.height>480) {//说明是5 5s
        cityTableView = [[UITableView alloc]initWithFrame:CGRectMake(40, 84, ScreenFrame.size.width - 80, ScreenFrame.size.height-120) style:UITableViewStylePlain];
    }else{
        cityTableView = [[UITableView alloc]initWithFrame:CGRectMake(40, 84, ScreenFrame.size.width - 80, ScreenFrame.size.height-120) style:UITableViewStylePlain];
    }
    cityTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    cityTableView.backgroundColor = [UIColor whiteColor];
    cityTableView.delegate = self;
    cityTableView.dataSource = self;
    cityTableView.hidden = YES;
    cityTableView.showsVerticalScrollIndicator= NO;
    cityTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:cityTableView];
    
    label_prompt = [[UILabel alloc] initWithFrame:CGRectMake(ScreenFrame.size.width/2 - 80, ScreenFrame.size.height - 80, 160, 30)];
    CALayer *lay2 = label_prompt.layer;
    [lay2 setMasksToBounds:YES];
    [lay2 setCornerRadius:8.0];
    label_prompt.text = @"";
    label_prompt.font = [UIFont systemFontOfSize:15];
    label_prompt.backgroundColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
    label_prompt.alpha = 1;
    label_prompt.textColor = [UIColor whiteColor];
    label_prompt.textAlignment = NSTextAlignmentCenter;
    label_prompt.hidden = YES;
    [self.view addSubview:label_prompt];
    [self createBackBtn];
    // Do any additional setup after loading the view.
}

#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (regionArray.count != 0) {
        return regionArray.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myTabelviewCell = @"regionCell";
    regionCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"regionCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (regionArray.count!=0) {
        ShjModel *shjm = [regionArray objectAtIndex:indexPath.row];
        cell.regionLabel.text = shjm.sa_area_name;
    }
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShjModel *shjm = [regionArray objectAtIndex:indexPath.row];
    if (regionStr.length == 0) {
        regionStr = [NSString stringWithFormat:@"%@",shjm.sa_area_name];
    }else{
        regionStr = [NSString stringWithFormat:@"%@%@",regionStr,shjm.sa_area_name];
    }
    if (regionID.length == 0) {
        regionID = [NSString stringWithFormat:@"%@",shjm.sa_area_id];
    }else{
        regionID = [NSString stringWithFormat:@"%@,%@",regionID,shjm.sa_area_id];
    }
    My_id = shjm.sa_area_id;
    _lblCity.text = regionStr;
    
    loadingV.hidden = NO;
    
    
    NSArray *fileContent2 = USER_INFORMATION;
    NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&id=%@",SELLER_URL,REGION_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],shjm.sa_area_id];
    
    [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
        _myParse = myParse;
        loadingV.hidden = YES;
        _myParse = myParse;
        NSDictionary *dicBig = _myParse.dicBig;
        [self shiparea:dicBig];
    } failure:^(){
        [self fail];
    } ];
    NSLog(@"regionStr:%@",regionStr);
}
-(void)fail{
    loadingV.hidden = YES;
    [MyObject failedPrompt: @"未能连接到服务器"];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
}
-(void)shiparea:(NSDictionary *)dicBig{
    if (dicBig) {
        if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"]){
            [self.navigationController popToRootViewControllerAnimated:NO];
            //登录过期 提示重新登录
            [MyObject failedPrompt:@"用户登录已过期，请重新登录"];
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
        }else{
            if (regionArray.count != 0) {
                [regionArray removeAllObjects];
            }
            if (dicBig) {
                NSArray *array = [dicBig objectForKey:@"area_list"];
                if (array.count==0) {
                    regionView.hidden = YES;
                    cityTableView.hidden = YES;
                }
                for (NSDictionary *dic in array) {
                    ShjModel *shjm = [[ShjModel alloc]init];
                    shjm.sa_area_id = [dic objectForKey:@"id"];
                    shjm.sa_area_name = [dic objectForKey:@"name"];
                    [regionArray addObject:shjm];
                }
            }
            [cityTableView reloadData];
        }
    }
}
-(void)btnCity{
    My_id = @"";
    regionID = @"";
    regionStr = @"";
    regionView.hidden = NO;
    cityTableView.hidden= NO;
    loadingV.hidden =NO;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImage:)];
    [regionView addGestureRecognizer:singleTap];
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘

    
    NSArray *fileContent2 = USER_INFORMATION;
    NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@",SELLER_URL,REGION_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0]];
    
    [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
        _myParse = myParse;
        loadingV.hidden = YES;
        _myParse = myParse;
        NSDictionary *dicBig = _myParse.dicBig;
        [self shiparea:dicBig];
    } failure:^(){
        [self fail];
    } ];
}


-(void)clickImage:(UITapGestureRecognizer *)reconginzer{
    regionView.hidden = YES;
    cityTableView.hidden = YES;
}

#pragma mark - SetKeyBoard
-(void)dismissKeyBoard{
    [_shipStreetAddrField resignFirstResponder];
}

//该方法为点击输入文本框要开始输入是调用的代理方法：就是把view上移到能看见文本框的地方
- (void)textViewDidBeginEditing:(UITextView *)textView{
    CGFloat keyboardHeight = 264.0f;
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

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (_shipStreetAddrField.text.length==0){
        if ([text isEqualToString:@""]) {
            _lblTVTishi.hidden = NO;
        }else{
            _lblTVTishi.hidden=YES;
        }
    }else
    {
        if (_shipStreetAddrField.text.length==1){
            if ([text isEqualToString:@""]) {
                _lblTVTishi.hidden=NO;
            }else{
                _lblTVTishi.hidden=YES;
            }
        }else{
            _lblTVTishi.hidden=YES;
        }
    }
    return YES;
}

//该方法为完成输入后要调用的代理方法：虚拟键盘隐藏后，要恢复到之前的文本框地方
- (void)textViewDidEndEditing:(UITextView *)textView{
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGFloat keyboardHeight = 246.0f;
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
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)createBackBtn{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
    button.frame =CGRectMake(0, 0, 44, 44);
    [button setBackgroundImage:[UIImage imageNamed:@"back_lj"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font  = [UIFont systemFontOfSize:14];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
    
    UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSave.frame = CGRectMake(0, 0, 44, 44);
    [btnSave setTitle:@"保存" forState:UIControlStateNormal];
    btnSave.titleLabel.font = [UIFont systemFontOfSize:17];
    [btnSave addTarget:self action:@selector(btnSave) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar2 = [[UIBarButtonItem alloc]initWithCustomView:btnSave];
    self.navigationItem.rightBarButtonItem = bar2;
}

-(void)btnSave{
    NSLog(@"%@", _lblCity.text);
    if (_shipAddrField.text.length == 0) {
        [MyObject failedPrompt:@"地址名称不能为空"];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
    }else if (_lblCity.text.length == 0 || [_lblCity.text isEqualToString:@"请选择所在城市"]) {
        [MyObject failedPrompt:@"所在城市不能为空"];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
    }else if (_shipStreetAddrField.text.length == 0) {
        [MyObject failedPrompt:@"街道地址不能为空"];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
    }else{
        loadingV.hidden =NO;
        
        
        NSArray *fileContent2 = USER_INFORMATION;

        NSDictionary *par = @{
                              @"user_id":[fileContent2 objectAtIndex:2],
                              @"token":[fileContent2 objectAtIndex:0],
                              @"sa_name":_shipAddrField.text,
                              @"sa_sequence":_addrNumField.text,
                              @"sa_user":_consigneeField.text,
                              @"sa_telephone":_shipTelField.text,
                              @"sa_company":_shipCompanyField.text,
                              @"sa_area_id":My_id,
                              @"sa_addr":_shipStreetAddrField.text,
                              @"id":@"",
                              @"sa_zip":_shipAreaCodeField.text
                              };
        [[MyNetTool managerWithVerify]POST:[NSString stringWithFormat:@"%@%@",SELLER_URL,SHIP_ADDR_SAVE_URL] parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            loadingV.hidden = YES;
            NSDictionary *dicBig = responseObject;
            if (dicBig) {
                if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"]){
                    [self.navigationController popToRootViewControllerAnimated:NO];
                    //登录过期 提示重新登录
                    [MyObject failedPrompt:@"用户登录已过期，请重新登录"];
                    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
                }else{
                    NSString *ret = [dicBig objectForKey:@"ret"];
                    if (ret.intValue == 100) {
                        [MyObject failedPrompt:@"保存成功"];
                        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimerTo) userInfo:nil repeats:NO];
                    }
                    else{
                        [MyObject failedPrompt: @"保存失败"];
                        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
                    }
                    
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self fail];
        }];
        
    }
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [_consigneeField resignFirstResponder];
    [_shipAddrField resignFirstResponder];
    [_addrNumField resignFirstResponder];
    [_shipTelField resignFirstResponder];
    [_shipCompanyField resignFirstResponder];
    [_shipAreaCodeField resignFirstResponder];
    [_shipStreetAddrField resignFirstResponder];
}


-(void)doTimer{
    label_prompt.hidden = YES;
}
-(void)doTimerTo{
    label_prompt.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)doTimer_signout{
    label_prompt.hidden = YES;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *MapLayerDataPath2 = [documentsDirectory stringByAppendingPathComponent:@"user_information.txt"];
    BOOL bRet2 = [fileMgr fileExistsAtPath:MapLayerDataPath2];
    if (bRet2) {
        NSError *err;
        [fileMgr removeItemAtPath:MapLayerDataPath2 error:&err];
    }
    AppDelegate *app = [AppDelegate sharedUserDefault];
    app.log_View.hidden = NO;
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
