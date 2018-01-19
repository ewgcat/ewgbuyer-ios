//
//  TSDetailViewController.h
//  My_App
//
//  Created by barney on 15/11/25.
//  Copyright © 2015年 barney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSModel.h"
@interface TSDetailViewController : UIViewController
@property(nonatomic,strong)TSModel *model;
@property (nonatomic, copy)NSString *goods_name;
@property (nonatomic, copy)NSString *goods_img;
@property (nonatomic, copy)NSString *order_id;
@property (nonatomic, copy)NSString *goods_id;
@property (nonatomic, copy)NSString *goods_gsp_ids;
@property (nonatomic, copy)NSString *oid;
@end
