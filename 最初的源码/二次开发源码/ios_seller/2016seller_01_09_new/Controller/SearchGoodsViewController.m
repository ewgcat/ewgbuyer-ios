//
//  SearchGoodsViewController.m
//  SellerApp
//
//  Created by barney on 16/1/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SearchGoodsViewController.h"
#import "goodsModel.h"
#import "goodsListCell.h"
#import "GoodsPreviewViewController.h"
#import "goodseditViewController.h"
@interface SearchGoodsViewController ()

@end

@implementation SearchGoodsViewController
{
    UITableView *goodsTableView;
    NSMutableArray *dataArray;
    UITextField *MyTextField;
    int count;

}
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
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
   dataArray = [[NSMutableArray alloc]init];
    count=1;
    if (UIDeviceSystem>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    
    goodsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    //空状态视图
    [MyObject noDataViewIn:self.view];
    //搜索列表设置
     goodsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     goodsTableView.delegate = self;
     goodsTableView.dataSource=  self;
     goodsTableView.hidden=YES;
     goodsTableView.showsVerticalScrollIndicator=NO;
     goodsTableView.showsHorizontalScrollIndicator = NO;
     goodsTableView.backgroundColor=UIColorFromRGB(0xf5f5f5);
    goodsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    goodsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [self.view addSubview: goodsTableView];
    
    [self createTopView];

}
#pragma mark -上拉刷新、下拉加载
-(void)headerRereshing{
    [self netJson];
    [goodsTableView.mj_header endRefreshing];
}
-(void)footerRereshing{
    count ++;
    [self netJson];
    [goodsTableView.mj_footer endRefreshing];
}
//创建顶部搜索控件
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
    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
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
//搜索按钮响应事件
-(void)searchBtnClicked{
    [MyTextField resignFirstResponder];
    if (MyTextField.text.length==0) {
        
        [OHAlertView showAlertWithTitle:@"提示" message:@"请输入搜索内容" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            
        }];
        
    }else
    {
    [MyObject startLoading];
    [self netJson];//发起网络请求
    }
}

-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
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
-(void)netJson
{
    [MyObject startLoading];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,GOODS_LIST_URL];
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken],
                          @"goods_status":@"",
                          @"orderby":@"",
                          @"ordertype":@"asc",
                          @"begin_count":@"0",
                          @"select_count":[NSString stringWithFormat:@"%d",count*10],
                          @"user_goodsclass_id":@"",
                          @"goods_name":MyTextField.text
                          
                          };
    [[MyNetTool managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MyObject endLoading];
        NSDictionary * dicBig=responseObject;
        NSLog(@"/////////商品搜索列表%@",dicBig);
        
        if (dicBig)
        {
            dataArray=[[NSMutableArray alloc]init];
            for (NSDictionary *dictt in [dicBig objectForKey:@"goods_list"])
            {
                goodsModel *model=[[goodsModel alloc]init];
                //kvc 模型赋值
                [model setValuesForKeysWithDictionary:dictt];
                [dataArray addObject:model];
                
            }
            [goodsTableView reloadData];
            //空状态
            if (dataArray.count == 0) {
                goodsTableView.hidden = YES;
            }else
            {
                goodsTableView.hidden = NO;
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        goodsTableView.hidden=YES;
        [MyObject endLoading];
        
        
    }];
 
}
#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArray.count != 0)
    {
        return dataArray.count;
    }
     return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 190;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myTabelviewCell = @"goodsListCell";
    goodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"goodsListCell" owner:self options:nil] lastObject];
        
    }
    goodsModel *model=[dataArray objectAtIndex:indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.title.text=model.goods_name;
    [cell.img sd_setImageWithURL:[NSURL URLWithString:model.goods_main_photo]placeholderImage:[UIImage imageNamed:@"loading"]];
    cell.price.text=[NSString stringWithFormat:@"￥%@",model.goods_current_price];
    cell.didSale.text=[NSString stringWithFormat:@"已售 %@",model.goods_salenum];
    cell.kc.text=[NSString stringWithFormat:@"库存 %@",model.goods_inventory];
  
    NSLog(@"model.goods_status=%@",model.goods_status);
    if ([model.goods_status integerValue]==1||[model.goods_status integerValue]==2||[model.goods_status integerValue]==-1||[model.goods_status integerValue]==-2||[model.goods_status integerValue]==-5||[model.goods_status integerValue]==-6) {
        cell.saleOffLabel.text=@"上架";
    }else{
        cell.saleOffLabel.text=@"下架";
    }
    cell.edit.tag=10000+indexPath.row;
    [cell.edit addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.saleOff.tag=20000+indexPath.row;
    [cell.saleOff addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.share.tag=30000+indexPath.row;
    [cell.share addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.del.tag=40000+indexPath.row;
    [ cell.del addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
//cell里4个按钮的点击事件
-(void)cellButtonClick:(UIButton *)btn{
    NSLog(@"btn.tag=%ld",(long)btn.tag);
    NSInteger theFew=btn.tag/10000;
    goodsModel *model=[dataArray objectAtIndex:btn.tag%10000];
    if (theFew==1) {
        //编辑
        goodseditViewController *gvc=[[goodseditViewController alloc]init];
        gvc.model=model;
        [self.navigationController pushViewController:gvc animated:YES];
    }else if (theFew==2) {
        //下架
//        NSIndexPath *index = [NSIndexPath indexPathForItem:btn.tag%10000 inSection:0];
//        goodsListCell *cell = [goodsTableView cellForRowAtIndexPath:index];
        NSInteger s=[model.goods_status integerValue];
        if (s==0) {
            //0为上架
            [OHAlertView showAlertWithTitle:@"确定下架此商品？" message:@"" cancelButton:nil otherButtons:@[@"取消",@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                if(buttonIndex==0){
                }else{
                    [self getGoodsSaleMulitId:model];
                }
            }];
            
        }else if (s==1){
            //1为在仓库中
            [OHAlertView showAlertWithTitle:@"确定上架此商品？" message:@"" cancelButton:nil otherButtons:@[@"取消",@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                if(buttonIndex==0){
                }else{
                    [self getGoodsSaleMulitId:model];
                }
            }];
        }else if (s==2){
            //2为定时自动上架
            [OHAlertView showAlertWithTitle:@"该商品已经定时自动上架" message:@"是否提前手动上架？" cancelButton:nil otherButtons:@[@"取消",@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                if(buttonIndex==0){
                }else{
                    [self getGoodsSaleMulitId:model];
                }
            }];
        }else if (s==3){
            //3为店铺过期自动下架
            [OHAlertView showAlertWithTitle:@"该商品店铺过期会自动下架" message:@"是否提前手动下架？" cancelButton:nil otherButtons:@[@"取消",@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                if(buttonIndex==0){
                }else{
                    [self getGoodsSaleMulitId:model];
                }
            }];
        }else if (s==-1){
            //-1为手动下架状态
            [OHAlertView showAlertWithTitle:@"确定上架此商品？" message:@"" cancelButton:nil otherButtons:@[@"取消",@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                if(buttonIndex==0){
                }else{
                    [self getGoodsSaleMulitId:model];
                }
            }];
            
        }else if (s==-2){
            //-2为违规下架状态
            [OHAlertView showAlertWithTitle:@"提示" message:@"该商品违规下架" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            }];
            
        }else if (s==-5){
            //-5为平台未审核
            [OHAlertView showAlertWithTitle:@"该商品上架申请已经提交后台审核。" message:@"请等待。" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            }];
        }else if (s==-6){
            //-6平台审核拒绝
            [OHAlertView showAlertWithTitle:@"提示" message:@"该商品上架申请被后台拒绝。" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            }];
        }
    }else if (theFew==3) {
        //分享
    }else if (theFew==4) {
        //删除
        [OHAlertView showAlertWithTitle:@"确定删除此商品？" message:@"" cancelButton:nil otherButtons:@[@"取消",@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            if(buttonIndex==0){
            }else{
                [self getGoodsDeleteMulitId:model.goods_id];
            }
        }];
    }
}
#pragma mark -下架请求
-(void)getGoodsSaleMulitId:(goodsModel *)model{
    [MyObject startLoading];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,STORE_GOODS_DOWN_SHELVES_URL];
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken],
                          @"mulitId":model.goods_id
                          };
    [myAfnetwork netWorkingURL:urlStr parameters:par andWay:@"post" getParseSuccess:^(myselfParse *parse) {
        NSDictionary *dicBig=parse.dicBig;
        NSLog(@"%@",dicBig);
        NSString *str=[dicBig objectForKey:@"success"];
        if (str) {
            NSInteger s=[model.goods_status intValue];
            if (s==1||s==2||s==-1) {
                [MyObject failedPrompt:@"上架成功"];
                [self netJson];
            }else{
                [MyObject failedPrompt:@"下架成功"];
                [self netJson];
            }
        }
        [MyObject endLoading];
    }getParsefailure:^{
        [MyObject failedPrompt:@"网络这在开小差"];
        [MyObject endLoading];
    }];
}
#pragma mark -删除请求
-(void)getGoodsDeleteMulitId:(NSString *)mulitId{
    [MyObject startLoading];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,STORE_GOODS_DELETE_URL];
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken],
                          @"mulitId":mulitId
                          };
    [myAfnetwork netWorkingURL:urlStr parameters:par andWay:@"post" getParseSuccess:^(myselfParse *parse) {
        NSDictionary *dicBig=parse.dicBig;
        NSLog(@"%@",dicBig);
        NSString *str=[dicBig objectForKey:@"success"];
        if (str) {
            [MyObject failedPrompt:@"删除成功"];
            [self headerRereshing];
        }
        [MyObject endLoading];
    }getParsefailure:^{
        [MyObject failedPrompt:@"网络这在开小差"];
        [MyObject endLoading];
    }];
}
//tableView里cell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
       goodsModel *model=[dataArray objectAtIndex:indexPath.row];
        NSLog(@"%@",model);
        GoodsPreviewViewController *gpvc=[[GoodsPreviewViewController alloc]init];
        gpvc.model=model;
        [self.navigationController pushViewController:gpvc animated:YES];
        
   
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
