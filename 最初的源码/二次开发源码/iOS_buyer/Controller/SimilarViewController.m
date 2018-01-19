//
//  SimilarViewController.m
//  
//
//  Created by apple on 15/10/20.
//
//

#import "SimilarViewController.h"
#import "SimilarTableViewCell.h"
#import "SecondViewController.h"
#import "DetailViewController.h"
#import "FirstViewController.h"

@interface SimilarViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    __weak IBOutlet UIView *noHaveView;
    __weak IBOutlet UIView *moveView;
    __weak IBOutlet UIView *hideVIew;
    NSMutableArray *dataArray;
    UITableView *tableview;


}
@end

@implementation SimilarViewController
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
    [self createNavigation];
    [self designPage];
    [self getLikeGoodsList:_model];
}
#pragma mark -界面
-(void)createNavigation{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    //导航栏
    UIView *bgView=[LJControl viewFrame:CGRectMake(0,0,ScreenFrame.size.width, 64) backgroundColor:MY_COLOR];
    [self.view addSubview:bgView];
    UILabel *titleLabel=[LJControl labelFrame:CGRectMake(ScreenFrame.size.width/2-50,22, 100, 40) setText:@"相似商品" setTitleFont:20 setbackgroundColor:[UIColor clearColor] setTextColor: [UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    [bgView addSubview:titleLabel];
    
    UIButton *backButton = [LJControl backBtn];
    backButton.frame=CGRectMake(15,30,15,23.5);
    backButton.tag=1000;
    [backButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:backButton];
    
    UIButton *buttonChat = [UIButton buttonWithType:UIButtonTypeCustom ];
    buttonChat.frame =CGRectMake(ScreenFrame.size.width-34, 30, 24, 24);
    [buttonChat setBackgroundImage:[UIImage imageNamed:@"point"] forState:UIControlStateNormal];
    buttonChat.tag=1001;
    [buttonChat addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:buttonChat];
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
    //无相似
    UIImageView *noDataImage=[LJControl imageViewFrame:CGRectMake(ScreenFrame.size.width/2-131,50, 263,263) setImage:@"seller_center_nothing.png" setbackgroundColor:[UIColor clearColor]];
    [noHaveView addSubview:noDataImage];
    noHaveView.hidden=YES;
    
    //tableview
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0,64, ScreenFrame.size.width,ScreenFrame.size.height-64) style:UITableViewStylePlain];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.hidden=YES;
    [self.view addSubview:tableview];
    //更多
    moveView.hidden=YES;
    hideVIew.layer.masksToBounds = YES;
    hideVIew.layer.cornerRadius = 6.0;
    NSArray *imgArray=@[@"tabbar1.png",@"tabbar2.png",@"tabbar3.png",@"tabbar4.png",@"tabbar5.png"];
    NSArray *namArray=@[@"首页",@"分类",@"购物车",@"品牌",@"个人中心"];
    for (int i=0; i<imgArray.count; i++) {
        UIButton *button=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(0, 42*i, 126,42) setNormalImage:nil setSelectedImage:nil setTitle:@"" setTitleFont:0 setbackgroundColor:[UIColor clearColor]];
        button.tag=1002+i;
        [button addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [hideVIew addSubview:button];
        UIImageView *image=[LJControl imageViewFrame:CGRectMake(10, 7, 25, 25) setImage:[imgArray objectAtIndex:i] setbackgroundColor:[UIColor clearColor]];
        [button addSubview:image];
        UILabel *label=[LJControl labelFrame:CGRectMake(35, 5, 86, 30) setText:[namArray objectAtIndex:i] setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
        [button addSubview:label];
        if (i!=imgArray.count-1) {
            UILabel *ll=[LJControl labelFrame:CGRectMake(0, 41, 126, 1) setText:@"" setTitleFont:0 setbackgroundColor:[UIColor whiteColor] setTextColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
            [button addSubview:ll];
        }
    }
    
}
-(void)backClick:(UIButton *)btn{
    NSLog(@"%ld",(long)btn.tag);
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    FirstViewController *first = [FirstViewController sharedUserDefault];

    if (btn.tag == 1002) {
        [first tabbarIndex:0];
    }else if (btn.tag == 1003) {
        [first tabbarIndex:1];
    }else if (btn.tag == 1004) {
        [first tabbarIndex:2];
    }else if (btn.tag == 1005) {
        [first tabbarIndex:3];
    }else if (btn.tag == 1006){
        [first tabbarIndex:4];
    }


}
-(void)buttonClicked:(UIButton *)btn{
    NSLog(@"%ld",(long)btn.tag);
    if (btn.tag==1000) {
        //返回
        [self.navigationController popViewControllerAnimated:YES];
    }else if (btn.tag==1001){
        //更多
        btn.selected=!btn.selected;
        if (btn.selected) {
            moveView.hidden=NO;
            [self.view bringSubviewToFront:moveView];
        }else{
            moveView.hidden=YES;
        }
    
    }
    
}
-(void)getLikeGoodsList:(Model *)model{
    [SYObject startLoading];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,MAYLIKE_URL]];
    ASIFormDataRequest * request=[ASIFormDataRequest requestWithURL:url];
    [request setPostValue:model.foot_goods_id forKey:@"id"];
    [request setRequestHeaders:[LJControl requestHeaderDictionary]];
    [request setDelegate:self];
    [request startAsynchronous];
}
#pragma mark- ASIHTTPRequestDelegate
-(void)requestFinished:(ASIHTTPRequest *)request{
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
    NSLog(@"%@",dic);
    dataArray=[[NSMutableArray alloc]init];
    for (NSDictionary *dict in [dic objectForKey:@"goods_list"]) {
        Model *model=[[Model alloc]init];
        model.goods_photo=[dict objectForKey:@"goods_main_photo"];
        model.goods_id=[dict objectForKey:@"id"];
        model.goods_name=[dict objectForKey:@"name"];
        [dataArray addObject:model];
    }
    if (dataArray.count==0) {
        noHaveView.hidden=NO;
        tableview.hidden=YES;
    }else{
        noHaveView.hidden=YES;
        tableview.hidden=NO;
        [tableview reloadData];
    }
    [SYObject endLoading];
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    [SYObject endLoading];
    [SYObject failedPrompt:@"请求出错，请查看网络环境"];
    
}

#pragma mark- UITableViewDataSource & UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myTabelviewCell = @"SimilarTableViewCell";
    SimilarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SimilarTableViewCell" owner:self options:nil] lastObject];
    }
    Model *model=[dataArray objectAtIndex:indexPath.row];
    cell.model=model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Model *model=[dataArray objectAtIndex:indexPath.row];
    SecondViewController *sec = [SecondViewController sharedUserDefault];
    sec.detail_id = model.goods_id;
    DetailViewController *dVC = [[DetailViewController alloc]init];
    [self.navigationController pushViewController:dVC animated:YES];
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
