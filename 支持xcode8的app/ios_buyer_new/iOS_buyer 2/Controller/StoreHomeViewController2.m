//
//  StoreHomeViewController2.m
//  My_App
//
//  Created by barney on 15/11/3.
//  Copyright © 2015年 barney. All rights reserved.
//
#import "StoreHomeViewController2.h"
#import "AFNetworkTool.h"
#import "ThirdViewController.h"
#import "StoreHomeInfoModel.h"
#import "StoreHomeTopModel.h"
#import "MyGoodsCell.h"
#import "MyUtil.h"
#import "UIImageView+WebCache.h"
#import "FastRegisterViewController.h"
#import "ChatViewController.h"
#import "MJRefresh.h"
#import "SecondViewController.h"
#import "DetailViewController.h"

static NSString *kcellIdentifier = @"collectionCellID";
static NSString *kheaderIdentifier = @"headerIdentifier";
static NSString *kfooterIdentifier = @"footerIdentifier";

@interface StoreHomeViewController2 ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>
{
@private UICollectionView * goodsStoreHomeView;//collectionView
@private int goodsCellWidth;//每个小cell的宽度
@private NSMutableArray * headerTitleArray;//顶部xib写的控件的数据源
@private NSMutableArray * bigDataArray;//cell的大数据源
@private UIView * btnView;//8个按钮的view
@private UIButton * storeHome;// 8个按钮
@private UIButton * storeHomeBig;
@private UIButton * storeAll;
@private UIButton * storeAllBig;
@private UIButton * storeNew;
@private UIButton * storeNewBig;
@private UIButton * storeContact;
@private UIButton * storeContactBig;
@private UIView * redLittleView;// 动画滑动的小红线
@private int myWidth;// 四分之一屏幕宽度
@private int myHeightToTop;// 小红线距离父亲视图的高度
@private int bigBtnHeight;// 44
@private int oldSetY;// 记录滚动视图的位置 y
@private UIView * smallBtnView; // 全部商品里 分类搜索小按钮的父视图
@private UIButton * btnPorpular; // 父亲视图里面的按钮
@private UIButton * btnVolume;
@private UIButton * btnPrice;
@private UIButton * btnAddNew;
@private NSString *goodsOrderType;// 排序方式
@private NSString *beginCount;// 数据开始位置
@protected BOOL shouldHeaderGray; // 是否让collectionViewHeader变灰
@private BOOL favouiteBool;
    
}
@end

@implementation StoreHomeViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    bigDataArray=[NSMutableArray array];
    headerTitleArray=[NSMutableArray array];
    [self createCollectionView];
    [self createBtnView];
    [self netWorkHomePage];
}
// 创建collectionview
-(void) createCollectionView
{
    shouldHeaderGray=NO;
    self.title=@"店铺首页";
    [self createBackBtn];
    // 纯代码自定义layout
    UICollectionViewFlowLayout * layout=[[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset=UIEdgeInsetsMake(5, 5, 5, 5);
    goodsCellWidth=ScreenFrame.size.width/2-7.5;
    layout.itemSize=CGSizeMake(goodsCellWidth, goodsCellWidth-10+15+21+10+21+10);
    layout.minimumInteritemSpacing=5;
    layout.minimumLineSpacing=5;
    // collectionView声明
    goodsStoreHomeView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 141, ScreenFrame.size.width, ScreenFrame.size.height-141) collectionViewLayout:layout];
    goodsStoreHomeView.backgroundColor=[UIColor whiteColor];
    goodsStoreHomeView.delegate=self;
    goodsStoreHomeView.dataSource=self;
    // 通过Nib生成cell
    [goodsStoreHomeView registerNib:[UINib nibWithNibName:@"MyGoodsCell" bundle:nil] forCellWithReuseIdentifier:kcellIdentifier];
    // 注册headerView Nib的view需要继承UICollectionReusableView
    [goodsStoreHomeView registerNib:[UINib nibWithNibName:@"MyGoodsHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifier];
    [self.view addSubview:goodsStoreHomeView];
}
//重写返回按钮
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

// 代码创建所有的按钮
-(void) createBtnView
{
    myWidth=ScreenFrame.size.width/4;
    myHeightToTop=64;
    bigBtnHeight=44;
    // 创建八个按钮和滑动线条的的view
    btnView=[[UIView alloc] initWithFrame:CGRectMake(0, 76, ScreenFrame.size.width, 65)];
    btnView.backgroundColor=[UIColor whiteColor];
    CALayer * mylayer = [btnView layer];
    mylayer.borderColor = [UIColorFromRGB(0XDCDCDC) CGColor];
    mylayer.borderWidth = 0.5f;
    // 下滑小红线
    redLittleView=[[UIView alloc] initWithFrame:CGRectMake(0, myHeightToTop, myWidth, 1)];
    redLittleView.backgroundColor=[UIColor redColor];
    [btnView addSubview:redLittleView];
    // 4个小的文字图片btn
    storeHome=[MyUtil createBtnFrame:CGRectMake(15, bigBtnHeight,myWidth-30 , 20) title:nil image:@"storeHome" highlighImage:nil selectImage:nil target:self action:@selector(btnClickAction:)];
    storeHome.tag=101;
    [btnView addSubview:storeHome];
    storeAll=[MyUtil createBtnFrame:CGRectMake(15+myWidth, bigBtnHeight,myWidth-30 , 20) title:nil image:@"storeAllNM" highlighImage:nil selectImage:nil target:self action:@selector(btnClickAction:)];
    storeAll.tag=102;
    [btnView addSubview:storeAll];
    storeNew=[MyUtil createBtnFrame:CGRectMake(15+myWidth*2, bigBtnHeight,myWidth-30 , 20) title:nil image:@"storeNewNM" highlighImage:nil selectImage:nil target:self action:@selector(btnClickAction:)];
    storeNew.tag=103;
    [btnView addSubview:storeNew];
    storeContact=[MyUtil createBtnFrame:CGRectMake(15+myWidth*3, bigBtnHeight,myWidth-30 , 20) title:nil image:@"storeContactNM" highlighImage:nil selectImage:nil target:self action:@selector(btnClickAction:)];
    storeContact.tag=104;
    [btnView addSubview:storeContact];
    // 4个大的图片btn
    CGFloat W=93;
    CGFloat bW=(myWidth-93)/2;
    storeHomeBig=[MyUtil createBtnFrame:CGRectMake(0+bW, 0, W, bigBtnHeight) title:nil image:@"storeHomeBig" highlighImage:nil selectImage:nil target:self action:@selector(btnClickAction:)];
    storeHomeBig.tag=101;
    [btnView addSubview:storeHomeBig];
    storeAllBig=[MyUtil createBtnFrame:CGRectMake(myWidth+bW, 0, W, bigBtnHeight) title:nil image:@"storeAllBigNM" highlighImage:nil selectImage:nil target:self action:@selector(btnClickAction:)];
    storeAllBig.tag=102;
    [btnView addSubview:storeAllBig];
    storeNewBig=[MyUtil createBtnFrame:CGRectMake(myWidth*2+bW, 0, W, bigBtnHeight) title:nil image:@"storeNewBigNM" highlighImage:nil selectImage:nil target:self action:@selector(btnClickAction:)];
    storeNewBig.tag=103;
    [btnView addSubview:storeNewBig];
    storeContactBig=[MyUtil createBtnFrame:CGRectMake(myWidth*3+bW, 0, W, bigBtnHeight) title:nil image:@"storeContactBigNM" highlighImage:nil selectImage:nil target:self action:@selector(btnClickAction:)];
    storeContactBig.tag=104;
    [btnView addSubview:storeContactBig];
    [self.view addSubview:btnView];
    // 全部宝贝里按钮的view
    smallBtnView=[[UIView alloc] initWithFrame:CGRectMake(0, 141, ScreenFrame.size.width, 40)];
    smallBtnView.backgroundColor=[UIColor whiteColor];
    CALayer * layer = [smallBtnView layer];
    layer.borderColor = [UIColorFromRGB(0XDCDCDC) CGColor];
    layer.borderWidth = 0.5f;
    // 全部宝贝里面的4个按钮
    btnPorpular=[MyUtil createBtnFrame:CGRectMake(0, 0, myWidth, 40) title:@"人气" image:nil highlighImage:nil selectImage:nil target:self action:@selector(smallBtnClickAction:)];
    btnPorpular.tag=105;
    [btnPorpular.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [smallBtnView addSubview:btnPorpular];
    btnVolume=[MyUtil createBtnFrame:CGRectMake(myWidth, 0, myWidth, 40) title:@"销量" image:nil highlighImage:nil selectImage:nil target:self action:@selector(smallBtnClickAction:)];
    btnVolume.tag=106;
    [btnVolume.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [smallBtnView addSubview:btnVolume];
    btnPrice=[MyUtil createBtnFrame:CGRectMake(myWidth*2, 0, myWidth, 40) title:@"价格" image:nil highlighImage:nil selectImage:nil target:self action:@selector(smallBtnClickAction:)];
    btnPrice.tag=107;
    [btnPrice.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [smallBtnView addSubview:btnPrice];
    btnAddNew=[MyUtil createBtnFrame:CGRectMake(myWidth*3, 0, myWidth, 40) title:@"新品" image:nil highlighImage:nil selectImage:nil target:self action:@selector(smallBtnClickAction:)];
    btnAddNew.tag=108;
    [btnAddNew.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [smallBtnView addSubview:btnAddNew];
    [self.view addSubview:smallBtnView];
    smallBtnView.hidden=YES;
}
// 全部宝贝里面的分类方式按钮
-(void) smallBtnClickAction:(UIButton *) btn
{
    // 清空让上拉刷新计数器
    beginCount=nil;
    [self cleanDataAndReloadView];
    NSDictionary * dict=[NSDictionary dictionary];
    ThirdViewController * th=[ThirdViewController sharedUserDefault];
    // 非点击变黑
    [self setAllGoodsSmallBtnGray];
    // 人气
    if(btn.tag==105)
    {
        goodsOrderType=@"goods_click";
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        dict=[MyUtil createPostData:0 :10 :goodsOrderType :@"" :th.store_id];
        [self netWorkAllGoods:dict];
    }
    // 销量
    if(btn.tag==106)
    {
        goodsOrderType=@"goods_salenum";
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        dict=[MyUtil createPostData:0 :10 :goodsOrderType :@"" :th.store_id];
        [self netWorkAllGoods:dict];
    }
    // 价格
    if(btn.tag==107)
    {
        goodsOrderType=@"goods_current_price";
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        dict=[MyUtil createPostData:0 :10 :goodsOrderType :@"" :th.store_id];
        [self netWorkAllGoods:dict];
    }
    // 新品
    if(btn.tag==108)
    {
        goodsOrderType=@"goods_seller_time";
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        dict=[MyUtil createPostData:0 :10 :goodsOrderType :@"" :th.store_id];
        [self netWorkAllGoods:dict];
    }
}
-(void) setAllGoodsSmallBtnGray
{
    [btnPorpular setTitleColor:[UIColor colorWithWhite:0.3 alpha:0.9] forState:UIControlStateNormal];
    [btnVolume setTitleColor:[UIColor colorWithWhite:0.3 alpha:0.9] forState:UIControlStateNormal];
    [btnPrice setTitleColor:[UIColor colorWithWhite:0.3 alpha:0.9] forState:UIControlStateNormal];
    [btnAddNew setTitleColor:[UIColor colorWithWhite:0.3 alpha:0.9] forState:UIControlStateNormal];
}
-(void) cleanDataAndReloadView
{
    [bigDataArray removeAllObjects];
    [headerTitleArray removeAllObjects];
    [goodsStoreHomeView reloadData];
}
- (IBAction)collectClick:(id)sender {
    [self netWorkCollect];
}
// 按钮点击事件
- (void)btnClickAction:(UIButton *)btn {
    if (btn.tag==104) {
        ChatViewController *chat = [[ChatViewController alloc]init];
        [self.navigationController pushViewController:chat animated:YES];
    }else{
        goodsStoreHomeView.backgroundColor=UIColorFromRGB(0XF5F5F5);
        [goodsStoreHomeView setFooterHidden:YES];
        [self cleanDataAndReloadView];
        smallBtnView.hidden=YES;
        shouldHeaderGray=YES;
        [self setBtnGray];
        [self setAllGoodsSmallBtnGray];
        double animationDuration=0.2;
        if(btn.tag==101)
        {
            shouldHeaderGray=NO;
            goodsStoreHomeView.backgroundColor=[UIColor whiteColor];
            [storeHome setBackgroundImage:[UIImage imageNamed:@"storeHome"] forState:UIControlStateNormal];
            [storeHomeBig setBackgroundImage:[UIImage imageNamed:@"storeHomeBig"] forState:UIControlStateNormal];
            [self netWorkHomePage];
            [UIView animateWithDuration:animationDuration animations:^{
                redLittleView.frame=CGRectMake(0, myHeightToTop, myWidth, 1);
            }];
        }
        if(btn.tag==102)
        {
            [goodsStoreHomeView setFooterHidden:NO];
            goodsOrderType=@"goods_click";
            smallBtnView.hidden=NO;
            [storeAll setBackgroundImage:[UIImage imageNamed:@"storeAll"] forState:UIControlStateNormal];
            [storeAllBig setBackgroundImage:[UIImage imageNamed:@"storeAllBig"] forState:UIControlStateNormal];
            [btnPorpular setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            ThirdViewController *th = [ThirdViewController sharedUserDefault];
            NSDictionary * dict=[MyUtil createPostData:0 :10 :goodsOrderType :@"" :th.store_id];
            [self netWorkAllGoods:dict];
            [UIView animateWithDuration:animationDuration animations:^{
                redLittleView.frame=CGRectMake(myWidth, myHeightToTop, myWidth, 1);
            }];
            // 加入下拉刷新footerView
            [goodsStoreHomeView addFooterWithTarget:self action:@selector(footerRefreshAction)];
        }
        if(btn.tag==103)
        {
            [storeNew setBackgroundImage:[UIImage imageNamed:@"storeNew"] forState:UIControlStateNormal];
            [storeNewBig setBackgroundImage:[UIImage imageNamed:@"storeNewBig"] forState:UIControlStateNormal];
            [self netWorkAddNew];
            [UIView animateWithDuration:animationDuration animations:^{
                redLittleView.frame=CGRectMake(myWidth*2, myHeightToTop, myWidth, 1);
            }];
        }

    }
//    if(btn.tag==104)
//    {
////        [storeContact setBackgroundImage:[UIImage imageNamed:@"storeContact"] forState:UIControlStateNormal];
////        [storeContactBig setBackgroundImage:[UIImage imageNamed:@"storeContactBig"] forState:UIControlStateNormal];
////        [UIView animateWithDuration:animationDuration animations:^{
////            redLittleView.frame=CGRectMake(myWidth*3, myHeightToTop, myWidth, 1);
////        }];
////        // 跳转到客服联系界面
//////        ThirdViewController * th=[ThirdViewController sharedUserDefault];
//////        SecondViewController * sec=[SecondViewController sharedUserDefault];
//        ChatViewController *chat = [[ChatViewController alloc]init];
////        sec.detail_id=th.store_id;
//        [self.navigationController pushViewController:chat animated:YES];
//    }
}
-(void) setBtnGray
{
    [storeHome setBackgroundImage:[UIImage imageNamed:@"storeHomeNM"] forState:UIControlStateNormal];
    [storeHomeBig setBackgroundImage:[UIImage imageNamed:@"storeHomeBigNM"] forState:UIControlStateNormal];
    [storeAll setBackgroundImage:[UIImage imageNamed:@"storeAllNM"] forState:UIControlStateNormal];
    [storeAllBig setBackgroundImage:[UIImage imageNamed:@"storeAllBigNM"] forState:UIControlStateNormal];
    [storeNew setBackgroundImage:[UIImage imageNamed:@"storeNewNM"] forState:UIControlStateNormal];
    [storeNewBig setBackgroundImage:[UIImage imageNamed:@"storeNewBigNM"] forState:UIControlStateNormal];
    [storeContact setBackgroundImage:[UIImage imageNamed:@"storeContactNM"] forState:UIControlStateNormal];
    [storeContactBig setBackgroundImage:[UIImage imageNamed:@"storeContactBigNM"] forState:UIControlStateNormal];
}
#pragma mark -netWorks
// 收藏点击事件
-(void) netWorkCollect
{
//    [self.collectBtn setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    NSString *storeCollectUrl =[NSString stringWithFormat:@"%@%@",FIRST_URL,STORE_COLLECT_URL];
    // 获取本地文件
    NSArray *fileContent=[MyUtil returnLocalUserFile];
    // 没有用户id的未登录判断
    if(fileContent[3]==nil)
    {
        [OHAlertView showAlertWithTitle:nil message:@"您还没有登陆，请登录后再收藏" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            self.tabBarController.selectedIndex = 4;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }else{
       
        
        [SYObject startLoadingInSuperview:self.view];
        [AFNetworkTool postJSONWithUrl:storeCollectUrl parameters:@{@"store_id":th.store_id,@"user_id":fileContent[3],@"token":fileContent[1]} success:^(id responseObject) {
            [SYObject endLoading];
           
            NSDictionary *dicBig=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            NSLog(@"收藏结果。。。。%@",dicBig);
            
            NSString *result =[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"code"]];
            if([result isEqualToString:@"1"]){
                [SYObject failedPrompt:@"操作失败"];
            }else if ([result isEqualToString:@"0"]){
                if (favouiteBool==NO) {
                   [SYObject failedPrompt:@"收藏成功"];
                    [self.collectBtn setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
                    favouiteBool=YES;
                   
                }else
                {
                    [SYObject failedPrompt:@"取消收藏成功"];
                    [self.collectBtn setImage:[UIImage imageNamed:@"sellect.png"] forState:UIControlStateNormal];
                    favouiteBool=NO;
                
                }
                
            }
        } fail:^{
            [SYObject endLoading];
            [SYObject failedPrompt:@"网络请求失败"];
        }];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.tabBarController.selectedIndex = 4;
    [self.navigationController popToRootViewControllerAnimated:YES];
    return;
}
// 全部商品按钮事件
-(void) netWorkAllGoods:(NSDictionary *) dict
{
    NSString *storeAllGoodsUrl =[NSString stringWithFormat:@"%@%@",FIRST_URL,STORE_ALLGOODS_URL];
    [SYObject startLoadingInSuperview:self.view];
    [AFNetworkTool postJSONWithUrl:storeAllGoodsUrl parameters:dict success:^(id responseObject) {
        [SYObject endLoading];
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSMutableArray * arrayM=[[NSMutableArray alloc] init];
        for(NSDictionary * miniDict in resultDic[@"goods_list"])
        {
            NSLog(@"%@",[miniDict objectForKey:@"id"]);
            StoreHomeInfoModel * model=[[ StoreHomeInfoModel alloc] init];
            [model setValuesForKeysWithDictionary:miniDict];
            [arrayM addObject:model];
        }
        if (arrayM.count>0) {
            [bigDataArray addObject:arrayM];
            [headerTitleArray addObject:@""];
        }
        if(bigDataArray.count>0)
        {
            [goodsStoreHomeView reloadData];
            [goodsStoreHomeView footerEndRefreshing];
        }
    } fail:^{
        [SYObject endLoading];
        NSLog(@"failed");
    }];
}
// 店铺首页按钮事件
-(void) netWorkHomePage
{
    [SYObject startLoadingInSuperview:self.view];
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    NSString *storeGoodsInfoUrl =[NSString stringWithFormat:@"%@%@",FIRST_URL,STORE_INFO_URL];
    [AFNetworkTool postJSONWithUrl:storeGoodsInfoUrl parameters:@{@"store_id":th.store_id} success:^(id responseObject) {
        [SYObject endLoading];
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"店铺首页按钮事件%@",resultDic);
        NSArray * subArray=resultDic[@"goods_data"];
        for(NSDictionary* dict in subArray)
        {
            NSMutableArray * arrayM=[[NSMutableArray alloc] init];
            for(NSDictionary *  miniDict in dict[@"data"])
            {
                StoreHomeInfoModel * model=[[ StoreHomeInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:miniDict];
                [arrayM addObject:model];
            }
            [bigDataArray addObject:arrayM];
            [headerTitleArray addObject:dict[@"name"]];
        }
        if(bigDataArray.count>0)
        {
            [goodsStoreHomeView reloadData];
        }
    } fail:^{
        [SYObject endLoading];
        NSLog(@"failed");
    }];
//    BOOL login;
//    [SYObject hasUserLogedIn:&login];
//    NSDictionary *par = nil;
//    if (login) {
    NSArray *fileContent=[MyUtil returnLocalUserFile];
    NSDictionary* par = nil;
    if(fileContent[3]==nil)
    {
        par = @{
                @"store_id":th.store_id
                };
    }else {
        par = @{
                @"store_id":th.store_id,
                @"user_id":[SYObject currentUserID],
                @"token":[SYObject currentToken]
                };
    }
    
    // 需要单独请求店铺名称 图片和粉丝数
    NSString *storeTopPrivateUrl =[NSString stringWithFormat:@"%@%@",FIRST_URL,STORE_PRIVATE_URL];
    [AFNetworkTool postJSONWithUrl:storeTopPrivateUrl parameters:par success:^(id responseObject) {
        [SYObject endLoading];
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"店铺有用信息、、、、%@",resultDic);
        if ([resultDic isKindOfClass:[NSDictionary class]]) {
            StoreHomeTopModel * model=[[StoreHomeTopModel alloc] init];
            [model setValuesForKeysWithDictionary:resultDic];
            self.storeName.text=model.store_name;
            self.storeEvalueLable.text=[NSString stringWithFormat:@"综合评分：%@.0分",model.fans_count];
            if (model.favourited.integerValue==0) {
                
                favouiteBool=NO;
                 [self.collectBtn setImage:[UIImage imageNamed:@"sellect.png"] forState:UIControlStateNormal];
                
            }else
            {
                favouiteBool=YES;
                [self.collectBtn setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
            }
            [self.storeHomeTopPage sd_setImageWithURL:[NSURL URLWithString:model.store_logo]];
        }
    } fail:^{
        [SYObject endLoading];
        NSLog(@"failed");
    }];
}
// 商品上新按钮事件
-(void) netWorkAddNew
{
    [SYObject startLoadingInSuperview:self.view];
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    NSString *storeAddNewUrl =[NSString stringWithFormat:@"%@%@",FIRST_URL,STORE_ADDNEW_URL];
    // 不确定上传条数
    [AFNetworkTool postJSONWithUrl:storeAddNewUrl parameters:@{@"store_id":th.store_id} success:^(id responseObject) {
        [SYObject endLoading];
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSArray * subArray=resultDic[@"data"];
        for(NSDictionary* dict in subArray)
        {
            NSMutableArray * arrayM=[[NSMutableArray alloc] init];
            for(NSDictionary *  miniDict in dict[@"goods_data"])
            {
                StoreHomeInfoModel * model=[[ StoreHomeInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:miniDict];
                [arrayM addObject:model];
            }
            [bigDataArray addObject:arrayM];
            [headerTitleArray addObject:dict[@"date_data"]];
        }
        if(bigDataArray.count>0)
        {
            [goodsStoreHomeView reloadData];
        }
    } fail:^{
        [SYObject endLoading];
        NSLog(@"fail");
    }];
}
#pragma mark -footerRefresh
-(void) footerRefreshAction
{
    NSInteger num=[beginCount intValue];
    num=num+10;
    beginCount=[NSString stringWithFormat:@"%ld",(long)num];
    NSLog(@"beginCount=%@",beginCount);
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    NSDictionary * dict=[MyUtil createPostData:num :10 :goodsOrderType :@"" :th.store_id];
    [self netWorkAllGoods:dict];
}
#pragma mark -CollectionView datasource
-(NSInteger )numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return bigDataArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // 不知原因的【something count】 会报错
    NSArray *dataArray=[bigDataArray objectAtIndex:section];
    return dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
    StoreHomeInfoModel * model=[[bigDataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell config:model];
    cell.backgroundColor = [UIColor whiteColor];
    cell.goodsView.frame=CGRectMake(0, 0, goodsCellWidth, goodsCellWidth);
    cell.goodsNameLable.frame=CGRectMake(5, goodsCellWidth-10+15, goodsCellWidth-5, 42);
    cell.goodsNameLable.numberOfLines=2;
    [cell.goodsNameLable setFont:[UIFont systemFontOfSize:12]];
    cell.gooodsPriceLable.frame=CGRectMake(0, goodsCellWidth-10+15+21+15, goodsCellWidth, 21);
    // 添加边框
    CALayer * layer = [cell layer];
    layer.borderColor = [UIColorFromRGB(0XDCDCDC) CGColor];
    layer.borderWidth = 0.5f;
    return cell;
}
// 设置collectionView 的headerView 和footerView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier;
    if ([kind isEqualToString: UICollectionElementKindSectionFooter ]){
        reuseIdentifier = kfooterIdentifier;
    }else{
        reuseIdentifier = kheaderIdentifier;
    }
    UICollectionReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
    UILabel *label = (UILabel *)[view viewWithTag:1];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        label.text = [NSString stringWithFormat:@"  %@",headerTitleArray[indexPath.section]];
        label.textAlignment=UITextLayoutDirectionLeft;
        label.font=[UIFont systemFontOfSize:17];
        label.textColor=UIColorFromRGB(0X000000);
        if(shouldHeaderGray)
        {
            view.backgroundColor=UIColorFromRGB(0XF5F5F5);
        }
        else
        {
            view.backgroundColor=[UIColor whiteColor];
        }
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
    }
    return view;
}
#pragma mark -UICollectionViewDelegateFlowLayout 代理
//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if(smallBtnView.hidden==YES){
        CGSize size={ScreenFrame.size.width,40};
        return size;
    }else{
        CGSize size={ScreenFrame.size.width,40};
        return size;
    }
}
// 跳转到详情页面
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    StoreHomeInfoModel * model=[[bigDataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    SecondViewController * sec=[[SecondViewController alloc] init];
    sec.detail_id=model.id;
    DetailViewController * detail=[[DetailViewController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark -UIscrollView
-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    oldSetY=scrollView.contentOffset.y;
}
// 控制位置实现动画
-(void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    // 把xib页面发送到底部，否则会遮挡
    [self.view sendSubviewToBack:self.storeTopView];
    // 向上滑动,隐藏
    if(scrollView.contentOffset.y>oldSetY)
    {
        [UIView animateWithDuration:0.4 animations:^{
            goodsStoreHomeView.frame=CGRectMake(0, 31, ScreenFrame.size.width, ScreenFrame.size.height-31);
            btnView.frame=CGRectMake(0, -34, ScreenFrame.size.width, 65);
            storeHomeBig.frame=CGRectMake(myWidth/2, 22, 0, 0);
            storeAllBig.frame=CGRectMake(myWidth/2+myWidth, 22, 0, 0);
            storeNewBig.frame=CGRectMake(myWidth/2+myWidth*2, 22, 0, 0);
            storeContactBig.frame=CGRectMake(myWidth/2+myWidth*3, 22, 0, 0);
            storeHome.frame=CGRectMake(0, 34,myWidth , 30);
            storeAll.frame=CGRectMake(myWidth, 34,myWidth , 30);
            storeNew.frame=CGRectMake(myWidth*2, 34,myWidth , 30);
            storeContact.frame=CGRectMake(myWidth*3, 34,myWidth , 30);
            smallBtnView.frame=CGRectMake(0, 31, ScreenFrame.size.width, 40);
        }];
    }
    // 恢复原来的位置
    else
    {
        if(scrollView.contentOffset.y<5)
        {
            [UIView animateWithDuration:0.4 animations:^{
                goodsStoreHomeView.frame=CGRectMake(0, 141, ScreenFrame.size.width, ScreenFrame.size.height-141);
                btnView.frame=CGRectMake(0, 76, ScreenFrame.size.width, 65);
                storeHomeBig.frame=CGRectMake(0, 0, myWidth, bigBtnHeight);
                storeAllBig.frame=CGRectMake(myWidth, 0, myWidth, bigBtnHeight);
                storeNewBig.frame=CGRectMake(myWidth*2, 0, myWidth, bigBtnHeight);
                storeContactBig.frame=CGRectMake(myWidth*3, 0, myWidth, bigBtnHeight);
                storeHome.frame=CGRectMake(15, bigBtnHeight,myWidth-30 , 20);
                storeAll.frame=CGRectMake(15+myWidth, bigBtnHeight,myWidth-30 , 20);
                storeNew.frame=CGRectMake(15+myWidth*2, bigBtnHeight,myWidth-30 , 20);
                storeContact.frame=CGRectMake(15+myWidth*3, bigBtnHeight,myWidth-30 , 20);
                smallBtnView.frame=CGRectMake(0, 141, ScreenFrame.size.width, 40);
            }];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
