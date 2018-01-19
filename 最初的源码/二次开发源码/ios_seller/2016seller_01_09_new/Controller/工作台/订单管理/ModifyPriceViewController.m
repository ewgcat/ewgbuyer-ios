//
//  ModifyPriceViewController.m
//  SellerApp
//
//  Created by apple on 15-3-30.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ModifyPriceViewController.h"
#import "OrderlistViewController.h"
#import "AppDelegate.h"
#import "sqlService.h"
@interface ModifyPriceViewController ()

@end

@implementation ModifyPriceViewController{
    myselfParse *_myParse;
}
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
    button2.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [button2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    button2.tag = 100;
    UIBarButtonItem *bar2 = [[UIBarButtonItem alloc]initWithCustomView:button2];
    self.navigationItem.rightBarButtonItem =bar2;
}

-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改价格";
    self.view.backgroundColor = GRAY_COLOR;
    [self createBackBtn];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChange:) name:@"UITextFieldTextDidChangeNotification" object:nil];
    
    UIView *whiteVIew = [[UIView alloc]initWithFrame:CGRectMake(0, 84, self.view.frame.size.width, 44*6)];
    whiteVIew.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteVIew];
    UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
    imageLine.backgroundColor = [UIColor lightGrayColor];
    [whiteVIew addSubview:imageLine];
    UIImageView *imageLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, whiteVIew.frame.size.height-0.5, self.view.frame.size.width, 0.5)];
    imageLine2.backgroundColor = [UIColor lightGrayColor];
    [whiteVIew addSubview:imageLine2];
    
    UILabel *lbl_ordernum = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-30, 44)];
    lbl_ordernum.text = @"买家用户";
    lbl_ordernum.font = [UIFont systemFontOfSize:17];
    [whiteVIew addSubview:lbl_ordernum];
    lbl_ordernum2 = [[UILabel alloc]initWithFrame:CGRectMake(15+100, 0, self.view.frame.size.width-130, 44)];
    lbl_ordernum2.text = @"";
    lbl_ordernum2.textColor = [UIColor blackColor];
    [whiteVIew addSubview:lbl_ordernum2];
    UIImageView *imageLine3 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 43.75, self.view.frame.size.width-10, 0.5)];
    imageLine3.backgroundColor = LINE_COLOR;
    [whiteVIew addSubview:imageLine3];
    
    UILabel *lbl_shipCom = [[UILabel alloc]initWithFrame:CGRectMake(15, 44, self.view.frame.size.width-30, 44)];
    lbl_shipCom.text = @"订单号";
    lbl_shipCom.textColor = [UIColor blackColor];
    [whiteVIew addSubview:lbl_shipCom];
    lbl_shipCom2 = [[UILabel alloc]initWithFrame:CGRectMake(15+100, 44, self.view.frame.size.width-130, 44)];
    lbl_shipCom2.text = @"";
    [whiteVIew addSubview:lbl_shipCom2];
    UIImageView *imageLine4 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 43.75+44, self.view.frame.size.width-10, 0.5)];
    imageLine4.backgroundColor = LINE_COLOR;
    [whiteVIew addSubview:imageLine4];
    
    UILabel *lbl_ads = [[UILabel alloc]initWithFrame:CGRectMake(15, 88, self.view.frame.size.width-30, 44)];
    lbl_ads.text = @"商品佣金";
    lbl_ads.textColor = [UIColor blackColor];
    [whiteVIew addSubview:lbl_ads];
    lbl_ads2 = [[UILabel alloc]initWithFrame:CGRectMake(15+100, 88, self.view.frame.size.width-130, 44)];
    lbl_ads2.text = @"";
    [whiteVIew addSubview:lbl_ads2];
    UIImageView *imageLine5 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 43.75+44*2, self.view.frame.size.width-10, 0.5)];
    imageLine5.backgroundColor = LINE_COLOR;
    [whiteVIew addSubview:imageLine5];
    
    UILabel *lbl_num = [[UILabel alloc]initWithFrame:CGRectMake(15, 44*3, self.view.frame.size.width-30, 44)];
    lbl_num.text = @"商品总价";
    [whiteVIew addSubview:lbl_num];
    goodstotalPrice = [[UITextField alloc]initWithFrame:CGRectMake(100+15, 44*3+84, ScreenFrame.size.width - 140, 44)];
    goodstotalPrice.text = @"";
    goodstotalPrice.tag = 100;
    goodstotalPrice.delegate = self;
    goodstotalPrice.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view addSubview:goodstotalPrice];
    UIImageView *imageLine6 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 43.75+44*3, self.view.frame.size.width-10, 0.5)];
    imageLine6.backgroundColor = LINE_COLOR;
    [whiteVIew addSubview:imageLine6];
    UIImageView *imageLine7 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 43.75+44*4, self.view.frame.size.width-10, 0.5)];
    imageLine7.backgroundColor = LINE_COLOR;
    [whiteVIew addSubview:imageLine7];
    
    UIImageView *imageEdit = [[UIImageView alloc]initWithFrame:CGRectMake(lbl_num.frame.size.width-18, 15, 14, 14)];
    imageEdit.image = [UIImage imageNamed:@"edit"];
    [lbl_num addSubview:imageEdit];
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 30)];
    [topView setBarStyle:UIBarStyleBlack];
    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
    [topView setItems:buttonsArray];
    [goodstotalPrice setInputAccessoryView:topView];
    
    UILabel *lbl_DJ = [[UILabel alloc]initWithFrame:CGRectMake(15, 44*4, self.view.frame.size.width-30, 44)];
    lbl_DJ.text = @"配送金额";
    [whiteVIew addSubview:lbl_DJ];
    shipPrice = [[UITextField alloc]initWithFrame:CGRectMake(100+15, 44*4+84, ScreenFrame.size.width - 140, 44)];
    shipPrice.text = @"0.00";
    shipPrice.delegate = self;
    shipPrice.tag = 101;
    shipPrice.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view addSubview:shipPrice];
    UIImageView *imageEdit2 = [[UIImageView alloc]initWithFrame:CGRectMake(lbl_DJ.frame.size.width-18, 15, 14, 14)];
    imageEdit2.image = [UIImage imageNamed:@"edit"];
    [lbl_DJ addSubview:imageEdit2];
    UILabel *lbl_DD = [[UILabel alloc]initWithFrame:CGRectMake(15, 44*5, self.view.frame.size.width-30, 44)];
    lbl_DD.text = @"订单金额";
    [whiteVIew addSubview:lbl_DD];
    lbl_DDPrice = [[UILabel alloc]initWithFrame:CGRectMake(15+100, 44*5, self.view.frame.size.width-130, 44)];
    lbl_DDPrice.textColor = [UIColor redColor];
    lbl_DDPrice.text = @"";
    [whiteVIew addSubview:lbl_DDPrice];
    UIToolbar * topView1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 30)];
    [topView1 setBarStyle:UIBarStyleBlack];
    UIBarButtonItem * helloButton1 = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
    UIBarButtonItem * btnSpace1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton1 = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray1 = [NSArray arrayWithObjects:helloButton1,btnSpace1,doneButton1,nil];
    [topView1 setItems:buttonsArray1];
    [shipPrice setInputAccessoryView:topView1];
    
    OrderlistViewController *order = [OrderlistViewController sharedUserDefault];
    
    NSArray *fileContent2 = USER_INFORMATION;
    NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_id=%@",SELLER_URL,MODIFYPRICE_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],order.order_id];
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
                goodstotalPrice.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"goods_amount"]];
                shipPrice.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"ship_price"]];
                lbl_ordernum2.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"user_name"]];
                lbl_shipCom2.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"order_id"]];
                lbl_ads2.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"commission_amount"]];
                lbl_DDPrice.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"totalPrice"]];
            }
        }
    } failure:^(){
        [self fail];
    } ];
    
    loadingV=[LJControl loadingView:CGRectMake((self.view.frame.size.width-100)/2, (self.view.frame.size.height-59-100)/2, 100, 100)];
    [self.view addSubview:loadingV];
    
    label_prompt =[LJControl labelFrame:CGRectMake(50, self.view.frame.size.height-100, self.view.frame.size.width-100, 30) setText:@"" setTitleFont:17 setbackgroundColor:[UIColor blackColor] setTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    [label_prompt.layer setMasksToBounds:YES];
    [label_prompt.layer setCornerRadius:4.0];
    label_prompt.alpha = 0.8;
    label_prompt.hidden = YES;
    [self.view addSubview:label_prompt];
}
-(void)fail{
    [MyObject failedPrompt:@"未能连接到服务器"];
}
-(void)failedPrompt:(NSString *)prompt{
    loadingV.hidden = YES;
    label_prompt.hidden = NO;
    label_prompt.text = prompt;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
}
-(void)textFieldDidChange:(NSNotification *)notif{
    lbl_DDPrice.text = [NSString stringWithFormat:@"%0.2f",goodstotalPrice.text.floatValue + shipPrice.text.floatValue];
}
-(void)doTimer_disappear{
    label_prompt.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doTimer_signout{
    label_prompt.hidden = YES;
    [LJControl cleanAll];
    AppDelegate *app = [AppDelegate sharedUserDefault];
    app.log_View.hidden = NO;
}
-(void)clearCacheSuccessOut{
    NSLog(@"成功");
}
-(void)doTimer{
    label_prompt.hidden = YES;
}
-(BOOL)isValidPrice {
    float total = goodstotalPrice.text.floatValue;
    float commission = lbl_ads2.text.floatValue;
    if (total < commission) {
        return NO;
    }
    return YES;
}
-(void)btnClicked:(UIButton *)btn{
    if (btn.tag == 100) {
//        if (goodstotalPrice.text.length == 0 || shipPrice.text.length == 0 || goodstotalPrice.text.floatValue == 0.0 ||shipPrice.text.floatValue == 0.0) {
        if (goodstotalPrice.text.length == 0 || shipPrice.text.length == 0 || goodstotalPrice.text.length == 0 ||shipPrice.text.length == 0) {
            [MyObject failedPrompt:@"金额不能为空"];
        }else if (![self isValidPrice]){
            [MyObject failedPrompt:@"总价不得少于佣金"];
        }else{
            OrderlistViewController *order = [OrderlistViewController sharedUserDefault];
            
            NSArray *fileContent2 = USER_INFORMATION;
            NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_id=%@&totalPrice=%@&ship_price=%@&goods_amount=%@",SELLER_URL,MODIFYPRICE_SAVE_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],order.order_id,lbl_DDPrice.text,shipPrice.text,goodstotalPrice.text];
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
                            [MyObject failedPrompt:@"已成功修改价格"];
                            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_disappear) userInfo:nil repeats:NO];
                        }else{
                            [MyObject failedPrompt:@"修改失败,请重试"];
                        }
                        
                        
                    }
                    
                }
            } failure:^(){
                [self fail];
            } ];
        }
    }
}
-(void)dismissKeyBoard{
    [shipPrice resignFirstResponder];
    [goodstotalPrice resignFirstResponder];
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}
#pragma mark -textView delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGFloat keyboardHeight = 260.0f;
    if (self.view.frame.size.height - keyboardHeight <= textField.frame.origin.y + textField.frame.size.height) {
        CGFloat y = textField.frame.origin.y - (self.view.frame.size.height - keyboardHeight - textField.frame.size.height-50);
        [UIView beginAnimations:@"srcollView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.275f];
        self.view.frame = CGRectMake(self.view.frame.origin.x, -y, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [shipPrice resignFirstResponder];
    [goodstotalPrice resignFirstResponder];
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [shipPrice resignFirstResponder];
    [goodstotalPrice resignFirstResponder];
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
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
