//
//  GroupOrdListViewController.h
//  My_App
//
//  Created by apple on 15-1-16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface Product : NSObject{
@private
    float _price;
    NSString *_subject;
    NSString *_body;
    NSString *_orderId;
}

@property (nonatomic, assign) float price;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *orderId;

@end

@interface GroupOrdListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    __weak IBOutlet UIView *nothingView;
    
    __weak IBOutlet UITableView *MyTableView;
    BOOL requestBool;
    NSMutableArray *dataArray;
    NSMutableArray *dataArrayShangla;
    NSInteger deletTag;
    ASIFormDataRequest *requestGroupOrdList_1;
    ASIFormDataRequest *requestGroupOrdList_2;
    ASIFormDataRequest *requestGroupOrdList_3;
    ASIFormDataRequest *requestGroupOrdList_4;
    ASIFormDataRequest *requestGroupOrdList_5;
    ASIFormDataRequest *requestGroupOrdList_6;
    ASIFormDataRequest *requestGroupOrdList_7;
    BOOL muchBool;
    __weak IBOutlet UIView *muchView;
    __weak IBOutlet UIImageView *grayMuchImage;
    //跳转按钮
    __weak IBOutlet UIButton *thirdBtn;
    __weak IBOutlet UIButton *firstBtn;
    __weak IBOutlet UIButton *secondBtn;
    __weak IBOutlet UIButton *fouthBtn;
    __weak IBOutlet UIButton *fifthBtn;
}
- (IBAction)tabbarBtnClicked:(id)sender;
@end
