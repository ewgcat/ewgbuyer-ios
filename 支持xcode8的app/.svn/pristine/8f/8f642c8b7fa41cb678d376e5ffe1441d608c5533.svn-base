//
//  getActivityGoodsViewController.m
//  My_App
//
//  Created by apple on 15/10/20.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "getActivityGoodsViewController.h"
#import "getAllActivityNavViewController.h"
#import "ActivityGoodsCollectionViewCell.h"
#import "SecondViewController.h"
#import "DetailViewController.h"

@interface getActivityGoodsViewController (){
    ClassifyModel *classifyModel;
    ASIFormDataRequest *RequestSave;
    ASIFormDataRequest *RequestUp;
}

@end

@implementation getActivityGoodsViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [RequestSave clearDelegatesAndCancel];
    [RequestUp clearDelegatesAndCancel];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    

    getAllActivityNavViewController *all = [getAllActivityNavViewController sharedUserDefault];
    classifyModel = all.classifyModel;
    self.title = classifyModel.coupon_name;
    [self createBackBtn];
    dataArray = [[NSMutableArray alloc]init];
    dataArrayUp = [[NSMutableArray alloc]init];
    topData = [[NSMutableArray alloc]init];
    
    pageNum = @"2";
 
    
    //collectionview设置代理
    MyCollectionView.backgroundColor = RGB_COLOR(242, 242, 242);
    [MyCollectionView registerClass:[ActivityGoodsCollectionViewCell class] forCellWithReuseIdentifier:@"ActivityGoodsCollectionViewCell"];
    MyCollectionView.delegate = self;
    MyCollectionView.dataSource = self;
    [MyCollectionView addFooterWithTarget:self action:@selector(addFooter)];
    [MyCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"getActivityGoodsCollectionReusableView"];
    //请求
    [self netWorking];
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
- (void)addFooter
{
    [self netWorkingUp:pageNum];
}
#pragma mark - 网络
-(void)netWorking{
//    LoadingView.hidden = NO;
    [SYObject startLoading];
    
    NSArray *keyArr =nil;
    NSArray *valueArr =nil;
    if ([SYObject currentUserID]) {//如果登录了
        
        keyArr= [[NSArray alloc]initWithObjects:@"actId",@"pageNum",@"user_id",@"token", nil];
        valueArr=[[NSArray alloc]initWithObjects:classifyModel.goods_id,@"1",[SYObject currentUserID],[SYObject currentToken], nil];
    }else{
        keyArr= [[NSArray alloc]initWithObjects:@"actId",@"pageNum", nil];
         valueArr=[[NSArray alloc]initWithObjects:classifyModel.goods_id,@"1", nil];
    }
    
   
    
   
    RequestSave = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,GETACTIVITYGOODS_URL] setKey:keyArr setValue:valueArr];
    RequestSave.delegate = self;
    [RequestSave setDidFailSelector:@selector(RequestFailed:)];
    [RequestSave setDidFinishSelector:@selector(GetuserMsgSucceeded:)];
    [RequestSave startAsynchronous];
}
-(void)netWorkingUp:(NSString *)pageNum_net{
    
    NSArray *keyArr =nil;
    NSArray *valueArr =nil;
    if ([SYObject currentUserID]) {//如果登录了
        
        keyArr= [[NSArray alloc]initWithObjects:@"actId",@"pageNum",@"user_id",@"token", nil];
        valueArr=[[NSArray alloc]initWithObjects:classifyModel.goods_id,@"1",[SYObject currentUserID],[SYObject currentToken], nil];
    }else{
        keyArr= [[NSArray alloc]initWithObjects:@"actId",@"pageNum", nil];
        valueArr = [[NSArray alloc]initWithObjects:classifyModel.goods_id,pageNum_net, nil];
    }

    RequestUp = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,GETACTIVITYGOODS_URL] setKey:keyArr setValue:valueArr];
    RequestUp.delegate = self;
    [RequestUp setDidFailSelector:@selector(RequestFailed:)];
    [RequestUp setDidFinishSelector:@selector(UpSucceeded:)];
    [RequestUp startAsynchronous];
}
-(void)UpSucceeded:(ASIFormDataRequest *)request{
    if ([request  responseStatusCode] == 200){
        [dataArrayUp removeAllObjects];
        if([[consultViewNetwork dataActivityGoodsData:request] count] != 0){
            dataArrayUp = [[consultViewNetwork dataActivityGoodsData:request] objectAtIndex:1];
        }
        
        [dataArray addObjectsFromArray:dataArrayUp];
        
//        [dataArray sortUsingComparator:^NSComparisonResult(ClassifyModel * obj1, ClassifyModel * obj2) {
//            
//            NSNumber *a=[NSNumber numberWithFloat:obj1.goods_current_price.floatValue];
//            NSNumber *b=[NSNumber numberWithFloat:obj2.goods_current_price.floatValue];
//            NSComparisonResult result = [a compare:b];
//            if (result == NSOrderedSame) {
//                result =[a compare:b];
//            }
//            return result;
//        }];

        
        
        [MyCollectionView reloadData];
        pageNum = [NSString stringWithFormat:@"%d",[pageNum intValue]+1];
    }else{
        [self failedPrompt:@"请求出错，请重试"];
    }
//    LoadingView.hidden = YES;
    [SYObject endLoading];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MyCollectionView reloadData];
        // 结束刷新
        [MyCollectionView footerEndRefreshing];
    });
}
-(void)GetuserMsgSucceeded:(ASIFormDataRequest *)request{
    if ([request  responseStatusCode] == 200){
        [dataArray removeAllObjects];
        [topData removeAllObjects];
        if([[consultViewNetwork dataActivityGoodsData:request] count] != 0){
            dataArray = [[consultViewNetwork dataActivityGoodsData:request] objectAtIndex:1];
            NSDictionary *dic = [[consultViewNetwork dataActivityGoodsData:request] objectAtIndex:0];
            
            [topData addObject:[NSString stringWithFormat:@"活动时间:%@至%@",[dic objectForKey:@"beginTime"],[dic objectForKey:@"endTime"]]];
            [topData addObject:[NSURL URLWithString:[[[consultViewNetwork dataActivityGoodsData:request] objectAtIndex:0] objectForKey:@"activity_image"]]];
        }
        if (dataArray.count == 0) {
            MyCollectionView.hidden = YES;
        }else{
//            [dataArray sortUsingComparator:^NSComparisonResult(ClassifyModel * obj1, ClassifyModel * obj2) {
//                
//                NSNumber *a=[NSNumber numberWithFloat:obj1.goods_current_price.floatValue];
//                NSNumber *b=[NSNumber numberWithFloat:obj2.goods_current_price.floatValue];
//                NSComparisonResult result = [a compare:b];
//                if (result == NSOrderedSame) {
//                    result =[a compare:b];
//                }
//                return result;
//            }];
            NSLog(@"dataArraydataArray=%@",dataArray);
            MyCollectionView.hidden = NO;
        }
        [MyCollectionView reloadData];
    }else{
        [self failedPrompt:@"请求出错，请重试"];
    }
//    LoadingView.hidden = YES;
    [SYObject endLoading];
    
}
-(void)RequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(void)failedPrompt:(NSString *)prompt{
        [SYObject endLoading];
    [SYObject failedPrompt:prompt];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - collectionView delegate
//设置顶部的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={ScreenFrame.size.width,32*ScreenFrame.size.width/95+30};
//     CGSize size={ScreenFrame.size.width,32*ScreenFrame.size.width/95+25};
    return size;
}
- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"getActivityGoodsCollectionReusableView" forIndexPath:indexPath];
    UIView *BigView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 46)];
    BigView.backgroundColor = [UIColor whiteColor];
    UIImageView *imageTop = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 32*ScreenFrame.size.width/95)];
    [BigView addSubview:imageTop];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, imageTop.frame.origin.y+imageTop.frame.size.height, ScreenFrame.size.width, 35)];
    label.textColor=[UIColor lightGrayColor];
    label.font=[UIFont systemFontOfSize:14];
    [BigView addSubview:label];
    [reusableview addSubview:BigView];
    if(topData.count!=0){
        [imageTop sd_setImageWithURL:[topData objectAtIndex:1] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
        label.text = [topData objectAtIndex:0];
    }
    return reusableview;
}
//每个分区上的元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (dataArray.count!=0) {
        return dataArray.count;
    }
    return 0;
}
//设置元素内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"ActivityGoodsCollectionViewCell";
    ActivityGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityGoodsCollectionViewCell" owner:self options:nil] lastObject];
    }
    if (dataArray.count!=0) {
        ClassifyModel *class = [dataArray objectAtIndex:indexPath.row];
        [cell setData:class];
    }
    return cell;
}
//设置元素的的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
//    UIEdgeInsets top = {10,10,10,10};
    UIEdgeInsets top = {5,5,5,5};
    
    return top;
}
//设置元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return CGSizeMake(ScreenFrame.size.width/2-15,(ScreenFrame.size.width-50)/2+66);
    return CGSizeMake((ScreenFrame.size.width-15)/2,(ScreenFrame.size.width-50)/2+66);
}
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

//点击元素触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(dataArray.count!=0){
        ClassifyModel *class = [dataArray objectAtIndex:indexPath.row];
        SecondViewController *sec = [SecondViewController sharedUserDefault];
        sec.detail_id = class.goods_id;
        DetailViewController *detail = [[DetailViewController alloc]init];
        [self.navigationController pushViewController:detail animated:YES];
    }
}
@end
