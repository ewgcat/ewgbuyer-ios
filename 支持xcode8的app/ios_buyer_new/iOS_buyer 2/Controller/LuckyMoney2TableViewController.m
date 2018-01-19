//
//  LuckyMoney2TableViewController.m
//  LuckyMoney
//
//  Created by 邱炯辉 on 16/7/16.
//  Copyright © 2016年 mlh. All rights reserved.
//

#import "LuckyMoney2TableViewController.h"
#import "LuckyRecordTableViewCell.h"
#import "AccountBalanceViewController.h"
@interface LuckyMoney2TableViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation LuckyMoney2TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

  

    self.navigationController.navigationBarHidden=YES;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 64)];
    view.backgroundColor = RGB_COLOR(216 ,78 ,67);
    [self.view addSubview:view];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
    button.frame =CGRectMake(1, 28, 60, 28+2);
    [button setImage:[UIImage imageNamed:@"barbuttonicon_back_15x30_@3x"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"barbuttonicon_back_15x30_@3x"] forState:UIControlStateHighlighted];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitle:@"返回" forState:UIControlStateHighlighted];
    
    //   [button setImage:[UIImage imageNamed:@"back_lj"] forState:UIControlStateNormal];
    //    [button setTitle:@"返回" forState:UIControlStateNormal];
    //    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    button.imageEdgeInsets=UIEdgeInsetsMake(5, 15, 5, 35);
    //    button.titleLabel.font=[UIFont systemFontOfSize:14];
    
    
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font  = [UIFont systemFontOfSize:15];
    
       
    [view addSubview:button];

//    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 22, ScreenFrame.size.width-100, 44)];
    label.text = @"红包详情";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
//    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(label.frame), ScreenFrame.size.width-100, 20)];
//    label2.text = @"微信安全支付";
//    label2.textColor = [UIColor whiteColor];
//    label2.font = [UIFont boldSystemFontOfSize:10];
//    label2.textAlignment = NSTextAlignmentCenter;
//    [view addSubview:label2];
//    [self.view addSubview:view];

    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor=RGB_COLOR(242 ,242 ,242);
    [self.view addSubview:_tableView];
    
    
    self.tableView.tableHeaderView=[self createHeaderview];
    [self.tableView registerNib:[UINib nibWithNibName:@"LuckyRecordTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LuckyRecordTableViewCell"];
    
    NSLog(@"--%@",self.tableView.subviews);
    self.tableView.rowHeight=50;
    self.tableView.estimatedRowHeight=50;
    
    self.tableView.tableFooterView=[[UIView alloc]init];
    UIView *v=[self createBottom];
    v.frame=CGRectMake(0, self.view.bounds.size.height-80, ScreenFrame.size.width, 70);
    [self.view addSubview:v];

}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;

}
-(UIView *)createBottom{
    UIView *bottomView=[[UIView alloc]init];
    UIButton  *but=[[UIButton alloc]initWithFrame:CGRectMake(0, 30, ScreenFrame.size.width, 20)];
    [but setTitle:@"查看我的余额明细" forState:UIControlStateNormal];
    [but setTitleColor:RGB_COLOR(104 ,118 ,156) forState:UIControlStateNormal];
    but.titleLabel.font=[UIFont systemFontOfSize:14];
    [but addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:but];
    
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(but.frame)+3, ScreenFrame.size.width, 18)];
    label.text=@"收到的钱可直接消费";
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:12];
    label.textColor=RGB_COLOR(145 ,145 ,145);
    [bottomView addSubview:label];
    return  bottomView;
}
-(void)click{
    AccountBalanceViewController *accBalance=[[AccountBalanceViewController alloc]init];
    [self.navigationController pushViewController:accBalance animated:YES];
}
//去掉导航栏那条线
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    for (UIView *obj in [self.navigationController.navigationBar.subviews[0] subviews]) {
        if ( [obj isKindOfClass:[UIImageView class]]) {
            obj.backgroundColor=[UIColor colorWithRed:216/255.0f green:78/255.0f blue:67/255.0f alpha:1];
                                 
        }
    }

}


-(UIView *)createHeaderview{
    int width=self.view.bounds.size.width;
    UIView *headerview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 280)];
    

    headerview.backgroundColor=[UIColor whiteColor];
   //

    //
    UIImageView *topImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,width , 80)];
    topImageView.image=[UIImage imageNamed:@"tops"];
    [headerview addSubview:topImageView];
    
    //
    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, -295, width, 300)];
    v.backgroundColor=[UIColor colorWithRed:216/255.0f green:78/255.0f blue:67/255.0f alpha:1];
    
    [headerview addSubview:v];
   //logo
    UIImageView *logoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    logoImageView.center=CGPointMake(width/2, 80);
    logoImageView.image=[UIImage imageNamed:@"logo3"];
    [headerview addSubview:logoImageView];
    
   //
    UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(logoImageView.frame)+5, width, 30)];
    label1.text=@"e网购优品红包";
    label1.textAlignment=NSTextAlignmentCenter;
    [headerview addSubview:label1];
    
    UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label1.frame)+5, width, 30)];
    label2.text=_dic[@"wishing"];
    label2.font=[UIFont systemFontOfSize:14];
    label2.textColor=[UIColor lightGrayColor];
    label2.textAlignment=NSTextAlignmentCenter;
    [headerview addSubview:label2];
    
    
    
    UILabel *label3=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label2.frame)+5, width, 35)];
    label3.text=[NSString stringWithFormat:@"%@元",_dic[@"amount"]];
    label3.font=[UIFont systemFontOfSize:23];
//    label3.textColor=[UIColor lightGrayColor];
    label3.textAlignment=NSTextAlignmentCenter;
    [headerview addSubview:label3];
    
    
    UILabel *label4=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label3.frame)+5, width, 30)];
    label4.text=@"已存入余额，可以提现";
    label4.font=[UIFont systemFontOfSize:14];
    label4.textColor=[UIColor lightGrayColor];
    label4.textAlignment=NSTextAlignmentCenter;
    [headerview addSubview:label4];
    
    
    UILabel *label5=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label4.frame), width, 30)];
    label5.text=[NSString stringWithFormat:@"  一个红包共%@元",_dic[@"amount"]];
    label5.font=[UIFont systemFontOfSize:14];
    label5.textColor=[UIColor lightGrayColor];
    label5.textAlignment=NSTextAlignmentLeft;
    [headerview addSubview:label5];
    
    
    
    //1像素的横线
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 279,  self.view.bounds.size.width, 0.5)];
    line.backgroundColor=[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.7];
    [headerview addSubview:line];
    
    
//    UIButton * openBut=[[UIButton alloc]initWithFrame:CGRectMake(50,200 ,50,50)];
//    [openBut setBackgroundImage:[UIImage imageNamed:@"logo3"] forState:UIControlStateNormal];
//    [openBut addTarget:self action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
//    [headerview addSubview:openBut];
    return headerview;
}
-(void)open{
    [self dismissViewControllerAnimated:YES completion:nil
     ];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LuckyRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LuckyRecordTableViewCell"];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary *userDic=_dic[@"redpack_user"];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:userDic[@"wx_head_img"]]];
    cell.nameLabel.text=userDic[@"username"];
    cell.timeLabel.text=_dic[@"addTime"];
    cell.moneyLabel.text=[NSString stringWithFormat:@"%@元",_dic[@"amount"]];

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
