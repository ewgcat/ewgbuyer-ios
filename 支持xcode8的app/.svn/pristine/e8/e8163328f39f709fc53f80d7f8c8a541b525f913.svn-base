//
//  EnsureestimateViewController.m
//  My_App
//
//  Created by apple on 14-8-25.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "EnsureestimateViewController2.h"
#import "publishTableViewCell2.h"
#import "ThirdViewController.h"
#import "DoImagePickerController.h"

static CGFloat off = 100;

@interface EnsureestimateViewController2 ()<DoImagePickerControllerDelegate>

@end

@implementation EnsureestimateViewController2
@synthesize MyTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"商品追加评价";
        
        if (UIDeviceHao>=7.0) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ScreenFrame.origin.y, ScreenFrame.size.width, ScreenFrame.size.height-64) style:UITableViewStylePlain];
        MyTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        MyTableView.delegate = self;
        MyTableView.dataSource = self;
        MyTableView.showsVerticalScrollIndicator=NO;
        MyTableView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:MyTableView];
        UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backBtnClicked)];
        rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
        [MyTableView addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];
        
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,PUBLISHLIST_URL]];
        ThirdViewController *th = [ThirdViewController sharedUserDefault];
        request101 = [ASIFormDataRequest requestWithURL:url];
        
        [request101 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
        [request101 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];

        [request101 setPostValue:th.ding_order_id forKey:@"order_id"];
        
        [request101 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request101.delegate = self;
        [request101 setDidFailSelector:@selector(urlRequestFailed:)];
        [request101 setDidFinishSelector:@selector(urlRequestSucceeded:)];
        [request101 startAsynchronous];
        [SYObject startLoading];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
//    hasPic = NO;
//    selBtn = nil;
    uploadCount = 0;
    totalCount = 0;
    resultPicDict = [NSMutableDictionary dictionary];
    imageIDDict = [NSMutableDictionary dictionary];
    selBtnDict = [NSMutableDictionary dictionary];
    btnStatusDict = [NSMutableDictionary dictionary];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request101 clearDelegatesAndCancel];
    [request102 clearDelegatesAndCancel];
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig:%@",dicBig);
        if (dataArray.count !=0) {
            [dataArray removeAllObjects];
        }
        if (pingjiaArray.count!=0) {
            [pingjiaArray removeAllObjects];
        }
        if (goodbadArray.count !=0) {
            [goodbadArray removeAllObjects];
        }
        if (scoreDataArray.count !=0) {
            [scoreDataArray removeAllObjects];
        }
        NSArray *arr = [dicBig objectForKey:@"goods_list"];
        for(NSDictionary *din in arr){
            ClassifyModel *class = [[ClassifyModel alloc]init];
            class.goods_id = [NSString stringWithFormat:@"%@",[din objectForKey:@"goods_id"]];
            class.goods_main_photo = [NSString stringWithFormat:@"%@",[din objectForKey:@"goods_mainphoto_path"]];
            class.goods_name = [NSString stringWithFormat:@"%@",[din objectForKey:@"goods_name"]];
            [dataArray addObject:class];
            NSArray * values2 = [NSArray arrayWithObjects:@"1", nil];
            NSArray * keys2 = [NSArray arrayWithObjects:@"ppp", nil];
            NSMutableDictionary * dict3 = [[NSMutableDictionary alloc]initWithObjects:values2 forKeys:keys2];
            [goodbadArray addObject:dict3];
            NSArray * values4 = [NSArray arrayWithObjects:@"", nil];
            NSArray * keys4 = [NSArray arrayWithObjects:@"content", nil];
            NSMutableDictionary * dict4 = [[NSMutableDictionary alloc]initWithObjects:values4 forKeys:keys4];
            [pingjiaArray addObject:dict4];
            NSArray * values = [NSArray arrayWithObjects:@"5",@"5",@"5", nil];
            NSArray * keys = [NSArray arrayWithObjects:@"describe",@"server",@"send", nil];
            NSMutableDictionary * dict2 = [[NSMutableDictionary alloc]initWithObjects:values forKeys:keys];
            [scoreDataArray addObject:dict2];
        }
    }else{
        [SYObject failedPrompt:@"网络请求失败"];
    }
    [MyTableView reloadData];
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}
#pragma mark - 返回按钮
-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}
-(void)backBtnClicked{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-tableView方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArray.count!=0) {
        return dataArray.count;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    NSString *selected = btnStatusDict[key];
    if (dataArray.count!=0) {
        if (indexPath.row == dataArray.count-1) {
            //最后一行
            if (selected || [selected isEqualToString:@"yes"]) {
                CGFloat sw = ScreenFrame.size.width;
                return 275 + (sw - 25) /4 + 45 - off;
            }else {
                return 275 + 30 + 5 +35 - off;
            }
            
        }else {
            //其他行
            CGFloat add = -20;
            if (selected || [selected isEqualToString:@"yes"]) {
                CGFloat sw = ScreenFrame.size.width;
                return 275 + (sw - 25) /4 + 45 - off + add;
            }else {
                return 275 + 30 + 5 +35 - off + add;
            }
        }
    }
    return 270 - off;
}
//内容将要发生改变编辑
#pragma mark - UITextView Delegate Methods
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [MyTableView reloadData];
        return NO;
    }
    return YES;
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
            totalCount += aSelected.count;
//            hasPic = YES;
            [SYObject startInfinitLoading];
            //上传图片到服务器
            for (UIImage *img in aSelected) {
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
                        NSInteger row = picker.tag - 414;
                        ClassifyModel *model = dataArray[row];
                        NSString *key = model.goods_id;
                        NSMutableArray *imageIDArr = imageIDDict[key];
                        if (imageIDArr == nil) {
                            imageIDArr = [NSMutableArray array];
                            imageIDDict[key] = imageIDArr;
                        }
                        [imageIDArr addObject:imageID];
                        NSMutableArray *resultPicArr = resultPicDict[key];
                        if (resultPicArr == nil) {
                            resultPicArr = [NSMutableArray array];
                            resultPicDict[key] = resultPicArr;
                        }
                        [resultPicArr addObject:img];
                        [MyTableView reloadData];
                    }
                    uploadCount += 1;
                    
                    if (uploadCount == totalCount) {
                        [SYObject endLoading];
                        //至此，所有图片上传完毕
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"%@",[error localizedDescription]);
                }];
            }
        }
    }];
}
-(IBAction)selBtnClicked:(UIButton *)btn{
    NSString *key = [NSString stringWithFormat:@"%ld",(long)btn.tag - 414];
    btnStatusDict[key] = @"yes";
    
    DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
    cont.delegate = self;
    cont.nMaxCount = 4;     // larger than 1
    cont.nColumnCount = 3;  // 2, 3, or 4
    cont.tag = btn.tag;
    cont.nResultType = DO_PICKER_RESULT_UIIMAGE; // get UIImage object array : common case
    // if you want to get lots photos, you had better use DO_PICKER_RESULT_ASSET.
    
    [self presentViewController:cont animated:YES completion:nil];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    publishTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"publishTableViewCell2" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        for (UIView *subView in cell.contentView.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    
    if (dataArray.count !=0 ) {
        ClassifyModel *class = [dataArray objectAtIndex:indexPath.row];
        [cell.image sd_setImageWithURL:[NSURL URLWithString:class.goods_main_photo] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
        cell.name.text = class.goods_name;
        
        UITextView *mytextview = [[UITextView alloc]initWithFrame:CGRectMake(60, 150 - 62, ScreenFrame.size.width-70, 67)];
        mytextview.delegate = self;
        mytextview.tag = indexPath.row;
        mytextview.text = [[pingjiaArray objectAtIndex:indexPath.row] objectForKey:@"content"];
        class.goods_pingcontent = mytextview.text;
        mytextview.backgroundColor = [UIColor clearColor];
        [cell addSubview:mytextview];
        UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 30)];
        [topView setBarStyle:UIBarStyleBlack];
         topView.backgroundColor=UIColorFromRGB(0xf0f1f2);
        UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
        button.frame =CGRectMake(0, 0, 35, 30);
        button.tag = indexPath.row;
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dismissKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font  = [UIFont boldSystemFontOfSize:15];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithCustomView:button];
        NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
        [topView setItems:buttonsArray];
        [mytextview setInputAccessoryView:topView];
        
        CGFloat newY =0;
        NSString *key = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        UIButton *selBtn = selBtnDict[key];
        NSString *selected = btnStatusDict[key];
        if (selected || [selected isEqualToString:@"yes"]) {
            CGFloat sw = ScreenFrame.size.width;
            NSInteger row = indexPath.row;
            ClassifyModel *model = dataArray[row];
            NSString *key = model.goods_id;
            NSMutableArray *resultPicArr = resultPicDict[key];
            for (int i=0; i<resultPicArr.count; i++) {
                UIImage *img = resultPicArr[i];
                CGFloat ivw1 = (sw -25) *0.25;
                UIImageView *iv = [[UIImageView alloc]initWithImage:img];
                CGFloat ivx = 5 + (ivw1 + 5) * i;
                CGFloat ivy = 275 - off;
                CGFloat ivw = ivw1;
                CGFloat ivh = ivw;
                iv.frame = CGRectMake(ivx, ivy, ivw, ivh);
                [cell addSubview:iv];
                newY = ivy + ivh + 10;
            }
                [selBtn removeFromSuperview];
        }else {
            selBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            selBtnDict[key] = selBtn;
            selBtn.tag = 414 + indexPath.row;
            selBtn.frame = CGRectMake(90, 275 - off, ScreenFrame.size.width - 180, 30);
            selBtn.backgroundColor = MY_COLOR;
            selBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            [selBtn setTitle:@"+追加晒单图片" forState:UIControlStateNormal];
            selBtn.layer.cornerRadius=4;
            selBtn.layer.masksToBounds=YES;
            [selBtn addTarget:self action:@selector(selBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:selBtn];
        }
        
        //最后一行
        if (indexPath.row == dataArray.count-1) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 333333;
            if (selected || [selected isEqualToString:@"yes"]) {
                btn.frame =CGRectMake(110, newY, ScreenFrame.size.width - 220, 30);
            }else {
                btn.frame =CGRectMake(110, 275 + 30 + 5 - off, ScreenFrame.size.width - 220, 30);
            }
            btn.backgroundColor = MY_COLOR;
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            [btn setTitle:@"提交" forState:UIControlStateNormal];
            btn.layer.cornerRadius=4;
            btn.layer.masksToBounds=YES;
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
        }
    }
    
    
    

    return cell;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    [[pingjiaArray objectAtIndex:textView.tag] setObject:textView.text forKey:@"content"];
}
-(void)dismissKeyBoard:(UIButton *)btn{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
}
-(void)btnClicked:(UIButton *)btn{
    if (btn.tag == 333333) {
        //发起提交请求  ORDERESTIMATE_URL
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
        NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ORDERESTIMATE_URL]];
        request102 = [ASIFormDataRequest requestWithURL:url];
        [request102 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
        [request102 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
        for(int i=0;i<dataArray.count;i++){
            //每一次循环代表订单中的一件商品
            ClassifyModel *class = [dataArray objectAtIndex:i];
            //追加评价
            NSMutableDictionary *didInfo = [pingjiaArray objectAtIndex:i];
            [request102 setPostValue:[didInfo objectForKey:@"content"] forKey:[NSString stringWithFormat:@"evaluate_info_%@",class.goods_id]];
            //追加晒单图片
            NSString *key = class.goods_id;
            NSMutableArray *imageIDArray = imageIDDict[key];
            NSString *picKey = [NSString stringWithFormat:@"evaluate_photos_%@",class.goods_id];
            NSString *picValue = [imageIDArray componentsJoinedByString:@","];
            [request102 setPostValue:picValue forKey:picKey];
        }
       
        ThirdViewController *th = [ThirdViewController sharedUserDefault];
        [request102 setPostValue:th.ding_order_id forKey:@"order_id"];
        
        [request102 setRequestHeaders:[LJControl requestHeaderDictionary]];
        request102.delegate = self;
        [request102 setDidFailSelector:@selector(sec_urlRequestFailed:)];
        [request102 setDidFinishSelector:@selector(sec_urlRequestSucceeded:)];
        [request102 startAsynchronous];
        [SYObject startLoading];
    }
}

-(void)sec_urlRequestSucceeded:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig:%@",dicBig);
        if ([[dicBig objectForKey:@"code"] intValue] == 100) {
            [SYObject failedPrompt:@"已成功评价" complete:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else if ([[dicBig objectForKey:@"code"] intValue] == -300){
            [SYObject failedPrompt:@"订单已经评价过"];
        }
    }
}

-(void)sec_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
}

- (void)viewDidLoad
{
    scoreDataArray = [[NSMutableArray alloc]init];
    pingjiaArray = [[NSMutableArray alloc]init];
    goodbadArray = [[NSMutableArray alloc]init];
    [super viewDidLoad];
    [self createBackBtn];
    xiangfuTag = 5;
    taiduTag = 5;
    suduTag = 5;
    pingjiaZhi = 1;
    dataArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view from its nib.
}

@end
