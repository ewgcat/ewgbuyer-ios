//
//  ComplainDetailViewController.m
//  2016seller_01_09_new
//
//  Created by barney on 16/1/11.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

#import "ComplainDetailViewController.h"
#import "ComplainFirstCell.h"
@interface ComplainDetailViewController ()
{
    NSMutableArray *dataArray;//tableView数据源
    UITableView *complainTabView;//tableView列表
    UITextView *_textView;
    
}

@end

@implementation ComplainDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray=[[NSMutableArray alloc]init];//数据源初始化
    self.title=@"投诉详情";//标题栏题目
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);//背景颜色
    if (UIDeviceSystem>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;//自动调整属性设置为NO
    }else{
    }
    //评价列表
    complainTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 74, ScreenFrame.size.width, ScreenFrame.size.height-74)];
    complainTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    complainTabView.delegate = self;
    complainTabView.dataSource=  self;
    complainTabView.showsVerticalScrollIndicator=NO;
    complainTabView.showsHorizontalScrollIndicator = NO;
    complainTabView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:complainTabView];
    [self getNetWorking];//调用网络请求
    

}
//网络请求
- (void)getNetWorking
{
    [MyObject startLoading];//遮罩
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,NEWS_CLASS_URL];
    //参数字典
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken]
                          };
    //发起请求
    [[MyNetTool managerWithVerify]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MyObject endLoading];
        NSDictionary * dicBig=responseObject;//数据字典
        NSLog(@"公告分类///%@",dicBig);
        
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
                //
                //                NSArray *ary=[dicBig objectForKey:@"articleClass"];
                //                for (NSDictionary *dic in ary)
                //                {
                //                    classModel *model=[[classModel alloc]init];
                //                    model.className=[dic objectForKey:@"className"];
                //                    model.ID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                //                    [titleArray addObject:model.className];
                //                    [IDArray addObject:model.ID];
                //                }
                [complainTabView reloadData];//刷新列表
                
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return 9;
}
//设置tableView各行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0)
    {
        return 70.f;
    }else if (indexPath.row==1)
        return 10.f;
    else if (indexPath.row==2)
        return 190.f;
    else if (indexPath.row==3||indexPath.row==7)
        return 15.f;
    else if (indexPath.row==4)
        return 115.f;
    else if (indexPath.row==5)
        return 15.f;
    else if (indexPath.row==6)
        return 240.f;
    else if (indexPath.row==8)
        return 50.f;
    else
        return 0;
    
}
//设置tableView的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellName=@"cell";
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellName];
    cell.backgroundColor=UIColorFromRGB(0xf5f5f5);
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //设置第0行cell
    if (indexPath.row==0) {
        ComplainFirstCell *cell=[[[NSBundle mainBundle] loadNibNamed:@"ComplainFirstCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
        
    }
    //设置第2行cell
    if (indexPath.row==2)
    {
        for (int i=0; i<4; i++)
        {
            //cell的上灰线
            UIView *grayLine=[LJControl viewFrame:CGRectMake(0, 0, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe3e3e3)];
            [cell.contentView addSubview:grayLine];
             //cell下灰线
            UIView *grayLine1=[LJControl viewFrame:CGRectMake(0, 190, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe3e3e3)];
            [cell.contentView addSubview:grayLine1];
            
            NSArray *titleAry=@[@"投诉状态 :",@"投诉主题 :",@"问题描述 :",@"投诉内容 :"];
            //设置title数组
            UILabel *lab=[LJControl labelFrame:CGRectMake(0, 15+35*i, ScreenFrame.size.width/4, 20) setText:titleAry[i] setTitleFont:15 setbackgroundColor:[UIColor whiteColor] setTextColor:UIColorFromRGB(0xa5a5a5) textAlignment:(NSTextAlignmentCenter)];
            cell.backgroundColor=[UIColor whiteColor];
            [cell.contentView addSubview:lab];
            //设置内容数组
            UILabel *lab1=[LJControl labelFrame:CGRectMake(lab.origin.x+lab.size.width, 15+35*i, ScreenFrame.size.width-ScreenFrame.size.width/4-5, 20) setText:@"123456" setTitleFont:15 setbackgroundColor:[UIColor whiteColor] setTextColor:UIColorFromRGB(0xa5a5a5) textAlignment:(NSTextAlignmentLeft)];
            [cell.contentView addSubview:lab1];
            //投诉内容
            if (i==3)
            {
                lab1.height=60.f;
                lab.height=60.f;
                lab1.backgroundColor=[UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
            }if (i==0)//投诉状态
            {
                lab1.text=@"待申诉";
                lab1.textColor=UIColorFromRGB(0xff0000);
            }if (i==1)//投诉主题
            {
                lab1.text=@"主题1";
                lab1.textColor=UIColorFromRGB(0x727272);
            }if (i==2)//问题描述
            {
                lab1.text=@"很有问题";
                lab1.backgroundColor=[UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
                lab1.height=30.f;
                lab.height=30.f;
            }
            
        }

    }
    //设置第4行cell
    if (indexPath.row==4)
    {
        cell.backgroundColor=[UIColor whiteColor];
        //上灰线
        UIView *grayLine1=[LJControl viewFrame:CGRectMake(0, 0, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe3e3e3)];
        [cell.contentView addSubview:grayLine1];
        //下灰线
        UIView *grayLine2=[LJControl viewFrame:CGRectMake(0, 115, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe3e3e3)];
        [cell.contentView addSubview:grayLine2];
        for (int i=0; i<3; i++)
        {
            UIImageView *img=[LJControl imageViewFrame:CGRectMake((ScreenFrame.size.width-(ScreenFrame.size.width/4*3+20*2))/2+(ScreenFrame.size.width/4+20)*i, 10, ScreenFrame.size.width/4, ScreenFrame.size.width/4) setImage:@"complain" setbackgroundColor:[UIColor whiteColor]];
            [cell.contentView addSubview:img];
          
        }
      
    }
    if (indexPath.row==6)
    {
        cell.backgroundColor=[UIColor whiteColor];
        //上灰线
        UIView *grayLine1=[LJControl viewFrame:CGRectMake(0, 0, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe3e3e3)];
        [cell.contentView addSubview:grayLine1];
        //下灰线
        UIView *grayLine2=[LJControl viewFrame:CGRectMake(0, 240, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe3e3e3)];
        [cell.contentView addSubview:grayLine2];
        //对话列表
        UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake(10, 0, ScreenFrame.size.width-20, 150)];
        textView.backgroundColor=[UIColor greenColor];
        textView.font=[UIFont systemFontOfSize:13];
        //textView.text=[talkAllAry componentsJoinedByString:@"\n"];
        textView.text=@"这个商品不合格sdoihf";
        textView.editable=NO;
        _textView=textView;
        [cell addSubview:textView];
        //发布对话框
        UITextView *textView1=[[UITextView alloc]initWithFrame:CGRectMake(10, textView.height+5, ScreenFrame.size.width-20, 40)];
        textView1.backgroundColor=[UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
        textView1.font=[UIFont systemFontOfSize:13];
        textView1.layer.cornerRadius=4;
        [textView1.layer setMasksToBounds:YES];
        textView1.layer.borderColor=UIColorFromRGB(0Xe4e4e4).CGColor;
        [cell addSubview:textView1];
        //发布、仲裁按钮
        for (int i=0; i<2; i++)
        {
            NSArray *btnAry=@[@"发布对话",@"提交仲裁"];
            UIButton *btn=[LJControl buttonType:(UIButtonTypeCustom) setFrame:CGRectMake((ScreenFrame.size.width-ScreenFrame.size.width/4*2-100)/2+(ScreenFrame.size.width/4+100)*i, textView1.origin.y+textView1.height+10, ScreenFrame.size.width/4, 25) setNormalImage:nil setSelectedImage:nil setTitle:btnAry[i] setTitleFont:15 setbackgroundColor:UIColorFromRGB(0x42a6f5)];
            btn.tag=100+i;
            [btn addTarget:self action:@selector(click:) forControlEvents:(UIControlEventTouchUpInside)];
            //按钮点击效果之一闪而过
            [btn addTarget:self action:@selector(buttonBackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
            [btn addTarget:self action:@selector(buttonBackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
            
            
        }
        
        
    }
    if (indexPath.row==8)
    {
        cell.backgroundColor=[UIColor whiteColor];
        //仲裁意见
        UILabel *lab=[LJControl labelFrame:CGRectMake(7,10, ScreenFrame.size.width/5, 30) setText:@"仲裁意见 :" setTitleFont:15 setbackgroundColor:[UIColor whiteColor] setTextColor:UIColorFromRGB(0xa5a5a5) textAlignment:(NSTextAlignmentRight)];
        [cell.contentView addSubview:lab];
        
        //仲裁内容
        UILabel *lab1=[LJControl labelFrame:CGRectMake(lab.width+7+5,10, ScreenFrame.size.width-lab.width-12, 30) setText:@"那有什么问题" setTitleFont:15 setbackgroundColor:[UIColor whiteColor] setTextColor:UIColorFromRGB(0x727272) textAlignment:(NSTextAlignmentLeft)];
        [cell.contentView addSubview:lab1];
        //上灰线
        UIView *grayLine1=[LJControl viewFrame:CGRectMake(0, 0, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe3e3e3)];
        [cell.contentView addSubview:grayLine1];
        //下灰线
        UIView *grayLine2=[LJControl viewFrame:CGRectMake(0, 50, ScreenFrame.size.width, 1) backgroundColor:UIColorFromRGB(0xe3e3e3)];
        [cell.contentView addSubview:grayLine2];
        
        
    }
    
    return cell;
}
-(void)click:(UIButton *)btn
{
    if (btn.tag==100)//发布对话
    {
        
    }else//提交仲裁
    {
    
    
    }



}
//  button普通状态下的背景色
- (void)buttonBackGroundNormal:(UIButton *)sender
{
    sender.backgroundColor = UIColorFromRGB(0X42a6f5);
}
//  button高亮状态下的背景色
- (void)buttonBackGroundHighlighted:(UIButton *)sender
{
    sender.backgroundColor = UIColorFromRGB(0X1976d2);
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
