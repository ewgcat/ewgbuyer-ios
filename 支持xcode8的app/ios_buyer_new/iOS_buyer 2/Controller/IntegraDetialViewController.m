//
//  IntegraDetialViewController.m
//  My_App
//
//  Created by apple on 14-12-31.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "IntegraDetialViewController.h"
#import "ExchangeListViewController.h"
#import "ExchangeHomeViewController.h"
#import "ExchangeCarViewController.h"
#import "ChatViewController.h"
#import "Model.h"
#import "NewLoginViewController.h"

@interface IntegraDetialViewController ()

@end

@implementation IntegraDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSouce];
//    [self createTableView];
    [self createOtherFrame];
    [self createFresh];
}
// 初始化数据源
-(void) initDataSouce
{
    dataArr = [[NSMutableArray alloc]init];
}
// 刷新头部视图
-(void) createFresh
{
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -180-myWebView.scrollView.bounds.size.height, myWebView.scrollView.frame.size.width, myWebView.scrollView.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    myWebView.scrollView.delegate = self;
    [myWebView.scrollView addSubview:_refreshHeaderView];
    [_refreshHeaderView refreshLastUpdatedDate];
}
// 创建其他控件
-(void) createOtherFrame
{
    self.title = @"商品详情";
    [self createBackBtn];
    self.view.backgroundColor = [UIColor colorWithRed:251/255.0f green:253/255.0f blue:242/255.0f alpha:1];
//     不知道存什么的单例页面
   // ExchangeHomeViewController *exc = [ExchangeHomeViewController sharedUserDefault];
//     网页视图
    
    myWebView=[[UIWebView alloc] initWithFrame:CGRectMake(0, shjTableView.frame.size.height, ScreenFrame.size.width, ScreenFrame.size.height)];
    
    myWebView.backgroundColor = [UIColor whiteColor];
//    NSURL *url32=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%@",FIRST_URL,INTEGRALINTRODUCE_URL,exc.ig_id]];
//    NSURLRequest *requestweb=[[NSURLRequest alloc] initWithURL:url32];
//    [myWebView loadRequest:requestweb];
    myWebView.delegate = self;
    [myWebView scalesPageToFit];
    [self.view addSubview:myWebView];
    // 顶部的大商品图片
    UIImageView *imgBG = [[UIImageView alloc]initWithFrame:CGRectMake(0, ScreenFrame.size.height-44, ScreenFrame.size.width, 44)];
    imgBG.backgroundColor = [UIColor whiteColor];
    imgBG.userInteractionEnabled = YES;
    [self.view addSubview:imgBG];
    // 不知道做什么的灰色边框，应该被图片盖住了
    UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 0.5)];
    imageLine.backgroundColor = [UIColor grayColor];
    [imgBG addSubview:imageLine];
    // 底部加入购物车的背景
    UIView * bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, ScreenFrame.size.height-108-16, ScreenFrame.size.width, 60)];
    bottomView.backgroundColor=UIColorFromRGB(0XE7E7E7);
    [self.view addSubview:bottomView];
    CALayer * bottomLayer=[bottomView layer];
    bottomLayer.borderColor=[UIColorFromRGB(0XDCDCDC) CGColor];
    bottomLayer.borderWidth=1.1f;
    // 加入购物车按钮
    UIButton *btnAddShopCar = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAddShopCar.frame = CGRectMake(20, 8, ScreenFrame.size.width-80, 44);
   
    btnAddShopCar.backgroundColor =UIColorFromRGB(0xf15353);
    btnAddShopCar.tag = 103;
    CALayer *lay3 = btnAddShopCar.layer;
    [lay3 setMasksToBounds:YES];
    [lay3 setCornerRadius:4.0f];
    [btnAddShopCar setTitle:@"+ 加入积分购物车" forState:UIControlStateNormal];
    btnAddShopCar.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [btnAddShopCar addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnAddShopCar addTarget:self action:@selector(buttonBackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
    [btnAddShopCar addTarget:self action:@selector(buttonBackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btnAddShopCar];
    // 购物车图片按钮
    UIButton *btnShopCar = [UIButton buttonWithType:UIButtonTypeCustom];
    btnShopCar.frame = CGRectMake(ScreenFrame.size.width - 50, 18, 36, 24);
    btnShopCar.tag = 102;
    CALayer *lay2 = btnShopCar.layer;
    [lay2 setMasksToBounds:YES];
    [lay2 setCornerRadius:4.0f];
    [btnShopCar setImage:[UIImage imageNamed:@"trolley_lj"] forState:UIControlStateNormal];
    [btnShopCar addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btnShopCar];
}
//  button普通状态下的背景色
- (void)buttonBackGroundNormal:(UIButton *)sender
{
    sender.backgroundColor = UIColorFromRGB(0Xf15353);
}
//  button高亮状态下的背景色
- (void)buttonBackGroundHighlighted:(UIButton *)sender
{
    sender.backgroundColor = UIColorFromRGB(0Xd15353);
}
//重写返回按钮
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView
-(void)createTableView{
    shjTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-64-60)];
    shjTableView.backgroundColor = [UIColor clearColor];
    shjTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    shjTableView.delegate = self;
    shjTableView.dataSource= self;
    shjTableView.showsVerticalScrollIndicator = NO;
    shjTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:shjTableView];
    
    labelTi = [[UILabel alloc] initWithFrame:CGRectMake(50, ScreenFrame.size.height-100, ScreenFrame.size.width-100, 30)];
    CALayer *lay2  = labelTi.layer;
    [lay2 setMasksToBounds:YES];
    [lay2 setCornerRadius:4.0];
    labelTi.hidden = YES;
    labelTi.font = [UIFont systemFontOfSize:14];
    labelTi.backgroundColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:0.8];
    labelTi.alpha = 1;
    labelTi.textColor = [UIColor whiteColor];
    labelTi.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labelTi];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return ScreenFrame.size.width + 360+8+40;
    }
    if (indexPath.row == 1) {
        return 60;
    }
    return 75;
}
// 要修改的cell位置关系
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *shjTableViewCell = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell%ld_%ld", (long)indexPath.section, (long)indexPath.row]];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:shjTableViewCell];
        // 去掉自带的cell分割线
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 0) {
        // 商品图片
        self.ig_goods_img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.width)];
        [cell addSubview:self.ig_goods_img];
        // 商品名字
        UIView *line1=[LJControl viewFrame:CGRectMake(0, self.ig_goods_img.bottom, ScreenFrame.size.width, 0.5) backgroundColor:UIColorFromRGB(0xd7d7d7)];
        [cell addSubview:line1];
        self.lblGoodsName = [[UILabel alloc]initWithFrame:CGRectMake(15, line1.bottom, ScreenFrame.size.width - 30, 40)];
        self.lblGoodsName.font = [UIFont systemFontOfSize:16];
        self.lblGoodsName.textColor=UIColorFromRGB(0x333333);
        self.lblGoodsName.numberOfLines = 0;
        [cell addSubview:self.lblGoodsName];
        UIView *line2=[LJControl viewFrame:CGRectMake(0, self.lblGoodsName.bottom, ScreenFrame.size.width, 0.5) backgroundColor:UIColorFromRGB(0xd7d7d7)];
        [cell addSubview:line2];
        
        UIView *backView=[LJControl viewFrame:CGRectMake(0, line2.bottom, ScreenFrame.size.width, 120) backgroundColor:UIColorFromRGB(0xf8f8f8)];
        [cell addSubview:backView];
        // 消耗积分
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(15, line2.bottom, 80, 40)];
        label1.text = @"消耗积分:";
        label1.textColor = UIColorFromRGB(0x999999);
        label1.backgroundColor=[UIColor clearColor];
        label1.font = [UIFont systemFontOfSize:16];
        [cell addSubview:label1];
        
        
        UIView *line3=[LJControl viewFrame:CGRectMake(0, label1.bottom, ScreenFrame.size.width, 0.5) backgroundColor:UIColorFromRGB(0xe9e9e9)];
        [cell addSubview:line3];
        // 市场价格
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(15, line3.bottom, 80, 40)];
        label2.text = @"市场价格:";
        label2.textColor = UIColorFromRGB(0X999999);
        label2.font = [UIFont systemFontOfSize:16];
         label2.backgroundColor=[UIColor clearColor];
        [cell addSubview:label2];
        
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
        UIView *myLine=[LJControl viewFrame:CGRectMake(0, label2.bottom, ScreenFrame.size.width, 0.5) backgroundColor:UIColorFromRGB(0xd7d7d7)];
        [cell addSubview:myLine];

//        积分兑换商品商品金额字段
        
        
        UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, label2.bottom, 80, 40)];
        moneyLabel.text = @"商品金额:";
        moneyLabel.textColor = UIColorFromRGB(0X999999);
        moneyLabel.font = [UIFont systemFontOfSize:16];
        moneyLabel.backgroundColor=[UIColor clearColor];
        [cell addSubview:moneyLabel];
        
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
        UIView *line4=[LJControl viewFrame:CGRectMake(0, moneyLabel.bottom, ScreenFrame.size.width, 0.5) backgroundColor:UIColorFromRGB(0xd7d7d7)];
        [cell addSubview:line4];

        // 消耗积分数字
        self.lblIntegraNeeds = [[UILabel alloc]initWithFrame:CGRectMake(98, line2.bottom, 100, 40)];
        self.lblIntegraNeeds.textColor = UIColorFromRGB(0Xe00000);
        self.lblIntegraNeeds.font = [UIFont systemFontOfSize:20];
        self.lblIntegraNeeds.backgroundColor=[UIColor clearColor];
        [cell addSubview:self.lblIntegraNeeds];
        // 市场价格数字
        self.lblGoodsPrice = [[UILabel alloc]initWithFrame:CGRectMake(98, line3.bottom, 120, 40)];
        self.lblGoodsPrice.textColor = UIColorFromRGB(0X999999);
        self.lblGoodsPrice.font = [UIFont systemFontOfSize:16];
        self.lblGoodsPrice.backgroundColor=[UIColor clearColor];
        [cell addSubview:self.lblGoodsPrice];
        
        // 商品价格数字
        self.goodPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(98, _lblGoodsPrice.bottom, 120, 40)];
        self.goodPriceLabel.textColor = UIColorFromRGB(0X999999);
        self.goodPriceLabel.font = [UIFont systemFontOfSize:16];
        self.goodPriceLabel.backgroundColor=[UIColor clearColor];
        [cell addSubview:self.goodPriceLabel];
        
        // 兑换时间
        UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(15, line4.bottom, 120, 40)];
        label3.text = @"兑换时间:";
        label3.textColor = UIColorFromRGB(0X999999);
        label3.font = [UIFont systemFontOfSize:14];
        [cell addSubview:label3];
        UIView *line5=[LJControl viewFrame:CGRectMake(0, label3.bottom, ScreenFrame.size.width, 0.5) backgroundColor:UIColorFromRGB(0xd7d7d7)];
        [cell addSubview:line5];
        
        
        
        // 兑换限制
        UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(15, line5.bottom, 120, 40)];
        label4.text = @"兑换限制:";
        label4.textColor = UIColorFromRGB(0X999999);
        label4.font = [UIFont systemFontOfSize:14];
        [cell addSubview:label4];
        UIView *line6=[LJControl viewFrame:CGRectMake(0, label4.bottom, ScreenFrame.size.width, 0.5) backgroundColor:UIColorFromRGB(0xd7d7d7)];
        [cell addSubview:line6];
        
        // 要求等级
//        UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(15, line6.bottom, 120, 40)];
//        label5.text = @"要求等级:";
//        label5.textColor = UIColorFromRGB(0X999999);
//        label5.font = [UIFont systemFontOfSize:14];
//        [cell addSubview:label5];
//        UIView *line7=[LJControl viewFrame:CGRectMake(0, label5.bottom, ScreenFrame.size.width, 0.5) backgroundColor:UIColorFromRGB(0xd7d7d7)];
//        [cell addSubview:line7];
        
        // 兑换时间数字
        self.lblShelvesTime = [[UILabel alloc]initWithFrame:CGRectMake(98, line4.bottom, ScreenFrame.size.width-108, 40)];
        self.lblShelvesTime.textColor = UIColorFromRGB(0X333333);
        self.lblShelvesTime.textAlignment = NSTextAlignmentLeft;
        self.lblShelvesTime.font = [UIFont systemFontOfSize:14];
        [cell addSubview:self.lblShelvesTime];
        // 兑换限制数字
        self.lblLimitCount = [[UILabel alloc]initWithFrame:CGRectMake(98, line5.bottom, 150, 40)];
        self.lblLimitCount.textAlignment = NSTextAlignmentLeft;
        self.lblLimitCount.font = [UIFont systemFontOfSize:14];
        self.lblLimitCount.textColor=UIColorFromRGB(0X333333);
        [cell addSubview:self.lblLimitCount];
        // 要求等级
//        self.lblClassNeeds = [[UILabel alloc]initWithFrame:CGRectMake(98, line6.bottom, 150, 40)];
//        self.lblClassNeeds.textAlignment = NSTextAlignmentLeft;
//        self.lblClassNeeds.font = [UIFont systemFontOfSize:14];
//        self.lblClassNeeds.textColor=UIColorFromRGB(0X333333);
//        [cell addSubview:self.lblClassNeeds];
        
//        UIView *lblLine2 = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenFrame.size.width + 208, ScreenFrame.size.width + 50, 0.5)];
//        lblLine2.backgroundColor = [UIColor lightGrayColor];
//        [cell addSubview:lblLine2];
        
        // 运费
        UILabel *label8 = [[UILabel alloc]initWithFrame:CGRectMake(15, line6.bottom, 120, 40)];
        label8.text = @"运费:";
        label8.textColor=UIColorFromRGB(0X999999);
        label8.font = [UIFont systemFontOfSize:14];
        [cell addSubview:label8];
        
        UIView *line8=[LJControl viewFrame:CGRectMake(0, label8.bottom, ScreenFrame.size.width, 0.5) backgroundColor:UIColorFromRGB(0xd7d7d7)];
        [cell addSubview:line8];
        
        // 运费数字
        self.lblTransfee = [[UILabel alloc]initWithFrame:CGRectMake(98, line6.bottom, 120, 40)];
        self.lblTransfee.textAlignment = NSTextAlignmentLeft;
        self.lblTransfee.font = [UIFont systemFontOfSize:14];
        self.lblTransfee.textColor=UIColorFromRGB(0X333333);
        [cell addSubview:self.lblTransfee];
        
//        UIView *lblLine4 = [[UIView alloc]initWithFrame:CGRectMake(10, ScreenFrame.size.width + 248, ScreenFrame.size.width , 0.5)];
//        lblLine4.backgroundColor = [UIColor lightGrayColor];
//        [cell addSubview:lblLine4];
        // 库存
        UILabel *label9 = [[UILabel alloc]initWithFrame:CGRectMake(15, line8.bottom, 120, 40)];
        label9.text = @"库存:";
        label9.font = [UIFont systemFontOfSize:14];
        label9.textColor=UIColorFromRGB(0X999999);
        [cell addSubview:label9];
        UIView *line9=[LJControl viewFrame:CGRectMake(0, label9.bottom, ScreenFrame.size.width, 0.5) backgroundColor:UIColorFromRGB(0xd7d7d7)];
        [cell addSubview:line9];
        
        
        // 兑换数量
        UILabel *label10 = [[UILabel alloc]initWithFrame:CGRectMake(15, line9.bottom+1, 120, 41)];
        label10.text = @"兑换数量:";
        label10.font = [UIFont systemFontOfSize:14];
        label10.textColor=UIColorFromRGB(0X999999);
        //label10.backgroundColor=[UIColor greenColor];
        [cell addSubview:label10];
//        UIView *line10=[LJControl viewFrame:CGRectMake(0, label10.bottom, ScreenFrame.size.width, 0.5) backgroundColor:UIColorFromRGB(0xd7d7d7)];
//        [cell addSubview:line10];
        
        
        // 库存数字
        self.lblGoodsCount = [[UILabel alloc]initWithFrame:CGRectMake(98, line8.bottom, 120, 40)];
        self.lblGoodsCount.textAlignment = NSTextAlignmentLeft;
        self.lblGoodsCount.font = [UIFont systemFontOfSize:14];
        self.lblGoodsCount.textColor=UIColorFromRGB(0X333333);
        [cell addSubview:self.lblGoodsCount];
        // 兑换数字
        self.countField = [[UITextField alloc]initWithFrame:CGRectMake(110+18, line9.bottom+9.5, 58, 25)];
        self.countField.text = @"1";
        self.countField.backgroundColor=UIColorFromRGB(0xf8f8f8);
        self.countField.layer.borderWidth = 1.0;
        self.countField.layer.cornerRadius = 1.0;
        self.countField.layer.borderColor = [UIColorFromRGB(0xdddddd) CGColor];
        self.countField.textAlignment = NSTextAlignmentCenter;
        self.countField.font = [UIFont systemFontOfSize:13];
        //self.countField.textColor=UIColorFromRGB(0X8F8F8F);
        //self.countField.keyboardType = UIKeyboardTypeNumberPad;
        self.countField.keyboardType=UIKeyboardTypeNumberPad;
        self.countField.delegate = self;
        [cell addSubview:self.countField];
        
        
        WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"取消" leftTarget:self leftAction:@selector(editBtn1) rightTitle:@"完成" rightTarget:self rightAction:@selector(editBtn)];
        [self.countField setInputAccessoryView:inputView];

       
      
        // 减按钮
        self.btnMinus = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnMinus.frame = CGRectMake(98, line9.bottom+9.5, 25, 25);
        self.btnMinus.tag = 104;
        [self.btnMinus setImage:[UIImage imageNamed:@"minusNew"] forState:UIControlStateNormal];
//        [self.btnMinus setImage:[UIImage imageNamed:@"shjjian1"] forState:UIControlStateSelected];
        [self.btnMinus addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:self.btnMinus];
        // 加按钮
        self.btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnAdd.frame = CGRectMake(175+18, line9.bottom+9.5, 25, 25);
        self.btnAdd.tag = 105;
        [self.btnAdd setImage:[UIImage imageNamed:@"addNew"] forState:UIControlStateNormal];
//        [self.btnAdd setImage:[UIImage imageNamed:@"shjjia1"] forState:UIControlStateSelected];
        [self.btnAdd addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:self.btnAdd];
//        cell.backgroundColor=UIColorFromRGB(0XFDF8F5);
        cell.backgroundColor=[UIColor whiteColor];
    }
    if (indexPath.row == 1) {
        // 底部继续拖动图片
        UIImageView *imgBG2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 61)];
        imgBG2.layer.borderWidth = 0.5;
        imgBG2.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        imgBG2.backgroundColor = [UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:255/255.0f];
        [cell addSubview:imgBG2];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, ScreenFrame.size.width-60, 60)];
        label.text = @"👆继续拖动,查看图文详情";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [imgBG2 addSubview:label];
        
 
    }
    return cell;
}
-(void)editBtn
{

  [self.countField resignFirstResponder];
    if ([self.countField.text intValue]>0) {
        
        
    }else
    {
     [SYObject failedPrompt:@"请输入正确数量"];
    }

   

}
-(void)editBtn1
{
    
    [self.countField resignFirstResponder];
       
}
-(void)btnClicked:(UIButton *)btn{
    ExchangeHomeViewController *exc = [ExchangeHomeViewController sharedUserDefault];
    // 跳转到积分购物车
    if (btn.tag == 102) {
        ExchangeCarViewController *exchangeCarVC = [[ExchangeCarViewController alloc]init];
        [self.navigationController pushViewController:exchangeCarVC animated:YES];
    }
    // 添加到购物车
    if (btn.tag == 103) {
        if ([self.countField.text intValue]>0) {
            NSArray *fileContent2 = [MyUtil returnLocalUserFile];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,INTEGRALADDTOCAR_URL]];
            request102 = [ASIFormDataRequest requestWithURL:url];
            [request102 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
            [request102 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
            [request102 setPostValue:_countField.text forKey:@"exchange_count"];
            [request102 setPostValue:exc.ig_id forKey:@"id"];
            //        [request102 setPostValue:@"0" forKey:@"beginCount"];
            //        [request102 setPostValue:@"20" forKey:@"selectCount"];
            [request102 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request102.tag = 102;
            [request102 setDelegate:self];
            [request102 setDidFailSelector:@selector(urlRequestFailed:)];
            [request102 setDidFinishSelector:@selector(urlRequestSucceeded:)];
            [request102 startAsynchronous];
            
        }else
        {
         [SYObject failedPrompt:@"兑换数量不能为0"];
        
        }
      
    }
    if (btn.tag == 104) {
        if ([self.countField.text intValue] == 1) {
            
        }else{
            self.countField.text = [NSString stringWithFormat:@"%d",[self.countField.text intValue]-1];
            _totalIntegral = [NSString stringWithFormat:@"%d",[self.lblIntegraNeeds.text intValue]*[self.countField.text intValue]];
            
        }
    }
    if (btn.tag == 105) {
       
        int limitCount = [_limitCountChoose intValue];
        int goodsCount = [_lblGoodsCount.text intValue];
        if ([self.countField.text intValue] == limitCount || [self.countField.text intValue] == goodsCount) {
            
        }else{
            self.countField.text = [NSString stringWithFormat:@"%d",[self.countField.text intValue]+1];
            _totalIntegral = [NSString stringWithFormat:@"%d",[self.lblIntegraNeeds.text intValue]*[self.countField.text intValue]];
        }
    }
}
// 上传添加的商品，成功返回 ret=true
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if (dicBig) {
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSFileManager *fileManagerDong = [NSFileManager defaultManager];
            if ([fileManagerDong fileExistsAtPath:readPath2]==NO){
                labelTi.hidden = NO;
                labelTi.text = @"您还未登录,请登录后添加!";
                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimerToLogin) userInfo:nil repeats:NO];
            }else if([[dicBig objectForKey:@"exchange_status"] integerValue]==0){
                [OHAlertView showAlertWithTitle:@"添加成功" message:@"商品已成功加入购物车"   cancelButton:nil otherButtons:@[@"去购物车",@"再逛逛"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                    if (buttonIndex == 0) {
                        ExchangeCarViewController *exchangeCarVC = [[ExchangeCarViewController alloc]init];
                        [self.navigationController pushViewController:exchangeCarVC animated:YES];
                    }
                }];
            }else{
                if (dicBig[@"exchange_info"] ) {
                    [OHAlertView showAlertWithTitle:nil message:dicBig[@"exchange_info"]   cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                    }];
                }
              

            }
            
//            }else if([[dicBig objectForKey:@"exchange_status"] integerValue]==-1){
//                [OHAlertView showAlertWithTitle:nil message:@"数量不足"   cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
//                }];
//            }else if([[dicBig objectForKey:@"exchange_status"] integerValue]==-2){
//                [OHAlertView showAlertWithTitle:nil message:@"限制兑换"   cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
//                }];
//            }else if([[dicBig objectForKey:@"exchange_status"] integerValue]==-3){
//                [OHAlertView showAlertWithTitle:nil message:@"积分不足"   cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
//                }];
//            }else if([[dicBig objectForKey:@"exchange_status"] integerValue]==-4){
//                [OHAlertView showAlertWithTitle:nil message:@"兑换时间已过"   cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
//                }];
//            }else if([[dicBig objectForKey:@"exchange_status"] integerValue]==-5){
//                [OHAlertView showAlertWithTitle:nil message:@"会员等级不够"   cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
//                }];
//            }else if([[dicBig objectForKey:@"exchange_status"] integerValue]==-6){
//                
//                
//                NSString *exchange_info=nil;
//                if (dicBig[@"exchange_info"]) {
//                    exchange_info=dicBig[@"exchange_info"];
//                }else{
//                    exchange_info=@"该兑换商品已下架";
//                }
//                [OHAlertView showAlertWithTitle:nil message:exchange_info  cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
//                }];
//            }

        }
    }
}
-(void)failedPrompt:(NSString *)prompt{
    loadingV.hidden = YES;
    labelTi.hidden = NO;
    labelTi.text = prompt;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)dismissKeyBoard{
    [self.countField resignFirstResponder];
    if (_countField.text.length == 0) {
        _countField.text = @"1";
    }
    _totalIntegral = [NSString stringWithFormat:@"%d",[self.lblIntegraNeeds.text intValue]*[self.countField.text intValue]];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
 
        NSString *str =[string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
        if(str.length > 0)//只让输入是数字的字符
        {
            return NO;
        }
        
 
    if (string.length == 0) {
        //说明是删除的操作
    }else{
        //说明是在添加的操作
        if ([_limitCountChoose isEqualToString:@"(null)"]) {
            CountExchange = [NSString stringWithFormat:@"%@%@",textField.text,string];
            if ([CountExchange intValue]>[_lblGoodsCount.text intValue]){
                [_countField resignFirstResponder];
                _countField.text = _lblGoodsCount.text;
            }
        }else{
            CountExchange = [NSString stringWithFormat:@"%@%@",textField.text,string];
            if([CountExchange intValue]>[_limitCountChoose intValue]){
                [_countField resignFirstResponder];
                _countField.text = _limitCountChoose;
            }else if ([CountExchange intValue]>[_lblGoodsCount.text intValue]){
                [_countField resignFirstResponder];
                _countField.text = _lblGoodsCount.text;
            }
        }
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}
- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 160; // tweak as needed
    const float movementDuration = 0.2f; // tweak as needed
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self dismissKeyBoard];
    return  YES;
}
#pragma mark - 用户信息调用
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request101 clearDelegatesAndCancel];
    [request102 clearDelegatesAndCancel];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [shjTableView removeFromSuperview];
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    loadingV=[self loadingView:CGRectMake((ScreenFrame.size.width-100)/2, (ScreenFrame.size.height-100)/2, 100, 100)];
    [self.view addSubview:loadingV];
    [self createTableView];
    ExchangeHomeViewController *exc = [ExchangeHomeViewController sharedUserDefault];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,INTEGRALGOODS_URL]];
    request101 = [ASIFormDataRequest requestWithURL:url];
    [request101 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request101 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    [request101 setPostValue:exc.ig_id forKey:@"ig_id"];
    [request101 setPostValue:@"0" forKey:@"beginCount"];
    [request101 setPostValue:@"20" forKey:@"selectCount"];
    
    [request101 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request101.tag = 101;
    [request101 setDelegate:self];
    [request101 setDidFailSelector:@selector(my1_urlRequestFailed:)];
    [request101 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
    [request101 startAsynchronous];
    [super viewWillAppear:YES];
}
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        loadingV.hidden = YES;
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"exchange_dibBig-->>%@",dicBig);
        if (dicBig) {
            [self.ig_goods_img sd_setImageWithURL:[dicBig objectForKey:@"ig_goods_img"] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
            self.lblGoodsName.text = [dicBig objectForKey: @"ig_goods_name"];
            self.lblIntegraNeeds.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"ig_goods_integral"]];
            self.lblGoodsPrice.text = [NSString stringWithFormat:@"￥%@",[dicBig objectForKey:@"ig_goods_price"]];
            
            self.goodPriceLabel.text = [NSString stringWithFormat:@"￥%@",[dicBig objectForKey:@"ig_goods_pay_price"]];

            
            
            ig_user_level = [dicBig objectForKey:@"ig_user_level"];
            self.lblClassNeeds.text=ig_user_level;
            if ([ig_user_level isEqualToString:@"铜牌会员"]) {
                self.lblClassNeeds.textColor = [UIColor colorWithRed:186/255.0f green:134/255.0f blue:94/255.0f alpha:1];
            }
            if ([ig_user_level isEqualToString:@"银牌会员"]) {
                self.lblClassNeeds.textColor = [UIColor colorWithRed:186/255.0f green:185/255.0f blue:185/255.0f alpha:1];
            }
            if ([ig_user_level isEqualToString:@"金牌会员"]) {
                self.lblClassNeeds.textColor = [UIColor colorWithRed:222/255.0f green:160/255.0f blue:12/255.0f alpha:1];
            }
            if ([ig_user_level isEqualToString:@"钻石会员"]) {
                self.lblClassNeeds.textColor = [UIColor orangeColor];
            }
            self.lblShelvesTime.text = [dicBig objectForKey:@"ig_time"];
            self.lblLimitCount.text = [dicBig objectForKey:@"ig_limit_count"];
            self.lblMyIntegral.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"integral"]];
            self.lblTransfee.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"transfee"]];
            self.lblGoodsCount.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"ig_goods_count"]];
            ig_id = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"ig_id"]];
            _totalIntegral = [NSString stringWithFormat:@"%d",[self.lblIntegraNeeds.text intValue]];
            _userLevel = [NSString stringWithFormat:@"%@", [dicBig objectForKey:@"user_level"]];
            _limitCountChoose = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"ig_limit_count_choose"]];
        }
    }
    
}

-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
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

-(void)doTimer{
    [labelTi setHidden:YES];
}
-(void)doTimerToLogin{
    [labelTi removeFromSuperview];
    NewLoginViewController *new = [[NewLoginViewController alloc]init];
    [self.navigationController pushViewController:new animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    if (aScrollView == myWebView.scrollView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:aScrollView];
    }
    
    if(aScrollView == shjTableView){
        CGPoint offset = aScrollView.contentOffset;  // 当前滚动位移
        CGRect bounds = aScrollView.bounds;          // UIScrollView 可视高度
        CGSize size = aScrollView.contentSize;         // 滚动区域
        UIEdgeInsets inset = aScrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        
        float reload_distance = 10;
        
        if (y > (h + reload_distance)) {
            // 滚动到底部
            if (scrollBool == NO) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                
                [shjTableView setFrame:CGRectMake(0, -shjTableView.frame.size.height, ScreenFrame.size.width, shjTableView.frame.size.height)];
                
                CGRect frame2 = myWebView.frame;
                frame2.origin.y -= myWebView.frame.size.height;
                [myWebView setFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-64)];
                ExchangeHomeViewController *exc = [ExchangeHomeViewController sharedUserDefault];
                NSURL *url32=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%@",FIRST_URL,INTEGRALINTRODUCE_URL,exc.ig_id]];
                NSURLRequest *requestweb=[[NSURLRequest alloc] initWithURL:url32];
                [myWebView loadRequest:requestweb];
                
                [UIView commitAnimations];
                scrollBool = YES;
            }else{
            }
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)aScrollView
{
    if (aScrollView == myWebView.scrollView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:aScrollView];
    }
}
#pragma mark - webview delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    _reloading = YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:myWebView.scrollView];
    loadingV.hidden = YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:myWebView.scrollView];
    //若不存在网络 则需要影藏webview 并提示用户点击屏幕进行刷新
    loadingV.hidden = YES;
}

#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == myWebView.scrollView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    scrollBool = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    if (shjTableView.frame.origin.y == 64) {
        
    }else{
        CGRect frame = shjTableView.frame;
        frame.origin.y += shjTableView.frame.size.height;
        [shjTableView setFrame:frame];
        
        CGRect frame2 = myWebView.frame;
        frame2.origin.y += myWebView.frame.size.height;
        [myWebView setFrame:frame2];
    }
    [UIView commitAnimations];
    
    ExchangeHomeViewController *exc = [ExchangeHomeViewController sharedUserDefault];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%@",FIRST_URL,INTEGRALINTRODUCE_URL,exc.ig_id]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [myWebView loadRequest:request];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return [NSDate date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
