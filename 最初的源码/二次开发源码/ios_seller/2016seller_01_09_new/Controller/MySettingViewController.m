//
//  MySettingViewController.m
//  SellerApp
//
//  Created by barney on 15/12/31.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MySettingViewController.h"
#import "setCell.h"
#import "CommonLogisticsViewController.h"
#import "ShippingInfoViewController.h"
#import "_015b2b2cseller-Swift.h"

@interface MySettingViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,CropViewControllerDelegate,EditInfoViewControllerDelegate,UIActionSheetDelegate>
{
    NSMutableArray *dataArray;
    UITableView *settingTabView;
    NSDictionary *dataDict;
}

@end

@implementation MySettingViewController

#pragma mark - 视图生命周期方法
-(void)viewWillAppear:(BOOL)animated{
    [self netRequest];
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray=[[NSMutableArray alloc]init];
    dataDict = [NSDictionary dictionary];
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x2196f3);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.title = @"设置";
    
    if (UIDeviceSystem>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    
    settingTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 74, ScreenFrame.size.width, ScreenFrame.size.height-64-49)];
    settingTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    settingTabView.delegate = self;
    settingTabView.dataSource=  self;
    settingTabView.showsVerticalScrollIndicator=NO;
    settingTabView.showsHorizontalScrollIndicator = NO;
    settingTabView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:settingTabView];

    settingTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
}
#pragma mark - 网络请求,刷新页面
-(void)headerRereshing{
    [self netRequest];
    [settingTabView.mj_header endRefreshing];
}
-(void)netRequest{
    [MyObject startLoading];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,SHOW_SELLER_INFO_URL];
    if ([MyNetTool currentUserID]&&[MyNetTool currentToken]) {
        NSDictionary *par = @{
                              @"user_id":[MyNetTool currentUserID],
                              @"token":[MyNetTool currentToken],
                              };
        [[MyNetTool managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            dataDict = (NSDictionary *)responseObject;
            [settingTabView reloadData];
            [MyObject endLoading];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MyObject failedPrompt:[error localizedDescription]];
            [MyObject endLoading];
        }];
    }
}
#pragma mark - 退出登录
-(void)logout{
    [LJControl cleanAll];
    AppDelegate *app = [AppDelegate sharedUserDefault];
    app.log_View.hidden = NO;
    [self.view.window bringSubviewToFront:app.log_View];
}
#pragma mark - UITableView数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==3) return 16;
    if (indexPath.row==6) return 100;
    return 60.f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==3) {
        static NSString *myTabelviewCell = @"Cell";
        UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:myTabelviewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromRGB(0xf5f5f5);
        UIView *line2=[LJControl viewFrame:CGRectMake(0, 16, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe3e3e3)];
        [cell addSubview:line2];

        return cell;
        
    }
    
    if (indexPath.row == 6)
    {
        UITableViewCell *cell =[[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromRGB(0xf2f2f2);
        UIButton *logoutBtn = [UIButton new];
        [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        logoutBtn.backgroundColor = NAV_COLOR;
        CGFloat space1 = 20;
        CGFloat space2 = 28;
        CGFloat w = ScreenFrame.size.width - space1 * 2;
        CGFloat h = 100 - space2 * 2;
        logoutBtn.frame = CGRectMake(space1, space2, w, h);
        [cell.contentView addSubview:logoutBtn];
        [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        logoutBtn.layer.cornerRadius = 5.0;
        [logoutBtn.layer setMasksToBounds:YES];
        return cell;
    }
    
    setCell *cell =[[[NSBundle mainBundle] loadNibNamed:@"setCell" owner:self options:nil] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.row==0) {
        //店铺logo
        cell.content.hidden=YES;
        cell.InBtn.hidden=YES;
        NSString *urlstr = dataDict[@"store_logo"];
        if (urlstr) {
            [cell.logo sd_setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"loading"]];
        }
       
        
    }else if (indexPath.row==1){
        //店铺名称
        cell.logo.hidden=YES;
        cell.InBtn.hidden=YES;
        NSString *title = dataDict[@"store_name"];
        if (title) {
            cell.content.text = title;
        }
       

    }else if (indexPath.row==2){
        //联系方式
        cell.logo.hidden=YES;
        cell.InBtn.hidden=YES;
        NSString *contact = dataDict[@"store_telephone"];
        if (contact) {
            cell.content.text = contact;
        }
    }else if (indexPath.row==4||indexPath.row==5)
    {
        cell.logo.hidden=YES;
        cell.content.hidden=YES;
    }
   
    NSArray *titleAry=@[@"店铺logo",@"店铺名称",@"联系方式",@"",@"常用物流",@"发货地址"];

    cell.title.text=titleAry[indexPath.row];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%lu行被点击",(long)indexPath.row);
    setCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 4) {
        //常用物流 CommonLogistics
        CommonLogisticsViewController *clVC = [[UIStoryboard storyboardWithName:@"WorkBench" bundle:nil]instantiateViewControllerWithIdentifier:@"CommonLogistics"];
        [self.navigationController pushViewController:clVC animated:YES];
    }else if (indexPath.row == 5){
        //发货地址 shippinginfo
        ShippingInfoViewController *siVC = [[UIStoryboard storyboardWithName:@"WorkBench" bundle:nil]instantiateViewControllerWithIdentifier:@"shippinginfo"];
        [self.navigationController pushViewController:siVC animated:YES];
    }else if (indexPath.row == 0){
        //店铺logo
        UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册中选取", nil];
        [choiceSheet showInView:self.view];
    }else if (indexPath.row == 1){
        //修改店铺名称
        EditInfoViewController *edit = [EditInfoViewController editInfoViewController];
        edit.storeTitle = @"店铺名称";
        edit.oldValue = cell.content.text;
        edit.delegate = self;
        [self.navigationController pushViewController:edit animated:YES];
    }else if (indexPath.row == 2){
        //修改联系方式
        EditInfoViewController *edit = [EditInfoViewController editInfoViewController];
        edit.storeTitle = @"联系方式";
        edit.oldValue = cell.content.text;
        edit.delegate = self;
        [self.navigationController pushViewController:edit animated:YES];
    }
}
#pragma mark - 摄像头功能
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}
#pragma mark - ActionSheet代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller animated:YES completion:^(void){
                NSLog(@"Picker View Controller is presented");
            }];
        }
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *imagePick = [[UIImagePickerController alloc]init];
            imagePick.delegate = self;
            imagePick.allowsEditing = NO;
            [self presentViewController:imagePick animated:YES completion:nil];
        }
    }
    
}
#pragma mark - 图片选择控制器代理
-(void)shouldShowNewLogo:(CropViewController *)cropViewCOntroller{
    [self netRequest];
}
-(void)shouldShowNewStoreInfo:(EditInfoViewController *)editInfoVC message:(NSString *)message{
    [self netRequest];
    [MyObject failedPrompt:message];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
    [MyObject endLoading];
    [MyObject failedPrompt:@"用户取消操作!"];
}
-(UIImage *)cropImage:(UIImage *)image inRect:(CGRect)rect{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef cr = UIGraphicsGetCurrentContext();
    CGContextAddRect(cr, rect);
    
    CGContextClip(cr);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    CGContextStrokePath(cr);
    UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image1;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [MyObject endLoading];
    //取得截取后的图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //先保存在沙盒
    [self saveImage:image withName:@"name.png"];
    
    CropViewController *crop = [CropViewController cropViewController];
    crop.image = image;
    crop.delegate = self;
    [self presentViewController:crop animated:YES completion:nil];
}
- (void)saveImage:(UIImage *)currentImage withName:(NSString *)name
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Document"];
    [imageData writeToFile:path atomically:NO];
}

@end
