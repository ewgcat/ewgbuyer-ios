//
//  OrderCancelViewController.m
//  SellerApp
//
//  Created by apple on 15-4-1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "OrderCancelViewController.h"
#import "OrderlistViewController.h"
#import "AppDelegate.h"
#import "sqlService.h"
@interface OrderCancelViewController (){
    myselfParse *_myParse;
}

@end

@implementation OrderCancelViewController
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
-(void)btnClicked:(UIButton *)btn{
    if (btn.tag == 100) {
        loadingV.hidden = NO;
        
        OrderlistViewController *order = [OrderlistViewController sharedUserDefault];
        
        NSArray *fileContent2 = USER_INFORMATION;
        NSString *url;
        if (reasonTag == 0) {
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_id=%@&state_info=%@&other_state_info=%@",SELLER_URL,MODIFYPRICE_CANCELSAVE_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],order.order_id,@"买家要求取消",@""];
        }else if(reasonTag == 1){
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_id=%@&state_info=%@&other_state_info=%@",SELLER_URL,MODIFYPRICE_CANCELSAVE_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],order.order_id,@"商品缺货",@""];
        }else{
            url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&order_id=%@&state_info=%@&other_state_info=%@",SELLER_URL,MODIFYPRICE_CANCELSAVE_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],order.order_id,@"",otherTextView.text];
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
                        [MyObject failedPrompt:@"取消订单成功"];
                        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_disappear) userInfo:nil repeats:NO];
                    }else{
                        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
                        [MyObject failedPrompt:@"取消订单失败"];
                    }
                }
            }
        } failure:^(){
            [self fail];
        } ];
    }
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
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"取消订单";
    self.view.backgroundColor = GRAY_COLOR;
    [self createBackBtn];
    reasonTag = 0;
    loadingV=[LJControl loadingView:CGRectMake((self.view.frame.size.width-100)/2, (self.view.frame.size.height-59-100)/2, 100, 100)];
    loadingV.hidden = YES;
    [self.view addSubview:loadingV];
    
    label_prompt =[LJControl labelFrame:CGRectMake(50, self.view.frame.size.height-100, self.view.frame.size.width-100, 30) setText:@"" setTitleFont:17 setbackgroundColor:[UIColor blackColor] setTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    [label_prompt.layer setMasksToBounds:YES];
    [label_prompt.layer setCornerRadius:4.0];
    label_prompt.alpha = 0.8;
    label_prompt.hidden = YES;
    [self.view addSubview:label_prompt];
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 84, self.view.frame.size.width, 44*4)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [whiteView.layer setMasksToBounds:YES];
    [whiteView.layer setCornerRadius:4.0f];
    [self.view addSubview:whiteView];
    UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
    imageLine.backgroundColor = [UIColor lightGrayColor];
    [whiteView addSubview:imageLine];
    UIImageView *imageLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, whiteView.frame.size.height-0.5, self.view.frame.size.width, 0.5)];
    imageLine2.backgroundColor = [UIColor lightGrayColor];
    [whiteView addSubview:imageLine2];
    UIImageView *imageLine3 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 43.75, self.view.frame.size.width, 0.5)];
    imageLine3.backgroundColor = [UIColor lightGrayColor];
    [whiteView addSubview:imageLine3];
    UILabel *labelnum2=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, whiteView.frame.size.width-30, 44)];
    labelnum2.text=@"订单号";
    [whiteView addSubview:labelnum2];
    UILabel *labelnum=[[UILabel alloc]initWithFrame:CGRectMake(105, 0, whiteView.frame.size.width-130, 44)];
    OrderlistViewController *ooo = [OrderlistViewController sharedUserDefault];
    labelnum.text=ooo.order_num;
    [whiteView addSubview:labelnum];
    UILabel *labelreason=[[UILabel alloc]initWithFrame:CGRectMake(15, 44, whiteView.frame.size.width-130, 44)];
    labelreason.text=@"取消原因";
    [whiteView addSubview:labelreason];
    UILabel *labelreason1=[[UILabel alloc]initWithFrame:CGRectMake(120, 44, whiteView.frame.size.width, 44)];
    labelreason1.text=@"  买家要求取消";
    [whiteView addSubview:labelreason1];
    imgeReason = [[UIImageView alloc]initWithFrame:CGRectMake(105, 44+12, 20, 20)];
    imgeReason.image = [UIImage imageNamed:@"circleon"];
    [whiteView addSubview:imgeReason];
    imgeReason2 = [[UIImageView alloc]initWithFrame:CGRectMake(105, 44+12+44, 20, 20)];
    imgeReason2.image = [UIImage imageNamed:@"circle"];
    [whiteView addSubview:imgeReason2];
    imgeReason3 = [[UIImageView alloc]initWithFrame:CGRectMake(105, 44*3+12, 20, 20)];
    imgeReason3.image = [UIImage imageNamed:@"circle"];
    [whiteView addSubview:imgeReason3];
    UILabel *labelreason2=[[UILabel alloc]initWithFrame:CGRectMake(120, 88, whiteView.frame.size.width, 44)];
    labelreason2.text=@"  商品缺货";
    [whiteView addSubview:labelreason2];
    UILabel *labelreason3=[[UILabel alloc]initWithFrame:CGRectMake(120, 44*3, whiteView.frame.size.width, 44)];
    labelreason3.text=@"  其他原因";
    [whiteView addSubview:labelreason3];
    
    UIButton *reason_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    reason_btn.frame = CGRectMake(105, 44*2, whiteView.frame.size.width-105, 44);
    reason_btn.tag = 101;
    [reason_btn addTarget:self action:@selector(reasonbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:reason_btn];
    UIButton *reason_btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    reason_btn2.frame = CGRectMake(105, 44, whiteView.frame.size.width-105, 44);
    reason_btn2.tag = 100;
    [reason_btn2 addTarget:self action:@selector(reasonbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:reason_btn2];
    UIButton *reason_btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    reason_btn3.frame = CGRectMake(105, 44*3, whiteView.frame.size.width-105, 44);
    reason_btn3.tag = 102;
    [reason_btn3 addTarget:self action:@selector(reasonbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:reason_btn3];
    
    
    otherView = [[UIView alloc]initWithFrame:CGRectMake(0, whiteView.frame.size.height+whiteView.frame.origin.y-1, self.view.frame.size.width, 60)];
    otherView.backgroundColor = [UIColor whiteColor];
    otherView.hidden = YES;
    [self.view addSubview:otherView];
    UIImageView *otherimageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 59.5, self.view.frame.size.width, 0.5)];
    otherimageLine.backgroundColor = [UIColor lightGrayColor];
    [otherView addSubview:otherimageLine];
    otherTextView = [[UITextView alloc]initWithFrame:CGRectMake(105, 5, ScreenFrame.size.width - 120, 44)];
    otherTextView.delegate = self;
    otherTextView.text = @"输入其他原因";
    otherTextView.textColor = [UIColor lightGrayColor];
    otherTextView.backgroundColor = [UIColor clearColor];
    otherTextView.tag = 100;
    otherTextView.font = [UIFont systemFontOfSize:17];
    [otherView addSubview:otherTextView];
    otherTextView.layer.borderWidth = 1;
    otherTextView.layer.borderColor = [LINE_COLOR CGColor];
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 30)];
    [topView setBarStyle:UIBarStyleBlack];
    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
    [topView setItems:buttonsArray];
    [otherTextView setInputAccessoryView:topView];
    
    
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
-(void)dismissKeyBoard{
    [otherTextView resignFirstResponder];
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [otherTextView resignFirstResponder];
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}
#pragma mark -textView delegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    CGFloat keyboardHeight = 260.0f;
    if (self.view.frame.size.height - keyboardHeight <= textView.frame.origin.y + textView.frame.size.height+44*4+89) {
        CGFloat y = textView.frame.origin.y - (self.view.frame.size.height - keyboardHeight - textView.frame.size.height-(44*4+89+20));
        [UIView beginAnimations:@"srcollView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.275f];
        self.view.frame = CGRectMake(self.view.frame.origin.x, -y, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    if ([textView.text isEqualToString:@"输入其他原因"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }else {
        
    }
    return YES;
}

-(void)reasonbtnClicked:(UIButton *)btn{
    if (btn.tag == 100) {
        reasonTag = 0;
        imgeReason.image = [UIImage imageNamed:@"circleon"];
        imgeReason2.image = [UIImage imageNamed:@"circle"];
        imgeReason3.image = [UIImage imageNamed:@"circle"];
        otherView.hidden = YES;
    }
    if (btn.tag == 101) {
        reasonTag = 1;
        imgeReason.image = [UIImage imageNamed:@"circle"];
        imgeReason2.image = [UIImage imageNamed:@"circleon"];
        imgeReason3.image = [UIImage imageNamed:@"circle"];
        otherView.hidden = YES;
    }
    if (btn.tag == 102) {
        reasonTag = 2;
        imgeReason.image = [UIImage imageNamed:@"circle"];
        imgeReason2.image = [UIImage imageNamed:@"circle"];
        imgeReason3.image = [UIImage imageNamed:@"circleon"];
        otherView.hidden = NO;
        
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
