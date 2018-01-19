//
//  AddEvaluatetTableViewController.m
//  My_App
//
//  Created by shiyuwudi on 16/2/3.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

#import "AddEvaluatetTableViewController.h"
#import "ModifyEvaTableViewController.h"
#import "EvaAddModel.h"
#import "ModifyEvaCell1.h"
#import "ModifyEvaCell2.h"
#import "ModifyEvaCell3.h"
#import "ModifyEvaCell4.h"
#import "ModifyEvaCell5.h"
#import "DoImagePickerController.h"

@interface AddEvaluatetTableViewController ()

@end

@implementation AddEvaluatetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model.evaluate_info = @"";
    self.model.evaluate_photos = [NSArray array];
    self.model.evaluate_photos_id = @"";
    self.title = @"追加评价";
    [self createBackBtn];
    self.view.backgroundColor = UIColorFromRGB(0xf1f1f1);
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden=NO;

}
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = right;
}
-(void)submit{
    
    if (self.model.evaluate_info.length>0) {
        
    if (self.model.evaluate_photos_id.length>0) {
        self.model.evaluate_photos_id  = [self.model.evaluate_photos_id substringFromIndex:1];
    }
   
    NSString *urlStr= [NSString stringWithFormat:@"%@%@",FIRST_URL,EVA_APPEND_URL];
    NSString *key1 = [NSString stringWithFormat:@"evaluate_info_%ld",(long)self.model.goods_id];
    NSString *key2 = [NSString stringWithFormat:@"evaluate_photos_%ld",(long)self.model.goods_id];
    NSDictionary *par = @{
                          @"user_id":[SYObject currentUserID],
                          @"token":[SYObject currentToken],
                          @"evaluate_id":self.evaID,
                          @"goods_id":[NSString stringWithFormat:@"%ld",(long)self.model.goods_id],
                          key1:self.model.evaluate_info,
                          key2:self.model.evaluate_photos_id,
                          };
    [SYObject startLoading];
    NSLog(@"追加评价参数字典%@",par);
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"result"] isEqualToString:@"SUCCESS"]) {
            [SYObject failedPrompt:@"追加成功" complete:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else {
            [SYObject failedPrompt:@"提交失败"];
        }
        [SYObject endLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        [SYObject endLoading];
        [SYObject failedPrompt:@"请求失败"];
    }];
    }else
    {
    [OHAlertView showAlertWithTitle:@"提示" message:@"抱歉,评语不能为空" cancelButton:@"确定" otherButtons:nil buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
        
    }];
    
    }
}
-(void)removeSubviews:(UITableViewCell *)cell{
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
}
-(void)textFieldDidChange:(NSNotification *)notif{
    self.model.evaluate_info = ((UITextField *)notif.object).text;
}

-(void)dismissKeyBoard{
    [self.view endEditing:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ModifyEvaCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:self.model.goods_main_photo] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
        cell.goodsName.text = self.model.goods_name;
        return cell;
    }else if (indexPath.row == 1){
        ModifyEvaCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
        cell.textField.text = self.model.evaluate_info;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:cell.textField];
        
        WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"" leftTarget:self leftAction:@selector(dismissKeyBoard) rightTitle:@"完成" rightTarget:self rightAction:@selector(dismissKeyBoard)];
        [cell.textField setInputAccessoryView:inputView];
        
//        UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 44)];
//        [topView setBarStyle:UIBarStyleBlack];
//        UIBarButtonItem * space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
//        NSArray * buttonsArray = [NSArray arrayWithObjects:space,doneButton,nil];
//        [topView setItems:buttonsArray];
//        [cell.textField setInputAccessoryView:topView];
        return cell;
    }else if (indexPath.row == 2){
        
        CGFloat h4 = (ScreenFrame.size.width - 7.0 * 8.0) * 0.25;//图片宽高
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell5"];
        [self removeSubviews:cell];
        cell.backgroundColor = UIColorFromRGB(0xf1f1f1);
        
        UIView *holder = [[UIView alloc]initWithFrame:CGRectMake(8, 8, cell.width - 16, h4 + 68)];
        holder.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:holder];
        
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.frame = CGRectMake(8, 16 + h4, ScreenFrame.size.width - 32, 44);
        [holder addSubview:confirmBtn];
        confirmBtn.backgroundColor = UIColorFromRGB(0xf15353);
        [confirmBtn setTitle:@"追加晒单图片" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(addPhoto:) forControlEvents:UIControlEventTouchUpInside];
        confirmBtn.layer.cornerRadius = 5.0;
        confirmBtn.layer.masksToBounds = YES;
        
        if(self.model.evaluate_photos && self.model.evaluate_photos.count >0){
            for (int i = 0;i < self.model.evaluate_photos.count; i++){
                //放图片
                UIImageView *iv = [[UIImageView alloc]init];
                
                [iv sd_setImageWithURL:[NSURL URLWithString:self.model.evaluate_photos[i]] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
                iv.frame = CGRectMake(8 + (8 + h4) * i, 8, h4, h4);
                CGRect imageFrame = iv.frame;
                [holder addSubview:iv];
                //删除按钮
                CGFloat delW = 25;
                CGFloat delH = 15;
                UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [delBtn setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
                
                delBtn.frame = CGRectMake(CGRectGetMaxX(imageFrame) - 0.5 * delW, CGRectGetMinY(imageFrame) - 0.5 * delH, delW, delH);
                
                [delBtn addTarget:self action:@selector(delImageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [holder addSubview:delBtn];
                delBtn.tag = 30 + i;
            }
        }
        return cell;
    }
    return [UITableViewCell new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 104;
    }else if (indexPath.row == 1){
        return 52;
    }else if (indexPath.row == 2){
        return 76+(ScreenFrame.size.width - 7.0 * 8.0) * 0.25;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
#pragma mark - 图片选择器
- (void)didCancelDoImagePickerController{
    [self dismissViewControllerAnimated:YES completion:^{
        [SYObject failedPrompt:@"已取消"];
    }];
}
- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected{
    [self dismissViewControllerAnimated:YES completion:^{
        if (aSelected || aSelected.count >=1) {
            [SYObject startLoading];
            __block int count = 0;
            for (UIImage *img in aSelected){
                NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,TSPicture_URL];
                NSData *imageData = UIImageJPEGRepresentation(img, 1);
                NSString *encodedStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                NSDictionary *par = @{
                                      @"user_id":[SYObject currentUserID],
                                      @"token":[SYObject currentToken],
                                      @"image":encodedStr
                                      };
                [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *dic = responseObject;
                    NSNumber *imageID = dic[@"data"][@"acc_id"];
                    NSString *url = dic[@"data"][@"acc_url"];
                    if (imageID) {
                        count += 1;
                        //加到url数组,id数组
                        NSMutableArray *arr = [self.model.evaluate_photos mutableCopy];
                        [arr addObject:url];
                        self.model.evaluate_photos = arr;
                        NSMutableArray *ids = [[self.model.evaluate_photos_id componentsSeparatedByString:@","]mutableCopy];
                        [ids addObject:imageID.stringValue];
                        NSString *str = [ids componentsJoinedByString:@","];
                        self.model.evaluate_photos_id = str;
                        [self.tableView reloadData];
                    }
                    if (count == aSelected.count) {
                        [SYObject endLoading];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"%@",[error localizedDescription]);
                }];
            }
        }
    }];
}
-(IBAction)addPhoto:(UIButton *)btn{
    if (self.model.evaluate_photos.count<4) {
        DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
        cont.delegate = self;
        cont.nMaxCount = 4 - self.model.evaluate_photos.count;     // larger than 1
        cont.nColumnCount = 3;  // 2, 3, or 4
        cont.tag = btn.tag;
        cont.nResultType = DO_PICKER_RESULT_UIIMAGE; // get UIImage object array : common case
        // if you want to get lots photos, you had better use DO_PICKER_RESULT_ASSET.
        
        [self presentViewController:cont animated:YES completion:nil];
        
    }else
    {
        [OHAlertView showAlertWithTitle:@"提示" message:@"抱歉,最多可添加4张图片" cancelButton:@"确定" otherButtons:nil buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            
        }];
       
    }
   
}
-(IBAction)delImageBtnClicked:(UIButton *)btn{
    NSInteger idx = btn.tag - 30;
    NSMutableArray *arr = [self.model.evaluate_photos mutableCopy];
    [arr removeObjectAtIndex:idx];
    self.model.evaluate_photos = arr;
    
    NSMutableArray *ids = [[self.model.evaluate_photos_id componentsSeparatedByString:@","]mutableCopy];
    [ids removeObjectAtIndex:idx];
    if (ids.count == 0) {
        self.model.evaluate_photos_id = @"";
    }else {
        NSString *str = [ids componentsJoinedByString:@","];
        self.model.evaluate_photos_id = str;
    }
    [self.tableView reloadData];
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
