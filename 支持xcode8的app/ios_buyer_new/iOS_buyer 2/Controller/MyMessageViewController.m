//
//  MyMessageViewController.m
//  My_App
//
//  Created by apple on 14-8-6.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "MyMessageViewController.h"
#import "ASIFormDataRequest.h"
#import "MyMessageModel.h"
#import "FirstViewController.h"
#import "ThreeDotView.h"

#import "MessageTableViewCell.h"


@interface MyMessageViewController ()<UIGestureRecognizerDelegate>
{
}

@property (nonatomic,strong)NSMutableDictionary *seletedDic;// 选中

@property (assign)NSUInteger lastCount;



@end

@implementation MyMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dataArrShangla = [[NSMutableArray alloc]init];
    dataArr = [[NSMutableArray alloc]init];
    
    _seletedDic=[NSMutableDictionary dictionary];
       if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    requestBool = NO;
    secondBtn.hidden=YES;
    thirdBtn.hidden=YES;
    fouthBtn.hidden=YES;
    fifthBtn.hidden=YES;
  
    self.title = @"我的消息";
    self.view.backgroundColor = UIColorFromRGB(0Xf0f0f0);
   
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    shjTableView.backgroundColor = [UIColor clearColor];
    shjTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    shjTableView.delegate = self;
    shjTableView.dataSource= self;
    shjTableView.showsVerticalScrollIndicator = YES;
    shjTableView.showsHorizontalScrollIndicator = NO;
    [shjTableView addHeaderWithTarget:self action:@selector(headerRereshing)];

    [self getData];
    muchBool = NO;
    muchView.hidden = YES;
    [grayMuchImage.layer setMasksToBounds:YES];
    [grayMuchImage.layer setCornerRadius:4];
    
    
#pragma mark - 注册cell 
    
    [shjTableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:@"MessageTableViewCell"];
  
}

-(void)getData{
    NSString *urlStr= [NSString stringWithFormat:@"%@%@",FIRST_URL,MESSAGE_URL];
    
    NSMutableDictionary *par=@{}.mutableCopy;
    [par setObject:[SYObject currentUserID] forKey:@"user_id"];
    [par setObject:[SYObject currentToken] forKey:@"token"];
    [par setObject:@"0" forKey:@"beginCount"];
    [par setObject:@"100" forKey:@"selectCount"];
    
    
    __weak typeof(self)ws =self;
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ws urlRequestSucceeded:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        NSLog(@"\n\n***错误信息:***\n*类名:%@*\n*方法名:%s*\n*行数:%d*\n\n",NSStringFromClass([self class]),__func__,__LINE__);
        [SYObject endLoading];
    }];
}
-(void)headerRereshing
{
    [self  getData];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    self.tdv.hidden = YES;

    MyMessageModel *shjmsm = [dataArr objectAtIndex:indexPath.row];
    
    
    NSString *ret= [_seletedDic valueForKey:[NSString stringWithFormat:@"%zd",indexPath.row]];
    
    NSString *a=[NSString stringWithFormat:@"%zd",!ret.boolValue];
    [_seletedDic setObject:a forKey:[NSString stringWithFormat:@"%zd",indexPath.row]];
    [tableView reloadData];
    
    if ([shjmsm.status isEqualToString:@"1"]) {//已读取就return
        
            return;
    }
    
    
    
 #if 1
    
    NSString *urlStr= [NSString stringWithFormat:@"%@%@",FIRST_URL,@"/app/buyer/buyer_message_receive.htm"];
    
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    
    NSDictionary *par=@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1],@"id":shjmsm.ID};
    __weak typeof(self) ws= self;
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSLog(@"======%@",dic);
        
        NSString *ret=[NSString stringWithFormat:@"%@",responseObject[@"ret"]];
        if ([ret isEqualToString:@"1"]) {
            [SYObject failedPrompt:@"已读取"];
        }else{
            [SYObject failedPrompt:@"消息不存在"];

        }
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            [shjTableView reloadData];
        });
        
#pragma mark ---这里先注释
        [self headerRereshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        [SYObject endLoading];
        
    }];

  #endif
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArr.count != 0) {
        NSLog(@"countcountcount==%zd",dataArr.count);
        return dataArr.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MessageTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MessageTableViewCell"];
    
    if (cell == nil) {
        cell = [[MessageTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:@"MessageTableViewCell"];

               

    }
//    if(dataArr.count != 0){
    
        MyMessageModel *shjmsm = [dataArr objectAtIndex:indexPath.row];
    
    NSLog(@"===%zd---%@=",indexPath.row,shjmsm.msm_content);
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:15.0f]};
    CGRect requiredSize = [shjmsm.msm_content boundingRectWithSize:CGSizeMake(ScreenFrame.size.width-20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    NSLog(@"===%zd   ===%f",indexPath.row,requiredSize.size.height);
    int height;
//    34.95 是2行的内容高度
    if (requiredSize.size.height>34) {
        NSInteger row=indexPath.row;
        NSString *key=[NSString stringWithFormat:@"%zd",row];
        NSString *ret=_seletedDic[key];
        if ([ret isEqualToString:@"1"]) {
            
            NSLog(@"1111");
            height=requiredSize.size.height+15;
        }else{
            height=50;
            
        }
    }else{
        height=25;
        
    }
    
    cell.lblContent.frame = CGRectMake(20, 51, ScreenFrame.size.width-40, height);
    
    
    cell.imgBG.frame =CGRectMake(10, 10, ScreenFrame.size.width-20, cell.frame.size.height-2);
    
    
    
    cell.statuLabel.frame= CGRectMake(ScreenFrame.size.width-85, CGRectGetMaxY(cell.lblContent.frame), 70, 20);
    
    CGRect rect = cell.frame;
    rect.size.height = CGRectGetMaxY(cell.statuLabel.frame)+5;
    cell.frame = rect;
    cell.whiteView.frame=CGRectMake(10, 10, ScreenFrame.size.width-20, cell.frame.size.height);

    

        //来自哪里
        cell.lblFromUser.text = [NSString stringWithFormat:@"%@",shjmsm.msm_fromUser];
        //时间
        cell.lbladdTime.text = [NSString stringWithFormat:@"%@",shjmsm.msm_addTime];
        //内容
        cell.lblContent.text = [NSString stringWithFormat:@"%@",shjmsm.msm_content];
        
    
        if ([shjmsm.status isEqualToString:@"1"]) {
            cell.statuLabel.text=@"已阅读";
            cell.statuLabel.textColor=[UIColor lightGrayColor];
            cell.lblContent.textColor=[UIColor lightGrayColor];
            
            
        }else{
            cell.lblContent.textColor=[UIColor blackColor];
            
            cell.statuLabel.textColor=[UIColor redColor];
            cell.statuLabel.text=@"点击阅读";
        }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath ];
    return cell.frame.size.height+15;
}

#pragma mark - 上拉刷新
-(void)footerRereshing{
    [self getData];
}
-(void)urlRequestSucceeded:(NSDictionary  *)dic{
    promptView.hidden=NO;

        [SYObject endLoading];
    NSDictionary *dicBig =dic;
        NSLog(@"我的消息:%@",dicBig);
        NSArray *array = [dicBig objectForKey:@"msg_list"];
        
        NSLog(@"ocun===%zd",array.count);
        if (dataArr.count!=0)
        {
            [dataArr removeAllObjects];
        }
        if (dicBig) {
            if ([[dicBig objectForKey:@"ret"] isEqualToString:@"false"]) {
            }else{
                for (NSDictionary *dic in array) {
                    MyMessageModel *shjmsm = [[MyMessageModel alloc]init];
                    shjmsm.msm_fromUser = [dic objectForKey:@"fromUser"];
                    shjmsm.msm_addTime = [dic objectForKey:@"addTime"];
                    shjmsm.msm_content = [dic objectForKey:@"content"];
                    NSLog(@"content==%@",shjmsm.msm_content);
                    
                    shjmsm.status =[NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
                    shjmsm.ID =[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];

//                    arr2 = [dic objectForKey:@"msg_list"];
                    [dataArr addObject:shjmsm];
                }
            }
        }
//    }
    if (dataArr.count==0) {
        shjTableView.hidden = YES;
        promptView.hidden=NO;
        
    }else{
        shjTableView.hidden = NO;
        promptView.hidden=YES;
    }
    [shjTableView reloadData];
    [shjTableView headerEndRefreshing];
    
}

@end
