//
//  AddCardViewController.m
//  BinbCardDemo
//
//  Created by 邱炯辉 on 16/7/11.
//  Copyright © 2016年 mlh. All rights reserved.
//

#import "AddCardViewController.h"
#import "AddCard2ViewController.h"
#import "CommonCrypto/CommonDigest.h"
@interface AddCardViewController ()

@end

@implementation AddCardViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.pwTF.selected=YES;
        self.sureBut.layer.masksToBounds=YES;
        self.sureBut.layer.cornerRadius=5;

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.pwTF.secureTextEntry=YES;
    self.sureBut.layer.masksToBounds=YES;
    [self.sureBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sureBut.layer.cornerRadius=5;

}
- (IBAction)makesureAction:(id)sender {
    NSString *md5String=[self md5:self.pwTF.text];
    NSLog(@"md5String==%@",md5String);
    if ([md5String isEqualToString:_md5PW]) {
        
        AddCard2ViewController *vc=[[AddCard2ViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];

    }else{
        [SYObject failedPrompt:@"支付密码错误"];
    }
    
}
- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
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
