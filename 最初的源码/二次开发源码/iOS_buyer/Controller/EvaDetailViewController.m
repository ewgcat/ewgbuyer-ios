//
//  EvaDetailViewController.m
//  My_App
//
//  Created by shiyuwudi on 16/2/1.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

#import "EvaDetailViewController.h"
#import "EvaAddModel.h"
#import "DoImagePickerController.h"

@interface EvaDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsEva;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) UILabel *comment;
@property (weak, nonatomic) UILabel *addComment;
@property (weak, nonatomic) IBOutlet UIView *starHolder;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) UITextField * commentView;
@property (nonatomic, strong) NSMutableArray *starBtnArray;
@property (nonatomic, strong) NSMutableArray *delBtnArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (strong, nonatomic)EvaAddModel *finalModel;
@property (assign, nonatomic)NSInteger pickCount;
@property (weak, nonatomic) UIView *imageHolder;

@end

@implementation EvaDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self net];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableView 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.backgroundColor = [UIColor greenColor];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (ScreenFrame.size.width - 7.0 * 8.0) * 0.25 + 16;
}
#pragma mark - 网络请求
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
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.model.goods_main_photo] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
            self.goodsName.text = self.model.goods_name;
            NSString *val = nil;
            switch (self.finalModel.evaluate_buyer_val) {
                case 1:{
                    val = @"好评";
                    break;
                }
                case 0:{
                    val = @"中评";
                    break;
                }
                case -1:{
                    val = @"差评";
                    break;
                }
                default:{
                    val = @"未知";
                    break;
                }
            }
            self.goodsEva.text = val;
            //星星
            NSArray *labelArr = @[self.label1,self.label2,self.label3];
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
                [self.starHolder addSubview:holder];
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
            //评语、追评语
            
            CGFloat w1 = ScreenFrame.size.width - 16;
            NSString *str0 = nil;
            if (self.model.evaluate_info&&self.model.evaluate_info.length!=0) {
                str0 = self.model.evaluate_info;
            }else{
                str0 = @"暂无评语";
            }
            NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
            NSString *str1 = [NSString stringWithFormat:@"  评语: %@",str0];
            CGFloat h1 = [str1 boundingRectWithSize:CGSizeMake(w1, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.height;
            h1 += 16;
            UILabel * commentView = [[UILabel alloc]initWithFrame:CGRectMake(8, self.starHolder.bottom + 8, w1, h1)];
            commentView.text = str1;
            commentView.numberOfLines=0;
            commentView.backgroundColor = [UIColor whiteColor];
            [self.scrollView addSubview:commentView];
            
            if (self.modify) {
                commentView.userInteractionEnabled = YES;
            }else {
                commentView.userInteractionEnabled = NO;
            }
            
            CGFloat w2 = w1;
            NSString *str2 = nil;
            if (self.model.addeva_info&&self.model.addeva_info.length!=0) {
                str2 = self.model.addeva_info;
            }else{
                str2 = @"暂无追加评语";
            }
            NSString *str3 = [NSString stringWithFormat:@"  追加评语: %@",str2];
            
            CGFloat h2 = [str3 boundingRectWithSize:CGSizeMake(w2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.height;
            
            h2 += 16;
            if (self.modify) {
                h2 = 0;
            }
            UILabel * addCommentView = [[UILabel alloc]initWithFrame:CGRectMake(8, commentView.bottom + 8, w2, h2)];
            addCommentView.text = str3;
            addCommentView.numberOfLines=0;
            addCommentView.backgroundColor = [UIColor whiteColor];
            [self.scrollView addSubview:addCommentView];
            void(^changeToHeight)(CGFloat) = ^(CGFloat new){
                CGSize size = self.scrollView.contentSize;
                size.height = new + ScreenFrame.size.height * 0.5;
                self.scrollView.contentSize = size;
            };
            changeToHeight(addCommentView.bottom + 8);
            
            //晒单、追加晒单
            CGFloat h4 = (ScreenFrame.size.width - 7.0 * 8.0) * 0.25;//图片宽高
            CGFloat h3 = h4 + 2 * 8;//外框高度
            
            if(self.finalModel.evaluate_photos && self.finalModel.evaluate_photos.count >0){
                
                UILabel *lblImage1 = [LJControl labelFrame:CGRectMake(8, addCommentView.bottom + 8, w2, 20) setText:@"  晒单图片" setTitleFont:17 setbackgroundColor:UIColorFromRGB(0xf1f1f1) setTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
                [self.scrollView addSubview:lblImage1];
                
                UIView *imageHolder = [[UIView alloc]initWithFrame:CGRectMake(8, lblImage1.bottom + 8, w2, h3)];
                imageHolder.backgroundColor  = [UIColor whiteColor];
                [self.scrollView addSubview:imageHolder];
                self.imageHolder = imageHolder;
                changeToHeight(imageHolder.bottom + 8);
                for (int i = 0;i < self.finalModel.evaluate_photos.count; i++){
                    //放图片
                    UIImageView *iv = [[UIImageView alloc]init];
                    [iv sd_setImageWithURL:[NSURL URLWithString:self.finalModel.evaluate_photos[i]] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
                    iv.frame = CGRectMake(8 + (8 + h4) * i, 8, h4, h4);
                    [imageHolder addSubview:iv];
                }
                if (self.finalModel.add_evaluate_photos && self.finalModel.add_evaluate_photos.count >0 && self.modify == NO) {
                    //放追加
                    UILabel *lblImage2 = [LJControl labelFrame:CGRectMake(8, imageHolder.bottom + 8, w2, h2) setText:@"  追加晒单图片" setTitleFont:17 setbackgroundColor:UIColorFromRGB(0xf1f1f1) setTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
                    [self.scrollView addSubview:lblImage2];
                    
                    UIView *imageHolder1 = [[UIView alloc]initWithFrame:CGRectMake(8, lblImage2.bottom + 8, w2, h3)];
                    imageHolder1.backgroundColor  = [UIColor whiteColor];
                    [self.scrollView addSubview:imageHolder1];
                    changeToHeight(imageHolder1.bottom + 8);
                    
                    for (int j = 0;j < self.finalModel.add_evaluate_photos.count; j++){
                        UIImageView *iv1 = [[UIImageView alloc]init];
                        [iv1 sd_setImageWithURL:[NSURL URLWithString:self.finalModel.add_evaluate_photos[j]] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
                        iv1.frame = CGRectMake(8 + (8 + h4) * j, 8, h4, h4);
                        [imageHolder1 addSubview:iv1];
                    }
                }
            }else if (self.finalModel.add_evaluate_photos && self.finalModel.add_evaluate_photos.count >0 && self.modify == NO){
                //放追加
                UILabel *lblImage3 = [LJControl labelFrame:CGRectMake(8, addCommentView.bottom + 8, w2, h2) setText:@"  追加晒单图片" setTitleFont:17 setbackgroundColor:UIColorFromRGB(0xf1f1f1) setTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
                [self.scrollView addSubview:lblImage3];
                
                UIView *imageHolder3 = [[UIView alloc]initWithFrame:CGRectMake(8, lblImage3.bottom + 8, w2, h3)];
                imageHolder3.backgroundColor  = [UIColor whiteColor];
                [self.scrollView addSubview:imageHolder3];
                changeToHeight(imageHolder3.bottom + 8);
                for (int k = 0;k < self.finalModel.add_evaluate_photos.count; k++){
                    UIImageView *iv1 = [[UIImageView alloc]init];
                    [iv1 sd_setImageWithURL:[NSURL URLWithString:self.finalModel.add_evaluate_photos[k]] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
                    iv1.frame = CGRectMake(8 + (8 + h4) * k, 8, h4, h4);
                    [imageHolder3 addSubview:iv1];
                }
            }
            
            
            
        }
        [SYObject endLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",[error localizedDescription]);
        [SYObject endLoading];
    }];
}
#pragma mark - 画界面
-(void)setupUI{
    self.title = @"评价详情";
    if (self.modify) {
        self.title = @"评价修改";
    }
    self.scrollView.contentSize = CGSizeMake(ScreenFrame.size.width, 1.5 * ScreenFrame.size.height);
    [self createBackBtn];
    self.starBtnArray = [NSMutableArray array];
    self.imageArray = [NSMutableArray array];
    self.delBtnArray = [NSMutableArray array];
    if (self.modify) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 键盘跟踪
-(void)dismissKeyBoard{
    [self.commentView resignFirstResponder];
}
- (void)keyBoardWillShow:(NSNotification *)note{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        CGFloat a = self.commentView.bottom - (ScreenFrame.size.height - ty - 44 - 44);
        [self.scrollView setContentOffset:CGPointMake(0, a)];
    }];
}
- (void)keyBoardWillHide:(NSNotification *)note{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [self.scrollView setContentOffset:CGPointZero];
    }];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark - 构造方法
+(instancetype)evaDetailViewController{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SYOrderStoryboard" bundle:nil];
    EvaDetailViewController *eva = [sb instantiateViewControllerWithIdentifier:@"EvaDetailViewController"];
    return eva;
}
#pragma mark - 点击方法
-(IBAction)delImageBtnClicked:(UIButton *)delBtn{
    NSInteger indx = delBtn.tag - 30;
    UIButton *btn = self.delBtnArray[indx];
    [btn removeFromSuperview];
    [self.delBtnArray removeObject:btn];
    UIImageView *iv = self.imageArray[indx];
    [iv removeFromSuperview];
    [self.imageArray removeObject:iv];
    NSMutableArray *ids = [[self.finalModel.evaluate_photos_id componentsSeparatedByString:@","]mutableCopy];
    [ids removeObjectAtIndex:indx];
    if (ids.count == 0) {
        self.finalModel.evaluate_photos_id = @"";
    }else {
        NSString *str = [ids componentsJoinedByString:@","];
        self.finalModel.evaluate_photos_id = str;
    }
}
-(void)set0:(UIButton *)btn{
    [btn setImage:[UIImage imageNamed:@"star0"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"star0"] forState:UIControlStateSelected];
}
-(void)set1:(UIButton *)btn{
    [btn setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateSelected];
}-(void)set5:(UIButton *)btn{
    [btn setImage:[UIImage imageNamed:@"star0.5"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"star0.5"] forState:UIControlStateSelected];
}
-(void)btnStarClicked:(UIButton *)btn{
    if (self.modify) {
        btn.selected = !btn.isSelected;
        if (!btn.selected) {
            [self set5:btn];
        }else{
            [self set1:btn];
        }
        for (UIButton *btn1 in self.starBtnArray) {
            if (btn1.tag / 10 == btn.tag / 10 && btn1.tag < btn.tag) {
                [self set1:btn1];
            }else if (btn1.tag / 10 == btn.tag / 10 && btn1.tag > btn.tag){
                [self set0:btn1];
            }
        }
        //修改模型用于提交
        NSInteger row = btn.tag / 10;
        NSInteger a = btn.tag % 10;
        float b;
        if (!btn.selected) {
            b = 0.5;
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
            [SYObject startInfinitLoading];
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
                    if (imageID) {
                        count += 1;
                        //TODO:添加图片和删除按钮到ui
                        //放图片
                        CGFloat h4 = (ScreenFrame.size.width - 7.0 * 8.0) * 0.25;
                        UIImageView *iv = [[UIImageView alloc]initWithImage:img];
                        iv.frame = CGRectMake(8 + (8 + h4) * self.imageArray.count, 8, h4, h4);
                        [self.imageHolder addSubview:iv];
                        CGFloat delW = 25;
                        CGFloat delH = 15;
                        void(^addDelBtn)(CGRect, UIView *, NSInteger) = ^(CGRect imageFrame, UIView *holder, NSInteger tag){
                            UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                            [delBtn setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
                            delBtn.frame = CGRectMake(CGRectGetMaxX(imageFrame) - 0.5 * delW, CGRectGetMinY(imageFrame) - 0.5 * delH, delW, delH);
                            [delBtn addTarget:self action:@selector(delImageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                            [holder addSubview:delBtn];
                            delBtn.tag = tag;
                            [self.delBtnArray addObject:delBtn];
                        };
                        addDelBtn(iv.frame,self.imageHolder,30 + self.imageArray.count);
                        [self.imageArray addObject:iv];
                        //修改提交的图片ID数组
                        NSMutableArray *ids = [[self.finalModel.evaluate_photos_id componentsSeparatedByString:@","]mutableCopy];
                        [ids addObject:imageID.stringValue];
                        NSString *str = [ids componentsJoinedByString:@","];
                        self.finalModel.evaluate_photos_id = str;
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
-(IBAction)pick:(UIButton *)btn{
    DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
    cont.delegate = self;
    cont.nMaxCount = 4 - self.imageArray.count;     // larger than 1
    cont.nColumnCount = 3;  // 2, 3, or 4
    cont.tag = btn.tag;
    cont.nResultType = DO_PICKER_RESULT_UIIMAGE; // get UIImage object array : common case
    // if you want to get lots photos, you had better use DO_PICKER_RESULT_ASSET.
    
    [self presentViewController:cont animated:YES completion:nil];
}

@end
