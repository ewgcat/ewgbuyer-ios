//
//  ApplyForReturnViewController.m
//  
//
//  Created by apple on 15/10/22.
//
//

#import "ApplyForReturnViewController.h"
#import "ApplyForGoodTableViewCell.h"
#import "LoginViewController.h"
#import "HJCAjustNumButton.h"
#import "NilCell.h"
@interface ApplyForReturnViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    UITableView *MyTableView;
    UITextView *myTextView;
    HJCAjustNumButton *HJCAbtn;
    NSString *maxCount;
}
@end

@implementation ApplyForReturnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    [self designPage];
    [self getGoodsReturnApply];
    maxCount = @"1";
}
- (IBAction)buttonClick:(UIButton *)sender {
    if (sender.tag==1000) {
         [self dismissViewControllerAnimated:YES completion:nil];
    }else if (sender.tag==1001){
    //提交
        [myTextView resignFirstResponder];
        if ([myTextView.text isEqualToString:@""]) {
            [SYObject failedPromptInSuperView:self.view title:@"请输入问题描述"];
        }
        else if ([HJCAbtn.textField.text isEqualToString:@""]){
            [SYObject failedPromptInSuperView:self.view title:@"申请数量无效"];
        }
        else{
            [self getGoodsReturnApplySave:HJCAbtn.textField.text andGoodsContent:myTextView.text];
        }
        
    }
}
#pragma mark -数据
-(void)getGoodsReturnApply{
    [SYObject startLoadingInSuperview:self.view];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:filePathDong];
    NSLog(@"%@",fileContent);
    NSString *urlstr=[NSString stringWithFormat:@"%@%@",FIRST_URL,BUYER_RETURN_GOODSAPPLY_URL];
    NSLog(@"%@",urlstr);
    NSURL *url=[NSURL URLWithString:urlstr];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    
    LoginViewController *log = [LoginViewController sharedUserDefault];
    [request setPostValue:[fileContent objectAtIndex:3] forKey:@"user_id"];
    [request setPostValue:[fileContent objectAtIndex:1] forKey:@"token"];
    [request setPostValue:[NSString stringWithFormat:@"%@",log.return_oid] forKey:@"oid"];
    [request setPostValue:[NSString stringWithFormat:@"%@",log.return_gsp_ids]forKey:@"goods_gsp_ids"];
    [request setPostValue:[NSString stringWithFormat:@"%@",log.return_goods_id] forKey:@"goods_id"];
    [request setRequestHeaders:[LJControl requestHeaderDictionary]];
    request.delegate=self;
    request.tag=1000;
    [request startAsynchronous];



}
-(void)getGoodsReturnApplySave:(NSString *)goodsCount andGoodsContent:(NSString *)goodsContent{
    [SYObject startLoadingInSuperview:self.view];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:filePathDong];
    NSLog(@"%@",fileContent);
    NSString *urlstr=[NSString stringWithFormat:@"%@%@",FIRST_URL,BUYER_RETURN_GOODSSUPPLY_SAVE_URL];
    NSLog(@"%@",urlstr);
    NSURL *url=[NSURL URLWithString:urlstr];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    
    LoginViewController *log = [LoginViewController sharedUserDefault];
    [request setPostValue:[fileContent objectAtIndex:3] forKey:@"user_id"];
    [request setPostValue:[fileContent objectAtIndex:1] forKey:@"token"];
    [request setPostValue:goodsContent forKey:@"return_goods_content"];
    [request setPostValue:[NSString stringWithFormat:@"%@",log.return_oid] forKey:@"oid"];
    [request setPostValue:[NSString stringWithFormat:@"%@",log.return_gsp_ids]forKey:@"goods_gsp_ids"];
    [request setPostValue:goodsCount forKey:@"return_goods_count"];
    [request setPostValue:[NSString stringWithFormat:@"%@",log.return_goods_id] forKey:@"goods_id"];
    [request setRequestHeaders:[LJControl requestHeaderDictionary]];
    request.delegate=self;
    request.tag=1001;
    [request startAsynchronous];
}

#pragma mark- ASIHTTPRequestDelegate
-(void)requestFinished:(ASIHTTPRequest *)request{
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
    NSLog(@"%@",dic);
    [SYObject endLoading];
    if (request.tag==1000) {
        maxCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"return_count"]];
        HJCAbtn.textField.text = maxCount;
        HJCAbtn.maxNum = maxCount;
        [MyTableView reloadData];
        if ([dic objectForKey:@"return_goods_content"]==nil) {
            myTextView.text=@"";
        }else{
            myTextView.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"return_goods_content"]];
        }
        UIButton *button=(UIButton *)[self.view viewWithTag:1001];
        button.userInteractionEnabled=YES;
    }else if (request.tag==1001){
        if ([[dic objectForKey:@"code"]integerValue]==100) {
            [SYObject failedPromptInSuperView:self.view title:@"退货申请成功，等待商家处理" complete:^{
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }else if ([[dic objectForKey:@"code"]integerValue]==-100){
             [SYObject failedPromptInSuperView:self.view title:@"退货申请未成功，请联系商家"];
        }
    }
    
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"请求错误");
    [SYObject endLoading];
    [SYObject failedPromptInSuperView:self.view title:@"网络请求错误"];
}

#pragma mark -界面
-(void)designPage{
     self.view.backgroundColor=UIColorFromRGB(0Xf0f0f0);
  
    //MyTableView
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
}
#pragma mark- UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 100;
    }else if (indexPath.row==1){
      return 120;
    }else if (indexPath.row==2){
        return 120;
    }else if (indexPath.row==3){
        return 70;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
            static NSString *myTabelviewCell = @"ApplyForGoodTableViewCell";
            ApplyForGoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
            if(cell == nil){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ApplyForGoodTableViewCell" owner:self options:nil] lastObject];
            }
            
            return cell;

    }
    static NSString *myTabelviewCell = @"NilCell";
    NilCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NilCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    for (UIView *subview in cell.subviews) {
        [subview removeFromSuperview];
    }
    if (indexPath.row==1) {
        UIView *headerView=[LJControl viewFrame:CGRectMake(0, 0,ScreenFrame.size.width, 20) backgroundColor: UIColorFromRGB(0Xf0f0f0)];
        [cell addSubview:headerView];
        
        UILabel *numlabel=[LJControl labelFrame:CGRectMake(10,25, cell.contentView.bounds.size.width-20, 30) setText:@"申请数量" setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0X4c4c4c) textAlignment:NSTextAlignmentLeft];
        [cell addSubview:numlabel];
//        LoginViewController *log = [LoginViewController sharedUserDefault];
        
        HJCAbtn = [[HJCAjustNumButton alloc] init];
        HJCAbtn.frame = CGRectMake(10, 60, 100,30);
        HJCAbtn.maxNum=maxCount;
        
        WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"取消" leftTarget:self leftAction:@selector(dismissKeyBoard1) rightTitle:@"完成" rightTarget:self rightAction:@selector(dismissKeyBoard)];
        [HJCAbtn.textField setInputAccessoryView:inputView];

        HJCAbtn.textField.delegate=self;
        [cell addSubview:HJCAbtn];
        UILabel *maxlabel=[LJControl labelFrame:CGRectMake(10, 95, cell.contentView.bounds.size.width-20, 20) setText: maxCount ? [NSString stringWithFormat:@"您最多可提交数量%@个",maxCount] : [NSString stringWithFormat:@"您最多可提交数量1个"] setTitleFont:11 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0Xb2b2b2) textAlignment:NSTextAlignmentLeft];
        [cell addSubview:maxlabel];
        
    }else if (indexPath.row==2) {
        UIView *headerView=[LJControl viewFrame:CGRectMake(0, 0,ScreenFrame.size.width, 20) backgroundColor: UIColorFromRGB(0Xf0f0f0)];
        [cell addSubview:headerView];
        
        UILabel *numlabel=[LJControl labelFrame:CGRectMake(10, 25, cell.contentView.bounds.size.width-20, 30) setText:@"问题描述" setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0X4c4c4c) textAlignment:NSTextAlignmentLeft];
        [cell addSubview:numlabel];
        
//        myTextView=[LJControl textFieldFrame:CGRectMake(10, 60, ScreenFrame.size.width-20, 50) text:@"" placeText:@" 请您在此描述详细问题" setfont:14 textColor:UIColorFromRGB(0X333333) keyboard:UIKeyboardTypeDefault];
        myTextView=[LJControl textViewFrame:CGRectMake(10, 60, ScreenFrame.size.width-20, 50) text:@"" setfont:14 textColor:UIColorFromRGB(0X333333) keyboard:UIKeyboardTypeDefault];
        
        myTextView.delegate = self;
        myTextView.layer.borderWidth = 1;
        [myTextView.layer setMasksToBounds:YES];
        [myTextView.layer setCornerRadius:8];
        [myTextView.layer setBorderColor:[UIColorFromRGB(0X999999) CGColor]];
        myTextView.backgroundColor=UIColorFromRGB(0xf9f9f9);
        //myTextView.returnKeyType=UIReturnKeyDefault;
        
        WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"取消" leftTarget:self leftAction:@selector(dismissKeyBoardOne) rightTitle:@"完成" rightTarget:self rightAction:@selector(dismissKeyBoardOne)];
        [myTextView setInputAccessoryView:inputView];
        
        [cell addSubview:myTextView];

    }else if (indexPath.row==3) {
        cell.backgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1];
        UIButton *button=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(50, 20, ScreenFrame.size.width-100, 30) setNormalImage:nil setSelectedImage:nil setTitle:@"" setTitleFont:0 setbackgroundColor:[UIColor clearColor]];
        button.tag=1001;
        UILabel *label=[LJControl labelFrame:CGRectMake(0, 0,ScreenFrame.size.width-100, 40) setText:@"提 交" setTitleFont:17 setbackgroundColor:UIColorFromRGB(0Xfd5d5d) setTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [label.layer setMasksToBounds:YES];
        [label.layer setCornerRadius:4];
        [button addSubview:label];
        [cell addSubview:button];
        
    }
    return cell;
    
}
-(void)dismissKeyBoardOne
{
    [myTextView resignFirstResponder];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
#pragma mark -UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
   // if (textField==myTextView) {
        [myTextView resignFirstResponder];
    //}
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField==HJCAbtn.textField) {
        [UIView animateWithDuration:1 animations:^{
            MyTableView.contentOffset=CGPointMake(0,60);
        }];
    }
    
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:1 animations:^{
        MyTableView.contentOffset=CGPointMake(0, 0);
    }];
    
}
-(void)dismissKeyBoard{
    if ([HJCAbtn.textField.text intValue]<=0) {
        HJCAbtn.textField.text=@"1";
        [HJCAbtn.textField resignFirstResponder];
        [SYObject failedPromptInSuperView:self.view title:@"退货数量不能为零"];
    }else if ([HJCAbtn.textField.text intValue]<=[maxCount intValue]) {
        [HJCAbtn.textField resignFirstResponder];
    }else{
        HJCAbtn.textField.text = maxCount;
        [HJCAbtn.textField resignFirstResponder];
        [SYObject failedPromptInSuperView:self.view title:@"退货数量不能大于购买数量"];
    }
}
-(void)dismissKeyBoard1
{
   
    [HJCAbtn.textField resignFirstResponder];
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    [UIView animateWithDuration:1 animations:^{
        MyTableView.contentOffset=CGPointMake(0,200);
    }];
    
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:1 animations:^{
        MyTableView.contentOffset=CGPointMake(0, 0);
    }];
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
