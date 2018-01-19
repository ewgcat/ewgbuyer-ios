//
//  ApplyForReturnCancelViewController.m
//  My_App
//
//  Created by apple on 16/1/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ApplyForReturnCancelViewController.h"
#import "ApplyForGoodTableViewCell.h"
#import "LoginViewController.h"
#import "HJCAjustNumButton.h"
#import "NilCell.h"

@interface ApplyForReturnCancelViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *MyTableView;
    UILabel *textLabel;
    UILabel *numlabel;
}
@end

@implementation ApplyForReturnCancelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    [self designPage];
    [self getGoodsReturnApply];
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
-(void)getGoodsReturnApplyCancel{
    [SYObject startLoadingInSuperview:self.view];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:filePathDong];
    NSLog(@"%@",fileContent);
    NSString *urlstr=[NSString stringWithFormat:@"%@%@",FIRST_URL,BUYER_RETURN_GOODS_CANCEL_SAVE_URL];
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
    request.tag=1001;
    [request startAsynchronous];
}
#pragma mark- ASIHTTPRequestDelegate
-(void)requestFinished:(ASIHTTPRequest *)request{
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
    NSLog(@"%@",dic);
    [SYObject endLoading];
    if (request.tag==1000) {
       numlabel.text=[NSString stringWithFormat:@"申请数量:%@",[dic objectForKey:@"return_count"]];
        if ([dic objectForKey:@"return_goods_content"]==nil) {
            textLabel.text=@"";
        }else{
            textLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"return_goods_content"]];
        }
    }else if (request.tag==1001){
        if ([[dic objectForKey:@"ret"]isEqualToString:@"true"]) {
            [SYObject failedPromptInSuperView:self.view title:@"退货申请取消成功" complete:^{
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }else{
            [SYObject failedPromptInSuperView:self.view title:@"退货申请取消失败"];
        }
    
    
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"请求错误");
    [SYObject endLoading];
    [SYObject failedPromptInSuperView:self.view title:@"网络请求错误"];
}

- (IBAction)backClick:(UIButton *)sender {
   [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)buttonClick:(UIButton *)btn{
    [self getGoodsReturnApplyCancel];


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
        return 60;
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
    if (indexPath.row==1) {
        UIView *headerView=[LJControl viewFrame:CGRectMake(0, 0,ScreenFrame.size.width, 20) backgroundColor: UIColorFromRGB(0Xf0f0f0)];
        [cell addSubview:headerView];
        
        LoginViewController *log = [LoginViewController sharedUserDefault];
        
        numlabel=[LJControl labelFrame:CGRectMake(10,25, cell.contentView.bounds.size.width-20, 30) setText:[NSString stringWithFormat:@"申请数量:%@",log.return_goods_count]setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0X4c4c4c) textAlignment:NSTextAlignmentLeft];
        [cell addSubview:numlabel];
       
        
    }else if (indexPath.row==2) {
        UIView *headerView=[LJControl viewFrame:CGRectMake(0, 0,ScreenFrame.size.width, 20) backgroundColor: UIColorFromRGB(0Xf0f0f0)];
        [cell addSubview:headerView];
        
        UILabel *numla=[LJControl labelFrame:CGRectMake(10, 25, cell.contentView.bounds.size.width-20, 30) setText:@"问题描述" setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0X4c4c4c) textAlignment:NSTextAlignmentLeft];
        [cell addSubview:numla];
    
        textLabel=[LJControl labelFrame:CGRectMake(10, 60, ScreenFrame.size.width-20, 50) setText:@"" setTitleFont:14 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0Xafafaf) textAlignment:NSTextAlignmentLeft];
        textLabel.layer.borderWidth = 2;
        [textLabel.layer setMasksToBounds:YES];
        [textLabel.layer setCornerRadius:8];
        [textLabel.layer setBorderColor:[UIColorFromRGB(0Xafafaf) CGColor]];
        [cell addSubview:textLabel];
        
        
    }else if (indexPath.row==3) {
        cell.backgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1];
        UIButton *button=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(50, 20, ScreenFrame.size.width-100, 30) setNormalImage:nil setSelectedImage:nil setTitle:@"" setTitleFont:0 setbackgroundColor:[UIColor clearColor]];
        button.tag=1001;
        UILabel *label=[LJControl labelFrame:CGRectMake(0, 0,ScreenFrame.size.width-100, 40) setText:@"取消退货申请" setTitleFont:17 setbackgroundColor:UIColorFromRGB(0Xfd5d5d) setTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [label.layer setMasksToBounds:YES];
        [label.layer setCornerRadius:4];
        [button addSubview:label];
        [cell addSubview:button];
        
    }
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
