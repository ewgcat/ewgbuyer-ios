//
//  PaymentOrderViewController.h
//  My_App
//
//  Created by apple on 16/2/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloudCart.h"
@interface PaymentOrderViewController : UIViewController

@property(nonatomic,strong)CloudCart *cloudCartModel;
@property(nonatomic,strong)NSArray *cloudCartArray;
@property(nonatomic,strong)NSString *totalPrice;
@end
