//
//  MyWalletViewController.m
//  My_App
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MyWalletViewController.h"
#import "AccountBalanceViewController.h"
#import "StandingsViewController.h"
#import "CouponsViewController.h"
#import "myzeroViewController.h"
#import "GroupOrdListViewController.h"

@interface MyWalletViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableView;
    NSMutableArray *dataArray;
}
@end

@implementation MyWalletViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createBackBtn];
    [self designPage];
    dataArray=[[NSMutableArray alloc]initWithObjects:@"余额",@"积分",@"优惠劵",@"生活惠",@"我的试用",nil];

}
-(void)createBackBtn{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    self.title=@"我的钱包";
    UIButton *button = [LJControl backBtn];
    button.tag=1000;
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)designPage{
    myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-64) style:UITableViewStylePlain];
    self.automaticallyAdjustsScrollViewInsets=NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate=self;
    myTableView.dataSource=self;
    [self.view addSubview:myTableView];

}
-(void)buttonClicked:(UIButton *)btn{
    if (btn.tag==1000) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1){  //关闭主界面的右滑返回
        return NO;
    }else{
        return YES;
    }
}
#pragma mark- UITableViewDataSource & UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UIView *l=[LJControl viewFrame:CGRectMake(10, 43, ScreenFrame.size.width-10, 1) backgroundColor:UIColorFromRGB(0Xf2f2f2)];
        [cell addSubview:l];
    }
    cell.textLabel.text=[dataArray objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
    //余额
        AccountBalanceViewController *avc = [[AccountBalanceViewController alloc]init];
        [self.navigationController pushViewController:avc animated:YES];
    }else  if(indexPath.row==1){
    //积分
        
        StandingsViewController *svc = [[StandingsViewController alloc]init];
        svc.myIntegral=_myIntegral;
        [self.navigationController pushViewController:svc animated:YES];
    }else if (indexPath.row==2){
    //优惠劵
        CouponsViewController *cvc = [[CouponsViewController alloc]init];
        [self.navigationController pushViewController:cvc animated:YES];
    }else if (indexPath.row==3){
    //生活惠
        GroupOrdListViewController *life = (GroupOrdListViewController *)[SYObject VCFromUsercenterStoryboard:@"GroupOrdListViewController"];
        [self.navigationController pushViewController:life animated:YES];
    }else if (indexPath.row==4){
    //我的试用
        myzeroViewController *zero = (myzeroViewController *)[SYObject VCFromUsercenterStoryboard:@"myzeroViewController"];
        [self.navigationController pushViewController:zero animated:YES];
    }

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
