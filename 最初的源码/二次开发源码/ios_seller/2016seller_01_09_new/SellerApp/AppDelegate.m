//
//  AppDelegate.m
//  SellerApp
//
//  Created by apple on 15-3-16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "DDPageControl.h"
#import "WorkBenchViewController.h"
#import "OrderDetailViewController.h"
#import "MyHomeViewController.h"

@interface AppDelegate (){
    myselfParse *_myParse;
}

@end

static AppDelegate *singleInstance=nil;
static CGFloat scaleTime = 2.0;

@implementation AppDelegate

#pragma mark - 单例
+(id)sharedUserDefault
{
    if(singleInstance==nil)
    {
        @synchronized(self)
        {
            if(singleInstance==nil)
            {
                singleInstance=[[[self class] alloc] init];
            }
        }
    }
    return singleInstance;
}
+ (id)allocWithZone:(NSZone *)zone;
{
    if(singleInstance==nil)
    {
        singleInstance=[super allocWithZone:zone];
    }
    return singleInstance;
}
-(id)copyWithZone:(NSZone *)zone
{
    return singleInstance;
}
#pragma mark - 程序状态代理
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    
    //推送处理
//    NSUserDefaults *def = [NSUserDefaults  standardUserDefaults];
//    NSString *deviceToken = [def objectForKey:@"deviceToken"];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        if (1) {
            [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
            
            [application registerForRemoteNotifications];
        }
    }else {
        if (1) {
            [application registerForRemoteNotificationTypes:
             (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
        }
    }
    
    [self clearBadge];
    
    //创建视图
    [self logView];
    [self initializeRootTabBar];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
   
    
    return YES;
}
#pragma mark - 推送处理
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    NSLog(@"userInfo = %@",userInfo);
    
    UIApplicationState state = application.applicationState;
    switch (state) {
        case UIApplicationStateActive:{
            //程序在前台
            [self handleRemoteNotif:userInfo type:1];
            break;
        }
        case UIApplicationStateBackground:
        case UIApplicationStateInactive:{
            
            //后台或者被杀死
            [self handleRemoteNotif:userInfo type:0];
            break;
        }
        default:{
            break;
        }
    }
    completionHandler(UIBackgroundFetchResultNewData);
}
//处理远程通知(web/order_id)
-(void)handleRemoteNotif:(NSDictionary *)userInfo type:(NSInteger)type{
    //type 后台/被杀死=0 程序正在运行=1
    UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
    UITabBarController *tabBar = (UITabBarController *)keyWindow.rootViewController;
    UINavigationController *navi1 = tabBar.selectedViewController;
    
    NSDictionary *aps = userInfo[@"aps"];
    NSDictionary *currentDict = aps;//aps==自己测试 userInfo==公司服务器
    
    if (type == 0 && [currentDict[@"type"] isEqualToString:@"web"]) {
        //后台网页
        //        NSString *urlStr = currentDict[@"value"];
        //        NSURL *url = [NSURL URLWithString:urlStr];
//                NotifWebViewController *vc = [[NotifWebViewController alloc]init];
        //        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        //        vc.request = request;
        //        [navi1 pushViewController:vc animated:YES];
    }else if (type == 0 && [currentDict[@"type"] isEqualToString:@"order"]){
        //后台订单
        NSString *orderID = currentDict[@"value"];
        if ([MyNetTool currentUserID] == nil) {
            [MyObject failedPrompt1:@"请先登录!"];
            return;
        }

        //拖延时间直到主窗口构建完毕
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIWindow *keyWindow1 = [[UIApplication sharedApplication]keyWindow];
            UITabBarController *tabBar1 = (UITabBarController *)keyWindow1.rootViewController;
            UINavigationController *navi2 = tabBar1.selectedViewController;
            OrderDetailViewController *detailVC = [OrderDetailViewController new];
            detailVC.orderID = orderID;
            [navi2 pushViewController:detailVC animated:YES];
        });
    }else if (type == 1 && [currentDict[@"type"] isEqualToString:@"order"]){
        //前台订单
        [OHAlertView showAlertWithTitle:@"您有新的通知" message:aps[@"alert"] cancelButton:@"取消" otherButtons:@[@"去查看"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            if (buttonIndex == alert.cancelButtonIndex) {
                //取消
            }else if (buttonIndex == alert.firstOtherButtonIndex){
                //去查看
                NSString *orderID = currentDict[@"value"];
                if ([MyNetTool currentUserID] == nil) {
                    [MyObject failedPrompt1:@"请先登录!"];
                    return;
                }
                OrderDetailViewController *detailVC = [OrderDetailViewController new];
                detailVC.orderID = orderID;
                [navi1 pushViewController:detailVC animated:YES];
            }
        }];
    }else{
    }
}
//远程通知注册成功委托
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token1 = [NSString stringWithFormat:@"%@",deviceToken];
    NSString *token2 = [token1 stringByReplacingOccurrencesOfString:@"<" withString:@""];
    NSString *token3 = [token2 stringByReplacingOccurrencesOfString:@">" withString:@""];
    //保存令牌
    NSUserDefaults *def = [NSUserDefaults  standardUserDefaults];
    [def setObject:token3 forKey:@"deviceToken"];
    
    [MyNetTool pushBind];
    NSLog(@"APNS: %@",deviceToken);
}
//远程通知注册失败委托
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"远程通知注册失败:%@", error);
}
//清除badge
-(void)clearBadge{
    int badge =(int)[UIApplication sharedApplication].applicationIconBadgeNumber;
    if(badge > 0)
    {
        badge = 0;
        [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    }
}
#pragma mark - PageControl
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    if (aScrollView == myScrollView) {
        CGFloat pageWidth = myScrollView.bounds.size.width ;
        float fractionalPage = myScrollView.contentOffset.x / pageWidth ;
        NSInteger nearestNumber = lround(fractionalPage) ;
        if (pageControl.currentPage != nearestNumber)
        {
            pageControl.currentPage = nearestNumber ;
            if (myScrollView.dragging)
                [pageControl updateCurrentPageDisplay] ;
        }
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)aScrollView
{
    // if we are animating (triggered by clicking on the page control), we update the page control
    if (aScrollView == myScrollView) {
        [pageControl updateCurrentPageDisplay] ;
    }
}
- (void)pageControlClicked2:(id)sender
{
    DDPageControl *thePageControl = (DDPageControl *)sender ;
    [myScrollView setContentOffset: CGPointMake(myScrollView.bounds.size.width * thePageControl.currentPage, myScrollView.contentOffset.y) animated: YES] ;
}
-(void)logView{
    //提示登录页
    _fist_View = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    _fist_View.backgroundColor = [UIColor whiteColor];
    
    myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _fist_View.frame.size.width, _fist_View.frame.size.height)];
    myScrollView.bounces = YES;
    myScrollView.delegate = self;
    myScrollView.pagingEnabled = YES;
    myScrollView.userInteractionEnabled = YES;
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.contentSize=CGSizeMake(_fist_View.frame.size.width*4,_fist_View.frame.size.width);
    myScrollView.backgroundColor = [UIColor whiteColor];
    [_fist_View addSubview:myScrollView];
    for(int i=0;i<4;i++){
        UIImageView *imageVIew = [[UIImageView alloc]init];
        if (self.window.frame.size.height<=480) {//4  4s
            imageVIew.frame = CGRectMake((ScreenFrame.size.width-260)/2+ScreenFrame.size.width*i, 40, 260, 390);
        }
        else if (self.window.frame.size.height<=568 && self.window.frame.size.height>480){//5  5s
            imageVIew.frame = CGRectMake((ScreenFrame.size.width-260)/2+ScreenFrame.size.width*i, 90, 260, 390);
        }
        else if (self.window.frame.size.height<=667 && self.window.frame.size.height>568){//6
            imageVIew.frame = CGRectMake((ScreenFrame.size.width-260)/2+ScreenFrame.size.width*i, 170, 260, 390);
        }
        else{//6plus
            imageVIew.frame = CGRectMake((ScreenFrame.size.width-260)/2+ScreenFrame.size.width*i, 180, 260, 390);
        }
        
        if (i == 0) {
            imageVIew.image = [UIImage imageNamed:@"01.png"];
        }else if (i == 1){
            imageVIew.image = [UIImage imageNamed:@"02.png"];
        }else if (i == 2){
            imageVIew.image = [UIImage imageNamed:@"03.png"];
        }else{
            imageVIew.image = [UIImage imageNamed:@"04.png"];
        }
        [myScrollView addSubview:imageVIew];
    }
    pageControl = [[DDPageControl alloc] init] ;
    [pageControl setCenter: CGPointMake(self.window.center.x, 80)] ;
    [pageControl setNumberOfPages: 4] ;
    [pageControl setCurrentPage: 0] ;
    [pageControl addTarget: self action: @selector(pageControlClicked2:) forControlEvents: UIControlEventValueChanged] ;
    [pageControl setDefersCurrentPageDisplay: YES] ;
    [pageControl setType: DDPageControlTypeOnFullOffEmpty] ;
    [pageControl setOnColor: NAV_COLOR] ;
    [pageControl setOffColor: [UIColor grayColor]] ;
    [pageControl setIndicatorDiameter: 10.0f] ;
    [pageControl setIndicatorSpace: 10.0f] ;
    [_fist_View addSubview: pageControl] ;
    
    UIButton *logbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logbtn.frame = CGRectMake((self.window.frame.size.width-250)/2, self.window.frame.size.height-60, 250, 43);
    [logbtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    logbtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [logbtn addTarget:self action:@selector(nextClicked) forControlEvents:UIControlEventTouchUpInside];
    [_fist_View addSubview:logbtn];
    
    //登录页
    _log_View = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    _log_View.backgroundColor = [UIColor whiteColor];
    _log_View.hidden = YES;
    [self.window addSubview:_log_View];
    UIImageView *imageBottom = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, 260)];
    imageBottom.image = [UIImage imageNamed:@"login_backgroud.png"];
    imageBottom.userInteractionEnabled = YES;
    [_log_View addSubview:imageBottom];
    UIImageView *imageMark = [[UIImageView alloc]initWithFrame:CGRectMake((self.window.frame.size.width-238)/2, 90,  238, 49)];
    imageMark.image = [UIImage imageNamed:@"login_logo.png"];
    imageMark.userInteractionEnabled = YES;
    [imageBottom addSubview:imageMark];
    UIImageView *imagetitle = [[UIImageView alloc]initWithFrame:CGRectMake((self.window.frame.size.width-118)/2, 170,  118, 54)];
    imagetitle.image = [UIImage imageNamed:@"login_title.png"];
    imagetitle.userInteractionEnabled = YES;
    [imageBottom addSubview:imagetitle];
    UIImageView *imageInput = [[UIImageView alloc]initWithFrame:CGRectMake(15, 275,  self.window.frame.size.width-30, 88)];
    imageInput.layer.borderWidth = 1;
    imageInput.userInteractionEnabled = YES;
    imageInput.layer.borderColor = [[UIColor colorWithRed:210/255.0f green:210/255.0f blue:210/255.0f alpha:1] CGColor];
    [imageInput.layer setCornerRadius:8.0f];
    [_log_View addSubview:imageInput];
    UIImageView *imageline = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43.5,  self.window.frame.size.width-30, 1)];
    imageline.backgroundColor = [UIColor colorWithRed:210/255.0f green:210/255.0f blue:210/255.0f alpha:1];
    [imageInput addSubview:imageline];
    
    UIButton *login_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    login_btn.frame = CGRectMake(15, self.window.frame.size.height-90, (self.window.frame.size.width-45)/2, 36);
    [login_btn setTitle:@"取消" forState:UIControlStateNormal];
    login_btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [login_btn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [login_btn.layer setMasksToBounds:YES];
    [login_btn.layer setCornerRadius:8.0f];
    login_btn.backgroundColor = [UIColor lightGrayColor];
    [_log_View addSubview:login_btn];
    UIButton *cancel_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel_btn.frame = CGRectMake(15+15+(self.window.frame.size.width-45)/2, self.window.frame.size.height-90, (self.window.frame.size.width-45)/2, 36);
    [cancel_btn setTitle:@"登录" forState:UIControlStateNormal];
    cancel_btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [cancel_btn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [cancel_btn.layer setMasksToBounds:YES];
    [cancel_btn.layer setCornerRadius:8.0f];
    cancel_btn.backgroundColor = NAV_COLOR;
    [_log_View addSubview:cancel_btn];
    

    
    UILabel *labelCompany = [[UILabel alloc]initWithFrame:CGRectMake(0, self.window.frame.size.height-50, _log_View.frame.size.width, 40)];
    labelCompany.text = @"Copyright 2012-2015 沈阳网之商科技有限公司";
    labelCompany.textColor =[UIColor lightGrayColor];
    labelCompany.textAlignment = NSTextAlignmentCenter;
    labelCompany.font = [UIFont boldSystemFontOfSize:12];
    [_log_View addSubview:labelCompany];
    if (self.window.frame.size.height<=480) {//4  4s
        
    }
    else if (self.window.frame.size.height<=568 && self.window.frame.size.height>480){//5  5s
        cancel_btn.frame = CGRectMake(15+15+(self.window.frame.size.width-45)/2, self.window.frame.size.height-180, (self.window.frame.size.width-45)/2, 36);
        login_btn.frame = CGRectMake(15, self.window.frame.size.height-180, (self.window.frame.size.width-45)/2, 36);
        labelCompany.text = @"Copyright 2012-2015\n沈阳网之商科技有限公司";
        labelCompany.numberOfLines = 2;
    }
    else if (self.window.frame.size.height<=667 && self.window.frame.size.height>568){//6
        cancel_btn.frame = CGRectMake(15+15+(self.window.frame.size.width-45)/2, self.window.frame.size.height-270, (self.window.frame.size.width-45)/2, 36);
        login_btn.frame = CGRectMake(15, self.window.frame.size.height-270, (self.window.frame.size.width-45)/2, 36);
        labelCompany.font = [UIFont boldSystemFontOfSize:13];
        labelCompany.text = @"Copyright 2012-2015\n沈阳网之商科技有限公司";
        labelCompany.numberOfLines = 2;
    }
    else{//6plus
        cancel_btn.frame = CGRectMake(15+15+(self.window.frame.size.width-45)/2, self.window.frame.size.height-300, (self.window.frame.size.width-45)/2, 36);
        login_btn.frame = CGRectMake(15, self.window.frame.size.height-300, (self.window.frame.size.width-45)/2, 36);
        labelCompany.font = [UIFont boldSystemFontOfSize:13];
        labelCompany.text = @"Copyright 2012-2015\n沈阳网之商科技有限公司";
        labelCompany.numberOfLines = 2;
    }
    
    userNameField = [[UITextField alloc]initWithFrame:CGRectMake(30, 275, self.window.frame.size.width-60, 44)];
    userNameField.placeholder = @"用户名";
    userNameField.textAlignment = NSTextAlignmentCenter;
    userNameField.font = [UIFont boldSystemFontOfSize:18];
    userNameField.clearsOnBeginEditing = YES;
    userNameField.keyboardType = UIKeyboardTypeDefault;
    userNameField.keyboardAppearance = UIKeyboardTypeDefault;
    [_log_View addSubview:userNameField];
    
    userPasswordField = [[UITextField alloc]initWithFrame:CGRectMake(30, 319, self.window.frame.size.width-60, 44)];
    userPasswordField.placeholder = @"密码";
    userPasswordField.font = [UIFont boldSystemFontOfSize:18];
    userPasswordField.secureTextEntry = YES;
    userPasswordField.textAlignment = NSTextAlignmentCenter;
    userPasswordField.clearsOnBeginEditing = YES;
    userPasswordField.keyboardType = UIKeyboardTypeDefault;
    userPasswordField.keyboardAppearance = UIKeyboardTypeDefault;
    userPasswordField.delegate = self;
    userNameField.delegate = self;
    [_log_View addSubview:userPasswordField];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboard_disappear)];
    tapGr.cancelsTouchesInView = NO;
    [_log_View addGestureRecognizer:tapGr];
    
    loadingV=[LJControl loadingView:CGRectMake((self.window.frame.size.width-100)/2, (self.window.frame.size.height-59-100)/2, 100, 100)];
    loadingV.hidden = YES;
    [self.window addSubview:loadingV];
    
    label_prompt =[LJControl labelFrame:CGRectMake(50, self.window.frame.size.height-100, self.window.frame.size.width-100, 30) setText:@"" setTitleFont:17 setbackgroundColor:[UIColor blackColor] setTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    [label_prompt.layer setMasksToBounds:YES];
    [label_prompt.layer setCornerRadius:4.0];
    label_prompt.alpha = 0.8;
    label_prompt.hidden = YES;
    [self.window addSubview:label_prompt];
    
    [self.window addSubview:_fist_View];
    
    //判断是否存在登录文件
    NSString *filePathDong=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"user_information.txt"];
    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
    if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
        _fist_View.hidden = NO;
        _log_View.hidden = NO;
    }else{
        _fist_View.hidden = YES;
        _log_View.hidden = YES;
    }
}

#pragma mark - 网络解析
-(void)analyze:(NSDictionary *)dicBig{
    NSLog(@"dicBig:%@",dicBig);
    if (dicBig) {
        if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"]) {
            NSLog(@"失败");
        }else{
            
        }
    }
}
- (void)initializeRootTabBar
{

    NSArray *vcNameArray=@[@"MyHomeViewController",@"MyGoodsViewController",@"OrderlistViewController",@"MyInformViewController",@"MySettingViewController"];
    
    NSMutableArray *vcArray=[[NSMutableArray alloc]init];
    NSArray *nameArray=@[@"首页",@"商品",@"订单",@"通知",@"设置"];
    NSArray *navArray=@[@"newHome",@"newGoods",@"newOrder",@"newInfor",@"newSetting"];
     NSArray *navSelectArray=@[@"newHomeSelect",@"newGoodsSelect",@"newOrderSelect",@"newInforSelect",@"newSettingSelect"];
   
    UIViewController *rvc0 = nil;
    for (int i=0; i<5; i++) {
        NSString *vcname=vcNameArray[i];
        UIViewController *rvc=[[(NSClassFromString(vcname))alloc]init];
        if (i==0) {
            rvc0 = rvc;
        }
        UINavigationController *nv=[[UINavigationController alloc]initWithRootViewController:rvc];
        nv.navigationBar.backgroundColor=UIColorFromRGB(0x2196f3);
        nv.title=nameArray[i];
        [vcArray addObject:nv];
        [self setTabBarItem:nv andImageName:navArray[i] andSelectedImageName:navSelectArray[i]];
    }
    UITabBarController *tbc=[[UITabBarController alloc]init];
    tbc.viewControllers=vcArray;
    _window.rootViewController = tbc;
    
    [_window bringSubviewToFront:self.log_View];
    [_window bringSubviewToFront:self.fist_View];
}
// 等比例压缩图片
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
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

-(void)setTabBarItem:(UINavigationController *)navi andImageName:(NSString *)imageName andSelectedImageName:(NSString *)selectedImageName
{
    [navi.navigationBar setBackgroundColor:[UIColor whiteColor]];
//     navi.tabBarItem.image = [[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSString *path1 = [[NSBundle mainBundle]pathForResource:imageName ofType:@"png"];
    NSData *data1 = [NSData dataWithContentsOfFile:path1];
    navi.tabBarItem.image = [[UIImage alloc]initWithData:data1 scale:scaleTime];
    
    
    NSString *path2 = [[NSBundle mainBundle]pathForResource:selectedImageName ofType:@"png"];
    NSData *data2 = [NSData dataWithContentsOfFile:path2];
    navi.tabBarItem.selectedImage = [[UIImage alloc]initWithData:data2 scale:scaleTime];
    
    [navi.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:_K_Color(83,83,83)} forState:UIControlStateNormal];
    [navi.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:_K_Color(36,126,255)} forState:UIControlStateSelected];
}

//键盘消失
-(void)keyboard_disappear{
    [userPasswordField resignFirstResponder];
    [userNameField resignFirstResponder];
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    self.window.frame = CGRectMake(self.window.frame.origin.x, 0, self.window.frame.size.width, self.window.frame.size.height);
    [UIView commitAnimations];
}
//取消事件
-(void)cancel{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 1;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;
    [[self.window layer] addAnimation:animation forKey:@"animation"];
    _log_View.hidden = YES;
    _fist_View.hidden = NO;
}
//进入登录页
-(void)nextClicked{
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 1;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;
    [[self.window layer] addAnimation:animation forKey:@"animation"];
    _log_View.hidden = NO;
    _fist_View.hidden = YES;
}
-(void)failedPrompt1:(NSString *)prompt{
    loadingV.hidden = YES;
//    [MyObject failedPrompt1:prompt];
    label_prompt.text = prompt;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
}
//登录事件
-(void)login{
    //发起登录请求
    if (userNameField.text.length == 0 || userPasswordField.text.length == 0) {
        [MyObject failedPrompt1:@"用户名或密码不能为空"];
    }else{
//        loadingV.hidden = NO;
        [MyObject startLoadingInSuperview:_window];
        NSString *url = [NSString stringWithFormat:@"%@%@?userName=%@&password=%@&device=iOS",SELLER_URL,USERLOGIN_URL,[userNameField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],userPasswordField.text];;
        [myAfnetwork url:url verify:@"" getChat:^(myselfParse * myParse) {
            loadingV.hidden = YES;
            _myParse = myParse;
            NSDictionary *dicBig = _myParse.dicBig;
            NSLog(@"dicBig:%@",dicBig);
            if (dicBig) {
                //保存聊天所需的参数
                NSNumber *service_id = dicBig[@"service_id"];
                if (service_id) {
                    [[NSUserDefaults standardUserDefaults]setObject:service_id forKey:@"chat_need_service_id"];
                }
                //账户判断
                if ([[dicBig objectForKey:@"code"] intValue] == -300) {
                    [MyObject failedPrompt1:@"密码不正确!"];
                    [MyObject endLoading];
                }else if ([[dicBig objectForKey:@"code"] intValue] == -200){
                    [MyObject failedPrompt1:@"该帐号不是商家!"];
                    [MyObject endLoading];
                }else if ([[dicBig objectForKey:@"code"] intValue] == -100){
                    [MyObject failedPrompt1:@"账号不存在!"];
                    [MyObject endLoading];
                }else{
                    [MyObject failedPrompt1:@"登录成功!"];
                    
                    UITabBarController *tab  = (UITabBarController *)_window.rootViewController;
                    tab.selectedIndex = 0;
                    
                    CATransition *animation = [CATransition animation];
                    animation.delegate = self;
                    animation.duration = 1;
                    animation.timingFunction = UIViewAnimationCurveEaseInOut;
                    animation.type = kCATransitionFade;
                    [[self.window layer] addAnimation:animation forKey:@"animation"];
                    _log_View.hidden = YES;
                    _fist_View.hidden = YES;
                    
                    //推送绑定
//                    [MyNetTool pushBind];
                    //保存得到的token userid
                    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                    NSString *filePaht = [documentsPath stringByAppendingPathComponent:@"user_information.txt"];
                    NSArray *array = [NSArray arrayWithObjects:[dicBig objectForKey:@"token"],[dicBig objectForKey:@"userName"],[dicBig objectForKey:@"user_id"],[dicBig objectForKey:VERIFY], nil];
                    NSLog(@"服务器返回登录信息:%@",dicBig);
                    [array writeToFile:filePaht atomically:YES];
                    
                    MyHomeViewController *home=[MyHomeViewController sharedUserDefault];
                    [home network];
                    [MyObject endLoading];
                }
            }
        }
                 failure:^(){
                     [MyObject failedPrompt1:@"未能连接到服务器"];
                     [MyObject endLoading];
                 } ];
    }
}

-(void)doTimer{
    label_prompt.hidden = YES;
}


#pragma mark - textField 代理
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    

    
    CGFloat keyboardHeight = 216.0f;
    if (self.window.frame.size.height - keyboardHeight <= textField.frame.origin.y + textField.frame.size.height) {
        CGFloat y = textField.frame.origin.y - (self.window.frame.size.height - keyboardHeight - textField.frame.size.height-80);
        [UIView beginAnimations:@"srcollView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.275f];
        self.window.frame = CGRectMake(self.window.frame.origin.x, -y, self.window.frame.size.width, self.window.frame.size.height);
        [UIView commitAnimations];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [userPasswordField resignFirstResponder];
    [userNameField resignFirstResponder];
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    self.window.frame = CGRectMake(self.window.frame.origin.x, 0, self.window.frame.size.width, self.window.frame.size.height);
    [UIView commitAnimations];
    return YES;
}
#pragma mark -去评价App 1.7 00025
-(void)createGoReview{
    NSInteger num = 0;
    NSUserDefaults *defau = [NSUserDefaults standardUserDefaults];
    if ([defau objectForKey:@"loginAppNum"]) {//不是第一次进入
        num = [[defau objectForKey:@"loginAppNum"] integerValue];
        num++;
        [defau setObject:[NSNumber numberWithInteger:num] forKey:@"loginAppNum"];
    }else{//第一次进入
        [defau setObject:[NSNumber numberWithInteger:num] forKey:@"loginAppNum"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSInteger loginNum = [[defau objectForKey:@"loginAppNum"] integerValue];
    NSInteger notToLoginNum = [[defau objectForKey:@"notToCommentNum"] integerValue];
    NSLog(@"loginNum = %ld ,notToLoginNum=%ld",(long)loginNum,(long)notToLoginNum);
    
    if(loginNum%20==0 && loginNum!=0 && notToLoginNum < 3){
        [OHAlertView showAlertWithTitle:@"求五星好评~~" message:@"程序猿熬夜奋战，只为您更好的体验!" cancelButton:nil otherButtons:@[@"去评价",@"离开"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            if(buttonIndex==0){
                //去评价
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPSTORE_URL]];
            }else{
                //离开
                NSUserDefaults *defau = [NSUserDefaults standardUserDefaults];
                if ([defau objectForKey:@"notToCommentNum"]) {//不是第一次拒绝
                    NSInteger nonum = [[defau objectForKey:@"notToCommentNum"] integerValue];
                    nonum++;
                    [defau setObject:[NSNumber numberWithInteger:nonum] forKey:@"notToCommentNum"];
                }else{//第一次拒绝
                    [defau setObject:[NSNumber numberWithInteger:num] forKey:@"notToCommentNum"];
                }
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }];
    }else{
    }
    //    测试使用
    //        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginAppNum"];
    //        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"notToCommentNum"];
    //        [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
