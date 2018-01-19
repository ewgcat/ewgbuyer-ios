//
//  EBishenqingTableViewController.m
//  My_App
//
//  Created by 邱炯辉 on 16/6/23.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "EBishenqingTableViewController.h"
#import "EBiRecordTableViewController.h"
@interface EBishenqingTableViewController ()
{
    NSInteger _selected;
}
@end

@implementation EBishenqingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _selected=-1;
    self.title=@"提现申请";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableView.tableFooterView=[self footview];
    self.tableView.tableHeaderView=[self createHeaderview];

}
-(UIView *)createHeaderview{
    UIView *headerview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width,40)];
   
    
    UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 200, 30)];
    label3.text=@"请选择提现类型";
    label3.textColor=[UIColor lightGrayColor];
    [headerview addSubview:label3];
    return headerview;
    
}
-(UIView *)footview{
    UIView *foot=[[UIView alloc ]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 50)];
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(30, 20, ScreenFrame.size.width-60, 30)];
    button.backgroundColor=[UIColor redColor];
    [button setTitle:@"立即申请" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shenqing) forControlEvents:UIControlEventTouchUpInside];
    [foot addSubview:button];
    foot.userInteractionEnabled=YES;
    return foot;
}
#pragma mark -立即申请
-(void)shenqing{
    
    if (_selected==-1) {
        [SYObject failedPrompt:@"请选择其中一种类型"];
        [SYObject endLoading];
        
        return;
        
    }
    NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
    NSString *name= [d valueForKey:@"level_name"];
    if ([name isEqualToString:@"钻卡会员"]) {
        //                只有钻卡会员才可以提现
        UIAlertController *vcqq=[UIAlertController alertControllerWithTitle:@"" message:@"您的申请通过后将直接转入您的余额账号？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancal=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [vcqq addAction:cancal];
        UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self saveData];
            
        }];
        [vcqq addAction:action];
        [self presentViewController:vcqq animated:YES completion:nil];
    }else{
        UIAlertController *vcqq=[UIAlertController alertControllerWithTitle:@"" message:@"您当前不是钻卡会员,无法提现" preferredStyle:UIAlertControllerStyleAlert];
    
        UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [vcqq addAction:action];
        [self presentViewController:vcqq animated:YES completion:nil];
    
    }
    

    

}
-(void)saveData{
    
    [SYObject startLoading];
    
  
    
    NSString *type=nil;
    if (_selected==0) {
        type=@"GOLD_100";
    }else if (_selected==1){
        type=@"GOLD_500";

    }else if (_selected==1){
        type=@"GOLD_1000";
        
    }
    ASIFormDataRequest *request102;
    
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/app/buyer/egoldapply_save.htm",FIRST_URL]];
    request102=[ASIFormDataRequest requestWithURL:url];
    [request102 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request102 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    [request102 setPostValue:type forKey:@"gold_type"];
    
    
    
    [request102 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request102.tag = 102;
    [request102 setDelegate:self];
    [request102 setDidFailSelector:@selector(urlRequestFailed:)];
    [request102 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [request102 startAsynchronous];
    
}

#pragma mark - 网络
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig:%@",dic);
        
        NSString *ret=[NSString stringWithFormat:@"%@",dic[@"ret"]];
        if ([ret isEqualToString:@"1"]) {
//            正常
            [SYObject failedPrompt:@"申请成功"];
            //提现记录
            EBiRecordTableViewController *vc=[[EBiRecordTableViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([ret isEqualToString:@"-3"]){
            [SYObject failedPrompt:@"E币不足"];

        }else if ([ret isEqualToString:@"-2"]){
            [SYObject failedPrompt:@"类型错误"];

        }else if ([ret isEqualToString:@"-4"]){
            [SYObject failedPrompt:@"系统异常"];

        }else if ([ret isEqualToString:@"-5"])
        {
            NSString *s=[NSString stringWithFormat:@"只能在每月%@号申请",dic[@"egoldsub"]];
            [SYObject failedPrompt:s];
        
        }
        
        
    }
    [SYObject endLoading];
}

-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
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
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.text=@[@"¥100",@"¥500",@"¥1000"][indexPath.row];
    cell.accessoryView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"++++%zd",indexPath.row);
    if (_selected!=-1) {
        NSIndexPath *indexpath=[NSIndexPath indexPathForRow:_selected inSection:0];
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexpath];
        UIImageView *imageview=(UIImageView *)cell.accessoryView;
        imageview.image=[UIImage imageNamed:@""];
    }
    
   
    _selected=indexPath.row;
    NSIndexPath *indexpath=[NSIndexPath indexPathForRow:_selected inSection:0];
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexpath];
    //设置选中的图片
    UIImageView *imageview=(UIImageView *)cell.accessoryView;
    imageview.image=[UIImage imageNamed:@"choose"];
    
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
