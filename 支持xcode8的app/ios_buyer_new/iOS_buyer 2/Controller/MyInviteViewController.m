//
//  MyInviteViewController.m
//  Demo
//
//  Created by 邱炯辉 on 16/5/25.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "MyInviteViewController.h"
#import "CustomActionSheet.h"
#import "InviteTableViewCell.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
@interface MyInviteViewController ()<CustomActionSheetDelegate,TencentSessionDelegate,UITableViewDelegate,UITableViewDataSource>
{
    TencentOAuth *_tencentOAuth;
    UITableView *_tableview;
    NSArray * _detailArr;

}
@end

@implementation MyInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.title=@"我的推广";
    _detailArr =@[@"将我的邀请码通知好友，好友注册时填写我的邀请码，注册成功即成为我的下级。",
                  @"好友使用微信扫描我的二维码，关注“e网购”公众号并注册个人信息，完成注册即可成为我的下级。",
                  @"分享该页面给好友，好友从该链接注册，注册成功即可成为我的下级。"];
    [self createUI];
}

-(void)createUI{
    
    UIBarButtonItem *barItem =[[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    self.navigationItem.rightBarButtonItem = barItem;
    
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-64) style:UITableViewStylePlain];
    _tableview.delegate= self;
    _tableview.dataSource=self;
    _tableview.estimatedRowHeight = 60;
    _tableview.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview: _tableview];
    
    [_tableview registerNib:[UINib nibWithNibName:@"InviteTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"InviteTableViewCell"];
    
    _tableview.tableHeaderView=[self createHeadView];
    _tableview.tableFooterView=[self createFootView];

    
}
-(UIView *)createFootView{
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 60)];
    
    UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
    [but setTitle:@"分享" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    but.frame=CGRectMake(20, 10,ScreenFrame.size.width -20 *2, 40);
    but.backgroundColor=[UIColor redColor];
    [footView addSubview:but];

    return footView;
}
-(UIView *)createHeadView{
    //取出保存在plist文件中的邀请码跟二维码
    NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
    NSString *_invitation_code= [d valueForKey:@"invitation_code"];
    NSString *_qrcode_img_path= [d valueForKey:@"qrcode_img_path"];

    UIView *headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 257)];
    
    UITextField *label=[[UITextField alloc]initWithFrame:CGRectMake(20, 30, ScreenFrame.size.width-20*2, 40)];
    label.font = [UIFont boldSystemFontOfSize:19];
    label.textAlignment= NSTextAlignmentCenter;
    label.text=[NSString stringWithFormat:@"%@%@",@"我的邀请码:",_invitation_code];
    
    [headview addSubview:label];
    
    
    
    UIImageView *imageview=[[UIImageView alloc]init];
    imageview.frame =CGRectMake(0, 0, 130, 130);
    imageview.center = CGPointMake(ScreenFrame.size.width/2, CGRectGetMaxY(label.frame) + 20+ 100/2);
    [imageview sd_setImageWithURL:[NSURL URLWithString:_qrcode_img_path]];
    [headview addSubview:imageview];
    
    
    
    UILabel *label33=[[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(imageview.frame)+ 10, ScreenFrame.size.width-40*2, 40)];
    label33.textAlignment= NSTextAlignmentLeft;
    
    label33.text=@"推广方式";
    [headview addSubview:label33];
    
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(label33.frame)+1, ScreenFrame.size.width-15, 0.5)];
    line.backgroundColor=LINE_COLOR;
    [headview addSubview:line];
    return headview;
}
#pragma mark - Table view 数据源和代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InviteTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"InviteTableViewCell"];
    cell.method.text=@[@"方式一",@"方式二",@"方式三"][indexPath.row];
    cell.detailLabel.text=_detailArr[indexPath.row];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
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
            [self sharetoWechatWithTitle:classify.detail_goods_name goodsID:classify.detail_id scene:scene smallPic:classify.detail_goods_photos_small];
        }else{
            [OHAlertView showAlertWithTitle:@"提示" message:@"您未安装微信客户端" cancelButton:@"确定" otherButtons:nil buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            }];
            
        }
    }else if (index==1) {
        //微信朋友圈
        if ([WXApi isWXAppInstalled]) {
            __block shareScene scene;
            scene = shareSceneTimeline;
            [self sharetoWechatWithTitle:classify.detail_goods_name goodsID:classify.detail_id scene:scene smallPic:classify.detail_goods_photos_small];
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
        [self sharetoQQWithTitle:classify.detail_goods_name goodsID:classify.detail_id smallPic:classify.detail_goods_photos_small];
        
    }else  if (index==3) {
        //qq空间
        [self initTence];
        [self sharetoQQTimelineWithTitle:classify.detail_goods_name goodsID:classify.detail_id smallPic:classify.detail_goods_photos_small];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -后来添加的分享
-(void)sharetoWechatWithTitle:(NSString *)title goodsID:(NSString *)goodsID scene:(shareScene)scene smallPic:(NSString *)smallPic{
    
    SendMessageToWXReq *sm = [[SendMessageToWXReq alloc]init];
    
    //发送多媒体信息
    WXMediaMessage *msg = [WXMediaMessage message];
    
    //标题
    msg.title = @"分享";
    
    //描述
    msg.description = @"快来扫码成为e网购会员噢！";
    
    //缩略图
    NSURL *url = [NSURL URLWithString:smallPic];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data) {
        msg.thumbData = data;
    }
    
    //链接
    WXWebpageObject *web = [WXWebpageObject object];
//    NSString *suffix = @"/wap/goods.htm?id=";
//    NSString *url1 = [NSString stringWithFormat:@"%@%@%@",FIRST_URL,suffix,goodsID];
    //取出保存在plist文件中的邀请码跟二维码
    NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
    NSString *_qrcode_img_path= [d valueForKey:@"qrcode_img_path"];
    

    web.webpageUrl = _qrcode_img_path;
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
    NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
    NSString *_qrcode_img_path= [d valueForKey:@"qrcode_img_path"];
    
    
    
    
    NSString *utf8String = _qrcode_img_path;
    NSString *description = @"快来扫码成为e网购会员噢！";
    NSString *previewImageUrl = _qrcode_img_path;
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
    NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
    NSString *_qrcode_img_path= [d valueForKey:@"qrcode_img_path"];
    
    
    NSString *suffix = @"/wap/goods.htm?id=";
    NSString *utf8String = _qrcode_img_path;
    NSString *description = @"快来扫码成为e网购会员噢！";
    NSString *previewImageUrl = _qrcode_img_path;
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
