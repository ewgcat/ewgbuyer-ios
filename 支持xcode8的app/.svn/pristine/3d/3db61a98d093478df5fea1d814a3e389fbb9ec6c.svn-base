//
//  addressManagerCell.h
//  My_App
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//
@class addressManagerCell;
@protocol AddressManagerCellDelegate <NSObject>

-(void)addressManagerCellSetDefaultBtnClicked:(addressManagerCell *)cell;
-(void)addressManagerCellDeleteBtnClicked:(addressManagerCell *)cell;
-(void)addressManagerCellDidRecognizedLeftGesture:(addressManagerCell *)cell;

@end
#import <UIKit/UIKit.h>
@interface addressManagerCell : UITableViewCell

@property (nonatomic,strong)ClassifyModel *model;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIImageView *boderImage;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UILabel *morenAddress;
@property (weak, nonatomic) IBOutlet UIImageView *validateImageview;
@property (weak, nonatomic) IBOutlet UILabel *cardNum;
@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;
@property (weak, nonatomic)id<AddressManagerCellDelegate> delegate;
@property (strong, nonatomic)NSIndexPath *indexPath;

-(void)setData:(ClassifyModel *)model;
-(void)setDefault:(BOOL)flag;

-(void)swipedRight:(UISwipeGestureRecognizer *)swipeGR;

@end
