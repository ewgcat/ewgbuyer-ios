//
//  goodseditViewController.m
//  SellerApp
//
//  Created by apple on 15-4-7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "goodseditViewController.h"
#import "NilCell.h"
#import "Model.h"
#import "myAfnetwork.h"
#import "myselfParse.h"
#import "AppDelegate.h"
#import "sqlService.h"
#import "GoodsEditDetailsViewController.h"

@interface goodseditViewController ()<GoodsEditDetailsViewControllerDelegate>
{
    myselfParse *_myParse;
    BOOL SpeFlay;
    NSMutableArray *goodsSpecIds;
    NSMutableArray *goodsSpecIdValue;
    NSMutableArray *goodsInventoryDetail;
    
}

@end

@implementation goodseditViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)createBackBtn{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
    button.frame =CGRectMake(0, 0, 44, 44);
    [button setBackgroundImage:[UIImage imageNamed:@"back_lj"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
    
    UIButton *button_edit = [UIButton buttonWithType:UIButtonTypeCustom ];
    button_edit.frame =CGRectMake(0, 0, 44, 44);
    [button_edit setTitle:@"保存" forState:UIControlStateNormal];
    button_edit.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button_edit addTarget:self action:@selector(overBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar2 = [[UIBarButtonItem alloc]initWithCustomView:button_edit];
    self.navigationItem.rightBarButtonItem =bar2;
}
-(void)failedPrompt:(NSString *)prompt{
    loadingV.hidden = YES;
    label_prompt.hidden = NO;
    label_prompt.text = prompt;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
}
-(void)overBtn{
    if (nameTextField.text.length == 0) {
        [MyObject failedPrompt:@"商品名称为空"];
    }else  if (priceTextField.text.length == 0) {
        [MyObject failedPrompt:@"商品价格为空"];
    }else  if (inventroyTextField.text.length == 0){
        [MyObject failedPrompt:@"商品库存为空"];
    }else {
        if (SpeFlay && !goodsSpecIds){
            [OHAlertView showAlertWithTitle:@"是否继续？" message:@"您选择按规格配置库存，但您并没有配置相应的规格库存" cancelButton:nil otherButtons:@[@"去配置",@"继续"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                if(buttonIndex==0){
                    //去配置
                    Model *model = [dataArray objectAtIndex:0];
                    GoodsEditDetailsViewController *gedvc=[[GoodsEditDetailsViewController alloc]init];
                    gedvc.model=_model;
                    if (SpeFlay) {
                        gedvc.speFlay=@"1";
                    }else{
                        gedvc.speFlay=@"0";
                    }
                    NSMutableArray *mArray=[[NSMutableArray alloc]init];
                    for (NSDictionary *dic in model.goods_specs_info) {
                        NSString *str=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                        [mArray addObject:str];
                    }
                    gedvc.seleArray=mArray;
                    gedvc.delegate=self;
                    [self.navigationController pushViewController:gedvc animated:YES];
                }else{
                    //继续请求
                    [self getGoodsEditSaveGoodsId:_model.goods_id andGoodsName:nameTextField.text andGoodsCurrentPrice:priceTextField.text andGoodsInventory:inventroyTextField.text  andGoodsRecommend:goods_recommend andGoodsSpecIds:goodsSpecIds andGoodsSpecIdValue:goodsSpecIdValue andGoodsInventoryDetail:goodsInventoryDetail];
                }
            }];
        }else{
           [self getGoodsEditSaveGoodsId:_model.goods_id andGoodsName:nameTextField.text andGoodsCurrentPrice:priceTextField.text andGoodsInventory:inventroyTextField.text  andGoodsRecommend:goods_recommend andGoodsSpecIds:goodsSpecIds andGoodsSpecIdValue:goodsSpecIdValue andGoodsInventoryDetail:goodsInventoryDetail];
        }
        
    }
}
-(void)doTimer_disappear{
    label_prompt.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)doTimer_signout{
    label_prompt.hidden = YES;
    [LJControl cleanAll];
    AppDelegate *app = [AppDelegate sharedUserDefault];
    app.log_View.hidden = NO;
}
-(void)clearCacheSuccessOut{
    NSLog(@"成功");
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -保存请求
-(void)getGoodsEditSaveGoodsId:(NSString *)goodsId andGoodsName:(NSString *)name andGoodsCurrentPrice:(NSString *)goodsCurrentPrice andGoodsInventory:(NSString *)goodsInventory andGoodsRecommend:(NSString *)goodsRecommend andGoodsSpecIds:(NSArray *)SpecIds andGoodsSpecIdValue:(NSArray *)SpecIdValue andGoodsInventoryDetail:(NSArray *)InventoryDetail{
   
    [MyObject startLoading];
    
    Model *model=[dataArray objectAtIndex:0];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,GOODS_EDIT_SAVE_URL];
    NSString *strIds;
    if (SpecIds.count>0) {
        strIds=[SpecIds componentsJoinedByString:@","];
    }else{
        NSMutableArray *mArray=[[NSMutableArray alloc]init];
        for (NSDictionary *dic in model.goods_specs_info) {
            NSString *str=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
            [mArray addObject:str];
        }
        strIds=[mArray componentsJoinedByString:@","];
    }
    
    NSString *strValues;
    if (SpecIdValue.count>0) {
        strValues=[SpecIdValue componentsJoinedByString:@","];
    }else{
        strValues=@"";
    }
    
    NSString *jsonString;
    if(InventoryDetail.count>0){
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:InventoryDetail options:NSJSONWritingPrettyPrinted error:nil];
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        jsonString=@"";
    }

    NSString *flayStr;
    if (SpeFlay) {
        flayStr=@"spec";
    }else{
        flayStr=@"all";
    }
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken],
                          @"goods_id":goodsId,
                          @"goods_name":name,
                          @"goods_current_price":goodsCurrentPrice,
                          @"goods_inventory":goodsInventory,
                          @"goods_recommend":goodsRecommend,
                          @"goods_spec_ids":strIds,
                          @"goods_spec_id_value":strValues,
                          @"goods_inventory_detail":jsonString,
                          @"inventory_type":flayStr
                          };
    [myAfnetwork netWorkingURL:urlStr parameters:par andWay:@"post" getParseSuccess:^(myselfParse *parse) {
        NSDictionary *dicBig=parse.dicBig;
        NSLog(@"%@",dicBig);
        if ([[dicBig objectForKey:@"ret"]integerValue]==100) {
            [MyObject failedPrompt:@"保存成功"];
            [MyObject startLoading];
            NSArray *fileContent2 = USER_INFORMATION;
            NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_id=%@",SELLER_URL,GOODS_EDIT_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],_model.goods_id];
            [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
                loadingV.hidden = YES;
                _myParse = myParse;
                [self analyze:_myParse.dicBig];
                [MyObject endLoading];
            } failure:^(){
                [self fail];
                [MyObject endLoading];
            } ];
        }else{
            [MyObject failedPrompt:@"保存失败，请检查配置"];
        }
        [MyObject endLoading];
    }getParsefailure:^{
        [MyObject failedPrompt:@"网络这在开小差"];
        [MyObject endLoading];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    SpeFlay=NO;
    // Do any additional setup after loading the view.
    [self createBackBtn];
    self.title = @"编辑商品";
    self.view.backgroundColor = [UIColor whiteColor];
    if (UIDeviceSystem>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    dataArray = [[NSMutableArray alloc]init];
    if (ScreenFrame.size.height>480) {//说明是5 5s
        orderlist_tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    }else{
        orderlist_tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    }
    orderlist_tableview.backgroundColor = GRAY_COLOR;
    orderlist_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    orderlist_tableview.delegate = self;
    orderlist_tableview.dataSource=  self;
    orderlist_tableview.showsVerticalScrollIndicator=NO;
    orderlist_tableview.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:orderlist_tableview];
    
    loadingV=[LJControl loadingView:CGRectMake((self.view.frame.size.width-100)/2, (self.view.frame.size.height-59-100)/2, 100, 100)];
    loadingV.hidden = YES;
    [self.view addSubview:loadingV];
    
    label_prompt =[LJControl labelFrame:CGRectMake(50, self.view.frame.size.height-100, self.view.frame.size.width-100, 30) setText:@"" setTitleFont:17 setbackgroundColor:[UIColor blackColor] setTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    [label_prompt.layer setMasksToBounds:YES];
    [label_prompt.layer setCornerRadius:4.0];
    label_prompt.alpha = 0.8;
    label_prompt.hidden = YES;
    [self.view addSubview:label_prompt];
    
    [MyObject startLoading];
    NSArray *fileContent2 = USER_INFORMATION;
    NSString *url = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&goods_id=%@",SELLER_URL,GOODS_EDIT_URL,[fileContent2 objectAtIndex:2],[fileContent2 objectAtIndex:0],_model.goods_id];
    [myAfnetwork url:url verify:[fileContent2 objectAtIndex:3] getChat:^(myselfParse *myParse) {
        loadingV.hidden = YES;
        _myParse = myParse;
        [self analyze:_myParse.dicBig];
        [MyObject endLoading];
    } failure:^(){
        [self fail];
        [MyObject endLoading];
    } ];
}
-(void)fail{
    [MyObject failedPrompt:@"未能连接到服务器"];
}
-(void)analyze:(NSDictionary *)dicBig{
    NSLog(@"dicBig:%@",dicBig);
    if (dicBig) {
        if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"]){
            [self.navigationController popToRootViewControllerAnimated:NO];
            //登录过期 提示重新登录
            [MyObject failedPrompt:@"用户登录已过期，请重新登录"];
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
        }else{
            if (dataArray.count!=0) {
                [dataArray removeAllObjects];
            }
            Model *model = [[Model alloc]init];
            model.goods_price = [dicBig objectForKey:@"goods_current_price"];
            model.goods_inventory = [dicBig objectForKey:@"goods_inventory"];
            model.goods_name = [dicBig objectForKey:@"goods_name"];
            model.goods_recommend = [dicBig objectForKey:@"goods_recommend"];
            model.goods_id = [dicBig objectForKey:@"id"];
            model.photo_list = [dicBig objectForKey:@"photo_list"];
            model.goods_specs_info=[dicBig objectForKey:@"goods_specs_info"];
            [dataArray addObject:model];
            goods_recommend = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"goods_recommend"]];
            NSString *str=[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"inventory_type"]];
            if ([str isEqualToString:@"all"]) {
                SpeFlay=NO;
            }else  if([str isEqualToString:@"spec"]){
                SpeFlay=YES;
            }
            
            
            [orderlist_tableview reloadData];
        }
    }
}
#pragma mark - 点击事件
-(void)doTimer{
    label_prompt.hidden = YES;
}
-(void)dismissKeyBoard{
    [inventroyTextField resignFirstResponder];
    [priceTextField resignFirstResponder];
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return 1;
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 208;
    }
    if (indexPath.row==1) {
        return 44;
    }
    if (indexPath.row==2) {
        return 44;
    }
    if (indexPath.row==3) {
       return 88;
    }
    if (indexPath.row==4) {
        return 64;
    }
    return 0;
   //return 424;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NilCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NilCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.backgroundColor = GRAY_COLOR;
    }else{
        for (UIView *subView in cell.contentView.subviews){
            [subView removeFromSuperview];
        }
    }

    if (dataArray.count!=0) {
        Model *model = [dataArray objectAtIndex:0];
        
        if (indexPath.row == 0) {
            
            UIView *viewTop = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 168)];
            viewTop.backgroundColor = [UIColor whiteColor];
            [cell addSubview:viewTop];
            UIImageView *imageLLL2 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 43.75, ScreenFrame.size.width-15, 0.5)];
            imageLLL2.backgroundColor = LINE_COLOR;
            [viewTop addSubview:imageLLL2];
            UIImageView *imageLLL22 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 43.75+80, ScreenFrame.size.width-15, 0.5)];
            imageLLL22.backgroundColor = LINE_COLOR;
            [viewTop addSubview:imageLLL22];
            UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
            imageLine.backgroundColor = [UIColor lightGrayColor];
            [viewTop addSubview:imageLine];
            UIImageView *imageLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, viewTop.frame.size.height-0.5, self.view.frame.size.width, 0.5)];
            imageLine2.backgroundColor = [UIColor lightGrayColor];
            [viewTop addSubview:imageLine2];
            UILabel *lbl_ordernum = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-30, 44)];
            lbl_ordernum.text = @"商品图片";
            [viewTop addSubview:lbl_ordernum];
            
            UIScrollView *myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(15, 44, ScreenFrame.size.width-30, 80)];
            myScrollView.tag = 102;
            myScrollView.bounces = YES;
            myScrollView.delegate = self;
            myScrollView.pagingEnabled = YES;
            myScrollView.userInteractionEnabled = YES;
            myScrollView.showsHorizontalScrollIndicator = NO;
            NSArray *arr = (NSArray *)model.photo_list;
            myScrollView.contentSize=CGSizeMake(85*arr.count,80);
            [viewTop addSubview:myScrollView];
            
            for(int i=0;i<arr.count;i++){
                UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10+85*i, 5, 70, 70)];
                [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arr objectAtIndex:i]]] placeholderImage:[UIImage imageNamed:@"loading"]];
                [myScrollView addSubview:image];
            }
            UILabel *lbl_ordernum2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 124, self.view.frame.size.width-30, 44)];
            lbl_ordernum2.text = @"商品名称:";
            [viewTop addSubview:lbl_ordernum2];
            nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(100+15, 124+20, ScreenFrame.size.width - 135, 44)];
            nameTextField.placeholder = @"请输入商品名称";
            nameTextField.text = model.goods_name;
            nameTextField.font = [UIFont systemFontOfSize:17];
            nameTextField.delegate = self;
            [cell addSubview:nameTextField];
            UIImageView *imageEdit22 = [[UIImageView alloc]initWithFrame:CGRectMake(nameTextField.frame.size.width-8+115, 124+15, 14, 14)];
            imageEdit22.image = [UIImage imageNamed:@"edit"];
            [viewTop addSubview:imageEdit22];
            
            return cell;
        }else if (indexPath.row==1){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            if(cell == nil){
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                cell.backgroundColor = [UIColor whiteColor];
                UIView *l=[LJControl viewFrame:CGRectMake(0,0, self.view.frame.size.width, 0.5) backgroundColor:[UIColor lightGrayColor]];
                [cell addSubview:l];
            }
            cell.textLabel.text=@"商品规格";
            return cell;
        }else if (indexPath.row==2){
            UIView *viewTop = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 44)];
            viewTop.backgroundColor = [UIColor whiteColor];
            [cell addSubview:viewTop];
            UIView *l=[LJControl viewFrame:CGRectMake(0,0, self.view.frame.size.width, 0.5) backgroundColor:[UIColor lightGrayColor]];
            [viewTop addSubview:l];
            UILabel *speCon = [[UILabel alloc]initWithFrame:CGRectMake(15,0, self.view.frame.size.width-30, 44)];
            speCon.text = @"价格库存按照规格配置";
            [viewTop addSubview:speCon];
            UISwitch *switchIO = [[UISwitch alloc] initWithFrame:CGRectMake(ScreenFrame.size.width-80,10, 20, 10)];
            [switchIO setOn:YES];
            switchIO.on=SpeFlay;
            [switchIO addTarget:self action:@selector(switchIOAction:) forControlEvents:UIControlEventValueChanged];
            [viewTop addSubview:switchIO];
            
        }else if(indexPath.row==3){
            UIView *viewTopNew = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 44*2)];
            viewTopNew.backgroundColor = [UIColor whiteColor];
            [cell addSubview:viewTopNew];
            UIImageView *imageLLL2212 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 43.75, ScreenFrame.size.width-15, 0.5)];
            imageLLL2212.backgroundColor = LINE_COLOR;
            [viewTopNew addSubview:imageLLL2212];
            UIImageView *imageLine2222 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
            imageLine2222.backgroundColor = [UIColor lightGrayColor];
            [viewTopNew addSubview:imageLine2222];
            UIImageView *imageLine212 = [[UIImageView alloc]initWithFrame:CGRectMake(0, viewTopNew.frame.size.height-0.5, self.view.frame.size.width, 0.5)];
            imageLine212.backgroundColor = [UIColor lightGrayColor];
            [viewTopNew addSubview:imageLine212];
            UILabel *lbl_ordernum21 = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-30, 44)];
            lbl_ordernum21.text = @"商品价格:";
            [viewTopNew addSubview:lbl_ordernum21];
            priceTextField = [[UITextField alloc]initWithFrame:CGRectMake(100+15, 0, ScreenFrame.size.width - 125, 44)];
            priceTextField.placeholder = @"请输入商品价格";
            priceTextField.text = [NSString stringWithFormat:@"%@",model.goods_price];
            priceTextField.font = [UIFont systemFontOfSize:17];
            priceTextField.delegate = self;
            priceTextField.keyboardType = UIKeyboardTypeNumberPad;
            [cell addSubview:priceTextField];
            
            UIToolbar * topView2 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 30)];
            [topView2 setBarStyle:UIBarStyleBlack];
            UIBarButtonItem * helloButton2 = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];// UIBarButtonItemStyleBordered
            UIBarButtonItem * btnSpace2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
            UIBarButtonItem *doneButton2 = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
            NSArray * buttonsArray2 = [NSArray arrayWithObjects:helloButton2,btnSpace2,doneButton2,nil];
            [topView2 setItems:buttonsArray2];
            [priceTextField setInputAccessoryView:topView2];
            
            UIImageView *imageEdit2 = [[UIImageView alloc]initWithFrame:CGRectMake(priceTextField.frame.size.width-18, 15, 14, 14)];
            imageEdit2.image = [UIImage imageNamed:@"edit"];
            [priceTextField addSubview:imageEdit2];
            UILabel *lbl_ordernum212 = [[UILabel alloc]initWithFrame:CGRectMake(15, 44, self.view.frame.size.width-30, 44)];
            lbl_ordernum212.text = @"商品库存:";
            [viewTopNew addSubview:lbl_ordernum212];
            inventroyTextField = [[UITextField alloc]initWithFrame:CGRectMake(100+15, 0+44, ScreenFrame.size.width - 125, 44)];
            inventroyTextField.placeholder = @"请输入商品库存";
            inventroyTextField.text = [NSString stringWithFormat:@"%@",model.goods_inventory];
            inventroyTextField.font = [UIFont systemFontOfSize:17];
            inventroyTextField.delegate = self;
            inventroyTextField.keyboardType = UIKeyboardTypeNumberPad;
            [cell addSubview:inventroyTextField];
            UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 30)];
            [topView setBarStyle:UIBarStyleBlack];
            UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
            UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
            NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
            [topView setItems:buttonsArray];
            [inventroyTextField setInputAccessoryView:topView];
            
            UIImageView *imageEdit2212 = [[UIImageView alloc]initWithFrame:CGRectMake(inventroyTextField.frame.size.width-18, 15, 14, 14)];
            imageEdit2212.image = [UIImage imageNamed:@"edit"];
            [inventroyTextField addSubview:imageEdit2212];
            
            return cell;
        }else if(indexPath.row==4){

            UIView *viewTop2new = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
            viewTop2new.backgroundColor = [UIColor whiteColor];
            [cell addSubview:viewTop2new];
            UIImageView *imageLine22 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
            imageLine22.backgroundColor = [UIColor lightGrayColor];
            [viewTop2new addSubview:imageLine22];
            UIImageView *imageLine222 = [[UIImageView alloc]initWithFrame:CGRectMake(0, viewTop2new.frame.size.height-0.5, self.view.frame.size.width, 0.5)];
            imageLine222.backgroundColor = [UIColor lightGrayColor];
            [viewTop2new addSubview:imageLine222];
            
            UILabel *lbl_ordernum222 = [[UILabel alloc]initWithFrame:CGRectMake(15,0, self.view.frame.size.width-30, 44)];
            lbl_ordernum222.text = @"店长推荐";
            [viewTop2new addSubview:lbl_ordernum222];
            
            UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(ScreenFrame.size.width-80,6, 20, 10)];
            [switchButton setOn:YES];
            if ([goods_recommend intValue] == 0) {
                switchButton.on = NO;
            }else{
                switchButton.on = YES;
            }
            
            [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [viewTop2new addSubview:switchButton];
            
            for(int i=0;i<1;i++){
                UIImageView *imageLLL = [[UIImageView alloc]initWithFrame:CGRectMake(15, 43.75+44*i, ScreenFrame.size.width-15, 0.5)];
                imageLLL.backgroundColor = LINE_COLOR;
                [viewTop2new addSubview:imageLLL];
            }
            return cell;
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==1 ){
        Model *model = [dataArray objectAtIndex:0];
        GoodsEditDetailsViewController *gedvc=[[GoodsEditDetailsViewController alloc]init];
        gedvc.model=_model;
        if (SpeFlay) {
            gedvc.speFlay=@"1";
        }else{
             gedvc.speFlay=@"0";
        }
        NSMutableArray *mArray=[[NSMutableArray alloc]init];
        for (NSDictionary *dic in model.goods_specs_info) {
            NSString *str=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
            [mArray addObject:str];
        }
        gedvc.seleArray=mArray;
        gedvc.delegate=self;
        [self.navigationController pushViewController:gedvc animated:YES];
    
    }
}
#pragma mark - 代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGFloat keyboardHeight = 260.0f;
    if (self.view.frame.size.height - keyboardHeight <= textField.frame.origin.y + textField.frame.size.height) {
        CGFloat y = textField.frame.origin.y + 64 - (self.view.frame.size.height - keyboardHeight - textField.frame.size.height);
        [UIView beginAnimations:@"srcollView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.275f];
        self.view.frame = CGRectMake(self.view.frame.origin.x, -y, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    if (textField==nameTextField) {
         NSIndexPath *indexpath=[NSIndexPath indexPathForRow:2 inSection:0];
        [orderlist_tableview scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else if (textField==priceTextField){
        NSIndexPath *indexpath=[NSIndexPath indexPathForRow:2 inSection:0];
        [orderlist_tableview scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [UIView animateWithDuration:1 animations:^{
            self.view.frame=CGRectMake(0,-145, ScreenFrame.size.width, ScreenFrame.size.height);
        }];
    }else if (textField==inventroyTextField){
        NSIndexPath *indexpath=[NSIndexPath indexPathForRow:2 inSection:0];
        [orderlist_tableview scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [UIView animateWithDuration:1 animations:^{
            self.view.frame=CGRectMake(0,-200, ScreenFrame.size.width, ScreenFrame.size.height);
        }];
    }
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{

    return YES;
}
#pragma mark -
-(void)switchIOAction:(UISwitch*)sender{
    BOOL isButtonOn = [sender isOn];
    if (isButtonOn) {
        SpeFlay = YES;
    }else {
        SpeFlay = NO;
    }
    [orderlist_tableview reloadData];
}
-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        goods_recommend = @"1";
    }else {
        goods_recommend = @"0";
    }
}
#pragma mark -GoodsEditDetailsViewControllerDelegate
-(void)getGoodsEditDetailsData:(NSArray *)goodsSpecId andGoodsSpecIdValue:(NSArray*)goodsSpecIdValues andGoodsInventoryDetail:(NSArray *)goodsInventoryDetails{
    /*     NSMutableArray *goodsSpecIds;
     NSMutableArray *goodsSpecIdValue;
     NSMutableArray *goodsInventoryDetail;*/
    
    goodsSpecIds=[[NSMutableArray alloc]initWithArray:goodsSpecId];
    goodsSpecIdValue=[[NSMutableArray alloc]initWithArray:goodsSpecIdValues];
    goodsInventoryDetail=[[NSMutableArray alloc]initWithArray:goodsInventoryDetails];
    
    NSInteger allCount=0;
    for (NSDictionary *dic in goodsInventoryDetail) {
        allCount=allCount +[[dic objectForKey:@"count"] integerValue];
    }
    Model *model=[dataArray objectAtIndex:0];
    model.goods_inventory=[NSString stringWithFormat:@"%d",allCount];
    inventroyTextField.text = [NSString stringWithFormat:@"%@",model.goods_inventory];
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
