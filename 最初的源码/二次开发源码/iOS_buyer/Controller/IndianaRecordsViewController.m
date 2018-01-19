//
//  IndianaRecordsViewController.m
//  My_App
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "IndianaRecordsViewController.h"
#import "IndianaRecordsCell.h"
#import "IndianaRecordsCell1.h"
#import "IndianaRecordsCell2.h"
#import "AddAdminViewController.h"
#import "CloudCart.h"
#import "CloudPurchaseLottery.h"
#import "CloudPurchaseGoods.h"
#import "CloudPurchaseGoodsDetailViewController.h"

@interface IndianaRecordsViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,DetailsButtonCLickDelegate,AddAdminViewControllerDelegate>

@property (nonatomic,strong)SYObject *obj;
@property (nonatomic,weak)UITableView *allTableView;
@property (nonatomic,weak)UITableView *ongoingTableView;
@property (nonatomic,weak)UITableView *announcedTableView;
@property(nonatomic,strong)NSMutableArray *allArray;
@property(nonatomic,strong)NSMutableArray *ongoingArray;
@property(nonatomic,strong)NSMutableArray *announcedArray;


@end

@implementation IndianaRecordsViewController
{
    NSString *person_addr_id;
    NSString *person_address;
    NSString *person_name;
    NSString *person_phone;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigation];
    [self designPage];
    [self getDefaultAddress];
    [self getCloudPurchaseRecordList:@"" andBeginCount:@"0" andSelectCount:@"10"];
    [self getCloudPurchaseRecordList1:@"5" andBeginCount:@"0" andSelectCount:@"10"];
    [self getCloudPurchaseRecordList2:@"15" andBeginCount:@"0" andSelectCount:@"10"];
}
#pragma mark -界面
-(void)createNavigation{
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0Xdf0000);
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    self.title=@"夺宝记录";
    
    UIButton *backButton = [LJControl backBtn];
    backButton.tag=1000;
    [backButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem =bar;
}
#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1){  //关闭主界面的右滑返回
        return NO;
    }else{
        return YES;
    }
}
-(void)btnClicked:(UIButton *)btn{
    if ([_backType isEqualToString:@"paySuccess"] ) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)designPage{
    self.view.backgroundColor=UIColorFromRGB(0Xf2f2f2);
    _obj = [[SYObject alloc]init];
    NSArray *titles = @[@"全部",@"进行中",@"已揭晓"];
    [_obj sy_addHeadNaviTitleArray:titles toContainerViewWithFrameSetted:self.view headerHeight:44.0 topMargin:0 testColor:NO normalFontSize:15.f selectedFontSize:15.f];
    
    _allTableView = _obj.tableViewArray[0];
    _allTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _allTableView.dataSource = self;
    _allTableView.delegate = self;
    _allTableView.backgroundColor=UIColorFromRGB(0Xf2f2f2);
    [_allTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [_allTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    _ongoingTableView = _obj.tableViewArray[1];
    _ongoingTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _ongoingTableView.dataSource = self;
    _ongoingTableView.delegate = self;
    _ongoingTableView.backgroundColor=UIColorFromRGB(0Xf2f2f2);
    [_ongoingTableView addHeaderWithTarget:self action:@selector(headerRereshing1)];
    [_ongoingTableView addFooterWithTarget:self action:@selector(footerRereshing1)];
    
    _announcedTableView = _obj.tableViewArray[2];
    _announcedTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _announcedTableView.dataSource = self;
    _announcedTableView.delegate = self;
    _announcedTableView.backgroundColor=UIColorFromRGB(0Xf2f2f2);
    [_announcedTableView addHeaderWithTarget:self action:@selector(headerRereshing2)];
    [_announcedTableView addFooterWithTarget:self action:@selector(footerRereshing2)];
    
}
#pragma mark -上拉刷新、下拉加载
-(void)headerRereshing{
    [self getCloudPurchaseRecordList:@"" andBeginCount:@"0" andSelectCount:@"10"];
    [_allTableView headerEndRefreshing];
}
-(void)footerRereshing{
    static int count=1;
    count ++;
    NSString *selectCount=[NSString stringWithFormat:@"%d",10*count];
    [self getCloudPurchaseRecordList:@"" andBeginCount:@"0" andSelectCount:selectCount];
    [_allTableView footerEndRefreshing];
}
-(void)headerRereshing1{
    [self getCloudPurchaseRecordList1:@"5" andBeginCount:@"0" andSelectCount:@"10"];
    [_ongoingTableView headerEndRefreshing];
}
-(void)footerRereshing1{
    static int count=1;
    count ++;
    NSString *selectCount=[NSString stringWithFormat:@"%d",10*count];
    [self getCloudPurchaseRecordList1:@"5" andBeginCount:@"0" andSelectCount:selectCount];
    [_ongoingTableView footerEndRefreshing];
}

-(void)headerRereshing2{
    [self getCloudPurchaseRecordList2:@"15" andBeginCount:@"0" andSelectCount:@"10"];
    [_announcedTableView headerEndRefreshing];
}
-(void)footerRereshing2{
    static int count=1;
    count ++;
    NSString *selectCount=[NSString stringWithFormat:@"%d",10*count];
    [self getCloudPurchaseRecordList2:@"15" andBeginCount:@"0" andSelectCount:selectCount];
    [_announcedTableView footerEndRefreshing];
}
#pragma mark -数据
//获得默认地址
-(void)getDefaultAddress{
    NSString *url =[NSString stringWithFormat:@"%@%@",FIRST_URL,DEFAULTADDRESSFIND_URL];
    NSArray *fileContent=[MyUtil returnLocalUserFile];
    NSDictionary *par = @{
                          @"user_id":fileContent[3],
                          @"token":fileContent[1]
                          };
    [[Requester managerWithHeader]POST:url parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dict = responseObject;
        if ([dict objectForKey:@"addr_id"]) {
            person_addr_id =[NSString stringWithFormat:@"%@",[dict objectForKey:@"addr_id"]];
        }
        if ([dict objectForKey:@"addr_id"]) {
            person_addr_id =[NSString stringWithFormat:@"%@",[dict objectForKey:@"addr_id"]];
        }
        if ([dict objectForKey:@"trueName"]) {
              person_name=[NSString stringWithFormat:@"%@",[dict objectForKey:@"trueName"]];
        }
        person_address =[NSString stringWithFormat:@"%@%@",[dict objectForKey:@"area"],[dict objectForKey:@"areaInfo"]];
        NSString *str =[dict objectForKey:@"telephone"];
        if(str.length == 0){
            person_phone =[NSString stringWithFormat:@"%@",[dict objectForKey:@"mobile"]];
        }else{
            person_phone =[NSString stringWithFormat:@"%@",[dict objectForKey:@"telephone"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:@"网络请求失败"];
    }];
}
//保存默认地址
-(void)getDefaultAddressAndAddressSave:(NSString *)lottery_id{
    NSString *url =[NSString stringWithFormat:@"%@%@",FIRST_URL,DEFAULTADDRESSFIND_URL];
    NSArray *fileContent=[MyUtil returnLocalUserFile];
    NSDictionary *par = @{
                          @"user_id":fileContent[3],
                          @"token":fileContent[1]
                          };
    [[Requester managerWithHeader]POST:url parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dict = responseObject;
        if ([dict objectForKey:@"addr_id"]) {
            person_addr_id =[NSString stringWithFormat:@"%@",[dict objectForKey:@"addr_id"]];
        }
        if ([dict objectForKey:@"addr_id"]) {
            person_addr_id =[NSString stringWithFormat:@"%@",[dict objectForKey:@"addr_id"]];
        }
        if ([dict objectForKey:@"trueName"]) {
            person_name=[NSString stringWithFormat:@"%@",[dict objectForKey:@"trueName"]];
        }
        person_address =[NSString stringWithFormat:@"%@%@",[dict objectForKey:@"area"],[dict objectForKey:@"areaInfo"]];
        NSString *str =[dict objectForKey:@"telephone"];
        if(str.length == 0){
            person_phone =[NSString stringWithFormat:@"%@",[dict objectForKey:@"mobile"]];
        }else{
            person_phone =[NSString stringWithFormat:@"%@",[dict objectForKey:@"telephone"]];
        }
        if (person_name.length>0) {
            [self saveCloudpurchaseAddressSave:lottery_id andluckyUsername:person_name andLuckyAddress:person_address andLuckyPhone:person_phone];
        }else{
            [OHAlertView showAlertWithTitle:@"温馨提示" message:@"当前并没有有效的收货地址，请重新添加收货地址！" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:@"网络请求失败"];
    }];
}

//获得列表
-(void)getCloudPurchaseRecordList:(NSString *)status andBeginCount:(NSString *)begin_count andSelectCount:(NSString *)select_count{
    NSString *url =[NSString stringWithFormat:@"%@%@",FIRST_URL,CLOUDPURCHASE_CLOUDPURCHASERECORD_LIST_URL];
    NSArray *fileContent=[MyUtil returnLocalUserFile];
    NSDictionary *par = @{
                          @"user_id":fileContent[3],
                          @"token":fileContent[1],
                          @"begin_count":begin_count,
                          @"select_count":select_count,
                          @"status":status
                          };
    [[Requester managerWithHeader]POST:url parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dict = responseObject;
        NSInteger code=[[NSString stringWithFormat:@"%@",dict[@"code"]] integerValue];
        if (code==10000) {
            //全部
            self.allTableView.backgroundView=nil;
            self.allArray = [NSMutableArray array];
            NSArray *arr = dict[@"data"];
            NSLog(@"dict = %@",dict);
            for (NSDictionary *dict1 in arr) {
                CloudCart *cart = [CloudCart yy_modelWithDictionary:dict1];
                [self.allArray addObject:cart];
            }
            [self.allTableView reloadData];
        }else{
            //全部
            self.allTableView.backgroundView=[SYObject noDataView];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:@"网络请求失败"];
    }];
}
-(void)getCloudPurchaseRecordList1:(NSString *)status andBeginCount:(NSString *)begin_count andSelectCount:(NSString *)select_count{
    NSString *url =[NSString stringWithFormat:@"%@%@",FIRST_URL,CLOUDPURCHASE_CLOUDPURCHASERECORD_LIST_URL];
    NSArray *fileContent=[MyUtil returnLocalUserFile];
    NSDictionary *par = @{
                          @"user_id":fileContent[3],
                          @"token":fileContent[1],
                          @"begin_count":begin_count,
                          @"select_count":select_count,
                          @"status":status
                          };
    [[Requester managerWithHeader]POST:url parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dict = responseObject;
        NSInteger code=[[NSString stringWithFormat:@"%@",dict[@"code"]] integerValue];
        if (code==10000) {
            //进行时
              self.ongoingTableView.backgroundView=nil;
            self.ongoingArray = [NSMutableArray array];
            NSArray *arr = dict[@"data"];
            NSLog(@"dict = %@",dict);
            for (NSDictionary *dict1 in arr) {
                CloudCart *cart = [CloudCart yy_modelWithDictionary:dict1];
                [self.ongoingArray addObject:cart];
            }
            [self.ongoingTableView reloadData];
        }else{
            //进行时
            self.ongoingTableView.backgroundView=[SYObject noDataView];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:@"网络请求失败"];
    }];
}
-(void)getCloudPurchaseRecordList2:(NSString *)status andBeginCount:(NSString *)begin_count andSelectCount:(NSString *)select_count{
    NSString *url =[NSString stringWithFormat:@"%@%@",FIRST_URL,CLOUDPURCHASE_CLOUDPURCHASERECORD_LIST_URL];
    NSArray *fileContent=[MyUtil returnLocalUserFile];
    NSDictionary *par = @{
                          @"user_id":fileContent[3],
                          @"token":fileContent[1],
                          @"begin_count":begin_count,
                          @"select_count":select_count,
                          @"status":status
                          };
    [[Requester managerWithHeader]POST:url parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dict = responseObject;
        NSInteger code=[[NSString stringWithFormat:@"%@",dict[@"code"]] integerValue];
        if (code==10000) {
            //已揭晓
             self.announcedTableView.backgroundView=nil;
            self.announcedArray = [NSMutableArray array];
            NSArray *arr = dict[@"data"];
            NSLog(@"dict = %@",dict);
            for (NSDictionary *dict1 in arr) {
                CloudCart *cart = [CloudCart yy_modelWithDictionary:dict1];
                [self.announcedArray addObject:cart];
            }
            [self.announcedTableView reloadData];
          
        }else{
            //已揭晓
            self.announcedTableView.backgroundView=[SYObject noDataView];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:@"网络请求失败"];
    }];
}
//保存收货地址
-(void)saveCloudpurchaseAddressSave:(NSString *)lottery_id andluckyUsername:(NSString *)lucky_username andLuckyAddress:(NSString *)lucky_address andLuckyPhone:(NSString *)lucky_phone{
    NSString *url =[NSString stringWithFormat:@"%@%@",FIRST_URL,CLOUDPURCHASE_ADDRESS_SAVE_URL];
    NSArray *fileContent=[MyUtil returnLocalUserFile];
    NSDictionary *par = @{
                          @"user_id":fileContent[3],
                          @"token":fileContent[1],
                          @"lottery_id":lottery_id,
                          @"lucky_username":lucky_username,
                          @"lucky_address":lucky_address,
                          @"lucky_phone":lucky_phone
                          };
    [[Requester managerWithHeader]POST:url parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dict = responseObject;
        NSInteger code=[[NSString stringWithFormat:@"%@",dict[@"ret"]] integerValue];
        if (code==100) {
            [OHAlertView showAlertWithTitle:@"温馨提示" message:@"收货地址保存成功，等待商家发货！" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                [self getCloudPurchaseRecordList:@"" andBeginCount:@"0" andSelectCount:@"10"];
                [self getCloudPurchaseRecordList2:@"15" andBeginCount:@"0" andSelectCount:@"10"];
            }];
        }else{
            [SYObject failedPrompt:@"收货地址保存失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:@"网络请求失败"];
    }];
}
//确认收货地址
-(void)getCloudpurChaseDeliveryStatus:(NSString *)lottery_id{
    NSString *url =[NSString stringWithFormat:@"%@%@",FIRST_URL,CLOUDPURCHASE_DELIVERY_STATUS_URL];
    NSArray *fileContent=[MyUtil returnLocalUserFile];
    NSDictionary *par = @{
                          @"user_id":fileContent[3],
                          @"token":fileContent[1],
                          @"lottery_id":lottery_id
                        };
    [[Requester managerWithHeader]POST:url parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dict = responseObject;
        NSInteger code=[[NSString stringWithFormat:@"%@",dict[@"ret"]] integerValue];
        if (code==100) {
            [self getCloudPurchaseRecordList:@"" andBeginCount:@"0" andSelectCount:@"10"];
            [self getCloudPurchaseRecordList2:@"15" andBeginCount:@"0" andSelectCount:@"10"];
        }else{
            [SYObject failedPrompt:@"当前网络请求失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:@"网络请求失败"];
    }];
}
#pragma mark -UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_allTableView) {
        return _allArray.count;
    }else if (tableView==_ongoingTableView){
        return _ongoingArray.count;
    }else if (tableView==_announcedTableView){
        return _announcedArray.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_allTableView) {
        CloudCart *model=[_allArray objectAtIndex:indexPath.row];
//        NSArray *fileContent=[MyUtil returnLocalUserFile];
        if ([model.cloudPurchaseLottery.status isEqualToString:@"15"]&&[model.status integerValue]==0) {
            return 230;
        }else if ([model.cloudPurchaseLottery.status isEqualToString:@"15"]&&[model.status integerValue]==1) {
            return 170;
        }else{
            return 130;
        
        }
    }else if (tableView==_ongoingTableView){
        return 130;
        
    }else if (tableView==_announcedTableView){
        CloudCart *model=[_announcedArray objectAtIndex:indexPath.row];
        if ([model.status integerValue]==1){
            return 170;
        }else{
            return 230;
        }
        
        
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_allTableView) {
        CloudCart *model=[_allArray objectAtIndex:indexPath.row];
        if ([model.cloudPurchaseLottery.status isEqualToString:@"15"]&&[model.status integerValue]==0) {
            IndianaRecordsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IndianaRecordsCell"];
            if(cell == nil){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"IndianaRecordsCell" owner:self options:nil] lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
            }
            cell.model=model;
            cell.delegate=self;
            return cell;
        }else if ([model.cloudPurchaseLottery.status isEqualToString:@"15"]&&[model.status integerValue]==1) {
            IndianaRecordsCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"IndianaRecordsCell2"];
            if(cell == nil){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"IndianaRecordsCell2" owner:self options:nil] lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
            }
            cell.model=model;
            cell.delegate=self;
            return cell;
        }else{
            IndianaRecordsCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"IndianaRecordsCell1"];
            if(cell == nil){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"IndianaRecordsCell1" owner:self options:nil] lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
            }
            cell.model=model;
            cell.delegate=self;
            return cell;
        }
    }else if (tableView==_ongoingTableView){
        CloudCart *model=[_ongoingArray objectAtIndex:indexPath.row];
        IndianaRecordsCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"IndianaRecordsCell1"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"IndianaRecordsCell1" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        cell.model=model;
        cell.delegate=self;
        return cell;
        
    }else if (tableView==_announcedTableView){
        CloudCart *model=[_announcedArray objectAtIndex:indexPath.row];
        if ([model.status integerValue]==1) {
            IndianaRecordsCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"IndianaRecordsCell2"];
            if(cell == nil){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"IndianaRecordsCell2" owner:self options:nil] lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
            }
            cell.model=model;
            cell.delegate=self;
            return cell;
        }else{
            IndianaRecordsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IndianaRecordsCell"];
            if(cell == nil){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"IndianaRecordsCell" owner:self options:nil] lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
            }
            cell.model=model;
            cell.delegate=self;
            return cell;
        }
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CloudCart *model;
    if (tableView==_allTableView) {
        model=[_allArray objectAtIndex:indexPath.row];
    }else if (tableView==_ongoingTableView){
        model=[_ongoingArray objectAtIndex:indexPath.row];
    }else if (tableView==_announcedTableView){
        model=[_announcedArray objectAtIndex:indexPath.row];
    }
    CloudPurchaseGoodsDetailViewController *detail=[[CloudPurchaseGoodsDetailViewController alloc]init];
    detail.ID = model.cloudPurchaseLottery.id;
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark-DetailsButtonCLickDelegate
-(void)detailsButtonCLick:(CloudCart *)model{
    NSLog(@"%@",model.purchased_codes);
//    NSArray *ary1=[model.purchased_codes componentsSeparatedByString:@"["];
    NSMutableArray *ary1=(NSMutableArray *)[model.purchased_codes componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[],"]];
    [ary1 removeObjectAtIndex:0];
    [ary1 removeLastObject];
    NSString *str=[ary1 componentsJoinedByString:@" "];
    [WDAlertView showOneButtonWithTitle:[NSString stringWithFormat:@"%@",model.cloudPurchaseLottery.cloudPurchaseGoods.goods_name]Message:[NSString stringWithFormat:@"共参与%@人次，夺宝号码:\n%@",model.purchased_times,str]  ButtonTitle:@"确定" Click:^{
    }];
}
-(void)addressSelectionButtonCLick:(CloudCart *)model{
    if(person_name.length>0){
        [OHAlertView showAlertWithTitle:@"当前默认收货地址为：" message:[NSString stringWithFormat:@"👤%@     📞%@\n%@",person_name,person_phone,person_address] cancelButton:nil otherButtons:@[@"使用默认地址",@"重新设置"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            if (buttonIndex==0) {
                //保存默认收货地址
                [self getDefaultAddressAndAddressSave:model.cloudPurchaseLottery.id];
            }else{
                AddAdminViewController *add = [[AddAdminViewController alloc]init];
                add.cloudCartModel=model;
                add.delegate=self;
                [self.navigationController pushViewController:add animated:YES];
            }
        }];
    }else{
        AddAdminViewController *add = [[AddAdminViewController alloc]init];
         add.cloudCartModel=model;
        add.delegate=self;
        [self.navigationController pushViewController:add animated:YES];
    }

}
-(void)confirmReceiptButtonCLick:(CloudCart *)model{
//确认收货
    [self getCloudpurChaseDeliveryStatus:model.cloudPurchaseLottery.id];
}

#pragma mark -AddAdminViewControllerDelegate
-(void)addAdminViewControllerBackClick:(CloudCart *)model{
//重新选择地址返回
    [self getDefaultAddressAndAddressSave:model.cloudPurchaseLottery.id];
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
