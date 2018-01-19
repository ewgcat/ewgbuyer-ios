//
//  FouthViewController.h
//  My_App
//
//  Created by apple on 15/7/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHSectionSelectionView.h"
#import "ASIFormDataRequest.h"

@interface FouthViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CHSectionSelectionViewDataSource, CHSectionSelectionViewDelegate>
{
    UIImageView *shjImageView;
    BOOL shjBool;
    NSMutableArray *dateArray;
    NSArray *array2;
    
    NSMutableArray *arrayfenzuhangshu;
    NSMutableArray *arrayDic;
    NSMutableArray *arrrayTitile;
    
    __weak IBOutlet UIView *nothingView;

    __weak IBOutlet UILabel *labelTi;

    
    ASIFormDataRequest *request_1;
    ASIFormDataRequest *request_2;
    ASIFormDataRequest *request_3;
    
    //无网
    IBOutlet UIButton *searchbtn;
}
@property (weak, nonatomic) IBOutlet UITableView *MyTableView;
@property(strong, nonatomic) NSArray *arr;
@property(assign,nonatomic) BOOL brandNav;
@property (nonatomic, strong) CHSectionSelectionView *selectionView;
//+(id)sharedUserDefault;

-(IBAction)refreshClicked:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomContrain;

@end
