//
//  returnGoodsShipViewController.h
//  My_App
//
//  Created by apple on 15-1-29.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface returnGoodsShipViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{

    UITableView *MyTableView;
    UILabel *laLiuyan;
    UITextView *myTextView;
    NSMutableArray *dataArray;
    NSInteger ShipTag;
    UITextField *registerNameField;
    
    UIView *shipView;
    UITableView *ShipTableView;
}

@end
