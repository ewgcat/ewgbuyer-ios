//
//  StoreAllGoodsViewController.h
//  My_App
//
//  Created by apple on 15/9/30.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreAllGoodsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>{
    NSMutableArray *dataArray;
    
    NSMutableArray *dataArrayShangla;
    
    BOOL shanglaBool;
    
    __weak IBOutlet UIView *topView;
    __weak IBOutlet UIView *loadingV;
    __weak IBOutlet UIView *grayView;
    __weak IBOutlet UIView *nothingView;
    
    
    __weak IBOutlet UITableView *MyTableView;
    BOOL requestBool;
    UIImageView *imageNothing;//什么都没有图片
    NSString *select_attribute;//用来判断是哪个上啦刷新
    
    BOOL priceBool;
    BOOL salesBool;
    BOOL renBool;
    BOOL timeBool;
    
    UIImageView *imageKuang;//顶部动态的框
    UILabel *laP;//价格label
    UILabel *la2S;
    UILabel *la3R;
    UILabel *la4N;
    
    
    BOOL btnClickedBool;
}

@property (strong, nonatomic)  UIImageView *redPrice;
@property (strong, nonatomic)  UIImageView *redSales;
@property (strong, nonatomic)  UIImageView *redPopularity;
@property (strong, nonatomic)  UIImageView *redTime;
@property (strong, nonatomic)  UIButton *timeBtn;

@property (strong, nonatomic)  UIButton *priceBtn;
@property (strong, nonatomic)  UIButton *sales;
@property (strong, nonatomic)  UIButton *popularityBtn;
- (IBAction)btnClicked:(id)sender;

@end
