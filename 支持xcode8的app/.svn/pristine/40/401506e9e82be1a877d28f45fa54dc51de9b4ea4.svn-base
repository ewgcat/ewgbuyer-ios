//
//  goodsReturnApplyViewController.m
//  My_App
//
//  Created by apple on 15-1-22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "goodsReturnApplyViewController.h"
#import "ASIFormDataRequest.h"
#import "LoginViewController.h"
#import "NilCell.h"

@interface goodsReturnApplyViewController ()

@end

@implementation goodsReturnApplyViewController
-(void)backBtnClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
    [myTextView resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 64)];
    view.backgroundColor = MY_COLOR;
    [self.view addSubview:view];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, ScreenFrame.size.width, 44)];
    label.text = @"申请退货";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:17];
    [view addSubview:label];
    
    UILabel *labelX = [[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width - 46, 26, 28, 28)];
    labelX.text = @"×";
    labelX.textAlignment = NSTextAlignmentCenter;
    labelX.textColor = [UIColor whiteColor];
    labelX.font = [UIFont boldSystemFontOfSize:30];
    [view addSubview:labelX];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
    button.frame =CGRectMake(ScreenFrame.size.width - 46, 28, 28, 28);
    [button setTitle:@"" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.font  = [UIFont systemFontOfSize:34];
    button.layer.borderWidth = 2;
    button.layer.borderColor = [[UIColor whiteColor] CGColor];
    CALayer *lay3  = button.layer;
    [lay3 setMasksToBounds:YES];
    [lay3 setCornerRadius:14.0];
    [view addSubview:button];
    
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    if (ScreenFrame.size.height>480) {//说明是5 5s
        MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    }else{
        MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    }
    MyTableView.backgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1];
    MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MyTableView.delegate = self;
    MyTableView.dataSource=  self;
    MyTableView.showsVerticalScrollIndicator=NO;
    MyTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:MyTableView];
    
    LoginViewController *log = [LoginViewController sharedUserDefault];
    NSArray *keyArr = [[NSArray alloc]initWithObjects:@"user_id",@"token",@"goods_gsp_ids",@"oid",@"goods_id", nil];
    NSArray *valueArr = [[NSArray alloc]initWithObjects:[USER_INFORMATION objectAtIndex:3],[USER_INFORMATION objectAtIndex:1],log.return_gsp_ids,[NSString stringWithFormat:@"%@",log.return_oid],[NSString stringWithFormat:@"%@",log.return_goods_id], nil];
    request_1 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,BUYER_RETURN_GOODSAPPLY_URL] setKey:keyArr setValue:valueArr];
    request_1.delegate = self;
    [request_1 setDidFailSelector:@selector(urlRequestFailed:)];
    [request_1 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [request_1 startAsynchronous];
}
#pragma mark - 网络
-(void)my2_urlRequestSucceeded:(ASIFormDataRequest *)request{
    
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"提交：%@",dicBig);
        if([[dicBig objectForKey:@"ret"] isEqualToString:@"true"]){
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [SYObject failedPromptInSuperView:self.view title:@"提交失败，请重新尝试"];
        }
        [SYObject endLoading];
    }
    else{
        [SYObject failedPromptInSuperView:self.view title:@"请求出错"];
    }
    
}
-(void)my2_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPromptInSuperView:self.view title:@"网络请求失败"];
}
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request  responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"取消退款：%@",dicBig);
        if([[dicBig objectForKey:@"ret"] isEqualToString:@"true"]){
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [SYObject failedPromptInSuperView:self.view title:@"取消失败，请重新尝试"];
        }
        [SYObject endLoading];
    }
    else{
        [SYObject failedPromptInSuperView:self.view title:@"请求出错"];
    }
    
}
-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPromptInSuperView:self.view title:@"网络请求失败"];
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        [SYObject endLoading];
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if (dicBig) {
            return_count = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"return_count"]] ;
            
            if ([[dicBig allKeys] containsObject:@"return_goods_content"]) {
                content = [dicBig objectForKey:@"return_goods_content"];
            }else{
                content = @"";
            }
        }
        [MyTableView reloadData];
    }
    else{
        [SYObject failedPromptInSuperView:self.view title:@"请求出错"];
    }
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPromptInSuperView:self.view title:@"网络请求失败"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//TODO:tabelView方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 400;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myTabelviewCell = @"NilCell";
    NilCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NilCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1];
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 10, ScreenFrame.size.width, 282)];
    view.backgroundColor = [UIColor whiteColor];
    [cell addSubview:view];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 6, ScreenFrame.size.width-30, 40)];
    label.numberOfLines = 2;
    label.text = @"提交申请后请及时与商家联系,商家同意退货后可填写退货物流信息";
    label.textColor = MY_COLOR;
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 45, view.frame.size.width, 0.5)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:line1];
    
    LoginViewController *log = [LoginViewController sharedUserDefault];
    UIImageView *imagePhoto = [[UIImageView alloc]initWithFrame:CGRectMake(19, 64, 50, 50)];
    [imagePhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",log.return_ImagePhoto]] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
    [view addSubview:imagePhoto];
    
    UILabel *labelRe = [LJControl labelFrame:CGRectMake(15, 145, ScreenFrame.size.width-30, 30) setText:@"退货数量:" setTitleFont:17 setbackgroundColor:[UIColor whiteColor] setTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [view addSubview:labelRe];
    textFieldGoodsCount = [LJControl textFieldFrame:CGRectMake(90, 155, ScreenFrame.size.width-105, 30) text:@"3" placeText:@"" setfont:17 textColor:[UIColor blackColor] keyboard:UIKeyboardTypeNumberPad];
    textFieldGoodsCount.backgroundColor = [UIColor whiteColor];
    textFieldGoodsCount.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    textFieldGoodsCount.delegate = self;
    textFieldGoodsCount.layer.borderWidth = 0.5;
    [textFieldGoodsCount.layer setMasksToBounds:YES];
    [textFieldGoodsCount.layer setCornerRadius:2];
    textFieldGoodsCount.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:textFieldGoodsCount];
    
    WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"取消" leftTarget:self leftAction:@selector(dismissKeyBoard) rightTitle:@"完成" rightTarget:self rightAction:@selector(dismissKeyBoard)];
    [textFieldGoodsCount setInputAccessoryView:inputView];
    
    UILabel *label22 = [[UILabel alloc]initWithFrame:CGRectMake(15, 175, ScreenFrame.size.width-30, 21)];
    label22.text = @"申请说明";
    [view addSubview:label22];
    
    UITapGestureRecognizer *singleTapGestureRecognizer3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    [singleTapGestureRecognizer3 setNumberOfTapsRequired:1];
    [cell addGestureRecognizer:singleTapGestureRecognizer3];
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(78, 58, view.frame.size.width-90, 44)];
    name.text = log.return_Name;
    name.numberOfLines = 2;
    name.font = [UIFont systemFontOfSize:15];
    [view addSubview:name];
    UILabel *spec = [[UILabel alloc]initWithFrame:CGRectMake(78, 105, view.frame.size.width-90, 20)];
    spec.text = @"规格:64G 白色 港版";
    spec.font = [UIFont systemFontOfSize:13];
    [view addSubview:spec];
    UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 130, view.frame.size.width, 0.5)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:line2];
    
    laLiuyan=[[UILabel alloc]initWithFrame:CGRectMake(20, 206, ScreenFrame.size.width - 40, 28)];
    laLiuyan.text=@" 填写留言可提高审核通过率,请认真填写.";
    laLiuyan.backgroundColor=[UIColor clearColor];
    laLiuyan.textColor=[UIColor grayColor];
    laLiuyan.font=[UIFont systemFontOfSize:12];
    
    myTextView = [[UITextView alloc]initWithFrame:CGRectMake(15, 210, ScreenFrame.size.width - 30, 40)];
    myTextView.backgroundColor = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    myTextView.delegate = self;
    myTextView.textColor = [UIColor blackColor];
    [cell addSubview:myTextView];
    [cell addSubview:laLiuyan];
    if (myTextView.text.length == 0) {
        laLiuyan.hidden = NO;
    }else{
        laLiuyan.hidden = YES;
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
    button.frame =CGRectMake(10, 260, ScreenFrame.size.width - 20, 34);
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBtnClicked2) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius=4;
    button.layer.masksToBounds=YES;
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.font  = [UIFont boldSystemFontOfSize:18];
    button.backgroundColor = MY_COLOR;
    [cell addSubview:button];
    if (log.return_CancelBool == NO) {
        laLiuyan.hidden = YES;
        myTextView.text =  content;
        myTextView.userInteractionEnabled = NO;
        [button setTitle:@"取消退货" forState:UIControlStateNormal];
    }else{
        laLiuyan.hidden = NO;
        myTextView.text = content;
        myTextView.userInteractionEnabled = YES;
    }
    
    
    WDInputView *inputView1=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"取消" leftTarget:self leftAction:@selector(dismissKeyBoard) rightTitle:@"完成" rightTarget:self rightAction:@selector(dismissKeyBoard)];
    [myTextView setInputAccessoryView:inputView1];

    return cell;
}
-(void)dismissKeyBoard{
    [myTextView resignFirstResponder];
    [textFieldGoodsCount resignFirstResponder];
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    myTextView.frame = CGRectMake(myTextView.frame.origin.x, 210, myTextView.frame.size.width, myTextView.frame.size.height);
    textFieldGoodsCount.frame = CGRectMake(textFieldGoodsCount.frame.origin.x, 155, textFieldGoodsCount.frame.size.width, textFieldGoodsCount.frame.size.height);
    [UIView commitAnimations];
}
-(void)backBtnClicked2{
    [SYObject startLoadingInSuperview:self.view];
    LoginViewController *log = [LoginViewController sharedUserDefault];
    if (log.return_CancelBool == NO) {
        //发起取消退货请求
        LoginViewController *log = [LoginViewController sharedUserDefault];
        NSArray *keyArr = [[NSArray alloc]initWithObjects:@"user_id",@"token",@"goods_gsp_ids",@"oid",@"goods_id", nil];
        NSArray *valueArr = [[NSArray alloc]initWithObjects:[USER_INFORMATION objectAtIndex:3],[USER_INFORMATION objectAtIndex:1],log.return_gsp_ids,[NSString stringWithFormat:@"%@",log.return_oid],[NSString stringWithFormat:@"%@",log.return_goods_id], nil];
        request_2 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,BUYER_RETURN_GOODS_CANCEL_SAVE_URL] setKey:keyArr setValue:valueArr];
        
        request_2.delegate = self;
        [request_2 setDidFailSelector:@selector(my1_urlRequestFailed:)];
        [request_2 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
        [request_2 startAsynchronous];
    }else{
        if (myTextView.text.length == 0) {
            [SYObject failedPromptInSuperView:self.view title:@"请输入申请说明"];
        }else{
            //发起请求
            LoginViewController *log = [LoginViewController sharedUserDefault];
            NSArray *keyArr = [[NSArray alloc]initWithObjects:@"user_id",@"token",@"return_goods_content",@"oid",@"goods_gsp_ids", @"return_goods_count",@"goods_id", nil];
            NSArray *valueArr = [[NSArray alloc]initWithObjects:[USER_INFORMATION objectAtIndex:3],[USER_INFORMATION objectAtIndex:1],myTextView.text,[NSString stringWithFormat:@"%@",log.return_oid],log.return_gsp_ids,return_count,[NSString stringWithFormat:@"%@",log.return_goods_id], nil];
            request_3 = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,BUYER_RETURN_GOODSSUPPLY_SAVE_URL] setKey:keyArr setValue:valueArr];
            
            request_3.delegate = self;
            [request_3 setDidFailSelector:@selector(my2_urlRequestFailed:)];
            [request_3 setDidFinishSelector:@selector(my2_urlRequestSucceeded:)];
            [request_3 startAsynchronous];
        }
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request_1 clearDelegatesAndCancel];
    [request_2 clearDelegatesAndCancel];
    [request_3 clearDelegatesAndCancel];
}

#pragma mark - delegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length == 0) {
        textField.text = @"1";
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    if (ScreenFrame.size.height<=480) {
        textField.frame = CGRectMake(textField.frame.origin.x, 120, textField.frame.size.width, textField.frame.size.height);
    }else if (ScreenFrame.size.height>480&&ScreenFrame.size.height<=568){
    }else if (ScreenFrame.size.height>568&&ScreenFrame.size.height<=1334/2){
    }else{
    }
    [UIView commitAnimations];
    return YES;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    laLiuyan.hidden = YES;
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    if (ScreenFrame.size.height<=480) {
        textView.frame = CGRectMake(textView.frame.origin.x, 80, textView.frame.size.width, textView.frame.size.height);
    }else if (ScreenFrame.size.height>480&&ScreenFrame.size.height<=568){
    }else if (ScreenFrame.size.height>568&&ScreenFrame.size.height<=1334/2){
    }else{
    }
    [UIView commitAnimations];
    return YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
