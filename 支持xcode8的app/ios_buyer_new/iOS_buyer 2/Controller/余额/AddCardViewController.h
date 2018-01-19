//
//  AddCardViewController.h
//  BinbCardDemo
//
//  Created by 邱炯辉 on 16/7/11.
//  Copyright © 2016年 mlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCardViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *sureBut;
@property (weak, nonatomic) IBOutlet UITextField *pwTF;
@property(nonatomic, copy)NSString *md5PW;
@end
