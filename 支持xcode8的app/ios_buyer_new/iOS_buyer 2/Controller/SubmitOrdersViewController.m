//
//  SubmitOrdersViewController.m
//  My_App
//
//  Created by apple on 15-1-7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SubmitOrdersViewController.h"
#import "BundlingViewController.h"
#import "ASIFormDataRequest.h"
#import "ThirdViewController.h"
#import "onlinePayTypeLifeViewController.h"
#import <AlipaySDK/AlipaySDK.h>

@interface SubmitOrdersViewController (){
    ASIFormDataRequest *request_1;
    ASIFormDataRequest *request_2;
    ASIFormDataRequest *request_3;
}

@end
static SubmitOrdersViewController *singleInstance = nil;
@implementation SubmitOrdersViewController
+(id)sharedUserDefault
{
    if(singleInstance==nil)
    {
        @synchronized(self)
        {
            if(singleInstance==nil)
            {
                singleInstance=[[[self class] alloc] init];
            }
        }
    }
    return singleInstance;
}

+ (id)allocWithZone:(NSZone *)zone;
{
    if(singleInstance==nil)
    {
        singleInstance=[super allocWithZone:zone];
    }
    return singleInstance;
}
-(id)copyWithZone:(NSZone *)zone
{
    return singleInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提交订单";
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0f green:242/255.0f blue:250/255.0f alpha:255/255.0f];
    
    UIImageView *imgBG = [[UIImageView alloc]initWithFrame:CGRectMake(10, 70, ScreenFrame.size.width - 20, 160)];
    imgBG.backgroundColor = [UIColor whiteColor];
    CALayer *lay2 = imgBG.layer;
    [lay2 setMasksToBounds:YES];
    [lay2 setCornerRadius:6.0f];
    imgBG.userInteractionEnabled = YES;
    [self.view addSubview:imgBG];
    
    
    
    self.imgLog = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 120, 80)];
    self.imgLog.backgroundColor = [UIColor lightGrayColor];
    [imgBG addSubview:self.imgLog];
    
    self.lblTitleName = [[UILabel alloc]initWithFrame:CGRectMake(135, 10, ScreenFrame.size.width - 160, 60)];
    
    self.lblTitleName.font = [UIFont systemFontOfSize:13];
    self.lblTitleName.numberOfLines = 0;
    [imgBG addSubview:self.lblTitleName];
    self.lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(135, 75, 80, 20)];
    self.lblPrice.textColor = MY_COLOR;
    self.lblPrice.font = [UIFont systemFontOfSize:13];
    [imgBG addSubview:self.lblPrice];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 90, 60, 40)];
    label.text = @"数量:";
    label.font = [UIFont systemFontOfSize:14];
    [imgBG addSubview:label];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 125, 60, 30)];
    label2.text = @"总计:";
    label2.font = [UIFont systemFontOfSize:14];
    [imgBG addSubview:label2];
    
    self.numOrderField = [[UITextField alloc]initWithFrame:CGRectMake(ScreenFrame.size.width - 110, 100, 50, 25)];
    self.numOrderField.text = @"1";
    self.numOrderField.layer.borderWidth = 1.0;
    self.numOrderField.layer.cornerRadius = 4.0;
    self.numOrderField.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.numOrderField.textAlignment = NSTextAlignmentCenter;
    self.numOrderField.font = [UIFont systemFontOfSize:12];
    self.numOrderField.keyboardType = UIKeyboardTypeNumberPad;
    [imgBG addSubview:self.numOrderField];
    
    WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"取消" leftTarget:self leftAction:@selector(dismissKeyBoard1) rightTitle:@"完成" rightTarget:self rightAction:@selector(dismissKeyBoard)];
    [self.numOrderField setInputAccessoryView:inputView];

    self.btnMinus = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnMinus.frame = CGRectMake(ScreenFrame.size.width - 140, 100, 25, 25);
    self.btnMinus.tag = 101;
    [self.btnMinus setImage:[UIImage imageNamed:@"shjjian2"] forState:UIControlStateNormal];
    [self.btnMinus addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [imgBG addSubview:self.btnMinus];
    self.btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnAdd.frame = CGRectMake(ScreenFrame.size.width - 55, 100, 25, 25);
    self.btnAdd.tag = 102;
    [self.btnAdd setImage:[UIImage imageNamed:@"shjjia2"] forState:UIControlStateNormal];
    [self.btnAdd addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [imgBG addSubview:self.btnAdd];
    
    self.lblTotal = [[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width - 110, 120, 80, 40)];
    self.lblTotal.textColor = [UIColor redColor];
    self.lblTotal.textAlignment = NSTextAlignmentRight;
    self.lblTotal.font = [UIFont systemFontOfSize:13];
    [imgBG addSubview:self.lblTotal];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 230, 180, 30)];
    label3.text = @"您绑定的手机号码";
    label3.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:label3];
    
    UIButton *btnBundling = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBundling.frame = CGRectMake(10, 260, ScreenFrame.size.width - 20, 30);
    btnBundling.backgroundColor = [UIColor whiteColor];
    btnBundling.tag = 103;
    CALayer *lay = btnBundling.layer;
    [lay setMasksToBounds:YES];
    [lay setCornerRadius:6.0f];
    [btnBundling addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBundling];
    self.lblPhoneNum = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 160, 30)];
    self.lblPhoneNum.font = [UIFont systemFontOfSize:14];
    [btnBundling addSubview:self.lblPhoneNum];
    UIImageView *imgNext = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width - 36, 11, 6, 12)];
    imgNext.image = [UIImage imageNamed:@"dis_indicator"];
    [btnBundling addSubview:imgNext];
    self.lblChange = [[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width - 120, 0, 80, 30)];
    self.lblChange.text = @"更改绑定手机";
    self.lblChange.textAlignment = NSTextAlignmentRight;
    self.lblChange.font = [UIFont systemFontOfSize:12];
    [btnBundling addSubview:self.lblChange];
    
    UIButton *btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSubmit.frame = CGRectMake(10, 310, ScreenFrame.size.width - 20, 30);
    btnSubmit.tag = 104;
    btnSubmit.backgroundColor = MY_COLOR;
    CALayer *lay3 = btnSubmit.layer;
    [lay3 setMasksToBounds:YES];
    [lay3 setCornerRadius:6.0f];
    [btnSubmit setTitle:@"提交订单" forState:UIControlStateNormal];
    btnSubmit.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnSubmit addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSubmit];
    
    UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backBtnClicked)];
    rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];
    
    [self createBackBtn];
    myBool = NO;
}
-(void)failedPrompt:(NSString *)prompt{
    [SYObject endLoading];
    [SYObject failedPrompt:prompt];
}

-(void)btnClicked:(UIButton *)btn{
    if (btn.tag == 101) {
        if ([self.numOrderField.text intValue] == 1) {
            
        }else{
            self.numOrderField.text = [NSString stringWithFormat:@"%d",[self.numOrderField.text intValue]-1];
            _lblTotal.text = [NSString stringWithFormat:@"￥%0.2f",[self.numOrderField.text intValue]*[self.lblPrice.text floatValue]];
        }
    }
    if (btn.tag == 102) {
        self.numOrderField.text = [NSString stringWithFormat:@"%d",[self.numOrderField.text intValue]+1];
        _lblTotal.text = [NSString stringWithFormat:@"￥%0.2f",[self.numOrderField.text intValue]*[self.lblPrice.text floatValue]];
    }
    if (btn.tag == 103) {
        BundlingViewController *blVC = [[BundlingViewController alloc]init];
        [self.navigationController pushViewController:blVC animated:YES];
    }
    if (btn.tag == 104) {
        
        if (code1.intValue == -100) {
            [self failedPrompt:@"请先绑定手机号!"];
        }
        else{
            [SYObject startLoading];
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL, GROUPORDERSAVE_URL]];
            request_1 = [ASIFormDataRequest requestWithURL:url];
            [request_1 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
            [request_1 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
//            [request_1 setPostValue:lgh.gg_id forKey:@"group_id"];
            [request_1 setPostValue:self.numOrderField.text forKey:@"order_count"];
            [request_1 setPostValue:@"wx_app" forKey:@"pay_method"];
            
            [request_1 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request_1.tag = 101;
            [request_1 setDelegate:self];
            [request_1 setDidFailSelector:@selector(urlRequestFailed:)];
            [request_1 setDidFinishSelector:@selector(urlRequestSucceeded:)];
            [request_1 startAsynchronous];
        }
    }
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"submit_dibBig-->>%@",dicBig);
        if (dicBig) {
            NSString *code = [dicBig objectForKey:@"code"];
            _order_id = [dicBig objectForKey:@"order_id"];
            _order_sn = [dicBig objectForKey:@"order_sn"];
            _total_price = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"total_price"]];
            if (code.intValue == -100) {
                [self failedPrompt:@"提交失败"];
            }
            if (code.intValue == 100) {
                ThirdViewController *third = [ThirdViewController sharedUserDefault];
                third.ding_order_id = [NSString stringWithFormat:@"%@",_order_id];
                third.ding_hao = [NSString stringWithFormat:@"%@",_order_sn];
                third.jie_order_goods_price = [NSString stringWithFormat:@"%@",_total_price];
                onlinePayTypeLifeViewController *online = [[onlinePayTypeLifeViewController alloc]init];
                [self.navigationController pushViewController:online animated:YES];
            }
        }
    }else{
        [self failedPrompt:@"请求出错，请重试"];
    }
    [SYObject endLoading];
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)dismissKeyBoard{
    [self.numOrderField resignFirstResponder];
    _lblTotal.text = [NSString stringWithFormat:@"￥%0.2f",[self.numOrderField.text intValue]*[self.lblPrice.text floatValue]];
}
-(void)dismissKeyBoard1{
    [self.numOrderField resignFirstResponder];
   
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request_3 clearDelegatesAndCancel];
    [request_2 clearDelegatesAndCancel];
    [request_1 clearDelegatesAndCancel];
}

#pragma mark - 用户信息调用
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    if (myBool == NO) {
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        myBool = YES;
    }
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL, HASPHONE_URL]];
    request_2 = [ASIFormDataRequest requestWithURL:url];
    [request_2 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request_2 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    [request_2 setPostValue:self.lblPhoneNum.text forKey:@"mobile"];
    
    [request_2 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_2.tag = 102;
    [request_2 setDelegate:self];
    [request_2 setDidFailSelector:@selector(my1_urlRequestFailed:)];
    [request_2 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
    [request_2 startAsynchronous];
    
//    LifeGroupHomeViewController *lgh = [LifeGroupHomeViewController sharedUserDefault];
    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL, LIFEGROUP_URL]];
    request_3 = [ASIFormDataRequest requestWithURL:url2];
    [request_3 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request_3 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
//    [request_3 setPostValue:lgh.gg_id forKey:@"id"];
    [request_3 setPostValue:@"life" forKey:@"type"];
    [request_3 setPostValue:@"0" forKey:@"beginCount"];
    [request_3 setPostValue:@"20" forKey:@"selectCount"];
   
    [request_3 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_3.tag = 103;
    [request_3 setDelegate:self];
    [request_3 setDidFailSelector:@selector(my2_urlRequestFailed:)];
    [request_3 setDidFinishSelector:@selector(my2_urlRequestSucceeded:)];
    [request_3 startAsynchronous];
    [super viewWillAppear:YES];
    
}
-(void)my2_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"grouplist_dibBig-->>%@",dicBig);
        if (dicBig) {
            [self.imgLog sd_setImageWithURL:[dicBig objectForKey:@"gg_img"] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
            self.lblTitleName.text = [NSString stringWithFormat:@"%@", [dicBig objectForKey:@"gg_name"]];
            self.lblPrice.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"gg_price"]];
            self.lblTotal.text = [NSString stringWithFormat:@"￥%0.2f",[[dicBig objectForKey:@"gg_price"]floatValue]];
            priceLabel = [dicBig objectForKey:@"gg_price"];
        }
    }
    
}
-(void)my2_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        [SYObject endLoading];
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"grouplist_dibBig-->>%@",dicBig);
        if (dicBig) {
            code1 = [dicBig objectForKey:@"code"];
            if (code1.intValue == -100) {
                self.lblPhoneNum.text = @"未绑定手机号";
                self.lblChange.text = @"去绑定";
            }
            if (code1.intValue == 100) {
                self.lblPhoneNum.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"mobile"]];
                self.lblChange.text = @"更改绑定手机";
            }
        }
    }
    
}
-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
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
