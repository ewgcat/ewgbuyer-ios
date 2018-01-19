//
//  CartCell.m
//  My_App
//
//  Created by apple on 14-7-29.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "CartCell.h"
#import "ThirdViewController.h"

static CartCell *singleInstance=nil;

@implementation CartCell


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

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];

    _count.delegate = self;
    
    ThirdViewController *ht = [ThirdViewController sharedUserDefault];
    ht.littlecount = [_count.text intValue];
    jie = 0;
    _minusLabel.layer.borderWidth = 0.5;
    _minusLabel.layer.borderColor = [MY_COLOR CGColor];
    CALayer *lay1  = _minusLabel.layer;
    [lay1 setMasksToBounds:YES];
    [lay1 setCornerRadius:6.0];
    
    _plusLabel.layer.borderWidth = 0.5;
    _plusLabel.layer.borderColor = [MY_COLOR CGColor];
    CALayer *lay2  = _plusLabel.layer;
    [lay2 setMasksToBounds:YES];
    [lay2 setCornerRadius:6.0];
    
    _count.layer.borderWidth = 0.5;
    _count.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    CALayer *lay3  = _count.layer;
    [lay3 setMasksToBounds:YES];
    [lay3 setCornerRadius:6.0];
    
    _photoImage.layer.borderWidth = 0.5;
    _photoImage.layer.borderColor = [[UIColor grayColor] CGColor];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    qianCount = [_count.text intValue];
    return NO;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{

    
    return YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)doTimer
{
    [labelTi removeFromSuperview];
}
- (IBAction)btnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    ThirdViewController *ht = [ThirdViewController sharedUserDefault];
    if (btn.tag == 101) {
        btn.enabled = NO;
        if (ht.myBool2 == NO) {
            //点击了全选
            if ([_count.text intValue] >1) {
                NSInteger zhi = [_count.text intValue] - 1;
                _count.text = [NSString stringWithFormat:@"%ld",(long)zhi];
                btn.enabled = NO;
                
                NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *documentsPath = [docPath objectAtIndex:0];
                NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
                NSFileManager *fileManagerDong = [NSFileManager defaultManager];
                NSString *URL_manager;
                if([fileManagerDong fileExistsAtPath:filePathDong] == NO){
                    URL_manager = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&count=%@&cart_mobile_ids=%@&cart_id=%@",FIRST_URL,MYCARCOUNT_URL,@"",@"",[NSString stringWithFormat:@"%ld",(long)zhi] ,@"",_carid.text];
                }else{
                    URL_manager = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&count=%@&cart_mobile_ids=%@&cart_id=%@",FIRST_URL,MYCARCOUNT_URL,[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:3],[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:1],[NSString stringWithFormat:@"%ld",(long)zhi] ,@"",_carid.text];
                }
                NSURL *url2 = [NSURL URLWithString:URL_manager];
                ASIFormDataRequest *request102=[ASIFormDataRequest requestWithURL:url2];
                
                [request102 setRequestHeaders:[LJControl requestHeaderDictionary]];
                request102.tag = 102;
                request102.delegate =self;
                [request102 setDidFailSelector:@selector(my1_urlRequestFailed:)];
                [request102 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
                [request102 startAsynchronous];
            }else{
                _minuBtn.enabled = YES;
                _count.text = [NSString stringWithFormat:@"1"];
            }
        }else{
            if ([_count.text intValue] >1) {
                NSInteger zhi = [_count.text intValue] - 1;
                _count.text = [NSString stringWithFormat:@"%ld",(long)zhi];
                btn.enabled = NO;
                
                NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *documentsPath = [docPath objectAtIndex:0];
                NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
                NSFileManager *fileManagerDong = [NSFileManager defaultManager];
                NSString *URL_manager;
                if([fileManagerDong fileExistsAtPath:filePathDong] == NO){
                    URL_manager = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&count=%@&cart_mobile_ids=%@&cart_id=%@",FIRST_URL,MYCARCOUNT_URL,@"",@"",[NSString stringWithFormat:@"%ld",(long)zhi] ,@"",_carid.text];
                }else{
                    URL_manager = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&count=%@&cart_mobile_ids=%@&cart_id=%@",FIRST_URL,MYCARCOUNT_URL,[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:3],[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:1],[NSString stringWithFormat:@"%ld",(long)zhi] ,@"",_carid.text];
                }
                
                NSURL *url2 = [NSURL URLWithString:URL_manager];
                ASIFormDataRequest *request102=[ASIFormDataRequest requestWithURL:url2];
                
                [request102 setRequestHeaders:[LJControl requestHeaderDictionary]];
                request102.tag = 102;
                request102.delegate =self;
                [request102 setDidFailSelector:@selector(my2_urlRequestFailed:)];
                [request102 setDidFinishSelector:@selector(my2_urlRequestSucceeded:)];
                [request102 startAsynchronous];
            }else{
                _minuBtn.enabled = YES;
                _count.text = [NSString stringWithFormat:@"1"];
            }
        }
    }
    if (btn.tag == 102) {
        btn.enabled = NO;
        if (ht.myBool2 == NO) {
            NSInteger zhi = [_count.text intValue]+1;
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSFileManager *fileManagerDong = [NSFileManager defaultManager];
            NSString *URL_manager;
            if([fileManagerDong fileExistsAtPath:filePathDong] == NO){
                URL_manager = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&count=%@&cart_mobile_ids=%@&cart_id=%@",FIRST_URL,MYCARCOUNT_URL,@"",@"",[NSString stringWithFormat:@"%ld",(long)zhi] ,@"",_carid.text];
            }else{
                URL_manager = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&count=%@&cart_mobile_ids=%@&cart_id=%@",FIRST_URL,MYCARCOUNT_URL,[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:3],[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:1],[NSString stringWithFormat:@"%ld",(long)zhi] ,@"",_carid.text];
            }
            NSURL *url2 = [NSURL URLWithString:URL_manager];
            ASIFormDataRequest *request102=[ASIFormDataRequest requestWithURL:url2];
            
            [request102 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request102.tag = 102;
            request102.delegate =self;
            [request102 setDidFailSelector:@selector(my3_urlRequestFailed:)];
            [request102 setDidFinishSelector:@selector(my3_urlRequestSucceeded:)];
            [request102 startAsynchronous];
        }else{
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSInteger zhi = [_count.text intValue]+1;
            NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSFileManager *fileManagerDong = [NSFileManager defaultManager];
            NSString *URL_manager;
            if([fileManagerDong fileExistsAtPath:filePathDong] == NO){
                URL_manager = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&count=%@&cart_mobile_ids=%@&cart_id=%@",FIRST_URL,MYCARCOUNT_URL,@"",@"",[NSString stringWithFormat:@"%ld",(long)zhi] ,@"",_carid.text];
            }else{
                URL_manager = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&count=%@&cart_mobile_ids=%@&cart_id=%@",FIRST_URL,MYCARCOUNT_URL,[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:3],[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:1],[NSString stringWithFormat:@"%ld",(long)zhi] ,@"",_carid.text];
            }
            
            NSURL *url2 = [NSURL URLWithString:URL_manager];
            
            ASIFormDataRequest *request102=[ASIFormDataRequest requestWithURL:url2];
            
            [request102 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request102.tag = 102;
            request102.delegate =self;
            [request102 setDidFailSelector:@selector(my4_urlRequestFailed:)];
            [request102 setDidFinishSelector:@selector(my4_urlRequestSucceeded:)];
            [request102 startAsynchronous];
        }
    }
    if (btn.tag == 103) {
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        if([fileManagerDong fileExistsAtPath:filePathDong]==NO){
            NSArray *arr = [ht.cart_meideng componentsSeparatedByString:@","];
            if (arr.count == 0) {
                ht.cart_meideng = [NSString stringWithFormat: @"%@,%@",ht.cart_meideng,_carid.text];
                ht.jiesuan.text = [NSString stringWithFormat:@"1"];
                [ht.btnQ2 setTitle:[NSString stringWithFormat:@"结算(%@)",ht.jiesuan.text] forState:UIControlStateNormal];
            }else{
                BOOL arrBool = YES;
                NSMutableArray *arr2 = (NSMutableArray*)arr;
                //有问题
                for (int i=0; i<arr2.count; i++){
                    if ([_carid.text isEqualToString:[arr2 objectAtIndex:i]]) {
                        [arr2 removeObjectAtIndex:i];
                        arrBool = NO;
                    }
                }
                if (arrBool == YES) {
                    ht.cart_meideng = [NSString stringWithFormat: @"%@,%@",ht.cart_meideng,_carid.text];
                    ht.jiesuan.text = [NSString stringWithFormat:@"%d",1+[ht.jiesuan.text intValue]];
                    
                    [ht.btnQ2 setTitle:[NSString stringWithFormat:@"结算(%@)",ht.jiesuan.text] forState:UIControlStateNormal];
                }else{
                    NSString *str;
                    for (int i=0; i<arr2.count; i++){
                        if (str.length == 0) {
                            str = [NSString stringWithFormat:@"%@",[arr2 objectAtIndex:i]];
                        }else{
                            str = [NSString stringWithFormat:@"%@,%@",str,[arr2 objectAtIndex:i]];
                        }
                    }
                    ht.cart_meideng = str;
                    
                    ht.jiesuan.text = [NSString stringWithFormat:@"%d",[ht.jiesuan.text intValue]-1];
                    [ht.btnQ2 setTitle:[NSString stringWithFormat:@"结算(%@)",ht.jiesuan.text] forState:UIControlStateNormal];
                }
            }
            if (ht.cart_meideng.length == 0) {
                ht.btnQ2.backgroundColor = [UIColor grayColor];
            }else if ([ht.cart_meideng isEqualToString:@"(null)"]) {
                ht.btnQ2.backgroundColor = [UIColor grayColor];
            }else{
                ht.btnQ2.backgroundColor = MY_COLOR;
            }
            [ht.MyTableView reloadData];
            [ht tableviewRefrsh];
        }else{
            NSArray *arr = [ht.cart_ids componentsSeparatedByString:@","];
            if (arr.count == 0) {
                ht.btnQ2.enabled = YES;
                [ht.btnQ2 setBackgroundColor:MY_COLOR];
                ht.cart_ids = [NSString stringWithFormat: @"%@,%@",ht.cart_ids,_carid.text];
                ht.jiesuan.text = [NSString stringWithFormat:@"1"];
                [ht.btnQ2 setTitle:[NSString stringWithFormat:@"结算(%@)",ht.jiesuan.text] forState:UIControlStateNormal];
            }else{
                //怎么解决呢
                BOOL arrBool = YES;
                NSMutableArray *arr2 = (NSMutableArray*)arr;
                
                for (int i=0; i<arr.count; i++){
                    if (arr2.count == 1) {
                        if ([_carid.text isEqualToString:[arr objectAtIndex:i]]) {
                            arr2 = nil;
                            arrBool = NO;
                        }
                    }else{
                        if ([_carid.text isEqualToString:[arr objectAtIndex:i]]) {
                            [arr2 removeObjectAtIndex:i];
                            arrBool = NO;
                        }
                    }
                }
                if (arrBool == YES) {
                    ht.btnQ2.enabled = YES;
                    [ht.btnQ2 setBackgroundColor:MY_COLOR];
                    ht.cart_ids = [NSString stringWithFormat: @"%@,%@",ht.cart_ids,_carid.text];
                    ht.jiesuan.text = [NSString stringWithFormat:@"%d",1+[ht.jiesuan.text intValue]];
                    [ht.btnQ2 setTitle:[NSString stringWithFormat:@"结算(%@)",ht.jiesuan.text] forState:UIControlStateNormal];
                }else{
                    if (arr2.count==1) {
                        ht.btnQ2.enabled = NO;
                        [ht.btnQ2 setBackgroundColor:[UIColor darkGrayColor]];
                    }
                    NSString *str;
                    for (int i=0; i<arr2.count; i++){
                        if (str.length == 0) {
                            str = [NSString stringWithFormat:@"%@",[arr2 objectAtIndex:i]];
                        }else{
                            str = [NSString stringWithFormat:@"%@,%@",str,[arr2 objectAtIndex:i]];
                        }
                    }
                    ht.cart_ids = str;
                    ht.jiesuan.text = [NSString stringWithFormat:@"%d",[ht.jiesuan.text intValue]-1];
                    [ht.btnQ2 setTitle:[NSString stringWithFormat:@"结算(%@)",ht.jiesuan.text] forState:UIControlStateNormal];
                }
            }
            [ht.MyTableView reloadData];
            [ht tableviewRefrsh];
        }
    }
}
-(void)my4_urlRequestSucceeded:(ASIFormDataRequest *)request{
    ThirdViewController *ht = [ThirdViewController sharedUserDefault];
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"result=%@", dicBig);
        if ([[dicBig objectForKey:@"code"] intValue] == 100) {
            if ([[dicBig allKeys] containsObject:@"max_inventory"]){
                
                if ([[dicBig objectForKey:@"max_inventory"] intValue]>=[_count.text intValue]) {
                    
                }else{
                    labelTi = [[UILabel alloc] initWithFrame:CGRectMake((ScreenFrame.size.width-140)/2, 30, 140, 30)];
                    CALayer *lay2  = labelTi.layer;
                    [lay2 setMasksToBounds:YES];
                    [lay2 setCornerRadius:8.0];
                    
                    labelTi.text = @"库存不足";
                    labelTi.font = [UIFont systemFontOfSize:14];
                    labelTi.backgroundColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
                    labelTi.alpha = 1;
                    labelTi.textColor = [UIColor whiteColor];
                    labelTi.textAlignment = NSTextAlignmentCenter;
                    [self addSubview:labelTi];
                    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
                }
            }
        }else if([[dicBig objectForKey:@"code"] intValue] == -100){
            labelTi.text = @" F码商品一次只能购买一件!";
            labelTi.font = [UIFont systemFontOfSize:14];
            labelTi.backgroundColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
            labelTi.alpha = 1;
            labelTi.textColor = [UIColor whiteColor];
            labelTi.textAlignment = NSTextAlignmentCenter;
            [self addSubview:labelTi];
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
        }
        
        _plusBtn.enabled = YES;
        _minuBtn.enabled = YES;
        [ht tableviewRefrsh];
        
    }
    else{
        
        labelTi.hidden = NO;
        labelTi.text = @"网络请求失败";
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
        
    }
}
-(void)my4_urlRequestFailed:(ASIFormDataRequest *)request{
    
    labelTi.hidden = NO;
    labelTi.text = @"网络请求失败";
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
    
}
-(void)my3_urlRequestSucceeded:(ASIFormDataRequest *)request{
    ThirdViewController *ht = [ThirdViewController sharedUserDefault];
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"result=%@", dicBig);
        if ([[dicBig allKeys] containsObject:@"max_inventory"]){
            if ([[dicBig objectForKey:@"max_inventory"] intValue]>=[_count.text intValue]) {
                
            }else{
                labelTi = [[UILabel alloc] initWithFrame:CGRectMake((ScreenFrame.size.width-140)/2, 30, 140, 30)];
                CALayer *lay2  = labelTi.layer;
                [lay2 setMasksToBounds:YES];
                [lay2 setCornerRadius:8.0];
                
                labelTi.text = @"库存不足";
                labelTi.font = [UIFont systemFontOfSize:14];
                labelTi.backgroundColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
                labelTi.alpha = 1;
                labelTi.textColor = [UIColor whiteColor];
                labelTi.textAlignment = NSTextAlignmentCenter;
                [self addSubview:labelTi];
                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
            }
        }
        _plusBtn.enabled = YES;
        _minuBtn.enabled = YES;
        [ht tableviewRefrsh];
        
    }else{
        
        labelTi.hidden = NO;
        labelTi.text = @"网络请求失败";
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
        
    }
    
}
-(void)my3_urlRequestFailed:(ASIFormDataRequest *)request{
    
    labelTi.hidden = NO;
    labelTi.text = @"网络请求失败";
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
    
}
-(void)my2_urlRequestSucceeded:(ASIFormDataRequest *)request{
    ThirdViewController *ht = [ThirdViewController sharedUserDefault];
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"result=%@", dicBig);
        if ([[dicBig allKeys] containsObject:@"max_inventory"]){
            if ([[dicBig objectForKey:@"max_inventory"] intValue]>=[_count.text intValue]) {
                
            }else{
                labelTi = [[UILabel alloc] initWithFrame:CGRectMake((ScreenFrame.size.width-140)/2, 30, 140, 30)];
                CALayer *lay2  = labelTi.layer;
                [lay2 setMasksToBounds:YES];
                [lay2 setCornerRadius:8.0];
                
                labelTi.text = @"库存不足";
                labelTi.font = [UIFont systemFontOfSize:14];
                labelTi.backgroundColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
                labelTi.alpha = 1;
                labelTi.textColor = [UIColor whiteColor];
                labelTi.textAlignment = NSTextAlignmentCenter;
                [self addSubview:labelTi];
                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
            }
        }
        _plusBtn.enabled = YES;
        _minuBtn.enabled = YES;
        [ht tableviewRefrsh];
        
    }else{
        labelTi.hidden = NO;
        labelTi.text = @"请求出错";
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
    }
    
}
-(void)my2_urlRequestFailed:(ASIFormDataRequest *)request{
    
    labelTi.hidden = NO;
    labelTi.text = @"网络请求失败";
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
    
}
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    ThirdViewController *ht = [ThirdViewController sharedUserDefault];
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"result=%@", dicBig);
        if ([[dicBig allKeys] containsObject:@"max_inventory"]){
            if ([[dicBig objectForKey:@"max_inventory"] intValue]>=[_count.text intValue]) {
            }else{
                labelTi = [[UILabel alloc] initWithFrame:CGRectMake((ScreenFrame.size.width-140)/2, 30, 140, 30)];
                CALayer *lay2  = labelTi.layer;
                [lay2 setMasksToBounds:YES];
                [lay2 setCornerRadius:8.0];
                
                labelTi.text = @"库存不足";
                labelTi.font = [UIFont systemFontOfSize:14];
                labelTi.backgroundColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
                labelTi.alpha = 1;
                labelTi.textColor = [UIColor whiteColor];
                labelTi.textAlignment = NSTextAlignmentCenter;
                [self addSubview:labelTi];
                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
            }
        }
        _plusBtn.enabled = YES;
        _minuBtn.enabled = YES;
        
        
    }
    else{
        labelTi.hidden = NO;
        labelTi.text = @"请求出错";
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
    }
    [ht tableviewRefrsh];
}
-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{
    
    labelTi.hidden = NO;
    labelTi.text = @"网络请求失败";
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
    
}
@end
