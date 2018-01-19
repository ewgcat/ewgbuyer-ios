//
//  CombinedViewController.m
//  My_App
//
//  Created by apple on 15/12/16.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "CombinedViewController.h"
#import "NilCell.h"
#import "Cart3Cell.h"
#import "FirstViewController.h"
@interface CombinedViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)SYObject *obj;
@property (nonatomic,weak)UITableView *suiteTableView;
@property (nonatomic,weak)UITableView *partsTableView;
@property(nonatomic,strong)NSMutableArray *suiteArray;
@property(nonatomic,strong)NSMutableArray *partsArray;
@property(nonatomic,assign)NSInteger selectedSection;
@property(nonatomic,strong)NSMutableArray *selectedGoodsArray;
@property(nonatomic,assign)BOOL flay;

@end

@implementation CombinedViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _selectedSection=0;
    _flay=NO;
    _selectedGoodsArray=[[NSMutableArray alloc]init];
    [self createNavigation];
    [self designPage];
    [self getGoodsParts:_model.detail_id];
    [self getGoodsSuits:_model.detail_id];
}
#pragma mark -界面
-(void)createNavigation{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    //导航栏
    self.title=@"组合套装";
    UIButton *backButton = [LJControl backBtn];
    backButton.tag=1000;
    [backButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backItem;
    
}


#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1){  //关闭主界面的右滑返回
        return NO;
    }else{
        return YES;
    }
}
-(void)designPage{
    self.view.backgroundColor=[UIColor whiteColor];
    _obj = [[SYObject alloc]init];
    NSArray *titles = @[@"组合套装",@"组合配件"];
    [_obj sy_addHeadNaviTitleArray:titles toContainerViewWithFrameSetted:self.view headerHeight:44.0 topMargin:0 testColor:NO normalFontSize:15.f selectedFontSize:15.f];
    _suiteTableView = _obj.tableViewArray[0];
    _suiteTableView.dataSource = self;
    _suiteTableView.delegate = self;
    _suiteTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _partsTableView = _obj.tableViewArray[1];
    _partsTableView.dataSource = self;
    _partsTableView.delegate = self;
    _partsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma mark -事件
-(void)buttonClicked:(UIButton *)btn{
    if (btn.tag==1000) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (btn.tag==1001){

    }
}
//  button1普通状态下的背景色
- (void)buttonBackGroundNormal:(UIButton *)sender
{
    sender.backgroundColor = UIColorFromRGB(0Xf15353);
}
//  button1高亮状态下的背景色
- (void)buttonBackGroundHighlighted:(UIButton *)sender
{
    sender.backgroundColor = UIColorFromRGB(0Xd15353);
}
-(void)determineButtonClick:(UIButton *)btn{
    NSLog(@"%ld",(long)_obj.curIndex);
    //判断库存
    if ([_model.detail_goods_inventory intValue]>0) {
        if (_obj.curIndex==0) {
            NSDictionary *dict=[_suiteArray objectAtIndex:btn.tag-1000];
            NSArray *arr=[dict objectForKey:@"goods_list"];
            NSMutableArray *marry=[[NSMutableArray alloc]init];
            for (NSDictionary *dic in arr) {
                NSString *str=[NSString stringWithFormat:@"%@",[dic objectForKey:@"goods_id"]];
                [marry addObject:str];
            }
            NSString *string=[marry componentsJoinedByString:@","];
            [self getAddGoodsCartbuyType:@"suit" andCombinIds:string andCombinVersion:[NSString stringWithFormat:@"%ld",(long)btn.tag-1000+1]];
            [marry removeAllObjects];
        }else  if (_obj.curIndex==1){
            NSString *string=[_selectedGoodsArray componentsJoinedByString:@","];
            [self getAddGoodsCartbuyType:@"parts" andCombinIds:string andCombinVersion:[NSString stringWithFormat:@"%ld",(long)btn.tag-1000+1]];
        }

    }else{
        [OHAlertView showAlertWithTitle:@"提示" message:@"抱歉，该商品库存不足" cancelButton:nil otherButtons:@[@"再逛逛"]buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
        }];
    }

}
#pragma mark -数据源
-(void)getGoodsSuits:(NSString *)goodId{
    [SYObject startLoading];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,COMBINATION_URL]];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    [request setPostValue:goodId forKey:@"id"];
    [request setRequestHeaders:[LJControl requestHeaderDictionary]];
    request.delegate=self;
    request.tag=1000;
    [request startAsynchronous];
  
}
-(void)getGoodsParts:(NSString *)goodId{
    [SYObject startLoading];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,COMBINATION_PARTS_URL]];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    [request setPostValue:goodId forKey:@"id"];
    [request setRequestHeaders:[LJControl requestHeaderDictionary]];
    request.delegate=self;
    request.tag=1001;
    [request startAsynchronous];
    
}
-(void)getAddGoodsCartbuyType:(NSString *)buy_type andCombinIds:(NSString *)combin_ids andCombinVersion:(NSString *)combin_version{
    [SYObject startLoading];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ADDCAR_URL]];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
 
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
    if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
        [request setPostValue:@"" forKey:@"user_id"];
        [request setPostValue:@"" forKey:@"token"];
    
    }else{
        NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:filePathDong];
        [request setPostValue:[fileContent objectAtIndex:3] forKey:@"user_id"];
        [request setPostValue:[fileContent objectAtIndex:1] forKey:@"token"];
    }
    [request setPostValue:[NSString stringWithFormat:@"%@",_model.detail_id] forKey:@"goods_id"];
    [request setPostValue:_goodsCount forKey:@"count"];
    [request setPostValue:@"" forKey:@"price"];
    [request setPostValue:@"" forKey:@"gsp"];
    [request setPostValue:combin_version forKey:@"combin_version"];
    [request setPostValue:buy_type forKey:@"buy_type"];
    [request setPostValue:combin_ids forKey:@"combin_ids"];
    [request setPostValue:@"" forKey:@"cart_mobile_ids"];
    [request setRequestHeaders:[LJControl requestHeaderDictionary]];
    request.delegate=self;
    request.tag=1002;
    [request startAsynchronous];
}

#pragma mark- ASIHTTPRequestDelegate
-(void)requestFinished:(ASIHTTPRequest *)request{
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
    NSLog(@"%@",dic);
    if (request.tag==1000) {
        if ([[dic objectForKey:@"verify"]intValue]==0) {
             _suiteTableView.backgroundView = [SYObject noDataView];
        }else{
            if (!_suiteArray) {
                _suiteArray=[[NSMutableArray alloc]init];
            }else{
                [_suiteArray removeAllObjects];
            }
            for (NSDictionary *dict in [dic objectForKey:@"plan_list"]) {
                [_suiteArray addObject:dict];
            }
            [_suiteTableView reloadData];
        
        }
    }else if (request.tag==1001){
        if ([[dic objectForKey:@"verify"]intValue]==0) {
            _partsTableView.backgroundView = [SYObject noDataView];
        }else{
            if (!_partsArray) {
                _partsArray=[[NSMutableArray alloc]init];
            }else{
                [_partsArray removeAllObjects];
            }
            for (NSDictionary *dict in [dic objectForKey:@"plan_list"]) {
                [_partsArray addObject:dict];
            }
            [_partsTableView reloadData];
        }
    }else if (request.tag==1002){
        if([[dic objectForKey:@"code"] integerValue]==1){
            [OHAlertView showAlertWithTitle:@"添加成功！" message:@"组合配件已成功加入购物车" cancelButton:nil otherButtons:@[@"去购物车",@"再逛逛"]buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                if(buttonIndex==0){
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    FirstViewController *first = [FirstViewController sharedUserDefault];
                    first.tabBarController.selectedIndex = 2;
                }else{
                }

            }];
        }else if([[dic objectForKey:@"code"] integerValue]==2){
            [OHAlertView showAlertWithTitle:@"添加成功！" message:@"组合套装已成功加入购物车" cancelButton:nil otherButtons:@[@"去购物车",@"再逛逛"]buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                if(buttonIndex==0){
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    FirstViewController *first = [FirstViewController sharedUserDefault];
                    first.tabBarController.selectedIndex = 2;
                }else{
                }
                
            }];
        }else{
            [SYObject failedPrompt:@"添加失败，请稍后重试"];
        }
    }
    [SYObject endLoading];
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"请求错误");
    [SYObject failedPrompt:@"网络正在开小差~~~"];
    [SYObject endLoading];
}
#pragma mark -UITableViewDataSource,UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==_suiteTableView) {
        if (_suiteArray.count>0) {
            return 41;
        }
    }else  if (tableView==_partsTableView){
        if (_partsArray.count>0) {
            return 41;
        }
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[LJControl viewFrame:CGRectMake(0, 0, ScreenFrame.size.width, 41) backgroundColor:[UIColor whiteColor]];
    UILabel *title=[LJControl labelFrame:CGRectMake(10, 5, 60, 30) setText:@"" setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentLeft];
    UILabel *pice=[LJControl labelFrame:CGRectMake(80, 5, 100, 30) setText:@"" setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0Xef0000) textAlignment:NSTextAlignmentLeft];
    if (tableView==_suiteTableView) {
        NSDictionary *dict=[_suiteArray objectAtIndex:section];
        title.text=[NSString stringWithFormat:@"套餐%ld",(long)section+1];
        pice.text=[NSString stringWithFormat:@"￥%.2f",[[dict objectForKey:@"plan_price"] floatValue]];
    }else  if (tableView==_partsTableView){
        NSDictionary *dict=[_partsArray objectAtIndex:section];
        title.text=[NSString stringWithFormat:@"套餐%ld",(long)section+1];
        pice.text=[NSString stringWithFormat:@"￥%.2f",[[dict objectForKey:@"plan_price"] floatValue]];
    }
    [view addSubview:title];
    [view addSubview:pice];
    
    
    UIButton *button=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(ScreenFrame.size.width-30,15, 20, 10) setNormalImage:[UIImage imageNamed:@"down-arrow1.png"] setSelectedImage:nil setTitle:@"" setTitleFont:0 setbackgroundColor:[UIColor clearColor]];
    [view addSubview:button];
    
    UILabel *ll=[LJControl labelFrame:CGRectMake(0, 40, ScreenFrame.size.width, 1) setText:@"" setTitleFont:0 setbackgroundColor:UIColorFromRGB(0XF2F2F2) setTextColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [view addSubview:ll];
    
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    btn.backgroundColor=[UIColor clearColor];
    btn.tag=1000+section;
//    if (_selectedSection==button.tag) {
//         btn.selected=_flay;
//    }
    [btn addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
   
    [view addSubview:btn];
  
    return view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView==_suiteTableView) {
        return _suiteArray.count;
    }else if (tableView==_partsTableView){
        return _partsArray.count;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_selectedSection-1000==section) {
        NSDictionary *dict;
        if (tableView==_suiteTableView) {
            dict=[_suiteArray objectAtIndex:section];
        }else if (tableView==_partsTableView){
            dict =[_partsArray objectAtIndex:section];
        }
        NSArray *arr=[dict objectForKey:@"goods_list"];
        if (_flay) {
            return arr.count+2;
        }else{
            return 1;
        }
    }
    if (tableView==_suiteTableView) {
        return 1;
    }else if (tableView==_partsTableView){
        return 1;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict;
    if (tableView==_suiteTableView) {
        dict=[_suiteArray objectAtIndex:indexPath.section];
    }else if (tableView==_partsTableView){
        dict =[_partsArray objectAtIndex:indexPath.section];
    }
    NSArray *arr=[dict objectForKey:@"goods_list"];
    if (_selectedSection-1000==indexPath.section) {
        if (indexPath.row==arr.count+1){
            return 80;
        }else{
            return 85; //111;
        }
    }else{
        return ScreenFrame.size.width/3;
    }
    return ScreenFrame.size.width/3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict;
    if (tableView==_suiteTableView) {
        dict=[_suiteArray objectAtIndex:indexPath.section];
    }else if (tableView==_partsTableView){
        dict =[_partsArray objectAtIndex:indexPath.section];
    }
    NSArray *arr=[dict objectForKey:@"goods_list"];
    if (_selectedSection-1000==indexPath.section) {
        if (_flay) {
            if (indexPath.row==0) {
                Cart3Cell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cart3Cell%ld_%ld", (long)indexPath.section, (long)indexPath.row]];
                if(cell == nil){
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"Cart3Cell" owner:self options:nil] lastObject];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                NSArray *imagearr=(NSArray *)_model.detail_goods_photos;
                [cell.pictureImageView sd_setImageWithURL:[NSURL URLWithString:[imagearr objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
                cell.nameLabel.text = _model.detail_goods_name;
                cell.specificationssLabel0.hidden=YES;
                cell.selectedButton.hidden=YES;
                return cell;

            }else if (indexPath.row==arr.count+1){
                NilCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                if(cell == nil){
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"NilCell" owner:self options:nil] lastObject];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor whiteColor];
                }else{
                    for (UIView *subView in cell.contentView.subviews)
                    {
                        [subView removeFromSuperview];
                    }
                }
                UIButton *button=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(23,5,ScreenFrame.size.width-46, 45) setNormalImage:nil setSelectedImage:nil setTitle:@"加入购物车" setTitleFont:17 setbackgroundColor:UIColorFromRGB(0Xf15353)];
                button.backgroundColor=UIColorFromRGB(0Xf15353);
                button.titleLabel.tintColor=UIColorFromRGB(0Xffffff);
                [button.layer setMasksToBounds:YES];
                [button.layer setCornerRadius:4.0];
                button.tag=indexPath.section+1000;
                [button addTarget:self action:@selector(determineButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [button addTarget:self action:@selector(buttonBackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
                [button addTarget:self action:@selector(buttonBackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button];
                return cell;
            }else{
                Cart3Cell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cart3Cell%ld_%ld", (long)indexPath.section, (long)indexPath.row]];
                if(cell == nil){
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"Cart3Cell" owner:self options:nil] lastObject];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                if (tableView==_suiteTableView) {
                        cell.selectedButton.hidden=YES;
                }else if (tableView==_partsTableView){
                    cell.selectedButton.tag=indexPath.section*1000+indexPath.row;
                    [cell.selectedButton addTarget:self action:@selector(selectedClick:) forControlEvents:UIControlEventTouchUpInside];
                }
                NSDictionary *dic=[arr objectAtIndex:indexPath.row-1];
                [cell.pictureImageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"goods_img"]] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
                cell.nameLabel.text = [dic objectForKey:@"goods_name"];
                cell.specificationssLabel0.hidden=YES;
                
                for (int i=0; i<_selectedGoodsArray.count; i++) {
                    NSString *str=[_selectedGoodsArray objectAtIndex:i];
                    NSString *string=[NSString stringWithFormat:@"%@",[dic objectForKey:@"goods_id"]];
                    if ([string isEqualToString:str]) {
                        [cell.selectedButton setBackgroundImage:[UIImage imageNamed:@"checkbox_yes.png"] forState:UIControlStateNormal];
                        cell.selectedButton.selected=YES;
                        break;
                    }
                }
                return cell;
            }
            
        }else{
            NilCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            if(cell == nil){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"NilCell" owner:self options:nil] lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
            }else{
                for (UIView *subView in cell.contentView.subviews)
                {
                    [subView removeFromSuperview];
                }
            }
            NSMutableArray *imageArray=[[NSMutableArray alloc]init];
            for (NSDictionary *dic in arr) {
                [imageArray addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"goods_img"]]];
            }
            NSInteger count=imageArray.count>3?3:imageArray.count;
            for (int i=0;i<count; i++) {
                UIImageView *img=[LJControl imageViewFrame:CGRectMake(5+ScreenFrame.size.width/3*i,5, ScreenFrame.size.width/3-10, ScreenFrame.size.width/3-10) setImage:@"" setbackgroundColor:[UIColor clearColor]];
                [img sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
                [cell.contentView addSubview:img];
            }
            UILabel *ll=[LJControl labelFrame:CGRectMake(0, ScreenFrame.size.width/3-1, ScreenFrame.size.width,1) setText:@"" setTitleFont:0 setbackgroundColor:UIColorFromRGB(0Xf2f2f2) setTextColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
            [cell.contentView addSubview:ll];
            return cell;

        }
    }
    NilCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NilCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }else{
        for (UIView *subView in cell.contentView.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    NSMutableArray *imageArray=[[NSMutableArray alloc]init];
    for (NSDictionary *dic in arr) {
        [imageArray addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"goods_img"]]];
    }
    NSInteger count=imageArray.count>3?3:imageArray.count;
    for (int i=0;i<count; i++) {
        UIImageView *img=[LJControl imageViewFrame:CGRectMake(5+ScreenFrame.size.width/3*i,5, ScreenFrame.size.width/3-10, ScreenFrame.size.width/3-10) setImage:@"" setbackgroundColor:[UIColor clearColor]];
        [img sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
        [cell.contentView addSubview:img];
    }
    UILabel *ll=[LJControl labelFrame:CGRectMake(0, ScreenFrame.size.width/3-1, ScreenFrame.size.width,1) setText:@"" setTitleFont:0 setbackgroundColor:UIColorFromRGB(0Xf2f2f2) setTextColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [cell.contentView addSubview:ll];
    return cell;
}
-(void)cellButtonClick:(UIButton*)button{
     button.selected=!button.selected;
    if (button.selected) {
        _flay=YES;
        _selectedSection=button.tag;
        [_selectedGoodsArray removeAllObjects];
    }else{
        _flay=NO;
        _selectedSection=0;
        [_selectedGoodsArray removeAllObjects];
    }
    [_suiteTableView reloadData];
    [_partsTableView reloadData];

}
#pragma mark -选中
-(void)selectedClick:(UIButton *)btn{
    NSDictionary *dict=[_partsArray objectAtIndex:btn.tag/1000];
    NSArray *arr=[dict objectForKey:@"goods_list"];
    NSDictionary *dic=[arr objectAtIndex:btn.tag%1000-1];
    btn.selected=!btn.selected;
    if (btn.selected) {
        [_selectedGoodsArray addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"goods_id"]]];
    }else{
        for (int i=0; i<_selectedGoodsArray.count; i++) {
            NSString *str=[_selectedGoodsArray objectAtIndex:i];
             NSString *string=[NSString stringWithFormat:@"%@",[dic objectForKey:@"goods_id"]];
            if ([string isEqualToString:str]) {
                [_selectedGoodsArray removeObjectAtIndex:i];
            }
        }
    }
    [_partsTableView reloadData];
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
