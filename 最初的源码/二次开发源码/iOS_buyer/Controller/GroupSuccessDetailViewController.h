//
//  GroupSuccessDetailViewController.h
//  My_App
//
//  Created by barney on 15/12/16.
//  Copyright © 2015年 barney. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupSuccessDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;
@property (weak, nonatomic) IBOutlet UILabel *orderID;
@property (weak, nonatomic) IBOutlet UILabel *addTime;
@property (weak, nonatomic) IBOutlet UILabel *payType;
@property (copy, nonatomic)NSString *orderSta;
@property (copy, nonatomic)NSString *orderId;
@property (copy, nonatomic)NSString *time;
@property (copy, nonatomic)NSString *type;
@end
