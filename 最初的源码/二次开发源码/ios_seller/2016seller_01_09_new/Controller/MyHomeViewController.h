//
//  MyHomeViewController.h
//  SellerApp
//
//  Created by barney on 15/12/29.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
 UITableView *home_tableview;

}
-(void)network;
- (void)getNetWorking;
+(id)sharedUserDefault;
@end
