//
//  forgetViewController.h
//  My_App
//
//  Created by apple on 15/7/29.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface forgetViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate>{
    __weak IBOutlet UIWebView *myWebview;
}

@end
