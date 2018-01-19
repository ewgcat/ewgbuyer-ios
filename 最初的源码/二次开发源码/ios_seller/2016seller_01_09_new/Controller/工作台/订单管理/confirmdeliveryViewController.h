//
//  confirmdeliveryViewController.h
//  SellerApp
//
//  Created by apple on 15-3-24.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewControllerNoTabbar.h"

@interface confirmdeliveryViewController : BaseViewControllerNoTabbar<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    UITableView *Mytableview;
    NSMutableArray *deliveryGoodsArray;
    UITextField *shipAddrField;//物流单号
    UITextView  *shipStreetAddrField;//操作说明
    UIView *shipView;//物流选择视图
    UIView *addressView;//地址选择视图
    UILabel *lbl_ordernum2;//订单号
    UILabel *lbl_detailAds2;//物流公司
    NSString *shipcompany;
    NSString *sendAddress;
    UILabel *lbl_detailAds;//发货地址
    UIView *loadingV;
    UILabel *label_prompt;
    NSMutableArray *shipAddrs_list;//shipAddrs_list数组
    NSMutableArray *expressCompanyCommon_list;//expressCompanyCommon_list数组
    NSInteger physicalGoods;//判断是否有实物商品
    UITableView *address_tableview;//地址tableView
    NSString *ecc_id;//物流公司id
    NSString *sa_id;//发货地址id
    NSDictionary *myDic;
    NSMutableArray *describeArray;
}
@end
