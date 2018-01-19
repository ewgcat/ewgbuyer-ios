//
//  TSDetailViewController.m
//  My_App
//
//  Created by barney on 15/11/25.
//  Copyright © 2015年 barney. All rights reserved.
//

#import "TSDetailViewController.h"
#import "TSCell.h"
#import "TSDoubleCell.h"
#import "TopicViewController.h"
#import "SingleOC.h"
#import "ASIFormDataRequest.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
@interface TSDetailViewController ()<UITableViewDataSource,UITabBarDelegate,UITableViewDelegate,ASIHTTPRequestDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITextViewDelegate>

@end

@implementation TSDetailViewController
{

    UITableView *_tabView;
    UILabel *_lab;
    UIImageView *_picture;
    ASIFormDataRequest *request_1;
    ASIFormDataRequest *request_2;
    UITextView *_textView;
    UITextView *_textView2;
    UIButton *_btn1;
    NSString *status;
    NSMutableArray *photoArray;
    NSMutableArray *encodeArray;
    NSMutableArray *idArray;
    NSMutableArray *ary;
    
    UITableViewCell *imageCell;
    NSMutableDictionary *imageDict;
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    imageDict = [NSMutableDictionary new];
    self.title=@"投诉详情";
    photoArray= [[NSMutableArray alloc]init];
    encodeArray =[[NSMutableArray alloc]init];
    idArray=[[NSMutableArray alloc]init];
    ary=[[NSMutableArray alloc]init];
    
    [self createView];
    [self createBackBtn];
    
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
-(void)createView
{
    _tabView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-64) style:(UITableViewStylePlain)];
   
    _tabView.delegate =self;
    _tabView.dataSource= self;
    _tabView.showsVerticalScrollIndicator=NO;
    _tabView.showsHorizontalScrollIndicator = NO;
   
    _tabView.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    //_tabView.separatorColor=[UIColor grayColor];
    _tabView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tabView];
   
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 40, 40);
    
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    [btn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //自定义的 导航栏按钮
    UIBarButtonItem *customItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem=customItem;
}

#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0) return 100;
    else if(indexPath.row==1) return 60;
    else if (indexPath.row==2) return 230;
    else return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellName=@"cell";
    
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row==1) {
       
        cell.textLabel.text=@"选择投诉主题";
        cell.textLabel.font=[UIFont systemFontOfSize:15];
        cell.textLabel.textColor=UIColorFromRGB(0X7e7e7e);
        UIButton *btn=[MyUtil createBtnFrame:CGRectMake(ScreenFrame.size.width-30, 18, 20, 20) title:nil image:@"bottomRightBtn" highlighImage:nil selectImage:nil target:self action:@selector(topBtnClick)];
        [cell addSubview:btn];
        if (_lab.text.length==0) {
            _lab=[[UILabel alloc]init];
        }
        _lab.frame=CGRectMake(ScreenFrame.size.width-160, 18, 120, 20);
        _lab.font=[UIFont systemFontOfSize:14];
        _lab.textAlignment=NSTextAlignmentRight;
        _lab.textColor=UIColorFromRGB(0X7e7e7e);
        [cell addSubview:_lab];
        UIView *line=[LJControl viewFrame:CGRectMake(0, 60, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe7e7e7)];
        [cell addSubview:line];
        
    }
    if (indexPath.row==2) {
        UILabel *lab1=[MyUtil createLabelFrame:CGRectMake(2, 25, 100, 30) text:@"问题描述 :" alignment:(NSTextAlignmentCenter) fontSize:15];
        lab1.textColor=UIColorFromRGB(0X7e7e7e);
        [cell addSubview:lab1];
        
        UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake(106, 15, ScreenFrame.size.width-120, 60)];
        textView.backgroundColor=UIColorFromRGB(0Xe4e4e4);
        textView.layer.cornerRadius=5;
        [textView.layer setMasksToBounds:YES];
        textView.delegate=self;
        textView.layer.borderColor=UIColorFromRGB(0Xe4e4e4).CGColor;
        textView.font=[UIFont systemFontOfSize:15];
        _textView=textView;
        
        WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"取消" leftTarget:self leftAction:@selector(editBtn) rightTitle:@"完成" rightTarget:self rightAction:@selector(editBtn)];
        [_textView setInputAccessoryView:inputView];

        [cell addSubview:textView];
        
        
        UILabel *lab2=[MyUtil createLabelFrame:CGRectMake(2, 103, 100, 30) text:@"投诉内容 :" alignment:(NSTextAlignmentCenter) fontSize:15];
        lab2.textColor=UIColorFromRGB(0X7e7e7e);
        [cell addSubview:lab2];
        
        UITextView *textView2=[[UITextView alloc]initWithFrame:CGRectMake(106, 100, ScreenFrame.size.width-120, 120)];
        textView2.backgroundColor=UIColorFromRGB(0Xe4e4e4);
        textView2.delegate=self;
        textView2.layer.cornerRadius=5;
        [textView2.layer setMasksToBounds:YES];
        textView2.layer.borderColor=UIColorFromRGB(0Xe4e4e4).CGColor;
        textView2.font=[UIFont systemFontOfSize:15];
        _textView2=textView2;
       
        _textView2.inputAccessoryView = inputView;
        [cell addSubview:textView2];
        UIView *line=[LJControl viewFrame:CGRectMake(0, 230, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe7e7e7)];
        [cell addSubview:line];
        
    }
    if (indexPath.row==3) {
        if (imageCell != nil) {
            return imageCell;
        }
        UILabel *lab3=[MyUtil createLabelFrame:CGRectMake(2, 25, 100, 30) text:@"投诉图片 :" alignment:(NSTextAlignmentCenter) fontSize:15];
        lab3.textColor=UIColorFromRGB(0X7e7e7e);
        
        [cell addSubview:lab3];
        
        UIView *line=[LJControl viewFrame:CGRectMake(0, 100, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe7e7e7)];
        [cell addSubview:line];
        
        
        for (int j=0; j<3; j++) {
            UIImageView *picture=[[UIImageView alloc]initWithFrame:CGRectMake(109+j*65, 25, 55, 55)];
            picture.userInteractionEnabled=YES;
            picture.tag=j+600;
            [cell addSubview:picture];
            picture.backgroundColor=UIColorFromRGB(0XF0F0F0);
            
            NSInteger tag = [status integerValue]-100;
            NSString *key = [NSString stringWithFormat:@"%ld",(long)tag];
            UIImage *saveImage = [imageDict valueForKey:key];
            if (saveImage != nil && j == tag -600) {
                [picture setImage:saveImage];
            }else{
                [picture setImage:[UIImage imageNamed:@"commitPicture.png"]];
            }
        }
        
        for (int i=0; i<3; i++) {
            UIButton *btn1=[MyUtil createBtnFrame:CGRectMake(109+65*i, 25, 55, 80) title:nil image:nil highlighImage:nil selectImage:nil target:self action:@selector(BtnClick:)];
            btn1.backgroundColor=[UIColor clearColor];
            btn1.tag=700+i;
            [cell addSubview:btn1];
            
        }
        
    }
    if (indexPath.row==0) {
   
    TSDoubleCell *cell0 = [[[NSBundle mainBundle] loadNibNamed:@"TSDoubleCell" owner:self options:nil] lastObject];
    cell0.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell0.content.text= [NSString stringWithFormat:@"%@",self.goods_name];
    [cell0.img sd_setImageWithURL:[NSURL URLWithString:self.goods_img]];
    cell0.TSBtn.hidden=YES;
    UIView *line=[LJControl viewFrame:CGRectMake(0, 100, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe7e7e7)];
    [cell0 addSubview:line];
       
    return cell0;
    }
    
    return cell;
    
}

//键盘收回
-(void)editBtn
{
    
    [_textView resignFirstResponder];
    [_textView2 resignFirstResponder];
    

    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1)
    {
        
        TopicViewController *topic=[[TopicViewController alloc]init];
        [self.navigationController pushViewController:topic animated:YES];
        
    }

}
-(void) topBtnClick
{

}

-(void)bottomBtnClick
{    //self.model.order_id  订单id
    //cs_id  主题id    [SingleOC share].topicID
    //goods_ids 商品id   self.model.goods_id
    //goods_gsp_ids 商品规格id  self.model.goods_gsp_ids
    //imgs 投诉图片的id
    //content问题描述   _textView.text
    //from_user_content投诉内容   _textView2.text
    NSLog(@"点击提交");
    BOOL login;
    NSArray *userInfoArray = [SYObject hasUserLogedIn:&login];
    NSString *userID = userInfoArray[3];
    NSString *token = userInfoArray[1];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,TSBegin_URL]];
    request_1=[ASIFormDataRequest requestWithURL:url];
    //设置post参数
    NSString *encodeStr=[idArray componentsJoinedByString:@","];
    [request_1 setPostValue:userID forKey:@"user_id"];
    [request_1 setPostValue:token forKey:@"token"];
   [request_1 setPostValue:self.oid forKey:@"order_id"];
    //[request_1 setPostValue:@"588" forKey:@"order_id"];
    [request_1 setPostValue:[SingleOC share].topicID forKey:@"cs_id"];
    [request_1 setPostValue:self.goods_id forKey:@"goods_ids"];
    [request_1 setPostValue:self.goods_gsp_ids forKey:@"goods_gsp_ids"];
    [request_1 setPostValue:_textView.text forKey:@"content"];
    [request_1 setPostValue:_textView2.text forKey:@"from_user_content"];
    [request_1 setPostValue:encodeStr forKey:@"imgs"];
    [request_1 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_1.delegate =self;
    [request_1 setDidFailSelector:@selector(my1_urlRequestFailed:)];
    [request_1 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
    if (![_textView2.text isEqualToString:@""]&![_textView.text isEqualToString:@""]&_lab.text.length>0)
    {
        [request_1 startAsynchronous];
        
    }
    else{
        [OHAlertView showAlertWithTitle:@"提示" message:@"亲，请完善信息哦" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            if(buttonIndex==0){
            }else{
            }
        }];
    }
    
}
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"最终 提交result===========%@", dicBig);
        // 每次请求都清空数据源
        
        if (dicBig && [dicBig[@"code"]integerValue]==100)
        {
            [SYObject failedPrompt:@"投诉成功" complete:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            NSLog(@"终于请求成功");
        }
        
        else
        {
            [SYObject failedPrompt:@"请求出错"];
        }
    }
    
}
-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}

-(void)BtnClick:(UIButton *)btn
{
    UIImagePickerController *imagePick = [[UIImagePickerController alloc]init];
    imagePick.delegate = self;
    imagePick.allowsEditing = YES;
    status=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    [self presentViewController:imagePick animated:YES completion:nil];
   
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString *path = [self saveImage:image withName:@"name.png"];
    UIImage *saveImage = [[UIImage alloc]initWithContentsOfFile:path];
    
    NSInteger tag = [status integerValue]-100;
    UIImageView *p=(UIImageView *)[self.view viewWithTag:tag];
    p.image = saveImage;
    
    
//    [imageDict setValue:saveImage forKey:[NSString stringWithFormat:@"%ld",(long)tag]];
    imageCell = [_tabView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    
    NSData *imageData = UIImageJPEGRepresentation(saveImage,0.5);
    NSString* encodeResult = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
   
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [SYObject startLoading];
        BOOL login;
        NSArray *userInfoArray = [SYObject hasUserLogedIn:&login];
        NSString *userID = userInfoArray[3];
        NSString *token = userInfoArray[1];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,TSPicture_URL]];
        request_2=[ASIFormDataRequest requestWithURL:url];
        //设置post参数
        [request_2 setPostValue:userID forKey:@"user_id"];
        [request_2 setPostValue:token forKey:@"token"];
        [request_2 setPostValue:encodeResult forKey:@"image"];
        
        [request_2 setRequestHeaders:[LJControl requestHeaderDictionary]];
         request_2.delegate =self;
        [request_2 setDidFailSelector:@selector(my1_urlRequestFailed:)];
        [request_2 setDidFinishSelector:@selector(my_urlRequestSucceeded:)];
        [request_2 startAsynchronous];

        NSLog(@"图片开始请求");
        
        
    }];
    
}

-(void)my_urlRequestSucceeded:(ASIFormDataRequest *)request
{
    [SYObject endLoading];
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"提交result===========%@", dicBig);
        // 每次请求都清空数据源
        
        if (dicBig)
        {
            NSLog(@"图片  终于请求成功");
            NSDictionary *dic=[dicBig objectForKey:@"data"];
            NSString *str=[dic objectForKey:@"acc_id"];
            [idArray addObject:str];
            NSLog(@"%@",str);
            
        }
        
        else
        {
            [SYObject failedPrompt:@"请求出错"];
        }
    }
    
    
}
- (NSString *)saveImage:(UIImage *)currentImage withName:(NSString *)name
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    NSString *path = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),name];
    [imageData writeToFile:path atomically:NO];
    return path;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _lab.text=[SingleOC share].topic;


}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request_1 clearDelegatesAndCancel];
    [request_2 clearDelegatesAndCancel];
   
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
