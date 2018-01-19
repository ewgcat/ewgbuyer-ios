//
//  MypostViewController.m
//  My_App
//
//  Created by 邱炯辉 on 16/6/23.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "MypostViewController.h"

#import "CustomActionSheet.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
@interface MypostViewController ()<CustomActionSheetDelegate,TencentSessionDelegate>
{
    TencentOAuth *_tencentOAuth;
    NSString *posturl;
      UIImageView *v;
}
@property(nonatomic,strong)UIScrollView *scrollview;
@end
@implementation MypostViewController
-(UIScrollView *)scrollview{
    if (_scrollview==nil) {
       _scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-64)];
        
        
        _scrollview.contentSize=CGSizeMake(ScreenFrame.size.width, ScreenFrame.size.height-64+70);
        [self.view addSubview:_scrollview];

    }
    return _scrollview;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIBarButtonItem *barItem =[[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    self.navigationItem.rightBarButtonItem = barItem;
    [self getData];
}
-(void)getData{
    
    [SYObject startLoading];
    
    
    ASIFormDataRequest *request102;
    
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,@"/app/buyer/poster.htm"]];
    request102=[ASIFormDataRequest requestWithURL:url];
    [request102 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request102 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    
    [request102 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request102.tag = 102;
    [request102 setDelegate:self];
    [request102 setDidFailSelector:@selector(urlRequestFailed:)];
    [request102 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [request102 startAsynchronous];
    
}

#pragma mark - 网络
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    
    NSLog(@"code=%d",statuscode2);
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig:122%@",dicBig);
        if (dicBig[@"poster_url"]) {
          
            
            if (_scrollview==nil) {
                //保证这里只执行一行
               v=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-64-20)];
               
                [self.scrollview addSubview:v];
                
                UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(v.frame),  ScreenFrame.size.width, 70)];
                
                [self.scrollview addSubview:bottomView];
                
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, ScreenFrame.size.width, 25)];
                label.text=@"如果您的海报有问题,请点击下方按钮重新获取";
                label.textColor=[UIColor lightGrayColor];
                label.textAlignment=NSTextAlignmentCenter;
                label.font=[UIFont systemFontOfSize:15];
                [bottomView addSubview:label];
                
                
                UIButton *but=[[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(label.frame)+5, ScreenFrame.size.width-20*2, 35)];
                but.backgroundColor=[UIColor redColor];
                but.layer.cornerRadius=10;
                but.layer.masksToBounds=YES;
                [but setTitle:@"获取海报" forState:UIControlStateNormal];
                [but addTarget:self action:@selector(getPoster) forControlEvents:UIControlEventTouchUpInside];
                
                [bottomView addSubview:but];
                
                //如果图片不出来的文字底部的说明
            }
            v.contentMode = UIViewContentModeScaleAspectFit;
            [v sd_setImageWithURL:[NSURL URLWithString:dicBig[@"poster_url"]]];
            posturl=dicBig[@"poster_url"];
          
           }
   
        
    }
    [SYObject endLoading];
}
#pragma mark - 获取最新海报

-(void)getPoster{
    [SYObject startLoading];
        NSString *urlStr= [NSString stringWithFormat:@"%@%@",FIRST_URL,@"/app/buyer/resetPoster.htm"];
        
        NSArray *fileContent2 = [MyUtil returnLocalUserFile];
        
        NSDictionary *par=@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1]};
        __weak typeof(self) ws= self;
        [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"responseObject==%@",responseObject);
            if (responseObject[@"resetPoster_url"]) {
                [v sd_setImageWithURL:[NSURL URLWithString:responseObject[@"resetPoster_url"]]];
               posturl=responseObject[@"resetPoster_url"];
            }
            
            [SYObject endLoading];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",[error localizedDescription]);
            [SYObject endLoading];
            
        }];
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)share{
    CustomActionSheet* sheet = [[CustomActionSheet alloc] initWithButtons:[NSArray arrayWithObjects:[CustomActionSheetButton buttonWithImage:[UIImage imageNamed:@"share_02.png"] title:@"微信联系人"],
                                                                           [CustomActionSheetButton buttonWithImage:[UIImage imageNamed:@"share_01.png"] title:@"微信朋友圈"],
                                                                           
                                                                           [CustomActionSheetButton buttonWithImage:[UIImage imageNamed:@"share_05.png"] title:@"QQ好友"],
                                                                           [CustomActionSheetButton buttonWithImage:[UIImage imageNamed:@"share_03.png"] title:@"QQ空间"],
                                                                           nil]];
    
    //  明烙华把新郎微博分享取消                             [CustomActionSheetButton buttonWithImage:[UIImage imageNamed:@"share_04.png"] title:@"新浪微博"],
    sheet.delegate=self;
    [sheet showInView:self.navigationController.view];
    
    
    
}
#pragma mark -CustomActionSheetDelegate
-(void)choseAtIndex:(int)index{
#warning 这里先用假数据
    NSArray *dataArray = nil;
    
    
    ClassifyModel *classify = [dataArray objectAtIndex:0];
    if (index==0) {
        //微信好友
        if ([WXApi isWXAppInstalled]) {
            __block shareScene scene;
            scene = shareSceneFriends;
            [self sharetoWechatWithTitle:classify.detail_goods_name goodsID:classify.detail_id scene:scene smallPic:posturl];
        }else{
            [OHAlertView showAlertWithTitle:@"提示" message:@"您未安装微信客户端" cancelButton:@"确定" otherButtons:nil buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            }];
            
        }
    }else if (index==1) {
        //微信朋友圈
        if ([WXApi isWXAppInstalled]) {
            __block shareScene scene;
            scene = shareSceneTimeline;
            [self sharetoWechatWithTitle:classify.detail_goods_name goodsID:classify.detail_id scene:scene smallPic:posturl];
        }else{
            [OHAlertView showAlertWithTitle:@"提示" message:@"您未安装微信客户端" cancelButton:@"确定" otherButtons:nil buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            }];
            
        }
    }else if (index==2) {
        //        //新浪shareSceneWeiBo
        //        [SYShopAccessTool sharetoWeiboWithTitle:classify.detail_goods_name goodsID:classify.detail_id smallPic:classify.detail_goods_photos_small];
        //    }else if (index==3) {
        //qq好友
        [self initTence];
        [self sharetoQQWithTitle:classify.detail_goods_name goodsID:classify.detail_id smallPic:posturl];
        
    }else  if (index==3) {
        //qq空间
        [self initTence];
        [self sharetoQQTimelineWithTitle:classify.detail_goods_name goodsID:classify.detail_id smallPic:posturl];
    }
}
-(void)initTence{
    _tencentOAuth=[[TencentOAuth alloc]initWithAppId:__TencentDemoAppid_ andDelegate:self];
    
}
#pragma mark -TencentSessionDelegate
-(void)tencentDidNotNetWork{
    
    
}
-(void)tencentDidLogin{
    
    
}
-(void)tencentDidNotLogin:(BOOL)cancelled{
    
    
    
}


//图片压缩到指定大小
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize  withImage:(UIImage *)image
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark -后来添加的分享
-(void)sharetoWechatWithTitle:(NSString *)title goodsID:(NSString *)goodsID scene:(shareScene)scene smallPic:(NSString *)smallPic{
    
    SendMessageToWXReq *sm = [[SendMessageToWXReq alloc]init];
    
    //发送多媒体信息
    WXMediaMessage *msg = [WXMediaMessage message];
    
    //标题
    msg.title = @"分享";
    
    //描述
    msg.description = @"您正在分享你的海报";
    
    //缩略图
    NSURL *url = [NSURL URLWithString:smallPic];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data) {
        UIImage *i=[[UIImage alloc]initWithData:data];
       
        UIImage *ii=[self imageByScalingAndCroppingForSize:CGSizeMake(100, 130) withImage:i];
        NSData *fData = UIImageJPEGRepresentation(ii, 1);
        msg.thumbData = fData;

    }
    
    //链接
    WXWebpageObject *web = [WXWebpageObject object];
    //    NSString *suffix = @"/wap/goods.htm?id=";
    //    NSString *url1 = [NSString stringWithFormat:@"%@%@%@",FIRST_URL,suffix,goodsID];
    //取出保存在plist文件中的邀请码跟二维码
//    NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
//    NSString *_qrcode_img_path= [d valueForKey:@"qrcode_img_path"];
    
    
    web.webpageUrl = posturl;
    msg.mediaObject = web;
    
    //暂时用不着
    //    msg.mediaTagName = @"我是mediaTagName";
    //    msg.messageExt = @"我是messageExt";
    
    sm.message = msg;
    switch (scene) {
        case shareSceneFriends:{
            sm.scene = WXSceneSession;
            break;
        }
        case shareSceneTimeline:{
            sm.scene = WXSceneTimeline;
            break;
        }
    }
    [WXApi sendReq:sm];
}
-(void)sharetoQQWithTitle:(NSString *)title goodsID:(NSString *)goodsID smallPic:(NSString *)smallPic{
    //取出保存在plist文件中的邀请码跟二维码
//    NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
//    NSString *_qrcode_img_path= [d valueForKey:@"qrcode_img_path"];
    
    
    
    
    NSString *utf8String = posturl;
    NSString *description = @"您正在分享你的海报";
    NSString *previewImageUrl = posturl;
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:utf8String]
                                title:@"分享"
                                description:description
                                previewImageURL:[NSURL URLWithString:previewImageUrl]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    //将内容分享到qzone
    //    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    [self handleSendResult:sent];
    
    
    
}
-(void)sharetoQQTimelineWithTitle:(NSString *)title goodsID:(NSString *)goodsID smallPic:(NSString *)smallPic{
    //取出保存在plist文件中的邀请码跟二维码
//    NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
//    NSString *_qrcode_img_path= [d valueForKey:@"qrcode_img_path"];
    
    
//    NSString *suffix = @"/wap/goods.htm?id=";
    NSString *utf8String = posturl;
    NSString *description = @"您正在分享你的海报";
    NSString *previewImageUrl = posturl;
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:utf8String]
                                title:@"分享"
                                description:description
                                previewImageURL:[NSURL URLWithString:previewImageUrl]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
    //    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    //将内容分享到qzone
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    [self handleSendResult:sent];
    
    
    
}
-(void)handleSendResult:(QQApiSendResultCode)sendResult{
    NSString *message;
    switch (sendResult) {
        case EQQAPIAPPNOTREGISTED:
            message=@"该APP未被注册";
            break;
        case EQQAPIMESSAGETYPEINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGECONTENTINVALID:
            message=@"发送参数错误";
            break;
        case EQQAPIQQNOTINSTALLED:
        case EQQAPIQQNOTSUPPORTAPI:
            message=@"未安装QQ客户端";
            [OHAlertView showAlertWithTitle:@"提示" message:@"你还未安装手机qq客户端" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                
            }];
            break;
        case EQQAPISENDFAILD:
            message=@"发送失败";
            break;
        default:
            message=@"未知错误";
            break;
    }
    NSLog(@"%@",message);
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
