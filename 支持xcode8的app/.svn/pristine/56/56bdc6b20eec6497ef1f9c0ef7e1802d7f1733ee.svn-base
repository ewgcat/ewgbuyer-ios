//
//  ExchangeListViewController.m
//  My_App
//
//  Created by apple on 14-12-30.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "ExchangeListViewController.h"
#import "ASIFormDataRequest.h"
#import "AddAdminViewController.h"
#import "ThirdViewController.h"
#import "ExchangeCarViewController.h"
#import "ExchangeHomeViewController.h"
#import "IntegralExchangeViewController.h"
#import "onlinePayTypesIntegralViewController.h"
#import "OnlinePayTypeSelectViewController.h"

@interface ExchangeListViewController ()

@end

static ExchangeListViewController *singleInstance=nil;

@implementation ExchangeListViewController
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
//-(UIView *)loadingView:(CGRect)rect
//{
//    UIView *loadV=[[UIView alloc]initWithFrame:rect];
//    loadV.backgroundColor=[UIColor blackColor];
//    loadV.alpha = 0.8;
//    UIActivityIndicatorView *activityIndicatorV=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    activityIndicatorV.center=CGPointMake(rect.size.width/2, rect.size.height/2-10);
//    [activityIndicatorV startAnimating];
//    
//    [loadV addSubview:activityIndicatorV];
//    UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(0, 70, 100, 30)];
//    la.text=@"正在加载...";
//    la.backgroundColor=[UIColor clearColor];
//    la.textAlignment=NSTextAlignmentCenter;
//    la.textColor=[UIColor whiteColor];
//    la.font=[UIFont boldSystemFontOfSize:15];
//    [loadV addSubview:la];
//    loadV.layer.cornerRadius=4;
//    loadV.layer.masksToBounds=YES;
//    return loadV;
//}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    labeltext.text = @"如有任何要求请留言";
    labeltext.hidden=NO;
    self.messField.text=@"";
    [request_1 clearDelegatesAndCancel];
    [request_2 clearDelegatesAndCancel];
    [request_3 clearDelegatesAndCancel];
    [request_4 clearDelegatesAndCancel];
}

-(void)viewWillAppear:(BOOL)animated{
    if (_myBool == NO) {
        
    }else{
        _myBool = NO;
//        [self.navigationController popViewControllerAnimated:YES];
    }
    ExchangeCarViewController *ecc = [ExchangeCarViewController sharedUserDefault];
    self.lblIntegrals.text = ecc.lblIntegralTotal.text;
    self.lblTransfee.text = [NSString stringWithFormat:@"￥%.2f",[ecc.lblAllShipfee.text floatValue]];
    
     self.orderCountLabel.text = [NSString stringWithFormat:@"￥%.2f",[ecc.allMoneyCountLabel.text floatValue]];
    
    self.goodCountLabel.text = [NSString stringWithFormat:@"￥%.2f",[ecc.moneyCountLabel.text floatValue]];

    
    self.tabBarController.tabBar.hidden = YES;
    
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    ExchangeHomeViewController *exc = [ExchangeHomeViewController sharedUserDefault];
    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,INTEGRALGOODS_URL]];
    request_1 = [ASIFormDataRequest requestWithURL:url2];
    [request_1 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request_1 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    [request_1 setPostValue:exc.ig_id forKey:@"ig_id"];
    [request_1 setPostValue:@"0" forKey:@"beginCount"];
    [request_1 setPostValue:@"20" forKey:@"selectCount"];
    
    [request_1 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_1.tag = 102;
    [request_1 setDidFailSelector:@selector(urlRequestFailed:)];
    [request_1 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [request_1 startAsynchronous];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,DEFAULTADDRESSFIND_URL]];
    request_2 = [ASIFormDataRequest requestWithURL:url];
    [request_2 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request_2 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    
    [request_2 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_2.tag = 105;
    request_2.delegate = self;
    [request_2 setDidFailSelector:@selector(my1_urlRequestFailed:)];
    [request_2 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
    [request_2 startAsynchronous];
    [super viewWillAppear:YES];
//     labeltext.text = @"如有任何要求请留言";
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        [SYObject endLoading];
        ExchangeCarViewController *excar = [ExchangeCarViewController sharedUserDefault];
        
        _lblIntegrals.text = [NSString stringWithFormat:@"%@",excar.lblIntegralTotal.text];
        _lblTransfee.text = [NSString stringWithFormat:@"%@",excar.lblAllShipfee.text];
        
           _goodCountLabel.text = [NSString stringWithFormat:@"%@",excar.moneyCountLabel.text];
        _orderCountLabel.text = [NSString stringWithFormat:@"%@",excar.allMoneyCountLabel.text];

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
#pragma mark -获取地址信息的接口
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        [SYObject endLoading];
        NSDictionary *dicBig = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig:%@",dicBig);
        
        if ([[dicBig allKeys] containsObject:@"addr_id"]){
            ThirdViewController *third = [ThirdViewController sharedUserDefault];
            self.imgAddrBG2.hidden = YES;
            self.imgAddBG.hidden = NO;
            third.person_addr_id =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"addr_id"]];
            self.lblArea.text =[NSString stringWithFormat:@"%@%@",[dicBig objectForKey:@"area"],[dicBig objectForKey:@"areaInfo"]];
            self.lblUserName.text=[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"trueName"]];
            
            if ([dicBig objectForKey:@"telephone"]) {
                self.lblPhone.text =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"telephone"]];

            }
            if ([dicBig objectForKey:@"mobile"]) {
                self.lblPhone.text =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"mobile"]];
                
            }
        }else{
            self.imgAddrBG2.hidden = NO;
            self.imgAddBG.hidden = YES;
        }
    }
    
}
-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
    [SYObject endLoading];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _myBool = NO;
    self.title = @"确认积分兑换清单";
    self.view.backgroundColor = [UIColor colorWithRed:251/255.0f green:253/255.0f blue:242/255.0f alpha:1];
    
    [self createBackBtn];
    
    self.imgAddBG = [[UIImageView alloc]initWithFrame:CGRectMake(0,5, ScreenFrame.size.width, 66)];
    self.imgAddBG.image = [UIImage imageNamed:@"xinfeng_lj.png"];
    self.imgAddBG.userInteractionEnabled = YES;
    [self.view addSubview:self.imgAddBG];
    
    UIView *back1=[LJControl viewFrame:CGRectMake(0, 0, self.imgAddBG.size.width, 66) backgroundColor:UIColorFromRGB(0xFFFBF3)];
    [self.imgAddBG addSubview:back1];
    
    self.imgAddrBG2 = [[UIImageView alloc]initWithFrame:CGRectMake(0,5, ScreenFrame.size.width, 66)];
    self.imgAddrBG2.image = [UIImage imageNamed:@"xinfeng_lj.png"];
    self.imgAddrBG2.userInteractionEnabled = YES;
    [self.view addSubview:self.imgAddrBG2];
    UIView *back2=[LJControl viewFrame:CGRectMake(0, 0, self.imgAddrBG2.size.width, 66) backgroundColor:UIColorFromRGB(0xFFFBF3)];
    [self.imgAddrBG2 addSubview:back2];
   
    
    UILabel *labelTishi = [[UILabel alloc]initWithFrame:CGRectMake(25, 10, 240, 46)];
    labelTishi.text = @"还没有收货人信息, 快去添加吧";
    labelTishi.textColor = [UIColor lightGrayColor];
    labelTishi.font = [UIFont systemFontOfSize:14];
    [self.imgAddrBG2 addSubview:labelTishi];
    
    UIImageView *toImg2=[LJControl imageViewFrame:CGRectMake(self.imgAddrBG2.size.width-18, self.imgAddrBG2.size.height*0.5-6, 8, 13) setImage:@"dis_indicator.png" setbackgroundColor:[UIColor whiteColor]];
    [self.imgAddrBG2 addSubview:toImg2];
    UIImageView *colorLine2=[LJControl imageViewFrame:CGRectMake(0, 66, self.imgAddrBG2.size.width, 2) setImage:@"colorLine.png" setbackgroundColor:[UIColor whiteColor]];
    [self.imgAddrBG2 addSubview:colorLine2];
    
    
    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAdd.frame = CGRectMake(0, 0, ScreenFrame.size.width, self.imgAddrBG2.size.height);
    btnAdd.tag = 201;
    btnAdd.backgroundColor=[UIColor clearColor];
    [btnAdd addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.imgAddrBG2 addSubview:btnAdd];
    
//    self.personAddress = [[UILabel alloc]initWithFrame:CGRectMake(10, 33, 265, 30)];
//    self.personAddress.textColor = [UIColor redColor];
//    self.personAddress.font = [UIFont systemFontOfSize:12];
//    [self.imgAddBG addSubview:self.personAddress];
    
//    self.lblTitleMes = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 25)];
//    self.lblTitleMes.text = @"收货人信息";
//    self.lblTitleMes.textColor = [UIColor grayColor];
//    self.lblTitleMes.font = [UIFont systemFontOfSize:17];
//    [self.imgAddBG addSubview:self.lblTitleMes];
    UIImageView *icon=[LJControl imageViewFrame:CGRectMake(15, 8, 20, 20) setImage:@"iconNew.png" setbackgroundColor:[UIColor whiteColor]];
    [self.imgAddBG addSubview:icon];
    
    
    UILabel *redLab=[LJControl labelFrame:CGRectMake(15, 38, 40, 20) setText:@"默认" setTitleFont:14 setbackgroundColor:UIColorFromRGB(0xf15353) setTextColor:[UIColor whiteColor] textAlignment:(NSTextAlignmentCenter)];
   [self.imgAddBG addSubview:redLab];
    
    self.lblArea = [[UILabel alloc]initWithFrame:CGRectMake(60, 38, 240, 20)];
    self.lblArea.textColor = UIColorFromRGB(0x666666);
    self.lblArea.font = [UIFont systemFontOfSize:15];
    [self.imgAddBG addSubview:self.lblArea];
    
    self.lblUserName = [[UILabel alloc]initWithFrame:CGRectMake(40, 8, 120, 20)];
    self.lblUserName.textColor = UIColorFromRGB(0x222222);
    self.lblUserName.font = [UIFont systemFontOfSize:17];
    [self.imgAddBG addSubview:self.lblUserName];
    
    
    UIImageView *iphone=[LJControl imageViewFrame:CGRectMake(125, 8, 20, 20) setImage:@"iphone.png" setbackgroundColor:[UIColor whiteColor]];
    [self.imgAddBG addSubview:iphone];
    
    self.lblPhone = [[UILabel alloc]initWithFrame:CGRectMake(150, 8, 120, 20)];
    self.lblPhone.textColor = UIColorFromRGB(0x222222);
    self.lblPhone.font = [UIFont systemFontOfSize:17];
    [self.imgAddBG addSubview:self.lblPhone];
    UIImageView *toImg1=[LJControl imageViewFrame:CGRectMake(self.imgAddBG.size.width-18, self.imgAddBG.size.height*0.5-6, 8, 13) setImage:@"dis_indicator.png" setbackgroundColor:[UIColor whiteColor]];
    [self.imgAddBG addSubview:toImg1];
    
    UIImageView *colorLine1=[LJControl imageViewFrame:CGRectMake(0, 66, self.imgAddBG.size.width, 2) setImage:@"colorLine.png" setbackgroundColor:[UIColor whiteColor]];
    [self.imgAddBG addSubview:colorLine1];

    
    UIButton *btnAdd1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAdd1.frame = CGRectMake(0, 0, ScreenFrame.size.width, self.imgAddBG.size.height);
    btnAdd1.tag = 203;
    btnAdd1.backgroundColor=[UIColor clearColor];
    [btnAdd1 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.imgAddBG addSubview:btnAdd1];

   
    UIImageView *imgMessBG = [[UIImageView alloc]initWithFrame:CGRectMake(0, 75, ScreenFrame.size.width, 90)];
    imgMessBG.backgroundColor = [UIColor whiteColor];
    imgMessBG.userInteractionEnabled = YES;
    imgMessBG.layer.borderWidth = 0.5;
    imgMessBG.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    [self.view addSubview:imgMessBG];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
    label.text = @"填写留言";
    label.font = [UIFont systemFontOfSize:14];
    [imgMessBG addSubview:label];
    
    UIImageView *imgMess = [[UIImageView alloc]initWithFrame:CGRectMake(10, 30, ScreenFrame.size.width-20, 50)];
    imgMess.backgroundColor = [UIColor whiteColor];
    imgMess.userInteractionEnabled = YES;
    imgMess.layer.borderWidth = 1;
    imgMess.layer.borderColor = [UIColorFromRGB(0xd7d7d7)CGColor];
    CALayer *lay2 = imgMess.layer;
    [lay2 setMasksToBounds:YES];
    [lay2 setCornerRadius:4.0f];
    [imgMessBG addSubview:imgMess];
    
    self.messField = [[UITextView alloc]initWithFrame:CGRectMake(5, 0, ScreenFrame.size.width-30, 50)];
    self.messField.font = [UIFont systemFontOfSize:12];
    self.messField.scrollEnabled = YES;
    self.messField.keyboardType = UIKeyboardAppearanceDefault;
    self.messField.delegate = self;
    [imgMess addSubview:self.messField];
    
    labeltext = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 290, 21)];
    labeltext.backgroundColor = [UIColor clearColor];
    labeltext.text = @"如有任何要求请留言";
    labeltext.textColor = [UIColor lightGrayColor];
    labeltext.textAlignment = NSTextAlignmentLeft;
    labeltext.font = [UIFont systemFontOfSize:12.0f];
    [self.messField addSubview:labeltext];
    
    UIImageView *imgAccountsBG = [[UIImageView alloc]initWithFrame:CGRectMake(0, 170, ScreenFrame.size.width, 60+60)];
    imgAccountsBG.backgroundColor = [UIColor whiteColor];
    imgAccountsBG.userInteractionEnabled = YES;
    imgAccountsBG.layer.borderWidth = 0.5;
    imgAccountsBG.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    [self.view addSubview:imgAccountsBG];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 60, 30)];
    label2.text = @"所需积分:";
    label2.font = [UIFont systemFontOfSize:12];
    [imgAccountsBG addSubview:label2];
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 60, 30)];
    label3.text = @"运费:";
    label3.font = [UIFont systemFontOfSize:12];
    [imgAccountsBG addSubview:label3];
    
  //商品金额
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(10, 55, 90, 30)];
    label4.text = @"商品金额:";
    label4.font = [UIFont systemFontOfSize:12];
    [imgAccountsBG addSubview:label4];
    
    //订单总金额
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 90, 30)];
    label5.text = @"订单总金额:";
    label5.font = [UIFont systemFontOfSize:12];
    [imgAccountsBG addSubview:label5];
    
    
    //所需积分的数字
    self.lblIntegrals = [[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-100, 5, 90, 30)];
    self.lblIntegrals.textAlignment = NSTextAlignmentRight;
    self.lblIntegrals.font = [UIFont systemFontOfSize:12];
    self.lblIntegrals.textColor=UIColorFromRGB(0xdb222e);
    [imgAccountsBG addSubview:self.lblIntegrals];
    //运费的数字

    self.lblTransfee = [[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-100, 30, 90, 30)];
    self.lblTransfee.textAlignment = NSTextAlignmentRight;
    self.lblTransfee.font = [UIFont systemFontOfSize:12];
     self.lblTransfee.textColor=UIColorFromRGB(0xdb222e);
    [imgAccountsBG addSubview:self.lblTransfee];
    
    
    
    
    //商品金额的数字
    
    self.goodCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-100, 55, 90, 30)];
    self.goodCountLabel.textAlignment = NSTextAlignmentRight;
    self.goodCountLabel.font = [UIFont systemFontOfSize:12];
    self.goodCountLabel.textColor=UIColorFromRGB(0xdb222e);
    [imgAccountsBG addSubview:self.goodCountLabel];
    
    
    
    
    //订单总金额的数字
    
    self.orderCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-100, 80, 90, 30)];
    self.orderCountLabel.textAlignment = NSTextAlignmentRight;
    self.orderCountLabel.font = [UIFont systemFontOfSize:12];
    self.orderCountLabel.textColor=UIColorFromRGB(0xdb222e);
    [imgAccountsBG addSubview:self.orderCountLabel];
    
    
    UIButton *btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSubmit.frame = CGRectMake(0, 0, 200, 35);
    btnSubmit.center = CGPointMake(ScreenFrame.size.width/2, 320);
    CALayer *lay3 = btnSubmit.layer;
    [lay3 setMasksToBounds:YES];
    [lay3 setCornerRadius:4.0f];
    btnSubmit.tag = 202;
    btnSubmit.backgroundColor = MY_COLOR;
    [btnSubmit setTitle:@"提交订单" forState:UIControlStateNormal];
    btnSubmit.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [btnSubmit addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSubmit];
     // Do any additional setup after loading the view.
 
}

-(void)btnClicked:(UIButton *)btn{
    if (btn.tag == 201) {
        AddAdminViewController *addAdminVC = [[AddAdminViewController alloc]init];
        [self.navigationController pushViewController:addAdminVC animated:YES];
        NSLog(@"201");
    }
    if (btn.tag == 202) {
        [SYObject startLoading];
        
#pragma mark -提交订单
        _myBool = YES;
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
        ThirdViewController *third = [ThirdViewController sharedUserDefault];
        ExchangeCarViewController *excar = [ExchangeCarViewController sharedUserDefault];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,EXCCARSUBMIT_URL]];
        request_3 = [ASIFormDataRequest requestWithURL:url];
        [request_3 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
        [request_3 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
        [request_3 setPostValue:third.person_addr_id forKey:@"addr_id"];
        [request_3 setPostValue:excar.good_id forKey:@"cart_ids"];
        [request_3 setPostValue:igo_msg forKey:@"igo_msg"];
        
        [request_3 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request_3.tag = 101;
        request_3.delegate = self;
        [request_3 setDidFailSelector:@selector(my2_urlRequestFailed:)];
        [request_3 setDidFinishSelector:@selector(my2_urlRequestSucceeded:)];
        [request_3 startAsynchronous];
        
        NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL, ALLPAYTYPE_URL]];
        request_4 = [ASIFormDataRequest requestWithURL:url3];
        [request_4 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
        [request_4 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
        [request_4 setPostValue:_order_id forKey:@"order_id"];
        
        [request_4 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request_4.tag = 106;
        request_4.delegate = self;
        [request_4 setDidFailSelector:@selector(my3_urlRequestFailed:)];
        [request_4 setDidFinishSelector:@selector(my3_urlRequestSucceeded:)];
        [request_4 startAsynchronous];
    }
    if (btn.tag == 203) {
        AddAdminViewController *addAdminVC = [[AddAdminViewController alloc]init];
        [self.navigationController pushViewController:addAdminVC animated:YES];
    
    }
}
-(void)my2_urlRequestSucceeded:(ASIFormDataRequest *)request{
    
    
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        [SYObject endLoading];
        NSDictionary *dicBig = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig:%@",dicBig);
        NSString *code = [dicBig objectForKey:@"code"];
        if (code.intValue == 100) {
            _order_id = [dicBig objectForKey:@"order_id"];
            _order_sn = [dicBig objectForKey:@"order_sn"];
            
            if (code.intValue == 100) {
                ThirdViewController *third = [ThirdViewController sharedUserDefault];
                ExchangeCarViewController *ex = [ExchangeCarViewController sharedUserDefault];
                [ex upSuccess];
                third.ding_order_id = [NSString stringWithFormat:@"%@",_order_id];
                third.ding_hao = [NSString stringWithFormat:@"%@",_order_sn];
                
                
#pragma mark -这里将总金额改成订单总金额
                third.jie_order_goods_price = [NSString stringWithFormat:@"%@",ex.allMoneyCountLabel.text];
//                onlinePayTypesIntegralViewController *online = [[onlinePayTypesIntegralViewController alloc]init];
//                [self.navigationController pushViewController:online animated:YES];
                OnlinePayTypeSelectViewController *onnn = [[OnlinePayTypeSelectViewController alloc]init];
                onnn.order_type=@"integral";
                [self.navigationController pushViewController:onnn animated:YES];
            }
        }
        if (code.intValue == -100) {
            [SYObject failedPrompt:@"购物车为空"];
            [SYObject endLoading];
        }
        if (code.intValue == 200) {
            _order_id = [dicBig objectForKey:@"order_id"];
            _order_sn = [dicBig objectForKey:@"order_sn"];
            [SYObject failedPrompt:@"兑换成功" complete:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [SYObject endLoading];
        }
        if (code.intValue == -200) {
            [SYObject failedPrompt:@"积分不足"];
            [SYObject endLoading];
        }
       
    }
}
-(void)my2_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
    [SYObject endLoading];
}
-(void)my3_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode4 = [request responseStatusCode];
    if (statuscode4 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig-->>%@",dicBig);
        if (dicBig) {
            NSString *can_pay = [dicBig objectForKey:@"can_pay"];
            if (can_pay.intValue == 0) {
                [SYObject failedPrompt:@"没有支付方式"];
                [SYObject endLoading];
            }
            if (can_pay.intValue == 1){
                
            }
        }
    }
    
}
-(void)my3_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
    [SYObject endLoading];
}




#pragma mark - 键盘操作
//隐藏键盘和隐藏提示label
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self.messField resignFirstResponder];
        return NO;
    }
    if (self.messField.text.length == 0) {
        if ([text isEqualToString:@""]) {
            labeltext.hidden = NO;
        }else{
            labeltext.hidden = YES;
        }
    }
    else{
        if (self.messField.text.length == 1) {
            if ([text isEqualToString:@""]) {
                labeltext.hidden = NO;
            }else{
                labeltext.hidden = YES;
            }
        }
        else{
            labeltext.hidden = YES;
        }
    }
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.messField resignFirstResponder];
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
