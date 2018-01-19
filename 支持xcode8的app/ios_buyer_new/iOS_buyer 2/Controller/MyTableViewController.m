//
//  MyTableViewController.m
//  My_App
//
//  Created by 邱炯辉 on 16/5/25.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "MyTableViewController.h"
#import "AgreeViewController.h"
#import "MyInviteViewController.h"
#import "CurrentRankViewController.h"
#import "RelationshipViewController.h"
#import "TeamTableViewController.h"
#import "RewardTableViewController.h"
#import "ProfitTableViewController.h"

#import "EBiRecordTableViewController.h"
#import "BookViewController.h"
#import "MypostViewController.h"
#import "InfoViewController.h"

#import "ExchangeMemberViewController.h"
@interface MyTableViewController ()
{
    NSArray *_controllerArr;
    NSArray *_titleArr;
    
    int isvip;
    NSArray *_desArr;//右边描述的的文字


}
@end

@implementation MyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 

    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"返回";
    self.navigationItem.backBarButtonItem=backItem;
    
    _desArr=@[@"完善资料",@"邀请码与二维码",@"更高等级更多优惠",@"查看上级信息",@"领取和查看下级升级奖励",@"梦想e+,激情e+,疯狂e+",@"下级购买商品可得到返佣",@"带个人二维码的精美海报图",@"平台向用户发的授权书"];

    self.title =@"VIP中心";
    self.tableView.tableFooterView =[[UIView alloc]init];
    self.tableView.tableHeaderView=[self createHeaderview];
    
}
-(UIImageView *)createHeaderview{
    UIImageView *headerView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 180)];
    headerView.image=[UIImage imageNamed:@"vip_front_cover.png"];
    NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
    
   NSString *photo_url= [d valueForKey:@"photo_url"];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake((ScreenFrame.size.width-60)/2, 10, 60, 60)];
    
    
    
//    [d setObject:photo_url forKey:@"photo_url"];
//    [d setObject:invitation_code forKey:@"invitation_code"];
//    [d setObject:qrcode_img_path forKey:@"qrcode_img_path"];
//    [d setObject:level_name2 forKey:@"level_name"];
//    [d setObject:name forKey:@"name"];
//    if (dicBig[@"mobile"]) {
//        // 这里先保存一下手机号码
//        [d setObject:dicBig[@"mobile"] forKey:@"phone"];
//        
//    }
//    if (dicBig[@"team_count"]) {
//        [d setObject:dicBig[@"team_count"] forKey:@"team_count"];
//    }
//    if (dicBig[@"child_reward"]) {
//        [d setObject:dicBig[@"child_reward"] forKey:@"child_reward"];
//    }
//    if (dicBig[@"commission"]) {
//        [d setObject:dicBig[@"commission"] forKey:@"commission"];
//    }

    imageView.layer.cornerRadius=30;
    imageView.layer.masksToBounds=YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:photo_url]];
    [headerView addSubview:imageView];
    
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake((ScreenFrame.size.width-100)/2, CGRectGetMaxY(imageView.frame)+5, 100, 20)];
    nameLabel.text=[d valueForKey:@"name"];
    nameLabel.textAlignment=NSTextAlignmentCenter;
    nameLabel.font=[UIFont systemFontOfSize:14];
    [headerView addSubview:nameLabel];
    
    UILabel *levelLabel=[[UILabel alloc]initWithFrame:CGRectMake((ScreenFrame.size.width-100)/2, CGRectGetMaxY(nameLabel.frame)+5, 100, 20)];
    levelLabel.textAlignment=NSTextAlignmentCenter;

    levelLabel.text=[d valueForKey:@"level_name"];
    [headerView addSubview:levelLabel];
    //承载的view
    UIView *myview=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(levelLabel.frame)+10, ScreenFrame.size.width, 50)];
    myview.backgroundColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
   
    [headerView addSubview:myview];
    
    UILabel *teamLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width/3, 20)];
    teamLabel.textAlignment=NSTextAlignmentCenter;
    teamLabel.textColor=[UIColor whiteColor];
//    teamLabel.backgroundColor=[UIColor redColor];
    teamLabel.text=[d valueForKey:@"team_count"];
    [myview addSubview:teamLabel];
    
    
    UILabel *teamLabel2=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(teamLabel.frame)+2, ScreenFrame.size.width/3, 20)];
    teamLabel2.textAlignment=NSTextAlignmentCenter;
    teamLabel2.textColor=[UIColor whiteColor];

    teamLabel2.text=@"团队人数";
    [myview addSubview:teamLabel2];
    
    
    UILabel *moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width/3, 0, ScreenFrame.size.width/3, 20)];
    moneyLabel.textColor=[UIColor whiteColor];

    moneyLabel.textAlignment=NSTextAlignmentCenter;
//    moneyLabel.backgroundColor=[UIColor redColor];
    moneyLabel.text=[d valueForKey:@"child_reward"];
    [myview addSubview:moneyLabel];
    
    
    UILabel *moneyLabel2=[[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width/3, CGRectGetMaxY(teamLabel.frame)+2, ScreenFrame.size.width/3, 20)];
    moneyLabel2.textAlignment=NSTextAlignmentCenter;
    moneyLabel2.textColor=[UIColor whiteColor];

    moneyLabel2.text=@"升级奖励";
    [myview addSubview:moneyLabel2];
    
    UILabel *fanLabel=[[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width/3*2, 0, ScreenFrame.size.width/3, 20)];
    fanLabel.textColor=[UIColor whiteColor];

    fanLabel.textAlignment=NSTextAlignmentCenter;
//    fanLabel.backgroundColor=[UIColor redColor];
    fanLabel.text=[d valueForKey:@"commission"];
    [myview addSubview:fanLabel];
    
    
    UILabel *fanLabel2=[[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width/3*2, CGRectGetMaxY(teamLabel.frame)+2, ScreenFrame.size.width/3, 20)];
    fanLabel2.textAlignment=NSTextAlignmentCenter;
    fanLabel2.textColor=[UIColor whiteColor];

    fanLabel2.text=@"返佣收益";
    [myview addSubview:fanLabel2];

    return headerView;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getData];
#if 0
    
//    
//    _controllerArr = @[NSStringFromClass([ActivateVIPViewController class]),              NSStringFromClass([MyInviteViewController class]),
//                       
//                       NSStringFromClass([CurrentRankViewController class]),
//                       NSStringFromClass([RelationshipViewController class]),
//                       NSStringFromClass([RewardTableViewController class]),
//                       NSStringFromClass([TeamTableViewController class]),
//                       NSStringFromClass([ProfitTableViewController class]),
//                       NSStringFromClass([ class]),
//                       NSStringFromClass([ProfitTableViewController class]),
//                       NSStringFromClass([ProfitTableViewController class])];
//    
//    
//    _titleArr=@[@"激活VIP",@"我的推广",@"VIP升级",@"我的上级",@"奖励管理",@"团队管理",@"返佣收益",@"E币提现",@"我的海报",@"授权书"];
//    isvip=0;
//    
//    [self.tableView reloadData];
#endif
}
-(void)getData{
    
    [SYObject startLoading];
    
    
    ASIFormDataRequest *request102;
    
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,@"/app/buyer/vip_set.htm"]];
    request102=[ASIFormDataRequest requestWithURL:url];
    [request102 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request102 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    
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
    
    NSLog(@"code=%d",statuscode2);
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig:%@",dicBig);
#pragma mark -先将true改成false，记得该会true
        if ([dicBig[@"state"]  isEqualToString:@"true"]) {
//        if ([dicBig[@"state"]  isEqualToString:@"false"]) {

            _controllerArr = @[NSStringFromClass([MyInviteViewController class]),
                               
                               NSStringFromClass([CurrentRankViewController class]),
                               NSStringFromClass([RelationshipViewController class]),
                               NSStringFromClass([RewardTableViewController class]),
                               NSStringFromClass([TeamTableViewController class]),
                               NSStringFromClass([ProfitTableViewController class]),
                               NSStringFromClass([MypostViewController class]),
                               NSStringFromClass([BookViewController class])];

            
            _titleArr=@[@"我的推广",@"VIP升级",@"我的上级",@"奖励管理",@"团队管理",@"返佣收益",@"我的海报",@"授权书",@"兑换会员"];
             _desArr=@[@"邀请码与二维码",@"更高等级更多优惠",@"查看上级信息",@"领取和查看下级升级奖励",@"梦想e+,激情e+,疯狂e+",@"下级购买商品可得到返佣",@"带个人二维码的精美海报图",@"平台向用户发的授权书"];
            isvip=1;
        }else if([dicBig[@"state"]  isEqualToString:@"false"]){
        
            _controllerArr = @[ NSStringFromClass([MyInviteViewController class]),
                               
                               NSStringFromClass([CurrentRankViewController class]),
                               NSStringFromClass([RelationshipViewController class]),
                               NSStringFromClass([RewardTableViewController class]),
                               NSStringFromClass([TeamTableViewController class]),
                               NSStringFromClass([ProfitTableViewController class]),
                               NSStringFromClass([MypostViewController class]),
                               NSStringFromClass([BookViewController class]) ];
            
            
            _titleArr=@[@"我的推广",@"VIP升级",@"我的上级",@"奖励管理",@"团队管理",@"返佣收益",@"我的海报",@"授权书",@"兑换会员"];
             _desArr=@[@"邀请码与二维码",@"更高等级更多优惠",@"查看上级信息",@"领取和查看下级升级奖励",@"梦想e+,激情e+,疯狂e+",@"下级购买商品可得到返佣",@"带个人二维码的精美海报图",@"平台向用户发的授权书"];
            isvip=0;
        }else if([dicBig[@"state"]  isEqualToString:@"disable"]){
            _controllerArr=@[];
            _titleArr=@[];
            _desArr=@[];
            [SYObject failedPrompt:@"vip服务已被禁用"];
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        
        }
        
        [self.tableView reloadData];
    }else{
        NSString *s=[NSString stringWithFormat:@"%d",statuscode2];
        [SYObject failedPrompt:s];
    }
    [SYObject endLoading];
}

-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];

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
    
    if (_controllerArr==nil) {
        return 0;
    }
    return _controllerArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * ID =@"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = _titleArr[indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:15];
   UILabel *a= [[UILabel alloc]initWithFrame:CGRectMake(50, 50, 200, 44)];
    a.textColor=[UIColor lightGrayColor];
    a.textAlignment=NSTextAlignmentRight;
    a.font=[UIFont systemFontOfSize:14];
//    a.backgroundColor=[UIColor redColor];
a.text=_desArr[indexPath.row];
    cell.accessoryView=a;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = _controllerArr[indexPath.row];
    
    Class cls=NSClassFromString(str);
        if (isvip==0) {
//            [SYObject failedPrompt:@"请激活vip"];
            InfoViewController *vc=[[InfoViewController alloc]init];
            vc.pushClass=str;
            vc.pushtitle=_titleArr[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
            
            return;
        }

   
        
        
        UIViewController *vc =[[cls alloc]init];
        vc.title = _titleArr[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];

    
}


@end
