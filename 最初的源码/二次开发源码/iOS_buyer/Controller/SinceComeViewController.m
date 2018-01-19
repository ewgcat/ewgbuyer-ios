//
//  SinceComeViewController.m
//  My_App
//
//  Created by apple on 15/10/29.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "SinceComeViewController.h"
#import "SinceComeCell.h"
#import "ThirdViewController.h"
#import "PayViewController.h"

@interface SinceComeViewController (){
    ASIFormDataRequest *RequestSave;
}

@end

@implementation SinceComeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"自提点选择";
    dataArray = [[NSMutableArray alloc]init];
    [self createBackBtn];
    MyTableview.delegate = self;
    MyTableview.dataSource = self;
    
    ThirdViewController *third = [ThirdViewController sharedUserDefault];
    NSLog(@"third.person_addr_id:%@",third.person_addr_id);
    RequestSave = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@?addr_id=%@&beginCount=0&selectCount=20",FIRST_URL,GOODS_CART2_DELIVERY_URL,third.person_addr_id] setKey:nil setValue:nil];
    RequestSave.delegate = self;
    [RequestSave setDidFailSelector:@selector(RequestFailed:)];
    [RequestSave setDidFinishSelector:@selector(GetuserMsgSucceeded:)];
    [RequestSave startAsynchronous];
    [SYObject startLoading];
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
-(void)RequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    [SYObject failedPrompt:@"请求失败"];
    
}
-(void)GetuserMsgSucceeded:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    if ([request  responseStatusCode] == 200){
        [dataArray removeAllObjects];
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"goodsList:%@",dicBig);
        [dataArray removeAllObjects];
        
        NSArray *arr = [dicBig objectForKey:@"data"];
        for(NSDictionary *dic in  arr){
            ClassifyModel *class = [[ClassifyModel alloc]init];
            class.manager_addr_id = [dic objectForKey:@"id"];
            class.manager_area = [dic objectForKey:@"addr"];
            class.manager_trueName = [dic objectForKey:@"name"];
            class.manager_telephone = [dic objectForKey:@"tel"];
            [dataArray addObject:class];
        }
        
        if (dataArray.count == 0) {
            MyTableview.hidden = YES;
        }else{
            MyTableview.hidden = NO;
        }
        [MyTableview reloadData];
    }else{
        [SYObject failedPrompt:@"请求出错，请重试"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - label计算高度
-(CGRect )labelSizeHeight:(NSString *)labeltext frame:(CGRect)frame font:(NSInteger )myfont{
    UILabel *labelTiecontent = [[UILabel alloc]init];
    labelTiecontent.numberOfLines = 0;
    labelTiecontent.font = [UIFont systemFontOfSize:myfont];
    labelTiecontent.text = labeltext;
    CGRect labelFrameTie = frame;
    labelFrameTie.size = [labelTiecontent sizeThatFits:CGSizeMake(ScreenFrame.size.width-frame.origin.x*2,  0)];
    return labelFrameTie;
}
#pragma mark - tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArray.count!=0) {
        return dataArray.count ;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (dataArray.count!=0) {
        ClassifyModel *class = [dataArray objectAtIndex:indexPath.row];
        CGRect sss = [self labelSizeHeight:class.manager_area frame:CGRectMake(0, 0, ScreenFrame.size.width-55, 30) font:13];
        return 74+sss.size.height+10;
    }
    return  0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SinceComeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SinceComeCell"];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SinceComeCell" owner:self options:nil] lastObject];
    }
    if (dataArray.count!=0) {
        ClassifyModel *class = [dataArray objectAtIndex:indexPath.row];
        cell.name.text = class.manager_trueName;
        cell.address.text = class.manager_area;
        cell.phone.text = [NSString stringWithFormat:@"%@",class.manager_telephone];
        PayViewController *pay = [PayViewController sharedUserDefault];
        if (([class.manager_addr_id intValue] == pay.address_id )) {
            cell.leftImage.image = [UIImage imageNamed:@"right"];
        }else{
            cell.leftImage.image = [UIImage imageNamed:@""];
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (dataArray.count!=0) {
        ClassifyModel *class = [dataArray objectAtIndex:indexPath.row];
        PayViewController *pay = [PayViewController sharedUserDefault];
        ThirdViewController *th = [ThirdViewController sharedUserDefault];
        th.delivery_id = [NSString stringWithFormat:@"%@",class.manager_addr_id];
        pay.address_id = [class.manager_addr_id intValue];
        pay.addressStr = class.manager_trueName;
        [self.navigationController popViewControllerAnimated:YES];
    }
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
