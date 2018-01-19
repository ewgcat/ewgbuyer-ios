//
//  ReturnRefundViewController.m
//  2016seller_01_09_new
//
//  Created by apple on 16/1/12.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

#import "ReturnRefundViewController.h"
#import "NilCell.h"
#import "ReturnRefundCell.h"
#import "ReturnRefundTwoCell.h"
#import "RefundModel.h"
#import "ReturnModel.h"

@interface ReturnRefundViewController ()<UITableViewDataSource,UITableViewDelegate,MyObjectDelegate,UITextFieldDelegate>
{
    MyObject *myObject;
    UITableView *returnTableView;
    UITableView *refundTableView;
}
@end

@implementation ReturnRefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self createBackBtn];
    [self designPage];
}
-(void)createBackBtn{
    self.title=@"退货/退款管理";
}
//-(void)requestForRefundNotif{
//    [MyNetTool requestForRefundStatusBegin:@"0" select:@"20" success:^(NSMutableArray *modelArray) {
//        self.refundArray = modelArray;

//        [MyNetTool requestForReturnStatusBegin:@"0" select:@"20" success:^(NSMutableArray *modelArray) {
//            self.returnArray = modelArray;
//        }];
//        
//    }];
//    
//}
-(void)designPage{
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);//背景颜色
    if (UIDeviceSystem>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;//自动调整属性设置为NO
    }else{
    }
    myObject = [MyObject new];
    myObject.delegate = self;
    NSArray *titles = @[@"退货订单",@"退款订单"];
    [myObject sy_addHeadNaviTitleArray:titles toContainerViewWithFrameSetted:self.view headerHeight:44.0 topMargin:64.0 testColor:NO normalFontSize:15.f selectedFontSize:15.f];
 
    
    returnTableView = myObject.tableViewArray[0];
    returnTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    returnTableView.delegate =self;
    returnTableView.dataSource= self;
    returnTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    returnTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];

    
    refundTableView = myObject.tableViewArray[1];
    refundTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    refundTableView.delegate =self;
    refundTableView.dataSource= self;
    refundTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing1)];
    refundTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing1)];
}
#pragma mark -上拉刷新、下拉加载
-(void)headerRereshing{
    
    [returnTableView.mj_header endRefreshing];
}
-(void)footerRereshing{
    
    [returnTableView.mj_header endRefreshing];
}
-(void)headerRereshing1{
    
    [refundTableView.mj_header endRefreshing];
}
-(void)footerRereshing1{
    
    [refundTableView.mj_header endRefreshing];
}
#pragma mark -UITableViewDataSource&&UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == returnTableView) {
        //退货
        return self.returnArray.count;
    }else {
        //退款
        return self.refundArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == returnTableView) {
        //退货
        return 224;
    }else {
        //退款
        return 180;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReturnRefundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReturnRefundCell"];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReturnRefundCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    if (tableView == returnTableView) {
        //退货
        ReturnModel *returnModel= self.returnArray[indexPath.row];
        [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:returnModel.goods_mainphoto_path]];
        cell.nameLabel.text=[NSString stringWithFormat:@"%@",returnModel.goods_name];
        cell.buyersLabel.text=[NSString stringWithFormat:@"%@",returnModel.user_name];
        cell.orderLabel.text=[NSString stringWithFormat:@"订单号: %@",returnModel.order_id];
        cell.timeLabel.text=[NSString stringWithFormat:@"%@",returnModel.addTime];
        //退货拒绝按钮
        [cell.refuseButton addTarget:self action:@selector(returnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        cell.refuseButton.tag=indexPath.row+1;
        //退货通过按钮
        [cell.adoptButton addTarget:self action:@selector(returnPassClick:) forControlEvents:(UIControlEventTouchUpInside)];
        cell.adoptButton.tag=indexPath.row;
        
        
        return cell;
    }else {
        //退款
        ReturnRefundTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReturnRefundTwoCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ReturnRefundTwoCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        RefundModel *refundModel = self.refundArray[indexPath.row];
        
        cell.refundMoneyLab.text=[NSString stringWithFormat:@"退款金额: %@",refundModel.refund_price];
        cell.peopleLab.text=[NSString stringWithFormat:@"申请人 : %@",refundModel.user_name];
        cell.orderNumLab.text=[NSString stringWithFormat:@"订单号: %@",refundModel.order_id];
        cell.timeLabel.text=[NSString stringWithFormat:@"%@",refundModel.audit_date];
        //退款拒绝按钮
        [cell.refuseButton addTarget:self action:@selector(refundClick:) forControlEvents:(UIControlEventTouchUpInside)];
        cell.refuseButton.tag=indexPath.row+1;
        //退款通过按钮
        [cell.adoptButton addTarget:self action:@selector(refundClick:) forControlEvents:(UIControlEventTouchUpInside)];
        cell.adoptButton.tag=indexPath.row;
        
        return cell;
    }
    
}
//退款按钮点击事件
-(void)refundClick:(UIButton *)btn
{
    NSString *status=[NSString new];
    NSString *str = btn.titleLabel.text;
    NSInteger tag;
    if ([str isEqualToString:@"审核拒绝"]) {
         status=@"1";
        tag=btn.tag-1;
    }else if([str isEqualToString:@"审核通过"]){
        tag=btn.tag;
        status=@"0";
    }
    
   RefundModel *refundModel = self.refundArray[tag];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,REFUND_BTN_URL];
    //参数字典
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken],
                          @"apply_form_id":[NSString stringWithFormat:@"%@",refundModel.apply_form_id],
                          @"result":status
                          };
    //发起请求
    [[MyNetTool managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * dicBig=responseObject;//数据字典
        NSLog(@"退货退款结果///%@",dicBig);
        
        if (dicBig)
        {
            if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"])
            {
                [self.navigationController popToRootViewControllerAnimated:NO];
                //登录过期，提示重新登录
                [MyObject failedPrompt:@"用户登录已过期，请重新登录"];
                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
                
            }
            else
            {
                NSString *ret=[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"ret"]];
                if ([ret isEqualToString:@"100"])
                {
                        [MyObject failedPrompt:@"请求成功"];
                }else
                    {
                        [MyObject failedPrompt:@"请求失败"];
                    }
                
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@",[error localizedDescription]);
        
         
     }];

   
}
-(void)returnPassClick:(UIButton *)btn
{
   
    [OHAlertView showAlertWithTitle:@"提示" message:@"请输入收货地址" alertStyle:(OHAlertViewStylePlainTextInput) cancelButton:@"取消" otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex)
     {
         UITextField  *textField=[alert textFieldAtIndex:0];
         if (buttonIndex==1) {
             if (textField.text.length>0) {
                 
                 ReturnModel *returnModel = self.returnArray[btn.tag];
                 NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,RETURN_BTN_URL];
                 //参数字典
                 NSDictionary *par = @{
                                       @"user_id":[MyNetTool currentUserID],
                                       @"token":[MyNetTool currentToken],
                                       @"return_goods_id":[NSString stringWithFormat:@"%@",returnModel.return_goods_id],
                                       @"goods_return_status":@"6",
                                       @"self_address":textField.text
                                       };


                 //发起请求
                 [[MyNetTool managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     
                     NSDictionary * dicBig=responseObject;//数据字典
                     NSLog(@"退货退款结果///%@",dicBig);
                     
                     if (dicBig)
                     {
                         if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"])
                         {
                             [self.navigationController popToRootViewControllerAnimated:NO];
                             //登录过期，提示重新登录
                             [MyObject failedPrompt:@"用户登录已过期，请重新登录"];
                             [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
                             
                         }
                         else
                         {
                             NSString *ret=[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"op_title"]];
                             [MyObject failedPrompt:ret];
                             
                         }
                     }
                     
                     
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error)
                  {
                      NSLog(@"%@",[error localizedDescription]);
                      
                      
                  }];
                 
             }
             else
             {
                 [OHAlertView showAlertWithTitle:@"提示" message:@"输入内容不能为空" alertStyle:(OHAlertViewStyleDefault) cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                     
                 }];
                 
                 
             }
         }
         
     }];

   
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//退货按钮点击事件
-(void)returnClick:(UIButton *)btn
{

    NSString *status=[NSString new];
    NSInteger tag;
        status=@"-1";
        tag=btn.tag-1;
    ReturnModel *returnModel = self.returnArray[tag];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,RETURN_BTN_URL];
    //参数字典
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken],
                          @"return_goods_id":[NSString stringWithFormat:@"%@",returnModel.return_goods_id],
                          @"goods_return_status":status,
                          @"self_address":@""
                          };
    //发起请求
    [[MyNetTool managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * dicBig=responseObject;//数据字典
        NSLog(@"退货退款结果///%@",dicBig);
        
        if (dicBig)
        {
            if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"])
            {
                [self.navigationController popToRootViewControllerAnimated:NO];
                //登录过期，提示重新登录
                [MyObject failedPrompt:@"用户登录已过期，请重新登录"];
                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
                
            }
            else
            {
                
                NSString *ret=[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"op_title"]];
                [MyObject failedPrompt:ret];
                
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@",[error localizedDescription]);
         
         
     }];

}
//跳转登陆界面
-(void)doTimer_signout
{
    [LJControl cleanAll];
    AppDelegate *app = [AppDelegate sharedUserDefault];
    app.log_View.hidden = NO;//显示登陆界面
}
#pragma mark- MyObjectDelegate
-(void)bottomTableDidEndDecelating:(MyObject *)myObj{


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
