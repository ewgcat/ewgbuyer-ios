//
//  CurrentRankViewController.m
//  Demo
//
//  Created by 邱炯辉 on 16/5/25.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "CurrentRankViewController.h"
#import "RankView.h"
#import "OnlinePayTypeSelectViewController.h"
#import "FirstViewController.h"
#import "ThirdViewController.h"
#import "FirstViewController.h"
@interface CurrentRankViewController ()<UITextFieldDelegate>
{
    NSMutableArray *_viewArr;
    NSString *currentRank;
    
    ASIFormDataRequest *requestList;
    
    
    NSString *shengjiRank;
    
    

}
@property(nonatomic,copy)NSString *invite_code;

@property(nonatomic,weak)UILabel * inviteLabel;
@property(nonatomic,weak)UILabel * nameLabel;
@property(nonatomic,weak)UIImageView * headImageview;
@property(nonatomic,weak)UILabel * moneyLabel;

@property(nonatomic,assign)BOOL hasUpper;//是否有上级

@property(nonatomic,weak)UILabel *label;
@property (nonatomic,copy)   NSString * current_vip_grade;//当前等级
@property (nonatomic,copy)NSString *up_price_1;//银卡价格
@property (nonatomic,copy)NSString *up_price_2;//金卡价格
@property (nonatomic,copy)NSString *up_price_3;//钻卡价格


@property (nonatomic,copy)NSString *up_price_1_day;//银卡天数
@property (nonatomic,copy)NSString *up_price_2_day;//金卡天数
@property (nonatomic,copy)NSString *up_price_3_day;//钻卡天数


@property (nonatomic,copy)NSString *up_price_1_remind;//银卡一句话
@property (nonatomic,copy)NSString *up_price_2_remind;//金卡一句话
@property (nonatomic,copy)NSString *up_price_3_remind;//钻卡一句话



@end

@implementation CurrentRankViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    NSString *url= [NSString stringWithFormat:@"%@/app/vip_my_parent_info.htm",FIRST_URL];
//    __weak typeof(self) ws=self;
//    NSDictionary *par=@{@"invitation_code":@"xhicjtoy"};
//    [[Requester managerWithHeader]POST:url parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"responseObject==%@",responseObject);
//        NSString *ret=[NSString stringWithFormat:@"%@",responseObject[@"ret"]];
//        
//        if([ret isEqualToString:@"1"]){
//            [ws.headImageview sd_setImageWithURL:[NSURL URLWithString:responseObject[@"photo_url"]]];
//            ws.nameLabel.text=[NSString stringWithFormat:@"姓名:%@",responseObject[@"true_name"]];
//            
//        }else  if([ret isEqualToString:@"-1"]){
//            [SYObject failedPrompt:@"参数为空"];
//        }else  if([ret isEqualToString:@"0"]){
//            [SYObject failedPrompt:@"找不到该邀请码的用户"];
//        }else  if([ret isEqualToString:@"-2"]){
//            [SYObject failedPrompt:@"这个邀请码对应多个用户"];
//        }
//        [SYObject endLoading];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",[error localizedDescription]);
//        [SYObject endLoading];
//        
//    }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    _viewArr=[NSMutableArray array];
    currentRank =@"当前等级";

    self.title=@"VIP升级";
    // Do any additional setup after loading the view.
//    [self createUI];
    [SYObject startLoading];
    [self haveUpper];
//    self.hasUpper=YES;
//
//    [self getUpperData];
}
#pragma mark - 判断是否有上级了
-(void)haveUpper{
    NSString *url= [NSString stringWithFormat:@"%@/app/buyer/buyer_parent_one.htm",FIRST_URL];
    
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    
    NSDictionary *par=@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1]};
    __weak typeof(self) ws=self;
    [[Requester managerWithHeader]POST:url parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject==%@",responseObject);
        
        if ([responseObject[@"ret"] isEqualToString:@"false"]) {
            ws.hasUpper=NO;
        }else if ([responseObject[@"ret"] isEqualToString:@"true"]){//有上级
        
        ws.hasUpper=YES;
            if (responseObject[@"invitation_code"]) {
                ws.invite_code=responseObject[@"invitation_code"];
            }

        }
        
//        [ws getData];
        [ws getUpperData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        [SYObject endLoading];
        
    }];


}
#pragma mark - 获取上级的数据
-(void)getUpperData{
    NSString *url= [NSString stringWithFormat:@"%@/app/vip_my_parent_info.htm",FIRST_URL];
    __weak typeof(self) ws=self;
    NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
    __block NSString *invitecode=nil;

    if ([d valueForKey:@"inviteCode"]!=nil) {
        invitecode=[d valueForKey:@"inviteCode"];
    }else{
        invitecode=self.invite_code;
    }
    if(_invite_code){
        invitecode=_invite_code;

    }
    NSDictionary *par=nil;

    if (invitecode) {
        par=@{@"invitation_code":invitecode};
    }else{
        [SYObject endLoading];
        
        return;
    }
    [[Requester managerWithHeader]POST:url parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject==%@",responseObject);
        NSString *ret=[NSString stringWithFormat:@"%@",responseObject[@"ret"]];
        NSLog(@"true_nametrue_name=%@",responseObject[@"true_name"]);
        
        if([ret isEqualToString:@"1"]){
            [ws.headImageview sd_setImageWithURL:[NSURL URLWithString:responseObject[@"photo_url"]]];
            ws.nameLabel.text=[NSString stringWithFormat:@"姓名:%@",responseObject[@"true_name"]];
            
            
            NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
            [d setObject:responseObject[@"photo_url"] forKey:@"photo_url"];
            [d setObject:responseObject[@"true_name"] forKey:@"true_name"];
            [d setObject:invitecode forKey:@"inviteCode"];
            
            
            [d synchronize];
            

        }else  if([ret isEqualToString:@"-1"]){
            [SYObject failedPrompt:@"参数为空"];
        }else  if([ret isEqualToString:@"0"]){
            [SYObject failedPrompt:@"找不到该邀请码的用户"];
        }else  if([ret isEqualToString:@"-2"]){
            [SYObject failedPrompt:@"这个邀请码对应多个用户"];
        }
        [ws getData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        [SYObject endLoading];
        
    }];
}
#pragma mark -获取价格等信息
-(void)getData{
    NSString *url= [NSString stringWithFormat:@"%@/app/buyer/vip_level_up.htm",FIRST_URL];
    
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    
    NSDictionary *par=@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1]};
    __weak typeof(self) ws=self;
    [[Requester managerWithHeader]POST:url parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject==%@",responseObject);
        
        if ([responseObject[@"ret"] isEqualToString:@"1"]) {
            ws.current_vip_grade=responseObject[@"current_vip_grade"];
            ws.up_price_1=responseObject[@"up_price_1"];
            ws.up_price_2=responseObject[@"up_price_2"];
            ws.up_price_3=responseObject[@"up_price_3"];
            
            
            ws.up_price_1_day=responseObject[@"up_price_1_day"];
            ws.up_price_2_day=responseObject[@"up_price_2_day"];
            ws.up_price_3_day=responseObject[@"up_price_3_day"];
            
            
            ws.up_price_1_remind=responseObject[@"up_price_1_remind"];
            ws.up_price_2_remind=responseObject[@"up_price_2_remind"];
            ws.up_price_3_remind=responseObject[@"up_price_3_remind"];
            
            
            
            [ws createUI];
        }else if ([responseObject[@"ret"] isEqualToString:@"-1"]){
            [SYObject failedPrompt:@"请激活VIP"];
        
        }else if ([responseObject[@"ret"] isEqualToString:@"-3"]){
            [SYObject failedPrompt:@"vip服务已被禁用"];
        
        }
              [SYObject endLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        [SYObject endLoading];
        
    }];

    
}


-(UIView *)createHeaderUI{
    UIView *topview=[[UIView alloc]init];
    
    
    int margin=15;
    UILabel *la1 =[[UILabel alloc]initWithFrame:CGRectMake(margin, 25 ,ScreenFrame.size.width-margin*2, 40)];
    la1.font=[UIFont systemFontOfSize:14];
    la1.textColor=[UIColor blackColor];
    la1.layer.borderWidth=0.5;
    la1.layer.borderColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5].CGColor;
    la1.text=@"  推荐人用户信息";
    la1.backgroundColor=[UIColor whiteColor];
    [topview addSubview:la1];
    
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(margin, CGRectGetMaxY(la1.frame)-0.5, ScreenFrame.size.width-margin*2, 60)];
    bottomView.backgroundColor=[UIColor whiteColor];
    bottomView.layer.borderWidth=0.5;
    bottomView.layer.borderColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5].CGColor;
    
    NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
    
    NSString *inviteCode= [d valueForKey:@"inviteCode"];
    NSString *photo_url= [d valueForKey:@"photo_url"];
    NSString *true_name= [d valueForKey:@"true_name"];
    
    UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
    imageview.backgroundColor=[UIColor yellowColor];
    [imageview sd_setImageWithURL:[NSURL URLWithString:photo_url]];
    imageview.layer.cornerRadius=25;
    imageview.layer.masksToBounds=YES;
    [bottomView addSubview:imageview];
    
    
    UILabel *la2 =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame)+10 , 5 ,100, 20)];
    la2.font=[UIFont systemFontOfSize:17];
    la2.textColor=[UIColor blackColor];
    la2.text=[NSString stringWithFormat:@"姓名:%@",true_name]; ;
    self.nameLabel=la2;
    [bottomView addSubview:la2];
    
    UILabel *la3 =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame)+10 , CGRectGetMaxY(la2.frame)+5 ,200, 20)];
    la3.font=[UIFont systemFontOfSize:17];
    la3.textColor=[UIColor blackColor];
    la3.text=[NSString stringWithFormat:@"邀请码:%@",inviteCode];
    [bottomView addSubview:la3];
    
    [topview addSubview:bottomView];
    
    topview.frame=CGRectMake(0, CGRectGetMaxY(self.label.frame), ScreenFrame.size.width, CGRectGetMaxY(bottomView.frame)+5);
  
    return topview;
    
}

-(void)createUI{
    
    
    UIScrollView *scrollview=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:scrollview];
    
    if (_hasUpper==NO) {//如果没有上级
        UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(30, 10, 100, 40)];
        label1.font=[UIFont systemFontOfSize:15];
        label1.textAlignment= NSTextAlignmentLeft;
        label1.text=@"推荐人邀请码";
        self.label=label1;
        [scrollview addSubview:label1];
        
        UITextField *tf1=[[UITextField alloc]initWithFrame:CGRectMake(140, 17, ScreenFrame.size.width-140-80, 25)];
        tf1.layer.borderWidth=0.5;
        tf1.layer.borderColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5].CGColor;
        tf1.layer.cornerRadius=3;
        tf1.delegate=self;
        [scrollview addSubview:tf1];
        
        UIButton *searchBut=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tf1.frame)+5, 17, 40, 25)];
        [searchBut setTitle:@"搜索" forState:UIControlStateNormal];
        searchBut.layer.cornerRadius=4;
        searchBut.layer.masksToBounds=YES;
        searchBut.titleLabel.font=[UIFont systemFontOfSize:15];
        
        searchBut.backgroundColor=[UIColor redColor];
        [scrollview addSubview:searchBut];
        

    }
    UIView *headerUI=[self createHeaderUI];
    [scrollview addSubview:headerUI];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(headerUI.frame), ScreenFrame.size.width-20*2, 40)];
    label.font = [UIFont boldSystemFontOfSize:19];
    label.textAlignment= NSTextAlignmentCenter;
    
    if ([_current_vip_grade isEqualToString:@"GENERAL"]) {
        label.text=@"当前等级:普通会员";

    }else if ([_current_vip_grade isEqualToString:@"SILVER"]){
        label.text=@"当前等级:银卡会员";

    }else if ([_current_vip_grade isEqualToString:@"GOLD"]){
        label.text=@"当前等级:金卡会员";
        
    }else if ([_current_vip_grade isEqualToString:@"DIAMOND"]){
        label.text=@"当前等级:钻卡会员";
        
    }
    [scrollview addSubview:label];
    
    UILabel *chooselabel=[[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(label.frame)+ 20, ScreenFrame.size.width-30*2, 40)];
    chooselabel.textAlignment= NSTextAlignmentLeft;
    chooselabel.text=@"请选择升级级别:";
    [scrollview addSubview:chooselabel];
    
    
//    int width=80;
//    int margin=(ScreenFrame.size.width-width*3)/4;
//    int  height=160;
    
    int margin=10;
    int width=(ScreenFrame.size.width-10*4)/3;

    int  height=width*2;
    RankView * rankview=[[RankView alloc]initWithFrame:CGRectMake(margin, CGRectGetMaxY(chooselabel.frame),width, height)];
    rankview.imageView.image =[UIImage imageNamed:@"lv-s.jpg"];

    rankview.rankStr=@"银卡会员";
    rankview.moneyStr=[NSString stringWithFormat:@"¥%@元",_up_price_1];
    


    
    rankview.tag = 111;
    [rankview.tap addTarget:self action:@selector(tap:)];



    NSLog(@"attachmentStr==%@",rankview.attachmentStr);
    
//    rankview.backgroundColor= [UIColor redColor];
    [scrollview addSubview:rankview];
    
    RankView * rankview2=[[RankView alloc]initWithFrame:CGRectMake(margin*2+width, CGRectGetMaxY(chooselabel.frame), width, height)];
    rankview2.imageView.image =[UIImage imageNamed:@"lv-g.jpg"];

    rankview2.rankStr=@"金卡会员";
    rankview2.moneyStr=@"¥200元";
    rankview2.tag = 222;
    [rankview2.tap addTarget:self action:@selector(tap:)];
    [scrollview addSubview:rankview2];
    rankview2.moneyStr=[NSString stringWithFormat:@"¥%@元",_up_price_2];

    
    
    RankView * rankview3=[[RankView alloc]initWithFrame:CGRectMake(margin*3+width*2, CGRectGetMaxY(chooselabel.frame),width, height)];
    rankview3.imageView.image =[UIImage imageNamed:@"lv-d.jpg"];

    rankview3.rankStr=@"钻卡会员";
    rankview3.moneyStr=@"¥300元";
    rankview3.tag = 333;
    [rankview3.tap addTarget:self action:@selector(tap:)];

//    rankview3.backgroundColor= [UIColor redColor];
    [scrollview addSubview:rankview3];
    rankview3.moneyStr=[NSString stringWithFormat:@"¥%@元",_up_price_3];

    
    [_viewArr addObject:rankview];
    [_viewArr addObject:rankview2];
    [_viewArr addObject:rankview3];

    

    scrollview.contentSize=CGSizeMake(ScreenFrame.size.width, CGRectGetMaxY(rankview3.frame)+60);


    
#pragma mark - 底部的界面
    UILabel *moneyLabel=[[UILabel alloc]init];
    moneyLabel.frame=CGRectMake(0, scrollview.size.height-45, ScreenFrame.size.width-100, 45);
    moneyLabel.font=[UIFont systemFontOfSize:14];
    moneyLabel.textColor=[UIColor orangeColor];
    moneyLabel.textAlignment=NSTextAlignmentCenter;
    self.moneyLabel=moneyLabel;
    moneyLabel.layer.borderColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5].CGColor;
    moneyLabel.layer.borderWidth=0.5;
    moneyLabel.backgroundColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0 ];
    [self.view addSubview:moneyLabel];

    


    UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
    [but setTitle:@"立即升级" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(clk) forControlEvents:UIControlEventTouchUpInside];
    but.frame=CGRectMake(CGRectGetMaxX(moneyLabel.frame), scrollview.size.height-45, 100, 45);
    but.backgroundColor=[UIColor orangeColor];
    [self.view addSubview:but];
    
    scrollview.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    if ([_current_vip_grade isEqualToString:@"GENERAL"]) {
        
    }else if ([_current_vip_grade isEqualToString:@"SILVER"]){
        rankview.attachmentStr=currentRank;
        
    }else if ([_current_vip_grade isEqualToString:@"GOLD"]){
        rankview2.attachmentStr=currentRank;
        
    }else if ([_current_vip_grade isEqualToString:@"DIAMOND"]){
        rankview3.attachmentStr=currentRank;
        self.moneyLabel.hidden=YES;
        but.hidden=YES;
        
    }
#pragma mark -看看是否需要隐藏
    
    if (_up_price_1==nil) {
        rankview.moneyStr=@"";
//        rankview.hidden=YES;
    }
    if (_up_price_2==nil) {
        rankview.moneyStr=@"";
        rankview2.moneyStr=@"";

//        rankview2.hidden=YES;
    }if (_up_price_3==nil) {
        rankview.moneyStr=@"";
        rankview2.moneyStr=@"";
        rankview3.moneyStr=@"";

//        rankview3.hidden=YES;
        
    }
#pragma mark -设置不可点击
    if ([_current_vip_grade isEqualToString:@"GENERAL"]) {
        
        
        
    }else if ([_current_vip_grade isEqualToString:@"SILVER"]){
        
        
    }else if ([_current_vip_grade isEqualToString:@"GOLD"]){
        [rankview removeGesture];

        
    }else if ([_current_vip_grade isEqualToString:@"DIAMOND"]){
        [rankview removeGesture];
        [rankview2 removeGesture];

        
    }
    
    
#pragma mark - 设置默认选中等级
    
    if (![_current_vip_grade isEqualToString:@"DIAMOND"]){
        rankview3.attachmentImg.hidden=NO;
//        rankview3.attachmentImg.image =[UIImage imageNamed:@"mycheck"];
  //选中的边框颜色
        rankview3.imageView.layer.borderWidth=2;
        rankview3.imageView.layer.borderColor=[UIColor orangeColor].CGColor;
        shengjiRank=@"DIAMOND";
        
        self.moneyLabel.text=[NSString stringWithFormat:@"%@",_up_price_3_remind];
//        rankview3.backgroundColor=[UIColor lightGrayColor];

        
    }
}
//-(void)setTabBarItem:(UITabBarItem *)tabBarItem
-(void)tap:(UITapGestureRecognizer *)sender{
    
    RankView *temp = (RankView *)sender.view;

    if ([temp.attachmentStr isEqualToString:currentRank]) {
        return;//如果是当前等级则不做处理
    }
    for (RankView *obj in _viewArr) {
        
        NSLog(@"-----%@",obj.attachmentStr);
        if (![obj.attachmentStr isEqualToString:currentRank]) {
//            obj.attachmentImg.image =nil;
            obj.attachmentImg.hidden=YES;
            

        }
        //选中的边框颜色
        obj.imageView.layer.borderWidth=0.5;
        obj.imageView.layer.borderColor=[UIColor lightGrayColor].CGColor;
//        obj.backgroundColor=[UIColor whiteColor];
        
        

    }
    
    //修改一下选中的背景的颜色
//    temp.backgroundColor=[UIColor lightGrayColor];
    temp.attachmentImg.hidden=NO;
//    temp.attachmentImg.image =[UIImage imageNamed:@"mycheck"];
    //选中的边框颜色
    temp.imageView.layer.borderWidth=2;
    temp.imageView.layer.borderColor=[UIColor orangeColor].CGColor;
    
    NSLog(@"++++++%zd",[_viewArr indexOfObject:temp]);
    NSUInteger index=[_viewArr indexOfObject:temp];
    if (index==0) {
        shengjiRank=@"SILVER";
        self.moneyLabel.text=[NSString stringWithFormat:@"%@",_up_price_1_remind];

    }else if (index==1){
        shengjiRank=@"GOLD";
         self.moneyLabel.text=[NSString stringWithFormat:@"%@",_up_price_2_remind];
    }else if (index==2){
        shengjiRank=@"DIAMOND";
         self.moneyLabel.text=[NSString stringWithFormat:@"%@",_up_price_3_remind];
    }
   
}

#pragma mark -立即升级
-(void)clk{
    NSLog(@"提交");
    if (shengjiRank ==nil) {
        [SYObject failedPrompt:@"请选择等级"];
        return;
    }
    __block NSString * order_id_danhao;
    __block NSString * order_id_id;

    NSString *url= [NSString stringWithFormat:@"%@/app/buyer/vip_level_up_save.htm",FIRST_URL];
    
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    
    NSDictionary *par=@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1],@"current_vip_grade":shengjiRank,@"order_type":@"ios"};
    __weak typeof(self) ws=self;
    [[Requester managerWithHeader]POST:url parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject==%@",responseObject);
        
        if ([responseObject[@"ret"] isEqualToString:@"1"]) {
            order_id_danhao=responseObject[@"order_id"];
            order_id_id=responseObject[@"id"];
            
            //进行跳转
            [ws gotoPay:order_id_danhao andid:order_id_id];
            
            
        }else if ([responseObject[@"ret"] isEqualToString:@"-1"]) {
            [SYObject failedPrompt:@"等级状态异常"];
        }else if ([responseObject[@"ret"] isEqualToString:@"-2"]) {
            [SYObject failedPrompt:@"系统异常"];
        }else if ([responseObject[@"ret"] isEqualToString:@"-3"]) {
            [SYObject failedPrompt:@"用户等级异常"];
        }else if ([responseObject[@"ret"] isEqualToString:@"-4"]) {
            [SYObject failedPrompt:@" 保存记录异常"];
        }
        [SYObject endLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        [SYObject endLoading];
        
    }];
   
}
-(void)gotoPay:(NSString *)danhao andid:(NSString *)idid{
    FirstViewController *ff = [FirstViewController sharedUserDefault];
    ff.willAppearBool = YES;
    //
    //    NSString *orderNum = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"order_num"]];
    //    NSString *orderID = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"order_id"]];
    //    third.ding_hao = orderNum;
    ThirdViewController *third = [ThirdViewController sharedUserDefault];
    
    //
    //    third.ding_fangshi = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"payType"]];
    //
    //    third.zongji.text = @"0.00";
    //    third.cart_ids = @"";
    //    third.jiesuan.text = @"0";
    //    [third.btnQ2 setTitle:[NSString stringWithFormat:@"结算(%@)",third.jiesuan.text] forState:UIControlStateNormal];
    //    third.btnQ2.backgroundColor = [UIColor grayColor];
    //
    //ding_order_id
    //    订单号
    third.ding_hao = danhao;
    //价格
    NSUserDefaults *a=[NSUserDefaults standardUserDefaults];
    if ([shengjiRank isEqualToString:@"SILVER"]) {
        third.jie_order_goods_price =_up_price_1;
        NSString *s=[NSString stringWithFormat:@"¥%@",_up_price_1];
        [a setObject:s forKey: @"realPrice"];

    }else if ([shengjiRank isEqualToString:@"GOLD"]) {
        third.jie_order_goods_price =_up_price_2;
        NSString *s=[NSString stringWithFormat:@"¥%@",_up_price_2];

        [a setObject:s forKey: @"realPrice"];

    }else if ([shengjiRank isEqualToString:@"DIAMOND"]) {
        third.jie_order_goods_price =_up_price_3;
        NSString *s=[NSString stringWithFormat:@"¥%@",_up_price_3];

        [a setObject:s forKey: @"realPrice"];

    }
    [a synchronize];
//    third.jie_order_goods_price =@"56.1";
//    third.ding_order_id = @"123";
    third.ding_order_id = idid;

    OnlinePayTypeSelectViewController *onnn = [[OnlinePayTypeSelectViewController alloc]init];
    
        onnn.order_type=@"ios";
    
    [self.navigationController pushViewController:onnn animated:YES];



}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;

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
