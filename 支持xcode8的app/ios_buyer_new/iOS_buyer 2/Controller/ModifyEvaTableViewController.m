//
//  ModifyEvaTableViewController.m
//  My_App
//
//  Created by apple2 on 16/2/2.
//  Copyright © 2016年 apple2. All rights reserved.
//

#import "ModifyEvaTableViewController.h"
#import "EvaAddModel.h"
#import "ModifyEvaCell1.h"
#import "ModifyEvaCell2.h"
#import "ModifyEvaCell3.h"
#import "ModifyEvaCell4.h"
#import "ModifyEvaCell5.h"
#import "DoImagePickerController.h"

@interface ModifyEvaTableViewController ()

@end

@implementation ModifyEvaTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self net];
    [self createBackBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = right;
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)submit{
    NSString *urlStr= [NSString stringWithFormat:@"%@%@",FIRST_URL,EVA_MODIFY_URL];
    NSString *key1 = [NSString stringWithFormat:@"evaluate_info_%ld",(long)self.model.goods_id];
    NSString *key2 = [NSString stringWithFormat:@"evaluate_photos_%ld",(long)self.model.goods_id];
    NSString *key3 = [NSString stringWithFormat:@"evaluate_buyer_val%ld",(long)self.model.goods_id];
    NSString *key4 = [NSString stringWithFormat:@"description_evaluate%ld",(long)self.model.goods_id];
    NSString *key5 = [NSString stringWithFormat:@"service_evaluate%ld",(long)self.model.goods_id];
    NSString *key6 = [NSString stringWithFormat:@"ship_evaluate%ld",(long)self.model.goods_id];
    NSDictionary *par = @{
                          @"user_id":[SYObject currentUserID],
                          @"token":[SYObject currentToken],
                          @"evaluate_id":[NSString stringWithFormat:@"%ld",(long)self.finalModel.evaluate_id],
                          @"goods_id":[NSString stringWithFormat:@"%ld",(long)self.model.goods_id],
                          key1:self.model.evaluate_info,
                          key2:self.finalModel.evaluate_photos_id,
                          key3:@"1",
                          key4:[NSString stringWithFormat:@"%.1f",self.finalModel.description_evaluate],
                          key5:[NSString stringWithFormat:@"%.1f",self.finalModel.service_evaluate],
                          key6:[NSString stringWithFormat:@"%.1f",self.finalModel.ship_evaluate]
                          };
    [SYObject startLoading];
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"result"] isEqualToString:@"SUCCESS"]) {
            [SYObject failedPrompt:@"修改成功" complete:^{
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
}
#pragma mark - UI
-(void)setupUI{
    self.title = @"评价修改";
}
#pragma mark - net request 
-(void)net{
    
    [SYObject startLoading];
    NSString *url = [NSString stringWithFormat:@"%@%@",FIRST_URL,EVA_DETAIL_URL];
    NSDictionary *par = @{
                          @"user_id":[SYObject currentUserID],
                          @"token":[SYObject currentToken],
                          @"evaluate_id":self.evaID
                          };
    [[Requester managerWithHeader]POST:url parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"评价详情:%@",responseObject);
        NSDictionary *dict = responseObject;
        if ([dict[@"result"]isEqualToString:@"SUCCESS"]) {
            NSDictionary *data = dict[@"data"];
            self.finalModel = [EvaAddModel yy_modelWithDictionary:data];
            [self.tableView reloadData];
        }
        [SYObject endLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        [SYObject endLoading];
    }];
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 104;
    }else if (indexPath.row == 1){
        return 52;
    }else if (indexPath.row == 2){
        return 146;
    }else if (indexPath.row == 3){
        return 52;
    }else if (indexPath.row == 4){
        return (ScreenFrame.size.width - 7.0 * 8.0) * 0.25 + 70;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
-(void)removeSubviews:(UITableViewCell *)cell{
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
}

-(void)textFieldDidChange:(NSNotification *)notif{
    self.model.evaluate_info = ((UITextView *)notif.object).text;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0){
        ModifyEvaCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:self.model.goods_main_photo] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
        cell.goodsName.text = self.model.goods_name;
        return cell;
    }
    else if (indexPath.row == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        return cell;
    }
    else if (indexPath.row == 2){
        ModifyEvaCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        //星星
        NSArray *labelArr = @[cell.label1,cell.label2,cell.label3];
        float totalArr [] = {
            self.finalModel.service_evaluate,
            self.finalModel.description_evaluate,
            self.finalModel.ship_evaluate
        };
        for (int i=0; i<3; i++) {
            UILabel *lbl = labelArr[i];
            CGFloat starH = lbl.height;
            CGFloat starX = ScreenFrame.size.width - 16 - 8 - 5 * starH;
            CGFloat starY = lbl.top;
            CGFloat starW = 5 * starH;
            UIView *holder = [[UIView alloc]initWithFrame:CGRectMake(starX, starY, starW, starH)];
            [cell.starHolder addSubview:holder];
            float total = totalArr[i];
            if (total >5) {
                total = 5;
            }
            NSInteger full = floor(total);
            float half = total - (float)full;
            NSInteger j;
            for (j=0; j<full; j++) {
                UIButton *iv1 = [UIButton buttonWithType:UIButtonTypeCustom];
                [iv1 setImage:[UIImage imageNamed: @"star1"] forState:UIControlStateNormal];
                iv1.frame = CGRectMake(starH * j, 0, starH, starH);
                [iv1 addTarget:self action:@selector(btnStarClicked:) forControlEvents:UIControlEventTouchDown];
                iv1.tag = i *10 + j;
                [holder addSubview:iv1];
                [self.starBtnArray addObject:iv1];
            }
            NSInteger bal = 0;
            if (half != 0.0) {
                UIImage *halfS = [UIImage imageNamed:@"star0.5"];
                UIButton *iv2 = [[UIButton alloc]init];
                iv2.selected =  YES;
                [iv2 setImage:halfS forState:UIControlStateNormal];
                iv2.frame = CGRectMake(starH * j, 0, starH, starH);
                iv2.tag = i *10 + j;
                [iv2 addTarget:self action:@selector(btnStarClicked:) forControlEvents:UIControlEventTouchDown];
                [holder addSubview:iv2];
                [self.starBtnArray addObject:iv2];
                bal = 5 - full - 1;
            }else {
                bal = 5 - full;
            }
            for (NSInteger k=5 - bal; k<5; k++) {
                UIButton *iv3 = [[UIButton alloc]init];
                [iv3 setImage:[UIImage imageNamed:@"star0"] forState:UIControlStateNormal];
                iv3.tag = i * 10 + k;
                [iv3 addTarget:self action:@selector(btnStarClicked:) forControlEvents:UIControlEventTouchDown];
                iv3.frame = CGRectMake(starH * k, 0, starH, starH);
                [holder addSubview:iv3];
                [self.starBtnArray addObject:iv3];
            }
        }

        return cell;
    }
    else if (indexPath.row == 3){
        ModifyEvaCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
        cell.textView.text = self.model.evaluate_info;
        cell.textView.delegate=self;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChange:) name:UITextViewTextDidChangeNotification object:cell.textView];
    
        
        WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"取消" leftTarget:self leftAction:@selector(dismissKeyBoard) rightTitle:@"完成" rightTarget:self rightAction:@selector(dismissKeyBoard)];
        [cell.textView setInputAccessoryView:inputView];
        
        
        return cell;
    }
    else if (indexPath.row == 4){
        CGFloat h4 = (ScreenFrame.size.width - 7.0 * 8.0) * 0.25;//图片宽高
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell5"];
        [self removeSubviews:cell];
        cell.backgroundColor = UIColorFromRGB(0xf1f1f1);
        UIView *holder = [[UIView alloc]initWithFrame:CGRectMake(8, 8, cell.width - 16, h4 + 66)];
        holder.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:holder];
        
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.frame = CGRectMake(8, 16 + h4, ScreenFrame.size.width - 32, 44);
        [holder addSubview:confirmBtn];
        confirmBtn.backgroundColor = UIColorFromRGB(0xf15353);
        [confirmBtn setTitle:@"添加晒单图片" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(addPhoto:) forControlEvents:UIControlEventTouchUpInside];
        confirmBtn.layer.cornerRadius = 5.0;
        confirmBtn.layer.masksToBounds = YES;
        
        if(self.finalModel.evaluate_photos && self.finalModel.evaluate_photos.count >0){
            for (int i = 0;i < self.finalModel.evaluate_photos.count; i++){
                //放图片
                UIImageView *iv = [[UIImageView alloc]init];
                
                [iv sd_setImageWithURL:[NSURL URLWithString:self.finalModel.evaluate_photos[i]] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
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
    else {
        return [UITableViewCell new];
    }
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
                        NSMutableArray *arr = [self.finalModel.evaluate_photos mutableCopy];
                        [arr addObject:url];
                        self.finalModel.evaluate_photos = arr;
                        NSMutableArray *ids = [[self.finalModel.evaluate_photos_id componentsSeparatedByString:@","]mutableCopy];
                        [ids addObject:imageID.stringValue];
                        NSString *str = [ids componentsJoinedByString:@","];
                        self.finalModel.evaluate_photos_id = str;
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
    DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
    cont.delegate = self;
    cont.nMaxCount = 4 - self.finalModel.evaluate_photos.count;     // larger than 1
    cont.nColumnCount = 3;  // 2, 3, or 4
    cont.tag = btn.tag;
    cont.nResultType = DO_PICKER_RESULT_UIIMAGE; // get UIImage object array : common case
    // if you want to get lots photos, you had better use DO_PICKER_RESULT_ASSET.
    
    [self presentViewController:cont animated:YES completion:nil];
}
-(IBAction)delImageBtnClicked:(UIButton *)btn{
    NSInteger idx = btn.tag - 30;
    NSMutableArray *arr = [self.finalModel.evaluate_photos mutableCopy];
    [arr removeObjectAtIndex:idx];
    self.finalModel.evaluate_photos = arr;
    
    NSMutableArray *ids = [[self.finalModel.evaluate_photos_id componentsSeparatedByString:@","]mutableCopy];
    [ids removeObjectAtIndex:idx];
    if (ids.count == 0) {
        self.finalModel.evaluate_photos_id = @"";
    }else {
        NSString *str = [ids componentsJoinedByString:@","];
        self.finalModel.evaluate_photos_id = str;
    }
    [self.tableView reloadData];
}
-(void)dismissKeyBoard{
    [self.view endEditing:YES];
}
-(void)btnStarClicked:(UIButton *)btn{
    btn.selected = !btn.isSelected;
    //修改模型用于提交
    NSInteger row = btn.tag / 10;
    NSInteger a = btn.tag % 10;
    float b;
    if (btn.selected) {
        b = 1.0;
    }else {
        b = 1.0;
    }
    float c = (float)a + b;
    if (row == 0) {
        self.finalModel.service_evaluate = c;
    }else if (row == 1){
        self.finalModel.description_evaluate = c;
    }else if (row == 2){
        self.finalModel.ship_evaluate = c;
    }
    [self.tableView reloadData];
}

@end
