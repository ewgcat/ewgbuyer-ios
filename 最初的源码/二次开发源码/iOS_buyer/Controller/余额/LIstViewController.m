//
//  LIstViewController.m
//  
//
//  Created by apple on 15/10/14.
//
//

#import "LIstViewController.h"
#import "AccountCell.h"
#import "AccountModel.h"
@interface LIstViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    __weak IBOutlet UIView *NoDataView;
    __weak IBOutlet UIView *hideView;
    __weak IBOutlet UIButton *IntoButton;
    __weak IBOutlet UIButton *OutButton;
    
    NSMutableArray *dataArray;
    UITableView *tableview;
    NSMutableString *DepositType;
    UIButton *rightButton;
    UILabel * rightlabel;
    int  count;
}
@end

@implementation LIstViewController
#pragma mark -上拉刷新、下拉加载
-(void)headerRereshing{
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:filePathDong];
    NSLog(@"%@",fileContent );
    [self getBuyerPredepositLogUserId:[fileContent objectAtIndex:3] andBeginCount:@"0" andSelectCount:@"10"  andToken:[fileContent objectAtIndex:1] andDepositType:DepositType];
    [tableview headerEndRefreshing];
}
-(void)footerRereshing{
    count ++;
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:filePathDong];
    NSLog(@"%@",fileContent );
    [self getBuyerPredepositLogUserId:[fileContent objectAtIndex:3] andBeginCount:@"0" andSelectCount:[NSString stringWithFormat:@"%d",10*count]  andToken:[fileContent objectAtIndex:1] andDepositType:DepositType];
    [tableview footerEndRefreshing];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataArray=[[NSMutableArray alloc]init];
    DepositType=[[NSMutableString alloc]init];
    count=0;
    [self createNavigation];
    [self designPage];
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:filePathDong];
    NSLog(@"%@",fileContent );
    [self getBuyerPredepositLogUserId:[fileContent objectAtIndex:3] andBeginCount:@"0" andSelectCount:@"10"  andToken:[fileContent objectAtIndex:1] andDepositType:@""];
    [DepositType setString:@""];
}
#pragma mark -界面
-(void)createNavigation{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    //导航栏
    UIView *bgView=[LJControl viewFrame:CGRectMake(0,0,ScreenFrame.size.width, 64) backgroundColor:UIColorFromRGB(0Xdf0000)];
    [self.view addSubview:bgView];
    UILabel *titleLabel=[LJControl labelFrame:CGRectMake(ScreenFrame.size.width/2-50, 22, 100, 40) setText:@"余额明细" setTitleFont:22 setbackgroundColor:[UIColor clearColor] setTextColor: [UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    [bgView addSubview:titleLabel];
    
    UIButton *backButton = [LJControl backBtn];
    backButton.frame=CGRectMake(10,20,44,44);
    backButton.tag=1000;
    [backButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:backButton];
    
    rightButton=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(ScreenFrame.size.width-130, 22, 120,40) setNormalImage:nil setSelectedImage:nil setTitle:nil setTitleFont:0 setbackgroundColor:[UIColor clearColor]];
    rightButton.tag=1001;
    [rightButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    rightlabel=[LJControl labelFrame:CGRectMake(0, 0, 104, 40) setText:@"全部" setTitleFont:22 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentRight];
    [rightButton addSubview:rightlabel];
    
    UIImageView *rightimage=[LJControl imageViewFrame:CGRectMake(104, 24, 16, 16) setImage:@"whitedownarrow.png" setbackgroundColor:[UIColor clearColor]];
    [rightButton addSubview:rightimage];
    [bgView addSubview:rightButton];
   
    
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
    
    //暂无分类
    UIImageView *noDataImage=[LJControl imageViewFrame:CGRectMake(ScreenFrame.size.width/2-131,50, 263,263) setImage:@"seller_center_nothing.png" setbackgroundColor:[UIColor clearColor]];
    [NoDataView addSubview:noDataImage];
    NoDataView.hidden=YES;
    
    //转出、转入
    hideView.backgroundColor=[UIColor whiteColor];
    hideView.hidden=YES;
    hideView.layer.shadowColor = [UIColor grayColor].CGColor;
    hideView.layer.shadowOffset = CGSizeMake(2,2);
    hideView.layer.shadowOpacity = 0.5;
    hideView.layer.shadowRadius = 2;
    
    //tableview
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0,64, ScreenFrame.size.width, ScreenFrame.size.height-65) style:UITableViewStylePlain];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.delegate=self;
    tableview.dataSource=self;
    [self.view addSubview:tableview];
    [tableview addHeaderWithTarget:self action:@selector(headerRereshing)];
    [tableview addFooterWithTarget:self action:@selector(footerRereshing)];
   
    //
    [IntoButton setTitle:@"全部" forState:UIControlStateSelected];
    [OutButton setTitle:@"全部" forState:UIControlStateSelected];
}

- (IBAction)buttonClicked:(UIButton *)sender {
    NSLog(@"%ld",(long)sender.tag);
    if (sender.tag==1000) {
        //返回
        [self.navigationController popViewControllerAnimated:YES];
    }else if (sender.tag==1001){
        //弹出
        sender.selected=!sender.selected;
        if (sender.selected) {
            hideView.hidden=NO;
            [self.view bringSubviewToFront:hideView];
        }else{
            hideView.hidden=YES;
        }
    }else if (sender.tag==1002){
    //全部
        hideView.hidden=YES;
        rightlabel.text=@"全部";
        rightButton.selected=NO;
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:filePathDong];
        NSLog(@"%@",fileContent );
        [self getBuyerPredepositLogUserId:[fileContent objectAtIndex:3] andBeginCount:@"0" andSelectCount:@"10"  andToken:[fileContent objectAtIndex:1] andDepositType:@""];
        [DepositType setString:@""];

    
    }else if (sender.tag==1003){
        //转入
        OutButton.selected=NO;
        sender.selected=!sender.selected;
        if (sender.selected) {
            hideView.hidden=YES;
            rightlabel.text=@"转入";
            rightButton.selected=NO;
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:filePathDong];
            NSLog(@"%@",fileContent );
            [self getBuyerPredepositLogUserId:[fileContent objectAtIndex:3] andBeginCount:@"0" andSelectCount:@"10"  andToken:[fileContent objectAtIndex:1] andDepositType:@"1"];
            [DepositType setString:@"1"];;

        }else{
            hideView.hidden=YES;
            rightlabel.text=@"全部";
            rightButton.selected=NO;
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:filePathDong];
            NSLog(@"%@",fileContent );
            [self getBuyerPredepositLogUserId:[fileContent objectAtIndex:3] andBeginCount:@"0" andSelectCount:@"10"  andToken:[fileContent objectAtIndex:1] andDepositType:@""];
            [DepositType setString:@""];
        
        
        }
        
//        hideView.hidden=YES;
//        rightlabel.text=@"转入";
//        rightButton.selected=NO;
//        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//        NSString *documentsPath = [docPath objectAtIndex:0];
//        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
//        NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:filePathDong];
//        NSLog(@"%@",fileContent );
//        [self getBuyerPredepositLogUserId:[fileContent objectAtIndex:3] andBeginCount:@"0" andSelectCount:@"10"  andToken:[fileContent objectAtIndex:1] andDepositType:@"1"];
//        [DepositType setString:@"1"];;
    }else if (sender.tag==1004){
        //转出
        IntoButton.selected=NO;
        sender.selected=!sender.selected;
        if (sender.selected) {
            hideView.hidden=YES;
            rightlabel.text=@"转出";
            rightButton.selected=NO;
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:filePathDong];
            NSLog(@"%@",fileContent );
            [self getBuyerPredepositLogUserId:[fileContent objectAtIndex:3] andBeginCount:@"0" andSelectCount:@"10"  andToken:[fileContent objectAtIndex:1] andDepositType:@"0"];
            [DepositType setString:@"0"];;
        }else{
            hideView.hidden=YES;
            rightlabel.text=@"全部";
            rightButton.selected=NO;
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:filePathDong];
            NSLog(@"%@",fileContent );
            [self getBuyerPredepositLogUserId:[fileContent objectAtIndex:3] andBeginCount:@"0" andSelectCount:@"10"  andToken:[fileContent objectAtIndex:1] andDepositType:@""];
            [DepositType setString:@""];
            
            
        }

//         hideView.hidden=YES;
//        rightlabel.text=@"转出";
//        rightButton.selected=NO;
//        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//        NSString *documentsPath = [docPath objectAtIndex:0];
//        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
//        NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:filePathDong];
//        NSLog(@"%@",fileContent );
//        [self getBuyerPredepositLogUserId:[fileContent objectAtIndex:3] andBeginCount:@"0" andSelectCount:@"10"  andToken:[fileContent objectAtIndex:1] andDepositType:@"0"];
//        [DepositType setString:@"0"];;
    }
}
#pragma mark -数据
-(void)getBuyerPredepositLogUserId:(NSString *)user_id andBeginCount:(NSString *)beginCount andSelectCount:(NSString *)selectCount andToken:(NSString *)token andDepositType:(NSString *)depositType{

    NSString *urlstr=[NSString stringWithFormat:@"%@%@?user_id=%@&beginCount=%@&selectCount=%@&token=%@&depositType=%@",FIRST_URL,PREDEPOSIT_URL,user_id,beginCount,selectCount,token,depositType];
    NSLog(@"%@",urlstr);
    NSURL *url=[NSURL URLWithString:urlstr];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    [request setRequestHeaders:[LJControl requestHeaderDictionary]];
    request.delegate=self;
    [request startAsynchronous];
}
#pragma mark- ASIHTTPRequestDelegate
-(void)requestFinished:(ASIHTTPRequest *)request{
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
        NSLog(@"%@",dic);
    if (dataArray.count>0) {
        [dataArray removeAllObjects];
    }
        NSArray *array=[dic objectForKey:@"data"];
        for (NSDictionary *dict in array) {
            AccountModel *model=[[AccountModel alloc]init];
            model.title=[NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]];
            model.time=[NSString stringWithFormat:@"%@",[dict objectForKey:@"time"]];
            model.money=[NSString stringWithFormat:@"%@",[dict objectForKey:@"amount"]];
            [dataArray addObject:model];
        
    }
    if (dataArray.count>0) {
        tableview.hidden=NO;
        NoDataView.hidden=YES;
        [tableview reloadData];
    }else{
        tableview.hidden=YES;
        NoDataView.hidden=NO;
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"请求错误");

}
#pragma mark- UITableViewDataSource & UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        NSLog(@"要删除啦~~~~~");
        [dataArray removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }else{
        
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myTabelviewCell = @"AccountCell";
    AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AccountCell" owner:self options:nil] lastObject];
    }
    AccountModel *model=[dataArray objectAtIndex:indexPath.row];
    cell.model=model;
    return cell;
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
