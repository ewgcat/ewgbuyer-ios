//
//  BrandGoodListViewController.h
//  My_App
//
//  Created by apple on 15/6/29.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface BrandGoodListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>{
    NSMutableArray *dataArray;
    
    NSMutableArray *dataArrayShangla;
    
    BOOL shanglaBool;
    
    __weak IBOutlet UIImageView *priceImage;
    __weak IBOutlet UILabel *labelTi;
    __weak IBOutlet UIImageView *nothingView;
    __weak IBOutlet UILabel *nothingLabel;
    __weak IBOutlet UITableView *MyTableView;
    
    
    __weak IBOutlet UIButton *SalesBtn;
    __weak IBOutlet UIButton *PopularityBtn;
    __weak IBOutlet UIButton *NewGoodsBtn;
    __weak IBOutlet UIButton *PriceBtn;
    
    
    BOOL requestBool;
    
    UIImageView *imageNothing;//什么都没有图片
    NSString *select_attribute;//用来判断是哪个上啦刷新
    
    BOOL priceBool;
    
    
    BOOL btnClickedBool;
    
    BOOL muchBool;//更多视图bool值
    __weak IBOutlet UIView *muchView;
    __weak IBOutlet UIView *muchGray;
    
    __weak IBOutlet UIButton *fifthBtn;
    __weak IBOutlet UIButton *fouthBtn;
    __weak IBOutlet UIButton *thirdBtn;
    __weak IBOutlet UIButton *firstBtn;
    __weak IBOutlet UIButton *secondBtn;
    BOOL exchangeBool;
}
- (IBAction)segcontrolBtnClicked:(id)sender;

@property (strong, nonatomic)  UIImageView *redPrice;
@property (strong, nonatomic)  UIImageView *redSales;
@property (strong, nonatomic)  UIImageView *redPopularity;
@property (strong, nonatomic)  UIImageView *redTime;
@property (strong, nonatomic)  UIButton *timeBtn;

//@property (strong, nonatomic)  UIButton *priceBtn;
//@property (strong, nonatomic)  UIButton *sales;
//@property (strong, nonatomic)  UIButton *popularityBtn;

- (IBAction)tabbarBtnClicked:(id)sender;

@end
