//
//  AddAdminViewController.h
//  My_App
//
//  Created by apple on 14-8-13.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "CloudCart.h"
#import "CloudPurchaseLottery.h"
#import "CloudPurchaseGoods.h"

@protocol AddAdminViewControllerDelegate <NSObject>

-(void)addAdminViewControllerBackClick:(CloudCart *)model;

@end




@interface AddAdminViewController : UIViewController<UITableViewDataSource,UITabBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UIView *promptView;
    UITableView *MyTableView;
    NSMutableArray *dataArray;
    NSArray *arrAdd;
    ASIFormDataRequest *requestAdd;
    NSMutableArray *arrFenzuhangshu;
    NSMutableArray *arrDic;
    NSMutableArray *arrTitle;
    
    NSInteger select;
    NSInteger didselect;
    NSString *morenid;
    
    ASIFormDataRequest *requestSetMo;
    ASIFormDataRequest *requestAdmin1;
    ASIFormDataRequest *requestAdmin3;
    ASIFormDataRequest *requestAdmin5;
}

@property(nonatomic,strong)CloudCart *cloudCartModel;

@property(nonatomic,assign)id<AddAdminViewControllerDelegate>delegate;

@end
