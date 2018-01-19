//
//  myzerodetailViewController.h
//  My_App
//
//  Created by apple on 15-1-5.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myzerodetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    //开始加在
    UITableView * MyTableView;
    NSMutableArray *dataArray;
    UILabel *laLiuyan;
    UITextView *mytextview;
}


@end
