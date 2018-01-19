//
//  ShippingInfoViewController.m
//  SellerApp
//
//  Created by apple on 15-3-17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ShippingInfoViewController.h"
#import "ShipEditSecViewController.h"
#import "NilCell.h"
#import "ShjModel.h"
#import "AppDelegate.h"
#import "sqlService.h"
#import "ShipEditViewController.h"

@interface ShippingInfoViewController (){
    myselfParse *_myParse;
}

@end

static ShippingInfoViewController *singleInstance=nil;

@implementation ShippingInfoViewController

+(id)sharedUserDefault
{
    if(singleInstance==nil)
    {
        @synchronized(self)
        {
            if(singleInstance==nil)
            {
                singleInstance=[[[self class] alloc] init];
            }
        }
    }
    return singleInstance;
}

- (IBAction)addBtnClicked:(id)sender {
    ShipEditViewController *edit = [[ShipEditViewController alloc]init];
    [self.navigationController pushViewController:edit animated:YES];
}

- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

+ (id)allocWithZone:(NSZone *)zone;
{
    if(singleInstance==nil)
    {
        singleInstance=[super allocWithZone:zone];
    }
    return singleInstance;
}

-(id)copyWithZone:(NSZone *)zone
{
    
    return singleInstance;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"管理发货地址";
    btnClickedBool = NO;
    self.view.backgroundColor = GRAY_COLOR;
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    [self creatTableView];
    
    dataArr = [[NSMutableArray alloc]init];
    pullDataArr = [[NSMutableArray alloc]init];
    requestBool = NO;
}
-(void)creatTableView{
    if (UIDeviceSystem>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
        
    }
    if (ScreenFrame.size.height>480) {//说明是5 5s
        shippingInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+44+20, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    }else{
        shippingInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+44+20, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    }
    shippingInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    shippingInfoTableView.delegate =self;
    shippingInfoTableView.dataSource= self;
    shippingInfoTableView.showsVerticalScrollIndicator=NO;
    shippingInfoTableView.showsHorizontalScrollIndicator = NO;
    shippingInfoTableView.backgroundColor = GRAY_COLOR;
    shippingInfoTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    shippingInfoTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [self.view addSubview:shippingInfoTableView];

    
}
-(void)headerRereshing{
    
    [self down_pull];
    [shippingInfoTableView.mj_header endRefreshing];
}
-(void)footerRereshing{
    [self up_pull];
    [shippingInfoTableView.mj_footer endRefreshing];
}

#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArr.count != 0) {
        return dataArr.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 150;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myTabelviewCell = @"NilCell";
    NilCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NilCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        for (UIView *subView in cell.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    if (dataArr.count != 0) {
        ShjModel *shjm = [dataArr objectAtIndex:indexPath.row];
        cell.backgroundColor = GRAY_COLOR;
        UIImageView *imgBaikuang = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, ScreenFrame.size.width, 130)];
        imgBaikuang.backgroundColor = [UIColor whiteColor];
        [cell addSubview:imgBaikuang];
        
        UILabel *lblOrderNum = [[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width - 120 -18, 30, 120, 24)];
        lblOrderNum.text = [NSString stringWithFormat:@"序号: %@",shjm.sa_sequence];
        lblOrderNum.textAlignment = NSTextAlignmentRight;
        [cell addSubview:lblOrderNum];
        
        UILabel *lblAddr = [[UILabel alloc]initWithFrame:CGRectMake(25, 30, 200, 24)];
        lblAddr.text = shjm.sa_name;
        lblAddr.numberOfLines = 0;
        [cell addSubview:lblAddr];
        
        UILabel *lblAddr1 = [[UILabel alloc]initWithFrame:CGRectMake(25, 54, 200, 24)];
        lblAddr1.text = shjm.sa_addr;
        lblAddr1.numberOfLines = 2;
        [cell addSubview:lblAddr1];
        
        UIImageView *imgLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 106, ScreenFrame.size.width, 1)];
        imgLine.backgroundColor = LINE_COLOR;
        [cell addSubview:imgLine];
        UIImageView *imgLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, ScreenFrame.size.width, 1)];
        imgLine2.backgroundColor = LINE_COLOR;
        [cell addSubview:imgLine2];
        UIImageView *imgLine3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 149, ScreenFrame.size.width, 1)];
        imgLine3.backgroundColor = LINE_COLOR;
        [cell addSubview:imgLine3];

        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 117, 120, 20)];
        label.text = @"设为默认地址";
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:15];
        [cell addSubview:label];
        
        UIButton *btnDefault = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDefault.frame = CGRectMake(10, 103, 160,44);
        btnDefault.tag = 100+ indexPath.row;
        CALayer *lay3 = btnDefault.layer;
        [lay3 setMasksToBounds:YES];
        [lay3 setCornerRadius:5.0f];
        myBool = YES;
        [btnDefault addTarget:self action:@selector(btnDefault:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btnDefault];
        
        UIImageView *imgIsDefault = [[UIImageView alloc]initWithFrame:CGRectMake(15, 110, 35, 35)];
        if (shjm.sa_default.integerValue == 1) {
            imgIsDefault.image = [UIImage imageNamed:@"checkbox_yes"];
        }else if(shjm.sa_default.integerValue == 0){
            imgIsDefault.image = [UIImage imageNamed:@"checkbox_no"];
        }
        [cell addSubview:imgIsDefault];
        if (myBool == YES) {
            imgIsDefault.hidden = NO;
        }else{
            imgIsDefault.hidden = YES;
        }
    
        UIButton *btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
        btnEdit.frame = CGRectMake(ScreenFrame.size.width-145, 105, 60, 44);
        btnEdit.tag = 200 + indexPath.row;
        CALayer *lay2 = btnEdit.layer;
        [lay2 setMasksToBounds:YES];
        [lay2 setCornerRadius:5.0f];
        [btnEdit addTarget:self action:@selector(btnEdit:) forControlEvents:UIControlEventTouchUpInside];
        [btnEdit setImage:[UIImage imageNamed:@"shjEdit"] forState:UIControlStateNormal];
        [cell addSubview:btnEdit];
        
        UIButton *btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDelete.frame = CGRectMake(ScreenFrame.size.width-75, 105, 60, 44);
        btnDelete.tag = 300 + indexPath.row;
        CALayer *lay4 = btnDelete.layer;
        [lay4 setMasksToBounds:YES];
        [lay4 setCornerRadius:5.0f];
        [btnDelete addTarget:self action:@selector(btnDelete:) forControlEvents:UIControlEventTouchUpInside];
        [btnDelete setImage:[UIImage imageNamed:@"shjDelete"] forState:UIControlStateNormal];
        [cell addSubview:btnDelete];
    }
    
    return cell;
}

-(void) btnDefault:(UIButton *)btn{
    NSInteger index;
    index = btn.tag - 100;
    ShjModel *shjm = [dataArr objectAtIndex:index];
    [MyObject startLoading];
    NSArray *fileContent2 = USER_INFORMATION;
    NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&id=%@",SELLER_URL,SHIP_ADDR_DEFAULT_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],shjm.sa_id];
    
    [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
        _myParse = myParse;
        [MyObject endLoading];
        _myParse = myParse;
        NSDictionary *dicBig = _myParse.dicBig;
        if (dicBig) {
            if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"]){
                [self.navigationController popToRootViewControllerAnimated:NO];
                //登录过期 提示重新登录
                [MyObject failedPrompt:@"用户登录已过期，请重新登录"];
                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
            }else{
                NSString *ret = [dicBig objectForKey:@"ret"];
                if (ret.integerValue == 100) {
                    [MyObject failedPrompt:@"设为默认发货地址成功!"];
                    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer2) userInfo:nil repeats:NO];
                }
            }
        }
    } failure:^(){
        [self fail];
    } ];
    
    for (int i = 0; i < dataArr.count; i++) {
        ShjModel *shjm = [dataArr objectAtIndex:i];
        if (i == index) {
            if ([shjm.sa_default integerValue] == 1) {
                shjm.sa_default = @"0";
            }else{
                shjm.sa_default = @"1";
                
            }
        }else{
            shjm.sa_default = @"0";
        }
    }

    [shippingInfoTableView reloadData];
}

-(void)fail{
    [MyObject failedPrompt:@"未能连接到服务器"];
}
-(void)failedPrompt:(NSString *)prompt{
    [MyObject endLoading];
    [MyObject failedPrompt:prompt];
}
-(void) btnEdit: (UIButton *)btn{
    NSInteger index;
    index = btn.tag - 200;
    ShjModel *shjm = [dataArr objectAtIndex:index];
    _edit_id = shjm.sa_id;
    ShipEditSecViewController *edit2 = [[ShipEditSecViewController alloc]init];
    [self.navigationController pushViewController:edit2 animated:YES];
}
-(void) btnDelete: (UIButton *)btn{
    NSInteger index;
    index = btn.tag - 300;
    ShjModel *shjm = [dataArr objectAtIndex:index];
    _edit_id = shjm.sa_id;
    
    UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"" message:@"是否删除本条发货地址" delegate:self cancelButtonTitle:@"删除" otherButtonTitles:@"取消", nil];
    [alv show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [MyObject startLoading];
        NSArray *fileContent2 = USER_INFORMATION;
        NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&mulitId=%@",SELLER_URL,SHIP_ADDR_DEL_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],_edit_id];
        
        [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
            _myParse = myParse;
            [MyObject endLoading];
            _myParse = myParse;
            NSDictionary *dicBig = _myParse.dicBig;
            if (dicBig) {
                if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"]){
                    [self.navigationController popToRootViewControllerAnimated:NO];
                    //登录过期 提示重新登录
                    [MyObject failedPrompt:@"用户登录已过期，请重新登录"];
                    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
                }else{
                    NSString *ret = [dicBig objectForKey:@"ret"];
                    if (ret.intValue == 100) {
                        
                        NSString *url2 = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&begin_count=%@",SELLER_URL,SHIP_ADDR_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0"];
                        
                        [myAfnetwork url:url2 verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
                            _myParse = myParse;
                            [MyObject endLoading];
                            _myParse = myParse;
                            NSDictionary *dicBig = _myParse.dicBig;
                            if (dicBig) {
                                if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"]){
                                    [self.navigationController popToRootViewControllerAnimated:NO];
                                    //登录过期 提示重新登录
                                    [MyObject failedPrompt:@"用户登录已过期，请重新登录"];
                                    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
                                }else{
                                    
                                    if (dataArr.count !=0) {
                                        [dataArr removeAllObjects];
                                    }
                                    NSArray *array = [dicBig objectForKey:@"ship_address_list"];
                                    for (NSDictionary *dic in array) {
                                        ShjModel *shjm = [[ShjModel alloc]init];
                                        shjm.sa_id = [dic objectForKey:@"id"];
                                        shjm.sa_addr = [dic objectForKey:@"sa_addr"];
                                        shjm.sa_default = [dic objectForKey:@"sa_default"];
                                        shjm.sa_name = [dic objectForKey:@"sa_name"];
                                        shjm.sa_sequence = [dic objectForKey:@"sa_sequence"];
                                        [dataArr addObject:shjm];
                                    }
                                    [shippingInfoTableView reloadData];
                                }
                            }
                        } failure:^(){
                            [self fail];
                        } ];
                        
                        [MyObject failedPrompt:@"删除发货地址成功!"];
                    }
                }
            }
        } failure:^(){
            [self fail];
        } ];
    }
}


-(void)doTimer2{
   
    [shippingInfoTableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [MyObject startLoading];
    [super viewWillAppear:YES];
    NSArray *fileContent2 = USER_INFORMATION;
    NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&begin_count=%@",SELLER_URL,SHIP_ADDR_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0"];
    
    [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
        _myParse = myParse;
        [MyObject endLoading];
        _myParse = myParse;
        NSDictionary *dicBig = _myParse.dicBig;
        if (dicBig) {
            if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"]){
                [self.navigationController popToRootViewControllerAnimated:NO];
                //登录过期 提示重新登录
                [MyObject failedPrompt:@"用户登录已过期，请重新登录"];
                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
            }else{
                
                if (dataArr.count !=0) {
                    [dataArr removeAllObjects];
                }
                NSArray *array = [dicBig objectForKey:@"ship_address_list"];
                for (NSDictionary *dic in array) {
                    ShjModel *shjm = [[ShjModel alloc]init];
                    shjm.sa_id = [dic objectForKey:@"id"];
                    shjm.sa_addr = [dic objectForKey:@"sa_addr"];
                    shjm.sa_default = [dic objectForKey:@"sa_default"];
                    shjm.sa_name = [dic objectForKey:@"sa_name"];
                    shjm.sa_sequence = [dic objectForKey:@"sa_sequence"];
                    [dataArr addObject:shjm];
                }
                [shippingInfoTableView reloadData];
            }
        }
    } failure:^(){
        [self fail];
    } ];
}


-(void)down_pull{
    
    NSArray *fileContent2 = USER_INFORMATION;
    NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&begin_count=%@",SELLER_URL,SHIP_ADDR_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0"];
    
    [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
        _myParse = myParse;
        [MyObject endLoading];
        _myParse = myParse;
        NSDictionary *dicBig = _myParse.dicBig;
        if (dicBig) {
            if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"]){
                [self.navigationController popToRootViewControllerAnimated:NO];
                //登录过期 提示重新登录
                [MyObject failedPrompt:@"用户登录已过期，请重新登录"];
                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
            }else{
                
                if (dataArr.count !=0) {
                    [dataArr removeAllObjects];
                }
                NSArray *array = [dicBig objectForKey:@"ship_address_list"];
                for (NSDictionary *dic in array) {
                    ShjModel *shjm = [[ShjModel alloc]init];
                    shjm.sa_id = [dic objectForKey:@"id"];
                    shjm.sa_addr = [dic objectForKey:@"sa_addr"];
                    shjm.sa_default = [dic objectForKey:@"sa_default"];
                    shjm.sa_name = [dic objectForKey:@"sa_name"];
                    shjm.sa_sequence = [dic objectForKey:@"sa_sequence"];
                    [dataArr addObject:shjm];
                }
                [shippingInfoTableView reloadData];
            }
        }
    } failure:^(){
        [self fail];
    } ];
}
-(void)up_pull{
    if (dataArr.count<10) {
    }else if (dataArr.count>=10){
        if (requestBool == YES){
            if (pullDataArr.count==10){
                [self pullMethod];
            }else if(pullDataArr.count==0){
            }else{
            }
        }else{
            if (pullDataArr.count%10==0){
                [self pullMethod];
            }else{
            }
        }
    }
}
-(void)pullMethod{
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"user_information.txt"]];
    NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&begin_count=%@&select_count=%@",SELLER_URL,SHIP_ADDR_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],[NSString stringWithFormat:@"%d",(int)dataArr.count],@"10"];
    
    [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
        _myParse = myParse;
        [MyObject endLoading];
        _myParse = myParse;
        NSDictionary *dicBig = _myParse.dicBig;
        if (dicBig) {
            if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"]){
                [self.navigationController popToRootViewControllerAnimated:NO];
                //登录过期 提示重新登录
                [MyObject failedPrompt:@"用户登录已过期，请重新登录"];
                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
            }else{
                NSArray *array = [dicBig objectForKey:@"ship_address_list"];
                if (pullDataArr.count!=0) {
                    [pullDataArr removeAllObjects];
                }
                for (NSDictionary *dic in array) {
                    ShjModel *shjm = [[ShjModel alloc]init];
                    shjm.sa_id = [dic objectForKey:@"id"];
                    shjm.sa_addr = [dic objectForKey:@"sa_addr"];
                    shjm.sa_default = [dic objectForKey:@"sa_default"];
                    shjm.sa_name = [dic objectForKey:@"sa_name"];
                    shjm.sa_sequence = [dic objectForKey:@"sa_sequence"];
                    [pullDataArr addObject:shjm];
                }
                [dataArr addObjectsFromArray:pullDataArr];
                requestBool = YES;
                [shippingInfoTableView reloadData];
            }
        }
    } failure:^(){
        [self fail];
    } ];
}

-(void)doTimer_signout{
    
    [LJControl cleanAll];
    AppDelegate *app = [AppDelegate sharedUserDefault];
    app.log_View.hidden = NO;
}
-(void)clearCacheSuccessOut{
    NSLog(@"成功");
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
