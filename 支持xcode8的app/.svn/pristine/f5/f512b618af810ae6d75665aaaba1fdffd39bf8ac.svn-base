//
//  CartViewController.h
//  My_App
//
//  Created by apple on 15/12/28.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHSectionSelectionView.h"
@class SYOrderDetailsModel;

@interface CartViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,UITextFieldDelegate,CHSectionSelectionViewDelegate>{
    UIView *logView;
    NSMutableArray *dataArray;
    NSMutableArray *arr_discount_list;
    NSMutableArray *activityArray;
    
    NSString *ppppRice;
    UIView *loadingV;
    
    UILabel *labelCount;
    UIButton *buttonDelete;
    
    UIView *labelWu;
    
    UIImageView *viwe;
    UITextField *textFF;
    NSString *cartidcan;
    NSString *yuanCount;
    
    ClassifyModel *classText;
    UIView *mansongView;//满就送view
    NSInteger mansongTag;//满就送标记tag值
    NSInteger zhongmansongTag;//满就送标记tag值
    NSMutableArray *mansongGiftStringArray;//赠品字符串数组
    UITableView *mansongTableview;
    NSInteger giftTag;//上面的对号
    BOOL sureBool;
    
    UITableView *combinTableview;
    NSMutableArray *combinDataArray;
    UILabel *CountMyX;//这个是点击购物车可输入数量页面里面的 右上角的数量值
    
    //无网
    IBOutlet UIButton *searchbtn;
}
@property(strong,nonatomic)NSString *goods_id;
@property(strong,nonatomic)UITableView *MyTableView;
@property(strong,nonatomic)UILabel *shangJin;
@property(strong,nonatomic)UILabel *zongji;
@property(strong,nonatomic)UILabel *jiesuan;
@property(assign,nonatomic)BOOL myBool;
@property(assign,nonatomic)BOOL myBool2;
@property(assign,nonatomic)NSInteger littlecount;
@property(assign,nonatomic)float Qzongji;
@property(assign,nonatomic)NSInteger jiesuanCount;
@property(assign,nonatomic)NSInteger Quanxuan;

@property(strong,nonatomic)UIButton *btnQ2;
@property(strong,nonatomic)UIButton *btnQ;
@property(strong,nonatomic)NSString *cart_ids;
@property(strong,nonatomic)NSString *cart_meideng;

@property(strong,nonatomic)NSString *chuancart_id;

//收货人信息
@property(strong,nonatomic)NSString *person_addr_id;
@property(strong,nonatomic)NSString *person_name;
@property(strong,nonatomic)NSString *person_phone;
@property(strong,nonatomic)NSString *person_address;

//自提点信息
@property(strong,nonatomic)NSString *delivery_type;
@property(strong,nonatomic)NSString *delivery_id;

//发票信息
@property(strong,nonatomic)NSString *tic_pu;
@property(strong,nonatomic)NSString *tic_zeng;
@property(strong,nonatomic)NSString *tic_taitou;

//支付配送方式
@property(strong,nonatomic)NSString *pay;
@property(strong,nonatomic)NSString *paymark;
@property(strong,nonatomic)NSString *fee;

//结算
@property(strong,nonatomic)NSString *jie_cart_ids;
@property(assign,nonatomic)NSInteger jie_reduce;
@property(strong,nonatomic)NSString *jie_order_goods_price;
@property(strong,nonatomic)NSString *jie_store_ids;

@property(strong,nonatomic)NSString *wuliu;

@property(strong,nonatomic)NSString *trans;
@property(strong,nonatomic)NSString *ship_price;

//订单
@property(strong,nonatomic)NSString *ding_hao;
@property(strong,nonatomic)NSString *ding_jine;
@property(strong,nonatomic)NSString *ding_fangshi;
@property(strong,nonatomic)NSString *ding_order_id;

@property(strong,nonatomic)NSString *typeString;
//团购
@property(strong,nonatomic)SYOrderDetailsModel *order_details_model;

@property(assign,nonatomic)NSInteger xuanzeyoufei;

@property(strong,nonatomic)NSString *select_order_id;

@property(strong,nonatomic)NSString *LongorderInfo;
@property(strong,nonatomic)NSArray *onlineArray;
@property(strong,nonatomic)NSString *usecouponsMoney;
@property(strong,nonatomic)NSString *usecouponsID;
@property(strong,nonatomic)NSString *train_order_id;

@property(strong,nonatomic)NSString *xiu_addr_id;
@property(strong,nonatomic)NSString *xiu_area;
@property(strong,nonatomic)NSString *xiu_areaInfo;
@property(strong,nonatomic)NSString *xiu_default;
@property(strong,nonatomic)NSString *xiu_mobile;
@property(strong,nonatomic)NSString *xiu_trueName;
@property(strong,nonatomic)NSString *xiu_zip;

@property (strong,nonatomic)NSString *strout_trade_no;

@property(strong,nonatomic)NSString *priteKey;


@property(strong,nonatomic)NSString *payViewmark;
@property(strong,nonatomic)NSString *moneyViewmark;

@property (nonatomic, strong) CHSectionSelectionView *selectionView;

//店铺id
@property(strong,nonatomic)NSString *store_id;
+(id)sharedUserDefault;
-(void)tableviewRefrsh;


-(IBAction)refreshClicked:(id)sender;
@end
