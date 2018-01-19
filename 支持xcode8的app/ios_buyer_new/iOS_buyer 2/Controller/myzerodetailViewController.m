//
//  myzerodetailViewController.m
//  My_App
//
//  Created by apple on 15-1-5.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "myzerodetailViewController.h"
#import "NilCell.h"
#import "ASIFormDataRequest.h"
#import "LoginViewController.h"

@interface myzerodetailViewController (){
    ASIFormDataRequest *request3;
    ASIFormDataRequest *request_1;
}
@property(nonatomic,assign)CGPoint yiqiandenagedian;
@end

@implementation myzerodetailViewController

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillAppear:YES];
    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,FREE_ORDERDETAIL_URL]];
    request3=[ASIFormDataRequest requestWithURL:url3];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    [request3 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request3 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    LoginViewController *log = [LoginViewController sharedUserDefault];
    [request3 setPostValue:log.lifeGroup_oid forKey:@"oid"];
    
    [request3 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request3.tag = 101;
    request3.delegate = self;
    [request3 setDidFailSelector:@selector(my2_urlRequestFailed:)];
    [request3 setDidFinishSelector:@selector(my2_urlRequestSucceeded:)];
    [request3 startAsynchronous];
    [SYObject startLoading];
}
-(void)my2_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"dicBig：%@",dicBig);
    if (statuscode2 == 200) {
        
        
        NSDictionary *dic = [dicBig objectForKey:@"data"];
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        ClassifyModel *class = [[ClassifyModel alloc]init];
        class.goods_addTime = [dic objectForKey:@"addTime"];
        class.goods_apply_status = [dic objectForKey:@"apply_status"];
        class.goods_evaluate_status = [dic objectForKey:@"evaluate_status"];
        class.goods_main_photo = [dic objectForKey:@"goods_img"];
        class.goods_name = [dic objectForKey:@"goods_name"];
        class.goods_oid = [dic objectForKey:@"oid"];
        class.goods_receiver_address = [dic objectForKey:@"receiver_address"];
        class.detail_goods_bad_evaluate = [dic objectForKey:@"shipCode"];
        class.detail_goods_middle_evaluate = [dic objectForKey:@"express_company_name"];
        NSString *ss = [dic objectForKey:@"receiver_tel"];
        if (ss.length == 0) {
            class.goods_receiver_tel = @"";
        }else{
            class.goods_receiver_tel = [dic objectForKey:@"receiver_tel"];
        }
        NSString *ss2 = [dic objectForKey:@"receiver_mobile"];
        if (ss2.length == 0) {
            class.goods_receiver_mobile = @"";
        }else{
            class.goods_receiver_mobile = [dic objectForKey:@"receiver_mobile"];
        }
        class.goods_return_content = [dic objectForKey:@"use_experience"];
        class.goods_receiver_name = [dic objectForKey:@"receiver_name"];
        [dataArray addObject:class];
        [MyTableView reloadData];
        [SYObject endLoading];
    }
    else{
        [SYObject failedPrompt:@"请求出错"];
    }
    
}

-(void)my2_urlRequestFailed:(ASIFormDataRequest *)request{
    // 请求响应失败，返回错误信息
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)createRealBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backRealBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;

    
}
-(void)backRealBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"0元购详情";
    dataArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createRealBackBtn];
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MyTableView.delegate = self;
    MyTableView.dataSource=  self;
    MyTableView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1];
    MyTableView.showsVerticalScrollIndicator=NO;
    MyTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:MyTableView];
    UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backRealBtnClicked)];
    rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
    [MyTableView addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];
}
//tabelView方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 540;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myTabelviewCell = @"NilCell";
    NilCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NilCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1];
    }
    if (dataArray.count!=0) {
        ClassifyModel *class = [dataArray objectAtIndex:0];
        
        UIView *diView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 550)];
        diView.backgroundColor = [UIColor whiteColor];
        [cell addSubview:diView];
//        diView.layer.borderWidth = 1;
//        diView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        
        UIImageView *imagePhoto = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, diView.frame.size.width-16, 114)];
        [imagePhoto sd_setImageWithURL:(NSURL*)[NSString stringWithFormat:@"%@",class.goods_main_photo]  placeholderImage:[UIImage imageNamed:@"kong_lj"]];
        [diView addSubview:imagePhoto];
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(11, 123, diView.frame.size.width-22, 40)];
        name.text = class.goods_name;
        name.font=[UIFont systemFontOfSize:15];
        [diView addSubview:name];
        UIView *name2 = [[UIView alloc]initWithFrame:CGRectMake(0, 158, diView.frame.size.width, 0.5)];
        name2.backgroundColor = UIColorFromRGB(0xd7d7d7);
        [diView addSubview:name2];
        UILabel *state = [[UILabel alloc]initWithFrame:CGRectMake(1, 155, 78, 40)];
        state.text = @"  订单状态:";
        state.font = [UIFont systemFontOfSize:15];
        [diView addSubview:state];
        UILabel *checkStatus = [[UILabel alloc]initWithFrame:CGRectMake(78, 155, ScreenFrame.size.width-88, 40)];
        checkStatus.text = @"";
        checkStatus.textColor = MY_COLOR;
        checkStatus.font = [UIFont systemFontOfSize:15];
        [diView addSubview:checkStatus];
        UILabel *time2 = [[UILabel alloc]initWithFrame:CGRectMake(1, 185, 78, 40)];
        time2.text = @"  申请时间:";
        time2.font = [UIFont systemFontOfSize:15];
        [diView addSubview:time2];
        UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(78, 185, diView.frame.size.width-80, 40)];
        time.text = class.goods_addTime;
        time.font = [UIFont systemFontOfSize:15];
        [diView addSubview:time];
        UIView *name3 = [[UIView alloc]initWithFrame:CGRectMake(0, 224, diView.frame.size.width, 0.5)];
        name3.backgroundColor =  UIColorFromRGB(0xd7d7d7);
        [diView addSubview:name3];
        
        UILabel *Pname = [[UILabel alloc]initWithFrame:CGRectMake(33, 239, (diView.frame.size.width-10)/2, 21)];
        Pname.text = [NSString stringWithFormat:@"%@",class.goods_receiver_name];
        Pname.font = [UIFont systemFontOfSize:15];
        [diView addSubview:Pname];
        
        UIImageView *iconImg=[LJControl imageViewFrame:CGRectMake(10, 241, 16, 16) setImage:@"iconNew" setbackgroundColor:[UIColor clearColor]];
        [diView addSubview:iconImg];
        
        
        UILabel *mobile = [[UILabel alloc]initWithFrame:CGRectMake(5+(diView.frame.size.width-10)/2, 239, (diView.frame.size.width-10)/2, 21)];
        mobile.font = [UIFont systemFontOfSize:15];
        mobile.textAlignment =NSTextAlignmentLeft;
        [diView addSubview:mobile];
        
        UIImageView *phoneImg=[LJControl imageViewFrame:CGRectMake(5+(diView.frame.size.width-10)/2-19, 241, 16, 16) setImage:@"iphone" setbackgroundColor:[UIColor clearColor]];
        [diView addSubview:phoneImg];
        
        UILabel *address = [[UILabel alloc]initWithFrame:CGRectMake(33, 260, (diView.frame.size.width-33-10), 30)];
        address.font = [UIFont systemFontOfSize:13];
        address.numberOfLines = 2;
        address.textColor=UIColorFromRGB(0x666666);
        address.text = class.goods_receiver_address;
        [diView addSubview:address];
        UIImageView *locationImg=[LJControl imageViewFrame:CGRectMake(10, 265, 16, 19) setImage:@"location" setbackgroundColor:[UIColor clearColor]];
        [diView addSubview:locationImg];
        
        
        UIView *name4 = [[UIView alloc]initWithFrame:CGRectMake(0, 301, diView.frame.size.width,0.5)];
        name4.backgroundColor = UIColorFromRGB(0xd7d7d7);
        [diView addSubview:name4];
       
        
        
        UILabel *www = [[UILabel alloc]initWithFrame:CGRectMake(1, 308, 78, 21)];
        www.text = @"物流公司:";
        www.textAlignment=NSTextAlignmentCenter;
        www.font = [UIFont systemFontOfSize:15];
        [diView addSubview:www];
        UILabel *company = [[UILabel alloc]initWithFrame:CGRectMake(79, 308, diView.frame.size.width-80, 21)];
        company.text = @"";
        company.font = [UIFont systemFontOfSize:15];
        [diView addSubview:company];
        UILabel *www2 = [[UILabel alloc]initWithFrame:CGRectMake(1, 332, 78, 21)];
        www2.text = @"物流单号:";
         www2.textAlignment=NSTextAlignmentCenter;
        www2.font = [UIFont systemFontOfSize:15];
        [diView addSubview:www2];
        UILabel *ship_orderid = [[UILabel alloc]initWithFrame:CGRectMake(79, 332, diView.frame.size.width-80, 21)];
        ship_orderid.text = @"";
        ship_orderid.font = [UIFont systemFontOfSize:15];
        [diView addSubview:ship_orderid];
        
        UILabel *www3 = [[UILabel alloc]initWithFrame:CGRectMake(1, 375, 78, 21)];
        www3.text = @"使用评价:";
         www3.textAlignment=NSTextAlignmentCenter;
        www3.font = [UIFont systemFontOfSize:15];
        [diView addSubview:www3];
        
        if (class.goods_receiver_mobile.length == 0) {
            if (class.goods_receiver_tel.length == 0) {
                mobile.text = @"";
            }else{
                mobile.text = [NSString stringWithFormat:@"%@",class.goods_receiver_tel];
            }
        }else{
            mobile.text = [NSString stringWithFormat:@"%@",class.goods_receiver_mobile];;
        }
        UITapGestureRecognizer *singleTapGestureRecognizer3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappear)];
        [singleTapGestureRecognizer3 setNumberOfTapsRequired:1];
        [diView addGestureRecognizer:singleTapGestureRecognizer3];
        
        CGFloat tX = www3.right + 5;
        CGFloat tW = ScreenFrame.size.width - tX - 10;
        CGFloat tY = www3.top - 5;
        CGFloat tH = 86;
        mytextview = [[UITextView alloc]initWithFrame:CGRectMake(tX, tY, tW, tH)];
        mytextview.delegate = self;
        mytextview.text = @"";
        mytextview.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
        
        CGFloat lX = tX - 1;
        CGFloat lW = mytextview.width;
        CGFloat lY = mytextview.top + 5;
        CGFloat lH = 20;
        laLiuyan=[[UILabel alloc]initWithFrame:CGRectMake(lX, lY, lW, lH)];
        laLiuyan.text=@" 请填写评价";
        laLiuyan.backgroundColor=[UIColor clearColor];
        laLiuyan.textColor=[UIColor grayColor];
        laLiuyan.font=[UIFont systemFontOfSize:12];
        
        [cell addSubview:mytextview];
        [cell addSubview:laLiuyan];
        
        UIView *name5 = [[UIView alloc]initWithFrame:CGRectMake(0, 365, diView.frame.size.width, 0.5)];
        name5.backgroundColor =  UIColorFromRGB(0xd7d7d7);
        [diView addSubview:name5];
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"评价" forState:UIControlStateNormal];
        [btn.layer setMasksToBounds:YES];
        [btn.layer setCornerRadius:4.0f];
        btn.backgroundColor = MY_COLOR;
        CGFloat w = 102;
        CGFloat h = 35;
        CGFloat x = 0.5 * (ScreenFrame.size.width - w);
        CGFloat y = 495;
        btn.frame = CGRectMake(x, y, w, h);
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [btn addTarget:self action:@selector(btnUp) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn];
    
        
        WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"取消" leftTarget:self leftAction:@selector(dismissKeyBoard) rightTitle:@"完成" rightTarget:self rightAction:@selector(dismissKeyBoard)];
        [mytextview setInputAccessoryView:inputView];

        
        if ([class.goods_evaluate_status integerValue] == 0){
            
        }else{
            btn.hidden = YES;
            laLiuyan.hidden = YES;
            mytextview.editable = NO;
            mytextview.userInteractionEnabled = false;
            mytextview.backgroundColor = [UIColor whiteColor];
            mytextview.text = class.goods_return_content;
        }
        
        if ([class.goods_apply_status integerValue] == 0) {
            checkStatus.text = @"待审核";
            UIView *myV = [[UIView alloc]initWithFrame:CGRectMake(0, 301.5, ScreenFrame.size.width, 400+7.5)];
            myV.backgroundColor = [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1];
            [cell addSubview:myV];
            UIImageView *iii = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, ScreenFrame.size.width-20, 0.5)];
            iii.backgroundColor = [UIColor grayColor];
            //[myV addSubview:iii];
        }else if ([class.goods_apply_status integerValue] == 5){
            checkStatus.text = @"申请通过,等待收货";
            
        }else if ([class.goods_apply_status integerValue] == -5){
            checkStatus.textColor = MY_COLOR;
            checkStatus.text = @"审核未通过";
        }
        company.text = class.detail_goods_middle_evaluate;
        ship_orderid.text = class.detail_goods_bad_evaluate;
    }
    
    return cell;
}
-(void)disappear{
    if (self.view.frame.origin.y>0) {
        
    }else{
        [mytextview resignFirstResponder];
        [UIView beginAnimations:@"srcollView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.275f];
        self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}
-(void)btnUp{
    if (mytextview.text.length == 0) {
        [SYObject failedPrompt:@"评价内容不能为空"];
    }else{
        NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,FREE_ESTIMATE_URL]];
        request_1=[ASIFormDataRequest requestWithURL:url3];
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
        [request_1 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
        [request_1 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
        LoginViewController *log = [LoginViewController sharedUserDefault];
        [request_1 setPostValue:log.lifeGroup_oid forKey:@"oid"];
        [request_1 setPostValue:mytextview.text forKey:@"use_experience"];
        
        [request_1 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request_1.tag = 101;
        request_1.delegate = self;
        [request_1 setDidFailSelector:@selector(urlRequestFailed:)];
        [request_1 setDidFinishSelector:@selector(urlRequestSucceeded:)];
        [request_1 startAsynchronous];
        [SYObject startLoading];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request_1 clearDelegatesAndCancel];
    [request3 clearDelegatesAndCancel];
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig：%@",dicBig);
        if ([[dicBig objectForKey:@"ret"] isEqualToString:@"true"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SYObject failedPrompt:@"评价失败"];
        }
        [SYObject endLoading];
    }
    else{
        [SYObject failedPrompt:@"请求出错"];
    }
    
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    // 请求响应失败，返回错误信息
    [SYObject failedPrompt:@"网络请求失败"];
}
-(void)dismissKeyBoard{
    [mytextview resignFirstResponder];

    [MyTableView setContentOffset:self.yiqiandenagedian animated:NO];

}
//该方法为点击输入文本框要开始输入是调用的代理方法：就是把view上移到能看见文本框的地方
- (void)textViewDidBeginEditing:(UITextView *)textView{

    CGRect rect = [MyTableView convertRect:textView.frame fromView:textView.superview];
    self.yiqiandenagedian = MyTableView.contentOffset;
    [MyTableView setContentOffset:CGPointMake(0, rect.origin.y) animated:YES];
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    laLiuyan.hidden = YES;
    return YES;
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
