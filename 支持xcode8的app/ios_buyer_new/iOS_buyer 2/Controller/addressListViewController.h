//
//  addressListViewController.h
//  My_App
//
//  Created by apple on 15/8/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHSectionSelectionView.h"

@interface addressListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CHSectionSelectionViewDataSource, CHSectionSelectionViewDelegate>{
    
    __weak IBOutlet UIView *rightView;
    __weak IBOutlet UITableView *MyTableView;
    __weak IBOutlet UIButton *cancelBtn;
    NSMutableArray *addressListArray;
    NSMutableArray *Vcardarray;
}
@property (nonatomic, strong) CHSectionSelectionView *selectionView;
@end
