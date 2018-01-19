//
//  AskDetailViewController.m
//  2016seller_01_09_new
//
//  Created by barney on 16/1/13.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

#import "AskDetailViewController.h"

@interface AskDetailViewController ()
{
    NSMutableArray *dataArray;//tableView数据源
    UITableView *askTabView;//tableView列表
    UITextView *_textView;
    
}

@end

@implementation AskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray=[[NSMutableArray alloc]init];//数据源初始化
    self.title=@"咨询详情";//标题栏题目
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);//背景颜色
    if (UIDeviceSystem>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;//自动调整属性设置为NO
    }else{
    }
    //咨询列表
    askTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 74, ScreenFrame.size.width, ScreenFrame.size.height-74)];
    askTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    askTabView.delegate = self;
    askTabView.dataSource=  self;
    askTabView.showsVerticalScrollIndicator=NO;
    askTabView.showsHorizontalScrollIndicator = NO;
    askTabView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:askTabView];
    [self getNetWorking];//调用网络请求

}
//网络请求
- (void)getNetWorking
{
    [MyObject startLoading];//遮罩
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,NEWS_CLASS_URL];
    //参数字典
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken]
                          };
    //发起请求
    [[MyNetTool managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MyObject endLoading];
        NSDictionary * dicBig=responseObject;//数据字典
        NSLog(@"公告分类///%@",dicBig);
        
        if (dicBig)
        {
            if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"])
            {
                [self.navigationController popToRootViewControllerAnimated:NO];
                //登录过期，提示重新登录
                [MyObject failedPrompt:@"用户登录已过期，请重新登录"];
                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
                
            }
            else
            {
                //
                //                NSArray *ary=[dicBig objectForKey:@"articleClass"];
                //                for (NSDictionary *dic in ary)
                //                {
                //                    classModel *model=[[classModel alloc]init];
                //                    model.className=[dic objectForKey:@"className"];
                //                    model.ID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                //                    [titleArray addObject:model.className];
                //                    [IDArray addObject:model.ID];
                //                }
                [askTabView reloadData];//刷新列表
                
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@",[error localizedDescription]);
         [MyObject endLoading];//结束遮罩
         
     }];
    
    
}
//跳转登陆界面
-(void)doTimer_signout
{
    [LJControl cleanAll];
    AppDelegate *app = [AppDelegate sharedUserDefault];
    app.log_View.hidden = NO;//显示登陆界面
}
#pragma mark - UITableView
//设置tableView的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}
//设置tableView各行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0)
    {
        return 70.f;
    }else if (indexPath.row==1)
        return 10.f;
    else if (indexPath.row==2)
        return 190.f;
    else if (indexPath.row==3||indexPath.row==7)
        return 15.f;
    else if (indexPath.row==4)
        return 115.f;
    else if (indexPath.row==5)
        return 15.f;
    else if (indexPath.row==6)
        return 240.f;
    else if (indexPath.row==8)
        return 50.f;
    else
        return 0;
    
}
//设置tableView的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellName=@"cell";
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellName];
    cell.backgroundColor=UIColorFromRGB(0xf5f5f5);
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //设置第0行cell
    if (indexPath.row==0)
    {
//        ComplainFirstCell *cell=[[[NSBundle mainBundle] loadNibNamed:@"ComplainFirstCell" owner:self options:nil] lastObject];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.backgroundColor = [UIColor whiteColor];
//        return cell;
        
    }
    
    return cell;
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
