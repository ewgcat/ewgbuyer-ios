//
//  DetailViewController.h
//  My_App
//
//  Created by apple on 14-7-30.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "EGORefreshTableHeaderView.h"

@class DDPageControl ;

@interface storegoodsDetailViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,UIScrollViewDelegate,UITextFieldDelegate,EGORefreshTableHeaderDelegate,UIWebViewDelegate>{
    UIButton *btn2Qing;//轻松购按钮
    UIButton *btnAddCar;//加入购物车按钮
    UILabel *FlabeHeart2;
    UIImageView *labeHeart2;
    UITableView *MyTableView;//详细页面tableview
    NSString *CountExchange;
    UITableView *SpecTableView;//规格tableview
    UIView *specView;
    UIButton *button2add;
    UIButton *Fbtn2Qing;//F码购买 Detail底部的View
    UIButton *btn22Qing;
    UIView *FBuyView;//F码购买规格页面的立即购买按钮地下的View
    
    BOOL muchBool;//更多视图bool值
    UIView *muchView;
    
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
    
    //库存
    UILabel *labelinventory;//库存标签
    
    NSInteger EbtnTag;
    
    //地区
    NSMutableArray *regionArray;
    UIImageView *regionView;
    UILabel *selectRegion;
    NSString *regionStr;
    //收藏
    UIButton *btnSC;
    UIButton *FbtnSC;
    
    float act_rate;//折扣率
    NSString *feetext;//运费
    
    NSString *cuPrice;//促销价格
    
    NSString *status;//商品的活动状态：促销 优惠 等
    
    UILabel *labelTi;
    
    BOOL scrollBool;//mytableview滑动到底部的
    UIWebView *myWebView;//商品详情webview
    
    //开始加在
    UIView *loadingV;
    
    UIView *myViewBI;//点击顶部图片放大后的视图
    
    NSInteger selectRegionIndex;//选中地区cell的indexpath值
    
    DDPageControl *pageControl ;//点击放大后 的滑动原点
    UIScrollView *_myScrollView22;//点击放大后滑动view
    
    DDPageControl *page2Control ;//滑动原点
    UIScrollView *_myScrollView2;//顶部上平图片 点击放大后的scrollview
    
    BOOL indexPath1Bool;//用来判断indexpath1是否被点击了 NO没有点击  YES为点击了
    BOOL indexPath2Bool;//用来判断indexpath1是否被点击了 NO没有点击  YES为点击了
    UITextField *countField;//规格页面可输入数量
    UIButton *buttonNext;//下一步按钮
    UILabel *labelCarCount;
    
    UIView *bottomView;//
    UIImageView *imageViewDarkGray;
    
    NSMutableArray *specSelectArray;
    
    BOOL _reloading;
    EGORefreshTableHeaderView *_refreshHeaderView;
    
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
    
}
@end