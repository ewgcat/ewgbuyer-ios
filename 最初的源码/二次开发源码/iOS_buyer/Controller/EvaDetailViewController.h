//
//  EvaDetailViewController.h
//  My_App
//
//  Created by shiyuwudi on 16/2/1.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EvaAddModel;

@interface EvaDetailViewController : UIViewController

@property (nonatomic, copy)NSString *evaID;
@property (nonatomic, strong)EvaAddModel *model;
@property (nonatomic, assign)BOOL modify;

+(instancetype)evaDetailViewController;

@end
