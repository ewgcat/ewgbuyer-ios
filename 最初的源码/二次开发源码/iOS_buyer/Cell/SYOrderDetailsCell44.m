//
//  SYOrderDetailsCell44.m
//  My_App
//
//  Created by shiyuwudi on 15/12/28.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import "SYOrderDetailsCell44.h"
#import "SYOrderDetailsCell4.h"
#import "SYOrderDetailsModel.h"
#import "OrderListModel.h"

//static CGFloat h = 108.f;//每行高
static CGFloat h1 = 30.f;//“查看更多”的高度
static NSInteger maxCount = 3;

static SYOrderDetailsCell44* singleInstance = nil;

@interface SYOrderDetailsCell44 ()<SYOrderDetailsCell4Delegate>

@property (nonatomic, weak)UIButton *moreBtn;
@property (nonatomic, assign)NSInteger level;

@end

@implementation SYOrderDetailsCell44

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}
+(instancetype)cell44{
    if (!singleInstance) {
        SYOrderDetailsCell44 *cell = [[[NSBundle mainBundle]loadNibNamed:@"SYOrderDetailsCell44" owner:self options:nil]lastObject];
        singleInstance = cell;
    }
    return singleInstance;
}
-(void)fillWithCount:(NSInteger)count btn:(UIButton *)btn lastY:(CGFloat)y model:(OrderListModel *)model{
        CGFloat yy  = 0;
        for (int i = 0; i < count; i++) {
            
            
            SYOrderDetailsModel *detailModel = model.orders[i];
            SYOrderDetailsCell4 *cell4 = [SYOrderDetailsCell4 cell4WithTableView:self.tableView];
            cell4.model = detailModel;
            cell4.delegate=self;
            CGFloat hh=[SYOrderDetailsCell4 getSYOrderDetailsCell4Higtt:detailModel];
            cell4.frame = CGRectMake(0, yy, ScreenFrame.size.width, hh);
            yy=yy+hh;
            [self.contentView addSubview:cell4];
            if (i==0) {
                UIView *line0=[LJControl viewFrame:CGRectMake(0, 0, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xE7E7E7)];
                [cell4 addSubview:line0];
 
            }else
            {
                UIView *line0=[LJControl viewFrame:CGRectMake(0, 0, ScreenFrame.size.width, 0.5) backgroundColor:UIColorFromRGB(0xE7E7E7)];
                [cell4 addSubview:line0];
            
            }
            
            
            if (i==count-1) {
                UIView *line=[LJControl viewFrame:CGRectMake(0, yy, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xE7E7E7)];
                [self.contentView addSubview:line];
            }
        }
    if (y == -1) {
        return;
    }
    btn.frame = CGRectMake(0, y, [UIScreen mainScreen].bounds.size.width, h1);
    [self.contentView addSubview:btn];
}
-(void)fillHaveGiftWithCount:(NSInteger)count btn:(UIButton *)btn lastY:(CGFloat)y model:(OrderListModel *)model{
    CGFloat yy  = 0;
    
    NSArray *arr1 = model.orders;
    NSInteger count1 = arr1.count;
    
    NSArray *arr2=model.gifOrderDetails;
    NSInteger count2=arr2.count;
    
    if (count< count1) {
        for (int i = 0; i < count; i++) {
            SYOrderDetailsModel *detailModel = model.orders[i];
            SYOrderDetailsCell4 *cell4 = [SYOrderDetailsCell4 cell4WithTableView:self.tableView];
            cell4.model = detailModel;
            cell4.delegate=self;
            CGFloat hh=[SYOrderDetailsCell4 getSYOrderDetailsCell4Higtt:detailModel];
            cell4.frame = CGRectMake(0, yy, ScreenFrame.size.width, hh);
            yy=yy+hh;
            [self.contentView addSubview:cell4];
        }
        if (y == -1) {
            return;
        }
        btn.frame = CGRectMake(0, y, [UIScreen mainScreen].bounds.size.width, h1);
        [self.contentView addSubview:btn];
    }else{
        for (int i = 0; i < count1; i++) {
            SYOrderDetailsModel *detailModel = model.orders[i];
            SYOrderDetailsCell4 *cell4 = [SYOrderDetailsCell4 cell4WithTableView:self.tableView];
            cell4.model = detailModel;
            cell4.delegate=self;
            CGFloat hh=[SYOrderDetailsCell4 getSYOrderDetailsCell4Higtt:detailModel];
            cell4.frame = CGRectMake(0, yy, ScreenFrame.size.width, hh);
            yy=yy+hh;
            [self.contentView addSubview:cell4];
        }
        if (count>count1) {
            UILabel *label=[LJControl labelFrame:CGRectMake(10, yy+5, ScreenFrame.size.width-20, 30) setText:@"赠品清单" setTitleFont:15 setbackgroundColor:[UIColor whiteColor] setTextColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentLeft];
            [self.contentView addSubview:label];
            yy=yy+35;
            NSInteger cc=count-count1>count2?count2:count-count1;
            for (int i = 0; i < cc; i++) {
                SYOrderDetailsModel *detailModel = model.gifOrderDetails[i];
                SYOrderDetailsCell4 *cell4 = [SYOrderDetailsCell4 cell4WithTableView:self.tableView];
                cell4.model = detailModel;
                cell4.delegate=self;
                CGFloat hh=[SYOrderDetailsCell4 getSYOrderDetailsCell4Higtt:detailModel];
                cell4.frame = CGRectMake(0, yy, ScreenFrame.size.width, hh);
                yy=yy+hh;
                [self.contentView addSubview:cell4];
            }
            
        }
        if (y == -1) {
            return;
        }
        btn.frame = CGRectMake(0, y, [UIScreen mainScreen].bounds.size.width, h1);
        [self.contentView addSubview:btn];
    }
    
}




-(void)setModel:(OrderListModel *)model{
    _model = model;
    //清空子视图
    for (UIView *subview in self.contentView.subviews) {
        [subview removeFromSuperview];
    }
    //设置UI
    UIButton *btn = [UIButton new];
    NSString *title = nil;
    if (self.open == YES) {
        title = @"收起";
    }else{
        title = @"查看更多";
    }
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [btn addTarget:self action:@selector(moreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
//    NSArray *arr = model.orders;
//    NSInteger count = arr.count;
    
    NSArray *arr1 = model.orders;
    NSInteger count1 = arr1.count;

    
    NSArray *arr2=model.gifOrderDetails;
    NSInteger count2=arr2.count;
    
    CGFloat ny=[SYOrderDetailsCell44 getNumberSYOrderDetailsCell4Hight:count1 andModel:model];
    CGFloat gy=[SYOrderDetailsCell44 getNumberSYOrderDetailsCell4GiftsHight:count2 andModel:model];
    CGFloat maxy=[SYOrderDetailsCell44 getNumberSYOrderDetailsCell4MaxHight:maxCount andModel:model];
    
    NSInteger count=count1+count2;
    CGFloat y=ny+gy;
    
    if (count2<=0) {
        if (count <= maxCount) {
            [self fillWithCount:count btn:btn lastY:-1 model:model];
        }else if (singleInstance.open == NO){
            [self fillWithCount:maxCount btn:btn lastY:maxy model:model];
        }else{
            [self fillWithCount:count btn:btn lastY:ny model:model];
        }
    }else{
        if (count <= maxCount) {
            [self fillHaveGiftWithCount:count btn:btn lastY:-1 model:model];
        }else if (singleInstance.open == NO){
            [self fillHaveGiftWithCount:maxCount btn:btn lastY:maxy model:model];
        }else{
            [self fillHaveGiftWithCount:count btn:btn lastY:y model:model];
        }
    }
    
    
    
}
-(void)moreBtnClicked:(UIButton *)btn{
    self.open = !self.isOpen;
    if (self.delegate && [self.delegate respondsToSelector:@selector(shouldReloadTableView:)]) {
        [self.delegate shouldReloadTableView:self];
    }
}
+(void)reset{
    singleInstance.open = NO;
}
//+(CGFloat)cellHeightWithModel:(OrderListModel *)model{
//    NSArray *arr = model.orders;
//    NSInteger count = arr.count;
//    CGFloat y=[self getNumberSYOrderDetailsCell4Hight:count andModel:model];
//    CGFloat maxy=[self getNumberSYOrderDetailsCell4Hight:maxCount andModel:model];
//    if (count <= maxCount) {
//        return y;
//    }else if (count > maxCount && singleInstance.open == NO){
//         return maxy + h1;
//    }else if (count > maxCount && singleInstance.open == YES){
//        return y + h1;
//    }else{
//        return 0.f;
//    }
//}
+(CGFloat)cellHeightWithModel:(OrderListModel *)model{
    NSArray *arr1 = model.orders;
    NSInteger count1 = arr1.count;
    
    
    NSArray *arr2=model.gifOrderDetails;
    NSInteger count2=arr2.count;
    
    if (count2<=0) {
        CGFloat y=[self getNumberSYOrderDetailsCell4Hight:count1 andModel:model];
        CGFloat maxy=[self getNumberSYOrderDetailsCell4Hight:maxCount andModel:model];
        if (count1 <= maxCount) {
            return y;
        }else if (count1 > maxCount && singleInstance.open == NO){
            return maxy + h1;
        }else if (count1 > maxCount && singleInstance.open == YES){
            return y + h1;
        }else{
            return 0.f;
        }

    }else{
        CGFloat ny=[SYOrderDetailsCell44 getNumberSYOrderDetailsCell4Hight:count1 andModel:model];
        CGFloat gy=[SYOrderDetailsCell44 getNumberSYOrderDetailsCell4GiftsHight:count2 andModel:model];
        CGFloat maxy=[SYOrderDetailsCell44 getNumberSYOrderDetailsCell4MaxHight:maxCount andModel:model];
        
        NSInteger count=count1+count2;
        CGFloat y=ny+gy;
        
        if (count <= maxCount) {
            return y;
        }else if (count > maxCount && singleInstance.open == NO){
            return maxy + h1;
        }else if (count > maxCount && singleInstance.open == YES){
            return y + h1;
        }else{
            return 0.f;
        }
    }
    
}


+(CGFloat)getNumberSYOrderDetailsCell4Hight:(NSInteger)count andModel:(OrderListModel *)model{
    CGFloat hight=0;
    NSInteger ordersCount=model.orders.count;
    NSInteger cc=count>ordersCount?ordersCount:count;
    for (int i=0; i<cc; i++) {
        SYOrderDetailsModel *detailModel = model.orders[i];
        CGFloat h=[SYOrderDetailsCell4 getSYOrderDetailsCell4Higtt:detailModel];
        hight=hight+h;
    }
    return hight;
}
+(CGFloat)getNumberSYOrderDetailsCell4MaxHight:(NSInteger)count andModel:(OrderListModel *)model{
    CGFloat hight=0;
    NSInteger ordersCount=model.orders.count;
     NSInteger gifordersCount=model.gifOrderDetails.count;
    if (count<=ordersCount) {
        for (int i=0; i<count; i++) {
            SYOrderDetailsModel *detailModel = model.orders[i];
            CGFloat h=[SYOrderDetailsCell4 getSYOrderDetailsCell4Higtt:detailModel];
            hight=hight+h;
        }

    }else{
        for (int i=0; i<ordersCount; i++) {
            SYOrderDetailsModel *detailModel = model.orders[i];
            CGFloat h=[SYOrderDetailsCell4 getSYOrderDetailsCell4Higtt:detailModel];
            hight=hight+h;
        }
        hight=hight+44;
        NSInteger cc=count-ordersCount>gifordersCount?gifordersCount:count-ordersCount;
        for (int i=0; i<cc; i++) {
            SYOrderDetailsModel *detailModel = model.gifOrderDetails[i];
            CGFloat h=[SYOrderDetailsCell4 getSYOrderDetailsCell4Higtt:detailModel];
            hight=hight+h;
        }
    
    }
    return hight;
}
+(CGFloat)getNumberSYOrderDetailsCell4GiftsHight:(NSInteger)count andModel:(OrderListModel *)model{
    CGFloat hight=35;
    NSInteger ordersCount=model.gifOrderDetails.count;
    NSInteger cc=count>ordersCount?ordersCount:count;
    for (int i=0; i<cc; i++) {
        SYOrderDetailsModel *detailModel = model.gifOrderDetails[i];
        CGFloat h=[SYOrderDetailsCell4 getSYOrderDetailsCell4Higtt:detailModel];
        hight=hight+h;
    }
    return hight;
}


#pragma mark -SYOrderDetailsCell4Delegate
-(void)activityButtonClick:(SYOrderDetailsModel *)model{
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderDetailsCell44ActivityButtonClick:)]) {
        [self.delegate orderDetailsCell44ActivityButtonClick:model];
    }
}
-(void)tapSYOrderDetailsCell4:(SYOrderDetailsModel *)model{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapSYOrderDetailsCell4Click:)]) {
        [self.delegate tapSYOrderDetailsCell4Click:model];
    }

}
@end
