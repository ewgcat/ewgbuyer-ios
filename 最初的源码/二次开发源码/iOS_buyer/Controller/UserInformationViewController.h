//
//  UserInformationViewController.h
//  My_App
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface UserInformationViewController : UIViewController<UIActionSheetDelegate,VPImageCropperDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>{
    
    __weak IBOutlet UIImageView *photoImage;
    __weak IBOutlet UIDatePicker *myPicker;
    __weak IBOutlet UIView *pickerView;
    
    __weak IBOutlet UIButton *pickerOkBtn;
    __weak IBOutlet UIButton *pickerCancelBtn;
    NSString *base64Data;
    BOOL DataPickerViewBool;
    NSString *photoStr;
}

@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *BrithLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;




- (IBAction)btnAction:(id)sender;
+(id)sharedUserDefault;
- (IBAction)pickerOKBtnClicked:(id)sender;
- (IBAction)pickerCancelBtnClicked:(id)sender;
@end
