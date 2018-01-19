//
//  EvaluateDetailViewController.m
//  2016seller_01_09_new
//
//  Created by barney on 16/1/11.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

#import "EvaluateDetailViewController.h"
#import "EvaluateOneCell.h"
#import "EvaluateDetailModel.h"

@interface EvaluateDetailViewController ()<UITextViewDelegate>
{
    
    NSMutableArray *dataArray;//tableView数据源
    UITableView *evaluateTabView;//tableView列表
    UITextView *_textView;
    UIView *_replyView;
    UITableViewCell *_cell;
    UILabel *_replyLab;
    UILabel *_replyDidLab;
    UIButton *_evaBtn;
    CGSize size;//评价内容的尺寸
    CGSize size1;//追加评价内容的尺寸
    BOOL replied;//是否有回复内容
    BOOL commit;//提交
    BOOL change;//回复按钮是否隐藏
    BOOL imageHidden;//是否有评价图片
    BOOL evaluate;//是否有评价内容
    BOOL add;//总追加
    BOOL addImage;//追加图片
    BOOL replySelect;//点击回复
    NSString *replyString;
    
}

@end

@implementation EvaluateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    replied = NO;
    commit=NO;
    change=NO;
    imageHidden=NO;
    evaluate=NO;
    add=NO;
    addImage=NO;
    replySelect=NO;
    dataArray=[[NSMutableArray alloc]init];//数据源初始化
    replyString=[[NSString alloc]init];
    self.title=@"评价详情";//标题栏题目
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);//背景颜色
    if (UIDeviceSystem>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;//自动调整属性设置为NO
    }else{
    }
    //评价列表
    evaluateTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenFrame.size.width, ScreenFrame.size.height-64)];
    evaluateTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    evaluateTabView.delegate = self;
    evaluateTabView.dataSource=  self;
    evaluateTabView.showsVerticalScrollIndicator=NO;
    evaluateTabView.showsHorizontalScrollIndicator = NO;
    evaluateTabView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:evaluateTabView];
    [self getNetWorking];//调用网络请求

}
//网络请求
- (void)getNetWorking
{
    [MyObject startLoading];//遮罩
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,EVALUATE_DETAIL_URL];
    //参数字典
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken],
                          @"eva_id":self.evaID
                          };
    //发起请求
    [[MyNetTool managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MyObject endLoading];
        NSDictionary * dicBig=responseObject;//数据字典
        NSLog(@"评价详情///%@",dicBig);
        
        if (dicBig)
        {
            if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"])
            {
                [self.navigationController popToRootViewControllerAnimated:NO];
                //登录过期，提示重新登录
                [MyObject failedPrompt:@"用户登录已过期，请重新登录"];
                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
                
            }
            else
            {
                EvaluateDetailModel *model=[[ EvaluateDetailModel alloc]init];
                //kvc  模型赋值
                [model setValuesForKeysWithDictionary:dicBig];
                if ([model.reply_status intValue]==1)
                {
                    replied=YES;//已评价
                }
                if (model.evaluate_photos.count==0) {
                    
                    imageHidden=YES;//无评价图片
                }
                if (!(model.evaluate_info.length>0)) {
                    
                    evaluate=YES;//无评价内容
                    
                }
                if ([model.addeva_status intValue]==0)
                {
                    add=YES;//无追加内容
                    
                }
                if (model.addeva_photos.count==0) {
                    
                    addImage=YES;//无评价图片
                }
                [dataArray addObject:model];
                [evaluateTabView reloadData];//刷新列表
                
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@",[error localizedDescription]);
         [MyObject endLoading];//结束遮罩
         
     }];
    
    
}
//跳转登陆界面
-(void)doTimer_signout
{
    [LJControl cleanAll];
    AppDelegate *app = [AppDelegate sharedUserDefault];
    app.log_View.hidden = NO;//显示登陆界面
}
#pragma mark - UITableView
//设置tableView的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}
//设置tableView各行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0)
    {
        return 70.f;
    }else if (indexPath.row==1)
    return 2.f;
    else if (indexPath.row==2)
        return 160.f;
    else if (indexPath.row==3)
        return 10.f;
    else if (indexPath.row==4)
        return 10+size.height;
    
    else if (indexPath.row==5)
    {
        if (imageHidden==YES)
        {
            return 0.f;//没有评价图片
        }
        return 80.f;
    
    }
    
    else if (indexPath.row==6)
    {
        if (evaluate==YES)
        {
            return 0.f;//隐藏回复按钮
            
        }
       return 35.f;
    }
    
    else if (indexPath.row==7)
    {
        if (commit==YES)
        {
            return 80.f;//显示提交按钮与输入框
        }
        return 0.f;
        
    }
    
    else if (indexPath.row==8)
        return 15.f;
    
    
    
    else if (indexPath.row==9)//追加评论
    {
        if (add==YES)
        {
            return 0;
        }
       return 10+size1.height;
    
    }
    else if (indexPath.row==10)//追加图片
    {
        if (add==YES||addImage==YES)//无追加图片
        {
            return 0;
        }
        return 80.f;
        
    }
       return 0;
    
}
//设置tableView的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EvaluateDetailModel *model=[dataArray firstObject];
    static NSString *cellName=@"cell";
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellName];
   cell.backgroundColor=UIColorFromRGB(0xf5f5f5);
   cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    if (indexPath.row==0) {
        EvaluateOneCell *cell=[[[NSBundle mainBundle] loadNibNamed:@"EvaluateOneCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        [cell.img sd_setImageWithURL:[NSURL URLWithString:model.main_photo]placeholderImage:[UIImage imageNamed:@"loading"]];
        cell.titleLab.text=model.goods_name;
        cell.price.text=[NSString stringWithFormat:@"￥%@",model.store_price];
        return cell;
        
    }else if (indexPath.row==2)
    {
        
       
        for (int i=0; i<4; i++)
        {
            NSArray *titleAry=@[@"描述相符",@"发货速度",@"服务态度",@"评价"];
            //设置title数组
            UILabel *lab=[LJControl labelFrame:CGRectMake(6, 15+35*i, ScreenFrame.size.width/5, 20) setText:titleAry[i] setTitleFont:15 setbackgroundColor:[UIColor whiteColor] setTextColor:UIColorFromRGB(0x494949) textAlignment:(NSTextAlignmentCenter)];
            cell.backgroundColor=[UIColor whiteColor];
            [cell.contentView addSubview:lab];
            //设置前三行的星级
            if (i<3)
            {
                //每行都设置5颗灰色星星
                for (int j=0; j<5; j++)
                {
                    UIImageView *imgView=[LJControl imageViewFrame:CGRectMake((ScreenFrame.size.width-170)+30*j, 14+35*i, 20, 20) setImage:@"grayStar.png" setbackgroundColor:nil];
                    [cell.contentView addSubview:imgView];
                }
                //根据网络请求下来的条件，设置每行黄色星星的颗数
                if (i==0)//描述相符
                {
                    if ([model.description_evaluate intValue]==6)
                    {
                        model.description_evaluate=@"5";
                        
                    }
                for (int k=0; k<[model.description_evaluate intValue]; k++)
                {
                    UIImageView *imgView=[LJControl imageViewFrame:CGRectMake((ScreenFrame.size.width-170)+30*k, 14, 20, 20) setImage:@"star.png" setbackgroundColor:nil];
                    [cell.contentView addSubview:imgView];

                }
                }
                if (i==1)//发货速度
                {
                    if ([model.ship_evaluate intValue]==6)
                    {
                        model.ship_evaluate=@"5";
                        
                    }
                    for (int k=0; k<[model.ship_evaluate intValue]; k++)
                    {
                        UIImageView *imgView=[LJControl imageViewFrame:CGRectMake((ScreenFrame.size.width-170)+30*k, 14+35*i, 20, 20) setImage:@"star.png" setbackgroundColor:nil];
                        [cell.contentView addSubview:imgView];
                        
                    }
                }
                if (i==2)//服务态度
                {
                    
                    if ([model.service_evaluate intValue]==6)
                    {
                        model.service_evaluate=@"5";
                        
                    }
                    for (int k=0; k<[model.service_evaluate intValue]; k++)
                    {
                        UIImageView *imgView=[LJControl imageViewFrame:CGRectMake((ScreenFrame.size.width-170)+30*k, 14+35*i, 20, 20) setImage:@"star.png" setbackgroundColor:nil];
                        [cell.contentView addSubview:imgView];
                        
                    }
                }
                
            }
            //设置评价 好、中、差
            if (i==3)
            {
                UIImageView *imgView=[LJControl imageViewFrame:CGRectMake(ScreenFrame.size.width-170, 14+35*i, 20, 30) setImage:@"goodEvaluate.png" setbackgroundColor:nil];
                [cell.contentView addSubview:imgView];
                if ([model.evaluate_buyer_val intValue]==0)//中评
                {
                    imgView.image=[UIImage imageNamed:@"midEvaluate"];
                }
                if ([model.evaluate_buyer_val intValue]==-1)//差评
                {
                    imgView.image=[UIImage imageNamed:@"weakEvaluate"];
                }
                
            }
            
        }
    
        //上灰线
        UIView *grayLine1=[LJControl viewFrame:CGRectMake(0, 0, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe3e3e3)];
        [cell.contentView addSubview:grayLine1];
        //下灰线
        UIView *grayLine2=[LJControl viewFrame:CGRectMake(0, 160, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe3e3e3)];
        [cell.contentView addSubview:grayLine2];
        
        return cell;
    
    }else if (indexPath.row==4)
    {
        cell.backgroundColor=[UIColor whiteColor];
        _cell=cell;
        //上灰线
        UIView *grayLine1=[LJControl viewFrame:CGRectMake(0, 0, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe3e3e3)];
        [cell.contentView addSubview:grayLine1];
        
        //评价内容label
        NSString *evaluateStr=[NSString new];
        if (model.evaluate_info.length>0)
        {
           evaluateStr=[NSString stringWithFormat:@"评价内容: %@",model.evaluate_info];
        }else
        {
          evaluateStr=@"暂无评论";
        }
        
        UILabel *evaLab=[LJControl labelFrame:CGRectMake(15, 10, ScreenFrame.size.width-30, 30) setText:evaluateStr setTitleFont:13 setbackgroundColor:[UIColor whiteColor] setTextColor:UIColorFromRGB(0x494949) textAlignment:(NSTextAlignmentLeft)];
       
        size=[evaluateStr sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(ScreenFrame.size.width-30, 10000) lineBreakMode:(NSLineBreakByCharWrapping)];
        evaLab.frame=CGRectMake(15, 10, ScreenFrame.size.width-30, size.height);
        evaLab.numberOfLines=0;
        evaLab.font=[UIFont systemFontOfSize:13];

        [cell.contentView addSubview:evaLab];
        
    }else if (indexPath.row==5)
    {
        //评价图片

        if (model.evaluate_photos.count>0)
        {
            for (int i=0; i<model.evaluate_photos.count; i++)
            {
                UIImageView *img=[LJControl imageViewFrame:CGRectMake(20+(ScreenFrame.size.width/6+10)*i, 10, ScreenFrame.size.width/6, ScreenFrame.size.width/6)setImage:nil setbackgroundColor:nil];

                [cell.contentView addSubview:img];
                [img sd_setImageWithURL:[NSURL URLWithString:model.evaluate_photos[i]]placeholderImage:[UIImage imageNamed:@"loading"]];
                          
            }
        }
        cell.backgroundColor=[UIColor whiteColor];
        cell.clipsToBounds = YES;
        
    }else if (indexPath.row==6)
    {
        if (change==YES)
        {
            
            //回复评论label
            UILabel *replyLab=[LJControl labelFrame:CGRectMake(15, 0, ScreenFrame.size.width-30, 30) setText:[NSString stringWithFormat:@"回复评论: %@",_textView.text] setTitleFont:13 setbackgroundColor:[UIColor whiteColor] setTextColor:UIColorFromRGB(0xff6600) textAlignment:(NSTextAlignmentLeft)];
            _replyLab=replyLab;
            
            if (replyString.length>0)
            {
                _replyLab.text=replyString;
            }
            
            replyString=replyLab.text;
            [cell.contentView addSubview:replyLab];
        }
        
        _replyDidLab=[LJControl labelFrame:CGRectMake(15, 0, ScreenFrame.size.width-30, 30) setText:[NSString stringWithFormat:@"回复评论: %@",model.reply] setTitleFont:13 setbackgroundColor:[UIColor whiteColor] setTextColor:UIColorFromRGB(0xff6600) textAlignment:(NSTextAlignmentLeft)];
        _replyDidLab.hidden=YES;
        [cell.contentView addSubview: _replyDidLab];
        cell.backgroundColor=[UIColor whiteColor];
        cell.clipsToBounds = YES;
        //回复按钮
        UIButton *evaBtn=[LJControl buttonType:(UIButtonTypeCustom) setFrame:CGRectMake((ScreenFrame.size.width-80)/2, 0, 80, 28) setNormalImage:nil setSelectedImage:nil setTitle:@"回复" setTitleFont:15 setbackgroundColor:[UIColor whiteColor]];
        [evaBtn setTitleColor:UIColorFromRGB(0x2196f3) forState:(UIControlStateNormal)];
        _evaBtn=evaBtn;
        //按钮边界
        evaBtn.layer.borderWidth=1;
        evaBtn.layer.borderColor=UIColorFromRGB(0x2196f3).CGColor;
        //按钮圆角
        [evaBtn.layer setMasksToBounds:YES];
        [evaBtn.layer setCornerRadius:4.0];
        //按钮点击事件
        [evaBtn addTarget:self action:@selector(replyBtn) forControlEvents:(UIControlEventTouchUpInside)];
        //按钮点击效果之一闪而过
        [evaBtn addTarget:self action:@selector(buttonBackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
        [evaBtn addTarget:self action:@selector(buttonBackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
        if (change==NO)
        {
            [cell.contentView addSubview:evaBtn];
        }
        
        
        if (replied==YES)//若已回复，则隐藏回复按钮,显示回复label
        {
            evaBtn.hidden=YES;
            _replyDidLab.hidden=NO;
            
            
        }

    }else if (indexPath.row==7)
    {

        cell.backgroundColor=[UIColor whiteColor];
        
        //回复输入框
        UITextView *replyTextView=[[UITextView alloc]initWithFrame:CGRectMake(15, 5, ScreenFrame.size.width-30, 30)];
        replyTextView.backgroundColor=UIColorFromRGB(0Xe4e4e4);
        replyTextView.layer.cornerRadius=5;
        [replyTextView.layer setMasksToBounds:YES];
        replyTextView.layer.borderColor=UIColorFromRGB(0Xe4e4e4).CGColor;
        replyTextView.font=[UIFont systemFontOfSize:13];
        _textView=replyTextView;
        _textView.delegate=self;
        
        UIBarButtonItem *btn2=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(editBtn)];
        UIBarButtonItem *btn1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIToolbar *backView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 30)];
        [backView setBarStyle:UIBarStyleBlack];
        backView.items = @[btn1,btn2];
        _textView.inputAccessoryView = backView;
        [cell.contentView addSubview:replyTextView];
        
        //提交按钮
        UIButton *commitBtn=[LJControl buttonType:(UIButtonTypeCustom) setFrame:CGRectMake((ScreenFrame.size.width-80)/2, 45, 80, 28) setNormalImage:nil setSelectedImage:nil setTitle:@"提交" setTitleFont:15 setbackgroundColor:[UIColor whiteColor]];
        [commitBtn setTitleColor:UIColorFromRGB(0x2196f3) forState:(UIControlStateNormal)];
        //按钮边界
        commitBtn.layer.borderWidth=1;
        commitBtn.layer.borderColor=UIColorFromRGB(0x2196f3).CGColor;
        //按钮圆角
        [commitBtn.layer setMasksToBounds:YES];
        [commitBtn.layer setCornerRadius:4.0];
        //按钮点击事件
        [commitBtn addTarget:self action:@selector(commitBtn) forControlEvents:(UIControlEventTouchUpInside)];
        //按钮点击效果之一闪而过
        [commitBtn addTarget:self action:@selector(buttonBackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
        [commitBtn addTarget:self action:@selector(buttonBackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:commitBtn];
        cell.contentView.clipsToBounds = YES;
        cell.clipsToBounds = YES;
        
    }else if (indexPath.row==9)
    {
       
        cell.backgroundColor=[UIColor whiteColor];
        cell.clipsToBounds = YES;
        //上灰线
        UIView *grayLine1=[LJControl viewFrame:CGRectMake(0, 0, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe3e3e3)];
        [cell.contentView addSubview:grayLine1];
       
        //追加评论内容label
        NSString *evaluateStr=[NSString new];
        if (model.addeva_info.length>0)
        {
            evaluateStr=[NSString stringWithFormat:@"%@ 追加评论: %@",model.addeva_time,model.addeva_info];
        }else
        {
            evaluateStr=@"暂无追加评论";
        }
        UILabel *evaTwoLab=[LJControl labelFrame:CGRectMake(15, 10, ScreenFrame.size.width-30, 40) setText:evaluateStr setTitleFont:13 setbackgroundColor:nil setTextColor:UIColorFromRGB(0x494949) textAlignment:(NSTextAlignmentLeft)];
        
        size1=[evaluateStr sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(ScreenFrame.size.width-30, 10000) lineBreakMode:(NSLineBreakByCharWrapping)];
        evaTwoLab.frame=CGRectMake(15, 10, ScreenFrame.size.width-30, size1.height);
        evaTwoLab.numberOfLines=0;
        evaTwoLab.font=[UIFont systemFontOfSize:13];
        [cell.contentView addSubview:evaTwoLab];
        
    }else if (indexPath.row==10)
    {
        
        cell.backgroundColor=[UIColor whiteColor];
        cell.clipsToBounds = YES;
       
        
        //追加评价图片
        if (model.addeva_photos.count>0)
        {
            for (int i=0; i<model.addeva_photos.count; i++)
            {
                UIImageView *img=[LJControl imageViewFrame:CGRectMake(20+(ScreenFrame.size.width/6+10)*i, 10, ScreenFrame.size.width/6, ScreenFrame.size.width/6)setImage:nil setbackgroundColor:nil];
                
                [cell.contentView addSubview:img];
                [img sd_setImageWithURL:[NSURL URLWithString:model.addeva_photos[i]]placeholderImage:[UIImage imageNamed:@"loading"]];
                
                
            }
        }
        //下灰线
        UIView *grayLine2=[LJControl viewFrame:CGRectMake(0, 80, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe3e3e3)];
        [cell.contentView addSubview:grayLine2];
        
    }
    
     return cell;
}
//键盘收回
-(void)editBtn
{

    [_textView resignFirstResponder];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame=CGRectMake(0,0, ScreenFrame.size.width, ScreenFrame.size.height);
    }];

}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{

    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame=CGRectMake(0,-250, ScreenFrame.size.width, ScreenFrame.size.height);
    }];
    return YES;
}

//回复按钮点击事件
-(void)replyBtn
{
    replySelect=!replySelect;
    if (replySelect==YES)
    {
        commit=YES;//显示提交按钮
        [UIView animateWithDuration:0.5 animations:^{

        [evaluateTabView reloadData];
        NSIndexPath *indexpath=[NSIndexPath indexPathForRow:2 inSection:0];
        [evaluateTabView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }];
        
    }else
    {
        commit=NO;//隐藏提交按钮
        
        [UIView animateWithDuration:0.5 animations:^{
            [evaluateTabView reloadData];
            NSIndexPath *indexpath=[NSIndexPath indexPathForRow:0 inSection:0];

            [evaluateTabView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }];
       
      }
    
    
}
//提交按钮点击事件
-(void)commitBtn
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame=CGRectMake(0,0, ScreenFrame.size.width, ScreenFrame.size.height);
    }];
    [_textView resignFirstResponder];
    if (_textView.text.length>0)//回复输入框
    {
    
    [MyObject startLoading];//遮罩
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,EVALUATE_REPLY_URL];
    //参数字典
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken],
                          @"eva_id":self.evaID,
                          @"reply":_textView.text
                          };
    //发起回复请求
    [[MyNetTool managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MyObject endLoading];
        NSDictionary * dicBig=responseObject;//数据字典
        NSLog(@"评价详情///%@",dicBig);
        
        if (dicBig)
        {
            if ([[dicBig objectForKey:VERIFY] isEqualToString:@"false"])
            {
                [self.navigationController popToRootViewControllerAnimated:NO];
                //登录过期，提示重新登录
                [MyObject failedPrompt:@"用户登录已过期，请重新登录"];
                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer_signout) userInfo:nil repeats:NO];
                
            }
            else
            {
                commit=NO;//隐藏提交按钮
                change=YES;//隐藏回复按钮、显示回复内容label
               [evaluateTabView reloadData];//刷新列表
               
                
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@",[error localizedDescription]);
         [MyObject endLoading];//结束遮罩
         
     }];

    }else
    {
        //若回复输入框内容为空，则弹出提示框
        [OHAlertView showAlertWithTitle:@"提示" message:@"请输入回复内容" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            
        }];
    }
    

    
}
//  button普通状态下的背景色
- (void)buttonBackGroundNormal:(UIButton *)sender
{
    sender.backgroundColor = UIColorFromRGB(0Xffffff);
}
//  button高亮状态下的背景色
- (void)buttonBackGroundHighlighted:(UIButton *)sender
{
    sender.backgroundColor = UIColorFromRGB(0Xe7f4fd);
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
