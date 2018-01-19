//
//  AddCard2ViewController.m
//  BinbCardDemo
//
//  Created by 邱炯辉 on 16/7/11.
//  Copyright © 2016年 mlh. All rights reserved.
//

#import "AddCard2ViewController.h"
#import "CommonCrypto/CommonDigest.h"
@interface AddCard2ViewController ()<UITextFieldDelegate>

@end

@implementation AddCard2ViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //        self.pwTF.selected=YES;
       
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.nextBut.layer.masksToBounds=YES;
    self.nextBut.layer.cornerRadius=5;
    self.title=@"绑定银行卡";
    self.nameLabel.delegate=self;
    self.cardNumLabel.delegate=self;
    self.pay_pw.delegate=self;
    self.phoneLabel.delegate=self;
//    保存银行卡\
//    /app/save_bankcard.htm
//    参数
//    user_id
//    token
//    user_name 持卡人
//    card_number 银行卡号码
//    passwd 支付密码
//    mobile 银行预留手机号码
//    返回
//    ret{1正常,-1未登录,-2信息不全,-3登录密码错误,-4银行卡已经绑定,-5银行卡号错误}
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)validateData{
    
    
    if (_nameLabel.text ==nil || [_nameLabel.text isEqualToString:@""]) {
        [SYObject failedPrompt:@"持卡人不能为空"];
        return;
    }
    
    if (_cardNumLabel.text ==nil || [_cardNumLabel.text isEqualToString:@""]) {
        [SYObject failedPrompt:@"银行卡号码不能为空"];
        return;

    }
    if (_pay_pw.text ==nil || [_pay_pw.text isEqualToString:@""]) {
        [SYObject failedPrompt:@"支付密码不能为空"];
        return;

    }
    if (_phoneLabel.text ==nil || [_phoneLabel.text isEqualToString:@""]) {
        [SYObject failedPrompt:@"预留手机不能为空"];
        return;

    }
//1.先验证银行卡
    

    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,@"/verify_bankcard.htm"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *postString=[NSString stringWithFormat:@"card_number=%@",_cardNumLabel.text];
    request.HTTPBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    // 由于要先对request先行处理,我们通过request初始化task
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//
        
        NSString *ret=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"===%@",ret);
        if ([ret isEqualToString:@"true"]) {
                [self postData];
        }else if ([ret isEqualToString:@"false"]){
            [SYObject failedPrompt:@"银行卡异常"];
                        
        }

    }];
    [task resume];
}
-(void)postData{
    
    NSString *urlStr= [NSString stringWithFormat:@"%@%@",FIRST_URL,@"/app/save_bankcard.htm"];
    
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    
    NSDictionary *par=@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1],@"user_name":_nameLabel.text,@"card_number":_cardNumLabel.text,@"passwd":_pay_pw.text ,@"mobile":_phoneLabel.text};
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSLog(@"======%@",dic);
        NSString *ret=[NSString stringWithFormat:@"%@",responseObject[@"ret"]];
        
        if ([ret isEqualToString:@"1"]) {
            [SYObject failedPrompt:@"绑定成功"];
          NSMutableArray *arr= [self.navigationController.viewControllers mutableCopy];
            [arr removeLastObject];
            [arr removeLastObject];
            self.navigationController.viewControllers=arr;
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if ([ret isEqualToString:@"-1"]){
            [SYObject failedPrompt:@"未登录"];
            
        }else if ([ret isEqualToString:@"-2"]){
            [SYObject failedPrompt:@"信息不全"];
            
        }else if ([ret isEqualToString:@"-3"]){
            [SYObject failedPrompt:@"支付密码错误"];
            
        }else if ([ret isEqualToString:@"-4"]){
            [SYObject failedPrompt:@"银行卡已经绑定"];
            
        }else if ([ret isEqualToString:@"-5"]){
            [SYObject failedPrompt:@"银行卡号错误"];
            
        }
        [SYObject endLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        [SYObject endLoading];
        
    }];
    

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

- (IBAction)nextAciton:(id)sender {
    [self validateData];
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
