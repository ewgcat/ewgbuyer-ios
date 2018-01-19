//
//  BinbCardTableViewController.m
//  BinbCardDemo
//
//  Created by 邱炯辉 on 16/7/9.
//  Copyright © 2016年 mlh. All rights reserved.
//

#import "BinbCardTableViewController.h"
#import "CardTableViewCell.h"
#import "AddCardViewController.h"
#import "PaySettingViewController.h"

@interface BinbCardTableViewController (){
   }
@property(nonatomic,copy) NSString *md5s;

@property(nonatomic,strong)    NSMutableArray *dataArr;

@end

@implementation BinbCardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.dataArr=[[NSMutableArray alloc]init];
    self.title=@"我的银行卡";
    [self.tableView registerNib:[UINib nibWithNibName:@"CardTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CardTableViewCell"];
    self.tableView.rowHeight=100;
    self.tableView.estimatedRowHeight=100;
    self.tableView.tableFooterView=[self createFootview];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self getData];

}
-(void)getData{
    //
    [SYObject startLoading];
    NSString *urlStr= [NSString stringWithFormat:@"%@%@",FIRST_URL,@"/app/buyer/bankcard.htm"];
    
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    
    NSDictionary *par=@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1]};
    __weak typeof(self) ws= self;
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SYObject endLoading];
        NSDictionary *dic = responseObject;
        NSLog(@"======%@",dic);
        NSString *ret=[NSString stringWithFormat:@"%@",responseObject[@"ret"]];
        if (responseObject[@"pay_password"]) {
            ws.md5s=responseObject[@"pay_password"];

        }else{
            [ws gotoChangePw];//如果没有密码，则跳转到支付密码设置
        }
        if ([ret isEqualToString:@"1"]) {
            [ws.dataArr removeAllObjects];
            NSArray *arr=dic[@"bankList"];
            [ws.dataArr addObjectsFromArray:arr];
            [ws.tableView reloadData];
            NSLog(@"arr=%@",arr);
            
        }else if ([ret isEqualToString:@"-1"]){
            [SYObject failedPrompt:@"用户ID异常"];
        
        }
        [SYObject endLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        [SYObject endLoading];
        
    }];
}

-(void)gotoChangePw{
    UIAlertController *vcqq=[UIAlertController alertControllerWithTitle:@"" message:@"请先设置支付密码！" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancal=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [vcqq addAction:cancal];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        PaySettingViewController *vc=[[PaySettingViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [vcqq addAction:action];
    [self presentViewController:vcqq animated:YES completion:nil];

}
-(UIView *)createFootview{
    
    CGFloat width= self.view.bounds.size.width;
    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 43)];
    
    UIButton *but=[[UIButton alloc]initWithFrame:CGRectMake(10, 4, width-20, 38)];
    but.backgroundColor=[UIColor redColor];
    [but setTitle:@"添加银行卡" forState:UIControlStateNormal];
    but.layer.masksToBounds=YES;
    but.layer.cornerRadius=5;
    [but addTarget:self action:@selector(addCard) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:but];

    
    return v;
}
-(void)addCard{
    AddCardViewController *vc=[[AddCardViewController alloc]init];
    vc.md5PW=_md5s;
    [self.navigationController pushViewController:vc animated:YES];
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
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardTableViewCell" forIndexPath:indexPath];
    
    NSDictionary *dic=self.dataArr[indexPath.row];
    if (dic[@"bank_img"]) {
        [cell.headImageview sd_setImageWithURL:[NSURL URLWithString:dic[@"bank_img"]]];
    }
    if (dic[@"card_number"]) {
        
        NSString *mainstr=dic[@"card_number"];
        NSString *s=[mainstr substringFromIndex:mainstr.length-4];
        cell.cardNum.text=[NSString stringWithFormat:@"**** **** **** **** %@",s];
    }
    
    if (dic[@"bank_name"]) {
        cell.name.text=dic[@"bank_name"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    // Configure the cell...
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic=self.dataArr[indexPath.row];
    
    UIAlertController *v=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"解除绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        
        NSString *urlStr= [NSString stringWithFormat:@"%@%@",FIRST_URL,@"/app/remove_bankcard.htm"];
        
        NSArray *fileContent2 = [MyUtil returnLocalUserFile];
        
        NSDictionary *par=@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1],@"id":dic[@"id"]};
        __weak typeof(self) ws= self;
        [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = responseObject;
            NSLog(@"======%@",dic);
            NSString *ret=[NSString stringWithFormat:@"%@",responseObject[@"ret"]];
            
            if ([ret isEqualToString:@"1"]) {
                [SYObject failedPrompt:@"解绑成功"];
                [ws getData];
                [ws.tableView reloadData];
               
                
            }else if ([ret isEqualToString:@"0"]){
                [SYObject failedPrompt:@"解绑失败"];
                
            }else if ([ret isEqualToString:@"-1"]){
                [SYObject failedPrompt:@"用户ID异常"];
                
            }else if ([ret isEqualToString:@"-2"]){
                [SYObject failedPrompt:@"银行卡ID错误"];
                
            }else if ([ret isEqualToString:@"-3"]){
                [SYObject failedPrompt:@"只能解绑自己银行卡"];
                
            }
            [SYObject endLoading];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",[error localizedDescription]);
            [SYObject endLoading];
            
        }];

    }];
    [v addAction:action];
    UIAlertAction *action2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [v addAction:action2];
    [self presentViewController:v animated:YES completion:nil];
    
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
