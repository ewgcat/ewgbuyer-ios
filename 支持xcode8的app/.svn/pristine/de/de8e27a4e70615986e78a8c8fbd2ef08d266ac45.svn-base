//
//  ContactUsViewController.m
//  My_App
//
//  Created by apple on 14-8-29.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "ContactUsViewController.h"
#import "ASIFormDataRequest.h"

@interface ContactUsViewController ()

@end

@implementation ContactUsViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [requestContactUs2 clearDelegatesAndCancel];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"联系我们";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,CONTENTUS_URL]];
    requestContactUs2 = [ASIFormDataRequest requestWithURL:url2];
    
    [requestContactUs2 setRequestHeaders:[LJControl requestHeaderDictionary]];
    requestContactUs2.tag = 301;
    [requestContactUs2 setDelegate:self];
    [requestContactUs2 setDidFailSelector:@selector(urlRequestFailed:)];
    [requestContactUs2 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    
    [requestContactUs2 startAsynchronous];
    
    [self createBackBtn];
    UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backBtnClicked)];
    rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];
    // Do any additional setup after loading the view from its nib.
}

-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int stauscode2 = [request responseStatusCode];
    if (stauscode2 == 200) {
        [SYObject endLoading];
        
        NSDictionary *dicBig = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig:%@",dicBig);
        lblRegisterName.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"qq_list"]];
        lblTelphone.text = [NSString stringWithFormat:@"%@",[dicBig objectForKey:@"telphone_list"]];
    }
    
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
}

-(UIView *)loadingView:(CGRect)rect
{
    UIView *loadV=[[UIView alloc]initWithFrame:rect];
    loadV.backgroundColor=[UIColor blackColor];
    loadV.alpha = 0.8;
    UIActivityIndicatorView *activityIndicatorV=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorV.center=CGPointMake(rect.size.width/2, rect.size.height/2-10);
    [activityIndicatorV startAnimating];
    
    [loadV addSubview:activityIndicatorV];
    UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(0, 70, 100, 30)];
    la.text=@"正在加载...";
    la.backgroundColor=[UIColor clearColor];
    la.textAlignment=NSTextAlignmentCenter;
    la.textColor=[UIColor whiteColor];
    la.font=[UIFont boldSystemFontOfSize:15];
    [loadV addSubview:la];
    loadV.layer.cornerRadius=4;
    loadV.layer.masksToBounds=YES;
    return loadV;
}


-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;

    
}
-(void)backBtnClicked{
    [requestContactUs2 cancel];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
