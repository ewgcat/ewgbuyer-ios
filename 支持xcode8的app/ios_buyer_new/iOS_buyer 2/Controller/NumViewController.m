//
//  NumViewController.m
//  My_App
//
//  Created by 邱炯辉 on 16/11/23.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "NumViewController.h"

@interface NumViewController ()

@property (nonatomic,strong) NSDictionary *dataDic;


@end

@implementation NumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self getData];
}

#pragma mark 获取数据
-(void)getData{
    [SYObject startLoading];
    
    NSString *urlStr= [NSString stringWithFormat:@"%@%@",FIRST_URL,@"/app/buyer/promotion_my_parent.htm"];
    
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    
    NSDictionary *par=@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1]};
    //
    __weak typeof(self) ws= self;
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject==%@",responseObject);
       ws.dataDic=responseObject;
        [ws createUI];
        [SYObject endLoading];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"**%@",[error localizedDescription]);
        [SYObject endLoading];
        
    }];
}
-(void)createUI{
    
    UIScrollView *scrollview=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollview.alwaysBounceHorizontal=NO;
    
    [self.view addSubview:scrollview];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, ScreenFrame.size.width, 40)];
    if (_dataDic[@"my_promotion_code"]) {
        label.text=[NSString stringWithFormat:@"我的推广码：%@",_dataDic[@"my_promotion_code"]];
    }
    label.textAlignment=NSTextAlignmentCenter;
    [scrollview addSubview:label];
    
    
    UIImageView *imageview=[[UIImageView alloc]init];
    imageview.frame=CGRectMake(0, 0, 90, 90);
    imageview.center=CGPointMake(ScreenFrame.size.width/2, 115);
    imageview.layer.cornerRadius=45;
    imageview.layer.masksToBounds=YES;
    imageview.backgroundColor=[UIColor redColor];
    if (_dataDic[@"parent_img"]) {
        [imageview sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"parent_img"]]];
    }
    [scrollview addSubview:imageview];
    
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageview.frame)+7, ScreenFrame.size.width, 40)];
    if (_dataDic[@"parent_name"]) {
        label2.text=[NSString stringWithFormat:@"%@",_dataDic[@"parent_name"]];
    }
    label2.textAlignment=NSTextAlignmentCenter;
    
    [scrollview addSubview:label2];
    //承载视图(下面的表格）
    UIView *baseView=[[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(label2.frame)+9, ScreenFrame.size.width-30, 350)];
    baseView.layer.cornerRadius=8;
    baseView.layer.masksToBounds=YES;
    baseView.layer.borderWidth=0.3;
    baseView.layer.borderColor=[UIColor lightTextColor].CGColor;
    
    baseView.backgroundColor=[UIColor whiteColor];
    [scrollview addSubview:baseView];
    
    
    UILabel *label11=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, baseView.size.width-15, 40)];
    label11.text=@"我的导师联系信息";
    [baseView addSubview:label11];
    
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label11.frame), baseView.size.width, 1)];
    line.backgroundColor=RGB_COLOR(224, 224, 224);
    [baseView addSubview:line];
    
    NSArray *titleArr=@[@"导师推广码",@"帐号",@"姓名",@"微信号",@"QQ号码",@"手机号码"];
    
    NSMutableArray *dataArr=@[].mutableCopy;
    //导师推广码
    if (_dataDic[@"parent_promotion_code"]) {
        [dataArr addObject:_dataDic[@"parent_promotion_code"]];
    }else{
        [dataArr addObject:@""];

    }
    
    //"帐号
    if (_dataDic[@"parent_name"]) {
        [dataArr addObject:_dataDic[@"parent_name"]];
    }else{
        [dataArr addObject:@""];
        
    }
    //姓名
    if (_dataDic[@"parent_truename"]) {
        [dataArr addObject:_dataDic[@"parent_truename"]];
    }else{
        [dataArr addObject:@""];
        
    }
    //微信号
    if (_dataDic[@"parent_wechat_code"]) {
        [dataArr addObject:_dataDic[@"parent_wechat_code"]];
    }else{
        [dataArr addObject:@""];
        
    }
    //QQ号码
    if (_dataDic[@"parent_qq_code"]) {
        [dataArr addObject:_dataDic[@"parent_qq_code"]];
    }else{
        [dataArr addObject:@""];
        
    }
    //手机号码
    if (_dataDic[@"parent_mobile"]) {
        [dataArr addObject:_dataDic[@"parent_mobile"]];
    }else{
        [dataArr addObject:@""];
        
    }
    int y=CGRectGetMaxY(line.frame)+1;
    for (int i=0; i<titleArr.count; i++) {
        UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(15, y, 100, 44)];
        label1.text=titleArr[i];
        [baseView addSubview:label1];
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(baseView.size.width-130-10, y, 130, 44)];
        label2.textAlignment=NSTextAlignmentRight;
        label2.text=dataArr[i];
        [baseView addSubview:label2];
        
        y+=44;
        if (!(i==titleArr.count-1)) {//如果是最后一个，就不加横线
            UIView *line=[[UIView alloc]initWithFrame:CGRectMake(15, y, baseView.size.width-15, 1)];
            line.backgroundColor=RGB_COLOR(224, 224, 224);
            [baseView addSubview:line];
   
        }
    }
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0,y, baseView.size.width, 1)];
    line2.backgroundColor=RGB_COLOR(224, 224, 224);
    [baseView addSubview:line2];
    
    
    
    scrollview.contentSize=CGSizeMake(ScreenFrame.size.width, CGRectGetMaxY(baseView.frame)+20);
    
    
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
