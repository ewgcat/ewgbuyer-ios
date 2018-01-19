//
//  EnsureestimateViewController.m
//  My_App
//
//  Created by apple on 14-8-25.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "EnsureestimateViewController.h"
#import "publishTableViewCell.h"
#import "ThirdViewController.h"
#import "DoImagePickerController.h"

@interface Bmessage : NSObject

@property (nonatomic) NSString *property1;
@property (nonatomic) NSInteger property2;

@end

@interface EnsureestimateViewController ()<DoImagePickerControllerDelegate>

@property (nonatomic, assign) CGPoint yiqiandenagedian;

@end

static EnsureestimateViewController *singleInstance=nil;


@implementation EnsureestimateViewController
{
    UIButton *btnQ;
}
@synthesize MyTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"商品评价";
        
        if (UIDeviceHao>=7.0) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ScreenFrame.origin.y, ScreenFrame.size.width, ScreenFrame.size.height-64-49) style:UITableViewStylePlain];
        MyTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        MyTableView.delegate = self;
        MyTableView.dataSource = self;
        MyTableView.showsVerticalScrollIndicator=NO;
        MyTableView.showsHorizontalScrollIndicator = NO;
        
        [self.view addSubview:MyTableView];
        
        [self createBottomView];
        
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
        
        uploadCount = 0;
        totalCount = 0;
        resultPicDict = [NSMutableDictionary dictionary];
        imageIDDict = [NSMutableDictionary dictionary];
        hasPicDict = [NSMutableDictionary dictionary];
    }
    return self;
}
-(void)createBottomView
{

    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor =[UIColor whiteColor];
    bottomView.frame = CGRectMake(0, ScreenFrame.size.height-49-64, ScreenFrame.size.width, 49);
    [self.view addSubview:bottomView];
    
    UIImageView *imageLineTop = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bottomView.frame.size.width, 0.5)];
    imageLineTop.backgroundColor = UIColorFromRGB(0xe3e3e3);
    [bottomView addSubview:imageLineTop];
    
    btnQ = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnQ setBackgroundImage:[UIImage imageNamed:@"checkbox_no.png"] forState:UIControlStateNormal];
    btnQ.frame = CGRectMake(0, 4.5, 40, 40);
    [btnQ addTarget:self action:@selector(noNameSelected:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btnQ];
    
     UILabel *lae3 = [[UILabel alloc]initWithFrame:CGRectMake(37,4.5, 80, 40)];
    lae3.text = @"匿名评价";
    lae3.textColor = [UIColor darkGrayColor];
    lae3.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:lae3];

     UIButton *submit = [[UIButton alloc]initWithFrame:CGRectMake(bottomView.size.width-100, 0, 100, 49)];
    [submit setTitle:@"发表评价" forState:(UIControlStateNormal)];
    submit.titleLabel.font=[UIFont systemFontOfSize:14];
    [submit setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    submit.backgroundColor = MY_COLOR;
    [submit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:submit];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request101 clearDelegatesAndCancel];
    [request102 clearDelegatesAndCancel];
}
-(void)noNameSelected:(UIButton *)btn
{
    btn.selected=!btn.selected;
    if (btn.selected)
    {
     [btnQ setBackgroundImage:[UIImage imageNamed:@"checkbox_yes.png"] forState:UIControlStateNormal];
    }else
    {
     [btnQ setBackgroundImage:[UIImage imageNamed:@"checkbox_no.png"] forState:UIControlStateNormal];
    
    }



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
    CGFloat offset = 70;
    if (dataArray.count!=0) {
        NSString *key = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        NSString *hasPic = hasPicDict[key];
        if ([hasPic isEqualToString:@"yes"]) {
            CGFloat sw = ScreenFrame.size.width;
            return 275 + (sw - 25) /4 + 45 + offset;
        }else {
            return 275 + 30 + 5 +35-35 + offset;
        }
    }
    return 270 + offset;
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
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect rect = [MyTableView convertRect:textView.frame fromView:textView.superview];
    self.yiqiandenagedian = MyTableView.contentOffset;
    [MyTableView setContentOffset:CGPointMake(0, rect.origin.y) animated:YES];

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
                        NSString *key1 = [NSString stringWithFormat:@"%ld",(long)picker.tag - 414];
                        hasPicDict[key1] = @"yes";
                        
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
    
    UITableViewCell *cell=(UITableViewCell *)btn.superview;
    NSIndexPath *path=[MyTableView indexPathForCell:cell];
    
    ClassifyModel *model = dataArray[path.row];
    NSString *key = model.goods_id;
    NSMutableArray *resultPicArr = resultPicDict[key];
    if (resultPicArr.count<4) {
        DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
        cont.delegate = self;
        cont.nMaxCount = 4-resultPicArr.count;     // larger than 1
        cont.nColumnCount = 3;  // 2, 3, or 4
        cont.tag = btn.tag;
        cont.nResultType = DO_PICKER_RESULT_UIIMAGE; // get UIImage object array : common case
        // if you want to get lots photos, you had better use DO_PICKER_RESULT_ASSET.
        
        [self presentViewController:cont animated:YES completion:nil];
    }else{
    [OHAlertView showAlertWithTitle:@"提示" message:@"抱歉,最多可添加4张图片" cancelButton:@"确定" otherButtons:nil buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
        
    }];
    
    
    }

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    publishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"publishTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        for (UIView *subView in cell.contentView.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    
    if (dataArray.count !=0 ) {
        //其他行
        ClassifyModel *class = [dataArray objectAtIndex:indexPath.row];
        [cell.image sd_setImageWithURL:[NSURL URLWithString:class.goods_main_photo] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
        cell.name.text = class.goods_name;
        
        UITextView *mytextview = [[UITextView alloc]initWithFrame:cell.pingkuangImage.frame];//CGRectMake(60, 150, ScreenFrame.size.width-70, 67)
        mytextview.delegate = self;
        mytextview.font = [UIFont systemFontOfSize:14];
        mytextview.tag = indexPath.row;
        mytextview.text = [[pingjiaArray objectAtIndex:indexPath.row] objectForKey:@"content"];
        class.goods_pingcontent = mytextview.text;
        mytextview.backgroundColor = [UIColor clearColor];
        [cell addSubview:mytextview];
        
        
        UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34)];
        [topView setBarStyle:UIBarStyleDefault];
        topView.backgroundColor=UIColorFromRGB(0xf0f1f2);
        UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        //UIColorFromRGB(0xf15353)
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
        button.frame =CGRectMake(0, 0, 35, 34);
        button.tag = indexPath.row;
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dismissKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:UIColorFromRGB(0xf15353) forState:UIControlStateNormal];
        button.titleLabel.font  = [UIFont boldSystemFontOfSize:15];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithCustomView:button];
        NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
        [topView setItems:buttonsArray];
        [mytextview setInputAccessoryView:topView];
        NSDictionary *PPP = [goodbadArray objectAtIndex:indexPath.row];
        
        //三朵小花
        
        CGFloat fY = cell.label5.centerY - 8.5;
        
        for(int i=0;i<3;i++){
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame =CGRectMake(60+85*i, fY, 48, 17);
            button.tag =indexPath.row * 100 + i;
            class.goods_pingjiazhi = [NSString stringWithFormat:@"%ld",(long)pingjiaZhi];
            if ([[PPP objectForKey:@"ppp"] intValue] == 1) {
                if (i==0) {
                    [button setBackgroundImage:[UIImage imageNamed:@"gooddian_lj"] forState:UIControlStateNormal];
                }
                if (i==1) {
                    [button setBackgroundImage:[UIImage imageNamed:@"zhong_lj"] forState:UIControlStateNormal];
                }
                if (i==2) {
                    [button setBackgroundImage:[UIImage imageNamed:@"cha_lj"] forState:UIControlStateNormal];
                }
            }else if([[PPP objectForKey:@"ppp"] intValue] == 0){
                if (i==0) {
                    [button setBackgroundImage:[UIImage imageNamed:@"good_lj"] forState:UIControlStateNormal];
                }
                if (i==1) {
                    [button setBackgroundImage:[UIImage imageNamed:@"zhongdian_lj1"] forState:UIControlStateNormal];
                }
                if (i==2) {
                    [button setBackgroundImage:[UIImage imageNamed:@"cha_lj"] forState:UIControlStateNormal];
                }
            }else if([[PPP objectForKey:@"ppp"] intValue] ==  -1){
                if (i==0) {
                    [button setBackgroundImage:[UIImage imageNamed:@"good_lj"] forState:UIControlStateNormal];
                }
                if (i==1) {
                    [button setBackgroundImage:[UIImage imageNamed:@"zhong_lj"] forState:UIControlStateNormal];
                }
                if (i==2) {
                    [button setBackgroundImage:[UIImage imageNamed:@"chadian_lj"] forState:UIControlStateNormal];
                }
            }
            [button addTarget:self action:@selector(NewbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:button];
        }
        NSDictionary *dic = [scoreDataArray objectAtIndex:indexPath.row];
        
        //三排星星
        
        for(int i=1;i<6;i++){
            
            CGFloat y1 = cell.label1.centerY - 9.0;
            CGFloat y2 = cell.label2.centerY - 9.0;
            CGFloat y3 = cell.label3.centerY - 9.0;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame =CGRectMake(88.5+20*i, y1, 19, 18);
            button.tag =1000 + 100*indexPath.row + i;
            if (i-1>[[dic objectForKey:@"describe"] intValue]) {
                [button setBackgroundImage:[UIImage imageNamed:@"starhui_lj"] forState:UIControlStateNormal];
            }else{
                [button setBackgroundImage:[UIImage imageNamed:@"star_lj"] forState:UIControlStateNormal];
            }
            [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font  = [UIFont systemFontOfSize:14];
            [cell addSubview:button];
            
            UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom ];
            button2.frame =CGRectMake(88.5+20*i, y2, 19, 18);
            [button2 setBackgroundImage:[UIImage imageNamed:@"star_lj"] forState:UIControlStateNormal];
            button2.tag =2000 + indexPath.row*100 + i;
            if (i-1>[[dic objectForKey:@"server"] intValue]) {
                [button2 setBackgroundImage:[UIImage imageNamed:@"starhui_lj"] forState:UIControlStateNormal];
            }else{
                [button2 setBackgroundImage:[UIImage imageNamed:@"star_lj"] forState:UIControlStateNormal];
            }
            [button2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            button2.titleLabel.font  = [UIFont systemFontOfSize:14];
            [cell addSubview:button2];
            
            UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom ];
            button3.frame =CGRectMake(88.5+20*i, y3, 19, 18);
            [button3 setBackgroundImage:[UIImage imageNamed:@"star_lj"] forState:UIControlStateNormal];
            button3.tag =+3000 + 100*indexPath.row + i;
            if (i-1>[[dic objectForKey:@"send"] intValue]) {
                [button3 setBackgroundImage:[UIImage imageNamed:@"starhui_lj"] forState:UIControlStateNormal];
            }else{
                [button3 setBackgroundImage:[UIImage imageNamed:@"star_lj"] forState:UIControlStateNormal];
            }
            [button3 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            button3.titleLabel.font  = [UIFont systemFontOfSize:14];
            [cell addSubview:button3];
        }
        
        NSString *key = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        NSString *hasPic = hasPicDict[key];
        CGFloat newY = 0;
        
        CGFloat iY = 0;
        
        //选择的图片
        if ([hasPic isEqualToString:@"yes"]) {
            CGFloat sw = ScreenFrame.size.width;
            NSInteger row = indexPath.row;
            ClassifyModel *model = dataArray[row];
            NSString *key = model.goods_id;
            NSMutableArray *resultPicArr = resultPicDict[key];
            for (int i=0; i<resultPicArr.count; i++) {
                UIImage *img = resultPicArr[i];
                CGFloat ivw1 = (sw -50) *0.25;
                UIImageView *iv = [[UIImageView alloc]initWithImage:img];
                CGFloat ivx = 5 + (ivw1 + 10) * i;
                CGFloat ivy = fY + 50;
                CGFloat ivw = ivw1;
                CGFloat ivh = ivw;
                iv.frame = CGRectMake(ivx, ivy, ivw, ivh);
                [cell addSubview:iv];
                newY = ivy + ivh + 10;
                
                
                //删除按钮
                CGFloat delW = 25;
                CGFloat delH = 15;
                UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [delBtn setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
                
                delBtn.frame = CGRectMake(CGRectGetMaxX(iv.frame) - 0.5 * delW, CGRectGetMinY(iv.frame) - 0.5 * delH, delW, delH);
                
                [delBtn addTarget:self action:@selector(delImageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:delBtn];
                delBtn.tag = 30 + i;
                
                iY = iv.bottom;
            }
        }
        
        UIButton *selBtn;
        selBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selBtn.tag = 414 + indexPath.row;
        CGFloat sY = iY == 0 ? fY + 35 : iY + 10;
        selBtn.frame = CGRectMake(90, sY, ScreenFrame.size.width - 180, 30);
        selBtn.backgroundColor = UIColorFromRGB(0xf15353);
        selBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [selBtn setTitle:@"+添加晒单图片" forState:UIControlStateNormal];
        selBtn.layer.cornerRadius=4;
        selBtn.layer.masksToBounds=YES;
        [selBtn addTarget:self action:@selector(selBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:selBtn];
    }
    return cell;
}

-(void)delImageBtnClicked:(UIButton *)btn{
    
    NSInteger idx = btn.tag - 30;
    UITableViewCell *cell=(UITableViewCell *)btn.superview;
    NSIndexPath *path=[MyTableView indexPathForCell:cell];
   
    ClassifyModel *model = dataArray[path.row];
    NSString *key = model.goods_id;
    NSMutableArray *imageIDArr = imageIDDict[key];
    [imageIDArr removeObjectAtIndex:idx];
    NSMutableArray *resultPicArr = resultPicDict[key];
    [resultPicArr removeObjectAtIndex:idx];
    [MyTableView reloadData];
    
}
-(void)NewbtnClicked:(UIButton *)btn{
    for(int i=0;i<dataArray.count;i++){
        if (btn.tag<100) {
            if (btn.tag==0) {
                [[goodbadArray objectAtIndex:0] setObject:@"1" forKey:@"ppp"];
            }else if (btn.tag == 1){
                [[goodbadArray objectAtIndex:0] setObject:@"0" forKey:@"ppp"];
            }else{
                [[goodbadArray objectAtIndex:0] setObject:@"-1" forKey:@"ppp"];
            }
            [MyTableView reloadData];
        }else{
            if (btn.tag%100==0) {
                [[goodbadArray objectAtIndex:btn.tag/100] setObject:@"1" forKey:@"ppp"];
            }else if (btn.tag%100 == 1){
                [[goodbadArray objectAtIndex:btn.tag/100] setObject:@"0" forKey:@"ppp"];
            }else{
                [[goodbadArray objectAtIndex:btn.tag/100] setObject:@"-1" forKey:@"ppp"];
            }
            [MyTableView reloadData];
        }
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    [[pingjiaArray objectAtIndex:textView.tag] setObject:textView.text forKey:@"content"];
}
-(void)dismissKeyBoard:(UIButton *)btn{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘

    [MyTableView setContentOffset:self.yiqiandenagedian animated:NO];

    
}
-(void)btnClicked:(UIButton *)btn{
    for(int i=0;i<dataArray.count;i++){
        if (btn.tag<2000) {//说明是描述相符
            if(btn.tag-1000<100){//说明是第一行第一个
                [[scoreDataArray objectAtIndex:0] setObject:[NSString stringWithFormat:@"%d",(int)btn.tag-1000-1] forKey:@"describe"];
            }else{
                [[scoreDataArray objectAtIndex:(btn.tag-1000)/100] setObject:[NSString stringWithFormat:@"%d",(int)(btn.tag-1000)%100-1] forKey:@"describe"];
            }
            [MyTableView reloadData];
        }else if (btn.tag<3000) {//说明是服务
            if(btn.tag-2000<100){//说明是第一行第一个
                [[scoreDataArray objectAtIndex:0] setObject:[NSString stringWithFormat:@"%d",(int)btn.tag-2000-1] forKey:@"server"];
            }else{
                [[scoreDataArray objectAtIndex:(btn.tag-2000)/100] setObject:[NSString stringWithFormat:@"%d",(int)(btn.tag-2000)%100-1] forKey:@"server"];
            }
            [MyTableView reloadData];
        }else  if (btn.tag<4000) {//说明是发货速度
            if(btn.tag-3000<100){//说明是第一行第一个
                [[scoreDataArray objectAtIndex:0] setObject:[NSString stringWithFormat:@"%d",(int)btn.tag-3000-1] forKey:@"send"];
            }else{
                [[scoreDataArray objectAtIndex:(btn.tag-3000)/100] setObject:[NSString stringWithFormat:@"%d",(int)(btn.tag-3000)%100-1] forKey:@"send"];
            }
            [MyTableView reloadData];
        }
    }
}
-(void)submit {
    
    //发起提交请求  ORDERESTIMATE_URL
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ORDERESTIMATE_URL]];
    request102 = [ASIFormDataRequest requestWithURL:url];
    [request102 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request102 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    if (btnQ.selected) {
       [request102 setPostValue:@"0" forKey:@"checkState"];
    }
   
    for(int i=0;i<dataArray.count;i++){
        //每一次循环代表订单中的一件商品
        ClassifyModel *class = [dataArray objectAtIndex:i];
        NSMutableDictionary *dicgoodbad = [goodbadArray objectAtIndex:i];
        [request102 setPostValue:[dicgoodbad objectForKey:@"ppp"] forKey:[NSString stringWithFormat:@"evaluate_buyer_val%@",class.goods_id]];
        NSMutableDictionary *dicpingjia = [scoreDataArray objectAtIndex:i];
        [request102 setPostValue:[NSString stringWithFormat:@"%d",[[dicpingjia objectForKey:@"describe"] intValue]+1] forKey:[NSString stringWithFormat:@"description_evaluate%@",class.goods_id]];
        [request102 setPostValue:[NSString stringWithFormat:@"%d",[[dicpingjia objectForKey:@"server"] intValue]+1] forKey:[NSString stringWithFormat:@"service_evaluate%@",class.goods_id]];
        [request102 setPostValue:[NSString stringWithFormat:@"%d",[[dicpingjia objectForKey:@"send"] intValue]+1] forKey:[NSString stringWithFormat:@"ship_evaluate%@",class.goods_id]];
        NSMutableDictionary *didInfo = [pingjiaArray objectAtIndex:i];
        [request102 setPostValue:[didInfo objectForKey:@"content"] forKey:[NSString stringWithFormat:@"evaluate_info_%@",class.goods_id]];
        
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
-(void)sec_urlRequestSucceeded:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig:%@",dicBig);
        if ([[dicBig objectForKey:@"code"] intValue] == 100) {
            [SYObject failedPrompt:@"已成功评价"];
        }else if ([[dicBig objectForKey:@"code"] intValue] == -200){
            [SYObject failedPrompt:@"用户信息错误"];
        }else if ([[dicBig objectForKey:@"code"] intValue] == -300){
            [SYObject failedPrompt:@"订单已经评价"];
        }else {
            [SYObject failedPrompt:@"未知错误"];
        }
    }
    [self pop];
}
-(void)pop{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}
-(void)sec_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
    [self pop];
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
