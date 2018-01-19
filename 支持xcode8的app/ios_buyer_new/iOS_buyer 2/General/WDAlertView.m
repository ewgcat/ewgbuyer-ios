//
//  WDAlertView.m
//  My_App
//
//  Created by apple on 16/2/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WDAlertView.h"
#import <Accelerate/Accelerate.h>

static char * const alertListViewButtonClickForDone = "alertListViewButtonClickForDone";
static char * const alertListViewButtonClickForcancel = "alertListViewButtonClickForcancel";
static CGFloat ZJCustomButtonHeight = 50;
static UIButton *_cover;
static WDAlertViewBlock _block;


#define JCColor(r, g, b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]
#define JCScreenWidth [UIScreen mainScreen].bounds.size.width
#define JCScreenHeight [UIScreen mainScreen].bounds.size.height
#define JCAlertViewWidth 280
#define JCAlertViewHeight 174
#define JCAlertViewMaxHeight 440
#define JCMargin 8
#define JCButtonHeight 40
//#define JCAlertViewTitleLabelHeight 50
#define JCAlertViewTitleLabelHeight 60
#define JCAlertViewTitleColor JCColor(65, 65, 65)
#define JCAlertViewTitleFont [UIFont boldSystemFontOfSize:17]
#define JCAlertViewContentColor JCColor(102, 102, 102)
#define JCAlertViewContentFont [UIFont systemFontOfSize:16]
#define JCAlertViewContentHeight (JCAlertViewHeight - JCAlertViewTitleLabelHeight - JCButtonHeight - JCMargin * 2)
#define JCiOS7OrLater ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)


@class WDViewController;

@interface WDAlertView ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSString *buttons;
@property (nonatomic, strong) clickHandle clicks;
@property (nonatomic, weak) WDViewController *vc;
@property (nonatomic, strong) UIImageView *screenShotView;

@property (nonatomic, strong) UITableView *mainAlertListView;                 //列表视图
@property (nonatomic, strong) UIButton *doneButton;                           //确定按钮
@property (nonatomic, strong) UIButton *cancelButton;                         //取消按钮

- (void)setup;

@end

@interface wdSingleTon : NSObject

@property (nonatomic, strong) UIWindow *backgroundWindow;
@property (nonatomic, weak) UIWindow *oldKeyWindow;
@property (nonatomic, strong) NSMutableArray *alertStack;
@property (nonatomic, strong) WDAlertView *previousAlert;

@end

@implementation wdSingleTon

+ (instancetype)shareSingleTon{
    static wdSingleTon *shareSingleTonInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareSingleTonInstance = [wdSingleTon new];
    });
    return shareSingleTonInstance;
}

- (UIWindow *)backgroundWindow{
    if (!_backgroundWindow) {
        _backgroundWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundWindow.windowLevel = UIWindowLevelStatusBar - 1;
    }
    return _backgroundWindow;
}

- (NSMutableArray *)alertStack{
    if (!_alertStack) {
        _alertStack = [NSMutableArray array];
    }
    return _alertStack;
    
}

@end

@interface WDViewController : UIViewController

@property (nonatomic, strong) UIImageView *screenShotView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, weak) WDAlertView *alertView;

@end
@implementation WDViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self addScreenShot];
    [self addCoverView];
    [self addAlertView];
}

- (void)addScreenShot{
    UIWindow *screenWindow = [UIApplication sharedApplication].windows.firstObject;
    UIGraphicsBeginImageContext(screenWindow.frame.size);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *originalImage = nil;
    if (JCiOS7OrLater) {
        originalImage = viewImage;
    } else {
        originalImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(viewImage.CGImage, CGRectMake(0, 20, 320, 460))];
    }
    
    int boxSize = 40;
    boxSize = boxSize - (boxSize % 2) + 1;
    NSData *imageData = UIImageJPEGRepresentation(originalImage, 1);
    UIImage *tmpImage = [UIImage imageWithData:imageData];
    CGImageRef img = tmpImage.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *CGImageGetHeight(img));
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    NSInteger windowR = boxSize/2;
    CGFloat sig2 = windowR / 3.0;
    if(windowR>0){ sig2 = -1/(2*sig2*sig2); }
    int16_t *kernel = (int16_t*)malloc(boxSize*sizeof(int16_t));
    int32_t  sum = 0;
    for(NSInteger i=0; i<boxSize; ++i){
        kernel[i] = 255*exp(sig2*(i-windowR)*(i-windowR));
        sum += kernel[i];
    }
    free(kernel);
    error = vImageConvolve_ARGB8888(&inBuffer, &outBuffer,NULL, 0, 0, kernel, boxSize, 1, sum, NULL, kvImageEdgeExtend);
    error = vImageConvolve_ARGB8888(&outBuffer, &inBuffer,NULL, 0, 0, kernel, 1, boxSize, sum, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error blur %ld", error);
    }
    outBuffer = inBuffer;
    CGColorSpaceRef colorSpace =CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGBitmapAlphaInfoMask &kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef =CGBitmapContextCreateImage(ctx);
    UIImage *blurImage = [UIImage imageWithCGImage:imageRef];
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    self.screenShotView = [[UIImageView alloc] initWithImage:blurImage];
    
    [self.view addSubview:self.screenShotView];
}

- (void)addCoverView{
    self.coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.coverView.backgroundColor = JCColor(5, 0, 10);
    [self.view addSubview:self.coverView];
}

- (void)addAlertView{
    [self.alertView setup];
    [self.view addSubview:self.alertView];
}

- (void)showAlert{
    CGFloat duration = 0.3;
    
    for (UIButton *btn in self.alertView.subviews) {
        btn.userInteractionEnabled = NO;
    }
    
    self.screenShotView.alpha = 0;
    self.coverView.alpha = 0;
    self.alertView.alpha = 0;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.screenShotView.alpha = 1;
        self.coverView.alpha = 0.65;
        self.alertView.alpha = 1.0;
    } completion:^(BOOL finished) {
        for (UIButton *btn in self.alertView.subviews) {
            btn.userInteractionEnabled = YES;
        }
    }];
    
    if (JCiOS7OrLater) {
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.values = @[@(0.8), @(1.05), @(1.1), @(1)];
        animation.keyTimes = @[@(0), @(0.3), @(0.5), @(1.0)];
        animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        animation.duration = duration;
        [self.alertView.layer addAnimation:animation forKey:@"bouce"];
    } else {
        self.alertView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [UIView animateWithDuration:duration * 0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.alertView.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:duration * 0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.alertView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:duration * 0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.alertView.transform = CGAffineTransformMakeScale(1, 1);
                } completion:nil];
            }];
        }];
    }
}

- (void)hideAlertWithCompletion:(void(^)(void))completion{
    CGFloat duration = 0.2;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.coverView.alpha = 0;
        self.screenShotView.alpha = 0;
        self.alertView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.screenShotView removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(0.4, 0.4);
    } completion:nil];
}

@end

@implementation WDAlertView
//样式1，单按钮滚动text
+ (void)showOneButtonWithTitle:(NSString *)title Message:(NSString *)message ButtonTitle:(NSString*)buttonTitle Click:(clickHandle)click{
    WDAlertView *alertView = [WDAlertView new];
    [alertView configAlertViewPropertyWithTitle:title Message:message ButtonTitle:buttonTitle Clicks:click];
}

- (void)configAlertViewPropertyWithTitle:(NSString *)title Message:(NSString *)message ButtonTitle:(NSString *)buttonTitle Clicks:(clickHandle)clicks{
    self.title = title;
    self.message = message;
    self.buttons = buttonTitle;
    self.clicks = clicks;
   
    
    [self show];
}
- (void)show{
    [wdSingleTon shareSingleTon].oldKeyWindow = [UIApplication sharedApplication].keyWindow;
    
    WDViewController *vc = [[WDViewController alloc] init];
    vc.alertView = self;
    self.vc = vc;
    
    [wdSingleTon shareSingleTon].backgroundWindow.frame = [UIScreen mainScreen].bounds;
    [[wdSingleTon shareSingleTon].backgroundWindow makeKeyAndVisible];
    [wdSingleTon shareSingleTon].backgroundWindow.rootViewController = self.vc;
    
    WDAlertView *previousAlert = [wdSingleTon shareSingleTon].previousAlert;
    if (previousAlert) {
        [[wdSingleTon shareSingleTon].alertStack addObject:previousAlert];
    }
    
    [self.vc showAlert];
    
    [wdSingleTon shareSingleTon].previousAlert = self;
}
- (void)setup{
    if (self.subviews.count > 0) {
        return;
    }
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:4.0];
    
    self.frame = CGRectMake(0, 0, JCAlertViewWidth, JCAlertViewHeight);
//    NSInteger count = self.buttons.count;
    
//    if (count > 2) {
//        self.frame = CGRectMake(0, 0, JCAlertViewWidth, JCAlertViewTitleLabelHeight + JCAlertViewContentHeight + JCMargin + (JCMargin + JCButtonHeight) * count);
//    }
    self.center = CGPointMake(JCScreenWidth / 2, JCScreenHeight / 2);
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(JCMargin, 0, JCAlertViewWidth - JCMargin * 2, JCAlertViewTitleLabelHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = self.title;
    titleLabel.textColor = JCAlertViewTitleColor;
    titleLabel.font = JCAlertViewTitleFont;
    //    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.numberOfLines=2;
    [self addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(JCMargin, JCAlertViewTitleLabelHeight, JCAlertViewWidth - JCMargin * 2, JCAlertViewContentHeight)];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.text = self.message;
    contentLabel.textColor = JCAlertViewContentColor;
    contentLabel.font = JCAlertViewContentFont;
    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:contentLabel];
    
    CGFloat contentHeight = [contentLabel sizeThatFits:CGSizeMake(JCAlertViewWidth, CGFLOAT_MAX)].height;
    
    if (contentHeight > JCAlertViewContentHeight) {
        [contentLabel removeFromSuperview];
        
        UITextView *contentView = [[UITextView alloc] initWithFrame:CGRectMake(JCMargin, JCAlertViewTitleLabelHeight, JCAlertViewWidth - JCMargin * 2, JCAlertViewContentHeight)];
        contentView.backgroundColor = [UIColor clearColor];
        contentView.text = self.message;
        contentView.textColor = JCAlertViewContentColor;
        contentView.font = JCAlertViewContentFont;
        contentView.editable = NO;
        if (JCiOS7OrLater) {
            contentView.selectable = NO;
        }
        [self addSubview:contentView];
        
        CGFloat realContentHeight = 0;
        if (JCiOS7OrLater) {
            [contentView.layoutManager ensureLayoutForTextContainer:contentView.textContainer];
            CGRect textBounds = [contentView.layoutManager usedRectForTextContainer:contentView.textContainer];
            CGFloat height = (CGFloat)ceil(textBounds.size.height + contentView.textContainerInset.top + contentView.textContainerInset.bottom);
            realContentHeight = height;
        }else {
            realContentHeight = contentView.contentSize.height;
        }
        
        if (realContentHeight > JCAlertViewContentHeight) {
            CGFloat remainderHeight = JCAlertViewMaxHeight - JCAlertViewTitleLabelHeight - JCMargin - (JCMargin + JCButtonHeight);
            contentHeight = realContentHeight;
            if (realContentHeight > remainderHeight) {
                contentHeight = remainderHeight;
            }
            
            CGRect frame = contentView.frame;
            frame.size.height = contentHeight;
            contentView.frame = frame;
            
            CGRect selfFrame = self.frame;
            selfFrame.size.height = selfFrame.size.height + contentHeight - JCAlertViewContentHeight;
            self.frame = selfFrame;
            self.center = CGPointMake(JCScreenWidth / 2, JCScreenHeight / 2);
        }
    }
    if (!JCiOS7OrLater) {
        CGRect frame = self.frame;
        frame.origin.y -= 10;
        self.frame = frame;
    }
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - JCButtonHeight - JCMargin*2, JCAlertViewWidth, 1)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    [self addSubview:lineView];

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(JCMargin, self.frame.size.height - JCButtonHeight - JCMargin, JCAlertViewWidth - JCMargin * 2, JCButtonHeight)];
    [btn setTitle:self.buttons forState:UIControlStateNormal];
    //        [self setButton:btn BackgroundWithButonType:[[btnDict.allKeys firstObject] integerValue]];
    btn.titleLabel.font=[UIFont systemFontOfSize:22];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self addSubview:btn];
    btn.tag = 0;
    [btn addTarget:self action:@selector(alertBtnClick:) forControlEvents:UIControlEventTouchUpInside];

}
- (void)alertBtnClick:(UIButton *)btn{
    [self dismissAlert];
    clickHandle handle = self.clicks;
    if (handle) {
        handle();
    }
}
- (void)dismissAlert{
    [self.vc hideAlertWithCompletion:^{
        [self stackHandle];
    }];
}
- (void)stackHandle{
    [[wdSingleTon shareSingleTon].alertStack removeObject:self];
    WDAlertView *lastAlert = [wdSingleTon shareSingleTon].alertStack.lastObject;
    [wdSingleTon shareSingleTon].previousAlert = nil;
    if (lastAlert) {
        [lastAlert show];
    } else {
        [self toggleKeyWindow];
    }
}
- (void)toggleKeyWindow{
    [[wdSingleTon shareSingleTon].oldKeyWindow makeKeyAndVisible];
    [wdSingleTon shareSingleTon].backgroundWindow.rootViewController = nil;
    [wdSingleTon shareSingleTon].backgroundWindow.frame = CGRectZero;
}
//样式二 多按钮列表视图
- (id)initWithFrame:(CGRect)frame buttonSty:(WDAlertViewType)WDAlertViewType title:(NSString *)title  doneButtonTitle:(NSString*)donebuttonTitle andCancelButtonTitle:(NSString*)CancelbuttonTitle
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initTheInterfaceButtonSty:WDAlertViewType title:title doneButtonTitle:donebuttonTitle andCancelButtonTitle:CancelbuttonTitle];
    }
    return self;
}

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self initTheInterface];
//    }
//    return self;
//}
//对弹框的布局
-(void)initTheInterfaceButtonSty:(WDAlertViewType)WDType title:(NSString *)title  doneButtonTitle:(NSString*)donebuttonTitle andCancelButtonTitle:(NSString*)CancelbuttonTitle{
    self.backgroundColor=UIColorFromRGB(0Xf5f5f5);
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 10.0f;
    self.clipsToBounds = TRUE;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor blackColor];
    CGFloat xWidth = self.bounds.size.width;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel.frame = CGRectMake(0, 0, xWidth, ZJCustomButtonHeight);
    self.titleLabel.text=title;
    [self addSubview:self.titleLabel];
    
    CGRect tableFrame = CGRectMake(0, ZJCustomButtonHeight, xWidth, self.bounds.size.height - 2 * ZJCustomButtonHeight);
    _mainAlertListView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    _mainAlertListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainAlertListView.dataSource = self;
    self.mainAlertListView.delegate = self;
    [self addSubview:self.mainAlertListView];
    
    if (WDType ==WDAlertViewTypeTwo) {
        CGRect doneBtn = CGRectMake(0, self.bounds.size.height - ZJCustomButtonHeight, self.bounds.size.width / 2.0f , ZJCustomButtonHeight);
        UIButton *doneButton = [[UIButton alloc] initWithFrame:doneBtn];
        self.doneButton = doneButton;
        [self.doneButton addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.doneButton];
        
        UILabel *donelabel=[[UILabel alloc] initWithFrame:CGRectMake(8,4, self.bounds.size.width / 2.0f-16,36)];
        donelabel.backgroundColor=[UIColor whiteColor];
        donelabel.font = [UIFont systemFontOfSize:13.0f];
        donelabel.textAlignment = NSTextAlignmentCenter;
        donelabel.textColor = [UIColor blackColor];
        donelabel.text=donebuttonTitle;
        donelabel.layer.cornerRadius = 4;
        donelabel.layer.borderWidth = 1;
        donelabel.layer.borderColor = [UIColorFromRGB(0Xefefef) CGColor];
        donelabel.layer.masksToBounds = YES;
        [self.doneButton addSubview:donelabel];
        
        CGRect cancelBtn = CGRectMake(self.bounds.size.width / 2.0f, self.bounds.size.height - ZJCustomButtonHeight, self.bounds.size.width / 2.0f - 0.5, ZJCustomButtonHeight);
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:cancelBtn];
        self.cancelButton = cancelButton;
        [self.cancelButton addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelButton];
        
        UILabel *cancelabel=[[UILabel alloc] initWithFrame:CGRectMake(8,4, self.bounds.size.width / 2.0f-16,36)];
        cancelabel.backgroundColor=UIColorFromRGB(0Xf14545);
        cancelabel.font = [UIFont systemFontOfSize:13.0f];
        cancelabel.textAlignment = NSTextAlignmentCenter;
        cancelabel.textColor = [UIColor whiteColor];
        cancelabel.text=CancelbuttonTitle;
        cancelabel.layer.cornerRadius = 4;
        cancelabel.layer.borderWidth = 1;
        cancelabel.layer.borderColor = [UIColorFromRGB(0Xefefef) CGColor];
        cancelabel.layer.masksToBounds = YES;
        [self.cancelButton addSubview:cancelabel];
        
        
    }else if (WDType ==WDAlertViewTypeOne){
        CGRect doneBtn = CGRectMake(self.bounds.size.width / 4.0f, self.bounds.size.height - ZJCustomButtonHeight, self.bounds.size.width / 2.0f , ZJCustomButtonHeight);
        UIButton *doneButton = [[UIButton alloc] initWithFrame:doneBtn];
        self.doneButton = doneButton;
        [self.doneButton addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.doneButton];
        
        UILabel *donelabel=[[UILabel alloc] initWithFrame:CGRectMake(11.5,6, self.bounds.size.width / 2.0f-16,36)];
        donelabel.backgroundColor=UIColorFromRGB(0Xf5f5f5);
        donelabel.font = [UIFont systemFontOfSize:17.0f];
        donelabel.textAlignment = NSTextAlignmentCenter;
        donelabel.textColor = UIColorFromRGB(0x007aff);
        donelabel.text=donebuttonTitle;
        [self.doneButton addSubview:donelabel];
        
        CGRect cancelBtn = CGRectMake(0,0,0,0);
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:cancelBtn];
        self.cancelButton = cancelButton;
        
    }else if (WDType ==WDAlertViewTypeOneAnother){
        
        CGRect doneBtn = CGRectMake(0, self.bounds.size.height - ZJCustomButtonHeight, self.bounds.size.width , ZJCustomButtonHeight);
        UIButton *doneButton = [[UIButton alloc] initWithFrame:doneBtn];
        doneButton.backgroundColor=[UIColor whiteColor];
        self.doneButton = doneButton;
        [self.doneButton addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.doneButton];
        
        UILabel *donelabel=[[UILabel alloc] initWithFrame:CGRectMake(15,5, self.bounds.size.width-30,39)];
        donelabel.backgroundColor=UIColorFromRGB(0Xf15353);
        donelabel.font = [UIFont systemFontOfSize:17.0f];
        donelabel.textAlignment = NSTextAlignmentCenter;
        donelabel.textColor = [UIColor whiteColor];
        donelabel.text=donebuttonTitle;
        donelabel.layer.cornerRadius = 4;
        donelabel.layer.masksToBounds = YES;
        [self.doneButton addSubview:donelabel];
        
        CGRect cancelBtn = CGRectMake(0,0,0,0);
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:cancelBtn];
        self.cancelButton = cancelButton;
        
     
    }

}
#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.datasource && [self.datasource respondsToSelector:@selector(alertListTableView:numberOfRowsInSection:)])
    {
        return [self.datasource alertListTableView:self numberOfRowsInSection:section];
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.datasource && [self.datasource respondsToSelector:@selector(alertListTableView:cellForRowAtIndexPath:)])
    {
        return [self.datasource alertListTableView:self heightForRowAtIndexPath:indexPath];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datasource && [self.datasource respondsToSelector:@selector(alertListTableView:cellForRowAtIndexPath:)])
    {
        return [self.datasource alertListTableView:self cellForRowAtIndexPath:indexPath];
    }
    return nil;
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertListTableView:didDeselectRowAtIndexPath:)])
    {
        [self.delegate alertListTableView:self didDeselectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertListTableView:didSelectRowAtIndexPath:)])
    {
        [self.delegate alertListTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - Animated Mthod
- (void)animatedIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)animatedOut
{
    [UIView animateWithDuration:.35 animations:^{
        [self removeFromSuperview];
        [_cover removeFromSuperview];
        _cover = nil;
    }];
}
- (void)showAlertListView
{
    UIWindow *keywindow = [[UIApplication sharedApplication].windows lastObject];
    keywindow.windowLevel = UIWindowLevelNormal;
    
    // 遮盖
    UIButton *cover = [[UIButton alloc] init];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.4;
    [cover addTarget:self action:@selector(animatedOut) forControlEvents:UIControlEventTouchUpInside];
    cover.frame = [UIScreen mainScreen].bounds;
    _cover = cover;
    
    [keywindow addSubview:cover];
    [keywindow addSubview:self];
    
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,
                              keywindow.bounds.size.height/2.0f);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self tableView:self.mainAlertListView didSelectRowAtIndexPath:indexPath];
    
    [self animatedIn];
}

- (void)dismiss
{
    [self animatedOut];
}

- (id)dequeueReusableAlertListCellWithIdentifier:(NSString *)identifier
{
    return [self.mainAlertListView dequeueReusableCellWithIdentifier:identifier];
}

- (UITableViewCell *)alertListCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.mainAlertListView reloadData];
    return [self.mainAlertListView cellForRowAtIndexPath:indexPath];
}

- (void)setDoneButtonWithBlock:(WDAlertViewBlock)block
{
    objc_setAssociatedObject(self.doneButton, alertListViewButtonClickForDone, [block copy], OBJC_ASSOCIATION_RETAIN);
}

- (void)setCancelButtonBlock:(WDAlertViewBlock)block{
    objc_setAssociatedObject(self.cancelButton, alertListViewButtonClickForcancel, [block copy], OBJC_ASSOCIATION_RETAIN);
}
#pragma mark - UIButton Clicke Method
- (void)buttonWasPressed:(id)sender
{
    WDAlertViewBlock __block block;
    UIButton *button = (UIButton *)sender;
    if (button == self.doneButton){
        
        block = objc_getAssociatedObject(sender, alertListViewButtonClickForDone);
        
    }else if(button == self.cancelButton){
        
        block = objc_getAssociatedObject(sender, alertListViewButtonClickForcancel);
        
    }
    if (block){
        block();
    }
}

- (void)touchForDismissSelf:(id)sender
{
    [self animatedOut];
}

@end
