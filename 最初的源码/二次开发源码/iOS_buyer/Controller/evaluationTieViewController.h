//
//  evaluationTieViewController.h
//  My_App
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface evaluationTieViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>{
    
    __weak IBOutlet UITableView *MyTableView;
}

@end
