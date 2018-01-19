//
//  SYObject.m
//  My_App
//  这个类中封装了一些方便的创建视图的方法
//  Created by shiyuwudi on 15/11/10.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import "SYObject.h"
#import "EvaModel.h"
#import <ImageIO/ImageIO.h>
#import "LoginViewController.h"
#import "SecondViewController.h"
#import "DetailViewController.h"
#import "NewLoginViewController.h"
#import "OrderListViewController.h"
#import "PaySuccessViewController.h"

#define IMG_COUNT 30 //自定义图片数量
#define IMG_NAME_PREFIX @"loading"//自定义图片前缀
#define IMG_CHANGE_INTERVAL 0.045//图片更换间隔
#define toCF (__bridge CFTypeRef)//cf桥接
#define COVER_TIMEOUT 30//遮罩超时

#define TEXT_FIELD_WIDTH_RATE 0.7
#define TEXT_FIELD_CORNER_REDIUS 4.f
#define LABEL_TEXT_COLOR [UIColor colorWithRed:147.f/255.f green:147.f/255.f blue:147.f/255.f alpha:1]
#define TEXT_FIELD_HEIGHT_RATE 0.6
#define TEXT_FIELD_BORDER_COLOR [UIColor colorWithRed:225.f/255.f green:225.f/255.f blue:225.f/255.f alpha:1]
#define BOTTOM_BTN_TITLE_FONT [UIFont systemFontOfSize:12.f]

@interface SYObject ()<UIScrollViewDelegate>

#pragma mark - 组件相关变量
@property (nonatomic,weak)UIButton *currentBtn;
@property (nonatomic,weak)UIScrollView *headNaviView;
@property (nonatomic,weak)UIScrollView *bottomScrollView;
@property (nonatomic,strong)NSArray *titleArr;
@property (nonatomic,assign)CGFloat w;
@property (nonatomic,strong)NSMutableArray *btnArr;
@property (nonatomic,weak)UIView *orangeBar;
@property (nonatomic,strong)NSArray *btnWArr;
@property (nonatomic,strong)NSArray *btnXArr;
@property (nonatomic,assign)BOOL isFewTitle;
@property (nonatomic,assign)CGFloat ratio;
@property (nonatomic,assign)CGFloat normalFontSize;
@property (nonatomic,assign)CGFloat selectedFontSize;

#pragma mark - 遮罩相关变量
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIImageView *bgView1;
@property (weak, nonatomic) IBOutlet UILabel *labelTi;

@property (copy, nonatomic)SYCompletionBlock completion;

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic)NSInteger count;
@property (nonatomic, strong)NSArray *imageArray;

@property (nonatomic,copy)NSString *gifName;
@property (nonatomic, copy)NSString *gifPath;
@property (nonatomic, assign)NSInteger gifCount;
@property (nonatomic, strong)NSArray *gifImagesArray;

@end

@implementation SYObject
+(void)loginActionInViewController:(UIViewController *)viewController action:(SYCompletionBlock)action {
    if (action == nil) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([SYObject currentUserID]) {
            action();
        }else{
            [SYObject failedPrompt:@"请先登录" complete:^{
                [viewController.navigationController pushViewController:[NewLoginViewController new] animated:true];
            }];
        }
    });
    
}
+(NSString *)toStr:(NSInteger)num {
    return [NSString stringWithFormat:@"%ld",(long)num];
}
+(UIViewController *)VCFromUsercenterStoryboard:(NSString *)name{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"usercenterStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:name];
    return vc;
}
#pragma mark - 旧代码抽象出来的方法
+(CGRect)orderCellImgFrameAtIndex:(NSInteger)index{
    return CGRectMake(15+88*index, 10, 78, 78);
}
#pragma mark - 遮罩
//初始化设置
-(void)awakeFromNib{
    [super awakeFromNib];

    self.count = -1;
    self.labelTi.layer.cornerRadius = self.labelTi.bounds.size.height * 0.5;
    [self.labelTi.layer setMasksToBounds:YES];
    self.labelTi.hidden = YES;
    self.bgView1.hidden = YES;
}
//gif路径和数量懒加载
-(NSString *)gifPath{
    if (!_gifPath&&_gifName) {
        _gifPath = [[NSBundle mainBundle]pathForResource:self.gifName ofType:@"gif"];
    }
    return _gifPath;
}
-(NSInteger)gifCount{
    if (_gifCount==0) {
        NSURL *url = [[NSBundle mainBundle]URLForResource:self.gifName withExtension:@"gif"];
        CGImageSourceRef source = CGImageSourceCreateWithURL(toCF url, NULL);
        size_t const count = CGImageSourceGetCount(source);
        CFRelease(source);
        _gifCount = count;
    }
    return _gifCount;
}
//主要方法
+(void)reset{
    [self setGif:nil];
}
+(void)setGif:(NSString *)gifName{
    //清空懒加载数据
    [self sharedView].gifCount = 0;
    [self sharedView].gifPath = nil;
    [self sharedView].gifImagesArray = nil;
    //重置计数器
    [self sharedView].count = -1;
    //赋值
    [self sharedView].gifName = gifName;
}
-(NSArray *)imagesSplitFromGIF{
    NSMutableArray *tempArr = [NSMutableArray array];
    NSURL *url = [[NSBundle mainBundle]URLForResource:self.gifName withExtension:@"gif"];
    //此处CF类型的url用的是桥接，所以不用释放
    CGImageSourceRef source = CGImageSourceCreateWithURL(toCF url, NULL);
    size_t const count = CGImageSourceGetCount(source);
    for (size_t i = 0; i < count; i++) {
        CGImageRef cfImage = CGImageSourceCreateImageAtIndex(source, i, NULL);
        UIImage *uiImage = [UIImage imageWithCGImage:cfImage];
        [tempArr addObject:uiImage];
        //释放图片(不然内存暴涨!!别问我怎么知道的...)
        CFRelease(cfImage);
    }
    //释放图片源
    CFRelease(source);
    return tempArr;
}
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}
+(void)failedPrompt:(NSString *)title{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
        [self failedPromptInSuperView:root.view title:title];
    });
}
+(void)failedPrompt:(NSString *)title complete:(SYCompletionBlock)completion{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self sharedView1].completion = completion;
        [self failedPrompt:title];
    });
}
+(void)failedPromptInSuperView:(UIView *)superView title:(NSString *)title complete:(SYCompletionBlock)completion{
    [self sharedView1].completion = completion;
    [self failedPromptInSuperView:superView title:title];
}

+(void)failedPromptInSuperView:(UIView *)superView title:(NSString *)title{
    if (!title||[title isEqualToString:@""]) {
        return;
    }
    NSString *fatStr = [NSString stringWithFormat:@" %@  ",title];
    [self sharedView1].labelTi.text = fatStr;
    [self sharedView1].frame = superView.bounds;
    [superView addSubview:[self sharedView1]];
    [[self sharedView1]showMessage];
}
-(void)hideKeyboard{
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [root.view endEditing:YES];
}
-(void)showMessage{
    [self hideKeyboard];
    self.labelTi.hidden = NO;
    self.labelTi.alpha = 1;
    [self hideMessage];
}
-(void)hideMessage{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.0 animations:^{
            self.labelTi.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            if (self.completion) {
                self.completion();
            }
        }];
    });
}
+(void)startLoading{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self sharedView].contentView.hidden = NO;
        [self sharedView].bgView.hidden = NO;
        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
        [self startLoadingInSuperview:root.view];
    });
}
+(void)endLoading{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self sharedView].timer.isValid) {
            [[self sharedView].timer invalidate];
        }
        [[self sharedView] removeFromSuperview];
    });
}
+(void)startLoadingWithTitle:(NSString *)title{
    [self sharedView].statusLabel.text = title;
    [self startLoading];
}
+(void)startLoadingInSuperview:(UIView *)superview{
    [self sharedView].frame = superview.bounds;
    [superview addSubview:[self sharedView]];
    [[self sharedView]startAnimating];
}
+(void)startInfinitLoading{
    [self sharedView].contentView.hidden = NO;
    [self sharedView].bgView.hidden = NO;
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [self startInfinitLoadingInSuperview:root.view];
}
+(void)startInfinitLoadingInSuperview:(UIView *)superview{
    [self sharedView].frame = superview.bounds;
    [superview addSubview:[self sharedView]];
    [[self sharedView]startInfiniteAnimating];
}
-(void)startInfiniteAnimating{
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:IMG_CHANGE_INTERVAL target:self selector:@selector(switchImage) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    [timer fire];
}
-(void)startAnimating{
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:IMG_CHANGE_INTERVAL target:self selector:@selector(switchImage) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    [timer fire];
    [self performSelector:@selector(checkTimeout) withObject:nil afterDelay:COVER_TIMEOUT];
}
-(void)checkTimeout{
    if (self.timer.isValid) {
        [self.timer invalidate];
        [self removeFromSuperview];
    }
}
-(void)switchImage{
    UIImage *newImage = [self getNextImage];
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        [self.imageView setImage:newImage];
    });
}
-(UIImage *)getNextImage{
    NSInteger newCount = self.count + 1;
    NSInteger overCount;
    if (self.gifPath) {
        //gif
        overCount = self.gifCount;
    }else {
        //自定义多张图片
        overCount = IMG_COUNT;
    }
    
    if (newCount == overCount) {
        newCount = 0;
    }
    UIImage *newImg;
    if (self.gifPath) {
        //gif
        newImg = self.gifImagesArray[newCount];
    }else{
        //自定义多张图片
        newImg = self.imageArray[newCount];
    }
    self.count = newCount;
    return newImg;
}
//从xib加载单例视图
+(SYObject *)sharedView
{
    static SYObject *sharedView = nil;
    if(sharedView==nil){
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        UINib *nib = [UINib nibWithNibName:@"ProgressView" bundle:bundle];
        NSArray *nibViews = [nib instantiateWithOwner:self options:0];
        sharedView = nibViews[0];
        sharedView.loadingView.layer.cornerRadius = 9.f;
        sharedView.loadingView.layer.masksToBounds = YES;
    }
    return sharedView;
}
+(SYObject *)sharedView1
{
    static SYObject *sharedView1 = nil;
    if(sharedView1==nil){
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        UINib *nib = [UINib nibWithNibName:@"ProgressView11" bundle:bundle];
        NSArray *nibViews = [nib instantiateWithOwner:self options:0];
        sharedView1 = nibViews[0];
    }
    return sharedView1;
}
//图片数组懒加载
-(NSArray *)imageArray{
    if (!_imageArray) {
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        for (int i= 0; i < IMG_COUNT; i++) {
            NSString *picName = [NSString stringWithFormat:@"%@%d",IMG_NAME_PREFIX,i];
            UIImage *img = [UIImage imageNamed:picName];
            [tempArr addObject:img];
        }
        _imageArray = tempArr;
    }
    return _imageArray;
}
-(NSArray *)gifImagesArray{
    if (!_gifImagesArray) {
        _gifImagesArray = [self imagesSplitFromGIF];
    }
    return _gifImagesArray;
}
#pragma mark - 商城
+(void)checkLogin:(UINavigationController *)navigationController s:(void (^)(BOOL))ret{
    //压根没登陆的情况
    BOOL login;
    [SYObject hasUserLogedIn:&login];
    if (login) {
        
    }else{
        NewLoginViewController *loginVC = [[NewLoginViewController alloc]init];
        [navigationController pushViewController:loginVC animated:YES];
        return;
    }
    //被顶的情况
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,USER_CENTER_URL];
    NSDictionary *par = [Requester userDictWithIDAndToken];
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict [@"ret"] isEqualToString:@"true"]){
            //用户登录有效
            ret(YES);
        }else{
            ret(NO);
            //如果没有登录，则跳转登录页面
            NewLoginViewController *loginVC = [[NewLoginViewController alloc]init];
            [navigationController pushViewController:loginVC animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ;
    }];
}
+(void)redirectAfterPayment:(UINavigationController *)navigationController orderNum:(NSDictionary *)userInfo{
    NSArray *old = navigationController.viewControllers;
    NSMutableArray *new = [old mutableCopy];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SYOrderStoryboard" bundle:nil];
    PaySuccessViewController *psVC = [sb instantiateViewControllerWithIdentifier:@"PaySuccess"];
    //设置内容
    psVC.userInfo = userInfo;
    [new insertObject:psVC atIndex:1];
    [navigationController setViewControllers:new animated:YES];
    [navigationController popToViewController:psVC animated:YES];
}
+(void)redirectAfterPayment:(UINavigationController *)navigationController orderNum:(NSDictionary *)userInfo orderType:(NSString *)orderType{
    NSArray *old = navigationController.viewControllers;
    NSMutableArray *new = [old mutableCopy];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SYOrderStoryboard" bundle:nil];
    PaySuccessViewController *psVC = [sb instantiateViewControllerWithIdentifier:@"PaySuccess"];
    //设置内容
    psVC.userInfo = userInfo;
    psVC.orderType = orderType;
    [new insertObject:psVC atIndex:1];
    [navigationController setViewControllers:new animated:YES];
    [navigationController popToViewController:psVC animated:YES];
}
+(void)redirectAfterPayment:(UINavigationController *)navigationController nameNphone:(NSString *)nameNphone address:(NSString *)address realprice:(NSString *)realprice{
    NSArray *old = navigationController.viewControllers;
    NSMutableArray *new = [old mutableCopy];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SYOrderStoryboard" bundle:nil];
    PaySuccessViewController *psVC = [sb instantiateViewControllerWithIdentifier:@"PaySuccess"];
    //设置内容
    psVC.usernameAndPhone = nameNphone;
    psVC.address = address;
    psVC.realPrice = realprice;
    psVC.payOnDel = NO;
    psVC.orderType=@"goods";
    [new insertObject:psVC atIndex:1];
    [navigationController setViewControllers:new animated:YES];
    [navigationController popToViewController:psVC animated:YES];
}



#pragma mark -兑换积分商品成功之后


+(void)integralAfterPayment:(UINavigationController *)navigationController orderNum:(NSDictionary *)userInfo orderType:(NSString *)orderType{
    NSArray *old = navigationController.viewControllers;
    NSMutableArray *new = [old mutableCopy];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SYOrderStoryboard" bundle:nil];
    PaySuccessViewController *psVC = [sb instantiateViewControllerWithIdentifier:@"PaySuccess"];
    //设置内容
    psVC.userInfo = userInfo;
    psVC.orderType = orderType;
    [new insertObject:psVC atIndex:1];
    [navigationController setViewControllers:new animated:YES];
    [navigationController popToViewController:psVC animated:YES];
}
//+(void)redirectAfterPayment:(UINavigationController *)navigationController orderId:(NSString *)orderId {
//    NSArray *old = navigationController.viewControllers;
//    NSMutableArray *new = [old mutableCopy];
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SYOrderStoryboard" bundle:nil];
//    PaySuccessViewController *psVC = [sb instantiateViewControllerWithIdentifier:@"PaySuccess"];
//    //设置内容
////    psVC.usernameAndPhone.
////    psVC.address = address;
////    psVC.realPrice = realprice;
//    psVC.payOnDel = NO;
//    psVC.orderType=@"goods";
//    [new insertObject:psVC atIndex:1];
//    [navigationController setViewControllers:new animated:YES];
//    [navigationController popToViewController:psVC animated:YES];
//}
//vip升级成功
+(void)redirectvip:(UINavigationController *)navigationController nameNphone:(NSString *)nameNphone address:(NSString *)address realprice:(NSString *)realprice{
    NSArray *old = navigationController.viewControllers;
    NSMutableArray *new = [old mutableCopy];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SYOrderStoryboard" bundle:nil];
    PaySuccessViewController *psVC = [sb instantiateViewControllerWithIdentifier:@"PaySuccess"];
    //设置内容
    psVC.usernameAndPhone = @"升级成功";
    psVC.address = @"";
    psVC.realPrice = realprice;
    psVC.payOnDel = NO;
    psVC.orderType=@"ios";
    [new insertObject:psVC atIndex:1];
    [navigationController setViewControllers:new animated:YES];
    [navigationController popToViewController:psVC animated:YES];
}
+(void)redirectPurchaseOfCloud:(UINavigationController *)navigationController nameNphone:(NSString *)nameNphone address:(NSString *)address realprice:(NSString *)realprice{
    NSArray *old = navigationController.viewControllers;
    NSMutableArray *new = [old mutableCopy];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SYOrderStoryboard" bundle:nil];
    PaySuccessViewController *psVC = [sb instantiateViewControllerWithIdentifier:@"PaySuccess"];
    //设置内容
    psVC.usernameAndPhone = nameNphone;
    psVC.address = address;
    psVC.realPrice = realprice;
    psVC.payOnDel = NO;
    psVC.orderType=@"cloudpurchase";
    [new insertObject:psVC atIndex:1];
    [navigationController setViewControllers:new animated:YES];
    [navigationController popToViewController:psVC animated:YES];
}

+(void)redirectAfterPayOnDel:(UINavigationController *)navigationController nameNphone:(NSString *)nameNphone address:(NSString *)address realprice:(NSString *)realprice{
    NSArray *old = navigationController.viewControllers;
    NSMutableArray *new = [old mutableCopy];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SYOrderStoryboard" bundle:nil];
    PaySuccessViewController *psVC = [sb instantiateViewControllerWithIdentifier:@"PaySuccess"];
    //设置内容
    psVC.usernameAndPhone = nameNphone;
    psVC.address = address;
    psVC.realPrice = realprice;
    psVC.payOnDel = YES;
    [new insertObject:psVC atIndex:1];
    [navigationController setViewControllers:new animated:YES];
    [navigationController popToViewController:psVC animated:YES];
}
#pragma mark - 组件
+(UIView *)bottomViewWithButtonTitleArray:(NSMutableArray *)btnArray resultBtnArray:(NSMutableArray *__autoreleasing *)resultArray{
    UIView *bottomView = [UIView new];
    CGFloat bottomH = 44;
    bottomView.frame = CGRectMake(0, ScreenFrame.size.height-bottomH, ScreenFrame.size.width, bottomH);
    bottomView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.6];
    
    *resultArray = [NSMutableArray array];
    for (int i = 0; i < btnArray.count; i ++) {
        UIButton *btn = [UIButton new];
        NSString *title = btnArray[i];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.backgroundColor = UIColorFromRGB(0xf15353);
        btn.layer.cornerRadius = 5.f;
        [btn.layer setMasksToBounds:YES];
        CGFloat space = 10.f;
        CGFloat w = 90.f;
        CGFloat h = 34.f;
        CGFloat y = 0.5 * (bottomView.height - h);
        CGFloat x = ScreenFrame.size.width - (i + 1) * (space + w);
        btn.frame = CGRectMake(x, y, w, h);
        [bottomView addSubview:btn];
        [*resultArray addObject:btn];
        btn.titleLabel.font = BOTTOM_BTN_TITLE_FONT;
    }
    
    return bottomView;
}
+(NSString *)orderStatusStringByCode:(NSString *)code{
    NSString *str;
    NSInteger codeInInt = code.integerValue;
    if (codeInInt==0) {
        str = @"已取消";
    }else if (codeInInt==10){
        str = @"待付款";
    }else if (codeInInt==11){
        str = @"已付定金";
    }else if (codeInInt==16){
        str = @"货到付款";
    }else if (codeInInt==20){
        str = @"待发货";
    }else if (codeInInt==21){
        str = @"已申请退款";
    }else if (codeInInt==22){
        str = @"退款中";
    }else if (codeInInt==25){
        str = @"退款完成";
    }else if (codeInInt==30){
        str = @"待收货";
    }else if (codeInInt==35){
        str = @"自提点已收货";
    }else if (codeInInt==40){
        str = @"已收货";
    }else if (codeInInt==50){
        str = @"已评价";
    }else if (codeInInt==65){
        str = @"自动评价";
    }
    
    if (!str) {
        str = @"";
    }
    return str;
}
+(NSString *)stringByNumber:(NSString *)number{
    NSString *str = [NSString stringWithFormat:@"%@",number];
    return str;
}
-(void)sy_addHeadNaviTitleArray:(NSArray *)titleArr toContainerViewWithFrameSetted:(UIView *)containerView{
    [self sy_addHeadNaviTitleArray:titleArr toContainerViewWithFrameSetted:containerView headerHeight:44.f topMargin:0.f testColor:NO normalFontSize:15.f selectedFontSize:15.f];
}
-(void)sy_setSelectColor:(UIColor *)color{
    for (UIButton *btn in _btnArr) {
        [btn setTitleColor:color forState:UIControlStateSelected];
    }
}
-(void)sy_setNormalColor:(UIColor *)color{
    for (UIButton *btn in _btnArr) {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
}
-(void)sy_setScrollIndicatorColor:(UIColor *)color{
    _orangeBar.backgroundColor = color;
}
-(void)setFirstTableViewAs:(UITableView *)firstTableView{
    //删除第一个tableView
    for (UIView *view in _bottomScrollView.subviews) {
        if ([view isKindOfClass:[UITableView class]]) {
            //再添加
            firstTableView.frame = view.frame;
            [view removeFromSuperview];
            [_tableViewArray removeObjectAtIndex:0];
            [_bottomScrollView addSubview:firstTableView];
            [_tableViewArray insertObject:firstTableView atIndex:0];
            break;
        }
    }
}
-(void)setSecondTableViewAs:(UITableView *)secondTableView{
    int num = 0;
    //删除第二个tableView
    for (int i=0;i<_bottomScrollView.subviews.count;i++){
        UIView *view = _bottomScrollView.subviews[i];
        if ([view isKindOfClass:[UITableView class]] ) {
            num ++;
            if (num == 2) {
                //再添加
                secondTableView.frame = view.frame;
                [view removeFromSuperview];
                [_tableViewArray removeObjectAtIndex:1];
                [_bottomScrollView addSubview:secondTableView];
                [_tableViewArray insertObject:secondTableView atIndex:1];
                break;
            }
        }
    }
}
-(void)disableScrolling{
    _bottomScrollView.scrollEnabled = NO;
}
-(void)sy_addWithArray:(NSArray *)titleArr toView:(UIView *)containerView{
    CGFloat headerHeight = 44.f;
    CGFloat topMargin = -44.f;
    BOOL testColor = NO;
    CGFloat normalFontSize = 15.f;
    CGFloat selectedFontSize = 15.f;
    
    _curIndex = 0;
    _normalFontSize = normalFontSize;
    _selectedFontSize = selectedFontSize;
    _titleArr = titleArr;
    CGRect frame = containerView.frame;
    CGFloat w = frame.size.width;
    _w = w;
    CGFloat h = frame.size.height;
    //控件创建，设置frame
    UIView *headNaviView = [[UIView alloc]initWithFrame:CGRectMake(0, topMargin, w, headerHeight)];
    UIScrollView *bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, headerHeight+topMargin, w, h - headerHeight)];
    _bottomScrollView = bottomScrollView;
    
//    _headNaviView = headNaviView;
    
    bottomScrollView.pagingEnabled = YES;
    bottomScrollView.contentSize = CGSizeMake(w * titleArr.count, h - headerHeight);
    bottomScrollView.showsHorizontalScrollIndicator = NO;
    bottomScrollView.showsVerticalScrollIndicator = NO;
    bottomScrollView.delegate = self;
    
    NSMutableArray *btnArr = [NSMutableArray array];
    CGFloat headScrollViewW = 0;
    NSMutableArray *btnWArr = [NSMutableArray array];
    NSMutableArray *btnXArr = [NSMutableArray array];
    for (int i = 0; i < titleArr.count; i ++) {
        //计算按钮宽度
        NSString *btnTitle = titleArr[i];
        CGFloat btnW = ScreenFrame.size.width / (CGFloat)titleArr.count;
        [btnWArr addObject:@(btnW)];
        if (i==titleArr.count-1) {
            //多加一个元素防止数组越界崩溃......
            [btnWArr addObject:@(btnW)];
        }
        [btnXArr addObject:@(headScrollViewW)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (testColor) {
            CGFloat g = 255.f/(float)titleArr.count;
            CGFloat f = g*(i+1);
            btn.backgroundColor = [UIColor colorWithRed:0 green:f/255.f blue:0 alpha:1];
        }
        [btn setTitle:btnTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:normalFontSize];
        [btnArr addObject:btn];
        _btnArr = btnArr;
        CGRect btnFrame = CGRectMake(headScrollViewW, 0, btnW, headerHeight);
        btn.frame = btnFrame;
        [headNaviView addSubview:btn];
        [btn addTarget:self action:@selector(naviBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            btn.selected = YES;
            _currentBtn = btn;
            btn.titleLabel.font = [UIFont systemFontOfSize:selectedFontSize];
        }
        headScrollViewW += btnW;
    }
    _btnWArr = btnWArr;
    _btnXArr = btnXArr;
    //创建tableView
    NSMutableArray *tableViewArr = [NSMutableArray array];
    _tableViewArray = tableViewArr;
    for (int i = 0; i < titleArr.count; i ++) {
        UITableView *tv = [[UITableView alloc]initWithFrame:CGRectMake(i * w, 0, w, h - headerHeight -44) style:UITableViewStylePlain];
        [tableViewArr addObject:tv];
        if (testColor) {
            CGFloat g = 255.f/(float)titleArr.count;
            CGFloat f = g*(i+1);
            tv.backgroundColor = [UIColor colorWithRed:0 green:f/255.f blue:0 alpha:1];
        }
        [bottomScrollView addSubview:tv];
    }
    
    UIView *orangeBar = [[UIView alloc]init];
    orangeBar.backgroundColor = [UIColor orangeColor];
    _orangeBar = orangeBar;
    UIButton *btn0 = btnArr[0];
    CGFloat btn0H = btn0.frame.size.height;
    CGFloat btn0W = btn0.frame.size.width;
    orangeBar.frame = CGRectMake(0, 0.95*btn0H, btn0W, 0.05*btn0H);
    
    //添加到父视图
    [headNaviView addSubview:orangeBar];
    [containerView addSubview:headNaviView];
    [containerView addSubview:bottomScrollView];
}
-(void)sy_addHeadNaviTitleArray:(NSArray *)titleArr toContainerViewWithFrameSetted:(UIView *)containerView headerHeight:(CGFloat)headerHeight topMargin:(CGFloat)topMargin testColor:(BOOL)testColor normalFontSize:(CGFloat)normalFontSize selectedFontSize:(CGFloat)selectedFontSize{
    _curIndex = 0;
    _normalFontSize = normalFontSize;
    _selectedFontSize = selectedFontSize;
    _titleArr = titleArr;
    CGRect frame = containerView.frame;
    CGFloat w = frame.size.width;
    _w = w;
    CGFloat h = frame.size.height;
    //控件创建，设置frame
    UIScrollView *headNaviView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, topMargin, w, headerHeight)];
    UIScrollView *bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, headerHeight+topMargin, w, h - headerHeight)];
    _bottomScrollView = bottomScrollView;
    
    _headNaviView = headNaviView;
    headNaviView.showsHorizontalScrollIndicator = NO;
    headNaviView.showsVerticalScrollIndicator = NO;
    
    bottomScrollView.pagingEnabled = YES;
    bottomScrollView.contentSize = CGSizeMake(w * titleArr.count, h - headerHeight);
    bottomScrollView.showsHorizontalScrollIndicator = NO;
    bottomScrollView.showsVerticalScrollIndicator = NO;
    bottomScrollView.delegate = self;
    
    NSMutableArray *btnArr = [NSMutableArray array];
    CGFloat headScrollViewW = 0;
    NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:selectedFontSize]};
    NSMutableArray *btnWArr = [NSMutableArray array];
    NSMutableArray *btnXArr = [NSMutableArray array];
    for (int i = 0; i < titleArr.count; i ++) {
        //计算按钮宽度
        NSString *btnTitle = titleArr[i];
        CGSize maxSize = CGSizeMake(CGFLOAT_MAX, headerHeight);
        CGFloat btnW = [btnTitle boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.width;
        btnW = btnW + 20;
        [btnWArr addObject:@(btnW)];
        if (i==titleArr.count-1) {
            //多加一个元素防止数组越界崩溃......
            [btnWArr addObject:@(btnW)];
        }
        [btnXArr addObject:@(headScrollViewW)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (testColor) {
            CGFloat g = 255.f/(float)titleArr.count;
            CGFloat f = g*(i+1);
            btn.backgroundColor = [UIColor colorWithRed:0 green:f/255.f blue:0 alpha:1];
        }
        [btn setTitle:btnTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:normalFontSize];
        [btnArr addObject:btn];
        _btnArr = btnArr;
        CGRect btnFrame = CGRectMake(headScrollViewW, 0, btnW, headerHeight);
        btn.frame = btnFrame;
        [headNaviView addSubview:btn];
        [btn addTarget:self action:@selector(naviBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            btn.selected = YES;
            _currentBtn = btn;
            btn.titleLabel.font = [UIFont systemFontOfSize:selectedFontSize];
        }
        headScrollViewW += btnW;
    }
    //按钮数量很少的情况
    if (headScrollViewW<_w) {
        _isFewTitle = YES;
        //只能在这里重新布局按钮
        CGFloat bX = 0;
        for (UIButton *btn in _btnArr) {
            //等比例放大宽度即可
            CGFloat ratio = _w / headScrollViewW;
            _ratio = ratio;
            CGRect fr = btn.frame;
            fr.size.width *= ratio;
            fr.origin.x = bX;
            btn.frame = fr;
            bX += fr.size.width;
        }
        headScrollViewW = w;
    }
    headNaviView.contentSize = CGSizeMake(headScrollViewW,0);
    _btnWArr = btnWArr;
    _btnXArr = btnXArr;
    //创建tableView
    NSMutableArray *tableViewArr = [NSMutableArray array];
    _tableViewArray = tableViewArr;
    for (int i = 0; i < titleArr.count; i ++) {
        UITableView *tv = [[UITableView alloc]initWithFrame:CGRectMake(i * w, 0, w, h - headerHeight -64) style:UITableViewStylePlain];
        [tableViewArr addObject:tv];
        if (testColor) {
            CGFloat g = 255.f/(float)titleArr.count;
            CGFloat f = g*(i+1);
            tv.backgroundColor = [UIColor colorWithRed:0 green:f/255.f blue:0 alpha:1];
        }
        [bottomScrollView addSubview:tv];
    }
    
    UIView *orangeBar = [[UIView alloc]init];
    orangeBar.backgroundColor = [UIColor orangeColor];
    _orangeBar = orangeBar;
    UIButton *btn0 = btnArr[0];
    CGFloat btn0H = btn0.frame.size.height;
    CGFloat btn0W = btn0.frame.size.width;
    orangeBar.frame = CGRectMake(0, 0.95*btn0H, btn0W, 0.05*btn0H);
    
    //添加到父视图
    [headNaviView addSubview:orangeBar];
    [containerView addSubview:headNaviView];
    [containerView addSubview:bottomScrollView];
    
}
-(void)setCurIndex:(NSInteger)curIndex{
    _curIndex = curIndex;
    UIButton *curBtn = _btnArr[curIndex];
    if (curBtn) {
        [self naviBtnClicked:curBtn];
    }
}
-(IBAction)naviBtnClicked:(id)sender{
    _currentBtn.selected = NO;
    _currentBtn = sender;
    _currentBtn.selected = YES;
    
    NSInteger index = [_btnArr indexOfObject:sender];
    _curIndex = index;
    if ( self.delegate && [self.delegate respondsToSelector:@selector(naviButtonClicked:index:)]) {
        [self.delegate naviButtonClicked:self index:index];
    }
    CGPoint p = CGPointMake(_w * index, 0);
    [_bottomScrollView  setContentOffset:p animated:YES];
    
    UIButton *btn = sender;
    //当前按钮居中
    CGFloat centerX = btn.frame.origin.x + 0.5 * btn.frame.size.width;
    CGFloat offX = centerX - _w * 0.5;
    [_headNaviView setContentOffset:CGPointMake(offX, 0) animated:YES];
    //如果滚多了.....那就滚回去！
    if (offX<=0) {
        offX = 0;
        [_headNaviView setContentOffset:CGPointMake(offX, 0) animated:YES];
    }
    if (offX+_w>=_headNaviView.contentSize.width) {
        offX = _headNaviView.contentSize.width - _w;
        [_headNaviView setContentOffset:CGPointMake(offX, 0) animated:YES];
    }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==_bottomScrollView) {
        if (_isFewTitle) {
            CGRect frame = _orangeBar.frame;
            CGFloat x = scrollView.contentOffset.x;
            NSInteger index = x / _w;
            CGFloat btnW = [_btnWArr[index] floatValue];
            CGFloat btnW1 = [_btnWArr[index+1] floatValue];
            CGFloat changeW = btnW1 - btnW;
            CGFloat sX = x - index * _w;
            CGFloat rX = sX * btnW / _w;
            CGFloat rRatio = rX / btnW;
            CGFloat btnW2 =btnW + changeW * rRatio;
            CGFloat bbW=0;
            for (int i=0; i<index; i++) {
                CGFloat bW = [_btnWArr[i] floatValue];
                bbW += bW;
            }
            CGFloat realX = bbW + rX;
            frame.origin.x = realX;
            frame.size.width = btnW2;
            //如果按钮较少,按比例放大指示条
            frame.origin.x *= _ratio;
            frame.size.width *= _ratio;
            _orangeBar.frame = frame;
            //调整字体大小
            CGFloat nFontSize = _normalFontSize + (_selectedFontSize - _normalFontSize) * rRatio;
            UIButton *pBtn = _btnArr[index];
            //假按钮，防止数组越界
            [_btnArr addObject:pBtn];
            UIButton *nBtn = _btnArr[index + 1];
            pBtn.titleLabel.font = [UIFont systemFontOfSize:(_selectedFontSize + _normalFontSize) - nFontSize];
            nBtn.titleLabel.font = [UIFont systemFontOfSize:nFontSize];
        }else{
            CGRect frame = _orangeBar.frame;
            CGFloat x = scrollView.contentOffset.x;
            NSInteger index = x / _w;
            CGFloat btnW = [_btnWArr[index] floatValue];
            CGFloat btnW1 = [_btnWArr[index+1] floatValue];
            CGFloat changeW = btnW1 - btnW;
            CGFloat sX = x - index * _w;
            CGFloat rX = sX * btnW / _w;
            CGFloat rRatio = rX / btnW;
            CGFloat btnW2 = btnW + changeW * rRatio;
            CGFloat bbW=0;
            for (int i=0; i<index; i++) {
                CGFloat bW = [_btnWArr[i] floatValue];
                bbW += bW;
            }
            CGFloat realX = bbW + rX;
            frame.origin.x = realX;
            frame.size.width = btnW2;
            _orangeBar.frame = frame;
            //调整字体大小
            CGFloat nFontSize = _normalFontSize + (_selectedFontSize - _normalFontSize) * rRatio;
            UIButton *pBtn = _btnArr[index];
            //假按钮，防止数组越界
            [_btnArr addObject:pBtn];
            UIButton *nBtn = _btnArr[index + 1];
            pBtn.titleLabel.font = [UIFont systemFontOfSize:(_selectedFontSize + _normalFontSize) - nFontSize];
            nBtn.titleLabel.font = [UIFont systemFontOfSize:nFontSize];
        }
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView==_bottomScrollView) {
        CGFloat x = scrollView.contentOffset.x;
        NSInteger index = x / _w;
        UIButton *btn = [_btnArr objectAtIndex:index];
        [self naviBtnClicked:btn];
        //当前按钮居中
        CGFloat centerX = btn.frame.origin.x + 0.5 * btn.frame.size.width;
        CGFloat offX = centerX - _w * 0.5;
        [_headNaviView setContentOffset:CGPointMake(offX, 0) animated:YES];
        //如果滚多了.....那就滚回去！
        if (offX<=0) {
            offX = 0;
            [_headNaviView setContentOffset:CGPointMake(offX, 0) animated:YES];
        }
        if (offX+_w>=_headNaviView.contentSize.width) {
            offX = _headNaviView.contentSize.width - _w;
            [_headNaviView setContentOffset:CGPointMake(offX, 0) animated:YES];
        }
    }
}

+(UIView *)loadingViewAtCenter{
    UIView *loadingV=[self loadingView:CGRectMake((ScreenFrame.size.width-100)/2, (ScreenFrame.size.height-100-64-44)/2, 100, 100)];
    return loadingV;
}
+(UIView *)loadingView:(CGRect)rect{
    UIView *loadV=[[UIView alloc]initWithFrame:rect];
    loadV.backgroundColor=[UIColor blackColor];
    loadV.alpha = 0.8;
    UIActivityIndicatorView *activityIndicatorV=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorV.center=CGPointMake(rect.size.width/2, rect.size.height/2-10);
    [activityIndicatorV startAnimating];
    
    [loadV addSubview:activityIndicatorV];
    UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(0, 70, 100, 30)];
    la.text=@"正在加载...";
    la.backgroundColor=[UIColor clearColor];
    la.textAlignment=NSTextAlignmentCenter;
    la.textColor=[UIColor whiteColor];
    la.font=[UIFont boldSystemFontOfSize:15];
    [loadV addSubview:la];
    loadV.layer.cornerRadius=4;
    loadV.layer.masksToBounds=YES;
    return loadV;
}
+(void)selfNavigationController:(UINavigationController *)naviCtl pushDetailPageByGoodsID:(NSString *)goodsID{
    [naviCtl pushViewController:[self goodsDetailPageWithGoodsID:goodsID] animated:YES];
}
+(DetailViewController *)goodsDetailPageWithGoodsID:(NSString *)goodsID{
    SecondViewController *sec = [SecondViewController sharedUserDefault];
    sec.detail_id = goodsID;
    DetailViewController *detailVC = [[DetailViewController alloc]init];
    return detailVC;
}
+(UIView *)noDataView{
    //无数据视图 314*314图片尺寸
    UIView *noDataView = [[UIView alloc]init];
    
    UIImageView *noDataIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"seller_center_nothing.png"]];
    noDataIV.frame = CGRectMake(100.f/568.f*ScreenFrame.size.height, 80.f/568.f*ScreenFrame.size.height, 0.5*314.f/568.f*ScreenFrame.size.height, 0.5*314.f/568.f*ScreenFrame.size.height);
    [noDataView addSubview: noDataIV];
    
    UILabel *noDataLabel = [[UILabel alloc]init];
    noDataLabel.text = @"未找到数据";
    noDataLabel.textAlignment = NSTextAlignmentCenter;
    noDataLabel.frame = CGRectMake(0, 300.f/568.f*ScreenFrame.size.height, ScreenFrame.size.width, 20.f/568.f*ScreenFrame.size.height);
    [noDataView addSubview:noDataLabel];
    
    noDataView.backgroundColor = BACKGROUNDCOLOR;
    return noDataView;
}
+(NSString *)currentUserName{
    BOOL login;
    NSArray *arr = [self hasUserLogedIn:&login];
    if (login) {
        NSString *uName = arr[2];
        return uName;
    }
    return nil;
}
+(NSString *)currentUserID{
    BOOL login;
    NSArray *arr = [self hasUserLogedIn:&login];
    if (login) {
        NSString *uID = arr[3];
        return uID;
    }
    return nil;
}
+(NSString *)currentToken{
    BOOL login;
    NSArray *arr = [self hasUserLogedIn:&login];
    if (login) {
        NSString *token = arr[1];
        return token;
    }
    return nil;
}
+(NSString *)currentVerify{
    BOOL login;
    NSArray *arr = [self hasUserLogedIn:&login];
    if (login) {
        NSString *verify = arr[4];
        return verify;
    }
    return nil;
}
+(NSArray *)hasUserLogedIn:(BOOL *)flag{
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:filePathDong];
    if([[NSFileManager defaultManager] fileExistsAtPath:[[docPath objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
        //文件不存在
        *flag = NO;
        return [NSArray array];
    }else{
        *flag = YES;
        return fileContent2;
    }
}
-(instancetype)detailCellViewWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font centerSeparatorSpaceFromLeftMargin:(CGFloat)space withRightDisclosureIndicator:(BOOL)have andRightText:(NSString *)rightText viewHeight:(CGFloat)height frame:(CGRect)frame buttonTag:(NSInteger)tag{
    
    SYObject *bgView = [[SYObject alloc]initWithFrame:frame];
    bgView.userInteractionEnabled = YES;
    CGFloat rightLabelW = 60.f/375.f*ScreenFrame.size.width;
    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(space, 5, ScreenFrame.size.width-space*2-rightLabelW, height-5-5)];
    leftLabel.font = font;
    leftLabel.text = title;
    leftLabel.textColor = titleColor;
    [bgView addSubview:leftLabel];
    leftLabel.numberOfLines = 0;
    
    UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(bgView.frame.size.width-7-space-7-rightLabelW, 5, rightLabelW, height-5-5)];
    if (rightText) {
        rightLabel.text = rightText;
    }else{
        rightLabel.text = @"";
    }
    rightLabel.textColor = titleColor;
    rightLabel.font = font;
    [bgView addSubview:rightLabel];
    
    UIImageView *indicator = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_indicator"]];
    indicator.frame = CGRectMake(bgView.frame.size.width-7-space, (bgView.frame.size.height-10)*0.5, 7, 10);
    indicator.hidden = !have;
    [bgView addSubview:indicator];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    bgView.clearButton = btn;
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = bgView.bounds;
    [bgView addSubview:btn];
    btn.tag = tag;
    
    UIView *separator = [[UIView alloc]initWithFrame:CGRectMake(space,bgView.frame.size.height-1.0,ScreenFrame.size.width-2*space,1.0)];
    separator.backgroundColor = _K_Color(151, 151, 151);
    [bgView addSubview:separator];
    
    [bgView bringSubviewToFront:btn];
    
    return bgView;
}
-(UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)title font:(NSInteger)font color:(UIColor *)color{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = title;
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = color;
    return label;
}
-(UIView *)evaCellViewWithEvaModel:(EvaModel *)model cellIndex:(NSInteger)cellIndex{
    static NSString *s1 = @"评论: ";
    static NSString *s2 = @"这个人很懒，什么评论也没有留下";
    static NSString *s3 = @"追加评价: ";
    self.evaModel = model;
    //关键变量
    //公共宽度
    CGFloat w = ScreenFrame.size.width;
    //空白
    CGFloat space = 12.f/ScreenFrame.size.width*375.f;
    //灰色条高度
    CGFloat h1 = 15.f/667.f*ScreenFrame.size.height;
    //第一栏高度：头像，姓名，时间
    CGFloat h2 = (222.f/667.f*ScreenFrame.size.height-h1)*0.3;
    //第二栏高度：评价
    NSString *ss1;
    NSString *ss2 = model.content;
    NSString *ss3 = [ss2 stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![ss3 isEqualToString:@""]) {
        ss1 = [s1 stringByAppendingString:model.content];
    }else{
        ss1 = [s1 stringByAppendingString:s2];
    }
    NSDictionary * dict = @{NSFontAttributeName:[UIFont systemFontOfSize:15.f]};
    CGSize maxSize = CGSizeMake(w-space, CGFLOAT_MAX);
    CGSize size = [ss1 boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    CGFloat h3 = size.height+2*space;
    //第三栏高度：晒单
    CGFloat h4 = h2;
    //第四栏高度：追加评价
    NSString *ss4;
    if (model.add_content) {
        ss4 = [s3 stringByAppendingString:model.add_content];
    }
    NSDictionary * dict1 = @{NSFontAttributeName:[UIFont systemFontOfSize:15.f]};
    CGSize maxSize1 = CGSizeMake(w-2*space, CGFLOAT_MAX);
    CGSize size1;
    size1 = [ss4 boundingRectWithSize:maxSize1 options:NSStringDrawingUsesLineFragmentOrigin attributes:dict1 context:nil].size;
    CGFloat h5 = size1.height+2*space;
    //第五栏高度：追加晒单
    CGFloat h6 = h2;
    
    //创建
    //必选的
    UIView *outView = [[UIView alloc]init];
    UIView *view = [[UIView alloc]init];
    UIImageView *headImage = [[UIImageView alloc]init];
    UILabel *nameLabel = [[UILabel alloc]init];
    UIView *line1 = [[UIView alloc]init];//h=1
    UILabel *contentLabel = [[UILabel alloc]init];
    UILabel *timeLabel =[[UILabel alloc]init];
    UIView *line2 = [[UIView alloc]init];
    //可选的
    UIView *photosView = [[UIView alloc]init];
    UIView *line3 = [[UIView alloc]init];
    UILabel *picLabel = [[UILabel alloc]init];
    UIView *imagesHolderView = [[UIView alloc]init];
    
    UIView *addContentsView = [[UIView alloc]init];
    UIView *line4 = [[UIView alloc]init];
    UILabel *addContentLabel = [[UILabel alloc]init];
    UILabel *addLeftLabel = [[UILabel alloc]init];
    
    UIView *addPhotosView = [[UIView alloc]init];
    UIView *line5 = [[UIView alloc]init];
    UILabel *picLabel1 = [[UILabel alloc]init];
    UIView *imagesHolderView1 = [[UIView alloc]init];
    //定位
    headImage.frame = CGRectMake(space, space, h2-2*space, h2-2*space);
    nameLabel.frame = CGRectMake(CGRectGetMaxX(headImage.frame)+space, space, 0.5*(w-space*3-headImage.frame.size.width), h2-2*space);
    timeLabel.frame = CGRectMake(CGRectGetMaxX(nameLabel.frame), space, 0.5*(w-space*3-headImage.frame.size.width), nameLabel.frame.size.height);
    line1.frame = CGRectMake(space, h2, w-space, 1);
    contentLabel.frame = CGRectMake(space, h2+space, w-space, h3-2*space);
    line2.frame = CGRectMake(space, CGRectGetMaxY(contentLabel.frame)+space, w-space, 1);
    if (![self shouldDisplayPhotosWithModel:model]) {
        h4 = 0.f;
        photosView.hidden = YES;
    }
    photosView.frame = CGRectMake(0, line2.frame.origin.y+1, w, h4);
    if (![self shouldDisplayAddContentWithModel:model]) {
        h5 = 0.f;
        addContentsView.hidden = YES;
    }
    addContentsView.frame = CGRectMake(0, CGRectGetMaxY(photosView.frame), w, h5);
    if (![self shouldDisplayAddPhotosWithModel:model]) {
        h6 = 0.f;
        addPhotosView.hidden = YES;
    }
    addPhotosView.frame = CGRectMake(0, CGRectGetMaxY(addContentsView.frame), w, h6);
    
    //PhotosView
    picLabel.frame = CGRectMake(space, 0.5*(h4-nameLabel.frame.size.height), 60.f/375.f*ScreenFrame.size.width, nameLabel.frame.size.height);
    imagesHolderView.frame = CGRectMake(60.f/375.f*ScreenFrame.size.width, 0, w-space-picLabel.frame.size.width, h4);
    line3.frame = CGRectMake(space, h4, w-space, 1);
    //addContentView
    line4.frame = CGRectMake(space, h5, w-space, 1);
    addLeftLabel.frame = CGRectMake(space, space, headImage.frame.size.width*2, nameLabel.frame.size.height);
    addContentLabel.frame = CGRectMake(space, space, w-2*space, h5-2*space);
    //addPhotosView
    picLabel1.frame = CGRectMake(space, 0.5*(h4-nameLabel.frame.size.height), 90.f/375.f*ScreenFrame.size.width, nameLabel.frame.size.height);
    imagesHolderView1.frame = CGRectMake(85.f/375.f*ScreenFrame.size.width, 0, w-space-picLabel.frame.size.width, h4);
    line5.frame = CGRectMake(space, h6, w-space, 1);
    
    //定位总体视图
    view.frame = CGRectMake(0, h1, w, h2+h3+h4+h5+h6);
    outView.frame = CGRectMake(0, 0, w, h1+h2+h3+h4+h5+h6);
    
    //添加到父视图
    [view addSubview:headImage];
    [view addSubview:nameLabel];
    [view addSubview:line1];
    [view addSubview:timeLabel];
    [view addSubview:contentLabel];
    [view addSubview:line2];
    [outView addSubview:view];
    //可选
    [view addSubview:photosView];
    [photosView addSubview:line3];
    [photosView addSubview:picLabel];
    [photosView addSubview:imagesHolderView];
    
    [view addSubview:addContentsView];
    [addContentsView addSubview:line4];
    [addContentsView addSubview:addContentLabel];
    
    [view addSubview:addPhotosView];
    [addPhotosView addSubview:line5];
    [addPhotosView addSubview:picLabel1];
    [addPhotosView addSubview:imagesHolderView1];
    
    //label字体，颜色，分隔线颜色
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:15.f];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.font = [UIFont systemFontOfSize:15.f];
    contentLabel.numberOfLines = 0;
    addContentLabel.textColor = [UIColor blackColor];
    addContentLabel.font = [UIFont systemFontOfSize:15.f];
    addContentLabel.numberOfLines = 0;
    picLabel.textColor = [UIColor blackColor];
    picLabel.font = [UIFont systemFontOfSize:15.f];
    picLabel1.textColor = [UIColor blackColor];
    picLabel1.font = [UIFont systemFontOfSize:15.f];
    timeLabel.textColor = _K_Color(124, 124, 124);
    timeLabel.font = [UIFont systemFontOfSize:14.f];
    timeLabel.textAlignment = NSTextAlignmentRight;
    line1.backgroundColor = BACKGROUNDCOLOR;
    line2.backgroundColor = BACKGROUNDCOLOR;
    line3.backgroundColor = BACKGROUNDCOLOR;
    line4.backgroundColor = BACKGROUNDCOLOR;
    line5.backgroundColor = BACKGROUNDCOLOR;
    outView.backgroundColor = BACKGROUNDCOLOR;
    view.backgroundColor = [UIColor whiteColor];

    //使用模型更新数据
    [headImage sd_setImageWithURL:[NSURL URLWithString:model.user_img] placeholderImage:[UIImage imageNamed:@"evaHeadImage"]];
    nameLabel.text = model.user;
    timeLabel.text = model.addTime;
    NSString *contentStr = model.content;
    NSString *contentStr1 = [contentStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![contentStr1 isEqualToString:@""]) {
        contentLabel.text = [s1 stringByAppendingString:model.content];
    }else{
        contentLabel.text = [s1 stringByAppendingString:s2];
    }
    NSString *addContentStr = model.add_content;
    NSString *addContentStr1 = [addContentStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (addContentStr&&![addContentStr1 isEqualToString:@""]) {
        addContentLabel.text = [s3 stringByAppendingString:model.add_content];
    }
    NSString *photoStr = @"晒单: ";
    CGFloat photoStrW = [photoStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, h2-2*space) options:0 attributes:dict context:nil].size.width;
    picLabel.text = photoStr;
    
    NSString *addPhotoStr = @"追加晒单: ";
    CGFloat addPhotoStrW = [addPhotoStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, h2-2*space) options:0 attributes:dict context:nil].size.width;
    picLabel1.text = addPhotoStr;
    //重新计算frame，并更新
    //PhotosView
    picLabel.frame = CGRectMake(space, 0.5*(h4-nameLabel.frame.size.height), photoStrW, nameLabel.frame.size.height);
    imagesHolderView.frame = CGRectMake(CGRectGetMaxX(picLabel.frame), 0, w-space-picLabel.frame.size.width, h4);
    //addPhotosView
    picLabel1.frame = CGRectMake(space, 0.5*(h4-nameLabel.frame.size.height), addPhotoStrW, nameLabel.frame.size.height);
    imagesHolderView1.frame = CGRectMake(CGRectGetMaxX(picLabel1.frame), 0, w-space-picLabel.frame.size.width, h4);
    
    //晒单
    NSArray *picArr = (NSArray *)model.evaluate_photos;
    CGFloat w1 = imagesHolderView.frame.size.width*0.25-12*1.5*2;
    if (picArr.count!=0) {
        for (int i=0; i<picArr.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*(w1+space), 0.5*(h4-w1), w1, w1);
            UIImageView *iv = [[UIImageView alloc]initWithFrame:btn.bounds];
            [iv sd_setImageWithURL:[NSURL URLWithString:picArr[i]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(imageSizeAcquired:size:index: cellIndex: type:)]) {
                    [self.delegate imageSizeAcquired:self size:image.size index:i cellIndex:cellIndex type:SY_PHOTO_TYPE_NORMAL];
                }
            }];
            [btn addSubview:iv];
            [imagesHolderView addSubview:btn];
            _imagesHolderView = imagesHolderView;
            [btn addTarget:self action:@selector(imageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 614+cellIndex;
        }
    }
    //追加晒单
    NSArray *addPicArr = (NSArray *)model.add_evaluate_photos;
    if (addPicArr.count!=0) {
        for (int i=0; i<addPicArr.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*(w1+space), 0.5*(h6-w1), w1, w1);
            UIImageView *iv = [[UIImageView alloc]initWithFrame:btn.bounds];
            [iv sd_setImageWithURL:[NSURL URLWithString:addPicArr[i]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(imageSizeAcquired:size:index: cellIndex: type:)]) {
                    [self.delegate imageSizeAcquired:self size:image.size index:i cellIndex:cellIndex type:SY_PHOTO_TYPE_ADD];
                }
            }];
            [btn addSubview:iv];
            [imagesHolderView1 addSubview:btn];
            _imagesHolderView1 = imagesHolderView1;
            [btn addTarget:self action:@selector(addImageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 614+cellIndex;
        }
    }
    return outView;
}
-(BOOL)shouldDisplayPhotosWithModel:(EvaModel *)model{
    NSArray *photoArr = (NSArray *)model.evaluate_photos;
    if (photoArr==nil||photoArr.count==0) {
        return NO;
    }
    return YES;
}
-(BOOL)shouldDisplayAddContentWithModel:(EvaModel *)model{
    NSString *addContent = model.add_content;
    if (!addContent) {
        return NO;
    }
    NSString *afterTrim = [addContent stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([afterTrim isEqualToString:@""]) {
        return NO;
    }
    return YES;
}
-(BOOL)shouldDisplayAddPhotosWithModel:(EvaModel *)model{
    NSArray *photoArr = (NSArray *)model.add_evaluate_photos;
    if (photoArr==nil||photoArr.count==0) {
        return NO;
    }
    return YES;
}
-(void)imageBtnClicked:(id)sender{
    UIButton *btn = sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageBtnIsClicked:indexOfImage:cellIndex:type:)]) {
        int i;
        for (i=0;i<btn.superview.subviews.count;i++) {
            if(btn.superview.subviews[i] == btn){
                break;
            }
        }
        [self.delegate imageBtnIsClicked:self indexOfImage:i cellIndex:btn.tag-614 type:SY_PHOTO_TYPE_NORMAL];
    }
}
-(void)addImageBtnClicked:(id)sender{
    UIButton *btn = sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageBtnIsClicked:indexOfImage:cellIndex:type:)]) {
        int i;
        for (i=0;i<btn.superview.subviews.count;i++) {
            if(btn.superview.subviews[i] == btn){
                break;
            }
        }
        
        [self.delegate imageBtnIsClicked:self indexOfImage:i cellIndex:btn.tag-614 type:SY_PHOTO_TYPE_ADD];
    }
}
-(CGFloat)evaCellHeightByModel:(EvaModel *)model{
    static NSString *s1 = @"评论: ";
    static NSString *s2 = @"这个人很懒，什么评论也没有留下......";
    static NSString *s3 = @"追加评价:  ";
    //关键变量
    //公共宽度
    CGFloat w = ScreenFrame.size.width;
    //空白
    CGFloat space = 12.f/ScreenFrame.size.width*375.f;
    //灰色条高度
    CGFloat h1 = 15.f/667.f*ScreenFrame.size.height;
    //第一栏高度：头像，姓名，时间
    CGFloat h2 = (222.f/667.f*ScreenFrame.size.height-h1)*0.3;
    //第二栏高度：评价
    NSString *ss1;
    NSString *ss2 = model.content;
    NSString *ss3 = [ss2 stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![ss3 isEqualToString:@""]) {
        ss1 = [s1 stringByAppendingString:model.content];
    }else{
        ss1 = [s1 stringByAppendingString:s2];
    }
    NSDictionary * dict = @{NSFontAttributeName:[UIFont systemFontOfSize:15.f]};
    CGSize maxSize = CGSizeMake(w-space, CGFLOAT_MAX);
    CGSize size = [ss1 boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    CGFloat h3 = size.height+2*space;
    //第三栏高度：晒单
    CGFloat h4 = h2;
    //第四栏高度：追加评价
    NSString *ss4;
    if (model.add_content) {
        ss4 = [s3 stringByAppendingString:model.add_content];
    }
    NSDictionary * dict1 = @{NSFontAttributeName:[UIFont systemFontOfSize:15.f]};
    CGSize maxSize1 = CGSizeMake(w-2*space, CGFLOAT_MAX);
    CGSize size1;
    size1 = [ss4 boundingRectWithSize:maxSize1 options:NSStringDrawingUsesLineFragmentOrigin attributes:dict1 context:nil].size;
    CGFloat h5 = size1.height+2*space;
    //第五栏高度：追加晒单
    CGFloat h6 = h2;
    if (![self shouldDisplayPhotosWithModel:model]) {
        h4 = 0.f;
    }
    if (![self shouldDisplayAddContentWithModel:model]) {
        h5 = 0.f;
    }
    if (![self shouldDisplayAddPhotosWithModel:model]) {
        h6 = 0.f;
    }
    return h1+h2+h3+h4+h5+h6+20.f/667.f*ScreenFrame.size.height;
}
-(CGFloat)cellHeight{
    return 44.f;
}
-(UIView *)addAddressLineViewWithTitle:(NSString *)title{
    UIView *view = [[UIView alloc]init];
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [self cellHeight]);
    view.frame = frame;
    UIFont *font = [UIFont systemFontOfSize:17.0];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, (frame.size.width-20)*(1-TEXT_FIELD_WIDTH_RATE), 24)];
    label.text = title;
    label.font = font;
    label.textColor = LABEL_TEXT_COLOR;
    [view addSubview:label];
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 5, (frame.size.width-20)*TEXT_FIELD_WIDTH_RATE, 34.f)];
    textField.backgroundColor = [UIColor colorWithRed:238.f/255.f green:238.f/255.f blue:238.f/255.f alpha:1];
    _textField = textField;
    textField.layer.borderWidth = 1.0;
    textField.layer.cornerRadius = TEXT_FIELD_CORNER_REDIUS;
    textField.layer.borderColor = TEXT_FIELD_BORDER_COLOR.CGColor;
    textField.textAlignment = NSTextAlignmentCenter;
    [view addSubview:textField];
    
    UIImage *img = [UIImage imageNamed:@"down-arrow"];
    UIImageView *arrow = [[UIImageView alloc]initWithImage:img];
    arrow.frame = CGRectMake(ScreenFrame.size.width-10-22, 20, 13, 7);
    [view addSubview:arrow];
    _arrow = arrow;
    arrow.hidden = YES;
    
    return view;
}


@end
