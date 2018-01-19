//
//  WDAlertView.h
//  My_App
//
//  Created by apple on 16/2/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickHandle)(void);
typedef void (^WDAlertViewBlock)();
typedef NS_ENUM(NSUInteger, WDAlertViewType) {
    WDAlertViewTypeOne,
    WDAlertViewTypeTwo,
    WDAlertViewTypeOneAnother
    
};


@class WDAlertView;

//WDAlertView数据源方法
@protocol WDAlertViewDatasource <NSObject>
//WDAlertView有多少行
- (NSInteger)alertListTableView:(WDAlertView *)tableView numberOfRowsInSection:(NSInteger)section;
-(CGFloat)alertListTableView:(WDAlertView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
//WDAlertView每个cell的样式
- (UITableViewCell *)alertListTableView:(WDAlertView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

//代理方法
@protocol WDAlertViewDelegate <NSObject>
//WDAlertView cell的选中
- (void)alertListTableView:(WDAlertView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
//WDAlertView cell为被选中
- (void)alertListTableView:(WDAlertView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface WDAlertView : UIView<UITableViewDataSource, UITableViewDelegate>

+ (void)showOneButtonWithTitle:(NSString *)title Message:(NSString *)message ButtonTitle:(NSString*)buttonTitle Click:(clickHandle)click;

@property (nonatomic, strong) id <WDAlertViewDatasource> datasource;
@property (nonatomic, weak) id <WDAlertViewDelegate> delegate;
//view的标题
@property (nonatomic, strong) UILabel *titleLabel;
//WDAlertView展示界面
- (void)showAlertListView;
//WDAlertView消失界面
- (void)dismiss;
//列表cell的重用
- (id)dequeueReusableAlertListCellWithIdentifier:(NSString *)identifier;
//设置确定按钮的标题，如果不设置的话，点击按钮没有响应
- (void)setDoneButtonWithBlock:(WDAlertViewBlock)block;
//如果在取消的时候也需要做一些事情的时候才设置它。不设置它的时候，只是让ZJAlertListView消失
- (void)setCancelButtonBlock:(WDAlertViewBlock)block;
- (id)initWithFrame:(CGRect)frame buttonSty:(WDAlertViewType)WDAlertViewType title:(NSString *)title  doneButtonTitle:(NSString*)donebuttonTitle andCancelButtonTitle:(NSString*)CancelbuttonTitle;



@end
