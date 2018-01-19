//
//  FreeCouponsViewController.h
//  My_App
//
//  Created by apple on 15/10/12.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FreeCouponsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>{
    __weak IBOutlet UITableView *CouponsTableView;
//    __weak IBOutlet UIView *LoadingView;
//    __weak IBOutlet UIView *LoadingGrayView;
    NSMutableArray *dataArray;
//    __weak IBOutlet UILabel *PromptLabel;
}

//领取页面优惠券信息
@property (strong,nonatomic)ClassifyModel *ReceiveModel;

+(id)sharedUserDefault;
@end
