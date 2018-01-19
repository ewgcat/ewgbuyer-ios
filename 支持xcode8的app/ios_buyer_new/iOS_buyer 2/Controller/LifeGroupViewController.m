//
//  LifeGroupViewController.m
//  My_App
//
//  Created by apple on 15-1-23.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LifeGroupViewController.h"
#import "ASIFormDataRequest.h"
#import "NilCell.h"
#import "LoginViewController.h"

@interface LifeGroupViewController (){
    ASIFormDataRequest *request_1;
    ASIFormDataRequest *request3;
}

@end

@implementation LifeGroupViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request3 clearDelegatesAndCancel];
    [request_1 clearDelegatesAndCancel];
}
-(void)backBtnClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
    [myTextView resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    tagReason = 0;
    // Do any additional setup after loading the view.
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    if (ScreenFrame.size.height>480) {//说明是5 5s
        MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    }else{
        MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    }
    MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MyTableView.delegate = self;
    MyTableView.dataSource=  self;
    MyTableView.showsVerticalScrollIndicator=NO;
    MyTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:MyTableView];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 64)];
    view.backgroundColor = MY_COLOR;
    [self.view addSubview:view];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, ScreenFrame.size.width, 44)];
    label.text = @"申请退款";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    [view addSubview:label];
    UILabel *labelX = [[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width -46, 26, 28, 28)];
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
    
    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,GROUPLIFE_RETURN_APPLY_URL]];
    request3=[ASIFormDataRequest requestWithURL:url3];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    [request3 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request3 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    LoginViewController *log = [LoginViewController sharedUserDefault];
    [request3 setPostValue:log.return_group_id forKey:@"group_id"];
    
    [request3 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request3.tag = 101;
    request3.delegate = self;
    [request3 setDidFailSelector:@selector(urlRequestFailed:)];
    [request3 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [request3 startAsynchronous];
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request  responseStatusCode];
    if (statuscode2 == 200) {
        [SYObject endLoading];
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@" %@",dicBig);
        if (dicBig) {
            
        }
        [MyTableView reloadData];
    }
    else{
        [SYObject failedPromptInSuperView:self.view title:@"请求出错"];
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    // 请求响应失败，返回错误信息
    [SYObject failedPromptInSuperView:self.view title:@"网络请求失败"];
}
#pragma mark - tabelView方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 400;
}
-(void)disappear{
    [myTextView resignFirstResponder];
    if (MyTableView.frame.origin.y<0) {
        [UIView beginAnimations:@"srcollView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.275f];
        MyTableView.frame = CGRectMake(MyTableView.frame.origin.x, 64, MyTableView.frame.size.width, MyTableView.frame.size.height);
        [UIView commitAnimations];
    }else{
        
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myTabelviewCell = @"NilCell";
    NilCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NilCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1];
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 388+13)];
    view.backgroundColor = [UIColor whiteColor];
    [cell addSubview:view];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, view.frame.size.width-16, 44)];
    label.textColor =UIColorFromRGB(0xf15353);
    label.text = @"手机端申请退款后，系统自动完成退款流程，退款金额存入账户预存款中";
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 2;
    [view addSubview:label];
    UIImageView *imageline = [[UIImageView alloc]initWithFrame:CGRectMake(0, 54, view.frame.size.width, 0.5)];
    imageline.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:imageline];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 59, view.frame.size.width-16, 30)];
    label2.text = @"商品信息";
    label2.font = [UIFont systemFontOfSize:15];
    [view addSubview:label2];
    UIImageView *imagePhoto = [[UIImageView alloc]initWithFrame:CGRectMake(10, 90, 80, 53)];
    LoginViewController *log = [LoginViewController sharedUserDefault];
    [imagePhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",log.return_group_ImagePhoto]] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
    [view addSubview:imagePhoto];
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(72+26, 84, view.frame.size.width-103, 40)];
    name.text = log.return_group_Name;
    name.numberOfLines = 2;
    name.font = [UIFont systemFontOfSize:13];
    [view addSubview:name];
    UILabel *code = [[UILabel alloc]initWithFrame:CGRectMake(72+26, 124, view.frame.size.width-103, 21)];
    code.text = [NSString stringWithFormat:@"消费码:%@",log.return_group_Code];
    code.numberOfLines = 2;
    code.font = [UIFont systemFontOfSize:13];
    [view addSubview:code];
    
//    UILabel *labelRe = [LJControl labelFrame:CGRectMake(10, 135, ScreenFrame.size.width-30, 44) setText:@"退货数量:" setTitleFont:15 setbackgroundColor:[UIColor whiteColor] setTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
//    [view addSubview:labelRe];
//    textFieldGoodsCount = [LJControl textFieldFrame:CGRectMake(90, 152, ScreenFrame.size.width-105, 30) text:@"3" placeText:@"" setfont:15 textColor:[UIColor blackColor] keyboard:UIKeyboardTypeNumberPad];
//    textFieldGoodsCount.backgroundColor = [UIColor whiteColor];
//    textFieldGoodsCount.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//    textFieldGoodsCount.delegate = self;
//    textFieldGoodsCount.layer.borderWidth = 0.5;
//    [textFieldGoodsCount.layer setMasksToBounds:YES];
//    [textFieldGoodsCount.layer setCornerRadius:2];
//    textFieldGoodsCount.textAlignment = NSTextAlignmentCenter;
//    [cell addSubview:textFieldGoodsCount];
//    UIToolbar * topView2 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 30)];
//    [topView2 setBarStyle:UIBarStyleBlack];
//    UIBarButtonItem * helloButton2 = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
//    UIBarButtonItem * btnSpace2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    UIBarButtonItem *doneButton2 = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
//    NSArray * buttonsArray2 = [NSArray arrayWithObjects:helloButton2,btnSpace2,doneButton2,nil];
//    [topView2 setItems:buttonsArray2];
//    [textFieldGoodsCount setInputAccessoryView:topView2];
    
    UIImageView *imagelineC = [[UIImageView alloc]initWithFrame:CGRectMake(0, 154, view.frame.size.width, 0.5)];
    imagelineC.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:imagelineC];
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(10, 145+13, view.frame.size.width-16, 30-5)];
    label4.text = @"退款原因:";
    label4.font = [UIFont systemFontOfSize:15];
    [view addSubview:label4];
    UILabel *label41 = [[UILabel alloc]initWithFrame:CGRectMake(100, 145+14, view.frame.size.width-90, 30-5)];
    label41.text = @"买错了/重新买";
    label41.font = [UIFont systemFontOfSize:13];
    [view addSubview:label41];
    UILabel *label42 = [[UILabel alloc]initWithFrame:CGRectMake(100, 166+14+9-5, view.frame.size.width-90, 25)];
    label42.text = @"计划有变，没时间消费";
    label42.font = [UIFont systemFontOfSize:13];
    [view addSubview:label42];
    UILabel *label43 = [[UILabel alloc]initWithFrame:CGRectMake(100, 188+14+9+8-10, view.frame.size.width-90, 25)];
    label43.text = @"预约不上";
    label43.font = [UIFont systemFontOfSize:13];
    [view addSubview:label43];
    UILabel *label44 = [[UILabel alloc]initWithFrame:CGRectMake(100, 209+14+11, view.frame.size.width-90, 25)];
    label44.text = @"去过了，不太满意";
    label44.font = [UIFont systemFontOfSize:13];
    [view addSubview:label44];
    UILabel *label45 = [[UILabel alloc]initWithFrame:CGRectMake(100, 230+14+15, view.frame.size.width-90, 25)];
    label45.text = @"其他";
    label45.font = [UIFont systemFontOfSize:13];
    [view addSubview:label45];
    
    UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(75, 158-2, 30, 30)];
    [image1 setImage:[UIImage imageNamed:@"checkbox_no.png"]];
    //checkbox_yes.png
    [view addSubview:image1];
    
    UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(75, 183-2, 30, 30)];
   [image2 setImage:[UIImage imageNamed:@"checkbox_no.png"]];
    [view addSubview:image2];
    
    UIImageView *image3 = [[UIImageView alloc]initWithFrame:CGRectMake(75, 208-2, 30, 30)];
   [image3 setImage:[UIImage imageNamed:@"checkbox_no.png"]];
    [view addSubview:image3];
    
    UIImageView *image4 = [[UIImageView alloc]initWithFrame:CGRectMake(75, 233-2, 30, 30)];
   [image4 setImage:[UIImage imageNamed:@"checkbox_no.png"]];
    [view addSubview:image4];
    
    UIImageView *image5 = [[UIImageView alloc]initWithFrame:CGRectMake(75, 258-2, 30, 30)];
   [image5 setImage:[UIImage imageNamed:@"checkbox_no.png"]];
    [view addSubview:image5];
    
    UIImageView *imageline3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 258+25+4, view.frame.size.width, 0.5)];
    imageline3.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:imageline3];
    
    UILabel *label453 = [[UILabel alloc]initWithFrame:CGRectMake(10, 293, view.frame.size.width-90, 30)];
    label453.text = @"退款说明:";
    label453.font = [UIFont systemFontOfSize:15];
    [view addSubview:label453];
    UITapGestureRecognizer *singleTapGestureRecognizer3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappear)];
    [singleTapGestureRecognizer3 setNumberOfTapsRequired:1];
    [cell addGestureRecognizer:singleTapGestureRecognizer3];
    
    
    if (tagReason == 0) {
        [image1 setImage:[UIImage imageNamed:@"checkbox_yes.png"]];
        [image2 setImage:[UIImage imageNamed:@"checkbox_no.png"]];
        [image3 setImage:[UIImage imageNamed:@"checkbox_no.png"]];
        [image4 setImage:[UIImage imageNamed:@"checkbox_no.png"]];
        [image5 setImage:[UIImage imageNamed:@"checkbox_no.png"]];
        
    }else if(tagReason == 1){
        [image1 setImage:[UIImage imageNamed:@"checkbox_no.png"]];
        [image2 setImage:[UIImage imageNamed:@"checkbox_yes.png"]];
        [image3 setImage:[UIImage imageNamed:@"checkbox_no.png"]];
        [image4 setImage:[UIImage imageNamed:@"checkbox_no.png"]];
        [image5 setImage:[UIImage imageNamed:@"checkbox_no.png"]];
    }else if(tagReason == 2){
        [image1 setImage:[UIImage imageNamed:@"checkbox_no.png"]];
        [image2 setImage:[UIImage imageNamed:@"checkbox_no.png"]];
        [image3 setImage:[UIImage imageNamed:@"checkbox_yes.png"]];
        [image4 setImage:[UIImage imageNamed:@"checkbox_no.png"]];
        [image5 setImage:[UIImage imageNamed:@"checkbox_no.png"]];
    }else if(tagReason == 3){
        [image1 setImage:[UIImage imageNamed:@"checkbox_no.png"]];
        [image2 setImage:[UIImage imageNamed:@"checkbox_no.png"]];
        [image3 setImage:[UIImage imageNamed:@"checkbox_no.png"]];
        [image4 setImage:[UIImage imageNamed:@"checkbox_yes.png"]];
        [image5 setImage:[UIImage imageNamed:@"checkbox_no.png"]];
    }else{
        [image1 setImage:[UIImage imageNamed:@"checkbox_no.png"]];
        [image2 setImage:[UIImage imageNamed:@"checkbox_no.png"]];
        [image3 setImage:[UIImage imageNamed:@"checkbox_no.png"]];
        [image4 setImage:[UIImage imageNamed:@"checkbox_no.png"]];
        [image5 setImage:[UIImage imageNamed:@"checkbox_yes.png"]];
    }
    laLiuyan=[[UILabel alloc]initWithFrame:CGRectMake(86,295, ScreenFrame.size.width - 101, 28)];
    laLiuyan.text=@" 填写退款说明";
    laLiuyan.backgroundColor=[UIColor clearColor];
    laLiuyan.textColor=[UIColor grayColor];
    laLiuyan.font=[UIFont systemFontOfSize:12];
    
    myTextView = [[UITextView alloc]initWithFrame:CGRectMake(86, 298, ScreenFrame.size.width - 101, 44)];
    myTextView.backgroundColor = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    myTextView.delegate = self;
    myTextView.textColor = [UIColor blackColor];
    [myTextView.layer setMasksToBounds:YES];
    [myTextView
     .layer setCornerRadius:4.0];
    [cell addSubview:myTextView];
    [cell addSubview:laLiuyan];
  
    
    WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"取消" leftTarget:self leftAction:@selector(dismissKeyBoard) rightTitle:@"完成" rightTarget:self rightAction:@selector(dismissKeyBoard)];
    [myTextView setInputAccessoryView:inputView];

    
    if (myTextView.text.length == 0) {
        laLiuyan.hidden = NO;
    }else{
        laLiuyan.hidden = YES;
    }
    
    for(int i=0;i<5;i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
        
        
        button.frame =CGRectMake(75, 145+13+25*i, ScreenFrame.size.width - 75, 25);
       
        button.tag = 100+i;
        [button addTarget:self action:@selector(btnReason:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:button];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
    button.frame =CGRectMake(15, 352, ScreenFrame.size.width - 30, 44);
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBtnClicked2) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius=4;
    button.layer.masksToBounds=YES;
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.font  = [UIFont systemFontOfSize:18];
    button.backgroundColor = UIColorFromRGB(0xf15353);
    [cell addSubview:button];
    
    return cell;
}
-(void)dismissKeyBoard{
    [myTextView resignFirstResponder];
    [textFieldGoodsCount resignFirstResponder];
    if (MyTableView.frame.origin.y<0) {
        [UIView beginAnimations:@"srcollView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.275f];
        MyTableView.frame = CGRectMake(MyTableView.frame.origin.x, 64, MyTableView.frame.size.width, MyTableView.frame.size.height);
        [UIView commitAnimations];
    }else{
        
    }
}
-(void)btnReason:(UIButton *)btn{
    if (MyTableView.frame.origin.y<0) {
        [UIView beginAnimations:@"srcollView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.275f];
        MyTableView.frame = CGRectMake(MyTableView.frame.origin.x, 64, MyTableView.frame.size.width, MyTableView.frame.size.height);
        [UIView commitAnimations];
    }else{
        
    }
    if (btn.tag == 100) {
        tagReason = 0;
        [MyTableView reloadData];
    }
    if (btn.tag == 101) {
        tagReason = 1;
        [MyTableView reloadData];
    }
    if (btn.tag == 102) {
        tagReason = 2;
        [MyTableView reloadData];
    }
    if (btn.tag == 103) {
        tagReason = 3;
        [MyTableView reloadData];
    }
    if (btn.tag == 104) {
        tagReason = 4;
        [MyTableView reloadData];
    }
}
-(void)backBtnClicked2{
    if (myTextView.text.length ==0) {
        [SYObject failedPromptInSuperView:self.view title:@"退款说明不能为空"];
    }else{
        NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,GROUPLIFE_RETURN_APPLY_SAVE_URL]];
        request_1=[ASIFormDataRequest requestWithURL:url3];
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
        [request_1 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
        [request_1 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
        LoginViewController *log = [LoginViewController sharedUserDefault];
        [request_1 setPostValue:log.return_group_id forKey:@"group_id"];
        [request_1 setPostValue:myTextView.text forKey:@"return_content"];
        if (tagReason == 0) {
            [request_1 setPostValue:@"买错了/重新买" forKey:@"return_reasion"];
        }else if (tagReason == 1){
            [request_1 setPostValue:@"计划有变，没时间消费" forKey:@"return_reasion"];
        }else if (tagReason == 2){
            [request_1 setPostValue:@"预约不上" forKey:@"return_reasion"];
        }else if (tagReason == 3){
            [request_1 setPostValue:@"去过了，不太满意" forKey:@"return_reasion"];
        }else{
            [request_1 setPostValue:@"其他" forKey:@"return_reasion"];
        }
        
        [request_1 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request_1.tag = 101;
        request_1.delegate = self;
        [request_1 setDidFailSelector:@selector(my1_urlRequestFailed:)];
        [request_1 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
        [request_1 startAsynchronous];
    }
    
}
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request  responseStatusCode];
    if (statuscode2 == 200) {
        [SYObject endLoading];
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@" %@",dicBig);
        if (dicBig) {
            if ([[dicBig objectForKey:@"ret"] isEqualToString:@"true"]) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
        [MyTableView reloadData];
    }
    else{
        [SYObject failedPromptInSuperView:self.view title:@"请求出错"];
    }
    
}
-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPromptInSuperView:self.view title:@"网络请求失败"];
    
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    laLiuyan.hidden = YES;
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    if(self.view.frame.size.height<=480){
        MyTableView.frame = CGRectMake(MyTableView.frame.origin.x, -190, MyTableView.frame.size.width, MyTableView.frame.size.height);
    }else if (ScreenFrame.size.height>480&&ScreenFrame.size.height<=568){
        MyTableView.frame = CGRectMake(MyTableView.frame.origin.x, -120, MyTableView.frame.size.width, MyTableView.frame.size.height);
    }else{
         MyTableView.frame = CGRectMake(MyTableView.frame.origin.x, -60, MyTableView.frame.size.width, MyTableView.frame.size.height);
        
    }
    [UIView commitAnimations];
}
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
        MyTableView.frame = CGRectMake(MyTableView.frame.origin.x, -10, MyTableView.frame.size.width, MyTableView.frame.size.height);
    }else if (ScreenFrame.size.height>480&&ScreenFrame.size.height<=568){
    }else if (ScreenFrame.size.height>568&&ScreenFrame.size.height<=1334/2){
    }else{
    }
    [UIView commitAnimations];
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
