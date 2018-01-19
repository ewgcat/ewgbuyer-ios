//
//  RelationshipViewController.m
//  My_App
//
//  Created by 邱炯辉 on 16/5/26.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "RelationshipViewController.h"

@interface RelationshipViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    NSArray *_titleArr1;
    NSArray *_titleArr2;
    NSMutableArray *_detailArr1;
    NSMutableArray *_detailArr2;
    NSMutableDictionary *_headDataDic;
    
    NSString *_invitation_code;
}
@property(nonatomic,weak)UISearchBar *searchBar;

@property(nonatomic,strong)NSMutableDictionary *headDataDic;

@property(nonatomic,strong)UITableView *tableView;
@end

@implementation RelationshipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    _titleArr1=@[@"姓名",@"微信号",@"QQ号码",@"手机号码",];
    _titleArr2=@[@"建立时间",@"建立方式"];
    _detailArr1 =[NSMutableArray array];
    _detailArr2=[NSMutableArray array];
    _headDataDic=[NSMutableDictionary dictionary];
    
    [self getData];
}
-(UIView *)createHeadView{
    UIView *headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 200)];
    headview.backgroundColor=[UIColor lightTextColor];
    UIImageView *imageview=[[UIImageView alloc]init];
    imageview.frame =CGRectMake(0, 0, 100, 100);
    imageview.center = CGPointMake(ScreenFrame.size.width/2, 80);
    NSString *str=_headDataDic[@"photo_url"];
    [imageview sd_setImageWithURL:[NSURL URLWithString:str]];
    imageview.layer.cornerRadius= 100/2;
    imageview.layer.masksToBounds =YES;
    [headview addSubview:imageview];
    
    
    UILabel *label=[[UILabel alloc]init];
    label.frame =CGRectMake(0, 0, 100, 30);
    label.center = CGPointMake(ScreenFrame.size.width/2, CGRectGetMaxY(imageview.frame)+ 10);
    label.textAlignment= NSTextAlignmentCenter;
    label.text=_headDataDic[@"nick_name"];
    [headview addSubview:label];
    
    return headview;
    
}

-(void)getData{
    
    [SYObject startLoading];
    
    ASIFormDataRequest *request102;
    
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/app/buyer/buyer_parent_one.htm",FIRST_URL]];
    request102=[ASIFormDataRequest requestWithURL:url];
    [request102 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request102 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
//    [request102 setPostValue:@"20" forKey:@"begincount"];
//    
//    [request102 setPostValue:@"20" forKey:@"selectcount"];
    
    [request102 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request102.tag = 102;
    [request102 setDelegate:self];
    [request102 setDidFailSelector:@selector(urlRequestFailed:)];
    [request102 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [request102 startAsynchronous];
    
}

#pragma mark - 网络
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    NSLog(@"statuscode=%d",statuscode2);
    if (statuscode2 == 200) {
        
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig:%@",dicBig);
        if (dicBig) {
            
            if ([dicBig[@"ret"] isEqualToString:@"false"]) {//没有上级
                [self createNOsuperiorUI];
            }else if ([dicBig[@"ret"] isEqualToString:@"true"]){//有上级
                
                if (dicBig[@"user_name"]) {
                    [_detailArr1 addObject:dicBig[@"user_name"]];

                }else{
                    [_detailArr1 addObject:@""];

                }
                
                if (dicBig[@"wechat"]) {
                    [_detailArr1 addObject:dicBig[@"wechat"]];

                }else{
                    [_detailArr1 addObject:@""];
                    
                }
                if (dicBig[@"qq"]) {
                    [_detailArr1 addObject:dicBig[@"qq"]];

                }else{
                    [_detailArr1 addObject:@""];
                    
                }
                if (dicBig[@"mobile"]) {
                    [_detailArr1 addObject:dicBig[@"mobile"]];

                }else{
                    [_detailArr1 addObject:@""];
                    
                }
                
                if (dicBig[@"vip_link_time"]) {
                    [_detailArr2 addObject:dicBig[@"vip_link_time"]];

                }else{
                    [_detailArr2 addObject:@""];
                    
                }
                if (dicBig[@"vip_link_type_name"]) {
                    [_detailArr2 addObject:dicBig[@"vip_link_type_name"]];
                    
                }else{
                    [_detailArr2 addObject:@""];
                    
                }

                if (dicBig[@"photo_url"]) {
                    [_headDataDic setObject:dicBig[@"photo_url"] forKey:@"photo_url"];

                }else{
                    [_headDataDic setObject:@"" forKey:@"photo_url"];
                    
                }
                if (dicBig[@"nick_name"]) {
                    [_headDataDic setObject:dicBig[@"nick_name"] forKey:@"nick_name"];

                }else{
                    [_headDataDic setObject:@"" forKey:@"nick_name"];
                    
                }

                self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height-64) style:UITableViewStylePlain];
                [self.view addSubview:_tableView];
                self.tableView.delegate=self;
                self.tableView.dataSource=self;
                self.tableView.tableHeaderView=[self createHeadView];
                self.tableView.tableFooterView=[[UIView alloc]init];
            }
        }
    }
    [SYObject endLoading];
}

-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
#pragma mark 没有上级的UI界面
-(void)createNOsuperiorUI{
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, self.view.frame.size.width-20*2, 40)];
    label.text=@"您尚未绑定上级，请输入上级的邀请码进行搜索绑定";
    label.font=[UIFont systemFontOfSize:14];
    label.numberOfLines =2;
//    [label sizeToFit];
    [self.view addSubview:label];
    
    UISearchBar *searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame)+5, self.view.frame.size.width, 44)];
//    searchBar.placeholder=@"请输入要搜索的上级邀请码";
    searchBar.delegate=self;
    self.searchBar =searchBar;
    [self.view addSubview:searchBar];
    
    
    
}

#pragma mark -搜素栏代理
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    searchBar.text=@"";
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    NSLog(@"%@",searchBar.text);
    if (searchBar.text==nil || [searchBar.text isEqualToString:@""]) {
        return;
    }
    [self getData2:searchBar.text];
    _invitation_code= searchBar.text;
    searchBar.text=@"";
}
#pragma mark 搜索框进行搜素
-(void)getData2:(NSString*)value{
    
    [SYObject startLoading];
    
    ASIFormDataRequest *request;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,@"/app/buyer/vip_my_parent_info.htm"]];

    request=[ASIFormDataRequest requestWithURL:url];
    
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];

    [request setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    [request setPostValue:value forKey:@"invitation_code"];
    [request setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];

    [request setRequestHeaders:[LJControl requestHeaderDictionary]];
    request.tag = 102;
    [request setDelegate:self];
    [request setDidFailSelector:@selector(urlRequestFailed2:)];
    [request setDidFinishSelector:@selector(urlRequestSucceeded2:)];
    [request startAsynchronous];
    
}

#pragma mark - 网络2
-(void)urlRequestSucceeded2:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    NSLog(@"statuscode=%d",statuscode2);
    if (statuscode2 == 200) {
        
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig:%@",dicBig);
        NSLog(@"msg:%@",dicBig[@"msg"]);
        if ([dicBig[@"ret"] isEqualToString:@"1"]) {
            [_headDataDic setObject:dicBig[@"nick_name"] forKey:@"nick_name"];
            [_headDataDic setObject:dicBig[@"photo_url"] forKey:@"photo_url"];
            UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_searchBar.frame)+10, ScreenFrame.size.width, 250)];
            [v addSubview:[self createHeadView]];
           [self.view addSubview:v];
            
            UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
            [but setTitle:@"立即绑定" forState:UIControlStateNormal];
            [but addTarget:self action:@selector(bind) forControlEvents:UIControlEventTouchUpInside];
            but.frame=CGRectMake(20, CGRectGetMaxY(v.frame)+5,ScreenFrame.size.width -20 *2, 40);
            but.backgroundColor=[UIColor redColor];
            [self.view addSubview:but];
        }else if ([dicBig[@"ret"] isEqualToString:@"0"]){
            [SYObject failedPrompt:@"邀请码对应用户不存在"];
            
        }else if ([dicBig[@"ret"] isEqualToString:@"-2"]){
            [SYObject failedPrompt:@"一个邀请码对应多个用户"];

            
        }else if ([dicBig[@"ret"] isEqualToString:@"-4"]){
            [SYObject failedPrompt:@" 系统异常"];

        }

    }
    [SYObject endLoading];
}

-(void)urlRequestFailed2:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}

#pragma mark 立即绑定
#if 0
-(void)bind{
    NSString *str=[NSString stringWithFormat:@"%@%@",FIRST_URL,@"/app/buyer/bindParent.htm"];
    
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    NSDictionary *dic=@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1],@"invitation_code":_invitation_code};
    
    __weak typeof(self) ws =self;
    [[Requester managerWithHeader]POST:str parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dict = responseObject;
            NSLog(@"dict=%@",dict);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        [SYObject endLoading];
        [SYObject failedPrompt:@"请求失败"];
    }];

}
#endif
-(void)bind{
    
    [SYObject startLoading];
    
    ASIFormDataRequest *request;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,@"/app/buyer/bindParent.htm"]];
    
    request=[ASIFormDataRequest requestWithURL:url];
    
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    
    [request setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    [request setPostValue:_invitation_code forKey:@"invitation_code"];
    [request setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    
    [request setRequestHeaders:[LJControl requestHeaderDictionary]];
    request.tag = 102;
    [request setDelegate:self];
    [request setDidFailSelector:@selector(urlRequestFailed3:)];
    [request setDidFinishSelector:@selector(urlRequestSucceeded3:)];
    [request startAsynchronous];
    
}

#pragma mark - 网络3
-(void)urlRequestSucceeded3:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    NSLog(@"statuscode=%d",statuscode2);
    if (statuscode2 == 200) {
        
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dicBig:%@",dicBig);
        NSLog(@"msg:%@",dicBig[@"msg"]);
            if ([dicBig[@"ret"] isEqualToString:@"1"]) {
        
                for (UIView *obj in self.view.subviews) {
                    NSLog(@"obj=%@",obj);
                    [obj removeFromSuperview];
                    
                }
                [self getData];
            }
        
    }
    [SYObject endLoading];
}

-(void)urlRequestFailed3:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return _titleArr1.count;
    }else{
        return _titleArr2.count;

    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID=@"cell123";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell ==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    // Configure the cell...
    
    if (indexPath.section==0) {
        cell.textLabel.text=_titleArr1[indexPath.row];
        if (_detailArr1[indexPath.row]) {
            cell.detailTextLabel.text=_detailArr1[indexPath.row];

        }

    }else{
        cell.textLabel.text=_titleArr2[indexPath.row];
        if (_detailArr2.count>0) {
            if (_detailArr2[indexPath.row]) {//如果数组里面有值
                cell.detailTextLabel.text=_detailArr2[indexPath.row];

            }else{
                cell.detailTextLabel.text=@"";

            }
        }else{
        
            cell.detailTextLabel.text=@"";

        }

    }
    
    return cell;
}
//header
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 35)];
    headview.backgroundColor=[UIColor whiteColor];
    
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0,0, ScreenFrame.size.width, 0.5)];
    line.backgroundColor=LINE_COLOR;
    [headview addSubview:line];
    
    UILabel *label=[[UILabel alloc]init];
    label.frame =CGRectMake(5, 10, 200, 20);
    label.font =[UIFont systemFontOfSize:17];
    label.text=@[@"上级联系方式",@"关系情况"][section];
   label.font =[UIFont systemFontOfSize:13];

    [headview addSubview:label];
    
    
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0, 34, ScreenFrame.size.width, 0.5)];
    line2.backgroundColor=LINE_COLOR;
    [headview addSubview:line2];
    return headview;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
@end
