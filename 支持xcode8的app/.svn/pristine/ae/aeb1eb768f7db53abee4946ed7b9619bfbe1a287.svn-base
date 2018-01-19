//
//  MyorderViewController.m
//  My_App
//
//  Created by 邱炯辉 on 16/6/11.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "MyorderViewController.h"
#import "NewLoginViewController.h"
#import "OrderListViewController.h"
@interface MyorderViewController ()
@property(nonatomic,strong)    OrderListViewController *vc;
;
@end

@implementation MyorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"订单";
  
    self.tabBarController.tabBar.hidden=NO;
    self.navigationController.navigationBar.barTintColor = RGB_COLOR(219,34,46);
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    NSLog(@"navigationController==%@",self.navigationController);
//    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
 self.navigationController.navigationBar.translucent = NO;


}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self begin];

}
//随着状态不同,切换title
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"订单";
    }
    return self;
}
-(void)begin{
    // 判断用户是否登录
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSFileManager *fileManagerDong = [NSFileManager defaultManager];
    if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
        
        UIAlertController *vcqq=[UIAlertController alertControllerWithTitle:@"" message:@"您尚未登录，请登录！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIWindow *w=[[UIApplication sharedApplication].delegate window] ;
          UITabBarController *t= (UITabBarController*) w.rootViewController;
            t.selectedIndex=4;
        }];
        [vcqq addAction:action];
        [self presentViewController:vcqq animated:YES completion:nil];
      
        
//        NewLoginViewController *vc = [[NewLoginViewController alloc]initWithNibName:@"NewLoginViewController" bundle:nil];
        
//        [self.view addSubview:vc.view];
//        [self addChildViewController:vc];
//        vc.view.frame=CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-64);
//        vc->tabbarshouldShow=YES;
//
//        self.tabBarController.tabBar.hidden=NO;

    }else{
        
#pragma mark -这里做了优化处理，因为每次点击到这份tabbarItem都是会创建的，所以改成懒加载了
  
        [self.view addSubview:self.vc.view];
        [self addChildViewController:self.vc];
        self.vc.view.frame=CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-64-49-10);
        self.tabBarController.tabBar.hidden=NO;

    }
}


-(OrderListViewController *)vc{
    if (_vc==nil) {
        _vc=[[OrderListViewController alloc]init];
        _vc->tabbarshouldShow=YES;
        _vc.changeviewFrame=YES;
    }
    return _vc;
}
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:YES];
//    [[self navigationController] setNavigationBarHidden:NO animated:NO];
//}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:YES];
//    self.tabBarController.tabBar.hidden = NO;
////    [[self navigationController] setNavigationBarHidden:no animated:animated];
//}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
