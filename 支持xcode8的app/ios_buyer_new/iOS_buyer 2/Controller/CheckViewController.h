//
//  CheckViewController.h
//  My_App
//
//  Created by apple on 14-8-25.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface CheckViewController : UIViewController<ASIHTTPRequestDelegate,UITableViewDataSource,UITableViewDelegate>{
    ASIFormDataRequest *request102;
    UITableView *MyTableView;
    NSMutableArray *dataArray;
    
    UIView *loadingV;//开始正在加载试图
}
@property (strong, nonatomic) UILabel *lblCheckName;
@property (strong, nonatomic) UILabel *lblWaybillNumber;

@property (strong, nonatomic) UILabel *lblGoodsName;
@property (strong, nonatomic) UIImageView *imgGoods;
@property (strong, nonatomic) UILabel *lblGoodsPrice;
@property (strong, nonatomic) UILabel *lblGoodsNumber;


@end
