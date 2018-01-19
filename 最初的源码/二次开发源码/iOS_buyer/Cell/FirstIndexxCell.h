//
//  FirstIndexxCell.h
//  My_App
//
//  Created by barney on 16/4/28.
//  Copyright © 2016年 barney. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FirstIndexxCell;

@protocol FirstIndexxCellDelegate <NSObject>

-(void)firstIndexxCell:(FirstIndexxCell *)cell didClickedWithTitle:(NSString *)title;

@end

@interface FirstIndexxCell : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, weak) id<FirstIndexxCellDelegate> delegate;

+(NSArray *)getAllKindsOfButton;

@end
