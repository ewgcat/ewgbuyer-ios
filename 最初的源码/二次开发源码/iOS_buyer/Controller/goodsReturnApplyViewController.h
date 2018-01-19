//
//  goodsReturnApplyViewController.h
//  My_App
//
//  Created by apple on 15-1-22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface goodsReturnApplyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate>
{
    UITableView *MyTableView;
    UILabel *laLiuyan;
    UITextView *myTextView;
    NSString *return_count;//货物的数量
    NSString *content;//退胡说明
    ASIFormDataRequest *request_1;
    ASIFormDataRequest *request_2;
    ASIFormDataRequest *request_3;
    
    UITextField *textFieldGoodsCount;
}

@end
