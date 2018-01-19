//
//  huiyuanxieyiViewController.m
//  My_App
//
//  Created by 邱炯辉 on 16/7/7.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "huiyuanxieyiViewController.h"
#import "CurrentRankViewController.h"
@interface huiyuanxieyiViewController ()

@end

@implementation huiyuanxieyiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"message:@"是否首次升级"preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"否"style:UIAlertActionStyleCancel handler:^(UIAlertAction*action) {
        CurrentRankViewController *vc=[[CurrentRankViewController alloc]init];
        [self.navigationController  pushViewController:vc animated:YES];
        NSMutableArray *oldVCs = [self.navigationController.viewControllers mutableCopy];

        UIViewController *v=oldVCs.firstObject;
        [oldVCs removeAllObjects];
        [oldVCs addObject:v];
        [oldVCs addObject:vc];

        self.navigationController.viewControllers = oldVCs;

      
    }]];
    [alert addAction: [UIAlertAction actionWithTitle:@"是"style:UIAlertActionStyleDestructive handler:^(UIAlertAction*action) {
        UIWebView *v=[[UIWebView alloc]initWithFrame:self.view.bounds];
        NSString *urlstring=[NSString stringWithFormat:@"%@%@",FIRST_URL,@"/app/vip_level_doc.htm"];
        
        [v loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlstring]]];
        [self.view addSubview:v];
        
        
        UIBarButtonItem *b=[[UIBarButtonItem alloc]initWithTitle:@"同意" style:UIBarButtonItemStyleDone target:self action:@selector(agree)];
        self.navigationItem.rightBarButtonItem=b;
        
           }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}
-(void)agree{
    
    
    CurrentRankViewController *vc=[[CurrentRankViewController alloc]init];
    [self.navigationController  pushViewController:vc animated:YES];
    NSMutableArray *oldVCs = [self.navigationController.viewControllers mutableCopy];
    
    UIViewController *v=oldVCs.firstObject;
    [oldVCs removeAllObjects];
    [oldVCs addObject:v];
    [oldVCs addObject:vc];

    self.navigationController.viewControllers = oldVCs;


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
