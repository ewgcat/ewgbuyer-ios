//
//  returnGoodsShipViewController.m
//  My_App
//
//  Created by apple on 15-1-29.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "returnGoodsShipViewController.h"
#import "NilCell.h"
#import "ASIFormDataRequest.h"
#import "LoginViewController.h"

@interface returnGoodsShipViewController (){
    ASIFormDataRequest *request_1;
    ASIFormDataRequest *request3;
}

@end

@implementation returnGoodsShipViewController
-(void)backBtnClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
    [registerNameField resignFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request_1 clearDelegatesAndCancel];
    [request3 clearDelegatesAndCancel];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray = [[NSMutableArray alloc]init];
    
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    if (ScreenFrame.size.height>480) {//说明是5 5s
        MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    }else{
        MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenFrame.origin.y+64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    }
    MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MyTableView.delegate = self;
    MyTableView.dataSource=  self;
    MyTableView.showsVerticalScrollIndicator=NO;
    MyTableView.showsHorizontalScrollIndicator = NO;
    MyTableView.backgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1];
    [self.view addSubview:MyTableView];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 64)];
    view.backgroundColor = MY_COLOR;
    [self.view addSubview:view];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, ScreenFrame.size.width, 44)];
    label.text = @"填写退货物流";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    [view addSubview:label];
    UILabel *labelX = [[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width - 46, 26, 28, 28)];
    labelX.text = @"×";
    labelX.textAlignment = NSTextAlignmentCenter;
    labelX.textColor = [UIColor whiteColor];
    labelX.font = [UIFont boldSystemFontOfSize:30];
    [view addSubview:labelX];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
    button.frame =CGRectMake(ScreenFrame.size.width - 46, 28, 28, 28);
    [button setTitle:@"" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.font  = [UIFont systemFontOfSize:34];
    button.layer.borderWidth = 2;
    button.layer.borderColor = [[UIColor whiteColor] CGColor];
    CALayer *lay3  = button.layer;
    [lay3 setMasksToBounds:YES];
    [lay3 setCornerRadius:14.0];
    [view addSubview:button];
    
    
    
    shipView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    shipView.backgroundColor = [UIColor clearColor];
    shipView.hidden = YES;
    [self.view addSubview:shipView];
    
    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,GOODS_RETURN_SHIP_URL]];
    request_1=[ASIFormDataRequest requestWithURL:url3];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    [request_1 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request_1 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    LoginViewController *log = [LoginViewController sharedUserDefault];
    [request_1 setPostValue:log.return_goods_id forKey:@"goods_id"];
    [request_1 setPostValue:log.return_oid forKey:@"oid"];
    [request_1 setPostValue:log.return_gsp_ids forKey:@"goods_gsp_ids"];
    
    [request_1 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_1.tag = 101;
    request_1.delegate = self;
    [request_1 setDidFailSelector:@selector(my1_urlRequestFailed:)];
    [request_1 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
    [request_1 startAsynchronous];
}
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSLog(@"物流%d",statuscode2);
        [SYObject endLoading];
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
         NSLog(@"退货物流信息%@",dicBig);
        if (dicBig) {
            if (dataArray.count!=0) {
                [dataArray removeAllObjects];
            }
            ClassifyModel *clas = [[ClassifyModel alloc]init];
            clas.goods_groupinfos = [dicBig objectForKey:@"express_list"];
            clas.goods_self_address = [dicBig objectForKey:@"self_address"];
            clas.goods_rid = [dicBig objectForKey:@"rid"];
            clas.goods_return_content = [dicBig objectForKey:@"return_content"];
            [dataArray addObject:clas];
        }
        [MyTableView reloadData];
    }
    else{
        NSLog(@"物流%d",statuscode2);
        [self failedPrompt:@"请求出错"];
    }
    
}
-(void)failedPrompt:(NSString *)prompt{
    [SYObject endLoading];
    [SYObject failedPromptInSuperView:self.view title:prompt];
}
-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}

-(UIView *)loadingView:(CGRect)rect
{
    UIView *loadV=[[UIView alloc]initWithFrame:rect];
    loadV.backgroundColor=[UIColor blackColor];
    loadV.alpha = 0.8;
    UIActivityIndicatorView *activityIndicatorV=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorV.center=CGPointMake(rect.size.width/2, rect.size.height/2-10);
    [activityIndicatorV startAnimating];
    
    [loadV addSubview:activityIndicatorV];
    UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(0, 70, 100, 30)];
    la.text=@"正在加载...";
    la.backgroundColor=[UIColor clearColor];
    la.textAlignment=NSTextAlignmentCenter;
    la.textColor=[UIColor whiteColor];
    la.font=[UIFont boldSystemFontOfSize:15];
    [loadV addSubview:la];
    loadV.layer.cornerRadius=4;
    loadV.layer.masksToBounds=YES;
    return loadV;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//TODO:tabelView方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == MyTableView) {
        return 1;
    }
    if (tableView == ShipTableView) {
        if (dataArray.count!=0) {
            ClassifyModel *class = [dataArray objectAtIndex:0];
            return class.goods_groupinfos.count+1;
        }
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == MyTableView){
        return 500;
    }
    if (tableView == ShipTableView) {
        return 30;
    }
    return 400;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == MyTableView){
        static NSString *myTabelviewCell = @"NilCell";
        NilCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NilCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1];
        }
        if (dataArray.count!=0) {
            ClassifyModel *class = [dataArray objectAtIndex:0];
            LoginViewController *log = [LoginViewController sharedUserDefault];
            UIView *bigView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width , 500)];
            bigView.backgroundColor = [UIColor whiteColor];
           
            [cell addSubview:bigView];
            UITapGestureRecognizer *singleTapGestureRecognizer3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappear)];
            [singleTapGestureRecognizer3 setNumberOfTapsRequired:1];
            [bigView addGestureRecognizer:singleTapGestureRecognizer3];
            
            UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(70, 133, ScreenFrame.size.width-80, 20)];
            if (class.goods_return_content.length>0)
            {
                label5.text = class.goods_return_content;
            }else
            {
                label5.text = @"暂无信息";
            
            }
            
            [bigView addSubview:label5];
            label5.numberOfLines=0;
            label5.textColor = UIColorFromRGB(0x666666);
            label5.font = [UIFont systemFontOfSize:13];
            
            NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
            CGRect requiredCGrect = [label5.text boundingRectWithSize:CGSizeMake(ScreenFrame.size.width-80, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
            
            CGSize requiredSize = requiredCGrect.size;
            label5.frame = CGRectMake(70, 133, ScreenFrame.size.width-80, requiredSize.height);
    
            
            UILabel *label8 = [[UILabel alloc]initWithFrame:CGRectMake(96, 176+requiredSize.height, ScreenFrame.size.width-106, 20)];
            label8.numberOfLines = 0;
            if (class.goods_self_address.length>0) {
                 label8.text = class.goods_self_address;
            }else
            {
                 label8.text = @"暂无信息";
            }
            CGRect requiredCGrect2 = [label8.text boundingRectWithSize:CGSizeMake(ScreenFrame.size.width-106, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
            CGSize requiredSize2 =requiredCGrect2.size;
            label8.frame = CGRectMake(96, 176+requiredSize.height, ScreenFrame.size.width-106, requiredSize2.height);
           
            [bigView addSubview:label8];
            label8.textColor = UIColorFromRGB(0x666666);
            label8.font = [UIFont systemFontOfSize:13];
            
            bigView.frame = CGRectMake(0, 0, ScreenFrame.size.width, 400+requiredSize.height+requiredSize2.height);
            
            UIView *redBack=[LJControl viewFrame:CGRectMake(0, 0, ScreenFrame.size.width, 46) backgroundColor:[UIColor colorWithRed:1.00f green:0.96f blue:0.95f alpha:1.00f]];
            [bigView addSubview:redBack];
            
            UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 6, ScreenFrame.size.width-20, 34)];
            label1.text = @"提交申请后请及时与商家联系,商家同意退货后可填写退货物流信息";
            [bigView addSubview:label1];
            label1.textColor = UIColorFromRGB(0xfe0000);
            label1.numberOfLines = 0;
            label1.font = [UIFont systemFontOfSize:13];
            
            UIImageView *imageLine1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 34+12, ScreenFrame.size.width , 0.5)];
            imageLine1.backgroundColor = [UIColor colorWithRed:1.00f green:0.63f blue:0.62f alpha:1.00f];
            [bigView addSubview:imageLine1];
            
            UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 100, 20)];
            label2.text = @"商品信息:";
            [bigView addSubview:label2];
            label2.textColor = UIColorFromRGB(0x333333);
            label2.font = [UIFont systemFontOfSize:13];
            
            UIImageView *imagePhoto = [[UIImageView alloc]initWithFrame:CGRectMake(70, 54, 50, 50)];
            [imagePhoto sd_setImageWithURL:[NSURL URLWithString:log.return_ImagePhoto] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
            [bigView addSubview:imagePhoto];
            UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(130, 54, ScreenFrame.size.width-140, 40)];
            labelName.text = log.return_Name;
            [bigView addSubview:labelName];
            labelName.numberOfLines = 0;
            labelName.textColor = UIColorFromRGB(0x666666);
            labelName.font = [UIFont systemFontOfSize:13];
           
            
            UIView *label3 = [[UIView alloc]initWithFrame:CGRectMake(0, 110, ScreenFrame.size.width, 0.5)];
            label3.backgroundColor = UIColorFromRGB(0xd7d7d7);
            [bigView addSubview:label3];
            
            UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(10, 130, ScreenFrame.size.width-40, 20)];
            label4.text = @"申请说明:";
            [bigView addSubview:label4];
            label4.textColor = UIColorFromRGB(0x333333);
            label4.font = [UIFont systemFontOfSize:13];
            
            UIView *label6 = [[UIView alloc]initWithFrame:CGRectMake(0, 133+requiredSize.height+20, ScreenFrame.size.width, 0.5)];
            [bigView addSubview:label6];
            label6.backgroundColor = UIColorFromRGB(0xd7d7d7);
            
            UILabel *label7 = [[UILabel alloc]initWithFrame:CGRectMake(10, 133+requiredSize.height+40, 90, 20)];
            label7.text = @"商家收货信息:";
            [bigView addSubview:label7];
            label7.textColor = UIColorFromRGB(0x333333);
            label7.font = [UIFont systemFontOfSize:13];
            
            UIView *label9 = [[UIView alloc]initWithFrame:CGRectMake(0, 177+requiredSize.height+requiredSize2.height+20, ScreenFrame.size.width, 0.5)];
            [bigView addSubview:label9];
            label9.backgroundColor = UIColorFromRGB(0xd7d7d7);
            
            UILabel *label10 = [[UILabel alloc]initWithFrame:CGRectMake(10, 177+requiredSize.height+requiredSize2.height+40-8, ScreenFrame.size.width-40, 38)];
            label10.text = @"物流公司:";
            [bigView addSubview:label10];
            label10.textColor = UIColorFromRGB(0x333333);
            label10.font = [UIFont systemFontOfSize:13];

            UIButton *buttonShip = [UIButton buttonWithType:UIButtonTypeCustom ];
            buttonShip.frame =CGRectMake(70, 177+40+requiredSize.height+requiredSize2.height+5-8, ScreenFrame.size.width-110, 28);
            [buttonShip.layer setMasksToBounds:YES];
            [buttonShip.layer setCornerRadius:4.0f];
            buttonShip.layer.borderWidth=0.5;
            buttonShip.layer.borderColor=UIColorFromRGB(0xe7e7e7).CGColor;
            [buttonShip setTitleColor:UIColorFromRGB(0x666666) forState:(UIControlStateNormal)];
            
            if (ShipTag == 0) {
                if (class.goods_groupinfos.count>0) {
                    [buttonShip setTitle:[NSString stringWithFormat:@"%@",[[class.goods_groupinfos objectAtIndex:0] objectForKey:@"express_name"]] forState:UIControlStateNormal];
                }else
                {
                    [buttonShip setTitle:@"暂无" forState:(UIControlStateNormal)];
                    buttonShip.userInteractionEnabled=NO;
                
                }
               
            }else{
                [buttonShip setTitle:[NSString stringWithFormat:@"%@",[[class.goods_groupinfos objectAtIndex:ShipTag-1] objectForKey:@"express_name"]] forState:UIControlStateNormal];
            }
            [buttonShip addTarget:self action:@selector(btnShipClicked) forControlEvents:UIControlEventTouchUpInside];
            buttonShip.titleLabel.textColor = UIColorFromRGB(0x666666);
            buttonShip.titleLabel.font  = [UIFont systemFontOfSize:15];
            buttonShip.backgroundColor = UIColorFromRGB(0xf0f0f0);
            [bigView addSubview:buttonShip];
            
            UILabel *labelJJ = [[UILabel alloc]initWithFrame:CGRectMake(70, 177+40+requiredSize.height+requiredSize2.height+5-8, ScreenFrame.size.width-80, 28)];
            labelJJ.text = @"▼";
            [bigView addSubview:labelJJ];
            labelJJ.textAlignment = NSTextAlignmentRight;
            labelJJ.textColor = [UIColor whiteColor];
            labelJJ.font = [UIFont systemFontOfSize:11];
            
            UIView *labelLine = [[UIView alloc]initWithFrame:CGRectMake(0, 177+40+requiredSize.height+requiredSize2.height+5-8+15+28, ScreenFrame.size.width, 0.5)];
            [bigView addSubview:labelLine];
            labelLine.backgroundColor = UIColorFromRGB(0xd7d7d7);
            
            UILabel *label11 = [[UILabel alloc]initWithFrame:CGRectMake(10, 177+40+requiredSize.height+requiredSize2.height+12+48, ScreenFrame.size.width-40, 30)];
            label11.text = @"物流单号:";
            [bigView addSubview:label11];
            label11.textColor = UIColorFromRGB(0x333333);
            label11.font = [UIFont systemFontOfSize:13];

            registerNameField = [[UITextField alloc]initWithFrame:CGRectMake(70, 177+40+requiredSize.height+requiredSize2.height+11+48, ScreenFrame.size.width-110, 30)];
            registerNameField.backgroundColor = [UIColor clearColor];
            registerNameField.placeholder = @"请输入快递单号";
            registerNameField.font = [UIFont systemFontOfSize:15];
            registerNameField.textColor = UIColorFromRGB(0x666666);
            registerNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
            registerNameField.clearsOnBeginEditing = YES;
            registerNameField.layer.borderWidth = 1;
            registerNameField.layer.borderColor = [UIColorFromRGB(0xe7e7e7) CGColor];
            [registerNameField.layer setMasksToBounds:YES];
            [registerNameField.layer setCornerRadius:4.0f];
            registerNameField.textAlignment = NSTextAlignmentLeft;
            registerNameField.delegate = self;
            [cell addSubview:registerNameField];
            UIView *finalLine = [[UIView alloc]initWithFrame:CGRectMake(0, 177+40+requiredSize.height+requiredSize2.height+11+48+30+15, ScreenFrame.size.width, 0.5)];
            [bigView addSubview:finalLine];
            finalLine.backgroundColor = UIColorFromRGB(0xd7d7d7);
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
            button.frame =CGRectMake(10, finalLine.bottom+18, ScreenFrame.size.width-20, 40);
            [button.layer setMasksToBounds:YES];
            [button.layer setCornerRadius:4.0f];
            [button setTitle:@"确定" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(backBtnClicked2) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.textColor = [UIColor whiteColor];
            button.titleLabel.font  = [UIFont systemFontOfSize:16];
            button.backgroundColor = UIColorFromRGB(0xf15353);
            [cell addSubview:button];
        }
        return cell;
    }else{
        static NSString *myTabelviewCell = @"NilCell";
        NilCell *cell = [tableView dequeueReusableCellWithIdentifier:myTabelviewCell];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NilCell" owner:self options:nil] lastObject];
            cell.backgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1];
        }
        if (dataArray.count!=0) {
            ClassifyModel *class = [dataArray objectAtIndex:0];
            if (indexPath.row == 0) {
                UILabel *label7 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ShipTableView.frame.size.width, 30)];
                label7.text = @"请选择物流公司:";
                [cell addSubview:label7];
                label7.textAlignment = NSTextAlignmentCenter;
                label7.backgroundColor = UIColorFromRGB(0xf15353);
                label7.textColor = [UIColor whiteColor];
                label7.font = [UIFont boldSystemFontOfSize:16];
            }else{
                UILabel *label7 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ShipTableView.frame.size.width, 30)];
                label7.text = [[class.goods_groupinfos objectAtIndex:indexPath.row-1] objectForKey:@"express_name"];
                [cell addSubview:label7];
                label7.textAlignment = NSTextAlignmentCenter;
                label7.backgroundColor = [UIColor whiteColor];
                label7.textColor = [UIColor blackColor];
                label7.font = [UIFont boldSystemFontOfSize:15];
                
                UIImageView *imalll = [[UIImageView alloc]initWithFrame:CGRectMake(10, 29.5, ShipTableView.frame.size.width-20, 0.5)];
                imalll.backgroundColor = [UIColor lightGrayColor];
                [cell addSubview:imalll];
            }
        }
        return  cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == ShipTableView) {
        if (indexPath.row == 0) {
            
        }else{
            ShipTag = indexPath.row;
            [MyTableView reloadData];
            shipView.hidden = YES;
            for (UIView *subView in shipView.subviews)
            {
                [subView removeFromSuperview];
            }
        }
    }
}
-(void)disappear{
    [registerNameField resignFirstResponder];
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    MyTableView.frame = CGRectMake(MyTableView.frame.origin.x, 64, MyTableView.frame.size.width, MyTableView.frame.size.height);
    [UIView commitAnimations];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [registerNameField resignFirstResponder];
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    MyTableView.frame = CGRectMake(MyTableView.frame.origin.x, 64, MyTableView.frame.size.width, MyTableView.frame.size.height);
    [UIView commitAnimations];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    CGFloat keyboardHeight = 276.0f;
    if (self.view.frame.size.height - keyboardHeight-64 <= textField.frame.origin.y + textField.frame.size.height) {
        [UIView beginAnimations:@"srcollView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.275f];
        MyTableView.frame = CGRectMake(MyTableView.frame.origin.x, -100, MyTableView.frame.size.width, MyTableView.frame.size.height);
        [UIView commitAnimations];
    }
    return YES;
}
-(void)ShipViewdisappear{
    shipView.hidden = YES;

    for (UIView *subView in shipView.subviews)
    {
        [subView removeFromSuperview];
    }
}
-(void)btnShipClicked{
    if (MyTableView.frame.origin.y>0) {
        
    }else{
        [registerNameField resignFirstResponder];
        [UIView beginAnimations:@"srcollView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.275f];
        MyTableView.frame = CGRectMake(MyTableView.frame.origin.x, 64, MyTableView.frame.size.width, MyTableView.frame.size.height);
        [UIView commitAnimations];
    }
    
    shipView.hidden = NO;
    UIImageView *imagegray = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, shipView.frame.size.width, shipView.frame.size.height)];
    imagegray.backgroundColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
    imagegray.alpha = 0.6;
    imagegray.userInteractionEnabled = YES;
    [shipView addSubview:imagegray];
    UITapGestureRecognizer *singleTapGestureRecognizer3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ShipViewdisappear)];
    [singleTapGestureRecognizer3 setNumberOfTapsRequired:1];
    [imagegray addGestureRecognizer:singleTapGestureRecognizer3];
    
    ShipTableView = [[UITableView alloc] initWithFrame:CGRectMake(50, 60, ScreenFrame.size.width-100, 210)];
    ShipTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    ShipTableView.delegate = self;
    ShipTableView.dataSource=  self;
    ShipTableView.showsVerticalScrollIndicator=NO;
    ShipTableView.showsHorizontalScrollIndicator = NO;
    [ShipTableView.layer setMasksToBounds:YES];
    [ShipTableView.layer setCornerRadius:8.0f];
    [shipView addSubview:ShipTableView];
}
-(void)backBtnClicked2{
    if (dataArray.count!=0) {
        NSString *phoneRegex = @"^[A-Za-z0-9]+$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",phoneRegex];
        BOOL isMatch = [phoneTest evaluateWithObject:registerNameField.text];
        
        
        if(registerNameField.text.length == 0) {
            //提示
            [self failedPrompt:@"物流单号不能为空"];
             [registerNameField resignFirstResponder];
            [UIView beginAnimations:@"srcollView" context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.275f];
            MyTableView.frame = CGRectMake(MyTableView.frame.origin.x, 64, MyTableView.frame.size.width, MyTableView.frame.size.height);
            [UIView commitAnimations];
            
        }else if (!isMatch) {
            [self failedPrompt:@"请输入正确的物流单号"];
            [registerNameField resignFirstResponder];
            [UIView beginAnimations:@"srcollView" context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.275f];
            MyTableView.frame = CGRectMake(MyTableView.frame.origin.x, 64, MyTableView.frame.size.width, MyTableView.frame.size.height);
            [UIView commitAnimations];
        }
        else{
            ClassifyModel *class = [dataArray objectAtIndex:0];
            [SYObject startLoadingInSuperview:self.view];
            //发起取消退货请求
            NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,GOODS_RETURN_SHIP_SAVE_URL]];
            request3=[ASIFormDataRequest requestWithURL:url3];
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
            [request3 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
            [request3 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
            [request3 setPostValue:[NSString stringWithFormat:@"%@",class.goods_rid] forKey:@"rid"];
            [request3 setPostValue:registerNameField.text forKey:@"express_code"];
            if(ShipTag == 0){
                [request3 setPostValue:[[class.goods_groupinfos objectAtIndex:0] objectForKey:@"express_id"] forKey:@"express_id"];
            }else{
                [request3 setPostValue:[[class.goods_groupinfos objectAtIndex:ShipTag-1] objectForKey:@"express_id"] forKey:@"express_id"];
            }
            
            [request3 setRequestHeaders:[LJControl requestHeaderDictionary]];
            request3.tag = 101;
            request3.delegate = self;
            [request3 setDidFailSelector:@selector(urlRequestFailed:)];
            [request3 setDidFinishSelector:@selector(urlRequestSucceeded:)];
            [request3 startAsynchronous];
        }
    }
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig：%@",dicBig);
        if([[dicBig objectForKey:@"ret"] isEqualToString:@"true"]){
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self failedPrompt:@"取消失败，请重新尝试"];
        }
        [SYObject endLoading];
    }
    else{
        [self failedPrompt:@"请求出错"];
    }
    
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [self failedPrompt:@"网络请求失败"];
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    laLiuyan.hidden = YES;
    return YES;
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
