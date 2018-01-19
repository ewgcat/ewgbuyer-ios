//
//  GoodsViewController.h
//  SellerApp
//
//  Created by apple on 15-3-20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    PullToRefreshTableView *orderlist_tableview;
    UITableView *classify_tableview;
    NSMutableArray *displayArray;//分类数组
    NSMutableArray *nodes;
    
    BOOL requestBool;//请求bool
    
    UILabel *label_prompt;//提示label
    UIView *loadingV;//正在加载视图
    UIView *faildV;//加载失败视图
    NSMutableArray *orderlist_Array;
    NSMutableArray *orderlistPull_Array;
    
    UILabel *ON_label;//出售中
    UILabel *depot_label;//仓库
    UILabel *illegal_label;//违规下架
    UILabel *category_label;//分类
    NSInteger labelTag;//出售中、仓库、违规下架等得标记值
    
    UILabel *time_label;//添加时间标签
    UILabel *salenumber_label;//销量
    UILabel *inventory_label;//库存
    NSInteger filterlabelTag;//添加时间标签、销量、库存的标记值
    
    BOOL timeBool;
    BOOL salesnumBool;
    BOOL inventoryBool;
    
    UIView *edit_view;
    
    BOOL btnClickedBool;
    NSString *goodid_Str;
    UIImageView *All_Image;
    BOOL allBool;
    UIButton *btnDown;//下架
    UIButton *btnUp;//上架
    NSInteger classify_ID;//用来记住选中的id，若=-1则时间等筛选需要加参数user_goodsclass_id
}
- (IBAction)backBtnClicked:(id)sender;
- (IBAction)editBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *button_edit;

+(id)sharedUserDefault;
@end
