//
//  MyFootprintViewController.m
//  
//
//  Created by apple on 15/10/20.
//
//

#import "MyFootprintViewController.h"
#import "Model.h"
#import "FootprintTableViewCell.h"
#import "SimilarViewController.h"
#import "SecondViewController.h"
#import "DetailViewController.h"

#import "FGTableViewCell.h"

@interface MyFootprintViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,DNSSwipeableCellDelegate, DNSSwipeableCellDataSource,UIGestureRecognizerDelegate>

@end

@implementation MyFootprintViewController
{
    __weak IBOutlet UIView *noHaveView;
//    UILabel *labelTi;
    NSMutableArray *fpvListArray;
    NSMutableArray *fpDateArray;
    UITableView *tableview;
    int count;
    
    Model *Openmodel;
    NSMutableString *Opentime;
    DNSSwipeableCell *qCell;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
     [[self navigationController] setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     Openmodel=[[Model alloc]init];
    Opentime=[[NSMutableString alloc]init];
    fpvListArray=[[NSMutableArray alloc]init];
    fpDateArray=[[NSMutableArray alloc]init];
    qCell=[[DNSSwipeableCell alloc]init];
    count=0;
    [self createNavigation];
    [self designPage];
    [self getFootPoint:@"0" andEndCount:@"5"];
}
#pragma mark -上拉刷新、下拉加载
-(void)headerRereshing{
   [self getFootPoint:@"0" andEndCount:@"5"];
    [tableview headerEndRefreshing];
}
-(void)footerRereshing{
    count ++;
    [self getFootPoint:@"0" andEndCount:[NSString stringWithFormat:@"%d",5+count]];
    [tableview footerEndRefreshing];
}

#pragma mark -界面
-(void)createNavigation{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    UIView *bgView=[LJControl viewFrame:CGRectMake(0,0,ScreenFrame.size.width, 64) backgroundColor:MY_COLOR];
    [self.view addSubview:bgView];
    UILabel *titleLabel=[LJControl labelFrame:CGRectMake(ScreenFrame.size.width/2-50, 22, 100, 40) setText:@"足迹" setTitleFont:20 setbackgroundColor:[UIColor clearColor] setTextColor: [UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    [bgView addSubview:titleLabel];
    
    UIButton *backButton = [LJControl backBtn];
    backButton.frame=CGRectMake(15,30,15,23.5);
    backButton.tag=1000;
    [backButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:backButton];
    
    UIButton *rightButton=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(ScreenFrame.size.width-70, 22, 60,44) setNormalImage:nil setSelectedImage:nil setTitle:nil setTitleFont:0 setbackgroundColor:[UIColor clearColor]];
    rightButton.tag=1001;
    [rightButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *rightlabel=[LJControl labelFrame:CGRectMake(0, 0, 60, 44) setText:@"清空" setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentRight];
    [rightButton addSubview:rightlabel];
    [bgView addSubview: rightButton];
}
-(void)designPage{
    //暂无足迹
    UIImageView *noDataImage=[LJControl imageViewFrame:CGRectMake(ScreenFrame.size.width/2-131,20, 263,263) setImage:@"seller_center_nothing.png" setbackgroundColor:[UIColor clearColor]];
    [noHaveView addSubview:noDataImage];
    noHaveView.hidden=YES;
      //tableview
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenFrame.size.width, ScreenFrame.size.height-64) style:UITableViewStyleGrouped];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.hidden=YES;
    [self.view addSubview:tableview];
    [tableview addHeaderWithTarget:self action:@selector(headerRereshing)];
    [tableview addFooterWithTarget:self action:@selector(footerRereshing)];
}
-(void)buttonClicked:(UIButton *)btn{
    NSLog(@"%ld",(long)btn.tag);
    if (btn.tag==1000) {
        //返回
        [self.navigationController popViewControllerAnimated:YES];
    }else if (btn.tag==1001){
        //清空
        [OHAlertView showAlertWithTitle:@"提示" message:@"您确定要清空所有的足迹吗?" cancelButton:nil otherButtons:@[@"确定",@"取消"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            if(buttonIndex==0){
                if (fpDateArray.count>0) {
                    for (NSString *str in fpDateArray) {
                        [self getFootPointRemove:str andGoodsId:@""];
                    }
                }
            }else{
            }
        }];

    }
    
}
#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1){  //关闭主界面的右滑返回
        return NO;
    }else{
        
        return YES;
    }
}
#pragma mark -数据
-(void)getFootPoint:(NSString *)beginCount andEndCount:(NSString *)endCount{
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:filePathDong];
    NSLog(@"%@",fileContent);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,FOOTPOINT_URL]];
    ASIFormDataRequest * request=[ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[fileContent objectAtIndex:3] forKey:@"user_id"];
    [request setPostValue:[fileContent objectAtIndex:1] forKey:@"token"];
    [request setPostValue:beginCount forKey:@"beginCount"];
    [request setPostValue:endCount forKey:@"endCount"];
    [request setRequestHeaders:[LJControl requestHeaderDictionary]];
    request.tag=1000;
    [request setDelegate:self];
    [request startAsynchronous];

}
-(void)getFootPointRemove:(NSString *)date andGoodsId:(NSString *)goods_id{
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:filePathDong];
    NSLog(@"%@",fileContent);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,FOOTPOINTREMVE_URL]];
    ASIFormDataRequest * request=[ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[fileContent objectAtIndex:3] forKey:@"user_id"];
    [request setPostValue:[fileContent objectAtIndex:1] forKey:@"token"];
    [request setPostValue:date forKey:@"date"];
    [request setPostValue:goods_id forKey:@"goods_id"];
    [request setRequestHeaders:[LJControl requestHeaderDictionary]];
    request.tag=1001;
    [request setDelegate:self];
    [request startAsynchronous];

}

#pragma mark- ASIHTTPRequestDelegate
-(void)requestFinished:(ASIHTTPRequest *)request{
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
    if (request.tag==1000) {
        NSLog(@"0%@",dic);
        if (fpvListArray.count>0) {
            [fpvListArray removeAllObjects];
        }
        if (fpDateArray.count>0) {
            [fpDateArray removeAllObjects];
        }
        for (NSDictionary *dict in [dic objectForKey:@"footpoint_list"]) {
                [fpDateArray addObject:[dict objectForKey:@"fp_date"]];
                NSMutableArray *dataArray=[[NSMutableArray alloc]init];
                for (NSDictionary *subDict in [dict objectForKey:@"fpv_list"]) {
                    Model *model=[[Model alloc]init];
                    model.foot_goods_class_id=[subDict objectForKey:@"goods_class_id"];
                    model.foot_goods_class_name=[subDict objectForKey:@"goods_class_name"];
                    model.foot_goods_id=[subDict objectForKey:@"goods_id"];
                    model.foot_goods_img_path=[subDict objectForKey:@"goods_img_path"];
                    model.foot_goods_name=[subDict objectForKey:@"goods_name"];
                    float price=[[subDict objectForKey:@"goods_price"] floatValue];
                    model.foot_goods_price=[NSString stringWithFormat:@"%.2f",price];
                    
                    NSLog(@"goodPrice+==%@",[subDict objectForKey:@"goods_price"]);
                    NSLog(@"foot_goods_price+==%@", model.foot_goods_price);

                    
                    model.foot_goods_sale=[subDict objectForKey:@"goods_sale"];
                    model.foot_goods_time=[subDict objectForKey:@"goods_time"];
                    [dataArray addObject:model];
                }
                [fpvListArray addObject:dataArray];
        }
        if (fpDateArray.count>0) {
            tableview.hidden=NO;
            noHaveView.hidden=YES;
            [tableview reloadData];
        }else{
            tableview.hidden=YES;
            noHaveView.hidden=NO;
        }
    }else  if (request.tag==1001) {
        NSLog(@"1%@",dic);
        if ([[dic objectForKey:@"ret"]integerValue]==0) {
          
            [SYObject failedPrompt:@"操作失败，请稍后再试！"];
        }else if ([[dic objectForKey:@"ret"]integerValue]==1) {
            [SYObject failedPrompt:@"成功移除足迹"];
            [self getFootPoint:@"0" andEndCount:@"5"];
        }else if ([[dic objectForKey:@"ret"]integerValue]==2) {
            [SYObject failedPrompt:@"成功移除此商品的足迹"];
            [self getFootPoint:@"0" andEndCount:@"5"];
        }
    
    
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"请求错误");
    
}

#pragma mark- UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return fpDateArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *dataArray=[fpvListArray objectAtIndex:section];
    return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    UILabel *headerLabel=[LJControl labelFrame:CGRectMake(0, 0, ScreenFrame.size.width, 40) setText:[NSString stringWithFormat:@"  %@",[fpDateArray objectAtIndex:section]] setTitleFont:15 setbackgroundColor:[UIColor whiteColor] setTextColor:UIColorFromRGB(0Xa2a2a2) textAlignment:NSTextAlignmentLeft];
    
    UIButton *headerButton=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(ScreenFrame.size.width-90, 5, 80, 30) setNormalImage:nil setSelectedImage:nil setTitle:@"" setTitleFont:0 setbackgroundColor:[UIColor clearColor]];
    UILabel *label=[LJControl labelFrame:CGRectMake(0, 0, 80,30) setText:@"移除当天" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0X999999) textAlignment:NSTextAlignmentCenter];
    [headerButton.layer setMasksToBounds:YES];
    [headerButton.layer setCornerRadius:4.0];
    //边界
    headerButton.layer.borderWidth=0.5;
    headerButton.layer.borderColor=UIColorFromRGB(0x999999).CGColor;
    
    [headerButton addSubview:label];
    
    headerButton.tag=300+section;
    [headerButton addTarget:self action:@selector(DeleteDate:) forControlEvents:UIControlEventTouchUpInside];
    headerLabel.userInteractionEnabled=YES;
    [headerLabel addSubview:headerButton];
    UILabel *ll=[LJControl labelFrame:CGRectMake(0, 39, ScreenFrame.size.width, 1) setText:@"" setTitleFont:0 setbackgroundColor:UIColorFromRGB(0Xa2a2a2) setTextColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
    [headerLabel addSubview:ll];
    
    return headerLabel;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section<fpDateArray.count-1) {
        UILabel *headerLabel=[LJControl labelFrame:CGRectMake(0, 0, ScreenFrame.size.width, 20) setText:@"" setTitleFont:0 setbackgroundColor:UIColorFromRGB(0Xe5e5e5) setTextColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        UILabel *l=[LJControl labelFrame:CGRectMake(0, 0,  ScreenFrame.size.width, 1) setText:@"" setTitleFont:0 setbackgroundColor:UIColorFromRGB(0Xcbcbcb) setTextColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        [headerLabel addSubview:l];
        
        UILabel *ll=[LJControl labelFrame:CGRectMake(0, 19,  ScreenFrame.size.width, 1) setText:@"" setTitleFont:0 setbackgroundColor:UIColorFromRGB(0Xcbcbcb) setTextColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        [headerLabel addSubview:ll];
        
        return headerLabel;
    }else{
        UILabel *headerLabel=[LJControl labelFrame:CGRectMake(0, 0, ScreenFrame.size.width, 0) setText:@"" setTitleFont:0 setbackgroundColor:UIColorFromRGB(0Xe5e5e5) setTextColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    return headerLabel;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==fpDateArray.count-1) {
        return 0.00001;
    }
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FGTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[FGTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    NSArray *dataArray=[fpvListArray objectAtIndex:indexPath.section];
    Model *model=[dataArray objectAtIndex:indexPath.row];
    Model *cellmodel=[[Model alloc]init];
    cellmodel.small_photo=model.foot_goods_img_path;
    cellmodel.name=model.foot_goods_name;
    
    cellmodel.good_price =model.foot_goods_price;
    cellmodel.goods_inventory=@"1";
    cell.model=cellmodel;
    cell.indexPath = indexPath;
    cell.dataSource = self;
    cell.delegate = self;
    
    [cell setNeedsUpdateConstraints];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *dataArray=[fpvListArray objectAtIndex:indexPath.section];
    Model *model=[dataArray objectAtIndex:indexPath.row];
    SecondViewController *sec = [SecondViewController sharedUserDefault];
    sec.detail_id = model.foot_goods_id;
    DetailViewController *dVC = [[DetailViewController alloc]init];
    [self.navigationController pushViewController:dVC animated:YES];
}

-(void)attract:(UIButton *)btn{
    //删除单个商品
    int section=(int)(btn.tag-10000)/10000;
    int row=(int)(btn.tag-10000)%10000;
    NSArray *dataArray=[fpvListArray objectAtIndex:section];
    Model *model=[dataArray objectAtIndex:row];
    [self getFootPointRemove:[fpDateArray objectAtIndex:section] andGoodsId:model.foot_goods_id];
}
-(void)shoppingCart:(UIButton *)btn{
    //找相似
    int section=(int)(btn.tag-10000)/10000;
    int row=(int)(btn.tag-10000)%10000;
    NSArray *dataArray=[fpvListArray objectAtIndex:section];
    Model *model=[dataArray objectAtIndex:row];
    SimilarViewController *svc=[[SimilarViewController alloc]init];
    svc.model=model;
    [self.navigationController pushViewController:svc animated:YES];
}
-(void)DeleteDate:(UIButton *)btn{
    //删除日期足迹
    [OHAlertView showAlertWithTitle:@"提示" message:@"您确定要清空此日期的足迹吗?" cancelButton:nil otherButtons:@[@"确定",@"取消"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
        if(buttonIndex==0){
            [self getFootPointRemove:[fpDateArray objectAtIndex:btn.tag-300] andGoodsId:@""];
        }else{
        }
    }];
}
#pragma mark -DNSSwipeableCellDelegate&DNSSwipeableCellDataSource
#pragma mark - DNSSwipeableCellDataSource

#pragma mark Required Methods
- (NSInteger)numberOfButtonsInSwipeableCellAtIndexPath:(NSIndexPath *)indexPath
{
    return 2;
}

- (NSString *)titleForButtonAtIndex:(NSInteger)index inCellAtIndexPath:(NSIndexPath *)indexPath
{
    switch (index) {
        case 0:
            return NSLocalizedString(@"删除", @"删除");
            break;
        case 1:
            return NSLocalizedString(@"找相似", @"找相似");
            break;
        default:
            break;
    }
    
    return nil;
}

- (UIColor *)backgroundColorForButtonAtIndex:(NSInteger)index inCellAtIndexPath:(NSIndexPath *)indexPath
{
    switch (index) {
        case 0:
            return [UIColor redColor];
            break;
        default: {
            //Note that the random index means colors won't persist after recycling.
            return UIColorFromRGB(0XDCDCDC);
        }
            break;
    }
}

- (UIColor *)textColorForButtonAtIndex:(NSInteger)index inCellAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIColor whiteColor];
}

#pragma mark - DNSSwipeableCellDelegate

- (void)swipeableCell:(DNSSwipeableCell *)cell didSelectButtonAtIndex:(NSInteger)index
{
    if (index == 0) {
       [self getFootPointRemove:Opentime andGoodsId:Openmodel.foot_goods_id];
    } else {
        SimilarViewController *svc=[[SimilarViewController alloc]init];
        svc.model=Openmodel;
        [self.navigationController pushViewController:svc animated:YES];
    }
}

- (void)swipeableCellDidOpen:(DNSSwipeableCell *)cell
{
    [Opentime setString:[fpDateArray objectAtIndex:cell.indexPath.section]];
    NSArray *dataArray=[fpvListArray objectAtIndex:cell.indexPath.section];
    Model *model=[dataArray objectAtIndex:cell.indexPath.row];
    Openmodel.foot_goods_class_id= model.foot_goods_class_id;
    Openmodel.foot_goods_class_name=model.foot_goods_class_name;
    Openmodel.foot_goods_id=model.foot_goods_id;
    Openmodel.foot_goods_img_path=model.foot_goods_img_path;
    Openmodel.foot_goods_name=model.foot_goods_name;
    Openmodel.foot_goods_price= model.foot_goods_price;
    Openmodel.foot_goods_sale=model.foot_goods_sale;
    Openmodel.foot_goods_time= model.foot_goods_time;
    
    [qCell closeCell:YES];
    qCell=cell;
}
- (void)swipeableCellDidClose:(DNSSwipeableCell *)cell
{
    Model *model=[[Model alloc]init];
    Openmodel.foot_goods_class_id= model.foot_goods_class_id;
    Openmodel.foot_goods_class_name=model.foot_goods_class_name;
    Openmodel.foot_goods_id=model.foot_goods_id;
    Openmodel.foot_goods_img_path=model.foot_goods_img_path;
    Openmodel.foot_goods_name=model.foot_goods_name;
    Openmodel.foot_goods_price= model.foot_goods_price;
    Openmodel.foot_goods_sale=model.foot_goods_sale;
    Openmodel.foot_goods_time= model.foot_goods_time;
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
