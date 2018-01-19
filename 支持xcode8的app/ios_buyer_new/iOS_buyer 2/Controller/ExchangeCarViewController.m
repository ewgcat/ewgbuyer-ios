//
//  ExchangeCarViewController.m
//  My_App
//
//  Created by apple on 15-1-16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ExchangeCarViewController.h"
#import "ExchangeHomeViewController.h"
#import "Model.h"
#import "ExchangeListViewController.h"

@interface ExchangeCarViewController (){
    ASIFormDataRequest *request_1;
    ASIFormDataRequest *request_2;
    ASIFormDataRequest *request_3;
    ASIFormDataRequest *request_4;
    ASIFormDataRequest *request_5;
    ASIFormDataRequest *request_6;
    ASIFormDataRequest *request_7;
    ASIFormDataRequest *request_8;
    ASIFormDataRequest *request_9;
    ASIFormDataRequest *request_10;
    ASIFormDataRequest *request_11;
    ASIFormDataRequest *request_12;
    UIImageView *imgItem;
}

@end

static ExchangeCarViewController *singleInstance=nil;

@implementation ExchangeCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"积分购物车";
    [self createBackBtn];
    self.view.backgroundColor =UIColorFromRGB(0Xf2f2f2); //[UIColor whiteColor];
    dataArr = [[NSMutableArray alloc]init];
#pragma mark -底部的视图
    imgItem = [[UIImageView alloc]initWithFrame:CGRectMake(0, ScreenFrame.size.height-64-104, ScreenFrame.size.width, 104)];
    imgItem.backgroundColor = [UIColor whiteColor];//SHJ_COLOR;
    imgItem.userInteractionEnabled = YES;
    [self.view addSubview:imgItem];
    
    UILabel *lblAllSelect = [[UILabel alloc]initWithFrame:CGRectMake(45, 22+20, 40, 20)];
    lblAllSelect.text = @"全选";
    lblAllSelect.textColor = [UIColor grayColor];
    lblAllSelect.font = [UIFont systemFontOfSize:12];
    [imgItem addSubview:lblAllSelect];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 70, 20)];
    label.text = @"积分总计:";
    label.font = [UIFont systemFontOfSize:14];
    [imgItem addSubview:label];
//    积分的数字
    self.lblIntegralTotal = [[UILabel alloc]initWithFrame:CGRectMake(145, 10, 50, 20)];
    self.lblIntegralTotal.text = [NSString stringWithFormat:@"%ld",(long)all_integral];
    self.lblIntegralTotal.textColor = MY_COLOR;
    self.lblIntegralTotal.font = [UIFont boldSystemFontOfSize:14];
    [imgItem addSubview:self.lblIntegralTotal];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(80, 30, 60, 20)];
    label2.text = @"总运费:";
    label2.font = [UIFont systemFontOfSize:14];
    [imgItem addSubview:label2];
    
//    商品金额
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 50, 70, 20)];
    moneyLabel.text = @"商品金额:";
    moneyLabel.font = [UIFont systemFontOfSize:14];
    [imgItem addSubview:moneyLabel];
    
    
    self.moneyCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, 50, 50, 20)];
    self.moneyCountLabel.text = [NSString stringWithFormat:@"%ld",(long)goods_total_price];
    self.moneyCountLabel.textColor = MY_COLOR;
    self.moneyCountLabel.font = [UIFont boldSystemFontOfSize:14];
    [imgItem addSubview:self.moneyCountLabel];
    

    
    
//    订单总金额
    UILabel *allMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 70, 80, 20)];
    allMoneyLabel.text = @"订单总金额:";
    allMoneyLabel.font = [UIFont systemFontOfSize:14];
    [imgItem addSubview:allMoneyLabel];
    
    
    
    self.allMoneyCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 70, 50, 20)];
    self.allMoneyCountLabel.text = [NSString stringWithFormat:@"%ld",(long)goods_total_price];
    self.allMoneyCountLabel.textColor = MY_COLOR;
    self.allMoneyCountLabel.font = [UIFont boldSystemFontOfSize:14];
    [imgItem addSubview:self.allMoneyCountLabel];
    
    
    
    
    //运费金额
    self.lblAllShipfee = [[UILabel alloc]initWithFrame:CGRectMake(135, 30, 60, 20)];
    self.lblAllShipfee.text = [NSString stringWithFormat:@"￥%ld",(long)all_shipfee];
    self.lblAllShipfee.textColor = MY_COLOR;
    self.lblAllShipfee.font = [UIFont boldSystemFontOfSize:14];
    [imgItem addSubview:self.lblAllShipfee];
    //全选按钮
    btnAllSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAllSelect.frame = CGRectMake(0, 10+20, 40, 40);
    btnAllSelect.tag = 101;
    [btnAllSelect setImage:[UIImage imageNamed:@"checkbox_no"] forState:UIControlStateNormal];
    [btnAllSelect addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [imgItem addSubview:btnAllSelect];
    
#pragma mark - 结算的按钮
    
    btnAccount = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnAccount.frame = CGRectMake(ScreenFrame.size.width - 100, 17, 80, 30);
    btnAccount.frame = CGRectMake(ScreenFrame.size.width-90,0,90,64+40);
    btnAccount.tag = 102;
//    CALayer *lay = btnAccount.layer;
//    [lay setMasksToBounds:YES];
//    [lay setCornerRadius:5.0f];
    _jieCount = @"0";
    [btnAccount setTitle:[NSString stringWithFormat:@"结算(%@)",_jieCount] forState:UIControlStateNormal];
    if ([_jieCount intValue]<=0) {
        btnAccount.enabled  = NO;
        btnAccount.backgroundColor = UIColorFromRGB(0Xdfdfdf);//[UIColor grayColor];
    }else{
        btnAccount.enabled = YES;
        btnAccount.backgroundColor = MY_COLOR;
    }
    [btnAccount addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [imgItem addSubview:btnAccount];
    [self createTableView];
}
-(void)upSuccess{
    _good_id = @"";
    [btnAllSelect setBackgroundImage:[UIImage imageNamed:@"checkbox_no"] forState:UIControlStateNormal];
    btnBool = NO;
    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,INTEGRALCARTCAL_URL]];
    request_1 = [ASIFormDataRequest requestWithURL:url2];
    [request_1 setPostValue:@"" forKey:@"cart_ids"];
    
    [request_1 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_1.tag = 102;
    request_1.delegate =self;
    [request_1 setDidFailSelector:@selector(urlRequestFailed:)];
    [request_1 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [request_1 startAsynchronous];
}
-(void)urlRequestSucceeded:(ASIHTTPRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig2 =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dibBig2-->>%@",dicBig2);
        if (dicBig2) {
            self.lblIntegralTotal.text = [NSString stringWithFormat:@"%@",[dicBig2 objectForKey:@"all_integral"]];
            self.lblAllShipfee.text = [NSString stringWithFormat:@"%@",[dicBig2 objectForKey:@"all_shipfee"]];
            
            self.moneyCountLabel.text = [NSString stringWithFormat:@"%@",[dicBig2 objectForKey:@"goods_total_price"]];
            
            self.allMoneyCountLabel.text = [NSString stringWithFormat:@"%@",[dicBig2 objectForKey:@"order_total_price"]];
            
            
            
            _jieCount =[NSString stringWithFormat:@"%@",[dicBig2 objectForKey:@"size"]];
            [btnAccount setTitle:[NSString stringWithFormat:@"结算(%@)",_jieCount] forState:UIControlStateNormal];
            if ([_jieCount intValue]<=0) {
                btnAccount.enabled = NO;
                btnAccount.backgroundColor = UIColorFromRGB(0Xdfdfdf);//[UIColor grayColor];
            }else{
                btnAccount.enabled = YES;
                btnAccount.backgroundColor = MY_COLOR;
            }
        }
    }
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


-(void)disappear{
    InputView.hidden = YES;
    for (UIView *subView in InputView.subviews)
    {
        [subView removeFromSuperview];
    }
}
-(void)btnClicked:(UIButton *)btn{
    
    if (btn.tag == 1000003) {
        if ([textFF.text intValue]==1) {
            CountInput.text = [NSString stringWithFormat:@"×%@",textFF.text];
        }else{
            textFF.text = [NSString stringWithFormat:@"%d",[textFF.text intValue]-1];
            CountInput.text = [NSString stringWithFormat:@"×%@",textFF.text];
        }
    }
    if (btn.tag == 1000004) {
        textFF.text = [NSString stringWithFormat:@"%d",[textFF.text intValue]+1];
        CountInput.text = [NSString stringWithFormat:@"×%@",textFF.text];
    }
    if (btn.tag == 1000001) {
       
        [textFF resignFirstResponder];
        InputView.hidden = YES;
        for (UIView *subView in InputView.subviews)
        {
            [subView removeFromSuperview];
        }
        shjTableView.userInteractionEnabled = YES;
    }
    if (btn.tag == 1000002) {
        if (textFF.text.length == 0) {
            [SYObject failedPrompt:@"数量不能为空"];
        }else if ([textFF.text intValue]==0){
            [SYObject failedPrompt:@"数量不能为0"];
        }else{
            InputView.hidden = YES;
            for (UIView *subView in InputView.subviews)
            {
                [subView removeFromSuperview];
            }
            //发起该数量的请求
            Model *sss = [dataArr objectAtIndex:fieldTag];
            
            NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&cart_id=%@&count=%@",FIRST_URL,INTEGRALCOUNTADJUST_URL,[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:3],[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:1],sss.igc_id,[NSString stringWithFormat:@"%@",textFF.text]]];
            request_2=[ASIFormDataRequest requestWithURL:url2];
            
            [request_2 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request_2.tag = 102;
            request_2.delegate =self;
            [request_2 setDidFailSelector:@selector(my1_urlRequestFailed:)];
            [request_2 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
            [request_2 startAsynchronous];
        }
    }
    
    if (btn.tag == 101) {
        [SYObject startLoading];
        if (btnBool==NO) {
            _good_id = @"";
            for(int i=0;i<dataArr.count;i++){
                Model *sss = [dataArr objectAtIndex:i];
                if(_good_id.length == 0){
                    _good_id = [NSString stringWithFormat:@"%@",sss.igc_id];
                }else{
                    _good_id = [NSString stringWithFormat:@"%@,%@",_good_id,sss.igc_id];
                }
            }
//            [btnAllSelect setBackgroundImage:[UIImage imageNamed:@"checkbox_yes"] forState:UIControlStateNormal];
            
            
            
            
            [btnAllSelect setImage:[UIImage imageNamed:@"checkbox_yes"] forState:UIControlStateNormal];
            btnBool = YES;
        }else{
//            [btnAllSelect setBackgroundImage:[UIImage imageNamed:@"checkbox_no"] forState:UIControlStateNormal];
            [btnAllSelect setImage:[UIImage imageNamed:@"checkbox_no"] forState:UIControlStateNormal];
            _good_id = @"";
            btnBool = NO;
        }
        
        NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?cart_ids=%@",FIRST_URL,INTEGRALCARTCAL_URL,_good_id]];
        request_3=[ASIFormDataRequest requestWithURL:url2];
        
        [request_3 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request_3.tag = 102;
        request_3.delegate =self;
        [request_3 setDidFailSelector:@selector(my22_urlRequestFailed:)];
        [request_3 setDidFinishSelector:@selector(my22_urlRequestSucceeded:)];
        [request_3 startAsynchronous];
        
        [shjTableView reloadData];
    }
    if (btn.tag == 102) {
#pragma mark - 结算
        ExchangeListViewController *exchangeListVC = [[ExchangeListViewController alloc]init];
        [self.navigationController pushViewController:exchangeListVC animated:YES];
    }
}
-(void)my22_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"result=11%@", dicBig);
        if (dicBig) {
            NSString *ret=[NSString stringWithFormat:@"%@",dicBig[@"code"]];

            if ([ret isEqualToString:@"-300"]) {
                
                NSLog(@"****==%@",dicBig[@"ig_name"]);
                NSString *string=dicBig[@"ig_name"];
                [OHAlertView showAlertWithTitle:string message:@"" dismissButton:@"确定"];
            }
            self.lblIntegralTotal.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"all_integral"]];
            self.lblAllShipfee.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"all_shipfee"]];
            
            
              self.moneyCountLabel.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"goods_total_price"]];
            
            self.allMoneyCountLabel.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"order_total_price"]];

        
            _jieCount =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"size"]];
            [btnAccount setTitle:[NSString stringWithFormat:@"结算(%@)",_jieCount] forState:UIControlStateNormal];
            if ([_jieCount intValue]<=0) {
                btnAccount.enabled = NO;
                btnAccount.backgroundColor = UIColorFromRGB(0Xdfdfdf);//[UIColor grayColor];
            }else{
                btnAccount.enabled = YES;
                btnAccount.backgroundColor = MY_COLOR;
            }
        }
        [SYObject endLoading];
    }
    else{
        [SYObject failedPrompt:@"请求出错"];
        [SYObject endLoading];
    }
}
-(void)my22_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"请求出错"];
     [SYObject endLoading];
}
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"result=22%@", dicBig);
        if (dicBig) {
            if ([[dicBig objectForKey:@"code"] intValue] == 100) {
                //发起刷新请求
                [self refreshe];
                NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?cart_ids=%@",FIRST_URL,INTEGRALCARTCAL_URL,_good_id]];
                request_4=[ASIFormDataRequest requestWithURL:url2];
                
                [request_4 setRequestHeaders:[LJControl requestHeaderDictionary]];
                request_4.tag = 102;
                request_4.delegate =self;
                [request_4 setDidFailSelector:@selector(my25_urlRequestFailed:)];
                [request_4 setDidFinishSelector:@selector(my25_urlRequestSucceeded:)];
                [request_4 startAsynchronous];
            }else if([[dicBig objectForKey:@"code"] intValue] == -100){
                [SYObject failedPrompt:@"库存不足"];
                
            }else if([[dicBig objectForKey:@"code"] intValue] == -200){
                [SYObject failedPrompt:@"无此商品"];
            }
        }
        [SYObject endLoading];
    }
    else{
        [SYObject failedPrompt:@"请求出错"];
         [SYObject endLoading];
    }
}
-(void)my25_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"result=33%@", dicBig);
        if (dicBig) {
            self.lblIntegralTotal.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"all_integral"]];
            self.lblAllShipfee.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"all_shipfee"]];
            
            
            self.moneyCountLabel.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"goods_total_price"]];
            
            self.allMoneyCountLabel.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"order_total_price"]];
            
            
            
            
            _jieCount =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"size"]];
            [btnAccount setTitle:[NSString stringWithFormat:@"结算(%@)",_jieCount] forState:UIControlStateNormal];
            if ([_jieCount intValue]<=0) {
                btnAccount.enabled = NO;
                btnAccount.backgroundColor = UIColorFromRGB(0Xdfdfdf);//[UIColor grayColor];
            }else{
                btnAccount.enabled = YES;
                btnAccount.backgroundColor = MY_COLOR;
            }
        }
        [SYObject endLoading];
        
    }
    else{
        [SYObject failedPrompt:@"请求出错"];
        [SYObject endLoading];
    }
}
-(void)my25_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"请求出错"];
    [SYObject endLoading];
}
-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
    [SYObject endLoading];
}
-(void)btnIsSelected:(UIButton *)btn{
    if (dataArr.count != 0) {
        Model *sss = [dataArr objectAtIndex:btn.tag-400];
        if (_good_id.length == 0) {
            _good_id = [NSString stringWithFormat:@"%@",sss.igc_id];
        }else{
            NSMutableArray *arr = (NSMutableArray *)[_good_id componentsSeparatedByString:@","];
            if (arr.count == 0) {
                
            }else if (arr.count == 1){
                BOOL myB = NO;
                for(int i=0;i<arr.count;i++){
                    if ([[arr objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%@",sss.igc_id]]) {
                        myB = YES;
                    }
                }
                if (myB == NO) {
                    _good_id = [NSString stringWithFormat:@"%@,%@",_good_id,sss.igc_id];
                }else{
                    _good_id = @"";
                }
            }else{
                BOOL myB = NO;
                for(int i=0;i<arr.count;i++){
                    if ([[arr objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%@",sss.igc_id]]) {
                        myB = YES;
                        [arr replaceObjectAtIndex:i withObject:@"null"];
                    }
                }
                if (myB == NO) {
                    _good_id = [NSString stringWithFormat:@"%@,%@",_good_id,sss.igc_id];
                }else{
                    _good_id = @"";
                    for(int i=0;i<arr.count;i++){
                        if (_good_id.length == 0) {
                            if ([[NSString stringWithFormat:@"%@",[arr objectAtIndex:i]] isEqualToString:@"null"]) {
                                
                            }else{
                                _good_id = [NSString stringWithFormat:@"%@",[arr objectAtIndex:i]];
                            }
                        }else{
                            if ([[NSString stringWithFormat:@"%@",[arr objectAtIndex:i]] isEqualToString:@"null"]) {
                                
                            }else{
                                _good_id = [NSString stringWithFormat:@"%@,%@",_good_id,[arr objectAtIndex:i]];
                            }
                        }
                    }
                }
            }
        }
        NSMutableArray *arrMM;
        if (_good_id.length==0) {
           arrMM = [NSMutableArray array];
        }else{
            arrMM = (NSMutableArray *)[_good_id componentsSeparatedByString:@","];
        }
//        NSMutableArray *arrMM = (NSMutableArray *)[_good_id componentsSeparatedByString:@","];
        if (arrMM.count == dataArr.count) {
            [btnAllSelect setBackgroundImage:[UIImage imageNamed:@"checkbox_yes"] forState:UIControlStateNormal];
            btnBool = YES;
        }else{
            [btnAllSelect setBackgroundImage:[UIImage imageNamed:@"checkbox_no"] forState:UIControlStateNormal];
            btnBool = NO;
        }
        [shjTableView reloadData];
        
        NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?cart_ids=%@",FIRST_URL,INTEGRALCARTCAL_URL,_good_id]];
        request_5=[ASIFormDataRequest requestWithURL:url2];
        
        [request_5 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request_5.tag = 102;
        request_5.delegate =self;
        [request_5 setDidFailSelector:@selector(my23_urlRequestFailed:)];
        [request_5 setDidFinishSelector:@selector(my23_urlRequestSucceeded:)];
        [request_5 startAsynchronous];
    }
}
-(void)my23_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"result10=%@", dicBig);
        if (dicBig) {
            NSString *ret=[NSString stringWithFormat:@"%@",dicBig[@"code"]];
            if ([ret isEqualToString:@"-300"]) {
                
                NSLog(@"****==%@",dicBig[@"ig_name"]);
                NSString *string=dicBig[@"ig_name"];
                [OHAlertView showAlertWithTitle:string message:@"" dismissButton:@"确定"];
            }
            self.lblIntegralTotal.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"all_integral"]];
            self.lblAllShipfee.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"all_shipfee"]];
            
            
            self.moneyCountLabel.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"goods_total_price"]];
            
            self.allMoneyCountLabel.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"order_total_price"]];
            
            _jieCount =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"size"]];
            [btnAccount setTitle:[NSString stringWithFormat:@"结算(%@)",_jieCount] forState:UIControlStateNormal];
            if ([_jieCount intValue]<=0) {
                btnAccount.enabled = NO;
                btnAccount.backgroundColor = UIColorFromRGB(0Xdfdfdf);//[UIColor grayColor];
            }else{
                btnAccount.enabled = YES;
                btnAccount.backgroundColor = MY_COLOR;
            }
        }
        [SYObject endLoading];
        
    }
    else{
        [SYObject failedPrompt:@"请求出错"];
        [SYObject endLoading];
    }
}
-(void)my23_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"请求出错"];
    [SYObject endLoading];
}
-(void)btnMinus:(UIButton *)btn{
    if (dataArr.count!=0) {
        Model *sss = [dataArr objectAtIndex:btn.tag-100];
        //INTEGRALCOUNTADJUST_URL
        if ([sss.igc_count intValue]<=1) {
            [SYObject failedPrompt:@"数量不能小于1"];
            [SYObject endLoading];
        }else{
            NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&cart_id=%@&count=%d",FIRST_URL,INTEGRALCOUNTADJUST_URL,[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:3],[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:1],sss.igc_id,[sss.igc_count intValue]-1]];
            request_6=[ASIFormDataRequest requestWithURL:url2];
            
            [request_6 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request_6.tag = 102;
            request_6.delegate =self;
            [request_6 setDidFailSelector:@selector(my24_urlRequestFailed:)];
            [request_6 setDidFinishSelector:@selector(my24_urlRequestSucceeded:)];
            [request_6 startAsynchronous];
        }
    }
}
-(void)my24_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"result=44%@", dicBig);
        if (dicBig) {
            if ([[dicBig objectForKey:@"code"] intValue] == 100) {
                //发起刷新请求
                [self refreshe];
                NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?cart_ids=%@",FIRST_URL,INTEGRALCARTCAL_URL,_good_id]];
                request_7=[ASIFormDataRequest requestWithURL:url2];
                
                [request_7 setRequestHeaders:[LJControl requestHeaderDictionary]];
                request_7.tag = 102;
                request_7.delegate =self;
                [request_7 setDidFailSelector:@selector(my26_urlRequestFailed:)];
                [request_7 setDidFinishSelector:@selector(my26_urlRequestSucceeded:)];
                [request_7 startAsynchronous];
            }else if([[dicBig objectForKey:@"code"] intValue] == -100){
                [SYObject failedPrompt:@"库存不足"];
                [SYObject endLoading];
            }else if([[dicBig objectForKey:@"code"] intValue] == -200){
                [SYObject failedPrompt:@"已经无此商品"];
                [SYObject endLoading];
            }
        }
        
    }
    else{
        [SYObject failedPrompt:@"请求出错"];
        [SYObject endLoading];
    }
}
-(void)my26_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"result=55%@", dicBig);
        if (dicBig) {
            self.lblIntegralTotal.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"all_integral"]];
            self.lblAllShipfee.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"all_shipfee"]];
            
            
            self.moneyCountLabel.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"goods_total_price"]];
            
            self.allMoneyCountLabel.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"order_total_price"]];
            
            
            
            _jieCount =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"size"]];
            [btnAccount setTitle:[NSString stringWithFormat:@"结算(%@)",_jieCount] forState:UIControlStateNormal];
            if ([_jieCount intValue]<=0) {
                btnAccount.enabled = NO;
                btnAccount.backgroundColor = UIColorFromRGB(0Xdfdfdf);//[UIColor grayColor];
            }else{
                btnAccount.enabled = YES;
                btnAccount.backgroundColor = MY_COLOR;
            }
        }
        [SYObject endLoading];
    }
    else{
        [SYObject failedPrompt:@"请求出错"];
        [SYObject endLoading];
    }
}
-(void)my26_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"请求出错"];
    [SYObject endLoading];
}
-(void)my24_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"请求出错"];
    [SYObject endLoading];
}
-(void) btnAdd:(UIButton *)btn{
    if (dataArr.count!=0) {
        Model *sss = [dataArr objectAtIndex:btn.tag-100];
        
        NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&cart_id=%@&count=%d",FIRST_URL,INTEGRALCOUNTADJUST_URL,[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:3],[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:1],sss.igc_id,[sss.igc_count intValue]+1]];
        request_8=[ASIFormDataRequest requestWithURL:url2];
        
        [request_8 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request_8.tag = 102;
        request_8.delegate =self;
        [request_8 setDidFailSelector:@selector(my27_urlRequestFailed:)];
        [request_8 setDidFinishSelector:@selector(my27_urlRequestSucceeded:)];
        [request_8 startAsynchronous];
    }
}
-(void)my27_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"result=66%@", dicBig);
        if (dicBig) {
            if ([[dicBig objectForKey:@"code"] intValue] == 100) {
                //发起刷新请求
                [self refreshe];
                NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?cart_ids=%@",FIRST_URL,INTEGRALCARTCAL_URL,_good_id]];
                request_9=[ASIFormDataRequest requestWithURL:url2];
                
                [request_9 setRequestHeaders:[LJControl requestHeaderDictionary]];
                request_9.tag = 102;
                request_9.delegate =self;
                [request_9 setDidFailSelector:@selector(my41_urlRequestFailed:)];
                [request_9 setDidFinishSelector:@selector(my41_urlRequestSucceeded:)];
                [request_9 startAsynchronous];
            }else if([[dicBig objectForKey:@"code"] intValue] == -100){
                [SYObject failedPrompt:@"库存不足"];
                [SYObject endLoading];
            }else if([[dicBig objectForKey:@"code"] intValue] == -200){
                [SYObject failedPrompt:@"库存不足"];
                [SYObject endLoading];
            }
        }
        
    }
    else{
        [SYObject failedPrompt:@"请求出错"];
        [SYObject endLoading];
    }
}
-(void)my41_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"result=77%@", dicBig);
        if (dicBig) {
            self.lblIntegralTotal.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"all_integral"]];
            self.lblAllShipfee.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"all_shipfee"]];
            
            
            self.moneyCountLabel.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"goods_total_price"]];
            
            self.allMoneyCountLabel.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"order_total_price"]];
            
            _jieCount =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"size"]];
            [btnAccount setTitle:[NSString stringWithFormat:@"结算(%@)",_jieCount] forState:UIControlStateNormal];
            if ([_jieCount intValue]<=0) {
                btnAccount.enabled = NO;
                btnAccount.backgroundColor = UIColorFromRGB(0Xdfdfdf);//[UIColor grayColor];
            }else{
                btnAccount.enabled = YES;
                btnAccount.backgroundColor = MY_COLOR;
            }
        }
        [SYObject endLoading];
        
    }
    else{
        [SYObject failedPrompt:@"请求出错"];
        [SYObject endLoading];
    }
}
-(void)my41_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"请求出错"];
    [SYObject endLoading];
}
-(void)my27_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"请求出错"];
    [SYObject endLoading];
}
#pragma mark - tableView
- (void)createTableView{
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    
    if (ScreenFrame.size.height>480) {//说明是5 5s
        shjTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenFrame.size.width, ScreenFrame.size.height-64-104) style:UITableViewStylePlain];
        
    }else{
        shjTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenFrame.size.width, ScreenFrame.size.height-64-104) style:UITableViewStylePlain];
    }
    shjTableView.backgroundColor=UIColorFromRGB(0Xf2f2f2);
    shjTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    shjTableView.delegate = self;
    shjTableView.dataSource = self;
    shjTableView.showsVerticalScrollIndicator=NO;
    shjTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:shjTableView];
    
    InputView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height)];
    InputView.hidden = YES;
    [self.view addSubview:InputView];
    
  }

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArr.count != 0) {
        return dataArr.count;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (dataArr.count != 0) {
       return 80;
    }
    return self.view.bounds.size.height-64*2;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *shjTableViewCell = @"ExchangeCarCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell%ld_%ld", (long)indexPath.section, (long)indexPath.row]];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:shjTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (dataArr.count != 0) {
        imgItem.hidden=NO;
        Model *shjm = [dataArr objectAtIndex:indexPath.row];
        UIButton *btnIsSelect = [UIButton buttonWithType:UIButtonTypeCustom];
        btnIsSelect.frame = CGRectMake(0, 15, 40, 40);
        btnIsSelect.tag = 400 + indexPath.row;
        NSMutableArray *arr = (NSMutableArray *)[_good_id componentsSeparatedByString:@","];
        if (arr.count!=0) {
            BOOL myB =  NO;
            for(int i=0;i<arr.count;i++){
                if ([[NSString stringWithFormat:@"%@",shjm.igc_id] isEqualToString:[arr objectAtIndex:i]]) {
                    myB = YES;
                }
            }
            if (myB== NO) {
                [btnIsSelect setImage:[UIImage imageNamed:@"checkbox_no"] forState:UIControlStateNormal];
            }else{
                [btnIsSelect setImage:[UIImage imageNamed:@"checkbox_yes"] forState:UIControlStateNormal];
            }
        }else{
            [btnIsSelect setImage:[UIImage imageNamed:@"checkbox_no"] forState:UIControlStateNormal];
        }
        [btnIsSelect addTarget:self action:@selector(btnIsSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btnIsSelect];
        
        UIImageView *imgLine = [[UIImageView alloc]initWithFrame:CGRectMake(10, 79, ScreenFrame.size.width-20, 0.5)];
        imgLine.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:imgLine];
        
        self.imgLog = [[UIImageView alloc]initWithFrame:CGRectMake(45, 9, 60, 60)];
        [self.imgLog sd_setImageWithURL:[NSURL URLWithString:shjm.igc_goods_img] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
        [cell addSubview:self.imgLog];
        
        self.lblGoodsName = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, ScreenFrame.size.width - 130, 30)];
        self.lblGoodsName.text = [NSString stringWithFormat:@"%@",shjm.igc_goods_name];
        self.lblGoodsName.font = [UIFont boldSystemFontOfSize:12];
        self.lblGoodsName.numberOfLines = 0;
        [cell addSubview:self.lblGoodsName];
        
        self.lblIntegrals = [[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width - 115, 45, 100, 10)];
        self.lblIntegrals.text = [NSString stringWithFormat:@"%@积分",shjm.igc_integral];
        self.lblIntegrals.textColor = MY_COLOR;
        self.lblIntegrals.textAlignment = NSTextAlignmentRight;
        self.lblIntegrals.font = [UIFont systemFontOfSize:12];
        [cell addSubview:self.lblIntegrals];
        
        UITextField *countField = [[UITextField alloc]initWithFrame:CGRectMake(140, 40, 40, 20)];
        countField.text = [NSString stringWithFormat:@"%@",shjm.igc_count];
        countField.enabled = NO;
        countField.layer.borderWidth = 1.0;
        countField.layer.cornerRadius = 5.0;
        countField.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        countField.textAlignment = NSTextAlignmentCenter;
        countField.font = [UIFont systemFontOfSize:13];
        countField.keyboardType = UIKeyboardTypeNumberPad;
        [cell addSubview:countField];
        UIButton *btnMinus = [UIButton buttonWithType:UIButtonTypeCustom];
        btnMinus.tag = indexPath.row +100;
        btnMinus.frame = CGRectMake(115, 40, 20, 20);
        [btnMinus setImage:[UIImage imageNamed:@"shjjian2"] forState:UIControlStateNormal];
        [btnMinus addTarget:self action:@selector(btnMinus:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btnMinus];
        
        UILabel *ship = [[UILabel alloc]initWithFrame:CGRectMake(115, 60, 200, 18)];
        ship.text = [NSString stringWithFormat:@"邮费:  %@",shjm.igc_transfee ];
        ship.textColor = MY_COLOR;
        ship.font = [UIFont boldSystemFontOfSize:12];
        [cell addSubview:ship];
        
        
#pragma mark -添加商品金额
        
        UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 60, 200, 18)];
        moneyLabel.text = [NSString stringWithFormat:@"商品金额:%@",shjm.list_good_price];
        moneyLabel.textColor = MY_COLOR;
        moneyLabel.font = [UIFont boldSystemFontOfSize:12];
        [cell addSubview:moneyLabel];
        
        
        
        
        UIButton *btnField = [UIButton buttonWithType:UIButtonTypeCustom];
        btnField.tag = indexPath.row +100;
        btnField.frame = CGRectMake(140, 40, 40, 20);
        [btnField addTarget:self action:@selector(btnField:) forControlEvents:UIControlEventTouchUpInside];
        btnField.backgroundColor = [UIColor clearColor];
        [cell addSubview:btnField];
        
        UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        btnAdd.frame = CGRectMake(185, 40, 20, 20);
        btnAdd.tag = indexPath.row + 100;
        [btnAdd setImage:[UIImage imageNamed:@"shjjia2"] forState:UIControlStateNormal];
        [btnAdd addTarget:self action:@selector(btnAdd:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btnAdd];
    }else{
//        UILabel *labelTishi = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, ScreenFrame.size.width - 40, 40)];
//        labelTishi.text = @"积分购物车为空";
//        labelTishi.textAlignment = NSTextAlignmentCenter;
//        labelTishi.textColor = [UIColor lightGrayColor];
//        [cell addSubview:labelTishi];
        imgItem.hidden=YES;
        UIView * labelWu = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height)];
        labelWu.backgroundColor = UIColorFromRGB(0Xf2f2f2);
        [cell addSubview:labelWu];
        
        UIImageView *imageNoth = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenFrame.size.width-140)/2, 100, 140, 140)];
        imageNoth.image = [UIImage imageNamed:@"nothing"];
        [labelWu addSubview:imageNoth];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 250, ScreenFrame.size.width, 22)];
        label.text = @"积分购物车为空";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor darkGrayColor];
        [labelWu addSubview:label];
        
        if (ScreenFrame.size.height<=480) {
            imageNoth.frame =CGRectMake((ScreenFrame.size.width-140)/2,100, 140, 140);
            label.frame = CGRectMake(0, 250, ScreenFrame.size.width, 22);
        }else if (ScreenFrame.size.height>480&&ScreenFrame.size.height<=568){
            imageNoth.frame =CGRectMake((ScreenFrame.size.width-140)/2, 180, 140, 140);
            label.frame = CGRectMake(0, 330, ScreenFrame.size.width, 22);
        }else if (ScreenFrame.size.height>568&&ScreenFrame.size.height<=1334/2){
            imageNoth.frame =CGRectMake((ScreenFrame.size.width-140)/2, 180, 140, 140);
            label.frame = CGRectMake(0, 330, ScreenFrame.size.width, 22);
        }else{
            imageNoth.frame =CGRectMake((ScreenFrame.size.width-140)/2, 200, 140, 140);
            label.frame = CGRectMake(0, 350, ScreenFrame.size.width, 22);
        }

        
    }
    
    return cell;
}
-(void)btnField:(UIButton *)btn{
    if (dataArr.count!=0) {
      
        Model *ssss = [dataArr objectAtIndex:btn.tag-100];
        fieldTag = btn.tag-100;
        //创建一个可输入的框
        InputView.hidden = NO;
        UIImageView *imageG = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height)];
        imageG.backgroundColor = [UIColor blackColor];
        imageG.alpha = 0.5;
        imageG.userInteractionEnabled = YES;
        [InputView addSubview:imageG];
        UITapGestureRecognizer *singleTapGestureRecognizer3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappear)];
        [singleTapGestureRecognizer3 setNumberOfTapsRequired:1];
        [imageG addGestureRecognizer:singleTapGestureRecognizer3];
        
        UIImageView *wgite = [[UIImageView alloc]initWithFrame:CGRectMake(40, 74, 240, 120)];
        wgite.image = [UIImage imageNamed:@"xuancount_"];
        wgite.userInteractionEnabled = YES;
        [InputView addSubview:wgite];
        
        UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(190, 2, 40, 18)];
        price.font = [UIFont boldSystemFontOfSize:12];
        price.textColor = [UIColor redColor];
        price.text = [NSString stringWithFormat:@"%@分",ssss.igc_integral];
        price.textAlignment = NSTextAlignmentRight;
        [wgite addSubview:price];
        
        CountInput = [[UILabel alloc]initWithFrame:CGRectMake(190, 20, 40, 18)];
        CountInput.font = [UIFont boldSystemFontOfSize:12];
        CountInput.textColor = [UIColor redColor];
        CountInput.text = [NSString stringWithFormat:@"×%@",ssss.igc_count];
        CountInput.textAlignment = NSTextAlignmentRight;
        [wgite addSubview:CountInput];
        
        textFF = [[UITextField alloc]initWithFrame:CGRectMake(100, 45, 40, 30)];
        textFF.backgroundColor = [UIColor clearColor];
        textFF.tag = 10000;
        textFF.text = [NSString stringWithFormat:@"%@",ssss.igc_count];
        textFF.keyboardType = UIKeyboardTypeNumberPad;
        textFF.delegate =self;
        [wgite addSubview:textFF];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 1000001;
        btn.frame = CGRectMake(5, 84, 110, 32);
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [wgite addSubview:btn];
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.tag = 1000002;
        btn2.frame = CGRectMake(125, 84, 110, 32);
        [btn2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [wgite addSubview:btn2];
        
        UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn3.tag = 1000003;
        btn3.frame = CGRectMake(70, 50, 20, 20);
        [btn3 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [wgite addSubview:btn3];
        
        UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn4.tag = 1000004;
        btn4.frame = CGRectMake(151, 50, 20, 20);
        [btn4 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [wgite addSubview:btn4];
    }
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

#pragma mark - 用户信息调用
-(void)refreshe{
    [SYObject startLoading];
    ExchangeHomeViewController *exc = [ExchangeHomeViewController sharedUserDefault];
    
    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&id=%@",FIRST_URL,EXCHANGECAR_URL,[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:3],[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:1],exc.ig_id]];
    request_10=[ASIFormDataRequest requestWithURL:url2];
    
    [request_10 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_10.tag = 102;
    request_10.delegate =self;
    [request_10 setDidFailSelector:@selector(my28_urlRequestFailed:)];
    [request_10 setDidFinishSelector:@selector(my28_urlRequestSucceeded:)];
    [request_10 startAsynchronous];
}
-(void)my28_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"result=88%@", dicBig);
        if (dicBig) {
            if ([[dicBig objectForKey:@"ret"] isEqualToString:@"flase"]) {
                [SYObject failedPrompt:@"用户信息错误，请重新登录"];
                [SYObject endLoading];
            }else{
                NSArray *array = [dicBig objectForKey:@"cart_list"];
                if (dataArr.count != 0) {
                    [dataArr removeAllObjects];
                }
                for (NSDictionary *dic in array) {
                    Model *shjm = [[Model alloc]init];
                    shjm.igc_goods_img = [dic objectForKey:@"ig_goods_img"];
                    shjm.igc_goods_name = [dic objectForKey:@"ig_goods_name"];
                    shjm.igc_integral = [dic objectForKey:@"integral"];
                    shjm.igc_count = [dic objectForKey:@"count"];
                    shjm.igc_transfee = [dic objectForKey:@"trans_fee"];
                    shjm.igc_id = [dic objectForKey:@"id"];
                    
#pragma mark -获取商品的 价格
                    shjm.list_good_price = [dic objectForKey:@"price"];

                    [dataArr addObject:shjm];
                }
                if (dataArr.count==0) {
                    btnDelete.hidden = YES;
                }else{
                    btnDelete.hidden = NO;
                }
                [shjTableView reloadData];
            }
        }
        [SYObject endLoading];
        
    }
    else{
        [SYObject failedPrompt:@"请求出错"];
        [SYObject endLoading];
    }
}
-(void)my28_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"请求出错"];
    [SYObject endLoading];
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillAppear:YES];
    [self refreshe];
    
    [btnAllSelect setBackgroundImage:[UIImage imageNamed:@"checkbox_no"] forState:UIControlStateNormal];
    _good_id = @"";
    btnBool = NO;
    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?cart_ids=%@",FIRST_URL,INTEGRALCARTCAL_URL,_good_id]];
    request_3=[ASIFormDataRequest requestWithURL:url2];
    
    [request_3 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_3.tag = 102;
    request_3.delegate =self;
    [request_3 setDidFailSelector:@selector(my22_urlRequestFailed:)];
    [request_3 setDidFinishSelector:@selector(my22_urlRequestSucceeded:)];
    [request_3 startAsynchronous];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
    
    btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDelete.frame = CGRectMake(0, 0, 35, 30);
    [btnDelete setTitle:@"删除" forState:UIControlStateNormal];
    [btnDelete addTarget:self action:@selector(btnDelete) forControlEvents:UIControlEventTouchUpInside ];
    btnDelete.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *bar2 = [[UIBarButtonItem alloc]initWithCustomView:btnDelete];
    self.navigationItem.rightBarButtonItem = bar2;
}

-(void)backBtnClicked{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnDelete{
    [OHAlertView showAlertWithTitle:@"提示" message:@"您确定要删除选中商品吗?" cancelButton:nil otherButtons:@[@"确定",@"取消"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,INTEGRALCARTDEL_URL]];
            request_11 = [ASIFormDataRequest requestWithURL:url];
            [request_11 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
            [request_11 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
            [request_11 setPostValue:_good_id forKey:@"cart_ids"];
            
            [request_11 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request_11.tag = 105;
            [request_11 setDelegate:self];
            [request_11 setDidFailSelector:@selector(my2_urlRequestFailed:)];
            [request_11 setDidFinishSelector:@selector(my2_urlRequestSucceeded:)];
            [request_11 startAsynchronous];
        }else if (buttonIndex == 1) {
        }

    }];
}
-(void)my2_urlRequestSucceeded:(ASIFormDataRequest *)request{
    
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig2 =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"删除-->>%@",dicBig2);
        if ([[dicBig2 objectForKey:@"code"] intValue] == 100) {
            [self refreshe];
            [btnAllSelect setBackgroundImage:[UIImage imageNamed:@"checkbox_no"] forState:UIControlStateNormal];
            btnBool = NO;
            
            NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?cart_ids=%@",FIRST_URL,INTEGRALCARTCAL_URL,@""]];
            request_12=[ASIFormDataRequest requestWithURL:url2];
            
            [request_12 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request_12.tag = 102;
            request_12.delegate =self;
            [request_12 setDidFailSelector:@selector(my29_urlRequestFailed:)];
            [request_12 setDidFinishSelector:@selector(my29_urlRequestSucceeded:)];
            [request_12 startAsynchronous];
        }
    }
    
}
-(void)my29_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"result=99%@", dicBig);
        if (dicBig) {
            self.lblIntegralTotal.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"all_integral"]];
            self.lblAllShipfee.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"all_shipfee"]];
            
            
            
            self.moneyCountLabel.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"goods_total_price"]];
            
            self.allMoneyCountLabel.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"order_total_price"]];
            
            _jieCount =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"size"]];
            [btnAccount setTitle:[NSString stringWithFormat:@"结算(%@)",_jieCount] forState:UIControlStateNormal];
            if ([_jieCount intValue]<=0) {
                btnAccount.enabled = NO;
                btnAccount.backgroundColor =UIColorFromRGB(0Xdfdfdf); //[UIColor grayColor];
            }else{
                btnAccount.enabled = YES;
                btnAccount.backgroundColor = MY_COLOR;
            }
        }
        [SYObject endLoading];
        
    }
    else{
        [SYObject failedPrompt:@"请求出错"];
        [SYObject endLoading];
    }
}
-(void)my29_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"请求出错"];
    [SYObject endLoading];
}
-(void)my2_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
    [SYObject endLoading];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request_1 clearDelegatesAndCancel];
    [request_2 clearDelegatesAndCancel];
    [request_3 clearDelegatesAndCancel];
    [request_4 clearDelegatesAndCancel];
    [request_5 clearDelegatesAndCancel];
    [request_6 clearDelegatesAndCancel];
    [request_7 clearDelegatesAndCancel];
    [request_8 clearDelegatesAndCancel];
    [request_9 clearDelegatesAndCancel];
    [request_10 clearDelegatesAndCancel];
    [request_11 clearDelegatesAndCancel];
    [request_12 clearDelegatesAndCancel];
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *str =[string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
        if(str.length > 0)
        {
            return NO;
        } 
     
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
