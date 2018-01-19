//
//  GroupPurcheasTableViewController.m
//  My_App
//
//  Created by barney on 15/12/8.
//  Copyright © 2015年 barney. All rights reserved.
//

#import "GroupPurcheasTableViewController.h"
#import "ASIFormDataRequest.h"
#import "UIImageView+WebCache.h"
#import "GroupPurcheaseDetailModel.h"
#import "GroupPurchaseCell1.h"
#import "GroupPurchaseCell2.h"
#import "GroupPurchaseCell3.h"
#import "GroupPurchaseCell4.h"
#import "GroupPurchaseCell5.h"
#import "GroupPurchaseCell6.h"
#import "GroupPurchaseCell7.h"
#import "GroupPurchaseCell8.h"
#import "GroupBuyViewController.h"
#import "XibCell.h"
#import "NewLoginViewController.h"
#import "AFNetworking.h"
#import "BundlingViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "GroupMapViewController.h"

@interface GroupPurcheasTableViewController ()<ASIHTTPRequestDelegate,UIAlertViewDelegate,CLLocationManagerDelegate>
@end

@implementation GroupPurcheasTableViewController
{
    NSMutableArray *dataArray;
    ASIFormDataRequest *request_1;
    GroupPurcheaseDetailModel *_model;
    UIView *_hiddenView;
    CGFloat _imgHeight;
    XibCell *xibCellCell;
    UIAlertView *_phoneAlert;
    UIAlertView *_alert;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [SYObject startLoading];
    self.title=@"生活惠";
    [self createBackBtn];
    dataArray = [[NSMutableArray alloc]init];
    [self downloadData];
    self.tableView.separatorColor=[UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.backgroundColor=UIColorFromRGB(0xf5f5f5);
    
    //self.tableView.hidden=YES;
    
    UIView *hiddenView=[[UIView alloc]initWithFrame:CGRectMake(0,64, ScreenFrame.size.width,58)];
    _hiddenView=hiddenView;
    
    //从xib创建
    XibCell *xibCell = [[[NSBundle mainBundle]loadNibNamed:@"XibCell" owner:nil options:nil]firstObject];
    xibCellCell = xibCell;
    [xibCell.buyBtn addTarget:self action:@selector(btnClick) forControlEvents:(UIControlEventTouchUpInside)];
    xibCell.frame = hiddenView.bounds;
    [hiddenView addSubview:xibCell];
   
    hiddenView.hidden=YES;
    [self.navigationController.view addSubview:hiddenView];

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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_hiddenView removeFromSuperview];


}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UITableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    CGFloat cell1Height = cell1.height;
    if (scrollView.contentOffset.y>=cell1Height){
        _hiddenView.hidden=NO;
    }else{
        _hiddenView.hidden=YES;
    }
  
   
}

-(UIView *)loadingView:(CGRect)rect
{
    UIView *loadV=[[UIView alloc]initWithFrame:rect];
    loadV.backgroundColor=[UIColor blackColor];
    loadV.alpha = 0.8;
    UIActivityIndicatorView *activityIndicatorV=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorV.center=CGPointMake(rect.size.width/2, rect.size.height/2-10);
    [activityIndicatorV startAnimating];
    
    [loadV addSubview:activityIndicatorV];
    UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(0, 70, 100, 30)];
    la.text=@"正在加载...";
    la.backgroundColor=[UIColor clearColor];
    la.textAlignment=NSTextAlignmentCenter;
    la.textColor=[UIColor whiteColor];
    la.font=[UIFont boldSystemFontOfSize:15];
    [loadV addSubview:la];
    loadV.layer.cornerRadius=4;
    loadV.layer.masksToBounds=YES;
    return loadV;
}

-(void)downloadData
{
    NSURL *url = [NSURL URLWithString:
                  [NSString stringWithFormat:@"%@%@?id=%@",
                   FIRST_URL,
                   LIFEGROUP_URL,self.group_id
                   ]];
    request_1=[ASIFormDataRequest requestWithURL:url];
     request_1.delegate =self;
    [request_1 setDidFailSelector:@selector(my_urlRequestFailed:)];
    [request_1 setDidFinishSelector:@selector(my_urlRequestSucceeded:)];
    [request_1 startAsynchronous];
 

}
-(void)my_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        [SYObject endLoading];
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"团购详情===========%@", dicBig);
        // 每次请求都清空数据源
        if (dataArray.count!=0)
        {
            [dataArray removeAllObjects];
        }
        if (dicBig) {
            GroupPurcheaseDetailModel *model=[[GroupPurcheaseDetailModel alloc]init];
            [model setValuesForKeysWithDictionary:dicBig];
            _model=model;
            xibCellCell.nowPrice.text = [NSString stringWithFormat:@"%@",model.gg_price];
            xibCellCell.oldPrice.text = [NSString stringWithFormat:@"门市价: ￥%@",model.gg_store_price];
            
            xibCellCell.buyBtn.layer.cornerRadius=5;
        }
        
            // 下载成功刷新数据源
            [self.tableView reloadData];
             self.tableView.hidden=NO;
            
    }
    
        else
        {
            [SYObject failedPrompt:@"请求出错"];
            [SYObject endLoading];
            NSLog(@"statuscode2错了%d",statuscode2);
            self.tableView.hidden=YES;
        }
    
}
-(void)my_urlRequestFailed:(ASIFormDataRequest *)request
{
    NSLog(@"团购失败了....");
    [SYObject failedPrompt:@"网络请求失败"];
    [SYObject endLoading];
    self.tableView.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
//    return 11;
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 221;
    }else if (indexPath.row==4||indexPath.row==6||indexPath.row==9)
    return 7;
else if (indexPath.row==2)
    return 12;
else if (indexPath.row==1)
    return 119;
else if (indexPath.row==3)
    return 140;
else if (indexPath.row==5)
    return 332-36-16;
else if (indexPath.row==7)
    return 82;
else if (indexPath.row==8)
    return 44;

else
    return 54;

}
-(void)phoneBtn
{
    [OHAlertView showAlertWithTitle:nil message:[NSString stringWithFormat:@"联系电话:%@",_model.phone] cancelButton:nil otherButtons:@[@"确定",@"取消"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
        if(buttonIndex==0){
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_model.phone]]];
        }else{
        }
    }];



}
-(void)tapLocation
{
    //显示地图，定位
    GroupMapViewController *mapView=[[GroupMapViewController alloc]init];
    [self.navigationController pushViewController:mapView animated:YES];
    mapView.mapModel=_model;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row==0){
        GroupPurchaseCell1 *cell1 = [GroupPurchaseCell1 cell1WithTableView:tableView];
        cell1.model = _model;
        _imgHeight=cell1.img.size.height;
        [cell1 setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        return cell1;
    }else if (indexPath.row==1)
    {
        GroupPurchaseCell2 *cell2 = [GroupPurchaseCell2 cell2WithTableView:tableView];
        cell2.model = _model;
        [cell2.buyBtn addTarget:self action:@selector(btnClick) forControlEvents:(UIControlEventTouchUpInside)];
        [cell2 setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        return cell2;
    
    
    }else if (indexPath.row==2||indexPath.row==4||indexPath.row==6||indexPath.row==9)
    {
        GroupPurchaseCell3 *cell3 = [GroupPurchaseCell3 cell3WithTableView:tableView];
        cell3.model = _model;
        [cell3 setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        return cell3;
        
        
    }else if (indexPath.row==3)
    {
        GroupPurchaseCell4 *cell4 = [GroupPurchaseCell4 cell4WithTableView:tableView];
        cell4.model = _model;
        [cell4.phone addTarget:self action:@selector(phoneBtn) forControlEvents:(UIControlEventTouchUpInside)];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLocation)];
        [cell4.locationView addGestureRecognizer:tap];
        cell4.locationView.userInteractionEnabled=YES;
        [cell4 setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        return cell4;
        
        
    }else if (indexPath.row==5)
    {
        GroupPurchaseCell5 *cell5 = [GroupPurchaseCell5 cell5WithTableView:tableView];
        cell5.model = _model;
        [cell5 setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        return cell5;
        
        
    }else if (indexPath.row==7)
    {
        GroupPurchaseCell6 *cell6 = [GroupPurchaseCell6 cell6WithTableView:tableView];
        cell6.model = _model;
        [cell6 setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        return cell6;
        
        
    }else if (indexPath.row==8)
    {
        GroupPurchaseCell7 *cell7 = [GroupPurchaseCell7 cell7WithTableView:tableView];
        cell7.model = _model;
        [cell7 setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        return cell7;
        
        
    }else if (indexPath.row==10)
    {
        GroupPurchaseCell8 *cell8 = [GroupPurchaseCell8 cell8WithTableView:tableView];
        cell8.model = _model;
        [cell8 setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        return cell8;
        
        
    }

    else{
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        return cell;
    }

}
-(void)btnClick
{
     [SYObject startLoading];
    [SYObject checkLogin:self.navigationController s:^(BOOL login) {
        [SYObject endLoading];
        if (login) {
            
            // 抢购前判断是否绑定手机
            NSString *isPhoneBundleUrl =[NSString stringWithFormat:@"%@%@",FIRST_URL,HASPHONE_URL];
            
            [[Requester managerWithHeader]POST:isPhoneBundleUrl parameters:@{@"user_id":[SYObject currentUserID],@"token":[SYObject currentToken]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
                NSDictionary *resultDict = responseObject;
                NSInteger code=[resultDict[@"code"] integerValue];
                NSLog(@"绑定手机请求。。。%@",resultDict);
                if(code ==100){
                    NSLog(@"已绑定");
                    //支付设置
                    GroupBuyViewController *groupBuy=[[GroupBuyViewController alloc]init];
                    
                    [self.navigationController pushViewController:groupBuy animated:YES];
                    groupBuy.groupModel=_model;
                    groupBuy.mobile=[NSString stringWithFormat:@"%@",resultDict[@"mobile"]];
                    groupBuy.groupBuy_id=self.group_id;
                }else if (code ==-100){
                    [OHAlertView showAlertWithTitle:nil message:@"您还未绑定手机，请先绑定！"cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                        BundlingViewController * bund=[[BundlingViewController alloc] init];
                        [self.navigationController pushViewController:bund animated:YES];
                    }];
                }else
                {
                    NSLog(@"返回值不是期待情况！！！请联系后台");
                }

                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@", error);
            }];
                 
        }
    }];
            
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
