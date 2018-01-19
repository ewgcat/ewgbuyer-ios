//
//  CommonLogisticsViewController.m
//  SellerApp
//
//  Created by apple on 15-3-30.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CommonLogisticsViewController.h"
#import "ShjModel.h"
#import "AppDelegate.h"
#import "sqlService.h"

@interface CommonLogisticsViewController (){
    UITableViewCellEditingStyle _editingStyle;
    myselfParse *_myParse;
}

@property (nonatomic,weak)UILabel *lblDefault;

@end
@implementation CommonLogisticsViewController

@synthesize lastPath;

-(void)fail{
    [MyObject endLoading];
    [MyObject failedPrompt:@"未能连接到服务器"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    syBool = NO;
    self.title = @"常用物流配置";
    self.view.backgroundColor = GRAY_COLOR;
    myBool = NO;
    cancelId = @"-1";
    
    logisticsArr = [[NSMutableArray alloc]init];
    defaultArray = [[NSMutableArray alloc]init];
    noDefaultArray = [[NSMutableArray alloc]init];
    if (UIDeviceSystem>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    if (ScreenFrame.size.height>480) {//说明是5 5s
        LogisticsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenFrame.size.width, ScreenFrame.size.height-64) style:UITableViewStyleGrouped];
    }else{
        LogisticsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenFrame.size.width, ScreenFrame.size.height-64) style:UITableViewStyleGrouped];
    }
    LogisticsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    LogisticsTableView.backgroundColor = GRAY_COLOR;
    LogisticsTableView.delegate = self;
    LogisticsTableView.dataSource = self;
    LogisticsTableView.showsVerticalScrollIndicator= NO;
    LogisticsTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:LogisticsTableView];
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    [self network];
    
}
-(void)network{
    NSArray *fileContent2 = USER_INFORMATION;
    NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@",SELLER_URL,ECC_SET_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0]];
    
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
                NSArray *array = [dicBig objectForKey:@"express_company_list"];
                NSLog(@"快递信息:%@",array);
                if (logisticsArr.count !=0) {
                    [logisticsArr removeAllObjects];
                }
                syBool = YES;
                for (NSDictionary *dic in array) {
                    ShjModel *shjm = [[ShjModel alloc]init];
                    shjm.company_name = [dic objectForKey:@"company_name"];
                    shjm.ecc_common = [dic objectForKey:@"ecc_common"];
                    shjm.ecc_default = [dic objectForKey:@"ecc_default"];
                    if ([shjm.ecc_default intValue] == 1) {
                        cancelId = [dic objectForKey:@"id"];
                        
                    }
                    shjm.ecc_id= [dic objectForKey:@"id"];
                    if (shjm.ecc_common.intValue == 1) {
                        [defaultArray addObject:shjm];
                    }
                    else if(shjm.ecc_common.intValue == 0){
                        [noDefaultArray addObject:shjm];
                    }
                    [logisticsArr addObject:shjm];
                }
                [LogisticsTableView reloadData];
            }
        }
    } failure:^(){
        [self fail];
    } ];
}
-(void)doTimer{
    
}

-(void)doTimer2{
    editBool = NO;
    btnEdit.title =@"编辑";
    myBool = NO;
    [LogisticsTableView reloadData];
}
#pragma mark -数据源方法
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (defaultArray != 0) {
            return defaultArray.count;
        }
    }
    if (section == 1) {
        if (noDefaultArray != 0) {
            return noDefaultArray.count;
        }
    }
    
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

#pragma mark -代理方法
//头部
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 200, 30)];
    label.tag = section;
    if (section == 0) {
        label.text = @"      常用物流";
    }else if(section == 1){
        label.text = @"      非常用物流";
    }
    
    return label;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger section=[indexPath section];   //分组号
    
    static NSString *shjTableViewCell = @"LogisticsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:shjTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        for (UIView *subView in cell.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    if (section == 0) {
        if (defaultArray.count != 0) {
            ShjModel *shjm = [defaultArray objectAtIndex:indexPath.row];
            
            UILabel *lblLogiName = [[UILabel alloc]initWithFrame:CGRectMake(44, 5, 200, 40)];
            lblLogiName.text = [NSString stringWithFormat:@"%@",shjm.company_name];
            [cell addSubview:lblLogiName];
            
            UIButton *btnDel = [UIButton buttonWithType:UIButtonTypeCustom];
            btnDel.frame = CGRectMake(0, 4, 44, 44);
            [btnDel setImage:[UIImage imageNamed:@"shjDel"] forState:UIControlStateNormal];
            btnDel.tag = 100+indexPath.row;
            [btnDel addTarget:self action:@selector(btnDel:) forControlEvents:UIControlEventTouchUpInside];
            btnDel.hidden = YES;
            [cell addSubview:btnDel];
            
            UIButton *btnIsMoren = [UIButton buttonWithType:UIButtonTypeCustom];
            btnIsMoren.frame = CGRectMake(60, 0, ScreenFrame.size.width - 60, 50);
            btnIsMoren.tag = indexPath.row +300;
            [btnIsMoren addTarget:self action:@selector(btnIsMoren:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btnIsMoren];
            
            UILabel *lblIsMoren = [[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width -100, 10, 70, 30)];
            [lblIsMoren.layer setMasksToBounds:YES];
            [lblIsMoren.layer setCornerRadius:4.f];
            lblIsMoren.layer.borderColor = [[UIColor grayColor] CGColor];
            lblIsMoren.layer.borderWidth = 2;
            lblIsMoren.hidden = YES;
            lblIsMoren.textAlignment = NSTextAlignmentCenter;
            lblIsMoren.font = [UIFont boldSystemFontOfSize:14];
            
            UILabel *lblDefault = [[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width -70, 10, 70, 30)];
            lblDefault.textAlignment = NSTextAlignmentCenter;
            lblDefault.font = [UIFont boldSystemFontOfSize:14];
            lblDefault.text = @"默认";
            lblDefault.textColor = NAV_COLOR;
            lblDefault.hidden = YES;
            [cell addSubview:lblDefault];
            self.lblDefault = lblDefault;
            if (syBool) {
                if (!editBool && shjm.ecc_default.integerValue == 1){
                    lblDefault.hidden = NO;
                }else {
                    lblDefault.hidden = YES;
                }
            }
            if (shjm.ecc_default.integerValue == 0) {
                lblIsMoren.text = @"设置默认";
                lblIsMoren.textColor = [UIColor redColor];
            }
            else if(shjm.ecc_default.integerValue == 1){
                lblIsMoren.text = @"取消默认";
                lblIsMoren.textColor = [UIColor lightGrayColor];
            }
            [cell addSubview:lblIsMoren];

            
            
            if (myBool == NO) {
                btnDel.hidden = YES;
                lblIsMoren.hidden = YES;
            }
            else{
                btnDel.hidden = NO;
                lblIsMoren.hidden = NO;
            }
            
        }
    }
    if (section == 1) {
        if (noDefaultArray.count != 0) {
            ShjModel *shjm = [noDefaultArray objectAtIndex:indexPath.row];
            
            UILabel *lblLogiName = [[UILabel alloc]initWithFrame:CGRectMake(44, 5, 200, 40)];
            lblLogiName.text = [NSString stringWithFormat:@"%@",shjm.company_name];
            [cell addSubview:lblLogiName];
            
            UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
            btnAdd.frame = CGRectMake(0, 4, 44, 44);
            [btnAdd setImage:[UIImage imageNamed:@"shjAdd"] forState:UIControlStateNormal];
            btnAdd.tag = 200+indexPath.row;
            [btnAdd addTarget:self action:@selector(btnAdd:) forControlEvents:UIControlEventTouchUpInside];
            btnAdd.hidden = YES;
            [cell addSubview:btnAdd];
            
            if (myBool == NO) {
                btnAdd.hidden = YES;
            }
            else{
                btnAdd.hidden = NO;
            }
        }
    }
    return cell;
}

-(void)btnDel:(UIButton *)btn{
    NSInteger index;
    index = btn.tag - 100;
    ShjModel *shjm = [defaultArray objectAtIndex:index];
    shjm.ecc_default = @"0";
    [noDefaultArray addObject:shjm];
    [defaultArray removeObject:shjm];
    [LogisticsTableView reloadData];
}

-(void) btnAdd:(UIButton *)btn{
    NSInteger index;
    index = btn.tag - 200;
    ShjModel *shjm = [noDefaultArray objectAtIndex:index];
    [defaultArray addObject:shjm];
    [noDefaultArray removeObject:shjm];
    [LogisticsTableView reloadData];
}

-(void) btnIsMoren:(UIButton *)btn{
    if (editBool) {
        syBool = NO;
        NSInteger index;
        index = btn.tag - 300;
        for(int i=0;i<defaultArray.count;i++){
            ShjModel *shjm = [defaultArray objectAtIndex:i];
            if (i == index) {
                if([shjm.ecc_default intValue] == 1){
                    shjm.ecc_default = @"0";
                }else{
                    shjm.ecc_default = @"1";
                }
            }else{
                shjm.ecc_default = @"0";
            }
        }
        [LogisticsTableView reloadData];
    }
}


-(void)doTimer_signout{
    [LJControl cleanAll];
    AppDelegate *app = [AppDelegate sharedUserDefault];
    app.log_View.hidden = NO;
}
-(void)clearCacheSuccessOut{
    NSLog(@"成功");
}
- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)editBtnClicked:(id)sender {
    if (editBool == YES) {
        //遍历数组
        NSString *str;
        for (int i = 0; i < defaultArray.count; i++) {
            ShjModel *shjm = [defaultArray objectAtIndex:i];
            if (str.length == 0) {
                str = [NSString stringWithFormat:@"%@",shjm.ecc_id];
            }else{
                str = [NSString stringWithFormat:@"%@,%@",str,shjm.ecc_id];
            }
        }
        for (int t = 0; t < defaultArray.count; t++) {
            ShjModel *shjm = [defaultArray objectAtIndex:t];
            if (shjm.ecc_default.intValue == 1) {
                [MyObject startLoading];
                NSArray *fileContent2 = USER_INFORMATION;
                NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&id=%@",SELLER_URL,ECC_DEFAULT_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],shjm.ecc_id];
                
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
                        }
                    }
                } failure:^(){
                    [self fail];
                } ];
            }else {
                BOOL ljBool = NO;
                for(int i=0;i<defaultArray.count;i++){
                    if ([shjm.ecc_id intValue] == 1) {
                        ljBool = YES;
                    }
                }
                
                if (ljBool == NO){
                    NSArray *fileContent2 = USER_INFORMATION;
                    NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&id=%@",SELLER_URL,ECC_DEFAULT_CANCE_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],cancelId];
                    [MyObject startLoading];
                    [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
                        _myParse = myParse;
                        [MyObject endLoading];
                        _myParse = myParse;
                        
                    } failure:^(){
                        [self fail];
                    } ];
                }
            }
        }
        
        
        NSArray *fileContent2 = USER_INFORMATION;
        NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&ids=%@",SELLER_URL,ECC_SAVE_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],str];
        
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
                        [LogisticsTableView setEditing:NO animated:YES];
                        [MyObject failedPrompt:@"提交成功"];
                        syBool = YES;
                        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer2) userInfo:nil repeats:NO];
                    }
                    else{
                        [MyObject failedPrompt:@"提交失败"];
                        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
                    }
                }
            }
        } failure:^(){
            [self fail];
        } ];
    }else{
        editBool = YES;
        btnEdit.title =@"完成";
        myBool = YES;
        [btnSubmit setHidden:NO ];
        [LogisticsTableView reloadData];
    }
}
@end
