//
//  AppDelegate.m
//  My_App
//
//  Created by apple on 14-7-28.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"
#import "ThirdViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FouthViewController.h"
#import "LoginViewController.h"
#import "OrderListViewController.h"
#import "NewLoginViewController.h"
#import "OnlinePayTypeSelectViewController.h"
#import "onlinePayTypesIntegralViewController.h"
#import "SYOrderDetailsTableViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "pinyin.h"
#import "NotifWebViewController.h"
#import "UMSocialSinaSSOHandler.h"
#import "DetailViewController.h"
#import "SearchViewController.h"
#import "MyCollectViewController.h"
#import "CartViewController.h"
#import "UPPaymentControl.h"
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "MyorderViewController.h"

#import <Bugly/Bugly.h>


#define BUGLY_APP_ID @"fd66561109"


extern CFAbsoluteTime startTime;
CFAbsoluteTime timeOnUI;

@interface AppDelegate ()<UIAlertViewDelegate,BuglyDelegate
>
{
    int _flag;//更新状态
}
@property (retain, nonatomic)UITabBarController *tabVC;



@end

@implementation AppDelegate

-(BOOL)handleOpenURL:(NSURL *)url{
    NSLog(@"url:%@",url);
    //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    WXApiManager *manager = [WXApiManager sharedManager];
    NSString *str = [NSString stringWithFormat:@"%@",url];
    if([[[str componentsSeparatedByString:@":"] objectAtIndex:0] isEqualToString:WXAppId]){
        if ([[[str componentsSeparatedByString:@"="] objectAtIndex:1]  isEqualToString:@"wechat"]){
            return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        }else if ([str rangeOfString:@"oauth?code"].location != NSNotFound){
            NSLog(@"第三方登录成功");
//            return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
            manager.backType = backTypeAuth;
            return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        }else if ([[[str componentsSeparatedByString:@"&ret="] objectAtIndex:1] intValue] == 0) {
            //微信支付成功
            NSLog(@"微信支付成功");
            manager.backType = backTypePaySuccess;
        }else if ([[[str componentsSeparatedByString:@"&ret="] objectAtIndex:1] intValue] == -1){
            //错误
            NSLog(@"错误");
            
            manager.backType = backTypePayError;
        }else{
            //用户取消
            NSLog(@"用户取消");
            manager.backType = backTypeCancelOrder;
        }
        return  [WXApi handleOpenURL:url delegate:manager];
    }
    
    return YES;
}
-(BOOL)UMSocialSnsSerhandleOpenURL:(NSURL *)url{
    return [UMSocialSnsService handleOpenURL:url];;
}
-(BOOL)TencentOAuthhandleOpenURL:(NSURL *)url{
    return [TencentOAuth HandleOpenURL:url];;
}
-(BOOL)WeiBohandleOpenURL:(NSURL *)url{
    return [WeiboSDK handleOpenURL:url delegate:[WBApiManager sharedManager]];
}
-(BOOL)UnionpayOpenURL:(NSURL *)url{
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        //结果code为成功时，先校验签名，校验成功后做后续处理
        if([code isEqualToString:@"success"]) {
            //判断签名数据是否存在
            if(data == nil){
                //如果没有签名数据，建议商户app后台查询交易结果
                return;
            }
            //数据从NSDictionary转换为NSString
            NSData *signData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
            NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
            //验签证书同后台验签证书
            //此处的verify，商户需送去商户后台做验签
            if([self verify:sign]) {
                //支付成功且验签成功，展示支付成功提示
            }else {
                //验签失败，交易结果数据被篡改，商户app后台查询交易结果
            }
        }else if([code isEqualToString:@"fail"]) {
            //交易失败
        }else if([code isEqualToString:@"cancel"]) {
            //交易取消
        }
    }];
    
    return YES;


}
-(BOOL) verify:(NSString *) resultStr {
    
    //验签证书同后台验签证书
    //此处的verify，商户需送去商户后台做验签
    return NO;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSLog(@"URL scheme:%@", [url scheme]);
    NSLog(@"URL query: %@", [url query]);
    if ([[url scheme]isEqualToString:TencentSchemes]) {
        return [TencentOAuth HandleOpenURL:url];
    }else if ([[url scheme]isEqualToString:wbSchemes]) {
         return [WeiboSDK handleOpenURL:url delegate:[WBApiManager sharedManager]];
    }
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}
//iOS 9.0 以及以上系统
- (BOOL)application:(UIApplication *)app openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options{
    NSString*text=[[url host]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    

    NSLog(@"text=%@",text);
    NSLog(@"URL scheme:%@", [url scheme]);
    NSLog(@"URL query: %@", [url query]);
    if ([[url scheme]isEqualToString:@"ewgvipbuyer"]) {
        NSString *str=[[[url query] componentsSeparatedByString:@"&value="] objectAtIndex:1];
        SecondViewController *sec=[SecondViewController sharedUserDefault];
        sec.detail_id = str;
        DetailViewController *detail = [[DetailViewController alloc]init];
        UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
        UITabBarController *tabBar = (UITabBarController *)keyWindow.rootViewController;
        UINavigationController *navi1 = tabBar.selectedViewController;
        [navi1 pushViewController:detail animated:YES];
        return YES;
    }else if ([[url scheme]isEqualToString:@"tencent1105441034"]) {
        return [self UMSocialSnsSerhandleOpenURL:url];
    }else if ([[url scheme]isEqualToString:TencentSchemes]) {
        return [self TencentOAuthhandleOpenURL:url];
    }else if ([[url scheme]isEqualToString:wbSchemes]) {
        return [self WeiBohandleOpenURL:url];
    }else if ([[url scheme]isEqualToString:UPSchemes]) {
        return [self UnionpayOpenURL:url];
    }else{
        return [self handleOpenURL:url];
    }

}
//iOS9以下的系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
    NSLog(@"URL scheme:%@", [url scheme]);
    NSLog(@"URL query: %@", [url query]);
    if ([[url scheme]isEqualToString:@"ewgvipbuyer"]) {
        NSString *str=[[[url query] componentsSeparatedByString:@"&value="] objectAtIndex:1];
        SecondViewController *sec=[SecondViewController sharedUserDefault];
        sec.detail_id = str;
        DetailViewController *detail = [[DetailViewController alloc]init];
        UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
        UITabBarController *tabBar = (UITabBarController *)keyWindow.rootViewController;
        UINavigationController *navi1 = tabBar.selectedViewController;
        [navi1 pushViewController:detail animated:YES];
        return YES;
    }else if ([[url scheme]isEqualToString:@"tencent1105441034"]) {
        return [self UMSocialSnsSerhandleOpenURL:url];
    }else if ([[url scheme]isEqualToString:TencentSchemes]) {
        return [self TencentOAuthhandleOpenURL:url];
    }else if ([[url scheme]isEqualToString:wbSchemes]) {
        return [self WeiBohandleOpenURL:url];
    }else if ([[url scheme]isEqualToString:UPSchemes]) {
        return [self UnionpayOpenURL:url];
    }else{
        return [self handleOpenURL:url];
    }
}
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
//远程通知注册成功委托
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token1 = [NSString stringWithFormat:@"%@",deviceToken];
    NSString *token2 = [token1 stringByReplacingOccurrencesOfString:@"<" withString:@""];
    NSString *token3 = [token2 stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSString *token4 = [token3 stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSUserDefaults *def = [NSUserDefaults  standardUserDefaults];
    [def setObject:token4 forKey:@"deviceToken"];

    [SYShopAccessTool pushBind];
    NSLog(@"device token is %@",deviceToken);
}
//处理远程通知(web/order_id)
-(void)handleRemoteNotif:(NSDictionary *)userInfo type:(NSInteger)type{
    //type 后台/被杀死=0 程序正在运行=1
    
    UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
    UITabBarController *tabBar = (UITabBarController *)keyWindow.rootViewController;
    UINavigationController *navi1 = tabBar.selectedViewController;
    NSDictionary *aps = userInfo[@"aps"];
    NSDictionary *currentDict = userInfo;//aps==自己测试 userInfo==公司服务器
    
    if (type == 0 && [currentDict[@"type"] isEqualToString:@"web"]) {
        //后台网页
        NSString *urlStr = currentDict[@"value"];
        NSURL *url = [NSURL URLWithString:urlStr];
        NotifWebViewController *vc = [[NotifWebViewController alloc]init];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        vc.request = request;
        [navi1 pushViewController:vc animated:YES];
    }else if (type == 0 && [currentDict[@"type"] isEqualToString:@"order"]){
        //后台订单
        NSString *orderID = currentDict[@"value"];
        if ([SYObject currentUserID] == nil) {
            [SYObject failedPrompt:@"请先登录!" complete:^{
                [navi1 pushViewController:[NewLoginViewController new] animated:YES];
            }];
            return;
        }
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SYOrderStoryboard" bundle:nil];
        SYOrderDetailsTableViewController *detailTVC = [sb instantiateViewControllerWithIdentifier:@"orderDetails"];
        detailTVC.orderID = [SYObject stringByNumber:orderID];
        [navi1 pushViewController:detailTVC animated:YES];
    }else if (type == 1 && [currentDict[@"type"] isEqualToString:@"order"]){
        //前台订单
        if (UIDeviceHao>=9.0) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"您有新的通知" message:aps[@"alert"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *aa1 = [UIAlertAction actionWithTitle:@"去查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *orderID = userInfo[@"value"];
                if ([SYObject currentUserID] == nil) {
                    [SYObject failedPrompt:@"请先登录!" complete:^{
                        [navi1 pushViewController:[NewLoginViewController new] animated:YES];
                    }];
                    return;
                }
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SYOrderStoryboard" bundle:nil];
                SYOrderDetailsTableViewController *detailTVC = [sb instantiateViewControllerWithIdentifier:@"orderDetails"];
                detailTVC.orderID = [SYObject stringByNumber:orderID];
                [navi1 pushViewController:detailTVC animated:YES];
            }];
            UIAlertAction *aa2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [ac addAction:aa1];
            [ac addAction:aa2];
            
            [navi1 presentViewController:ac animated:YES completion:nil];
        }else{
        }
    }else{
        
    }
}
//远程通知注册失败委托(模拟器一定会注册失败)
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"注册失败，无法获取设备ID, 具体错误: %@", [error localizedDescription]);
}
#pragma mark -3D touch
-(void)init3DTouchActionShow{
    /** type 该item 唯一标识符
     localizedTitle ：标题
     localizedSubtitle：副标题
     icon：icon图标 可以使用系统类型 也可以使用自定义的图片
     userInfo：用户信息字典 自定义参数，完成具体功能需求
     */
    UIApplication *application = [UIApplication sharedApplication];
     UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch];
    UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc]initWithType:@"UITouchText.search" localizedTitle:@"搜索" localizedSubtitle:@"" icon:icon1 userInfo:nil];
    
    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"dingdan-icon-daishouhuo@2x.png"];
    UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc]initWithType:@"UITouchText.receipt" localizedTitle:@"待收货" localizedSubtitle:@"" icon:icon2 userInfo:nil];
    
    UIApplicationShortcutIcon *icon3 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"nav3.png"];
    UIApplicationShortcutItem *item3 = [[UIApplicationShortcutItem alloc]initWithType:@"UITouchText.shopping" localizedTitle:@"购物车" localizedSubtitle:@"" icon:icon3 userInfo:nil];
    
    UIApplicationShortcutIcon *icon4 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeLove];
    UIApplicationShortcutItem *item4 = [[UIApplicationShortcutItem alloc]initWithType:@"UITouchText.collection" localizedTitle:@"收藏" localizedSubtitle:@"" icon:icon4 userInfo:nil];
   application.shortcutItems = @[item1,item2,item3,item4];

}
- (void)application:(UIApplication *)application
performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem
  completionHandler:(void(^)(BOOL succeeded))completionHandler{
    //判断先前我们设置的唯一标识
    [self shortcutItemRespondingToEvents:shortcutItem];
   
}
-(void)shortcutItemRespondingToEvents:(UIApplicationShortcutItem *)shortcutItem{
    if([shortcutItem.type isEqualToString:@"UITouchText.search"]){
        SearchViewController *ordrt = [[SearchViewController alloc]init];
        UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
        UITabBarController *tabBar = (UITabBarController *)keyWindow.rootViewController;
        UINavigationController *navi1 = tabBar.selectedViewController;
        [navi1 pushViewController:ordrt animated:YES];
        
    }else if ([shortcutItem.type isEqualToString:@"UITouchText.receipt"]){
        if([[NSFileManager defaultManager] fileExistsAtPath:INFORMATION_FILEPATH] == NO){
            NewLoginViewController *new = [[NewLoginViewController alloc]init];
            UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
            UITabBarController *tabBar = (UITabBarController *)keyWindow.rootViewController;
            UINavigationController *navi1 = tabBar.selectedViewController;
            [navi1 pushViewController:new animated:YES];
        }else{
            LoginViewController *log=[LoginViewController sharedUserDefault];
            log.orderTag = 3;
            OrderListViewController *order = [[OrderListViewController alloc]init];
            UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
            UITabBarController *tabBar = (UITabBarController *)keyWindow.rootViewController;
            UINavigationController *navi1 = tabBar.selectedViewController;
            [navi1 pushViewController:order animated:YES];
        }
    }else if ([shortcutItem.type isEqualToString:@"UITouchText.shopping"]){
        if([[NSFileManager defaultManager] fileExistsAtPath:INFORMATION_FILEPATH] == NO){
            NewLoginViewController *new = [[NewLoginViewController alloc]init];
            UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
            UITabBarController *tabBar = (UITabBarController *)keyWindow.rootViewController;
            UINavigationController *navi1 = tabBar.selectedViewController;
            [navi1 pushViewController:new animated:YES];
        }else{
            CartViewController *cart = [[CartViewController alloc]init];
            UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
            UITabBarController *tabBar = (UITabBarController *)keyWindow.rootViewController;
            UINavigationController *navi1 = tabBar.selectedViewController;
            [navi1 pushViewController:cart animated:YES];
        }
    }else if ([shortcutItem.type isEqualToString:@"UITouchText.collection"]){
        if([[NSFileManager defaultManager] fileExistsAtPath:INFORMATION_FILEPATH] == NO){
            NewLoginViewController *new = [[NewLoginViewController alloc]init];
            UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
            UITabBarController *tabBar = (UITabBarController *)keyWindow.rootViewController;
            UINavigationController *navi1 = tabBar.selectedViewController;
            [navi1 pushViewController:new animated:YES];
        }else{
            MyCollectViewController *MyFavourite = [[MyCollectViewController alloc]init];
            UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
            UITabBarController *tabBar = (UITabBarController *)keyWindow.rootViewController;
            UINavigationController *navi1 = tabBar.selectedViewController;
            [navi1 pushViewController:MyFavourite animated:YES];
            
        }
    }
}
#pragma mark -定位
- (void)getCoreLocation{
    //    longv.hidden=YES;
    //[SYObject endLoading];
    _manager=[[CLLocationManager alloc]init];
    _manager.delegate=self;
    
    [_manager requestAlwaysAuthorization];
    [_manager requestWhenInUseAuthorization];
    
    // 设置定位精度
    // kCLLocationAccuracyNearestTenMeters:精度10米
    // kCLLocationAccuracyHundredMeters:精度100 米
    // kCLLocationAccuracyKilometer:精度1000 米
    // kCLLocationAccuracyThreeKilometers:精度3000米
    // kCLLocationAccuracyBest:设备使用电池供电时候最高的精度
    // kCLLocationAccuracyBestForNavigation:导航情况下最高精度，一般要有外接电源时才能使用
    _manager.desiredAccuracy = kCLLocationAccuracyBest;
    //有的时候我们不需要频繁获得数据，比如高速行驶的时候 如果不设置间隔，会频繁的调用GPS，造成耗费电量
    _manager.distanceFilter = 1000.0f;
    
    //开启定位
    [_manager startUpdatingLocation];
    
}
//新定位方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *newLocation=[locations lastObject];
    NSLog(@"%f~~~~%f",newLocation.coordinate.longitude,newLocation.coordinate.latitude);
    [colat setString:[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude ]];
    [colng setString:[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude]];
    
    [self getCityWith:newLocation];
    [_manager stopUpdatingLocation];
}
-(void)getCityWith:(CLLocation *)loca
{
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:loca completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if ([placemarks count]>0) {
            CLPlacemark *placemark=placemarks[0];
            NSDictionary *addressDicttionary=placemark.addressDictionary;
            NSString *address=[addressDicttionary objectForKey:(NSString *)kABPersonAddressStreetKey];
            address=address==nil?@"":address;
            NSString *state=[addressDicttionary objectForKey:(NSString *)kABPersonAddressStateKey];
            state=state==nil?@"":state;
            NSString *city=[addressDicttionary objectForKey:(NSString *)kABPersonAddressCityKey];
            city=city==nil?@"":city;
            
            NSString *subCity=[addressDicttionary objectForKey:@"SubLocality"];
            subCity=subCity==nil?@"":subCity;

            
            NSLog(@"位置%@",addressDicttionary);
            
            NSLog(@"%@~%@~%@~%@",address,state,city,subCity);
            
            NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
            [standard setObject:state forKey:@"stateNew"];
            [standard setObject:city forKey:@"cityNew"];
            [standard setObject:subCity forKey:@"subCityNew"];

            [standard synchronize];


        }else{
           
        }
    }];


}
//定位失败
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    
    colng=[[NSMutableString alloc]init];
    colat=[[NSMutableString alloc]init];
    [self getCoreLocation];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.vcCount = 0;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //适配
    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (ScreenFrame.size.height>480) {
        myDelegate.autoSizeScaleX=ScreenFrame.size.width/320;
        myDelegate.autoSizeScaleY=ScreenFrame.size.height/480;
    }else{
        
        myDelegate.autoSizeScaleX=1.0;
        myDelegate.autoSizeScaleY=1.0;
        
    }

    navArray = [[NSMutableArray alloc]init];

    //微信分享回调代理
    [WXApiManager sharedManager].delegate = self;
    
    //设置友盟Appkey
    [UMSocialData setAppKey:UmengAppkey];
   
    //设置微信AppId，设置分享url，默认使用友盟的网址
    
    
//    [UMSocialWechatHandler setWXAppId:@"wx4b3df472a8cd8a2e" appSecret:@"829174345912c0460937f1254a1e35b0" url:@"http://www.ewgvip.com"];
    
    [UMSocialWechatHandler setWXAppId:WXAppId appSecret:@"bbe60094191973ba485cb69c634e0e8d" url:@"http://www.ewgvip.com"];
    
    
    
    
    //设置手机QQ的AppId，指定你的分享url，若传nil，将使用友盟的网址
    [UMSocialQQHandler setQQWithAppId:@"1105441034" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
    
    //打开新浪微博的SSO开关
    //    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //微信注册
    [WXApi registerApp:WXAppId withDescription:@"demo"];
    
    //微博注册
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    
    
    
    
#pragma mark - bugly统计

    [self setupBugly];

    

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
//    //启动广告
//    [self getAdvertisement];
//    
//    CGSize viewSize = self.window.bounds.size;
//    NSString *viewOrientation = @"Portrait";    //横屏请设置成 @"Landscape"
//    NSString *launchImage = nil;
//    
//    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
//    for (NSDictionary* dict in imagesDict)
//    {
//        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
//        
//        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
//        {
//            launchImage = dict[@"UILaunchImageName"];
//        }
//    }
//    UIImageView *launchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchImage]];
//    
//    UIViewController *viewc = [[UIViewController alloc]init];
//    self.window.rootViewController = viewc;
//    viewc.view.backgroundColor=[UIColor colorWithPatternImage:launchView.image];
//    int badge =(int)[UIApplication sharedApplication].applicationIconBadgeNumber;
//    if(badge > 0)
//    {
//        badge = 0;
//        [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
//    }
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
//获取通讯录
    //    [self addressLIst];
    
//    //nav图片
//    if (networkIsOK) {
//        [self index_nav_request];//需要网络
//    }else{
//        [self createTabbar_image];
//    }
//
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];

//检查启动时间
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"本次启动耗时: %f 秒",CFAbsoluteTimeGetCurrent() - startTime);
//    });
    
//  求好评
//    [self createGoReview];
    //3D touch
    //    [self init3DTouchActionShow];
        if([launchOptions objectForKey:@"UIApplicationLaunchOptionsShortcutItemKey"]){//从标签进入
            _currentShortItem=launchOptions[@"UIApplicationLaunchOptionsShortcutItemKey"];
            //启动广告
            [self getAdvertisement];
            CGSize viewSize = self.window.bounds.size;
            NSString *viewOrientation = @"Portrait";    //横屏请设置成 @"Landscape"
            NSString *launchImage = nil;
            
            NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
            for (NSDictionary* dict in imagesDict)
            {
                CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
                
                if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
                {
                    launchImage = dict[@"UILaunchImageName"];
                }
            }
            UIImageView *launchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchImage]];
            
            UIViewController *viewc = [[UIViewController alloc]init];
            self.window.rootViewController = viewc;
            viewc.view.backgroundColor=[UIColor colorWithPatternImage:launchView.image];
            int badge =(int)[UIApplication sharedApplication].applicationIconBadgeNumber;
            if(badge > 0)
            {
                badge = 0;
                [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
            }
            self.window.backgroundColor = [UIColor whiteColor];
            [self.window makeKeyAndVisible];
           return NO;
        }else{//不是从标签进入
            _currentShortItem=launchOptions[@"UIApplicationLaunchOptionsShortcutItemKey"];
            //启动广告
            [self getAdvertisement];
            
            CGSize viewSize = self.window.bounds.size;
            NSString *viewOrientation = @"Portrait";    //横屏请设置成 @"Landscape"
            NSString *launchImage = nil;
            
            NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
            for (NSDictionary* dict in imagesDict)
            {
                CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
                
                if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
                {
                    launchImage = dict[@"UILaunchImageName"];
                }
            }
            UIImageView *launchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchImage]];
            
            UIViewController *viewc = [[UIViewController alloc]init];
            self.window.rootViewController = viewc;
            viewc.view.backgroundColor=[UIColor colorWithPatternImage:launchView.image];
            int badge =(int)[UIApplication sharedApplication].applicationIconBadgeNumber;
            if(badge > 0)
            {
                badge = 0;
                [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
            }
            self.window.backgroundColor = [UIColor whiteColor];
            [self.window makeKeyAndVisible];

           return YES;
        }
    
    return YES;
}

- (void)setupBugly {
    // Get the default config
    BuglyConfig * config = [[BuglyConfig alloc] init];
    
    // Open the debug mode to print the sdk log message.
    // Default value is NO, please DISABLE it in your RELEASE version.
#if DEBUG
    config.debugMode = NO;
#endif
    
    // Open the customized log record and report, BuglyLogLevelWarn will report Warn, Error log message.
    // Default value is BuglyLogLevelSilent that means DISABLE it.
    // You could change the value according to you need.
    config.reportLogLevel = BuglyLogLevelWarn;
    
    // Open the STUCK scene data in MAIN thread record and report.
    // Default value is NO
    config.blockMonitorEnable = YES;
    
    // Set the STUCK THRESHOLD time, when STUCK time > THRESHOLD it will record an event and report data when the app launched next time.
    // Default value is 3.5 second.
    config.blockMonitorTimeout = 1.5;
    
    // Set the app channel to deployment
    config.channel = @"Bugly";
    
    config.delegate = self;
    
    // NOTE:Required
    // Start the Bugly sdk with APP_ID and your config
    [Bugly startWithAppId:BUGLY_APP_ID
#if DEBUG
        developmentDevice:YES
#endif
                   config:config];
    
    // Set the customizd tag thats config in your APP registerd on the  bugly.qq.com
    // [Bugly setTag:1799];
    
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", [UIDevice currentDevice].name]];
    
    [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"Process"];
    
    // NOTE: This is only TEST code for BuglyLog , please UNCOMMENT it in your code.
    [self performSelectorInBackground:@selector(testLogOnBackground) withObject:nil];
}
/**
 *    @brief TEST method for BuglyLog
 */
- (void)testLogOnBackground {
    int cnt = 0;
    while (1) {
        cnt++;
        
        switch (cnt % 5) {
            case 0:
                BLYLogError(@"Test Log Print %d", cnt);
                break;
            case 4:
                BLYLogWarn(@"Test Log Print %d", cnt);
                break;
            case 3:
                BLYLogInfo(@"Test Log Print %d", cnt);
                BLYLogv(BuglyLogLevelWarn, @"BLLogv: Test", NULL);
                break;
            case 2:
                BLYLogDebug(@"Test Log Print %d", cnt);
                BLYLog(BuglyLogLevelError, @"BLLog : %@", @"Test BLLog");
                break;
            case 1:
            default:
                BLYLogVerbose(@"Test Log Print %d", cnt);
                break;
        }
        
        // print log interval 1 sec.
        sleep(1);
    }
}

- (NSString *)attachmentForException:(NSException *)exception {
    NSLog(@"Callback: trap exception: %@", exception);
    
    return @"This is an attachment";
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
    
    if(loginNum%30==0 && loginNum!=0 && notToLoginNum < 3){
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

}

#pragma mark -进入主页
-(void)pushHomeController{
    //检查网络连通性
    self.imageView.hidden = YES;
    BOOL networkIsOK = [Requester isNetworkOK];
    if (networkIsOK) {
        [self index_nav_request];//需要网络
    }else{
        [self createTabbar_image];
    }
//    [self.window makeKeyAndVisible];
    //检查启动时间
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"本次启动耗时: %f 秒",CFAbsoluteTimeGetCurrent() - startTime);
    });
    if (_currentShortItem!=nil) {
        //标签进入响应事件
        [self shortcutItemRespondingToEvents:_currentShortItem];
    }else{
        //求好评
        
        [self createGoReview];
    }
    
   
}
#pragma mark -获得广告
-(void)getAdvertisement{
    
#if 1
    NSString * urlstr=[NSString stringWithFormat:@"%@%@",FIRST_URL,LAUNCH_AD_URL];
    [[Requester managerWithHeader]GET:urlstr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dicBig=responseObject;
        NSLog(@"广告dicBig:%@",dicBig);
        NSLog(@"code=%@",[dicBig objectForKey:@"code"]);
        if (dicBig) {
            //如果code＝＝100是有广告图片
            if ([[dicBig objectForKey:@"code"] intValue] == 100) {

                UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height) ];
                [imageView sd_setImageWithURL:[NSURL URLWithString:[dicBig objectForKey:@"img_url"]] placeholderImage:[UIImage imageNamed:@""]];

                
                self.imageView = imageView;
                [self.window addSubview:imageView];
                [self performSelector:@selector(pushHomeController) withObject:nil afterDelay:4.0f];

                

            }else{
                [self pushHomeController];
            }
        }else{
            [self pushHomeController];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self pushHomeController];
    }];
#endif


}
-(void)index_nav_request{
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]];
    NSString *url = [NSString stringWithFormat:@"%@%@",FIRST_URL,INDEX_NAV_URL];
    NSString *verify ;
    if([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]]==NO){
        verify = @"";
    }else{
        verify = [fileContent2 objectAtIndex:4];
    }

    NSMutableDictionary *dicMy3 = [[NSMutableDictionary alloc]initWithObjects:@[verify] forKeys:@[VERIFY]];

    
    [[Requester managerWithHeader]POST:url parameters:dicMy3 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        [self index_nav_analyzeSuccess:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",[error localizedDescription]);
        
        //创建tabbar
        [self createTabbar_image];
        launch_ad_View.hidden = YES;
        
    }];
}

-(void)index_nav_analyzeSuccess:(id)responseData{
        //返回code值判断登录是否成功
        NSDictionary *dicBig =responseData;
        NSLog(@"nav_dicBig:%@",dicBig);
        if (navArray.count!=0) {
            [navArray removeAllObjects];
        }
        if (dicBig) {
            if ([[dicBig objectForKey:@"code"] intValue] == 100) {
                for(int i=1;i<6;i++){
                    NSArray *arr = [[NSArray alloc]initWithObjects:[dicBig objectForKey:[NSString stringWithFormat:@"nav_%da",i]],[dicBig objectForKey:[NSString stringWithFormat:@"nav_%db",i]], nil];
                    [navArray addObject:arr];
                }
                if ([[dicBig objectForKey:@"navigator_bar"] isEqualToString:@"true"]) {
                    //创建网络tabbar
                    [self createTabbar_netimage];
                }else if ([[dicBig objectForKey:@"navigator_bar"] isEqualToString:@"false"]) {
                    //创建tabbar
                    [self createTabbar_image];
                }else{
                    //其他情况选择本地的tabbar
                    [self createTabbar_image];
                }
//                //创建网络tabbar
//                [self createTabbar_netimage];
            }else{
                //创建tabbar
                [self createTabbar_image];
            }
        }
    
}
-(void)failedPrompt:(NSString *)prompt{
    labelTi.hidden = NO;
    labelTi.text = prompt;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
}
-(void)doTimer{
    labelTi.hidden = YES;
}
#pragma mark - 创建tabbar
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
-(UIImage *)reture_imageNavIndex:(int ) navIndex SelectIndex:(int ) selectIndex{
    UIImage* image=nil;
    NSArray *arr = [navArray objectAtIndex:navIndex];
    NSString* path = nil;
    if (arr && arr.count != 0) {
        path =[arr objectAtIndex:selectIndex];
    }
    NSURL* url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];//网络图片url
    NSData* data = [NSData dataWithContentsOfURL:url];//获取网络图片数据
    if(data!=nil){
        image = [[UIImage alloc] initWithData:data];
        //缩放图片
        CGSize size = {30,30};
        image = [self scaleToSize:image size:size];
    }
    return image;
}
#pragma mark -UIImage变为NSData并进行压缩
-(UIImage*)uiimageChangNsData:(NSString *)imageName{
    NSString *path = [[NSBundle mainBundle]pathForResource:imageName ofType:@"png"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage* image = [[UIImage alloc]initWithData:data scale:2.0f];
    return image;
}

// 没进入的方法
-(void)createTabbar_image{
    UITabBarController *tb=[[UITabBarController alloc]init];
    self.tabVC = tb;
    self.window.rootViewController=tb;
//    CGSize size = {28,28};
    FirstViewController *c1=[[FirstViewController alloc]init];
    c1.tabBarItem.title=@"首页";
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:c1];
    nav.tabBarItem.image = [[self uiimageChangNsData:@"nav1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [[self uiimageChangNsData:@"nav11"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [nav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor darkGrayColor]} forState:UIControlStateNormal];
    [nav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:0.97f green:0.39f blue:0.06f alpha:1.00f]} forState:UIControlStateSelected];
    
    SecondViewController *c2=[[SecondViewController alloc]init];
    c2.tabBarItem.title=@"分类";
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:c2];
    
    nav1.tabBarItem.image = [[self uiimageChangNsData:@"nav2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav1.tabBarItem.selectedImage = [[self uiimageChangNsData:@"nav22"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [nav1.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor darkGrayColor]} forState:UIControlStateNormal];
    [nav1.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:0.97f green:0.39f blue:0.06f alpha:1.00f]} forState:UIControlStateSelected];
    
    ThirdViewController *c3=[[ThirdViewController alloc]init];
    c3.tabBarItem.title=@"购物车";
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:c3];
    nav2.tabBarItem.image = [[self uiimageChangNsData:@"nav3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav2.tabBarItem.selectedImage = [[self uiimageChangNsData:@"nav33"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [nav2.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor darkGrayColor]} forState:UIControlStateNormal];
    [nav2.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:0.97f green:0.39f blue:0.06f alpha:1.00f]} forState:UIControlStateSelected];
    
//    FouthViewController *c4=[[FouthViewController alloc]init];
//    c4.tabBarItem.title=@"品牌";
//    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:c4];
//    nav3.tabBarItem.image = [[self uiimageChangNsData:@"nav4"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    nav3.tabBarItem.selectedImage = [[self uiimageChangNsData:@"nav44"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [nav3.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor darkGrayColor]} forState:UIControlStateNormal];
//    [nav3.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:0.97f green:0.39f blue:0.06f alpha:1.00f]} forState:UIControlStateSelected];
    
    LoginViewController *c5=[[LoginViewController alloc]init];
    c5.tabBarItem.title=@"个人中心";
    UINavigationController *nav4 = [[UINavigationController alloc]initWithRootViewController:c5];
    nav4.tabBarItem.image = [[self uiimageChangNsData:@"nav5"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav4.tabBarItem.selectedImage = [[self uiimageChangNsData:@"nav55"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [nav4.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor darkGrayColor]} forState:UIControlStateNormal];
    [nav4.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:0.97f green:0.39f blue:0.06f alpha:1.00f]} forState:UIControlStateSelected];
    
#pragma mark -明烙华添加
    
    MyorderViewController *c4=[[MyorderViewController alloc]init];
    c4.tabBarItem.title=@"订单";
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:c4];
    nav3.tabBarItem.image = [[self uiimageChangNsData:@"nav4"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav3.tabBarItem.selectedImage = [[self uiimageChangNsData:@"nav44"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [nav3.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor darkGrayColor]} forState:UIControlStateNormal];
    [nav3.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:0.97f green:0.39f blue:0.06f alpha:1.00f]} forState:UIControlStateSelected];
    
    tb.viewControllers=@[nav,nav1,nav2,nav3,nav4];
}
// 有网络连接就从网络请求图片
-(void)createTabbar_netimage{
    UITabBarController *tb=[[UITabBarController alloc]init];
    self.tabVC = tb;
    self.window.rootViewController=tb;
    
    FirstViewController *c1=[[FirstViewController alloc]init];
    c1.tabBarItem.title=@"首页";
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:c1];
    nav.tabBarItem.image = [[self reture_imageNavIndex:0 SelectIndex:0] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [[self reture_imageNavIndex:0 SelectIndex:1] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [nav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor darkGrayColor]} forState:UIControlStateNormal];
    [nav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:0.97f green:0.39f blue:0.06f alpha:1.00f]} forState:UIControlStateSelected];
    
    SecondViewController *c2=[[SecondViewController alloc]init];
    c2.tabBarItem.title=@"分类";
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:c2];
    
    nav1.tabBarItem.image = [[self reture_imageNavIndex:1 SelectIndex:0] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav1.tabBarItem.selectedImage = [[self reture_imageNavIndex:1 SelectIndex:1] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [nav1.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor darkGrayColor]} forState:UIControlStateNormal];
    [nav1.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:0.97f green:0.39f blue:0.06f alpha:1.00f]} forState:UIControlStateSelected];
    
    ThirdViewController *c3=[[ThirdViewController alloc]init];
    c3.tabBarItem.title=@"购物车";
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:c3];
    nav2.tabBarItem.image = [[self reture_imageNavIndex:2 SelectIndex:0]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav2.tabBarItem.selectedImage = [[self reture_imageNavIndex:2 SelectIndex:1]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [nav2.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor darkGrayColor]} forState:UIControlStateNormal];
    [nav2.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:0.97f green:0.39f blue:0.06f alpha:1.00f]} forState:UIControlStateSelected];
    
//    FouthViewController *c4=[[FouthViewController alloc]init];
//    c4.tabBarItem.title=@"品牌";
//    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:c4];
//    nav3.tabBarItem.image = [[self reture_imageNavIndex:3 SelectIndex:0]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    nav3.tabBarItem.selectedImage = [[self reture_imageNavIndex:3 SelectIndex:1]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [nav3.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor darkGrayColor]} forState:UIControlStateNormal];
//    [nav3.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:0.97f green:0.39f blue:0.06f alpha:1.00f]} forState:UIControlStateSelected];
    
    LoginViewController *c5=[[LoginViewController alloc]init];
    c5.tabBarItem.title=@"个人中心";
    UINavigationController *nav4 = [[UINavigationController alloc]initWithRootViewController:c5];
    nav4.tabBarItem.image = [[self reture_imageNavIndex:4 SelectIndex:0]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav4.tabBarItem.selectedImage = [[self reture_imageNavIndex:4 SelectIndex:1]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [nav4.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor darkGrayColor]} forState:UIControlStateNormal];
    [nav4.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:0.97f green:0.39f blue:0.06f alpha:1.00f]} forState:UIControlStateSelected];
    
#pragma mark -明烙华添加
  
    
    MyorderViewController *c4=[[MyorderViewController alloc]init];
    c4.tabBarItem.title=@"订单";
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:c4];
    nav3.tabBarItem.image = [[self reture_imageNavIndex:3 SelectIndex:0]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav3.tabBarItem.selectedImage = [[self reture_imageNavIndex:3 SelectIndex:1]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [nav3.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor darkGrayColor]} forState:UIControlStateNormal];
    [nav3.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:0.97f green:0.39f blue:0.06f alpha:1.00f]} forState:UIControlStateSelected];
    
    tb.viewControllers=@[nav,nav1,nav2,nav3,nav4];
//    //tabBar纯白背景
//    UIImage *bgImg = [[UIImage alloc] init];
//    [tb.tabBar setBackgroundImage:bgImg];
//    [tb.tabBar setShadowImage:bgImg];
//    if (UIDeviceHao>=7.0) {
//        [[UITabBar appearance] setSelectionIndicatorImage:bgImg];
//    }
}
#pragma mark - 点击事件
-(void)passBtnClicked{
    launch_ad_View.hidden = YES;
}


-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{



}
#pragma mark - 生命周期方法
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
