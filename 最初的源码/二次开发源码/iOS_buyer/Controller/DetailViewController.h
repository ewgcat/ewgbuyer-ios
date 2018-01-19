//
//  DetailViewController.h
//  My_App
//
//  Created by apple on 14-7-30.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableHeaderView1.h"

@class DDPageControl ;

@interface DetailViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,UIScrollViewDelegate,UITextFieldDelegate,EGORefreshTableHeaderDelegate,EGORefreshTableHeaderDelegate1,UIWebViewDelegate,UITextFieldDelegate>{
    UIButton *btn2Qing;//轻松购按钮
    UIButton *btnAddCar;//加入购物车按钮
    UIButton *btnAddCar1;
    UIButton *btnAddCar2;
    UIImageView *labeHeart2;
    UIImageView *labeHeart3;
    UIImageView *labeHeart4;
    UILabel *FlabeHeart2;
    UITableView *MyTableView;//详细页面tableview
    NSString *CountExchange;
    UITableView *SpecTableView;//规格tableview
    UIView *specView;
    UIButton *button2add;
    UIButton *Fbtn2Qing;//F码购买 Detail底部的View
    UIButton *btn22Qing;
    UIButton *btn22Qing1;
    UIButton *btn22Qing2;
    
    UIView *FBuyView;//F码购买规格页面的立即购买按钮地下的View
    
    UITableView *RegoinTableView;//地区tableview
    NSMutableArray *dataArray;//数组
    NSMutableArray *specificationsArray;//规格数组
    NSMutableArray *maylikeArray;//可能还喜欢数组
    NSArray *arrImage;//顶部可滑动图片的数组
    
    NSString *userLeve;
    
    UILabel *morenSpec;//默认的规格
    
    BOOL selectBool;//用来判断第三个cell是展开的还是收起的
    BOOL tableBool;
    
    BOOL specSelectBool;
    
    //无网
    IBOutlet UIButton *searchbtn;
    
    //库存
    UILabel *labelinventory;//库存标签
    
    NSInteger EbtnTag;
    
    //地区
    NSMutableArray *regionArray;
    UIImageView *regionView;
    UILabel *selectRegion;
    NSString *regionStr;
    NSString *regionIdStr;
    //收藏
    UIButton *btnSC;
    UIButton *btnSC1;
    UIButton *FbtnSC;
    
    float act_rate;//折扣率
    NSString *feetext;//运费
    
    NSString *cuPrice;//促销价格
    
    NSString *status;//商品的活动状态：促销 优惠 等
    
    UILabel *labelTi;
    
    BOOL scrollBool;//mytableview滑动到底部的
//    int scrollCount;//第一次滑到底部不做操作
    UIWebView *myWebView;//商品详情webview
    UIWebView *myWebView1;
    
    //开始加在
    UIView *loadingV;
    
    UIView *myViewBI;//点击顶部图片放大后的视图
    
    NSInteger selectRegionIndex;//选中地区cell的indexpath值
    
    DDPageControl *pageControl ;//点击放大后 的滑动原点
    UIScrollView *_myScrollView22;//点击放大后滑动view
    
    DDPageControl *page2Control ;//滑动原点
    UILabel *pagelabel;
    UIScrollView *_myScrollView2;//顶部上平图片 点击放大后的scrollview
    
    BOOL indexPath1Bool;//用来判断indexpath1是否被点击了 NO没有点击  YES为点击了
    BOOL indexPath2Bool;//用来判断indexpath1是否被点击了 NO没有点击  YES为点击了
    UITextField *countField;//规格页面可输入数量
    UITextField *countField1;
    UIButton *buttonNext;//下一步按钮
    
    UIView *bottomView;//
    UIView *bottomView1;//
    UIView *bottomView2;
    UIImageView *imageViewDarkGray;
    
    NSMutableArray *specSelectArray;
    
    BOOL _reloading;
    EGORefreshTableHeaderView1 *_refreshHeaderView;
    
    UIView *FCode_bottomView;
    
    NSInteger afterTag;
    
    UIView *FCodeView;
    UITextField *phoneNumFieldFF;
    
    NSMutableArray *zuheArray;
    NSMutableArray *zuhePeijianArray;
    UITableView *zuhepeijianTableView;
    
    UIView *zuheView;
    UITableView *zuheTableView;
    NSMutableArray *peijianSelectArray;
    
    BOOL favouiteBool;
    
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
    ASIFormDataRequest *request_21;
    ASIFormDataRequest *request_22;
    ASIFormDataRequest *request_23;
    ASIFormDataRequest *request_24;
    ASIFormDataRequest *request_25;
    ASIFormDataRequest *request_26;
    ASIFormDataRequest *request_27;
    ASIFormDataRequest *request_28;
    ASIFormDataRequest *request_29;
    ASIFormDataRequest *request_30;
    ASIFormDataRequest *request_31;
    ASIFormDataRequest *request_32;
    ASIFormDataRequest *request_33;
    ASIFormDataRequest *request_34;
    ASIFormDataRequest *request_35;
    ASIFormDataRequest *request_36;
    ASIFormDataRequest *request_37;
    ASIFormDataRequest *request_38;
    ASIFormDataRequest *request_39;
    ASIFormDataRequest *request_40;
    ASIFormDataRequest *request_41;
    ASIFormDataRequest *request_42;
    ASIFormDataRequest *request_43;
    ASIFormDataRequest *request_44;
    ASIFormDataRequest *request_45;
    ASIFormDataRequest *request_46;
    ASIFormDataRequest *request_47;
    ASIFormDataRequest *request_48;
    ASIFormDataRequest *request_49;
    
    BOOL muchBool;//更多视图bool值
    __weak IBOutlet UIView *muchView;
    __weak IBOutlet UIImageView *grayMuchImage;
    //跳转按钮
    __weak IBOutlet UIButton *thirdBtn;
    __weak IBOutlet UIButton *firstBtn;
    __weak IBOutlet UIButton *secondBtn;
    __weak IBOutlet UIButton *fouthBtn;
    __weak IBOutlet UIButton *fifthBtn;
    
}

@property (nonatomic, copy)NSString *detail_id;
//购物车传过来的值
@property (nonatomic,strong)NSDictionary *cartDictionary;

-(IBAction)refreshClicked:(id)sender;
- (IBAction)mainBtnClicked:(id)sender;

@end