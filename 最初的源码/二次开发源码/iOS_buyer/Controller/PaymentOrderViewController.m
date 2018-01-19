//
//  PaymentOrderViewController.m
//  My_App
//
//  Created by apple on 16/2/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PaymentOrderViewController.h"
#import "PaymentOrderCell.h"
#import "PaymentOrderCell1.h"
#import "NilCell.h"
#import "CloudCartCell.h"
#import "CloudCart.h"
#import "OnlinePayTypeSelectViewController.h"
#import "ThirdViewController.h"

@interface PaymentOrderViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *dataArray;
    UITableView *myTableView;
    __weak IBOutlet UILabel *totalLabel;
    __weak IBOutlet UIButton *submitButton;
    
    
}
@end

@implementation PaymentOrderViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigation];
    [self designPage];
    [self createToolView];
}
#pragma mark -界面
-(void)createNavigation{
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0Xdf0000);
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
   self.title=@"支付订单";
    
    UIButton *backButton = [LJControl backBtn];
    backButton.tag=1000;
    [backButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)btnClicked:(UIButton *)btn{
    [OHAlertView showAlertWithTitle:@"确认操作" message:@"您的订单尚未支付，确定要终止支付操作吗？" cancelButton:nil otherButtons:@[@"取消",@"我要离开"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
        if (buttonIndex==0) {
        }else{
           [self.navigationController popViewControllerAnimated:YES];
        }

    }];
}
- (IBAction)submitButtonClick:(UIButton *)sender {
    NSString *pushCashSaveUrl =[NSString stringWithFormat:@"%@%@",FIRST_URL,CLOUDPURCHASE_SUBMIT_ORDER_URL];
    // 获取本地文件
    NSMutableArray *keys=[[NSMutableArray alloc]init];
    NSMutableArray *vlaues=[[NSMutableArray alloc]init];
    for (CloudCart *model in _cloudCartArray) {
        [keys addObject:[model lotteryID]];
        [vlaues addObject:[model userBuyedQty]];
    }
    NSDictionary *dic=[[NSDictionary alloc]initWithObjects:vlaues forKeys:keys];
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *jionString= [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSArray *fileContent=[MyUtil returnLocalUserFile];
    NSDictionary *par = @{
                          @"user_id":fileContent[3],
                          @"token":fileContent[1],
                          @"orderInfo":jionString
                          };
    [[Requester managerWithHeader]POST:pushCashSaveUrl parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dict = responseObject;
        NSLog(@"dict = %@",dict);
         NSInteger code=[dict[@"code"] integerValue];
        NSDictionary * resultDict =[dict objectForKey:@"data"];
        if(code ==10001){
            NSLog(@"充值订单保存%@",resultDict);
            ThirdViewController *th = [ThirdViewController sharedUserDefault];
            th.ding_hao = [NSString stringWithFormat:@"%@",resultDict[@"odrdersn"]];
            th.jie_order_goods_price = [NSString stringWithFormat:@"%@",resultDict[@"price"]];
            th.ding_order_id = [NSString stringWithFormat:@"%@",resultDict[@"id"]];
            //这里应该跳转进入选择页面
            OnlinePayTypeSelectViewController *on = [[OnlinePayTypeSelectViewController alloc]init];
            on.order_type=@"cloudpurchase";
            [self.navigationController pushViewController:on animated:YES];
        }else{
            [SYObject failedPrompt:@"请求失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [SYObject failedPrompt:@"网络请求失败"];
    }];


    
}
#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1){  //关闭主界面的右滑返回
        return NO;
    }else{
        return YES;
    }
}
-(void)designPage{
    myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenFrame.size.width, ScreenFrame.size.height-22-70) style:UITableViewStylePlain];
    myTableView.separatorStyle = UITableViewStylePlain;
    myTableView.delegate=self;
    myTableView.dataSource=self;
    [self.view addSubview:myTableView];
}
-(void)createToolView{
    NSString *text =[NSString stringWithFormat:@"%@%@元 ",totalLabel.text,_totalPrice];
    NSRange range = [text rangeOfString:[NSString stringWithFormat:@"总计：%@元 ",_totalPrice]];
    NSRange range1 = NSMakeRange(range.location + 3, range.length - 3);
    NSMutableAttributedString *statusText = [[NSMutableAttributedString alloc]initWithString:text];
    [statusText addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0Xef0000) range:range1];
    totalLabel.attributedText =statusText;

    [submitButton.layer setMasksToBounds:YES];
    [submitButton.layer setCornerRadius:4.0];

}
#pragma mark- UITableViewDataSource & UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _cloudCartArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 96;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PaymentOrderCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentOrderCell1"];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PaymentOrderCell1" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.model=[_cloudCartArray objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

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
