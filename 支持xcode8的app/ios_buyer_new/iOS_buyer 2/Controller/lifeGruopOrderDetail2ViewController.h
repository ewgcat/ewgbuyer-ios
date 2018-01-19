//
//  lifeGruopOrderDetail2ViewController.h
//  My_App
//
//  Created by apple on 15-2-6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lifeGruopOrderDetail2ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *MyTableView;
    BOOL requestBool;
    NSMutableArray *dataArray;
    NSMutableArray *dataArrayShangla;
    UIButton *buttonCancel;
    
    NSString *PartnerID;
    NSString *SellerID;
    NSString *PartnerPrivKey;
    NSString *AlipayPubKey;
    NSString *MD5_KEY;
    NSMutableArray *arrayPay;
}

@property (nonatomic,assign) SEL result;//这里声明为属性方便在于外部传入。

@end
