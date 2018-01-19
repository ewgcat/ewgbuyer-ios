//
//  confirmdeliveryViewController.m
//  SellerApp
//
//  Created by apple on 15-3-24.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "confirmdeliveryViewController.h"
#import "NilCell.h"
#import "OrderlistViewController.h"
#import "AppDelegate.h"
#import "sqlService.h"

@interface confirmdeliveryViewController (){
    myselfParse *_myParse;
}

@end

@implementation confirmdeliveryViewController
-(void)createBackBtn{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
    button.frame =CGRectMake(0, 0, 44, 44);
    [button setBackgroundImage:[UIImage imageNamed:@"back_lj"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom ];
    button2.frame =CGRectMake(0, 0, 50, 44);
    [button2 setTitle:@"提交" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    button2.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    button2.tag = 100;
    UIBarButtonItem *bar2 = [[UIBarButtonItem alloc]initWithCustomView:button2];
    self.navigationItem.rightBarButtonItem =bar2;
}

-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"确认发货";
    self.view.backgroundColor = GRAY_COLOR;
    [self createBackBtn];
    expressCompanyCommon_list = [[NSMutableArray alloc]init];
    shipAddrs_list = [[NSMutableArray alloc]init];
    deliveryGoodsArray = [[NSMutableArray alloc]init];
    describeArray = [[NSMutableArray alloc]init];
    if (UIDeviceSystem>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    if (ScreenFrame.size.height>480) {//说明是5 5s
        Mytableview = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    }else{
        Mytableview = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    }
    Mytableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    Mytableview.delegate = self;
    Mytableview.dataSource=  self;
    Mytableview.backgroundColor = GRAY_COLOR;
    Mytableview.showsVerticalScrollIndicator=NO;
    Mytableview.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:Mytableview];
    
    shipView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    shipView.hidden = YES;
    [self.view addSubview:shipView];
    
    addressView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    addressView.hidden = YES;
    [self.view addSubview:addressView];
    
    loadingV=[LJControl loadingView:CGRectMake((self.view.frame.size.width-100)/2, (self.view.frame.size.height-59-100)/2, 100, 100)];
    [self.view addSubview:loadingV];
    
    label_prompt =[LJControl labelFrame:CGRectMake(50, self.view.frame.size.height-100, self.view.frame.size.width-100, 30) setText:@"" setTitleFont:17 setbackgroundColor:[UIColor blackColor] setTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    [label_prompt.layer setMasksToBounds:YES];
    [label_prompt.layer setCornerRadius:4.0];
    label_prompt.alpha = 0.8;
    label_prompt.hidden = YES;
    [self.view addSubview:label_prompt];
    
    OrderlistViewController *order = [OrderlistViewController sharedUserDefault];
    
    NSArray *fileContent2 = USER_INFORMATION;
    NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_id=%@",SELLER_URL,DELIVERGOODS_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],order.order_id];
    [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
        loadingV.hidden = YES;
        _myParse = myParse;
        NSDictionary *dicBig = _myParse.dicBig; 
        myDic = dicBig;
        if (dicBig) {
            if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"]){
                [self.navigationController popToRootViewControllerAnimated:NO];
                //登录过期 提示重新登录
                [MyObject failedPrompt:@"用户登录已过期，请重新登录"];
                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
            }else{
                physicalGoods = [[dicBig objectForKey:@"physicalGoods"] intValue];//判断是否有实物商品
                if([[dicBig objectForKey:@"physicalGoods"] intValue] == 1){//实物
                    lbl_ordernum2.text = [dicBig objectForKey:@"order_id"];
                    shipAddrField.text = @"";
                    expressCompanyCommon_list = [dicBig objectForKey:@"expressCompanyCommon_list"];
                    if (expressCompanyCommon_list.count==0) {
                        shipcompany = @"点击选择物流公司";
                    }else{
                        shipcompany = [[expressCompanyCommon_list objectAtIndex:0] objectForKey:@"ecc_name"];
                        ecc_id = [[expressCompanyCommon_list objectAtIndex:0] objectForKey:@"id"];
                    }
                    shipAddrs_list = [dicBig objectForKey:@"shipAddrs_list"];
                    if (shipAddrs_list.count == 0) {
                        sendAddress = @"点击选择发货地址";
                    }else{
                        sendAddress = [[shipAddrs_list objectAtIndex:0] objectForKey:@"sa_name"];
                        sa_id = [[shipAddrs_list objectAtIndex:0] objectForKey:@"id"];
                    }
                    NSArray *arr = [dicBig objectForKey:@"deliveryGoods"];
                    for(int i=0;i<arr.count+1;i++){
                        if (i == arr.count) {
                            [describeArray addObject:@""];
                        }else{
                            [describeArray addObject:@""];
                        }
                    }
                }else{//虚拟
                    NSArray *arr = [dicBig objectForKey:@"deliveryGoods"];
                    for(int i=0;i<arr.count+1;i++){
                        if (i == arr.count) {
                            [describeArray addObject:@""];
                        }else{
                            [describeArray addObject:@""];
                        }
                    }
                }
                
                [Mytableview reloadData];
                
            }
        }
    } failure:^(){
        [self fail];
    } ];
}
-(void)failedPrompt:(NSString *)prompt{
    loadingV.hidden = YES;
    label_prompt.hidden = NO;
    label_prompt.text = prompt;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
}
-(void)fail{
    [MyObject failedPrompt:@"未能连接到服务器"];
}
-(void)clearCacheSuccessOut{
    NSLog(@"成功");
}
-(void)doTimer_signout{
    label_prompt.hidden = YES;
    [LJControl cleanAll];
    AppDelegate *app = [AppDelegate sharedUserDefault];
    app.log_View.hidden = NO;
}
-(void)doTimer{
    label_prompt.hidden = YES;
}

-(void)disappear2{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 1;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;
    [[self.view layer] addAnimation:animation forKey:@"animation"];
    addressView.hidden = YES;
    for (UIView *subView in addressView.subviews)
    {
        [subView removeFromSuperview];
    }
}
-(void)disappear{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 1;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;
    [[self.view layer] addAnimation:animation forKey:@"animation"];
    shipView.hidden = YES;
    for (UIView *subView in shipView.subviews)
    {
        [subView removeFromSuperview];
    }
}
-(void)btnClicked:(UIButton *)btn{
    if (btn.tag == 100) { 
        if (physicalGoods == 1) {
            if(shipAddrField.text.length == 0){
                [MyObject failedPrompt:@"物流单号不能为空"];
            }else{
                OrderlistViewController *order = [OrderlistViewController sharedUserDefault];
                
                NSArray *fileContent2 = USER_INFORMATION;
                NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&ecc_id=%@&sa_id=%@&state_info=%@&order_id=%@",SELLER_URL,DELIVERGOODS_SAVE_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],ecc_id,sa_id,shipStreetAddrField.text,order.order_id];
                
                NSArray *arr = (NSArray *)[myDic objectForKey:@"deliveryGoods"];
                if(arr.count == 0){
                    
                }else{
                    NSString *good_id ;
                    NSString *goods_name ;
                    NSString *goods_count;
                    for(int i=0;i<arr.count;i++){
                        if (good_id.length == 0) {
                            good_id = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"goods_id"]];
                        }else{
                            good_id = [NSString stringWithFormat:@"%@,%@",good_id,[[arr objectAtIndex:i] objectForKey:@"goods_id"]];
                        }
                        if (goods_name.length == 0) {
                            goods_name = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"goods_name"]];
                        }else{
                            goods_name = [NSString stringWithFormat:@"%@,%@",goods_name,[[arr objectAtIndex:i] objectForKey:@"goods_name"]];
                        }
                        if (goods_count.length == 0) {
                            goods_count = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"goods_count"]];
                        }else{
                            goods_count = [NSString stringWithFormat:@"%@,%@",goods_count,[[arr objectAtIndex:i] objectForKey:@"goods_count"]];
                        }
                    }
                    NSString *order_seller_intro;
                    for(int i=0;i<describeArray.count;i++){
                        if (order_seller_intro.length == 0) {
                            order_seller_intro = [NSString stringWithFormat:@"%@",[describeArray objectAtIndex:i]];
                        }else{
                            order_seller_intro = [NSString stringWithFormat:@"%@,%@",order_seller_intro,[describeArray objectAtIndex:i]];
                        }
                    }
                    url = [NSString stringWithFormat:@"%@&goods_id=%@&goods_name=%@&goods_count=%@&order_seller_intro=%@&state_info=%@",url,good_id,goods_name,goods_count,order_seller_intro,shipStreetAddrField.text];
                }
                
                [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
                    loadingV.hidden = YES;
                    _myParse = myParse;
                    NSDictionary *dicBig = _myParse.dicBig;
                    if (dicBig) {
                        if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"]){
                            [self.navigationController popToRootViewControllerAnimated:NO];
                            //登录过期 提示重新登录
                            [MyObject failedPrompt:@"用户登录已过期，请重新登录"];
                            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
                        }else{
                            if ([[dicBig objectForKey:@"ret"] intValue] == 100) {
                                [MyObject failedPrompt:@"已成功发货"];
                                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_disappear) userInfo:nil repeats:NO];
                            }else{
                                [MyObject failedPrompt:@"发货失败,请重试"];
                            }
                            
                        }
                    }
                } failure:^(){
                    [self fail];
                } ];
            }
            
        }else{
            NSString *good_id ;
            NSString *goods_name ;
            NSString *goods_count;
            NSArray *arr = (NSArray *)[myDic objectForKey:@"deliveryGoods"];
            for(int i=0;i<arr.count;i++){
                if (good_id.length == 0) {
                    good_id = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"goods_id"]];
                }else{
                    good_id = [NSString stringWithFormat:@"%@,%@",good_id,[[arr objectAtIndex:i] objectForKey:@"goods_id"]];
                }
                if (goods_name.length == 0) {
                    goods_name = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"goods_name"]];
                }else{
                    goods_name = [NSString stringWithFormat:@"%@,%@",goods_name,[[arr objectAtIndex:i] objectForKey:@"goods_name"]];
                }
                if (goods_count.length == 0) {
                    goods_count = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"goods_count"]];
                }else{
                    goods_count = [NSString stringWithFormat:@"%@,%@",goods_count,[[arr objectAtIndex:i] objectForKey:@"goods_count"]];
                }
            }
            NSString *order_seller_intro;
            for(int i=0;i<describeArray.count;i++){
                if (order_seller_intro.length == 0) {
                    order_seller_intro = [NSString stringWithFormat:@"%@",[describeArray objectAtIndex:i]];
                }else{
                    order_seller_intro = [NSString stringWithFormat:@"%@,%@",order_seller_intro,[describeArray objectAtIndex:i]];
                }
            }
            
            OrderlistViewController *order = [OrderlistViewController sharedUserDefault];
            
            NSArray *fileContent2 = USER_INFORMATION;
            NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_id=%@&goods_id=%@&goods_name=%@&goods_count=%@&order_seller_intro=%@&state_info=%@",SELLER_URL,DELIVERGOODS_SAVE_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],order.order_id,good_id,goods_name,goods_count,order_seller_intro,shipStreetAddrField.text];
            [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
                loadingV.hidden = YES;
                _myParse = myParse;
                NSDictionary *dicBig = _myParse.dicBig;
                if (dicBig) {
                    if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"]){
                        [self.navigationController popToRootViewControllerAnimated:NO];
                        //登录过期 提示重新登录
                        [MyObject failedPrompt:@"用户登录已过期，请重新登录"];
                        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
                    }
                    else{
                        if ([[dicBig objectForKey:@"ret"] intValue] == 100) {
                            [MyObject failedPrompt:@"已成功发货"];
                            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_disappear) userInfo:nil repeats:NO];
                        }else{
                            [MyObject failedPrompt:@"发货失败,请重试"];
                        }
                    }
                }
            } failure:^(){
                [self fail];
            } ];
        }
    }
    if (btn.tag == 101) {
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 1;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionFade;
        [[self.view layer] addAnimation:animation forKey:@"animation"];
        addressView.hidden = NO;
        
        UIImageView *grayImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, addressView.frame.size.width, addressView.frame.size.height)];
        grayImageview.alpha = 0.5;
        grayImageview.userInteractionEnabled = YES;
        grayImageview.backgroundColor = [UIColor blackColor];
        [addressView addSubview:grayImageview];
        UITapGestureRecognizer *tapGr2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappear2)];
        tapGr2.cancelsTouchesInView = NO;
        [grayImageview addGestureRecognizer:tapGr2];
        
        if (ScreenFrame.size.height>480) {//说明是5 5s
            address_tableview = [[UITableView alloc] initWithFrame:CGRectMake(40, (addressView.frame.size.height-40*5)/2-40, ScreenFrame.size.width-80, 40*5)];
        }else{
            address_tableview = [[UITableView alloc] initWithFrame:CGRectMake(40, (addressView.frame.size.height-40*5)/2-40, ScreenFrame.size.width-80, 40*5)];
        }
        address_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        address_tableview.delegate = self;
        address_tableview.dataSource=  self;
        address_tableview.showsVerticalScrollIndicator=NO;
        address_tableview.showsHorizontalScrollIndicator = NO;
        [address_tableview.layer setMasksToBounds:YES];
        [address_tableview.layer setCornerRadius:4.0f];
        [addressView addSubview:address_tableview];
    }
    if (btn.tag == 102) {
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 1;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionFade;
        [[self.view layer] addAnimation:animation forKey:@"animation"];
        shipView.hidden = NO;
        
        UIImageView *grayImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, shipView.frame.size.width, shipView.frame.size.height)];
        grayImageview.alpha = 0.5;
        grayImageview.userInteractionEnabled = YES;
        grayImageview.backgroundColor = [UIColor blackColor];
        [shipView addSubview:grayImageview];
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappear)];
        tapGr.cancelsTouchesInView = NO;
        [grayImageview addGestureRecognizer:tapGr];
        UITableView *orderlist_tableview;
        if (ScreenFrame.size.height>480) {//说明是5 5s
            orderlist_tableview = [[UITableView alloc] initWithFrame:CGRectMake(40, (shipView.frame.size.height-40*5)/2-40, ScreenFrame.size.width-80, 40*5)];
        }else{
            orderlist_tableview = [[UITableView alloc] initWithFrame:CGRectMake(40, (shipView.frame.size.height-40*5)/2-40, ScreenFrame.size.width-80, 40*5)];
        }
        orderlist_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        orderlist_tableview.delegate = self;
        orderlist_tableview.dataSource=  self;
        orderlist_tableview.showsVerticalScrollIndicator=NO;
        orderlist_tableview.showsHorizontalScrollIndicator = NO;
        [orderlist_tableview.layer setMasksToBounds:YES];
        [orderlist_tableview.layer setCornerRadius:4.0f];
        [shipView addSubview:orderlist_tableview];
    }
}
-(void)doTimer_disappear{
    label_prompt.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [shipStreetAddrField resignFirstResponder];
    [shipAddrField resignFirstResponder];
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}
-(void)dismissKeyBoard{
    [shipStreetAddrField resignFirstResponder];
    [shipAddrField resignFirstResponder];
    
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark -textField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGFloat keyboardHeight = 260.0f;
    if (self.view.frame.size.height - keyboardHeight <= textField.frame.origin.y + textField.frame.size.height) {
        CGFloat y = textField.frame.origin.y - (self.view.frame.size.height - keyboardHeight - textField.frame.size.height-40);
        [UIView beginAnimations:@"srcollView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.275f];
        self.view.frame = CGRectMake(self.view.frame.origin.x, -y, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [shipStreetAddrField resignFirstResponder];
    [shipAddrField resignFirstResponder];
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    return YES;
}

#pragma mark -textView delegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    CGFloat keyboardHeight = 260.0f;
    if (self.view.frame.size.height - keyboardHeight <= textView.frame.origin.y + textView.frame.size.height) {
        CGFloat y = textView.frame.origin.y - (self.view.frame.size.height - keyboardHeight - textView.frame.size.height-50);
        [UIView beginAnimations:@"srcollView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.275f];
        self.view.frame = CGRectMake(self.view.frame.origin.x, -y, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    if ([textView.text isEqualToString:@"输入操作说明"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }else {
    }
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.tag == 100) {
        [describeArray replaceObjectAtIndex:describeArray.count-1 withObject:textView.text];
    }else{
        for(int i=0;i<describeArray.count;i++){
            if (textView.tag == i) {
                [describeArray replaceObjectAtIndex:i withObject:textView.text];
            }
        }
    }
}
#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == address_tableview) {
        if (shipAddrs_list.count!=0) {
            return shipAddrs_list.count+1;
        }
    }else if(tableView == Mytableview){
        return 2;
    }else{
        if (expressCompanyCommon_list.count!=0) {
            return expressCompanyCommon_list.count+1;
        }
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == Mytableview) {
        if(physicalGoods == 1){
            if (indexPath.row == 0) {
                return 44*5+20;
            }else if (indexPath.row == 1) {
                NSArray *arr = (NSArray *)[myDic objectForKey:@"deliveryGoods"];
                return 30+117*arr.count+47;
            }
        }else{
            if (indexPath.row == 0) {
                return 64;
            }else if (indexPath.row == 1){
                NSArray *arr = (NSArray *)[myDic objectForKey:@"deliveryGoods"];
                return 30+117*arr.count+47;
            }else{
                return 67;
            }
        }
        
        return 0;
    }
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myTabelviewCell = @"NilCell";
    NilCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NilCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        for (UIView *subView in cell.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    if (tableView == address_tableview) {
        if (indexPath.row == 0) {
            UILabel *lbl_des = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
            lbl_des.text = @"选择发货地址";
            lbl_des.textColor = [UIColor whiteColor];
            lbl_des.font = [UIFont boldSystemFontOfSize:19];
            lbl_des.backgroundColor = NAV_COLOR;
            lbl_des.textAlignment = NSTextAlignmentCenter;
            [cell addSubview:lbl_des];
        }else{
            if (shipAddrs_list.count!=0) {
                UILabel *lbl_des = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
                lbl_des.text = [[shipAddrs_list objectAtIndex:indexPath.row-1] objectForKey:@"sa_name"];
                lbl_des.textColor = [UIColor blackColor];
                lbl_des.font = [UIFont systemFontOfSize:17];
                lbl_des.backgroundColor = [UIColor whiteColor];
                lbl_des.textAlignment = NSTextAlignmentCenter;
                [cell addSubview:lbl_des];
                UIImageView *imageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(10, 39.5, tableView.frame.size.width-20, 0.5)];
                imageVIew.backgroundColor = [UIColor lightGrayColor];
                [cell addSubview:imageVIew];
                if ([sa_id intValue]==[[[shipAddrs_list objectAtIndex:indexPath.row-1] objectForKey:@"id"] intValue ]) {
                    UIImageView *imageVIew2 = [[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width-34, 12, 16, 16)];
                    imageVIew2.image = [UIImage imageNamed:@"yes"];
                    [cell addSubview:imageVIew2];
                }
            }
        }
    }else if(tableView == Mytableview){
        cell.backgroundColor = GRAY_COLOR;
        if (physicalGoods == 1) {
            if (indexPath.row == 0) {
                UIView *whiteVIew = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44*5+3)];
                whiteVIew.backgroundColor = [UIColor whiteColor];
                [cell addSubview:whiteVIew];
                UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
                imageLine.backgroundColor = [UIColor lightGrayColor];
                [whiteVIew addSubview:imageLine];
                UIImageView *imageLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, whiteVIew.frame.size.height-0.5, self.view.frame.size.width, 0.5)];
                imageLine2.backgroundColor = [UIColor lightGrayColor];
                [whiteVIew addSubview:imageLine2];
                for(int i=0;i<4;i++){
                    UIImageView *imageLine3 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 43.75+44*i, self.view.frame.size.width-15, 0.5)];
                    imageLine3.backgroundColor = LINE_COLOR;
                    [whiteVIew addSubview:imageLine3];
                }
                
                UILabel *lbl_ordernum = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-30, 44)];
                lbl_ordernum.text = @"订单号";
                [whiteVIew addSubview:lbl_ordernum];
                lbl_ordernum2 = [[UILabel alloc]initWithFrame:CGRectMake(115, 0, self.view.frame.size.width-130, 44)];
                lbl_ordernum2.text = [myDic objectForKey:@"order_id"];
                [whiteVIew addSubview:lbl_ordernum2];
                UILabel *lbl_shipCom = [[UILabel alloc]initWithFrame:CGRectMake(15, 44, self.view.frame.size.width-30, 44)];
                lbl_shipCom.text = @"物流公司";
                [whiteVIew addSubview:lbl_shipCom];
                UILabel *lbl_ads = [[UILabel alloc]initWithFrame:CGRectMake(15, 44*2, self.view.frame.size.width-30, 44)];
                lbl_ads.text = @"发货地址";
                [whiteVIew addSubview:lbl_ads];
                lbl_detailAds2 = [[UILabel alloc]initWithFrame:CGRectMake(115, 44, self.view.frame.size.width-130, 44)];
                lbl_detailAds2.text = shipcompany;
                lbl_detailAds2.textColor = [UIColor lightGrayColor];
                [whiteVIew addSubview:lbl_detailAds2];
                UIImageView *imageN2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-35, 17, 6, 10)];
                imageN2.image = [UIImage imageNamed:@"next"];
                [lbl_shipCom addSubview:imageN2];
                UIButton *button_ads2 = [UIButton buttonWithType:UIButtonTypeCustom ];
                button_ads2.frame =CGRectMake(15, 44, self.view.frame.size.width-30, 44);
                [button_ads2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
                button_ads2.tag = 102;
                [whiteVIew addSubview:button_ads2];
                
                lbl_detailAds = [[UILabel alloc]initWithFrame:CGRectMake(115, 44*2, self.view.frame.size.width-130, 44)];
                lbl_detailAds.text = sendAddress;
                lbl_detailAds.textColor = [UIColor grayColor];
                [whiteVIew addSubview:lbl_detailAds];
                UIImageView *imageN = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-35, 17, 6, 10)];
                imageN.image = [UIImage imageNamed:@"next"];
                [lbl_ads addSubview:imageN];
                UIButton *button_ads = [UIButton buttonWithType:UIButtonTypeCustom ];
                button_ads.frame =CGRectMake(15, 44*2, self.view.frame.size.width-30, 44);
                [button_ads addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
                button_ads.tag = 101;
                [whiteVIew addSubview:button_ads];
                
                UILabel *lbl_num = [[UILabel alloc]initWithFrame:CGRectMake(15, 44*3, self.view.frame.size.width-30, 44)];
                lbl_num.text = @"物流单号";
                [whiteVIew addSubview:lbl_num];
                UILabel *lbl_des = [[UILabel alloc]initWithFrame:CGRectMake(15, 44*4, self.view.frame.size.width-30, 47)];
                lbl_des.text = @"操作说明";
                [whiteVIew addSubview:lbl_des];
                
                shipAddrField = [[UITextField alloc]initWithFrame:CGRectMake(115, 44*3+20, ScreenFrame.size.width - 148-5, 44)];
                shipAddrField.placeholder = @"输入物流单号";
                shipAddrField.delegate = self;
                shipAddrField.keyboardType = UIKeyboardTypeNumberPad;
                [cell addSubview:shipAddrField];
                UIImageView *imageEdit2 = [[UIImageView alloc]initWithFrame:CGRectMake(shipAddrField.frame.size.width+shipAddrField.frame.origin.x, 15, 14, 14)];
                imageEdit2.image = [UIImage imageNamed:@"edit"];
                [lbl_num addSubview:imageEdit2];
                UIToolbar * topView1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 30)];
                [topView1 setBarStyle:UIBarStyleBlack];
                UIBarButtonItem * helloButton1 = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
                UIBarButtonItem * btnSpace1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
                UIBarButtonItem *doneButton1 = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
                NSArray * buttonsArray1 = [NSArray arrayWithObjects:helloButton1,btnSpace1,doneButton1,nil];
                [topView1 setItems:buttonsArray1];
                [shipAddrField setInputAccessoryView:topView1];
                
                shipStreetAddrField = [[UITextView alloc]initWithFrame:CGRectMake(110, 44*4+3+20, ScreenFrame.size.width - 148, 41)];
                shipStreetAddrField.delegate = self;
                shipStreetAddrField.text = @"输入操作说明";
                shipStreetAddrField.tag = 100;
                shipStreetAddrField.textColor = [UIColor lightGrayColor];
                shipStreetAddrField.backgroundColor = [UIColor clearColor];
                shipStreetAddrField.font = [UIFont systemFontOfSize:17];
                [cell addSubview:shipStreetAddrField];
                UIImageView *imageEdit = [[UIImageView alloc]initWithFrame:CGRectMake(shipStreetAddrField.frame.size.width+shipStreetAddrField.frame.origin.x, 15, 14, 14)];
                imageEdit.image = [UIImage imageNamed:@"edit"];
                [lbl_des addSubview:imageEdit];
                UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 30)];
                [topView setBarStyle:UIBarStyleBlack];
                UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
                UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
                UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
                NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
                [topView setItems:buttonsArray];
                [shipStreetAddrField setInputAccessoryView:topView];
            }else{
                if (indexPath.row == 1) {
                    NSArray *arr = (NSArray *)[myDic objectForKey:@"deliveryGoods"];
                    if (!arr){
                        UITableViewCell *cell = [UITableViewCell new];
                        cell.backgroundColor = tableView.backgroundColor;
                        return cell;
                    }
                    UILabel *lbl_shipCom = [[UILabel alloc]initWithFrame:CGRectMake(15, 8, self.view.frame.size.width-30, 20)];
                    lbl_shipCom.text = @"虚拟商品";
                    lbl_shipCom.font = [UIFont systemFontOfSize:15];
                    lbl_shipCom.textColor = [UIColor grayColor];
                    [cell addSubview:lbl_shipCom];
                    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 117*arr.count+47)];
                    view.backgroundColor = [UIColor whiteColor];
                    [cell addSubview:view];
                    UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
                    imageLine.backgroundColor = [UIColor lightGrayColor];
                    [view addSubview:imageLine];
                    UIImageView *imageLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, view.frame.size.height-0.5, self.view.frame.size.width, 0.5)];
                    imageLine2.backgroundColor = [UIColor lightGrayColor];
                    [view addSubview:imageLine2];
                    
                    for(int i=0;i<arr.count;i++){
                        UILabel *lbl_name = [[UILabel alloc]initWithFrame:CGRectMake(15, 0+117*i, self.view.frame.size.width-30, 48)];
                        lbl_name.text = [[arr objectAtIndex:i] objectForKey:@"goods_name"];
                        lbl_name.numberOfLines = 2;
                        lbl_name.textColor = [UIColor darkGrayColor];
                        lbl_name.font = [UIFont systemFontOfSize:15];
                        [view addSubview:lbl_name];
                        UILabel *lbl_cc = [[UILabel alloc]initWithFrame:CGRectMake(15, 44+117*i, self.view.frame.size.width-30, 20)];
                        lbl_cc.text = [NSString stringWithFormat:@"数量:%d",[[[arr objectAtIndex:i] objectForKey:@"goods_count"] intValue] ];
                        lbl_cc.textColor = [UIColor darkGrayColor];
                        lbl_cc.font = [UIFont systemFontOfSize:14];
                        [view addSubview:lbl_cc];
                        UILabel *lbl_ss = [[UILabel alloc]initWithFrame:CGRectMake(15, 76+117*i, self.view.frame.size.width-30, 20)];
                        lbl_ss.text = @"商品说明";
                        lbl_ss.font = [UIFont systemFontOfSize:15];
                        [view addSubview:lbl_ss];
                        UIImageView *imageLine3 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 117+117*i, self.view.frame.size.width-15, 0.5)];
                        imageLine3.backgroundColor = LINE_COLOR;
                        [view addSubview:imageLine3];
                        UITextView *goodsIntroduce = [[UITextView alloc]initWithFrame:CGRectMake(95, 68+117*i, ScreenFrame.size.width - 110, 44)];
                        goodsIntroduce.text = [describeArray objectAtIndex:i];
                        goodsIntroduce.delegate = self;
                        goodsIntroduce.textColor = [UIColor grayColor];
                        goodsIntroduce.font = [UIFont systemFontOfSize:17];
                        goodsIntroduce.layer.borderWidth = 1;
                        goodsIntroduce.tag = i;
                        goodsIntroduce.layer.borderColor = [LINE_COLOR CGColor];
                        [view addSubview:goodsIntroduce];
                        
                        UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 30)];
                        [topView setBarStyle:UIBarStyleBlack];
                        UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
                        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
                        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
                        NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
                        [topView setItems:buttonsArray];
                        [goodsIntroduce setInputAccessoryView:topView];
                    }
                }
            }
        }else{
            if (indexPath.row == 0) {
                UIView *whiteVIew = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
                whiteVIew.backgroundColor = [UIColor whiteColor];
                [cell addSubview:whiteVIew];
                UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
                imageLine.backgroundColor = [UIColor lightGrayColor];
                [whiteVIew addSubview:imageLine];
                UIImageView *imageLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, whiteVIew.frame.size.height-0.5, self.view.frame.size.width, 0.5)];
                imageLine2.backgroundColor = [UIColor lightGrayColor];
                [whiteVIew addSubview:imageLine2];
                
                UILabel *lbl_ordernum = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-30, 44)];
                lbl_ordernum.text = @"订单号";
                [whiteVIew addSubview:lbl_ordernum];
                lbl_ordernum2 = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, self.view.frame.size.width-130, 44)];
                
                lbl_ordernum2.text = [NSString stringWithFormat:@"%@",[myDic objectForKey:@"order_id"]];
                [whiteVIew addSubview:lbl_ordernum2];
            }else if (indexPath.row == 1){
                UILabel *lbl_shipCom = [[UILabel alloc]initWithFrame:CGRectMake(15, 8, self.view.frame.size.width-30, 20)];
                lbl_shipCom.text = @"虚拟商品";
                lbl_shipCom.font = [UIFont systemFontOfSize:15];
                lbl_shipCom.textColor = [UIColor grayColor];
                [cell addSubview:lbl_shipCom];
                NSArray *arr = (NSArray *)[myDic objectForKey:@"deliveryGoods"];
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 117*arr.count+47)];
                view.backgroundColor = [UIColor whiteColor];
                [cell addSubview:view];
                UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
                imageLine.backgroundColor = [UIColor lightGrayColor];
                [view addSubview:imageLine];
                UIImageView *imageLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, view.frame.size.height-0.5, self.view.frame.size.width, 0.5)];
                imageLine2.backgroundColor = [UIColor lightGrayColor];
                [view addSubview:imageLine2];
                
                for(int i=0;i<arr.count;i++){
                    UILabel *lbl_name = [[UILabel alloc]initWithFrame:CGRectMake(15, 0+117*i, self.view.frame.size.width-30, 48)];
                    lbl_name.text = [[arr objectAtIndex:i] objectForKey:@"goods_name"];
                    lbl_name.numberOfLines = 2;
                    lbl_name.textColor = [UIColor darkGrayColor];
                    lbl_name.font = [UIFont systemFontOfSize:15];
                    [view addSubview:lbl_name];
                    UILabel *lbl_cc = [[UILabel alloc]initWithFrame:CGRectMake(15, 44+117*i, self.view.frame.size.width-30, 20)];
                    lbl_cc.text = [NSString stringWithFormat:@"数量:%d",[[[arr objectAtIndex:i] objectForKey:@"goods_count"] intValue] ];
                    lbl_cc.textColor = [UIColor darkGrayColor];
                    lbl_cc.font = [UIFont systemFontOfSize:14];
                    [view addSubview:lbl_cc];
                    UILabel *lbl_ss = [[UILabel alloc]initWithFrame:CGRectMake(15, 76+117*i, self.view.frame.size.width-30, 20)];
                    lbl_ss.text = @"商品说明";
                    lbl_ss.font = [UIFont systemFontOfSize:15];
                    [view addSubview:lbl_ss];
                    UIImageView *imageLine3 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 117+117*i, self.view.frame.size.width-15, 0.5)];
                    imageLine3.backgroundColor = LINE_COLOR;
                    [view addSubview:imageLine3];
                    UITextView *goodsIntroduce = [[UITextView alloc]initWithFrame:CGRectMake(95, 68+117*i, ScreenFrame.size.width - 110, 44)];
                    goodsIntroduce.text = [describeArray objectAtIndex:i];
                    goodsIntroduce.delegate = self;
                    goodsIntroduce.textColor = [UIColor grayColor];
                    goodsIntroduce.font = [UIFont systemFontOfSize:17];
                    goodsIntroduce.layer.borderWidth = 1;
                    goodsIntroduce.tag = i;
                    goodsIntroduce.layer.borderColor = [LINE_COLOR CGColor];
                    [view addSubview:goodsIntroduce];
                    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 30)];
                    [topView setBarStyle:UIBarStyleBlack];
                    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
                    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
                    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
                    NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
                    [topView setItems:buttonsArray];
                    [goodsIntroduce setInputAccessoryView:topView];
                }
                UILabel *lbl_des = [[UILabel alloc]initWithFrame:CGRectMake(15, view.frame.size.height-47, self.view.frame.size.width-30, 47)];
                lbl_des.text = @"操作说明";
                [view addSubview:lbl_des];
                shipStreetAddrField = [[UITextView alloc]initWithFrame:CGRectMake(90, view.frame.size.height-43, self.view.frame.size.width - 128, 41)];
                shipStreetAddrField.delegate = self;
                shipStreetAddrField.text = [describeArray lastObject];
                shipStreetAddrField.textColor = [UIColor lightGrayColor];
                shipStreetAddrField.backgroundColor = [UIColor clearColor];
                shipStreetAddrField.tag = 100;
                shipStreetAddrField.font = [UIFont systemFontOfSize:17];
                [view addSubview:shipStreetAddrField];
                UIImageView *imageEdit = [[UIImageView alloc]initWithFrame:CGRectMake(shipStreetAddrField.frame.size.width+shipStreetAddrField.frame.origin.x, 15, 14, 14)];
                imageEdit.image = [UIImage imageNamed:@"edit"];
                [lbl_des addSubview:imageEdit];
                UIToolbar * topView2 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 30)];
                [topView2 setBarStyle:UIBarStyleBlack];
                UIBarButtonItem * helloButton2 = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
                UIBarButtonItem * btnSpace2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
                UIBarButtonItem *doneButton2 = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
                NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton2,btnSpace2,doneButton2,nil];
                [topView2 setItems:buttonsArray];
                [shipStreetAddrField setInputAccessoryView:topView2];
            }
        }
    }else{
        if (indexPath.row == 0) {
            UILabel *lbl_des = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
            lbl_des.text = @"选择物流公司";
            lbl_des.textColor = [UIColor whiteColor];
            lbl_des.font = [UIFont boldSystemFontOfSize:19];
            lbl_des.backgroundColor = NAV_COLOR;
            lbl_des.textAlignment = NSTextAlignmentCenter;
            [cell addSubview:lbl_des];
        }else{
            if (expressCompanyCommon_list.count!=0) {
                UILabel *lbl_des = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
                lbl_des.text = [[expressCompanyCommon_list objectAtIndex:indexPath.row-1] objectForKey:@"ecc_name"];
                lbl_des.textColor = [UIColor blackColor];
                lbl_des.font = [UIFont boldSystemFontOfSize:17];
                lbl_des.backgroundColor = [UIColor whiteColor];
                lbl_des.textAlignment = NSTextAlignmentCenter;
                [cell addSubview:lbl_des];
                UIImageView *imageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(10, 39.5, tableView.frame.size.width-20, 0.5)];
                imageVIew.backgroundColor = [UIColor lightGrayColor];
                [cell addSubview:imageVIew];
                if ([ecc_id intValue]==[[[expressCompanyCommon_list objectAtIndex:indexPath.row-1] objectForKey:@"id"] intValue ]) {
                    UIImageView *imageVIew2 = [[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width-34, 12, 16, 16)];
                    imageVIew2.image = [UIImage imageNamed:@"yes"];
                    [cell addSubview:imageVIew2];
                }
            }
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 1;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;
    [[self.view layer] addAnimation:animation forKey:@"animation"];
    if (tableView == address_tableview) {
        sa_id = [[shipAddrs_list objectAtIndex:indexPath.row-1] objectForKey:@"id"];
        lbl_detailAds.text = [[shipAddrs_list objectAtIndex:indexPath.row-1] objectForKey:@"sa_name"];
        addressView.hidden = YES;
        for (UIView *subView in addressView.subviews)
        {
            [subView removeFromSuperview];
        }
    }else if (tableView == Mytableview){
        
    }else{
        ecc_id = [[expressCompanyCommon_list objectAtIndex:indexPath.row-1] objectForKey:@"id"];
        lbl_detailAds2.text = [[expressCompanyCommon_list objectAtIndex:indexPath.row-1] objectForKey:@"ecc_name"];
        shipView.hidden = YES;
        for (UIView *subView in shipView.subviews)
        {
            [subView removeFromSuperview];
        }
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
