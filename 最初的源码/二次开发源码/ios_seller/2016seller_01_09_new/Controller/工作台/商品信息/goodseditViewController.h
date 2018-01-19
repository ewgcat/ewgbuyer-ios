//
//  goodseditViewController.h
//  SellerApp
//
//  Created by apple on 15-4-7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "goodsModel.h"
@interface goodseditViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{

    NSMutableArray *dataArray;
    UILabel *label_prompt;//提示label
    UIView *loadingV;//正在加载视图
    UITableView *orderlist_tableview;
    UITextField *nameTextField;
    UITextField *priceTextField;
    UITextField *inventroyTextField;
    NSString *goods_recommend;
    NSString *swichTag;
}

@property(nonatomic,strong)goodsModel *model;

@end
