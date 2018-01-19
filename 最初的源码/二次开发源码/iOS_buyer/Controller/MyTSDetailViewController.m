//
//  MyTSDetailViewController.m
//  My_App
//
//  Created by barney on 15/12/1.
//  Copyright © 2015年 barney. All rights reserved.
//

#import "MyTSDetailViewController.h"
#import "ASIFormDataRequest.h"
#import "UIImageView+WebCache.h"
#import "MyTSCell.h"
#import "MyTS.h"
#import "SingleOC.h"
#import "MyTSDetail.h"
@interface MyTSDetailViewController ()<UITableViewDataSource,UITabBarDelegate,UITableViewDelegate,ASIHTTPRequestDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITextViewDelegate>

@end

@implementation MyTSDetailViewController
{
    UITableView *_tabView;
    ASIFormDataRequest *request_1;
    ASIFormDataRequest *request_2;
    ASIFormDataRequest *request_3;
    NSMutableArray *dataArray;
    UILabel *_lab;
    UILabel *_lab4;
    UITextView *_textView;
    UITextView *_textView1;
    NSMutableArray *talkAry;
    NSMutableArray *talkAllAry;
    BOOL TSImage;
    BOOL ReplyImage;
    BOOL talk;
    UIButton *commitBtn;
    BOOL complete;
    
    CGRect _size1;
    CGRect _size2;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"投诉详情";
    dataArray= [[NSMutableArray alloc]init];
    talkAry= [[NSMutableArray alloc]init];
    talkAllAry= [[NSMutableArray alloc]init];
    [self createView];
    [self downloadData];
    [self createBackBtn];
    TSImage=NO;
    ReplyImage=NO;
    talk=NO;
    complete=NO;


}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _tabView.hidden=YES;

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
    
    _tabView.separatorColor=[UIColor clearColor];
    
    [self.view addSubview:_tabView];
       
    
    
}
-(void) downloadData
{
    [SYObject startLoading];
    //发起请求
    NSURL *url = [NSURL URLWithString:
                   [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&id=%@",
                    FIRST_URL,
                    MyTSDetail_URL,
                    [[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:3],
                    [[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:1],
                    self.TSID]];
    request_1=[ASIFormDataRequest requestWithURL:url];
    [request_1 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_1.tag = 102;
    request_1.delegate =self;
    [request_1 setDidFailSelector:@selector(my_urlRequestFailed:)];
    [request_1 setDidFinishSelector:@selector(my_urlRequestSucceeded:)];
    [request_1 startAsynchronous];
}

// 请求成功(第一次进入页面的请求)
-(void)my_urlRequestSucceeded:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        _tabView.hidden=NO;
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"我的投诉详情。。。。。===========%@", dicBig);
        // 每次请求都清空数据源
        if (dataArray.count!=0)
        {
            [dataArray removeAllObjects];
        }
        if (dicBig) {
             MyTSDetail *clas = [[MyTSDetail alloc]init];
            NSArray *arr = [dicBig objectForKey:@"datas"];
           
            for(NSDictionary *dic in arr)
            {
                [talkAllAry addObject:[dic objectForKey:@"content"]];
            }
            
                //clas.addTime = [dicBig2 objectForKey:@"addTime"];
                clas.status = [dicBig objectForKey:@"status"];
            if ([clas.status intValue]==2||[clas.status intValue]==3)
            {
                talk=YES;
            
            }
                clas.store_name=[dicBig objectForKey:@"store_name"];
                clas.img=[dicBig objectForKey:@"img"];
                clas.from_user_content=[dicBig objectForKey:@"from_user_content"];
                clas.from_acc1=[dicBig objectForKey:@"from_acc1"];
                clas.from_acc2=[dicBig objectForKey:@"from_acc2"];
                clas.from_acc3=[dicBig objectForKey:@"from_acc3"];
                if (clas.from_acc1) {
                
                TSImage=YES;
                }
                clas.to_acc1=[dicBig objectForKey:@"to_acc1"];
                clas.to_acc2=[dicBig objectForKey:@"to_acc2"];
                clas.to_acc3=[dicBig objectForKey:@"to_acc3"];
                clas.to_user_content=[dicBig objectForKey:@"to_user_content"];
                if (clas.to_acc1) {
                
                ReplyImage=YES;
                }
            
                clas.handle_content=[dicBig objectForKey:@"handle_content"];
                [dataArray addObject:clas];
            
            if (dataArray.count ==0) {
                _tabView.hidden = YES;
                

            }
            // 下载成功刷新数据源
            [_tabView reloadData];
            
        }
        
        else
        {
            [self failedPrompt:@"请求出错"];
        }
    }
}
-(void)my_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    [SYObject failedPrompt:@"请求失败"];
    NSLog(@"%@",request.error);
}
//失败调用
-(void)failedPrompt:(NSString *)prompt
{
    [SYObject endLoading];
    [SYObject failedPrompt:prompt];
}
#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0)
        return 100;
    else if(indexPath.row==1)
        return 60;
    else if (indexPath.row==2)
    {
        //return 100;
         MyTSDetail *cla = [dataArray firstObject];
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
        CGRect size1;
        CGRect size2;
        if (cla.to_user_content.length>0) {
             size1 = [cla.to_user_content boundingRectWithSize:CGSizeMake(ScreenFrame.size.width-116, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        }else
        {
             size1 = [@"暂无" boundingRectWithSize:CGSizeMake(ScreenFrame.size.width-116, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        }
        if (cla.from_user_content.length>0) {
             size2 = [cla.from_user_content boundingRectWithSize:CGSizeMake(ScreenFrame.size.width-116, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        }else
        {
             size2 = [@"暂无" boundingRectWithSize:CGSizeMake(ScreenFrame.size.width-116, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        
        }
        
        return 18+15+size1.size.height+size2.size.height+8;
        
        
    }
    else if (indexPath.row==3)
    {if(TSImage==YES)
            return 125;
        else
            return 0;
    }
    
    else if (indexPath.row==4)
    {
        if(ReplyImage==YES)
        return 125;
        else
        return 0;
    }
    
    else
    {
        if (talk==YES)
        {
            return 350;
        }
        else return 0;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    if (indexPath.row==1) {
       
        if (dataArray.count !=0) {
        MyTSDetail *cla = [dataArray firstObject];
        cell.textLabel.text=@"仲裁意见";
        cell.textLabel.font=[UIFont systemFontOfSize:17];
        cell.textLabel.textColor=UIColorFromRGB(0X7e7e7e);
            
        UILabel *lab=[MyUtil createLabelFrame:CGRectMake(ScreenFrame.size.width-210, 0, 200, 60) text:nil alignment:(NSTextAlignmentRight) fontSize:14];
        _lab=lab;
        lab.numberOfLines=0;
        lab.textAlignment=NSTextAlignmentRight;
       
        lab.textColor=UIColorFromRGB(0X7e7e7e);
        if (cla.handle_content) {
            lab.text=cla.handle_content;
        }else
        {
        lab.text=@"暂无";
        
        }
        
        [cell addSubview:lab];
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 59, ScreenFrame.size.width, 1)];
        line.backgroundColor=UIColorFromRGB(0xe3e3e3);
        [cell addSubview:line];
        UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 1)];
        line1.backgroundColor=UIColorFromRGB(0xe3e3e3);
        [cell addSubview:line1];

            
    }
    }
    if (indexPath.row==2) {
        
        
       
        if (dataArray.count !=0) {
            MyTSDetail *cla = [dataArray firstObject];
        UILabel *lab1=[MyUtil createLabelFrame:CGRectMake(4, 15, 100, 20) text:@"申诉内容 :" alignment:(NSTextAlignmentCenter) fontSize:17];
        lab1.textColor=UIColorFromRGB(0X7e7e7e);
        [cell addSubview:lab1];
        
           
        UILabel *lab2=[MyUtil createLabelFrame:CGRectMake(106, 18, ScreenFrame.size.width-116, 30) text:nil alignment:(NSTextAlignmentLeft) fontSize:13];
        lab2.textColor=UIColorFromRGB(0X7e7e7e);
        lab2.layer.cornerRadius=5;
        [lab2.layer setMasksToBounds:YES];
        if (!cla.to_user_content)
        {
            lab2.text=@"暂无";
        }else
        {
        lab2.text=cla.to_user_content;
        }
            
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
        CGRect size1 = [lab2.text boundingRectWithSize:CGSizeMake(ScreenFrame.size.width-116, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        _size1=size1;
        lab2.frame=CGRectMake(106, 18, ScreenFrame.size.width-116, size1.size.height);
        lab2.numberOfLines=0;
        [cell addSubview:lab2];

        
        
        UILabel *lab3=[MyUtil createLabelFrame:CGRectMake(4,lab2.bottom+5, 100, 20) text:@"投诉内容 :" alignment:(NSTextAlignmentCenter) fontSize:17];
        lab3.textColor=UIColorFromRGB(0X7e7e7e);
        [cell addSubview:lab3];
        
        UILabel *lab4=[MyUtil createLabelFrame:CGRectMake(106, lab3.top+3, ScreenFrame.size.width-116, 30) text:nil alignment:(NSTextAlignmentLeft) fontSize:13];
        lab4.textColor=UIColorFromRGB(0X7e7e7e);
        lab4.layer.cornerRadius=5;
        lab4.numberOfLines=0;
        [lab4.layer setMasksToBounds:YES];
        _lab4=lab4;
            if (!cla.from_user_content)
            {
                lab4.text=@"暂无";
            }else
            {
                 lab4.text=[NSString stringWithFormat:@"%@",cla.from_user_content];
            }
       
            
        CGRect size2 = [lab4.text boundingRectWithSize:CGSizeMake(ScreenFrame.size.width-116, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        _size2=size2;
        lab4.frame=CGRectMake(106, lab3.top+3, ScreenFrame.size.width-116, size2.size.height);
        [cell addSubview:lab4];
        

        }
       
         
    }
    if (indexPath.row==3) {
        
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 125, ScreenFrame.size.width, 1)];
        line.backgroundColor=UIColorFromRGB(0xe3e3e3);
        [cell addSubview:line];
        UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 1)];
        line1.backgroundColor=UIColorFromRGB(0xe3e3e3);
        [cell addSubview:line1];


         if (dataArray.count !=0) {
        UILabel *lab5=[MyUtil createLabelFrame:CGRectMake(4, 25, 100, 30) text:@"投诉图片 :" alignment:(NSTextAlignmentCenter) fontSize:17];
        lab5.textColor=UIColorFromRGB(0X7e7e7e);
        [cell addSubview:lab5];
        
        MyTSDetail *cla = [dataArray firstObject];
        for (int j=0; j<3; j++) {
            UIImageView *picture=[[UIImageView alloc]initWithFrame:CGRectMake(109+j*75, 30, 55, 80)];
            picture.tag=j+600;
            
            [cell addSubview:picture];
            if (picture.tag==600)
            {
                if (cla.from_acc1) {
                    [picture sd_setImageWithURL:[NSURL URLWithString:cla.from_acc1]placeholderImage:[UIImage imageNamed:@"kong_lj.png"]];
                }

                
            }else if (picture.tag==601)
            {
                if (cla.from_acc2) {
                    [picture sd_setImageWithURL:[NSURL URLWithString:cla.from_acc2]placeholderImage:[UIImage imageNamed:@"kong_lj.png"]];
                }
            
            }else if (picture.tag==602)
            {
                if (cla.from_acc3)
                {
                    [picture sd_setImageWithURL:[NSURL URLWithString:cla.from_acc3]placeholderImage:[UIImage imageNamed:@"kong_lj.png"]];
                }

                
            }
            
        }
             
         }
        cell.clipsToBounds = YES;
        
}
    if (indexPath.row==4)
    {
        
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 125, ScreenFrame.size.width, 1)];
        line.backgroundColor=UIColorFromRGB(0xe3e3e3);
        [cell addSubview:line];

         if (dataArray.count !=0) {
        UILabel *lab6=[MyUtil createLabelFrame:CGRectMake(4, 25, 100, 30) text:@"申诉图片 :" alignment:(NSTextAlignmentCenter) fontSize:17];
        lab6.textColor=UIColorFromRGB(0X7e7e7e);
        [cell addSubview:lab6];
        MyTSDetail *cla = [dataArray firstObject];
        for (int j=0; j<3; j++) {
            UIImageView *picture=[[UIImageView alloc]initWithFrame:CGRectMake(109+j*75, 30, 55, 80)];
            picture.tag=j+800;
            
            [cell addSubview:picture];
            
            if (picture.tag==800) {
                
                if (cla.to_acc1) {
                    [picture sd_setImageWithURL:[NSURL URLWithString:cla.to_acc1]placeholderImage:[UIImage imageNamed:@"kong_lj.png"]];
                }
            }else if (picture.tag==801)
            {
                if (cla.to_acc2) {
                    [picture sd_setImageWithURL:[NSURL URLWithString:cla.to_acc2]placeholderImage:[UIImage imageNamed:@"kong_lj.png"]];
                }
                
            }else if (picture.tag==802)
            {
                if (cla.to_acc3) {
                    [picture sd_setImageWithURL:[NSURL URLWithString:cla.to_acc3]placeholderImage:[UIImage imageNamed:@"kong_lj.png"]];
                }
            }
          
        }
         }
        cell.clipsToBounds = YES;
    }
    
    if (indexPath.row==5) {
        
         MyTSDetail *cla = [dataArray firstObject];
        UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 1)];
        line1.backgroundColor=UIColorFromRGB(0xe3e3e3);
        [cell addSubview:line1];

        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 349, ScreenFrame.size.width, 1)];
        line.backgroundColor=UIColorFromRGB(0xe3e3e3);
        [cell addSubview:line];

            if (dataArray.count !=0) {
            UILabel *lab5=[MyUtil createLabelFrame:CGRectMake(4, 25, 100, 30) text:@"对话记录 :" alignment:(NSTextAlignmentCenter) fontSize:17];
            lab5.textColor=UIColorFromRGB(0X7e7e7e);
            [cell addSubview:lab5];
              UITextView *textView1=[[UITextView alloc]initWithFrame:CGRectMake(106, 25, ScreenFrame.size.width-120, 150)];
            //textView1.backgroundColor=UIColorFromRGB(0Xe4e4e4);
            textView1.layer.cornerRadius=5;
            [textView1.layer setMasksToBounds:YES];
            textView1.layer.borderColor=UIColorFromRGB(0Xe4e4e4).CGColor;
            textView1.layer.borderWidth=1;
            textView1.font=[UIFont systemFontOfSize:13];
                if (talkAllAry.count>0) {
                   textView1.text=[talkAllAry componentsJoinedByString:@"\n"];
                }else
                {
                textView1.text=@"暂无对话";
                
                }
           
            textView1.editable=NO;
            _textView1=textView1;
            textView1.textColor=UIColorFromRGB(0X7e7e7e);
            [cell addSubview:textView1];
            
            
            UILabel *lab7=[MyUtil createLabelFrame:CGRectMake(4, 185, 100, 30) text:@"发布对话 :" alignment:(NSTextAlignmentCenter) fontSize:17];
            lab7.textColor=UIColorFromRGB(0X7e7e7e);
            [cell addSubview:lab7];
            
            UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake(106, 185, ScreenFrame.size.width-120, 80)];
            textView.backgroundColor=UIColorFromRGB(0Xe4e4e4);
            textView.layer.cornerRadius=5;
            [textView.layer setMasksToBounds:YES];
            textView.layer.borderColor=UIColorFromRGB(0Xe4e4e4).CGColor;
            textView.font=[UIFont systemFontOfSize:13];
            textView.delegate=self;
            
            _textView=textView;
            
            WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"取消" leftTarget:self leftAction:@selector(editBtn) rightTitle:@"完成" rightTarget:self rightAction:@selector(editBtn)];
            [_textView setInputAccessoryView:inputView];
            
            [cell addSubview:textView];
            NSArray *ary=@[@"发布对话",@"刷新对话",@"提交仲裁"];
            for (int i=0; i<3; i++) {

                 UIButton *btn=[MyUtil createBtnFrame:CGRectMake((ScreenFrame.size.width-ScreenFrame.size.width/5*3-70)/2+(ScreenFrame.size.width/5+35)*i, 295, ScreenFrame.size.width/5, 30) title:ary[i] image:nil highlighImage:nil  selectImage:nil target:self action:@selector(FinalClick:)];

                [btn.layer setMasksToBounds:YES];
                [btn.layer setCornerRadius:4.0];
                btn.backgroundColor=UIColorFromRGB(0xf15353);
                [btn addTarget:self action:@selector(buttonBackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
                [btn addTarget:self action:@selector(buttonBackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                btn.tag=i+700;
                btn.titleLabel.font=[UIFont systemFontOfSize:14];
                [cell addSubview:btn];
                if (i==2) {
                    
                    commitBtn=btn;
                     if ([cla.status intValue]==3)
                    {
                        btn.backgroundColor=[UIColor grayColor];
                        btn.userInteractionEnabled=NO;
                        
                        
                    }
                    if (complete==YES) {
                        
                        btn.backgroundColor=[UIColor grayColor];
                        btn.userInteractionEnabled=NO;
                    }else
                    {
                    
                    }
                    
                }
  
            }
         
        }
        cell.clipsToBounds = YES;
    }
    if (indexPath.row==0) {
        
        static NSString *Cell = @"MyTSCell";
        MyTSCell *cell0 = [tableView dequeueReusableCellWithIdentifier:Cell];
        
        if(cell0 == nil){
            cell0 = [[[NSBundle mainBundle] loadNibNamed:@"MyTSCell" owner:self options:nil] lastObject];
            cell0.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (dataArray.count !=0) {
            MyTSDetail *cla = [dataArray firstObject];
            NSLog(@"投诉===========%@", cla);
            // 下单时间
            
            cell0.name.text = cla.store_name;
            [cell0.img sd_setImageWithURL:[NSURL URLWithString:cla.img]];
          
            if ([cla.status intValue]==1)
            {
                cell0.status.text=@"待申诉";
            }else if ([cla.status intValue]==0)
            {
                cell0.status.text=@"新投诉";
                
            }else if ([cla.status intValue]==2)
            {
                cell0.status.text=@"沟通中";
               
                
            }else if ([cla.status intValue]==3)
            {
                cell0.status.text=@"待仲裁";
                
                
            }else if ([cla.status intValue]==4)
            {
                cell0.status.text=@"投诉结束";
                
            }
            cell0.status.textColor = MY_COLOR;
            cell0.time.hidden=YES;
            cell0.bottomLine.hidden=YES;
            //cell0.time.text = [NSString stringWithFormat:@"%@",cla.addTime];
            
        }        return cell0;
        
    }
    
    return cell;
    
}
//键盘收回
-(void)editBtn
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame=CGRectMake(0,64                                                                                                                                                                                                                                                       , ScreenFrame.size.width, ScreenFrame.size.height);
    }];
    [_textView resignFirstResponder];
   
    
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
     NSIndexPath *indexpath=[NSIndexPath indexPathForRow:2 inSection:0];
    [_tabView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [UIView animateWithDuration:0.5 animations:^{
            self.view.frame=CGRectMake(0,-160, ScreenFrame.size.width, ScreenFrame.size.height);
        }];
    return YES;
}

//  button普通状态下的背景色
- (void)buttonBackGroundNormal:(UIButton *)sender
{
    sender.backgroundColor = UIColorFromRGB(0Xf15353);
}
//  button高亮状态下的背景色
- (void)buttonBackGroundHighlighted:(UIButton *)sender
{
    sender.backgroundColor = UIColorFromRGB(0Xd15353);
}

-(void)FinalClick:(UIButton *)btn
{
    if (btn.tag==700) {
        if (_textView.text.length>0) {
            [self editBtn];
            [self downloadData11];

        }else
        {
            [self editBtn];
            [OHAlertView showAlertWithTitle:@"提示" message:@"亲，您尚未填写发布信息哦" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            }];
        
        }
        
        
    }else if(btn.tag==702)
    {
        [self downloadData12];
    
    }else if(btn.tag==701)
    {  talkAllAry= [[NSMutableArray alloc]init];
       [self downloadData];
        
    }



}

-(void) downloadData11
{
    [SYObject startLoading];
    //发起请求
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,MyTSTalk_URL];
    NSDictionary *par = @{
                          @"user_id":[SYObject currentUserID],
                          @"token":[SYObject currentToken],
                          @"id":[NSString stringWithFormat:@"%@",self.TSID],
                          @"talk_content":[NSString stringWithFormat:@"%@",_textView.text]
                          
                          };
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
           [SYObject endLoading];
            NSDictionary *dicBig =responseObject;
            NSLog(@"发布对话。。。。。===========%@", dicBig);
            if (dicBig) {
                NSArray *ary=[dicBig objectForKey:@"datas"];
                for (NSDictionary *dic in ary)
                {
                    NSString *content=[dic objectForKey:@"content"];
                    [talkAry addObject:content];
                }
                [OHAlertView showAlertWithTitle:@"提示" message:@"您已发布成功,请刷新对话" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                }];
                
                _textView1.text=[talkAry componentsJoinedByString:@"\n"];
                [_tabView reloadData];
                
            }
            
            else
            {
                [self failedPrompt:@"请求出错"];
            }
        

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:[error localizedDescription]];
        [SYObject endLoading];
       
    }];

    
}
-(void)myTS_urlRequestSucceeded:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"发布对话。。。。。===========%@", dicBig);
            if (dicBig) {
                NSArray *ary=[dicBig objectForKey:@"datas"];
                for (NSDictionary *dic in ary)
                {
                    NSString *content=[dic objectForKey:@"content"];
                    [talkAry addObject:content];
                }
                [OHAlertView showAlertWithTitle:@"提示" message:@"您已发布成功,请刷新对话" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                }];

                _textView1.text=[talkAry componentsJoinedByString:@"\n"];
                [_tabView reloadData];
                
        }
        
        else
        {
            [self failedPrompt:@"请求出错"];
        }
    }
}

-(void) downloadData12
{
    [SYObject startLoading];
    //发起请求
    NSURL *url = [NSURL URLWithString:
                   [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&id=%@",
                    FIRST_URL,
                    MyTSCheck_URL,
                    [[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:3],
                    [[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"information.txt"]] objectAtIndex:1],
                    self.TSID]];
    request_3=[ASIFormDataRequest requestWithURL:url];
    [request_3 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_3.delegate =self;
    [request_3 setDidFailSelector:@selector(my_urlRequestFailed:)];
    [request_3 setDidFinishSelector:@selector(myTSCheck_urlRequestSucceeded:)];
    [request_3 startAsynchronous];
}

-(void)myTSCheck_urlRequestSucceeded:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig2 =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"提交仲裁。。。。。===========%@", dicBig2);
        [OHAlertView showAlertWithTitle:@"提示" message:@"提交成功" cancelButton:nil otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
        }];
        
        complete=YES;
        [_tabView reloadData];
        
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request_1 clearDelegatesAndCancel];
    [request_2 clearDelegatesAndCancel];
    [request_3 clearDelegatesAndCancel];
    
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
