//
//  delayViewController.m
//  SellerApp
//
//  Created by apple on 15-3-30.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "delayViewController.h"
#import "OrderlistViewController.h"
#import "AppDelegate.h"
#import "sqlService.h"

@interface delayViewController (){
    myselfParse *_myParse;
    OrderlistViewController *order;
}

@end

@implementation delayViewController
-(void)createBackBtn{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
    button.frame =CGRectMake(0, 0, 44, 44);
    [button setBackgroundImage:[UIImage imageNamed:@"back_lj"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
    
    UIButton *cancel_upbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel_upbtn.frame = CGRectMake(0,0, 50, 44);
    [cancel_upbtn setTitle:@"提交" forState:UIControlStateNormal];
    cancel_upbtn.tag = 100;
    cancel_upbtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [cancel_upbtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar2 = [[UIBarButtonItem alloc]initWithCustomView:cancel_upbtn];
    self.navigationItem.rightBarButtonItem =bar2;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    lbl_ordernum2.text = order.order_num;
    NSLog(@"lbl_ordernum2.text:%@",order.order_num);
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"延长收货时间";
    self.view.backgroundColor = GRAY_COLOR;
    UIView *whiteVIew = [[UIView alloc]initWithFrame:CGRectMake(0, 84, self.view.frame.size.width, 44*2)];
    whiteVIew.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteVIew];
    UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
    imageLine.backgroundColor = [UIColor lightGrayColor];
    [whiteVIew addSubview:imageLine];
    UIImageView *imageLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, whiteVIew.frame.size.height-0.5, self.view.frame.size.width, 0.5)];
    imageLine2.backgroundColor = [UIColor lightGrayColor];
    [whiteVIew addSubview:imageLine2];
    
    [self createBackBtn];
    UILabel *lbl_ordernum = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-30, 44)];
    lbl_ordernum.text = @"订单号";
    lbl_ordernum.textColor = [UIColor blackColor];
    lbl_ordernum.font = [UIFont systemFontOfSize:17];
    [whiteVIew addSubview:lbl_ordernum];
    lbl_ordernum2 = [[UILabel alloc]initWithFrame:CGRectMake(15+100, 0, self.view.frame.size.width-130, 44)];
    lbl_ordernum2.textColor = [UIColor blackColor];
    lbl_ordernum2.font = [UIFont systemFontOfSize:17];
    [whiteVIew addSubview:lbl_ordernum2];
    
    order = [OrderlistViewController sharedUserDefault];
    lbl_ordernum2.text = order.order_num;
    NSLog(@"lbl_ordernum2.text:%@",order.order_num);
    
    UIImageView *line3 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 43.75, self.view.frame.size.width-15, 0.5)];
    line3.backgroundColor = LINE_COLOR;
    [whiteVIew addSubview:line3];
    
    UILabel *lbl_ship = [[UILabel alloc]initWithFrame:CGRectMake(15, 44, self.view.frame.size.width-30, 44)];
    lbl_ship.text = @"延长时间";
    lbl_ship.textColor = [UIColor blackColor];
    lbl_ship.font = [UIFont systemFontOfSize:17];
    [whiteVIew addSubview:lbl_ship];
    UILabel *lbl_day = [[UILabel alloc]initWithFrame:CGRectMake(lbl_ship.frame.size.width-41, 44, 20, 44)];
    lbl_day.text = @"天";
    lbl_day.textColor = [UIColor blackColor];
    lbl_day.font = [UIFont boldSystemFontOfSize:17];
    [whiteVIew addSubview:lbl_day];
    delayTime = [[UITextField alloc]initWithFrame:CGRectMake(100+15, 44, ScreenFrame.size.width - 150, 44)];
    delayTime.text = @"3";
    delayTime.font = [UIFont systemFontOfSize:17];
    delayTime.delegate = self;
    delayTime.keyboardType = UIKeyboardTypeNumberPad;
    [whiteVIew addSubview:delayTime];
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
    [delayTime setInputAccessoryView:topView1];
    
    loadingV=[LJControl loadingView:CGRectMake((self.view.frame.size.width-100)/2, (self.view.frame.size.height-59-100)/2, 100, 100)];
    loadingV.hidden = YES;
    [self.view addSubview:loadingV];
    
    label_prompt =[LJControl labelFrame:CGRectMake(50, self.view.frame.size.height-100, self.view.frame.size.width-100, 30) setText:@"" setTitleFont:17 setbackgroundColor:[UIColor blackColor] setTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    [label_prompt.layer setMasksToBounds:YES];
    [label_prompt.layer setCornerRadius:4.0];
    label_prompt.alpha = 0.8;
    label_prompt.hidden = YES;
    [self.view addSubview:label_prompt];
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
-(void)failedPrompt:(NSString *)prompt{
    loadingV.hidden = YES;
    label_prompt.hidden = NO;
    label_prompt.text = prompt;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
}
-(void)btnClicked:(UIButton *)btn{
    if (btn.tag == 100) {
        if (delayTime.text.length == 0) {
            [MyObject failedPrompt:@"延长时间不能为空"];
        }else if([delayTime.text intValue]<=0){
            [MyObject failedPrompt:@"延长时间大于零"];
        }else{
            loadingV.hidden = NO;
            
            NSArray *fileContent2 = USER_INFORMATION;
            NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_id=%@&delay_time=%@",SELLER_URL,DELAYTIMES_SAVE_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],order.order_id,delayTime.text];
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
                            [MyObject failedPrompt:@"已成功延长收货时间"];
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
-(void)fail{
    [MyObject failedPrompt:@"未能连接到服务器"];
}
-(void)dismissKeyBoard{
    [delayTime resignFirstResponder];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [delayTime resignFirstResponder];
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
