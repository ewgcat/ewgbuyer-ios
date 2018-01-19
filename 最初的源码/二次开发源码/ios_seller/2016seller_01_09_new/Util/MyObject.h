//
//  MyObject.h
//  SellerApp
//
//  Created by shiyuwudi on 15/12/23.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MyObject;

typedef void(^SYCompletionBlock)(void);

@protocol MyObjectDelegate <NSObject>

-(void)bottomTableDidEndDecelating:(MyObject *)myObj;

@end

@interface MyObject : UIView


#pragma mark - 无数据视图
+(void)noDataViewIn:(UIView *)superview;
+(UIView *)noDataView;
+(UIView *)noDataViewOffset:(CGFloat)y;
+(UIView *)noDataViewForTableView:(UITableView *)tableView;

#pragma mark - 遮罩和提示相关
+(void)startLoading;
+(void)endLoading;

+(void)startLoadingWithTitle:(NSString *)title;
+(void)startLoadingInSuperview:(UIView *)superview;

+(void)failedPrompt1:(NSString *)title;
+(void)failedPrompt:(NSString *)title;
+(void)failedPrompt:(NSString *)title complete:(SYCompletionBlock)completion;
+(void)failedPromptInSuperView:(UIView *)superView title:(NSString *)title;
+(void)setGif:(NSString *)gifName;//用gif做加载图片
+(void)reset;//清理gif,用回自定义图片

#pragma mark - 自动创建顶部标签页,和配套的底部表视图
@property (nonatomic,readonly,assign)NSInteger curIndex;
@property (nonatomic, weak)id<MyObjectDelegate> delegate;
/**
 ****个性版||创建之后要保存为strong属性或者成员变量!表视图用tableViewArray属性访问****
 */
-(void)sy_addHeadNaviTitleArray:(NSArray *)titleArr toContainerViewWithFrameSetted:(UIView *)containerView headerHeight:(CGFloat)headerHeight topMargin:(CGFloat)topMargin testColor:(BOOL)testColor normalFontSize:(CGFloat)normalFontSize selectedFontSize:(CGFloat)selectedFontSize;
/**
 ****精简版||创建之后要保存为strong属性或者成员变量!表视图用tableViewArray属性访问****
 */
-(void)sy_addHeadNaviTitleArray:(NSArray *)titleArr toContainerViewWithFrameSetted:(UIView *)containerView;
/**
 设置当前按钮的颜色，默认是橙色
 */
-(void)sy_setSelectColor:(UIColor *)color;
/**
 设置非当前按钮的颜色，默认是灰色
 */
-(void)sy_setNormalColor:(UIColor *)color;
/**
 设置提示条的颜色，默认是橙色
 */

//设置第一个，第二个tableview
-(void)setFirstTableViewAs:(UITableView *)firstTableView;
-(void)setSecondTableViewAs:(UITableView *)secondTableView;

@property(nonatomic,strong,readonly)NSMutableArray *tableViewArray;


@end
