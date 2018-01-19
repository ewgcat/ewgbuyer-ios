//
//  ExchangeHomeViewController.h
//  My_App
//
//  Created by apple on 14-12-29.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"


@interface ExchangeHomeViewController : UIViewController<ASIHTTPRequestDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    __weak IBOutlet UILabel *filterIntegralLabel;
    __weak IBOutlet UIView *nothingView;
//    __weak IBOutlet UILabel *myIntegral;
    __weak IBOutlet UIButton *filterBtn;

    __weak IBOutlet UICollectionView *integralCollectionView;
    
    __weak IBOutlet UIView *filterIntrgralView;
    BOOL filterBool;
    NSInteger filterTag;
    NSMutableArray *dataArr;
    NSMutableArray *dataArrShangla;
    NSString  *myIntegral;
    
    
    __weak IBOutlet UIButton *Btn_4000;
    __weak IBOutlet UIButton *Btn_1999;
    __weak IBOutlet UIButton *Btn_2000;
    __weak IBOutlet UIButton *Btn_10000;
    __weak IBOutlet UIButton *Btn_6000;
    __weak IBOutlet UIButton *All_btn;
    
    __weak IBOutlet UILabel *FilterAllLabel;
    __weak IBOutlet UILabel *Filter1999;
    __weak IBOutlet UILabel *Filter2000;
    __weak IBOutlet UILabel *Filter4000;
    __weak IBOutlet UILabel *Filter6000;
    __weak IBOutlet UILabel *Filter10000;
}
- (IBAction)filterIntegralAction:(id)sender;
- (IBAction)exchangeRecordAction:(id)sender;
@property (strong, nonatomic) NSString *ig_id;

- (IBAction)filterBtnAction:(id)sender;

+(id)sharedUserDefault;

@end
