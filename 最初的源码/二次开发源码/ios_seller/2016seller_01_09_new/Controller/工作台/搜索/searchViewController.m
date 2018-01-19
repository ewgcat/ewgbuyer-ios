//
//  searchViewController.m
//  SellerApp
//
//  Created by apple on 15-4-15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "searchViewController.h"
#import "OrderlistCell.h"
#import "Model.h"
#import "ModifyPriceViewController.h"
#import "ModifyShipViewController.h"
#import "delayViewController.h"
#import "OrderDetailViewController.h"
#import "confirmdeliveryViewController.h"
#import "OrderCancelViewController.h"
#import "AppDelegate.h"
#import "searchViewController.h"
#import "OrderlistViewController.h"
#import "sqlService.h"
@interface searchViewController (){
    myselfParse *_myParse;
    OrderlistViewController *orderList;
}

@end

@implementation searchViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    self.tabBarController.tabBar.hidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    self.tabBarController.tabBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    orderList = [OrderlistViewController sharedUserDefault];
    self.view.backgroundColor = [UIColor whiteColor];
    orderlist_Array = [[NSMutableArray alloc]init];
    if (UIDeviceSystem>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    UIImageView *imageNothing = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenFrame.size.width-133)/2, (ScreenFrame.size.height-117)/2, 133, 117)];
    imageNothing.image = [UIImage imageNamed:@"seller_center_nothing"];
    [self.view addSubview:imageNothing];
    UILabel *labelNothing = [[UILabel alloc]initWithFrame:CGRectMake(0, imageNothing.frame.origin.y+imageNothing.frame.size.height, ScreenFrame.size.width, 30)];
    labelNothing.text = @"抱歉，没有找到相关数据";
    labelNothing.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labelNothing];
    orderlist_tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    orderlist_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    orderlist_tableview.delegate = self;
    orderlist_tableview.dataSource=  self;
    orderlist_tableview.showsVerticalScrollIndicator=NO;
    orderlist_tableview.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:orderlist_tableview];
    
    [self createTopView];
    
   
}
-(void)createTopView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 64)];
    view.backgroundColor = NAV_COLOR;
    [self.view addSubview:view];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
    button.frame =CGRectMake(13, 20, 44, 44);
    [button setBackgroundImage:[UIImage imageNamed:@"back_lj"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    MyTextField = [LJControl textFieldFrame:CGRectMake(55, 27, ScreenFrame.size.width-100, 30) text:@"" placeText:@" 🔍搜索商品" setfont:17 textColor:[UIColor blackColor] keyboard:UIKeyboardTypeDefault];
    MyTextField.delegate = self;
    MyTextField.backgroundColor = [UIColor whiteColor];
    [MyTextField.layer setMasksToBounds:YES];
    [MyTextField.layer setCornerRadius:4.0];
    [view addSubview:MyTextField];
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 30)];
    [topView setBarStyle:UIBarStyleBlack];
    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
    [topView setItems:buttonsArray];
    [MyTextField setInputAccessoryView:topView];
    
    UIButton *leftbtn = [LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(ScreenFrame.size.width-40, 27, 34, 30) setNormalImage:[UIImage imageNamed:@""] setSelectedImage:[UIImage imageNamed:@""] setTitle:@"搜索" setTitleFont:13 setbackgroundColor:[UIColor clearColor]];
    leftbtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    leftbtn.layer.borderWidth = 1.5;
    leftbtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    [leftbtn.layer setMasksToBounds:YES];
    [leftbtn.layer setCornerRadius:2.0];
    [leftbtn addTarget:self action:@selector(searchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:leftbtn];
}
-(void)searchBtnClicked{
    [MyTextField resignFirstResponder];
    [MyObject startLoading];
    [self netJson];
}

-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dismissKeyBoard{
    [MyTextField resignFirstResponder];
}

#pragma mark - uitextfield
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [MyTextField resignFirstResponder];
    return YES;
}

#pragma mark - 网络解析
-(void)netJson{
    NSArray *fileContent2 = USER_INFORMATION;
    NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&begin_count=%@&search_word=%@&device=iOS",SELLER_URL,ORDERLIST_SERACH_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],@"0",[MyTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
        [MyObject endLoading];
        _myParse = myParse;
        [self analyze:_myParse.dicBig];
    } failure:^(){
        
    } ];
}
-(void)analyze:(NSDictionary *)dicBig{
    NSLog(@"dicBig:%@",dicBig);
    if (dicBig) {
        if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"]) {
            [self.navigationController popToRootViewControllerAnimated:NO];
            //登录过期 提示重新登录
            [MyObject failedPrompt:@"用户登录已过期，请重新登录"];
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
        }else{
            NSArray *array = [dicBig objectForKey:@"order_list"];
            if (orderlist_Array.count !=0) {
                [orderlist_Array removeAllObjects];
            }
            for(NSDictionary *dic in array){
                Model *model = [[Model alloc]init];
                model.addTime = [dic objectForKey:@"addTime"];
                model.order_id = [dic objectForKey:@"order_id"];
                model.order_num = [dic objectForKey:@"order_num"];
                NSLog(@"222:%@",model.order_num);
                model.order_type = [dic objectForKey:@"order_type"];
                model.payment = [dic objectForKey:@"payment"];
                model.photo_list = [dic objectForKey:@"photo_list"];
                model.ship_price = [dic objectForKey:@"ship_price"];
                model.totalPrice = [dic objectForKey:@"totalPrice"];
                model.name_list = [dic objectForKey:@"name_list"];
                model.order_status = [dic objectForKey:@"order_status"];
                [orderlist_Array addObject:model];
            }
            if (orderlist_Array.count == 0) {
                orderlist_tableview.hidden = YES;
            }else{
                orderlist_tableview.hidden = NO;
            }
            [orderlist_tableview reloadData];
        }
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
#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (orderlist_Array.count != 0) {
        return orderlist_Array.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 178.5+44*2+20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myTabelviewCell = @"OrderlistCell";
    OrderlistCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderlistCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = GRAY_COLOR;
    }else{
        for (UIView *subView in cell.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    if (orderlist_Array.count!=0) {
        Model *mymodel = [orderlist_Array objectAtIndex:indexPath.row];
        [cell my_cell:mymodel];
        if ([mymodel.order_status intValue] == 10){//代付款
            UIButton *over_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            over_btn.frame = CGRectMake(self.view.frame.size.width-118-6, 198.5+44, 100, 44);
            over_btn.tag = indexPath.row;
            [over_btn addTarget:self action:@selector(cellCancelbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:over_btn];
            
            UIButton *Price_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            Price_btn.frame = CGRectMake(self.view.frame.size.width-118-6-110, 198.5+44, 100, 44);
            Price_btn.tag = indexPath.row;
            [Price_btn addTarget:self action:@selector(cellPricebtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:Price_btn];
        }else if ([mymodel.order_status intValue] == 20){//待发货
            UIButton *over_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            over_btn.frame = CGRectMake(self.view.frame.size.width-118-6, 198.5+44, 100, 44);
            over_btn.tag = indexPath.row;
            [over_btn addTarget:self action:@selector(cellSendbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:over_btn];
        }else if ([mymodel.order_status intValue] == 30){// 已发货
            UIButton *over_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            over_btn.frame = CGRectMake(self.view.frame.size.width-118-6, 198.5+44, 100, 44);
            over_btn.tag = indexPath.row;
            [over_btn addTarget:self action:@selector(cellShipbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:over_btn];
            
            UIButton *Price_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            Price_btn.frame = CGRectMake(self.view.frame.size.width-118-6-130, 229, 120, 44);
            Price_btn.tag = indexPath.row;
            [Price_btn addTarget:self action:@selector(cellTimebtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:Price_btn];
        }else if ([mymodel.order_status intValue] == 40){// 已确认收货
        }else if ([mymodel.order_status intValue] == 50){// 已完成
        }else{
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [MyTextField resignFirstResponder];
    if (orderlist_Array.count!=0) {
        Model *mmm = [orderlist_Array objectAtIndex:indexPath.row];
        orderList.order_id = mmm.order_id;
        
        OrderDetailViewController *order = [[OrderDetailViewController alloc]init];
        [self.navigationController pushViewController:order animated:YES];
    }
}
#pragma mark - 点击事件
-(void)cellSendbtnClicked:(UIButton *)btn{
    [MyTextField resignFirstResponder];
    if (orderlist_Array.count!=0) {
        Model *mmm = [orderlist_Array objectAtIndex:btn.tag];
        orderList.order_id = mmm.order_id;
        confirmdeliveryViewController *inin = [[confirmdeliveryViewController alloc]init];
        [self.navigationController pushViewController:inin animated:YES];
    }
}

-(void)cellShipbtnClicked:(UIButton *)btn{
    [MyTextField resignFirstResponder];
    if (orderlist_Array.count!=0) {
        Model *mmm = [orderlist_Array objectAtIndex:btn.tag];
        orderList.order_id = mmm.order_id;
        ModifyShipViewController *modify = [[ModifyShipViewController alloc]init];
        [self.navigationController pushViewController:modify animated:YES];
    }
}
-(void)cellTimebtnClicked:(UIButton *)btn{
    [MyTextField resignFirstResponder];
    if (orderlist_Array.count!=0) {
        Model *mmm = [orderlist_Array objectAtIndex:btn.tag];
        orderList.order_num = mmm.order_num;
        orderList.order_id = mmm.order_id;
        NSLog(@"orderList.order_num:%@",mmm.order_num);
        delayViewController *delay = [[delayViewController alloc]init];
        [self.navigationController pushViewController:delay animated:YES];
    }
}

-(void)cellCancelbtnClicked:(UIButton *)btn{
    [MyTextField resignFirstResponder];
    if (orderlist_Array.count!=0) {
        Model *mmm = [orderlist_Array objectAtIndex:btn.tag];
        orderList.order_id = mmm.order_id;
        orderList.order_num = mmm.order_num;
        OrderCancelViewController *modify = [[OrderCancelViewController alloc]init];
        [self.navigationController pushViewController:modify animated:YES];
    }
}

-(void)cellPricebtnClicked:(UIButton *)btn{
    [MyTextField resignFirstResponder];
    if (orderlist_Array.count!=0) {
        Model *mmm = [orderlist_Array objectAtIndex:btn.tag];
        orderList.order_id = mmm.order_id;
        ModifyPriceViewController *modify = [[ModifyPriceViewController alloc]init];
        [self.navigationController pushViewController:modify animated:YES];
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
