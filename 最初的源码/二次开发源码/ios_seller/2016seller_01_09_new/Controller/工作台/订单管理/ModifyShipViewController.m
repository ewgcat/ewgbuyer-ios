//
//  ModifyShipViewController.m
//  SellerApp
//
//  Created by apple on 15-3-30.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ModifyShipViewController.h"
#import "OrderlistViewController.h"
#import "AppDelegate.h"
#import "sqlService.h"
@interface ModifyShipViewController (){
    myselfParse *_myParse;
}

@end

@implementation ModifyShipViewController
-(void)createBackBtn{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
    button.frame =CGRectMake(0, 0, 44, 44);
    [button setBackgroundImage:[UIImage imageNamed:@"back_lj"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
    
    UIButton *cancel_upbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel_upbtn.frame = CGRectMake(0, 0, 50, 44);
    [cancel_upbtn setTitle:@"提交" forState:UIControlStateNormal];
    cancel_upbtn.tag = 100;
    cancel_upbtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [cancel_upbtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar2 = [[UIBarButtonItem alloc]initWithCustomView:cancel_upbtn];
    self.navigationItem.rightBarButtonItem =bar2;
}

-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改物流";
    self.view.backgroundColor = GRAY_COLOR;
    [self createBackBtn];
    UIView *whiteVIew = [[UIView alloc]initWithFrame:CGRectMake(0, 84, self.view.frame.size.width, 44*3+3)];
    whiteVIew.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteVIew];
    UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
    imageLine.backgroundColor = [UIColor lightGrayColor];
    [whiteVIew addSubview:imageLine];
    UIImageView *imageLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, whiteVIew.frame.size.height-0.5, self.view.frame.size.width, 0.5)];
    imageLine2.backgroundColor = [UIColor lightGrayColor];
    [whiteVIew addSubview:imageLine2];
    
    //订单号
    UILabel *lbl_ordernum = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-30, 44)];
    lbl_ordernum.text = @"订单号";
    lbl_ordernum.textColor = [UIColor blackColor];
    lbl_ordernum.font = [UIFont fontWithName:@"" size:17];//Arial-BoldItalicMT
    [lbl_ordernum.layer setMasksToBounds:YES];
    [lbl_ordernum.layer setCornerRadius:4.0f];
    [whiteVIew addSubview:lbl_ordernum];
    lbl_ordernum2 = [[UILabel alloc]initWithFrame:CGRectMake(15+100, 0, self.view.frame.size.width-130, 44)];
    lbl_ordernum2.text = @"";
    lbl_ordernum2.textColor = [UIColor blackColor];
    lbl_ordernum2.font = [UIFont systemFontOfSize:17];
    [lbl_ordernum2.layer setMasksToBounds:YES];
    [lbl_ordernum2.layer setCornerRadius:4.0f];
    [whiteVIew addSubview:lbl_ordernum2];
    UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 43.75, self.view.frame.size.width-15, 0.5)];
    line2.backgroundColor = LINE_COLOR;
    [whiteVIew addSubview:line2];
    
    //物流单号
    UILabel *lbl_ship = [[UILabel alloc]initWithFrame:CGRectMake(15, 44, self.view.frame.size.width-30, 44)];
    lbl_ship.text = @"物流单号";
    lbl_ship.textColor = [UIColor blackColor];
    lbl_ship.font = [UIFont systemFontOfSize:17];
    [lbl_ship.layer setMasksToBounds:YES];
    [lbl_ship.layer setCornerRadius:4.0f];
    [whiteVIew addSubview:lbl_ship];
    shipnum = [[UITextField alloc]initWithFrame:CGRectMake(100+15, 44, ScreenFrame.size.width - 140, 44)];
    shipnum.text = @"";
    shipnum.textColor = [UIColor blackColor];
    shipnum.font = [UIFont systemFontOfSize:17];
    shipnum.delegate = self;
    shipnum.keyboardType = UIKeyboardTypeNumberPad;
    [whiteVIew addSubview:shipnum];
    UIImageView *imageEdit2 = [[UIImageView alloc]initWithFrame:CGRectMake(lbl_ship.frame.size.width-18, 15, 14, 14)];
    imageEdit2.image = [UIImage imageNamed:@"edit"];
    [lbl_ship addSubview:imageEdit2];
    UIToolbar * topView1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 30)];
    [topView1 setBarStyle:UIBarStyleBlack];
    UIBarButtonItem * helloButton1 = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
    UIBarButtonItem * btnSpace1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton1 = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray1 = [NSArray arrayWithObjects:helloButton1,btnSpace1,doneButton1,nil];
    [topView1 setItems:buttonsArray1];
    [shipnum setInputAccessoryView:topView1];
    UIImageView *line3 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 43.75+44, self.view.frame.size.width-15, 0.5)];
    line3.backgroundColor = LINE_COLOR;
    [whiteVIew addSubview:line3];
    
    //操作说明
    UILabel *lbl_action = [[UILabel alloc]initWithFrame:CGRectMake(15, 88, self.view.frame.size.width-30, 46)];
    lbl_action.text = @"操作说明";
    lbl_action.textColor = [UIColor blackColor];
    lbl_action.font = [UIFont systemFontOfSize:17];
    [lbl_action.layer setMasksToBounds:YES];
    [lbl_action.layer setCornerRadius:4.0f];
    [whiteVIew addSubview:lbl_action];
    textview_directions = [[UITextView alloc]initWithFrame:CGRectMake(110, 91+20+64, ScreenFrame.size.width - 150, 41)];
    textview_directions.font = [UIFont systemFontOfSize:17];
    textview_directions.delegate = self;
    textview_directions.text = @"请输入操作说明";
    textview_directions.textColor = [UIColor grayColor];
    textview_directions.backgroundColor = [UIColor clearColor];
    [self.view addSubview:textview_directions];
    UIImageView *imageEdit = [[UIImageView alloc]initWithFrame:CGRectMake(textview_directions.frame.size.width+textview_directions.frame.origin.x-10, 16, 14, 14)];
    imageEdit.image = [UIImage imageNamed:@"edit"];
    [lbl_action addSubview:imageEdit];
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 30)];
    [topView setBarStyle:UIBarStyleBlack];
    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
    [topView setItems:buttonsArray];
    [textview_directions setInputAccessoryView:topView];
    
    OrderlistViewController *order = [OrderlistViewController sharedUserDefault];
    
    NSArray *fileContent2 = USER_INFORMATION;
    NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_id=%@",SELLER_URL,LOGISTICS_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],order.order_id];
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
                NSString *shipCode =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"shipCode"]];
                if (shipCode) {
                    shipnum.text = [shipCode stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                }else {
                    shipnum.text = @"";
                }
                lbl_ordernum2.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"order_id"]];
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
-(void)btnClicked:(UIButton *)btn{
    if (btn.tag == 100) {
        if (shipnum.text.length ==0) {
            [MyObject failedPrompt:@"物流单号不能为空"];
        }else{
            OrderlistViewController *order = [OrderlistViewController sharedUserDefault];
            
            NSArray *fileContent2 = USER_INFORMATION;
            NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_id=%@&shipCode=%@&state_info=%@",SELLER_URL,LOGISTICS_SAVE_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],order.order_id,shipnum.text,textview_directions.text];
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
                            [MyObject failedPrompt:@"已成功修改物流"];
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
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textview_directions.text isEqualToString:@"请输入操作说明"]) {
        textview_directions.text = @"";
        textview_directions.textColor = [UIColor blackColor];
    }else{
        
    }
    CGFloat keyboardHeight = 290.0f;
    if (self.view.frame.size.height - keyboardHeight <= textView.frame.origin.y + textView.frame.size.height) {
        CGFloat y = textView.frame.origin.y - (self.view.frame.size.height - keyboardHeight - textView.frame.size.height-50);
        [UIView beginAnimations:@"srcollView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.275f];
        self.view.frame = CGRectMake(self.view.frame.origin.x, -y, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textview_directions.text.length == 0) {
        textview_directions.text = @"请输入操作说明";
        textview_directions.textColor = [UIColor grayColor];
    }else{
        
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [shipnum resignFirstResponder];
    [textview_directions resignFirstResponder];
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [shipnum resignFirstResponder];
    return YES;
}
-(void)dismissKeyBoard{
    [shipnum resignFirstResponder];
    [textview_directions resignFirstResponder];
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
