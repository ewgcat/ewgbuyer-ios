//
//  BaseTableViewControllerNoTabbar.h
//  2016seller_01_09_new
//
//  Created by shiyuwudi on 16/1/14.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewControllerNoTabbar : UITableViewController

-(void)setRightBtnWithTitle:(NSString *)title normalImg:(NSString *)normalImg highlightImg:(NSString *)highlightImg target:(id)target action:(SEL)action;

@end
