//
//  ScanScanViewController.m
//  My_App
//
//  Created by barney on 16/3/30.
//  Copyright © 2016年 barney. All rights reserved.
//

#import "ScanScanViewController.h"
#import "DetailViewController.h"
#import "ScanLoginViewController.h"
#import "SecondViewController.h"
#import "FirstViewController.h"
#import "NewLoginViewController.h"

@interface ScanScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
    SecondViewController *sec;

}
@property (strong, nonatomic) UIView *viewPreview;
@property (strong, nonatomic) UIView *boxView;
@property (nonatomic) BOOL isReading;
@property (strong, nonatomic) CALayer *scanLayer;
@property (nonatomic, strong) UIImageView * line;
@property (nonatomic, strong) NSString *scanStr;
@property (nonatomic, assign) BOOL yici;
@property (nonatomic, strong) NSTimer *timer;

-(BOOL)startReading;
-(void)stopReading;

//捕捉会话
@property (nonatomic, strong) AVCaptureSession *captureSession;
//展示layer
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@end

@implementation ScanScanViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _captureSession = nil;
    _isReading = NO;
    num = 0;
    upOrdown = NO;
   [self startReading];
   self.tabBarController.tabBar.hidden=YES;
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = MY_COLOR;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self createBackBtn];
    self.title=@"扫一扫";
    self.viewPreview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    [self.view addSubview:self.viewPreview];
    
    
}
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{

     [self.navigationController popToRootViewControllerAnimated:YES];
    
}
-(void)cancelQr{
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)startReading {
    NSError *error;
    
    //1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //2.用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    //3.创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    //4.实例化捕捉会话
    _captureSession = [[AVCaptureSession alloc] init];
    
    //4.1.将输入流添加到会话
    [_captureSession addInput:input];
    
    //4.2.将媒体输出流添加到会话中
    [_captureSession addOutput:captureMetadataOutput];
    
    //5.创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    //5.1.设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    //5.2.设置输出媒体数据类型为QRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    //6.实例化预览图层
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    
    //7.设置预览图层填充方式
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //8.设置图层的frame
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    
    //9.将图层添加到预览view的图层上
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    //10.设置扫描范围
//    captureMetadataOutput.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.8f, 0.8f);
    captureMetadataOutput.rectOfInterest = CGRectMake(0, 0, 1, 1);
    
    //10.1.扫描框
//    _boxView = [[UIView alloc] initWithFrame:CGRectMake(_viewPreview.bounds.size.width * 0.2f, _viewPreview.bounds.size.height * 0.2f, _viewPreview.bounds.size.width - _viewPreview.bounds.size.width * 0.4f, _viewPreview.bounds.size.height - _viewPreview.bounds.size.height * 0.4f)];
//    _boxView.layer.borderColor = [UIColor greenColor].CGColor;
//    _boxView.layer.borderWidth = 1.0f;
//    
//    [_viewPreview addSubview:_boxView];
    
    UIColor *clear = [UIColor clearColor];
    UIView *topView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 36)];
    topView1.backgroundColor = clear;
    topView1.alpha = 0.5;
    [self.viewPreview addSubview:topView1];
    UIView *topView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 36, (ScreenFrame.size.width-240)/2, ScreenFrame.size.height-36-64)];
    topView2.backgroundColor = clear;
    topView2.alpha = 0.5;
    [self.viewPreview addSubview:topView2];
    UIView *topView3 = [[UIView alloc]initWithFrame:CGRectMake((ScreenFrame.size.width-240)/2+240, 36, (ScreenFrame.size.width-240)/2, ScreenFrame.size.height-100)];
    topView3.backgroundColor = clear;
    topView3.alpha = 0.5;
    [self.viewPreview addSubview:topView3];
    UIView *topView4 = [[UIView alloc]initWithFrame:CGRectMake((ScreenFrame.size.width-240)/2, 276, 240, ScreenFrame.size.height-64)];
    topView4.backgroundColor = clear;
    topView4.alpha = 0.5;
    [self.viewPreview addSubview:topView4];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, topView4.frame.origin.y, self.viewPreview.frame.size.width, 40)];
    label.text = @"将二维码放入框内，即可自动扫描";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.font = [UIFont boldSystemFontOfSize:17];
    label.backgroundColor = clear;
    [self.view addSubview:label];
    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pick_bg.png"]];
    image.frame = CGRectMake((ScreenFrame.size.width-240)/2, 36, 240, 240);
    [self.viewPreview addSubview:image];
    
//    UIView *topView5 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 64)];
//    topView5.backgroundColor = clear;
//    [self.viewPreview addSubview:topView5];
//    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.backgroundColor = clear;
//    btn.frame = CGRectMake(10, 25, 33, 33);
//    UIImage *img = [UIImage imageNamed:@"back_lj"];
//    [btn setBackgroundImage:img forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
//    [btn addTarget:self action:@selector(cancelQr) forControlEvents:UIControlEventTouchUpInside];
//    [topView5 addSubview:btn];
//    
//    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, ScreenFrame.size.width, 44)];
//    labelTitle.text = @"扫一扫";
//    labelTitle.textColor = [UIColor whiteColor];
//    labelTitle.font = [UIFont boldSystemFontOfSize:17];
//    labelTitle.textAlignment = NSTextAlignmentCenter;
//    [topView5 addSubview:labelTitle];
    
    //10.2.扫描线
//    _scanLayer = [[CALayer alloc] init];
//    _scanLayer.frame = CGRectMake(0, 0, _boxView.bounds.size.width, 1);
//    _scanLayer.backgroundColor = [UIColor brownColor].CGColor;
//    
//    [_boxView.layer addSublayer:_scanLayer];
    _line = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenFrame.size.width-240)/2, 104-64, 240, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.viewPreview addSubview:_line];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    _timer= timer;
    [timer fire];
    
    //10.开始扫描
    [_captureSession startRunning];
    
    
    return YES;
}
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake((ScreenFrame.size.width-240)/2, 104-64+2*num, 240, 2);
        if (2*num == 240) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake((ScreenFrame.size.width-240)/2, 104-64+2*num, 240, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
}

-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
//    [_scanLayer removeFromSuperlayer];
    [_line removeFromSuperview];
    [_videoPreviewLayer removeFromSuperlayer];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    [_timer invalidate];
    _timer = nil;
    
    //判断是否有数据
    if (self.yici) {
        return;
    }
    
    self.yici = YES;
    
    
    
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSLog(@"扫描结果......%@",metadataObj);
        //判断回传的数据类型
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            _isReading = NO;
            //[self dismissViewControllerAnimated:YES completion:nil];
            
            //判断是否包含 头'http:'
            NSString *regex = @"http+:[^\\s]*";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
            
            //判断是否包含 头'ssid:'
            NSString *ssid = @"ssid+:[^\\s]*";;
            NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
            
            _scanStr =  metadataObj.stringValue ;
            
            if ([predicate evaluateWithObject:_scanStr]) {
                
            }else if([ssidPre evaluateWithObject:_scanStr]){
                NSArray *arr = [_scanStr componentsSeparatedByString:@";"];
                NSArray * arrInfoHead = [[arr objectAtIndex:0] componentsSeparatedByString:@":"];
                NSArray * arrInfoFoot = [[arr objectAtIndex:1] componentsSeparatedByString:@":"];
                _scanStr= [NSString stringWithFormat:@"ssid: %@ \n password:%@", [arrInfoHead objectAtIndex:1],[arrInfoFoot objectAtIndex:1]];
                UIPasteboard *pasteboard=[UIPasteboard generalPasteboard];
                pasteboard.string = [arrInfoFoot objectAtIndex:1];
            }
            //首先 判断是扫码登陆 还是商品跳转
            NSLog(@"scanStr:%@",_scanStr);
            if([_scanStr rangeOfString:@"qr_session_id="].location !=NSNotFound)
            {
                BOOL login;
                [SYObject hasUserLogedIn:&login];
                if (login) {
                    FirstViewController *first = [FirstViewController sharedUserDefault];
                    first.scanStr = _scanStr;
                    NSArray *arr = [_scanStr componentsSeparatedByString:@"qr_session_id="];
                    if (arr.count==0) {
                    }else if (arr.count == 1){
                        //商品分支
                        [self isZipField:_scanStr];
                    }else{
                        //登录分支
                        [self isScanLogin:_scanStr];
                    }
 
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NewLoginViewController *loginVC = [[NewLoginViewController alloc]init];
                        [self.navigationController pushViewController:loginVC animated:NO];
                         NSMutableArray *oldVCs = [self.navigationController.viewControllers mutableCopy];
                        [oldVCs removeObjectAtIndex:oldVCs.count - 2];
                        self.navigationController.viewControllers = oldVCs;
                    });
                }
            }else if ([_scanStr rangeOfString:@"goods_"].location !=NSNotFound){
                //        [NSString stringWithFormat:@"%@/goods_",FIRST_URL]
                [self isZipField:_scanStr];
               // [self dismissViewControllerAnimated:YES completion:nil];
//                 [self.navigationController popViewControllerAnimated:YES];
            }else{
                //[self dismissViewControllerAnimated:YES completion:nil];
//                 [self.navigationController popViewControllerAnimated:YES];
            }
            
            
        }
    }
}
-(BOOL)isScanLogin:(NSString *)zip
{
    if (zip.length == 0) {
        return YES;
    }
    else{
        NSString *zipRegex = @"iskyshop_login\\.htm\\?qr_session_id=([A-Za-z0-9_-])+";
        NSPredicate *zipTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",zipRegex];
        BOOL isMatch = [zipTest evaluateWithObject:zip];
        if (!isMatch) {
            dispatch_async(dispatch_get_main_queue(), ^{
                ScanLoginViewController *sss = [[ScanLoginViewController alloc]init];
                [self.navigationController pushViewController:sss animated:NO];
            });
            
            //[self presentViewController:sss animated:YES completion:nil];
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
}
-(BOOL)isZipField:(NSString *)zip
{
    if (zip.length == 0) {
        return YES;
    }
    else{
        NSString *zipRegex = [NSString stringWithFormat:@"%@/%@",FIRST_URL,@"goods_(\\d)+"];
        NSPredicate *zipTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",zipRegex];
        BOOL isMatch = [zipTest evaluateWithObject:zip];
        if (!isMatch) {
            
            NSArray *arr = [_scanStr componentsSeparatedByString:[NSString stringWithFormat:@"/goods_"]];
            NSString *SSS = [arr objectAtIndex:1];
            NSArray *arr2 = [SSS componentsSeparatedByString:@".htm"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                SecondViewController *second = [SecondViewController sharedUserDefault];
                second.detail_id = [arr2 objectAtIndex:0];
                DetailViewController *detail = [[DetailViewController alloc]init];
                [self.navigationController pushViewController:detail animated:NO];
                NSMutableArray *arr = [self.navigationController.viewControllers mutableCopy];
                [arr removeObjectAtIndex:(arr.count - 2)];
                
                self.navigationController.viewControllers = arr;
            });
           
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
}

- (void)moveScanLayer:(NSTimer *)timer
{
    CGRect frame = _line.frame;
    if (_boxView.frame.size.height < _scanLayer.frame.origin.y) {
        frame.origin.y = 0;
        _scanLayer.frame = frame;
    }else{
        
        frame.origin.y += 5;
        
        [UIView animateWithDuration:0.1 animations:^{
            _scanLayer.frame = frame;
        }];
    }
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end
