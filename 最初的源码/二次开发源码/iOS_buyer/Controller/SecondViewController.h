//
//  SecondViewController.h
//  My_App
//
//  Created by apple on 15/7/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "ZBarSDK.h"

@interface SecondViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,UITextFieldDelegate,ZBarReaderDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>{
    
    __weak IBOutlet UIButton *refreshNetBtn;
    __weak IBOutlet UITableView *MyTableView;
    __weak IBOutlet UICollectionView *My_collectionView;
    __weak IBOutlet UILabel *searchLabel;
   
    __weak IBOutlet UIButton *scanBtn;
    __weak IBOutlet UIButton *searchBtn;
    
    __weak IBOutlet UILabel *labelTi;
    
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    
    BOOL myBool;
    NSInteger My_indexpath;
    NSMutableArray *dataArray;
    NSMutableArray *dataArraySecond;
}

@property (strong,nonatomic)NSString *sub_id;
@property (strong,nonatomic)NSString *sub_title;
@property (strong,nonatomic)NSString *sub_id2;
@property (strong,nonatomic)NSString *sub_title2;
@property (strong,nonatomic)NSString *detail_id;// 物品id
@property (nonatomic, strong) UIImageView * line;
@property (strong,nonatomic)NSString *detailweb_title;
@property (strong,nonatomic)NSString *detailweb_details;
@property(strong,nonatomic)NSString *searchKeyword;
@property(assign,nonatomic)BOOL storeAllgoodsBool;

+(id)sharedUserDefault;

@end
