//
//  ShouRuViewController.m
//  My_App
//
//  Created by 邱炯辉 on 16/11/23.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "ShouRuViewController.h"

@interface ShouRuViewController ()<UITextFieldDelegate>
{
    UITextField *tf;
}
@end

@implementation ShouRuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    int height=44;
    UIView *myview=[[UIView alloc]initWithFrame:CGRectMake(0, 20, ScreenFrame.size.width, height)];
    myview.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:myview];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, height)];
    label.text=@"金额：";
    label.textAlignment=NSTextAlignmentCenter;
    [myview addSubview:label];
    
    tf=[[UITextField alloc]initWithFrame:CGRectMake(100, 0, 200, height)];
    tf.placeholder=@"请输入提现金额";
    tf.delegate=self;
    [myview addSubview:tf];
    
    
    UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
    [but setTitle:@"提交" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(clk:) forControlEvents:UIControlEventTouchUpInside];
    but.layer.cornerRadius=8;
    but.layer.masksToBounds=YES;
    but.frame=CGRectMake(30, 100, ScreenFrame.size.width-60, 40);
    but.backgroundColor=[UIColor redColor];
    [self.view addSubview:but];
}
-(void)clk:(UIButton *)sender{

    if (tf.text.length==0) {
        [SYObject failedPrompt:@"请输入正确的金额"];
        return;
    }
    [SYObject startLoading];
    NSString *urlStr= [NSString stringWithFormat:@"%@%@",FIRST_URL,@"/app/buyer/promotion_income_withdrawal_save.htm"];
    
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    
    NSDictionary *par=@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1],@"cash_amount":tf.text};
    //
    __weak typeof(self) ws= self;
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject==%@",responseObject);
        NSString *ret=[NSString stringWithFormat:@"%@",responseObject[@"result"]];
        [SYObject failedPrompt:ret];
        
        if ([responseObject[@"code"] intValue]==100) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        [SYObject endLoading];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"**%@",[error localizedDescription]);
        [SYObject endLoading];
        
    }];
}

#pragma mark UITextField



- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string

{

        
        NSScanner      *scanner    = [NSScanner scannerWithString:string];
        
        NSCharacterSet *numbers;
        
        NSRange        pointRange = [textField.text rangeOfString:@"."];
        
        if ( (pointRange.length > 0) && (pointRange.location < range.location  || pointRange.location > range.location + range.length) )
            
        {
            
            numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
            
        }
        
        else
            
        {
            
            numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
            
        }
        
        if ( [textField.text isEqualToString:@""] && [string isEqualToString:@"."] )
            
        {
            
            return NO;
            
        }
        
        short remain = 2; //默认保留2位小数
        
        NSString *tempStr = [textField.text stringByAppendingString:string];
        
        NSUInteger strlen = [tempStr length];
        
        if(pointRange.length > 0 && pointRange.location > 0){ //判断输入框内是否含有“.”。
            
            if([string isEqualToString:@"."]){ //当输入框内已经含有“.”时，如果再输入“.”则被视为无效。
                
                return NO;
                
            }
            
            if(strlen > 0 && (strlen - pointRange.location) > remain+1){ //当输入框内已经含有“.”，当字符串长度减去小数点前面的字符串长度大于需要要保留的小数点位数，则视当次输入无效。
                
                return NO;
                
            }
            
        }
        
        NSRange zeroRange = [textField.text rangeOfString:@"0"];
        
        if(zeroRange.length == 1 && zeroRange.location == 0){ //判断输入框第一个字符是否为“0”
            
            if(![string isEqualToString:@"0"] && ![string isEqualToString:@"."] && [textField.text length] == 1){ //当输入框只有一个字符并且字符为“0”时，再输入不为“0”或者“.”的字符时，则将此输入替换输入框的这唯一字符。
                
                textField.text = string;
                
                return NO;
                
            }else{
                
                if(pointRange.length == 0 && pointRange.location > 0){ //当输入框第一个字符为“0”时，并且没有“.”字符时，如果当此输入的字符为“0”，则视当此输入无效。
                    
                    if([string isEqualToString:@"0"]){
                        
                        return NO;
                        
                    }
                    
                }
                
            }
            
        }
        
        NSString *buffer;
        
        if ( ![scanner scanCharactersFromSet:numbers intoString:&buffer] && ([string length] != 0) )
            
        {
            
            return NO;
            
        }
        

    return YES;
    
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
