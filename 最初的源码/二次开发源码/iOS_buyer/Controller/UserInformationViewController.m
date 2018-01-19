//
//  UserInformationViewController.m
//  My_App
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UserInformationViewController.h"
#import "userInfromationCell.h"
#import "BundlingViewController.h"
#import "BindingViewController.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface UserInformationViewController ()<UIGestureRecognizerDelegate>
{
    ASIFormDataRequest *RequestReceiveCoupons;
    ASIFormDataRequest *RequestSave;
}
@end

static UserInformationViewController *singleInstance=nil;

@implementation UserInformationViewController

- (IBAction)btnAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if(btn.tag == 101){
        DataPickerViewBool = YES;
        pickerView.hidden = YES;
        UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册中选取", nil];
        [choiceSheet showInView:self.view];
    }
    
    if(btn.tag == 103){
        DataPickerViewBool = YES;
        pickerView.hidden = YES;
        UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil  delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男", @"女", @"保密", nil];
        choiceSheet.tag = 101;
        [choiceSheet showInView:self.view];
    }
    if(btn.tag == 104){
        DataPickerViewBool = NO;
        pickerView.hidden = NO;
    }
    if(btn.tag == 105){
        DataPickerViewBool = YES;
        pickerView.hidden = YES;
        BundlingViewController *bundling = [[BundlingViewController alloc]init];
        [self.navigationController pushViewController:bundling animated:YES];
    }
}

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

+ (id)allocWithZone:(NSZone *)zone;
{
    if(singleInstance==nil)
    {
        singleInstance=[super allocWithZone:zone];
    }
    return singleInstance;
}

-(id)copyWithZone:(NSZone *)zone
{
    
    return singleInstance;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    pickerView.hidden = YES;
     [self netWorking];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"用户信息";
    [self createBackBtn];
    
    myPicker.datePickerMode = UIDatePickerModeTime;
    [myPicker setDatePickerMode:UIDatePickerModeDate];
    myPicker.maximumDate=[NSDate date];
    pickerView.hidden = YES;
    [myPicker addTarget:self action:@selector(datePickerDateChanged:) forControlEvents:UIControlEventValueChanged];

    [self netWorking];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}
#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1){  //关闭主界面的右滑返回
        return NO;
    }else{
        
        return YES;
    }
}
//重写返回按钮
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 网络
-(void)netWorking{
    [SYObject startLoading];
    NSArray *keyArr = [[NSArray alloc]initWithObjects:@"userId", nil];
    NSArray *valueArr = [[NSArray alloc]initWithObjects:[USER_INFORMATION objectAtIndex:3], nil];
    RequestReceiveCoupons = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,GETUSERMSG_URL] setKey:keyArr setValue:valueArr];
    
    RequestReceiveCoupons.delegate = self;
    [RequestReceiveCoupons setDidFailSelector:@selector(RequestFailed:)];
    [RequestReceiveCoupons setDidFinishSelector:@selector(GetuserMsgSucceeded:)];
    [RequestReceiveCoupons startAsynchronous];
}
-(void)GetuserMsgSucceeded:(ASIFormDataRequest *)request{
    if ([request  responseStatusCode] == 200){
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if (dicBig) {
            NSLog(@"dddd:%@",dicBig);
            NSDictionary *resultDic = [dicBig objectForKey:@"result"];
            if ([[resultDic objectForKey:@"birthday"] length] == 0) {
                _BrithLabel.text = @"请选择出生日期";
            }else{
                _BrithLabel.text = [resultDic objectForKey:@"birthday"];
            }
            if ([[resultDic objectForKey:@"gender"] intValue] == 1) {
                _sexLabel.text = @"男";
            }else if ([[resultDic objectForKey:@"gender"] intValue] == -1){
                _sexLabel.text = @"保密";
            }else{
                _sexLabel.text = @"女";
            }
            if ([[resultDic objectForKey:@"mobile"] length] == 0) {
                _mobileLabel.text = @"未绑定";
            }else{
                _mobileLabel.text = [resultDic objectForKey:@"mobile"];
            }
            photoStr  = [resultDic objectForKey:@"photo"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
                UIImage *protraitImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[resultDic objectForKey:@"photo"]]]];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if (protraitImg) {
                        photoImage.image = protraitImg;
 
                    }else
                    {
                        photoImage.image=[UIImage imageNamed:@"kong_lj"];
                    
                    }
                   
                });
            });
        }
    }else{
        [SYObject failedPrompt:@"请求出错，请重试"];
    }
    [SYObject endLoading];
}
-(void)SaveuserMsgSucceeded:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    if ([request  responseStatusCode] == 200){
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if (dicBig) {
            NSLog(@"cccc:%@",dicBig);
            if([[dicBig objectForKey:@"code"] intValue] == 200){
                [SYObject failedPrompt:@"修改成功"];
            }else{
                [SYObject failedPrompt:@"修改失败，请重试"];
            }
        }
    }else{
        [SYObject failedPrompt:@"请求出错，请重试"];
    }
}

-(void)RequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
#pragma mark - textfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)keyBoardDisappear{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
}
#pragma mark - 返回按钮
-(void) datePickerDateChanged:(UIDatePicker *)paramDatePicker{
    if ([paramDatePicker isEqual:myPicker]){
        NSLog(@"Selected date = %@", paramDatePicker.date);
        DataPickerViewBool = YES;
        
//        NSString *sss = [NSString stringWithFormat:@"%@",paramDatePicker.date];
//        NSArray *arr = [sss componentsSeparatedByString:@" "];
//        _BrithLabel.text = [arr objectAtIndex:0];
    }
}

#pragma mark - 点击事件
-(void)modifyMsg:(NSArray*)keyArr valueArray:(NSArray  *)valueArr {
    //LoadingView.hidden = NO;
    [SYObject startLoading];
    
    RequestSave = [consultViewNetwork startRequest_url:[NSString stringWithFormat:@"%@%@",FIRST_URL,SAVEUSER_URL] setKey:keyArr setValue:valueArr];
    RequestSave.delegate = self;
    [RequestSave setDidFailSelector:@selector(RequestFailed:)];
    [RequestSave setDidFinishSelector:@selector(SaveuserMsgSucceeded:)];
    [RequestSave startAsynchronous];
}
- (IBAction)pickerOKBtnClicked:(id)sender {
    if (DataPickerViewBool == YES) {
//        _BrithLabel.text = [[[NSString stringWithFormat:@"%@",myPicker.date] componentsSeparatedByString:@" "] objectAtIndex:0];
        NSString *str=[[[NSString stringWithFormat:@"%@",myPicker.date] componentsSeparatedByString:@" "] objectAtIndex:0];
         NSArray*array=[str componentsSeparatedByString:@"-"];
        NSString *string=[NSString stringWithFormat:@"%ld",(long)[array[2] integerValue]+1];
        NSMutableArray *marray=[[NSMutableArray alloc]initWithObjects:array[0],array[1],string, nil];
        _BrithLabel.text = [marray componentsJoinedByString:@"-"];
        
    }
    pickerView.hidden = YES;
    
    //发起修改生日的请求
    NSArray *keyArr = [[NSArray alloc]initWithObjects:@"userId",@"birthday", nil];
    NSArray *valueArr = [[NSArray alloc]initWithObjects:[USER_INFORMATION objectAtIndex:3],_BrithLabel.text, nil];
    [self modifyMsg:keyArr valueArray:valueArr];
}

- (IBAction)pickerCancelBtnClicked:(id)sender {
    pickerView.hidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)editPortrait {
    
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.portraitImageView.image = editedImage;
    NSData *imageData = UIImageJPEGRepresentation(self.portraitImageView.image,0.5);
    base64Data = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        NSArray *keyArr = [[NSArray alloc]initWithObjects:@"userId",@"image",@"ext",@"oldimage", nil];
        NSArray *valueArr = [[NSArray alloc]initWithObjects:[USER_INFORMATION objectAtIndex:3],base64Data,@"jpg",photoStr, nil];
        [self modifyMsg:keyArr valueArray:valueArr];
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 101) {
        NSArray *keyArr = [[NSArray alloc]initWithObjects:@"userId",@"gender",nil];
        NSArray *valueArr;
        if (buttonIndex == 0){
            _sexLabel.text = @"男";
            valueArr = [[NSArray alloc]initWithObjects:[USER_INFORMATION objectAtIndex:3],@"1", nil];
            [self modifyMsg:keyArr valueArray:valueArr];
        }else if(buttonIndex == 1){
            _sexLabel.text = @"女";
            valueArr = [[NSArray alloc]initWithObjects:[USER_INFORMATION objectAtIndex:3],@"0", nil];
            [self modifyMsg:keyArr valueArray:valueArr];
        }else if(buttonIndex == 2){
            _sexLabel.text = @"保密";
            valueArr = [[NSArray alloc]initWithObjects:[USER_INFORMATION objectAtIndex:3],@"-1", nil];
            [self modifyMsg:keyArr valueArray:valueArr];
        }else{
            
        }
        
    }else{
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
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [self presentViewController:controller animated:YES completion:^(void){
                    NSLog(@"Picker View Controller is presented");
                }];
            }
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
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

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
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
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark portraitImageView getter
- (UIImageView *)portraitImageView {
    if (!photoImage) {
        CGFloat w = 100.0f; CGFloat h = w;
        CGFloat x = (self.view.frame.size.width - w) / 2;
        CGFloat y = (self.view.frame.size.height - h) / 2;
        photoImage.frame = CGRectMake(x, y, w, h);
        [photoImage.layer setCornerRadius:(photoImage.frame.size.height/2)];
        [photoImage.layer setMasksToBounds:YES];
        [photoImage setContentMode:UIViewContentModeScaleAspectFill];
        [photoImage setClipsToBounds:YES];
        photoImage.layer.shadowColor = [UIColor blackColor].CGColor;
        photoImage.layer.shadowOffset = CGSizeMake(4, 4);
        photoImage.layer.shadowOpacity = 0.5;
        photoImage.layer.shadowRadius = 2.0;
        photoImage.layer.borderColor = [[UIColor blackColor] CGColor];
        photoImage.layer.borderWidth = 2.0f;
        photoImage.userInteractionEnabled = YES;
        photoImage.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [photoImage addGestureRecognizer:portraitTap];
    }
    return photoImage;
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
