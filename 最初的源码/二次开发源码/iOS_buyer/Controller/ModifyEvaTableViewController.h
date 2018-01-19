//
//  ModifyEvaTableViewController.h
//  My_App
//
//  Created by apple2 on 16/2/2.
//  Copyright © 2016年 apple2. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EvaAddModel;

@interface ModifyEvaTableViewController : UITableViewController<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, copy)NSString *evaID;
@property (nonatomic, strong)EvaAddModel *model;
@property (strong, nonatomic)EvaAddModel *finalModel;
@property (nonatomic, strong) NSMutableArray *starBtnArray;

@end
