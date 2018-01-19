//
//  LifeGroupHomeViewController.h
//  My_App
//
//  Created by apple on 15-1-6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"


@interface LifeGroupHomeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ASIHTTPRequestDelegate>{
    
    UIView *view1;
    UIView *view2;
    
    UIView *viewTypeBG;
    UITableView *typeTableView;
    UIView *viewTypeBG3;
    UITableView *typeTableView2;
    UIView *viewTypeBG2;
    UITableView *areaTableView;
    UISegmentedControl *MsegmentControl;
    UIButton *btnType;
    UIButton *btnType2;
    
    UICollectionView *goodCollectionView;
    NSMutableArray *dataArr;
    NSMutableArray *dataArr2;
    NSMutableArray *dataArr3;
    NSMutableArray *dataArrShangla;
    NSMutableArray *dataArrShangla2;
    NSMutableArray *dataArr5;
    NSMutableArray *dataArr_life;
    NSMutableArray *dataArr_life_P;
    
    UICollectionView *lifeCollectionView;
    UIButton *btnArea;
    NSString *msg;//分类
    NSString *msc;//价格分类
    NSString *areafl;//地区分类
    
    UILabel *labelNOGoods;
    
    NSInteger ClassifySelectTag_goods;
    NSInteger PriceSelectTag_goods;
    NSInteger ClassifySelectTag_life;
    NSInteger PriceSelectTag_life;
    
    ASIFormDataRequest *request_1;
    ASIFormDataRequest *request_2;
    ASIFormDataRequest *request_3;
    ASIFormDataRequest *request_4;
    ASIFormDataRequest *request_5;
    ASIFormDataRequest *request_6;
    ASIFormDataRequest *request_7;
    ASIFormDataRequest *request_8;
    ASIFormDataRequest *request_9;
    ASIFormDataRequest *request_10;
    ASIFormDataRequest *request_11;
    ASIFormDataRequest *request_12;
    ASIFormDataRequest *request_13;
    ASIFormDataRequest *request_14;
    ASIFormDataRequest *request_15;
    ASIFormDataRequest *request_16;
    ASIFormDataRequest *request_17;
    ASIFormDataRequest *request_18;
    ASIFormDataRequest *request_19;
    ASIFormDataRequest *request_20;
}
@property (strong, nonatomic) NSString *gg_id;
@property (strong, nonatomic) NSArray *list;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSArray *type2;
@property (strong, nonatomic) UILabel *labelArea;
@property (strong, nonatomic) UILabel *labelArea2;

+(id)sharedUserDefault;

@end
