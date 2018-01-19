//
//  WorkBenchViewController.h
//  SellerApp
//
//  Created by apple on 15/4/27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkBenchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UIButton *refreshButton;
    __weak IBOutlet UIView *loadingV;
    __weak IBOutlet UIView *refreshV;
    __weak IBOutlet UITableView *myTableview;
    __weak IBOutlet UILabel *label_prompt;
    __weak IBOutlet UIView *grayView;
}
@property (strong,nonatomic)NSString *PhotoStr;
@property (assign,nonatomic)NSInteger selectTag;
+(id)sharedUserDefault;
- (void)getNetWorking;
@end
