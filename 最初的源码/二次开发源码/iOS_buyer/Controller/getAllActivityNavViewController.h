//
//  getAllActivityNavViewController.h
//  My_App
//
//  Created by apple on 15/10/20.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface getAllActivityNavViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    __weak IBOutlet UILabel *PromptLabel;
    __weak IBOutlet UITableView *MyTableView;
    NSMutableArray *dataArray;
}
@property (strong,nonatomic) ClassifyModel *classifyModel;
+(id)sharedUserDefault;
@end
