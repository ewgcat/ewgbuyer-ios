//
//  ReceiveCouponsViewController.m
//  My_App
//
//  Created by apple on 15/10/12.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ReceiveCouponsViewController.h"
#import "FreeCouponsViewController.h"
#import "ReceiveSuccessCell.h"
#import "ReceiveGoodsCell.h"
#import "DetailViewController.h"
#import "SecondViewController.h"

@interface ReceiveCouponsViewController (){
    FreeCouponsViewController *free;
    ASIFormDataRequest *RequestReceiveCoupons;
    ASIFormDataRequest *RequestCode;
}

@end

@implementation ReceiveCouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"领取优惠券";
    [self createBackBtn];
    dataArray = [[NSMutableArray alloc]init];
    
    //设置layer
    [CodeBgImage.layer setMasksToBounds:YES];
    [CodeBgImage.layer setCornerRadius:4];
    [ReceiveBtn.layer setMasksToBounds:YES];
    [ReceiveBtn.layer setCornerRadius:4];
    [coupons_Info.layer setMasksToBounds:YES];
    [coupons_Info.layer setCornerRadius:10];
//    [LoadingGrayView.layer setMasksToBounds:YES];
//    [LoadingGrayView.layer setCornerRadius:4];
//    [PromptLabel.layer setMasksToBounds:YES];
//    [PromptLabel.layer setCornerRadius:4];
//    PromptLabel.hidden=YES;
//    //
//    LoadingView.hidden = YES;
    ReceiveBtn.backgroundColor = RGB_COLOR(200, 200, 200);
    
    //代理
    CodeTextField.delegate = self;
    
    WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"取消" leftTarget:self leftAction:@selector(editBtn) rightTitle:@"完成" rightTarget:self rightAction:@selector(editBtn)];
    [CodeTextField setInputAccessoryView:inputView];
    
    ReceiveSuccessTableView.delegate = self;
    ReceiveSuccessTableView.dataSource = self;
    ReceiveSuccessTableView.hidden = YES;
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    
    //优惠券数据
    free = [FreeCouponsViewController sharedUserDefault];
    [coupons_Image sd_setImageWithURL:(NSURL*)free.ReceiveModel.coupon_pic placeholderImage:[UIImage imageNamed:@"kong_lj"]];
    coupons_Price.text = [NSString stringWithFormat:@"%@",free.ReceiveModel.coupon_amount];
    coupons_Time.text = [NSString stringWithFormat:@"%@至%@",free.ReceiveModel.coupon_beginTime,free.ReceiveModel .coupon_endTime];
    coupons_Info.text = [NSString stringWithFormat:@"  满%@元使用",free.ReceiveModel.coupon_order_amount];
    coupons_Name.text = free.ReceiveModel.coupon_name;
    
    [self CodeNetWorking];
    
    [codeRefreshBtm addTarget:self action:@selector(codeRegreshBtnAction) forControlEvents:UIControlEventTouchUpInside];
}
-(void)editBtn
{
    [CodeTextField resignFirstResponder];
     [self dismissKeyBoard];

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
-(void)codeRegreshBtnAction{
    [self CodeNetWorking];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [RequestReceiveCoupons clearDelegatesAndCancel];
    [RequestCode clearDelegatesAndCancel];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self dismissKeyBoard];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGFloat keyboardHeight = 216.0f;
    if (self.view.frame.size.height - keyboardHeight <= textField.frame.origin.y + textField.frame.size.height) {
        CGFloat y = textField.frame.origin.y - (self.view.frame.size.height - keyboardHeight - textField.frame.size.height - 35);
        
        [UIView beginAnimations:@"srcollView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.275f];
        self.view.frame = CGRectMake(self.view.frame.origin.x, -y, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    return YES;
}
-(void)dismissKeyBoard{
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    self.view.frame = CGRectMake(0, 64, ScreenFrame.size.width, ScreenFrame.size.height-64);
    [UIView commitAnimations];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - 网络
-(void)CodeNetWorking{
//    LoadingView.hidden = NO;
    [SYObject startLoading];
    codeStr = [NSString stringWithFormat:@"%d%d%d%d",(arc4random() % 9) + 1,(arc4random() % 9) + 1,(arc4random() % 9) + 1,(arc4random() % 9) + 1];
    RequestCode = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@?verify_str=%@",FIRST_URL,APP_VERIFY_URL,codeStr] setKey:nil setValue:nil];
    RequestCode.delegate = self;
        [RequestCode setDidFailSelector:@selector(RequestFailed:)];
        [RequestCode setDidFinishSelector:@selector(RequestCodeSucceeded:)];
        [RequestCode startAsynchronous];
}
-(void)netWorking{
    NSArray *keyArr = [[NSArray alloc]initWithObjects:@"user_id",@"coupon_id", nil];
    NSArray *valueArr = [[NSArray alloc]initWithObjects:[USER_INFORMATION objectAtIndex:3],free.ReceiveModel.coupon_id, nil];
    RequestReceiveCoupons = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,CAPTURE_COUPONS_URL] setKey:keyArr setValue:valueArr];
    
    RequestReceiveCoupons.delegate = self;
    [RequestReceiveCoupons setDidFailSelector:@selector(RequestFailed:)];
    [RequestReceiveCoupons setDidFinishSelector:@selector(RequestReceiveCouponsSucceeded:)];
    [RequestReceiveCoupons startAsynchronous];
}
-(void)RequestCodeSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request  responseStatusCode];
    if (statuscode2 == 200) {
        [CodeImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?verify_str=%@",FIRST_URL,APP_VERIFY_URL,codeStr]] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
    }
    else{
        [SYObject failedPrompt:@"请求出错"];
    }
//    LoadingView.hidden = YES;
    [SYObject endLoading];
    ReceiveBtn.backgroundColor = RGB_COLOR(241, 83, 83);
}
-(void)RequestReceiveCouponsSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request  responseStatusCode];
    if (statuscode2 == 200) {
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        if([[[consultViewNetwork dataReveciveCouponsLData:request] objectAtIndex:0] intValue] == 1){
            dataArray = [[consultViewNetwork dataReveciveCouponsLData:request] objectAtIndex:1];
            [ReceiveSuccessTableView reloadData];
            ReceiveSuccessTableView.hidden = NO;
        }
    }
    else{
        [SYObject failedPrompt:@"请求出错"];
        [SYObject endLoading];
    }
//    LoadingView.hidden = YES;
    [SYObject endLoading];
}
-(void)RequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
    [SYObject endLoading];
}
//-(void)failedPrompt:(NSString *)prompt{
////    LoadingView.hidden = YES;
//    [SYObject endLoading];
//    PromptLabel.hidden = NO;
//    PromptLabel.text = prompt;
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
//}
//-(void)TimeOutdoTimer{
//    
//}
//-(void)doTimer{
//    PromptLabel.hidden = YES;
//}

#pragma mark - 点击事件
//商品点击事件
-(void)goodBtnClicked:(UIButton *)btn{
    ClassifyModel *classLeft = [dataArray objectAtIndex:btn.tag];
    SecondViewController *sec = [SecondViewController sharedUserDefault];
    NSLog(@"classLeft.goods_idclassLeft.goods_id:%@",classLeft.goods_id);
    sec.detail_id = classLeft.goods_id;
    DetailViewController *detail = [[DetailViewController alloc]init];
    [self.navigationController pushViewController:detail animated:YES];
}

- (IBAction)ReceiveBtnAction:(id)sender {
    [self dismissKeyBoard];
//    LoadingView.hidden = NO;
    [SYObject startLoading];
    
    //判断验证码是否正确
    NSLog(@"codeStrcodeStr:%@",codeStr);
    NSLog(@"CodeTextField:%@",CodeTextField.text);
    if ([codeStr isEqualToString:CodeTextField.text]) {
        [self netWorking];
    }else if(CodeTextField.text.length == 0){
        [SYObject failedPrompt:@"请输入验证码"];
        [SYObject endLoading];
    }else{
        [SYObject failedPrompt:@"验证码不正确"];
        [SYObject endLoading];
    }
}

#pragma mark - tableview代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArray.count != 0) {
        if (dataArray.count%2 == 0){
            return dataArray.count/2+1;
        }
        else{
            return dataArray.count/2+2;
        }
    }else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 308;
    }else{
        return (ScreenFrame.size.width-36)/2+71;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (dataArray.count!=0) {
        if (indexPath.row == 0) {
            ReceiveSuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiveSuccessCell"];
            if(cell == nil){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ReceiveSuccessCell" owner:self options:nil] lastObject];
            }
            return cell;
        }else{
            ReceiveGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiveGoodsCell"];
            if(cell == nil){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ReceiveGoodsCell" owner:self options:nil] lastObject];
            }
            if (dataArray.count != 0) {
                ClassifyModel *classLeft = [dataArray objectAtIndex:(indexPath.row-1)*2];
                ClassifyModel *classRight;
                cell.LeftBtn.tag = (indexPath.row-1)*2;
                cell.RightBtn.tag = (indexPath.row-1)*2+1;
                [cell.LeftBtn addTarget:self action:@selector(goodBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [cell.RightBtn addTarget:self action:@selector(goodBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                if (dataArray.count%2 == 0) {//成双
                    classRight = [dataArray objectAtIndex:(indexPath.row-1)*2+1];
                }else{
                    if (indexPath.row-1 == dataArray.count/2) {
                        classRight = classLeft;
                        cell.ReceiveGoods_RightView.hidden = YES;
                        cell.RightBtn.hidden = YES;
                    }else{
                        classRight = [dataArray objectAtIndex:(indexPath.row-1)*2+1];
                        cell.ReceiveGoods_RightView.hidden = NO;
                        cell.RightBtn.hidden = NO;
                    }
                }
                [cell setData:classLeft rightData:classRight];
            }
            return cell;
        }
    }else{
        ReceiveSuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiveSuccessCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ReceiveSuccessCell" owner:self options:nil] lastObject];
        }
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    return cell;
}
@end
