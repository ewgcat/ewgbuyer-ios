//
//  AddEvaluatetTableViewController.h
//  My_App
//
//  Created by shiyuwudi on 16/2/3.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EvaAddModel;

@interface AddEvaluatetTableViewController : UITableViewController

@property (nonatomic, copy)NSString *evaID;
@property (nonatomic, strong)EvaAddModel *model;
//@property (strong, nonatomic)EvaAddModel *finalModel;
@property (nonatomic, strong) NSMutableArray *starBtnArray;

@end
