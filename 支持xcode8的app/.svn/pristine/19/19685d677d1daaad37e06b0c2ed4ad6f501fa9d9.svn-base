//
//  TSCell.h
//  My_App
//
//  Created by barney on 15/11/24.
//  Copyright © 2015年 barney. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TSButtonCLickDelegate <NSObject>

-(void)detailsButtonCLick:(NSDictionary *)sd WithOid:(NSString *)oid;//协议方法

@end


@interface TSCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *order;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *TS;
@property (weak, nonatomic) IBOutlet UIView *top;
@property (weak, nonatomic) IBOutlet UIView *bottom;
@property (weak, nonatomic) IBOutlet UIView *finalLine;
@property (weak, nonatomic) IBOutlet UITableView *yourTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (copy,nonatomic)NSString *oid;
@property (copy,nonatomic)NSArray *array;
@property(nonatomic,assign)id<TSButtonCLickDelegate>delegate;


@end
