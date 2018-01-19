//
//  PayViewController.m
//  My_App
//
//  Created by apple on 14-8-18.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "PayViewController.h"
#import "ThirdViewController.h"
#import "NilCell.h"
#import "SinceComeViewController.h"

@interface PayViewController (){
    ASIFormDataRequest *request_1;
    ASIFormDataRequest *request_2;
    ASIFormDataRequest *request_3;
    ASIFormDataRequest *request_4;
    ASIFormDataRequest *request_Time;
    CGFloat scrollH;
    BOOL selfBring;
}

@end

static PayViewController *singleInstance=nil;

@implementation PayViewController

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
    return [[self alloc]init];
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

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    if (arrayShip.count!=0) {
        [arrayShip removeAllObjects];
    }
    if (peisongArray.count !=0 ) {
        [peisongArray removeAllObjects];
    }
    if (MyDataarray.count!=0) {
        [MyDataarray removeAllObjects];
    }
    if (NewpeisongArray.count!=0) {
        [NewpeisongArray removeAllObjects];
    }
    if (zhifufangshiDataarray.count!=0) {
        [zhifufangshiDataarray removeAllObjects];
    }
    
    [request_1 clearDelegatesAndCancel];
    [request_2 clearDelegatesAndCancel];
    [request_3 clearDelegatesAndCancel];
    [request_4 clearDelegatesAndCancel];
    [request_Time clearDelegatesAndCancel];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    sinceComeTag = NO;
    timeTag = 2;
    timeStr = @"点击选择时间";
    
    self.tabBarController.tabBar.hidden = YES;
    paypayTag=0;
    [MyTableView222 reloadData];
    [SYObject startLoading];
    ThirdViewController *third = [ThirdViewController sharedUserDefault];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,CARFEE_URL]];
    request_1 = [ASIFormDataRequest requestWithURL:url];
    [request_1 setPostValue:third.jie_cart_ids forKey:@"cart_ids"];
    [request_1 setPostValue:third.jie_store_ids forKey:@"store_ids"];
    if (third.person_addr_id.length == 0) {
        [request_1 setPostValue:@"1" forKey:@"addr_id"];
    }else{
        [request_1 setPostValue:third.person_addr_id forKey:@"addr_id"];
    }
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:filePathDong];
    
    [request_1 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_1.tag = 101;
    request_1.delegate = self;
    [request_1 setDidFailSelector:@selector(mmurlRequestFailed:)];
    [request_1 setDidFinishSelector:@selector(mmurlRequestSucceeded:)];
    [request_1 startAsynchronous];
    
    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ALLPAYTYPE_URL]];
    request_2 = [ASIFormDataRequest requestWithURL:url3];
    
    [request_2 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request_2 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    
    [request_2 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_2.tag = 102;
    request_2.delegate = self;
    [request_2 setDidFailSelector:@selector(urlRequestFailed:)];
    [request_2 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [request_2 startAsynchronous];
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    ThirdViewController *third = [ThirdViewController sharedUserDefault];
    NSArray *arrObjc2;
    if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
        arrObjc2 = [[NSArray alloc]initWithObjects:@"", nil];
    }else{
        arrObjc2 = [[NSArray alloc]initWithObjects:[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:4], nil];
    }
    NSArray *arrKey2 = [[NSArray alloc]initWithObjects:VERIFY, nil];
    NSMutableDictionary *dicMy2 = [[NSMutableDictionary alloc]initWithObjects:arrObjc2 forKeys:arrKey2];
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig:%@",dicBig);
        if(dicBig){
            if (zhifufangshiDataarray.count!=0) {
                [zhifufangshiDataarray removeAllObjects];
            }
            if ([[dicBig objectForKey:@"can_pay"] intValue] == 1) {
                [zhifufangshiDataarray addObject:@"在线支付"];
                third.pay = @"在线支付";
                fangshiFirst =@"在线支付";
                _payMethod.text = fangshiFirst;
                payType = fangshiFirst;
                //发起是否支持货到付款
                NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,AFTERSUPPLY_COUNT]];
                request_3 = [ASIFormDataRequest requestWithURL:url2];
                
                NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *documentsPath = [docPath objectAtIndex:0];
                NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                [request_3 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
                [request_3 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
                [request_3 setPostValue:third.goods_id forKey:@"goods_ids"];
                [request_3 setRequestHeaders:dicMy2];
                request_3.tag = 102;
                request_3.delegate = self;
                [request_3 setDidFailSelector:@selector(my1_urlRequestFailed:)];
                [request_3 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
                [request_3 startAsynchronous];
            }else{
                //发起是否支持货到付款
                
                NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,AFTERSUPPLY_COUNT]];
                request_4 = [ASIFormDataRequest requestWithURL:url2];
                
                NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *documentsPath = [docPath objectAtIndex:0];
                NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
                NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                [request_4 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
                [request_4 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
                [request_4 setPostValue:third.goods_id forKey:@"goods_ids"];
                
                [request_4 setRequestHeaders:dicMy2];
                request_4.tag = 102;
                request_4.delegate = self;
                [request_4 setDidFailSelector:@selector(my2_urlRequestFailed:)];
                [request_4 setDidFinishSelector:@selector(my2_urlRequestSucceeded:)];
                [request_4 startAsynchronous];
            }
        }
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"支付和配送方式";
         [self createBottom];
        self.view.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:239/255.0f alpha:1];
        
        if (UIDeviceHao>=7.0) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }else{
        }
        if (ScreenFrame.size.height>480) {//说明是5 5s
            MyTableView222 = [[UITableView alloc]initWithFrame:CGRectMake(0, ScreenFrame.origin.y, ScreenFrame.size.width, ScreenFrame.size.height-64-60) style:UITableViewStylePlain];
            
        }else{
            MyTableView222 = [[UITableView alloc]initWithFrame:CGRectMake(0, ScreenFrame.origin.y, ScreenFrame.size.width, ScreenFrame.size.height-64-60) style:UITableViewStylePlain];
        }
        MyTableView222.separatorStyle = UITableViewCellSeparatorStyleNone;
        MyTableView222.delegate = self;
        MyTableView222.dataSource=  self;
        MyTableView222.showsVerticalScrollIndicator=NO;
        MyTableView222.showsHorizontalScrollIndicator = NO;
        MyTableView222.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
        [self.view addSubview:MyTableView222];
        
        imageG = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-64)];
        imageG.image = [UIImage imageNamed:@"touming_lj"];
        imageG.hidden = YES;
        imageG.userInteractionEnabled = YES;
        [self.view addSubview:imageG];
        
        UIView *myview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, imageG.frame.size.width, imageG.frame.size.height)];
        myview.backgroundColor = [UIColor blackColor];
        myview.alpha = 0.5;
        [imageG addSubview:myview];
        
        _MyTableView = [[UITableView alloc]initWithFrame:CGRectMake((ScreenFrame.size.width-200)/2,150,200,260) style:UITableViewStylePlain];
        _MyTableView.hidden = NO;
        _MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _MyTableView.delegate = self;
        _MyTableView.dataSource=  self;
        _MyTableView.showsVerticalScrollIndicator=NO;
        _MyTableView.showsHorizontalScrollIndicator = NO;
        [imageG addSubview:_MyTableView];
        
        pickerBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height)];
        pickerBgView.hidden = YES;
        [self.view addSubview:pickerBgView];
        UIImageView *imageGGG = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height)];
        imageGGG.backgroundColor = [UIColor blackColor];
        imageGGG.alpha = 0.4;
        [pickerBgView addSubview:imageGGG];
        
        pickerview = [[UIPickerView alloc] initWithFrame:CGRectMake(-0.5, ScreenFrame.size.height-216-64, ScreenFrame.size.width+1, 216)];
        pickerview.showsSelectionIndicator=YES;
        [pickerBgView addSubview:pickerview];
        pickerview.delegate=self;
        pickerview.dataSource=self;
        pickerview.backgroundColor = [UIColor whiteColor];
        
        UIView *viewPic = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenFrame.size.height-216-64-44, ScreenFrame.size.width, 44)];
        viewPic.backgroundColor = RGB_COLOR(233, 233, 233);
        [pickerBgView addSubview:viewPic];
        UIButton *btnCancle = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCancle.frame = CGRectMake(0 , 0, 70, 44);
        [btnCancle setTitle:@"关闭" forState:UIControlStateNormal];
        btnCancle.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnCancle setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btnCancle addTarget:self action:@selector(btnCancleAction) forControlEvents:UIControlEventTouchUpInside];
        [viewPic addSubview:btnCancle];
        UIButton *btnOK = [UIButton buttonWithType:UIButtonTypeCustom];
        btnOK.frame = CGRectMake(ScreenFrame.size.width-70 , 0, 70, 44);
        [btnOK setTitle:@"确定" forState:UIControlStateNormal];
        btnOK.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnOK setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btnOK addTarget:self action:@selector(btnOKAction) forControlEvents:UIControlEventTouchUpInside];
        [viewPic addSubview:btnOK];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  imageG.hidden=YES;

}
-(void)createBottom
{
    UIView * bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, ScreenFrame.size.height-108-16, ScreenFrame.size.width, 60)];
    bottomView.backgroundColor=UIColorFromRGB(0XE7E7E7);
    [self.view addSubview:bottomView];
    CALayer * bottomLayer=[bottomView layer];
    bottomLayer.borderColor=[UIColorFromRGB(0XDCDCDC) CGColor];
    bottomLayer.borderWidth=1.1f;
    // 加入购物车按钮
    UIButton *btnAddShopCar = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAddShopCar.frame = CGRectMake(40, 8, ScreenFrame.size.width-80, 44);
    
    btnAddShopCar.backgroundColor =UIColorFromRGB(0xf15353);
    
    CALayer *lay3 = btnAddShopCar.layer;
    [lay3 setMasksToBounds:YES];
    [lay3 setCornerRadius:4.0f];
    [btnAddShopCar setTitle:@"确定" forState:UIControlStateNormal];
    btnAddShopCar.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [btnAddShopCar addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btnAddShopCar];

}
-(void)rightClick
{
 [self signAction];
 
}
-(void)btnCancleAction{
    pickerBgView.hidden = YES;
    leftStr = @"";
    rightStr = @"";
}
-(void)btnOKAction{
    pickerBgView.hidden = YES;
    
    if (leftStr.length == 0 && rightStr.length == 0) {
        
        if (selfBring==NO) {
            
            timeStr = [NSString stringWithFormat:@"%@ %@",[pickerDataLeft objectAtIndex:0],[pickerDataRight objectAtIndex:0]];
            
        }else if (selfBring==YES)
        {
        _SelfTimeStr= [NSString stringWithFormat:@"%@ %@",[pickerDataLeft objectAtIndex:0],[pickerDataRight objectAtIndex:0]];
        
        }
       
    }else if (leftStr.length == 0){
        if (selfBring==NO) {

        timeStr = [NSString stringWithFormat:@"%@ %@",[pickerDataLeft objectAtIndex:0],rightStr];
        }else if (selfBring==YES)
        {
            _SelfTimeStr= [NSString stringWithFormat:@"%@ %@",[pickerDataLeft objectAtIndex:0],rightStr];
            
        }
        
        
    }else if (rightStr.length == 0){
        if (selfBring==NO) {
            

        timeStr = [NSString stringWithFormat:@"%@ %@",leftStr,[pickerDataRight objectAtIndex:0]];
        }else if (selfBring==YES)
        {
            _SelfTimeStr= [NSString stringWithFormat:@"%@ %@",leftStr,[pickerDataRight objectAtIndex:0]];
            
        }
    }else{
        
         if (selfBring==NO) {
        
        timeStr = [NSString stringWithFormat:@"%@ %@",leftStr,rightStr];
         }else if (selfBring==YES)
         {
             _SelfTimeStr= [NSString stringWithFormat:@"%@ %@",leftStr,rightStr];
             
         }

    }
    
    [MyTableView222 reloadData];
}
-(void)createDataPicker{
    
}

#pragma mark Picker Data Source Methods
//设置pickerView的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

//设置每列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    if (component == 0)
        return pickerDataLeft.count;
    return pickerDataRight.count;
}

//设置每行每列的内容
#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    if (component == 0){
        if ([pickerDataLeft count] != 0) {
            return [pickerDataLeft objectAtIndex:row];
        }
    }else{
        if ([pickerDataRight count] != 0) {
            return [pickerDataRight objectAtIndex:row];
        }
    }
    return @"";
}
-(void) pickerView: (UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent: (NSInteger)component{
    if (component == 0) {
        leftStr = [pickerDataLeft objectAtIndex:row];
    }else{
        rightStr = [pickerDataRight objectAtIndex:row];
    }
}
#pragma mark - 网络
-(void)netTime_request{
    request_Time = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,GOODS_CART2_URL] setKey:nil setValue:nil];
    [request_Time setDidFailSelector:@selector(requestFaild:)];
    [request_Time setDidFinishSelector:@selector(requestTimeSuccess:)];
    request_Time.delegate = self;
    [request_Time startAsynchronous];
}
-(void)requestFaild:(ASIFormDataRequest *)request{
    NSLog(@"失败");
}
-(void)requestTimeSuccess:(ASIFormDataRequest *)request{
    if ([request responseStatusCode] == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"requestTimeSuccess:%@",dicBig);
        
        [pickerDataLeft removeAllObjects];
        
        if (dicBig) {
            pickerDataLeft = [dicBig objectForKey:@"day_list"];
            
            [pickerview reloadAllComponents];
        }
    }else{
        NSLog(@"=====!200");
    }
}

-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"2dicBig:%@",dicBig);
        if(dicBig){
            if ([[dicBig objectForKey:@"can_pay"] intValue] == 1) {
                [zhifufangshiDataarray addObject:@"货到付款"];
            }else{
                [zhifufangshiDataarray addObject:@"000"];
            }
        }
    }else{
        NSLog(@"报错");
    }
    NSLog(@"222");
    [MyTableView222 reloadData];
    NSLog(@"333");
    [SYObject endLoading];
}

-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)my2_urlRequestSucceeded:(ASIFormDataRequest *)request{
    ThirdViewController *third = [ThirdViewController sharedUserDefault];
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        if (zhifufangshiDataarray.count!=0) {
            [zhifufangshiDataarray removeAllObjects];
        }
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if(dicBig){
            if ([[dicBig objectForKey:@"can_pay"] intValue] == 1) {
                [zhifufangshiDataarray addObject:@"货到付款"];
                third.pay = @"货到付款";
                fangshiFirst =@"货到付款";
                _payMethod.text = fangshiFirst;
                payType = fangshiFirst;
            }
        }
    }
    [MyTableView222 reloadData];
    [SYObject endLoading];
}
-(void)my2_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)mmurlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        //发起时间请求
        [self netTime_request];
        
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"3dicBig:%@",dicBig);
        NSArray *myAA = [dicBig objectForKey:@"trans_list"];
        if (arrayShip.count!=0) {
            [arrayShip removeAllObjects];
        }
        if (peisongArray.count !=0 ) {
            [peisongArray removeAllObjects];
        }
        if (MyDataarray.count!=0) {
            [MyDataarray removeAllObjects];
        }
        if (NewpeisongArray.count!=0) {
            [NewpeisongArray removeAllObjects];
        }
        
        for(NSDictionary *dic in myAA){
            [arrayShip addObject:[[[dic objectForKey:@"transInfo_list"] objectAtIndex:0] objectForKey:@"key"]];
        }
        
        
        MyDataarray = [dicBig objectForKey:@"trans_list"];
        NSArray *arr2 = [dicBig objectForKey:@"trans_list"];
        int i=0;
        for(NSDictionary *dic in arr2){
            [NewpeisongArray addObject:dic];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 120+73*i, 280, 21)];
            label.font = [UIFont systemFontOfSize:11];
            
            label.text =[NSString stringWithFormat:@"订单中的%@件商品，由%@为您发货",[dic objectForKey:@"goods_count"],[dic objectForKey:@"store_name"]];
            [_myscrollview addSubview:label];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
            button.frame =CGRectMake(220, 120+21+73*i, 90, 40);
            button.tag = i+500;
            [button setBackgroundImage:[UIImage imageNamed:@"pay_lj"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font  = [UIFont systemFontOfSize:17];
            [_myscrollview addSubview:button];
            
            UIImageView *imagePic = [[UIImageView alloc]initWithFrame:CGRectMake(20, 120+21+73*i, 50, 50)];
            NSArray *ar  = [dic objectForKey:@"goods_list"];
            
            [imagePic sd_setImageWithURL:(NSURL*)[ar objectAtIndex:0] placeholderImage:[UIImage imageNamed:@"kong"]];
            [_myscrollview addSubview:imagePic];
            
            fei= [[UILabel alloc]initWithFrame:CGRectMake(220, 120+21+73*i, 90, 40)];
            fei.font = [UIFont systemFontOfSize:15];
            fei.textColor = [UIColor grayColor];
            fei.tag = i+500;
            fei.textAlignment = NSTextAlignmentCenter;
            NSArray *arrList = [dic objectForKey:@"transInfo_list"];
            fei.text =[NSString stringWithFormat:@"%@",[[arrList objectAtIndex:0] objectForKey:@"key"]];
            [_myscrollview addSubview:fei];
            
            i++;
            ClassifyModel *claaa =[[ClassifyModel alloc]init];
            claaa.peisongstore_name =[dic objectForKey:@"store_name"];
            claaa.peisongList =  [dic objectForKey:@"transInfo_list"];
            claaa.peisongstore_id = [dic objectForKey:@"store_id"];
            claaa.peisonggoods_list = [dic objectForKey:@"goods_list"];
            
            [peisongArray addObject:claaa];
        }
        _quedingBtn.frame = CGRectMake(125, 120+21+73*(i-1)+45, 70, 33);
        [_quedingBtn addTarget:self action:@selector(quedingBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_myscrollview addSubview:_quedingBtn];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(125, 120+21+73*(i-1)+45, 70, 33)];
        label.font = [UIFont systemFontOfSize:17];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.text =[NSString stringWithFormat:@"确定"];
        [_myscrollview addSubview:label];
        scrollViewHeight = 120+21+55*(i-1)+45+50;
        CGSize newSize = CGSizeMake(ScreenFrame.size.width,scrollViewHeight);
        [_myscrollview setContentSize:newSize];
        
        youfei = [[NSMutableArray alloc]init];
        value_money  = [[NSMutableArray alloc]init];
        
        //为了得到当他没有点击配送cell时得到的默认的那个配送方式
        for(int i=0;i<peisongArray.count;i++){
            ClassifyModel *cla2 = [peisongArray objectAtIndex:i];
            NSString *str = [NSString stringWithFormat:@"%@:%@",cla2.peisongstore_name,[[cla2.peisongList objectAtIndex:0] objectForKey:@"key"]];
            [youfei addObject:str];
            NSString *str2 = [NSString stringWithFormat:@"%@",[[cla2.peisongList objectAtIndex:0] objectForKey:@"value"]];
            [value_money addObject:str2];
        }
        [MyTableView222 reloadData];
    }
    [SYObject endLoading];
}
-(void)mmurlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}


-(void)quedingBtnClick{
    
}

-(void)createBackBtn{
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(signAction)];
//    [self.navigationItem setRightBarButtonItem:leftButton animated:YES];
    
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}

-(void)signAction{
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    if (payType.length == 0) {
        [SYObject endLoading];
        [SYObject failedPrompt:@"请选择支付方式"];
    }else{
        //说明他没有点击请选择支付方式
        if (sinceComeTag == YES && [_addressStr isEqualToString:@"点击选择自提点"]) {
            [SYObject endLoading];
            [SYObject failedPrompt:@"请选择自提点"];
        }else{
            if (btnTag == 0 ) {
                NSString *tran;
                NSString *ship;
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                for(int i=0;i<peisongArray.count;i++){
                    ClassifyModel *cla2 = [peisongArray objectAtIndex:i];
                    if (tran.length ==0) {
                        tran = [[cla2.peisongList objectAtIndex:0] objectForKey:@"key"];
                    }else{
                        tran = [NSString stringWithFormat:@"%@,%@",tran,[[cla2.peisongList objectAtIndex:0] objectForKey:@"key"]];
                    }
                    if (ship.length ==0) {
                        ship = [NSString stringWithFormat:@"%@",[[cla2.peisongList objectAtIndex:0] objectForKey:@"value"]];
                    }else{
                        ship = [NSString stringWithFormat:@"%@,%@",tran,[[cla2.peisongList objectAtIndex:0] objectForKey:@"value"]];
                    }
                    
                    NSString *str = [NSString stringWithFormat:@"%@:%@",cla2.peisongstore_name,[[cla2.peisongList objectAtIndex:0] objectForKey:@"key"]];
                    [arr addObject:str];
                }
                th.trans = tran;
                th.ship_price = ship;
                NSInteger youfeiMoney = 0;
                NSString *str;
                for(int i=0;i<arr.count;i++){
                    NSArray *arrmy = [[arr objectAtIndex:i] componentsSeparatedByString:@":"];
                    if ([[arrmy objectAtIndex:1] isEqualToString:@"卖家承担"]) {
                    }else if ([[arrmy objectAtIndex:1] isEqualToString:@"商家承担"]) {
                    }else{
                        NSArray *sss = [[arrmy objectAtIndex:1] componentsSeparatedByString:@"["];
                        NSArray *sss2 = [[sss objectAtIndex:1] componentsSeparatedByString:@"."];
                        youfeiMoney = youfeiMoney+[[sss2 objectAtIndex:0] intValue];
                    }
                    if (str.length == 0) {
                        str = [NSString stringWithFormat:@"%@",[arr objectAtIndex:i]];
                    }else{
                        str = [NSString stringWithFormat:@"%@\n%@",str,[arr objectAtIndex:i]];
                    }
                }
                th.wuliu = [NSString stringWithFormat:@"%ld",(long)youfeiMoney];
                th.fee = str;
            }else if (btnTag == 200){
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                NSString *tran;
                NSString *ship;
                for(int i=0;i<peisongArray.count;i++){
                    ClassifyModel *cla2 = [peisongArray objectAtIndex:i];
                    if (tran.length ==0) {
                        tran = [[cla2.peisongList objectAtIndex:0] objectForKey:@"key"];
                    }else{
                        tran = [NSString stringWithFormat:@"%@,%@",tran,[[cla2.peisongList objectAtIndex:0] objectForKey:@"key"]];
                    }
                    
                    if (ship.length ==0) {
                        ship = [NSString stringWithFormat:@"%@",[[cla2.peisongList objectAtIndex:0] objectForKey:@"value"]];
                    }else{
                        ship = [NSString stringWithFormat:@"%@,%@",tran,[[cla2.peisongList objectAtIndex:0] objectForKey:@"value"]];
                    }
                    
                    NSString *str = [NSString stringWithFormat:@"%@:%@",cla2.peisongstore_name,[[cla2.peisongList objectAtIndex:0] objectForKey:@"key"]];
                    [arr addObject:str];
                }
                NSInteger youfeiMoney = 0;
                NSString *str;
                for(int i=0;i<arr.count;i++){
                    NSArray *arrmy = [[arr objectAtIndex:i] componentsSeparatedByString:@":"];
                    if ([[NSString stringWithFormat:@"%@",[arrmy objectAtIndex:1]] isEqualToString:@"卖家承担"]) {
                    }else if ([[NSString stringWithFormat:@"%@",[arrmy objectAtIndex:1]] isEqualToString:@"商家承担"]) {
                        
                    }else{
                        NSArray *sss = [[arrmy objectAtIndex:1] componentsSeparatedByString:@"["];
                        NSArray *sss2 = [[sss objectAtIndex:1] componentsSeparatedByString:@"."];
                        youfeiMoney = youfeiMoney+[[sss2 objectAtIndex:0] intValue];
                    }
                    if (str.length == 0) {
                        str = [NSString stringWithFormat:@"%@",[arr objectAtIndex:i]];
                    }else{
                        str = [NSString stringWithFormat:@"%@\n%@",str,[arr objectAtIndex:i]];
                    }
                }
                th.ship_price =ship;
                th.trans = tran;
                th.wuliu = [NSString stringWithFormat:@"%ld",(long)youfeiMoney];
                th.fee = str;
            }else {
                //这里判断是否选择自提点 默认的是不使用
                
                NSString *tran;
                NSInteger youfeiMoney = 0;
                NSString *str;
                NSString *ship;
                for(int i=0;i<youfei.count;i++){
                    NSArray *arrmy = [[youfei objectAtIndex:i] componentsSeparatedByString:@":"];
                    if ([[NSString stringWithFormat:@"%@",[arrmy objectAtIndex:1]] isEqualToString:@"卖家承担"]) {
                        
                    }else if ([[NSString stringWithFormat:@"%@",[arrmy objectAtIndex:1]] isEqualToString:@"商家承担"]) {
                        
                    }else{
                        NSArray *sss = [[arrmy objectAtIndex:1] componentsSeparatedByString:@"["];
                        NSArray *sss2 = [[sss objectAtIndex:1] componentsSeparatedByString:@"."];
                        youfeiMoney = youfeiMoney+[[sss2 objectAtIndex:0] intValue];
                    }
                    if (tran.length ==0) {
                        tran = [arrmy objectAtIndex:1];
                    }else{
                        tran = [NSString stringWithFormat:@"%@,%@",tran,[arrmy objectAtIndex:1]];
                    }
                    if (str.length == 0) {
                        str = [NSString stringWithFormat:@"%@",[youfei objectAtIndex:i]];
                    }else{
                        str = [NSString stringWithFormat:@"%@\n%@",str,[youfei objectAtIndex:i]];
                    }
                }
                for(int i=0;i<value_money.count;i++){
                    if (ship.length ==0) {
                        ship = [NSString stringWithFormat:@"%@",[value_money objectAtIndex:i]];
                    }else{
                        ship = [NSString stringWithFormat:@"%@,%@",ship,[value_money objectAtIndex:i]];
                    }
                }
                
                th.ship_price = ship;
                th.trans = tran;
                th.fee =  str;
                th.xuanzeyoufei = youfeiMoney;
                th.wuliu = [NSString stringWithFormat:@"%ld",(long)youfeiMoney];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
-(void)backBtnClicked{
    //[self signAction];
    ThirdViewController *third  = [ThirdViewController sharedUserDefault];
    third.pay = @"请选择支付方式";
    third.fee =  @"请选择配送方式";
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createBackBtn];
    NewpeisongArray = [[NSMutableArray alloc]init];
    arrayShip = [[NSMutableArray alloc]init];
    
    pickerDataLeft = [[NSMutableArray alloc]init];
    pickerDataRight = [[NSMutableArray alloc]init];
    [pickerDataRight addObject:@"9:00-15:00"];
    [pickerDataRight addObject:@"15:00-19:00"];
    [pickerDataRight addObject:@"19:00-22:00"];
    
    peisongArray = [[NSMutableArray alloc]init];
    MyDataarray = [[NSMutableArray alloc]init];
    zhifufangshiDataarray = [[NSMutableArray alloc]init];
    
    arr222 = [[NSMutableArray alloc]init];
    arr333 = [[NSMutableArray alloc]init];
    timeTag = 2;
    timeStr = @"点击选择时间";
    // Do any additional setup after loading the view from its nib.
    sinceComeTag = NO;
    _addressStr = @"点击选择自提点";
    _SelfTimeStr = @"请选择自提时间";
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    arr222 = nil;
    arr333 = nil;
    peisongArray = nil;
    fei = nil;
    youfei = nil;
    value_money = nil;
    imageG = nil;
    _myscrollview = nil;
    _MyTableView = nil;
    _quedingBtn = nil;
    _payBtn = nil;
    _payMethod = nil;
    _queding = nil;
    
    
}
-(void)dealloc {
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    arr222 = nil;
    arr333 = nil;
    peisongArray = nil;
    fei = nil;
    youfei = nil;
    value_money = nil;
    imageG = nil;
    _myscrollview = nil;
    _MyTableView = nil;
    _quedingBtn = nil;
    _payBtn = nil;
    _payMethod = nil;
    _queding = nil;
}
-(void)timeBtnCLicked:(UIButton *)btn{
    if (btn.tag == 100) {
        timeTag = 0;
        pickerBgView.hidden = NO;
        selfBring=NO;
    }
    if (btn.tag == 101) {
        timeTag = 1;
    }
    if (btn.tag == 102) {
        timeTag = 2;
    }
    [MyTableView222 reloadData];
}

#pragma mark - tabelView方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == MyTableView222) {
        return 1;
    }else{
        if (NewpeisongArray.count!=0) {
            NSDictionary *cl = [NewpeisongArray objectAtIndex:btnTag-500];
            return [[cl objectForKey:@"transInfo_list"] count]+1;
        }
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == MyTableView222) {
        if (sinceComeTag == NO) {
            return 166+134*MyDataarray.count+44+44*4+16-16-40;
        }else{
            return 166+134*MyDataarray.count+44+44*6+16;
        }
        
    }else{
        return 30;
    }
    return 30;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == MyTableView222) {
        NilCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NilCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (MyDataarray.count!=0) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, 44)];
            label.text = @"支付方式:";
            label.textColor = UIColorFromRGB(0X6b6b6b);
            label.font = [UIFont systemFontOfSize:15];
            [cell addSubview:label];
            if (zhifufangshiDataarray.count!=0) {
                for(int i=0;i<zhifufangshiDataarray.count;i++){
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
                    button.frame =CGRectMake(20+106*i, 44, 86, 36);
                    [button.layer setMasksToBounds:YES];
                    [button.layer setCornerRadius:4.0];
                    button.layer.borderColor = [UIColorFromRGB(0Xefefef) CGColor];
                    button.layer.borderWidth = 0.5;
                    [button setTitleColor:UIColorFromRGB(0X7d7f80) forState:UIControlStateNormal];
                    button.tag = 500+i;
                    [button setTitle:[zhifufangshiDataarray objectAtIndex:i] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(btn500Clicked:) forControlEvents:UIControlEventTouchUpInside];
                    if (paypayTag == i) {
                        button.layer.borderColor = [UIColorFromRGB(0Xf15353) CGColor];
                        [button setTitleColor:UIColorFromRGB(0Xf15353) forState:UIControlStateNormal];
                    }
                    button.titleLabel.font  = [UIFont systemFontOfSize:15];
                    [cell addSubview:button];
                    if (i==1) {
                        if ([[zhifufangshiDataarray objectAtIndex:i] isEqualToString:@"000"]) {
                            button.hidden = YES;
                            UILabel *labeTTT = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, 180, 44)];
                            labeTTT.text = @"该订单部分商品不支持货到付款。";
                            labeTTT.backgroundColor = [UIColor clearColor];
                            labeTTT.textColor = MY_COLOR;
                            labeTTT.font = [UIFont systemFontOfSize:12];
                            [cell addSubview:labeTTT];
                        }
                    }
                }
            }
            
            UIImageView *imageLL = [[UIImageView alloc]initWithFrame:CGRectMake(0, 90, ScreenFrame.size.width, 16)];
            imageLL.backgroundColor = RGB_COLOR(246, 246, 246);
            [cell addSubview:imageLL];
            
            UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 106, 80, 44)];
            label2.text = @"配送方式:";
            label2.textColor = UIColorFromRGB(0X6b6b6b);
            label2.font = [UIFont systemFontOfSize:15];
            [cell addSubview:label2];
            
            for(int i=0;i<MyDataarray.count;i++ ){
                NSDictionary *dic = [MyDataarray objectAtIndex:i];
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 150+134*i, ScreenFrame.size.width-40, 30)];
                label.font = [UIFont systemFontOfSize:12];
                label.textColor = [UIColor lightGrayColor];
                label.text =[NSString stringWithFormat:@"订单中的%@件商品，由%@为您发货",[dic objectForKey:@"goods_count"],[dic objectForKey:@"store_name"]];
                [cell addSubview:label];
                
                UIScrollView *_myscrollview2 = [[UIScrollView alloc]initWithFrame:CGRectMake(20, 180+134*i, ScreenFrame.size.width-30, 60)];
                _myscrollview2.showsHorizontalScrollIndicator = NO;
                _myscrollview2.bounces = YES;
                _myscrollview2.delegate = self;
                _myscrollview2.userInteractionEnabled = YES;
                CGSize newSize = CGSizeMake(ScreenFrame.size.width-30,60);
                [_myscrollview2 setContentSize:newSize];
                [cell addSubview:_myscrollview2];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
                button.frame =CGRectMake(20, 245+134*i, 90, 34);
                button.tag = i+500;
                [button.layer setMasksToBounds:YES];
                [button.layer setCornerRadius:4.0];
                [button setTitle:[arrayShip objectAtIndex:i] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(buttonBackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
                [button addTarget:self action:@selector(buttonBackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
                button.titleLabel.font = [UIFont systemFontOfSize:14];
                button.backgroundColor = [UIColor orangeColor];
                
                [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:button];
                
                NSArray *array = (NSArray *)[dic objectForKey:@"goods_list"];
                [_myscrollview2 setContentSize:CGSizeMake(70*array.count,60)];
                for(int j=0;j<array.count;j++){
                    UIImageView *imagePic = [[UIImageView alloc]initWithFrame:CGRectMake(70*j, 0, 60, 60)];
                    imagePic.backgroundColor = [UIColor whiteColor];
                    [imagePic sd_setImageWithURL:(NSURL*)[array objectAtIndex:j] placeholderImage:[UIImage imageNamed:@"kong"]];
                    [_myscrollview2 addSubview:imagePic];
                }
                fei= [[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-105, 154+21+73*i, 90, 34)];
                fei.font = [UIFont systemFontOfSize:15];
                fei.textColor = [UIColor grayColor];
                fei.tag = i+500;
                fei.backgroundColor = [UIColor orangeColor];
                fei.textAlignment = NSTextAlignmentCenter;
                NSArray *arrList = [dic objectForKey:@"transInfo_list"];
                fei.text =[NSString stringWithFormat:@"%@",[[arrList objectAtIndex:0] objectForKey:@"key"]];
                NSLog(@"feifeifei:%@",fei);
                [_myscrollview2 addSubview:fei];
            }
            
            UIImageView *imageLL2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 150+134*MyDataarray.count, ScreenFrame.size.width, 16)];
            imageLL2.backgroundColor = RGB_COLOR(246, 246, 246);
            [cell addSubview:imageLL2];
            
            //选择配送时间
            UILabel *shiplabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 166+134*MyDataarray.count, ScreenFrame.size.width-40, 44)];
            shiplabel.font = [UIFont systemFontOfSize:15];
            shiplabel.textColor = UIColorFromRGB(0X6b6b6b);
            shiplabel.text =@"配送时间";
            [cell addSubview:shiplabel];
            UIImageView *imageLL3 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 166+134*MyDataarray.count+44, ScreenFrame.size.width-15, 0.5)];
            imageLL3.backgroundColor = [UIColor lightGrayColor];
            [cell addSubview:imageLL3];
            
            UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 166+134*MyDataarray.count+44+44*0, 40, 40)];
            [cell addSubview:image1];
            UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 166+134*MyDataarray.count+44+44*1, 40, 40)];
            [cell addSubview:image2];
            UIImageView *image3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 166+134*MyDataarray.count+44+44*2, 40, 40)];
            [cell addSubview:image3];
            
            if(timeTag == 0){
                image1.image = [UIImage imageNamed:@"checkbox_yes"];
                image2.image = [UIImage imageNamed:@"checkbox_no"];
                image3.image = [UIImage imageNamed:@"checkbox_no"];
            }else if (timeTag == 1){
                image1.image = [UIImage imageNamed:@"checkbox_no"];
                image2.image = [UIImage imageNamed:@"checkbox_yes"];
                image3.image = [UIImage imageNamed:@"checkbox_no"];
            }else{
                image1.image = [UIImage imageNamed:@"checkbox_no"];
                image2.image = [UIImage imageNamed:@"checkbox_no"];
                image3.image = [UIImage imageNamed:@"checkbox_yes"];
            }
            
            UILabel *shiplabel2 = [[UILabel alloc]initWithFrame:CGRectMake(64, 166+134*MyDataarray.count+44+44*0, ScreenFrame.size.width-74-30, 44)];
            shiplabel2.font = [UIFont systemFontOfSize:13];
            shiplabel2.text = timeStr;
            shiplabel2.textColor = [UIColor darkGrayColor];
            shiplabel2.textAlignment = NSTextAlignmentRight;
            [cell addSubview:shiplabel2];
            UIImageView *imageCanlner = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-12-24, 166+134*MyDataarray.count+44+44*0+10, 24, 24)];
            imageCanlner.image = [UIImage imageNamed:@"Calendar"];
            [cell addSubview:imageCanlner];
            
            NSArray *arr = [NSArray arrayWithObjects:@"指定配送时间",@"工作日、双休日、法定节假日均可配送",@"工作日9点-18点可配送", nil];
            for(int i=0;i<3;i++){
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(0, 166+134*MyDataarray.count+44+44*i, ScreenFrame.size.width, 44);
                btn.tag = 100+i;
                [cell addSubview:btn];
                [btn addTarget:self action:@selector(timeBtnCLicked:) forControlEvents:UIControlEventTouchUpInside];
                UILabel *shiplabel1 = [[UILabel alloc]initWithFrame:CGRectMake(44, 166+134*MyDataarray.count+44+44*i, ScreenFrame.size.width-40, 44)];
                shiplabel1.font = [UIFont systemFontOfSize:13];
                shiplabel1.text =[arr objectAtIndex:i];
                shiplabel1.textColor = [UIColor grayColor];
                [cell addSubview:shiplabel1];
            }
            
//            UIImageView *imageLL4 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 166+134*MyDataarray.count+44+44*3, ScreenFrame.size.width-15, 16)];
//            imageLL4.backgroundColor = RGB_COLOR(246, 246, 246);
//            [cell addSubview:imageLL4];
            
            //自提点选择
            UIImageView *image4 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 166+134*MyDataarray.count+44+44*3+16, 40, 40)];
            [cell addSubview:image4];
            UILabel *shiplabel6 = [[UILabel alloc]initWithFrame:CGRectMake(45, 166+134*MyDataarray.count+44+44*3+16, ScreenFrame.size.width-40, 44)];
            shiplabel6.font = [UIFont systemFontOfSize:15];
            shiplabel6.text =@"使用自提地点";
            shiplabel6.textColor = UIColorFromRGB(0X6b6b6b);
            [cell addSubview:shiplabel6];
            UIButton *btns1 = [UIButton buttonWithType:UIButtonTypeCustom];
            btns1.frame = CGRectMake(0, 166+134*MyDataarray.count+44+44*3+16, ScreenFrame.size.width/2, 44);
            btns1.tag = 100;
            [cell addSubview:btns1];
            [btns1 addTarget:self action:@selector(sincecomeBtnCLicked:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *btns2 = [UIButton buttonWithType:UIButtonTypeCustom];
            btns2.frame = CGRectMake(0, 166+134*MyDataarray.count+44+44*3+16, ScreenFrame.size.width, 44);
            btns2.tag = 101;
            [cell addSubview:btns2];
            [btns2 addTarget:self action:@selector(sincecomeBtnCLicked:) forControlEvents:UIControlEventTouchUpInside];
            
            //去掉自提点功能
            image4.hidden=YES;
            shiplabel6.hidden=YES;
            btns1.hidden=YES;
            btns2.hidden=YES;
            
            
            scrollH = 88;
            UIView *vvvv = [[UIView alloc]initWithFrame:CGRectMake(0, 166+134*MyDataarray.count+44+44*4+16, ScreenFrame.size.width, scrollH)];
            vvvv.backgroundColor = [UIColor whiteColor];
            [cell addSubview:vvvv];
            UIImageView *imageLL6 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 44, ScreenFrame.size.width-15, 0.5)];
            imageLL6.backgroundColor = [UIColor lightGrayColor];
            [vvvv addSubview:imageLL6];
            UIImageView *imageLL7 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, ScreenFrame.size.width-15, 0.5)];
            imageLL7.backgroundColor = [UIColor lightGrayColor];
            [vvvv addSubview:imageLL7];
            UILabel *shiplabel3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, ScreenFrame.size.width-40, 44)];
            shiplabel3.font = [UIFont systemFontOfSize:15];
            shiplabel3.textColor = [UIColor grayColor];
            shiplabel3.text =@"自提地点";
            [vvvv addSubview:shiplabel3];
            
            UILabel *shiplabel44 = [[UILabel alloc]initWithFrame:CGRectMake(20, 44, ScreenFrame.size.width-40, 44)];
            shiplabel44.font = [UIFont systemFontOfSize:15];
            shiplabel44.textColor = [UIColor grayColor];
            shiplabel44.text =@"自提时间";
            [vvvv addSubview:shiplabel44];
            
            if(sinceComeTag == NO){
                image4.image = [UIImage imageNamed:@"checkbox_no"];
                vvvv.hidden = YES;
            }else{
                image4.image = [UIImage imageNamed:@"checkbox_yes"];
                vvvv.hidden = NO;
            }
            
            UILabel *shiplabel4 = [[UILabel alloc]initWithFrame:CGRectMake(64, 0, ScreenFrame.size.width-90, 44)];
            shiplabel4.font = [UIFont systemFontOfSize:15];
            shiplabel4.text =_addressStr;
            shiplabel4.textColor = UIColorFromRGB(0X323232);
            shiplabel4.textAlignment = NSTextAlignmentRight;
            [vvvv addSubview:shiplabel4];
            
            UILabel *shiplabel45 = [[UILabel alloc]initWithFrame:CGRectMake(64, 44, ScreenFrame.size.width-100, 44)];
            shiplabel45.font = [UIFont systemFontOfSize:15];
            shiplabel45.text =_SelfTimeStr;
            shiplabel45.textColor = UIColorFromRGB(0X323232);
            shiplabel45.textAlignment = NSTextAlignmentRight;
            [vvvv addSubview:shiplabel45];
            
            UIImageView *imageCanlner2 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-8-24, 54, 24, 24)];
            imageCanlner2.image = [UIImage imageNamed:@"Calendar"];
            [vvvv addSubview:imageCanlner2];
            
            UIImageView *imageNext = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-15, 16, 8, 13)];
            imageNext.image = [UIImage imageNamed:@"dis_indicator"];
            [vvvv addSubview:imageNext];
            
            UIButton *buttonDD = [UIButton buttonWithType:UIButtonTypeCustom ];
            buttonDD.frame =CGRectMake(120, 0, ScreenFrame.size.width-120 , 44);
            [buttonDD addTarget:self action:@selector(btnDDClicked) forControlEvents:UIControlEventTouchUpInside];
            [vvvv addSubview:buttonDD];
            
            UIButton *buttonDD2 = [UIButton buttonWithType:UIButtonTypeCustom ];
            buttonDD2.frame =CGRectMake(120, 44, ScreenFrame.size.width-120 , 44);
            [buttonDD2 addTarget:self action:@selector(btnTimeClicked) forControlEvents:UIControlEventTouchUpInside];
            [vvvv addSubview:buttonDD2];
            
            UIImageView *imageLL5 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 166+134*MyDataarray.count+44+44*6+16, ScreenFrame.size.width-15, 16)];
            imageLL5.backgroundColor = RGB_COLOR(246, 246, 246);
            [cell addSubview:imageLL5];
        }
        return cell;
    }else{
        static NSString *cellStr = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"请选择配送方式:";
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
            cell.backgroundColor = UIColorFromRGB(0xf15353);
        }else{
            if (NewpeisongArray.count!=0) {
                NSDictionary *cla = [NewpeisongArray objectAtIndex:btnTag-500];
                cell.textLabel.textColor =[UIColor blackColor];
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                cell.textLabel.text = [[[cla objectForKey:@"transInfo_list"] objectAtIndex:indexPath.row-1] objectForKey:@"key"];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
            }
        }
        UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 30, 200, 0.5)];
        imageLine.backgroundColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1];
        
        [cell addSubview:imageLine];
        
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    return  cell;
}
- (void)buttonBackGroundNormal:(UIButton *)sender
{
    sender.backgroundColor = [UIColor orangeColor];
}
//  button1高亮状态下的背景色
- (void)buttonBackGroundHighlighted:(UIButton *)sender
{
    sender.backgroundColor = UIColorFromRGB(0Xc30909);
}
-(void)sincecomeBtnCLicked:(UIButton *)btn{
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    
    if (btn.tag == 100) {
        sinceComeTag = 0;
        th.delivery_type = @"0";
        th.delivery_id = @"";
    }
    if (btn.tag == 101) {
        if (sinceComeTag == NO) {
            sinceComeTag = YES;
            th.delivery_type = @"1";
            CGPoint p = MyTableView222.contentOffset;
            p.y += scrollH;
            [MyTableView222 setContentOffset:p animated:YES];
        }else{
            sinceComeTag = NO;
            th.delivery_type = @"0";
        }
        
    }
    [MyTableView222 reloadData];
}
-(void)btnDDClicked{
    SinceComeViewController *since = [[SinceComeViewController alloc]init];
    [self.navigationController pushViewController:since animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _MyTableView) {
        if (indexPath.row ==0) {
            
        }else{
            imageG.hidden = YES;
            ThirdViewController *th = [ThirdViewController sharedUserDefault];
            if (btnTag == 200) {
                _payMethod.text = [arr222 objectAtIndex:indexPath.row-1];
                th.pay = _payMethod.text;
                payType =_payMethod.text;
                th.paymark = [arr333 objectAtIndex:indexPath.row-1];
                [MyTableView222 reloadData];
            }else{
                ClassifyModel *cla = [peisongArray objectAtIndex:btnTag-500];
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(221, 120+23+73*(btnTag-500), 88, 36)];
                label.textColor = [UIColor grayColor];
                label.font = [UIFont systemFontOfSize:14];
                label.textAlignment = NSTextAlignmentCenter;
                label.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
                label.text = [[cla.peisongList objectAtIndex:indexPath.row-1] objectForKey:@"key"];
                [_myscrollview addSubview:label];
                [arrayShip replaceObjectAtIndex:btnTag-500 withObject:[[[[MyDataarray objectAtIndex:btnTag-500] objectForKey:@"transInfo_list"] objectAtIndex:indexPath.row-1] objectForKey:@"key"]];
                
                NSString *str = [NSString stringWithFormat:@"%@:%@",cla.peisongstore_name,[[cla.peisongList objectAtIndex:indexPath.row-1] objectForKey:@"key"]];
                [youfei replaceObjectAtIndex:btnTag-500 withObject:str];
                
                NSString *str2 = [NSString stringWithFormat:@"%@",[[cla.peisongList objectAtIndex:indexPath.row-1] objectForKey:@"value"]];
                [value_money replaceObjectAtIndex:btnTag-500 withObject:str2];
                [MyTableView222 reloadData];
            }
        }
    }
}
-(void)btnTimeClicked{
    NSLog(@"点击了字体时间呢");
    pickerBgView.hidden = NO;
    selfBring=YES;
  
}
-(void)btn500Clicked:(UIButton *)btn{
    pickerBgView.hidden = YES;
    if (zhifufangshiDataarray.count!=0) {
        for(int i=0;i<zhifufangshiDataarray.count;i++){
            if (btn.tag -500 == i) {
                paypayTag = btn.tag-500;
                
                ThirdViewController *th = [ThirdViewController sharedUserDefault];
                _payMethod.text = [zhifufangshiDataarray objectAtIndex:i];
                th.pay = [zhifufangshiDataarray objectAtIndex:i];
                payType =[zhifufangshiDataarray objectAtIndex:i];
                th.paymark = @"";
                [MyTableView222 reloadData];
            }
        }
        
    }
}

- (IBAction)btnClicked:(id)sender {
    pickerBgView.hidden = YES;
    
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 200) {
        //做下拉列表
        btnTag = btn.tag;
        imageG.hidden = NO;
        [_MyTableView reloadData];
    }
    if (btn.tag == 201) {

    }
    
    for(int i=0;i<peisongArray.count;i++){
        if (btn.tag == i+500) {
            ClassifyModel *cl = [peisongArray objectAtIndex:i];
            _MyTableView.frame = CGRectMake((ScreenFrame.size.width-200)/2,150,200,30*(cl.peisongList.count+1));
            btnTag = btn.tag;
            imageG.hidden = NO;
            [_MyTableView reloadData];
            [MyTableView222 reloadData];
        }
    }
}
@end
