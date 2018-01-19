//
//  LuckyMoneyTableViewController.m
//  LuckyMoney
//
//  Created by 邱炯辉 on 16/7/16.
//  Copyright © 2016年 mlh. All rights reserved.
//

#import "LuckyMoneyTableViewController.h"
#import "LuckMoneyTableViewCell.h"
#import "LuckyMoney2TableViewController.h"
@interface MyTextcell : UITableViewCell
@property(nonatomic,strong)UIImageView * headImageView;
@property(nonatomic,strong)NSString * myText;

@property(nonatomic,strong)UIImageView * bgImageview;
@property(nonatomic,strong)UILabel *myTextLabel;
@end

@implementation MyTextcell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor groupTableViewBackgroundColor];

        self.headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-10-40, 10, 40, 40)];
//        _headImageView.backgroundColor=[UIColor redColor];
        [self.contentView addSubview:_headImageView];
        
        
        self.bgImageview=[[UIImageView alloc]init];
        
        [self.contentView addSubview:_bgImageview];
        
        _myTextLabel=[[UILabel alloc]init];
        _myTextLabel.numberOfLines=0;
//        _myTextLabel.backgroundColor=[UIColor blueColor];
        [self.bgImageview addSubview:_myTextLabel];

        
    }
    return self;
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    NSLog(@"_myText_myText==%@",_myText);
    if (_myText.length<=0) {
        return;
    }
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:17]};
    
    CGSize  maxSize=CGSizeMake(ScreenFrame.size.width-50*2, MAXFLOAT);
   CGRect rect= [_myText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    if (rect.size.width<=30) {
        rect.size.width=30;
    }
    int  width=rect.size.width+30;//背景的宽
    int  height=rect.size.height+30;//背景的高

    _bgImageview.frame=CGRectMake(CGRectGetMinX(_headImageView.frame)-10-width, 10, width, height);
//    _bgImageview.backgroundColor=[UIColor orangeColor];
    _bgImageview.image=[[UIImage imageNamed:@"SenderTextNodeBkg_61x54_@2x"]stretchableImageWithLeftCapWidth:10 topCapHeight:30];
    _myTextLabel.text=_myText;
    _myTextLabel.frame=CGRectMake(15, 10, rect.size.width, rect.size.height);
    

}

@end

@interface LuckyMoneyTableViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>{
     UIView *weakBackView;
    UIImageView *weakImageView;
    UIButton *openBut;
   int  _page;//页数
    
    NSString *redpackId;//红包ID
    NSInteger selectedRow;
    
    NSMutableArray *_dataArr;
    
    BOOL isFirstCome;//是否是第一次进来这个页面
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *bottomView;
@end

@implementation LuckyMoneyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr =[NSMutableArray array];
    isFirstCome=YES;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _page=1;
    self.automaticallyAdjustsScrollViewInsets=NO;
//    self.title=@"我的红包";
    
    
    
#pragma mark ----
#if 1
    
    
    self.navigationController.navigationBarHidden=YES;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 64)];
    view.backgroundColor = RGB_COLOR(35 ,48 ,26);;
    [self.view addSubview:view];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
    button.frame =CGRectMake(1, 28, 60, 28+2);
    [button setImage:[UIImage imageNamed:@"barbuttonicon_back_15x30_@3x"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"barbuttonicon_back_15x30_@3x"] forState:UIControlStateHighlighted];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitle:@"返回" forState:UIControlStateHighlighted];

    //   [button setImage:[UIImage imageNamed:@"back_lj"] forState:UIControlStateNormal];
    //    [button setTitle:@"返回" forState:UIControlStateNormal];
    //    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    button.imageEdgeInsets=UIEdgeInsetsMake(5, 15, 5, 35);
    //    button.titleLabel.font=[UIFont systemFontOfSize:14];
    
    
    [button addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font  = [UIFont systemFontOfSize:15];
    
    UIImageView *rightImageview=[[UIImageView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-30-18, 7+20, 30, 30)];
    rightImageview.image=[UIImage imageNamed:@"barbuttonicon_InfoSingle_30x30_@3x"];
    
    [view addSubview:rightImageview];

    [view addSubview:button];
    [self.view addSubview:view];
    //
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, ScreenFrame.size.width, 44)];
    label.text = @"e网购红包";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    

#endif
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-49-64)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LuckMoneyTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LuckMoneyTableViewCell"];
    
    [self.tableView registerClass:[MyTextcell class] forCellReuseIdentifier:@"MyTextcell"];
    
    self.tableView.rowHeight=110;
    self.tableView.estimatedRowHeight=110;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
  self.bottomView= [self createBottomview];
    _bottomView.frame=CGRectMake(0, CGRectGetMaxY(_tableView.frame), self.view.bounds.size.width, 49);
    [self.view addSubview:_bottomView];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
//    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
#pragma mark -键盘弹起处理
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]
                           
                           CGRectValue];
    NSTimeInterval animationDuration = [[userInfo
                                         
                                         objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        
        float height=self.view.bounds.size.height-49-keyboardRect.size.height;
        _tableView.frame= CGRectMake(0, 64, self.view.bounds.size.width, height-64);
        _bottomView.frame =CGRectMake(0, height, self.view.bounds.size.width, 49);
        
    }];
    
    
}
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    
    
    NSTimeInterval animationDuration = [[userInfo
                                         
                                         objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.tableView.frame=CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-49-64);

     _bottomView.frame= CGRectMake(0, CGRectGetMaxY(_tableView.frame), self.view.bounds.size.width, 49);

    }];
}





-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;

    [self getData];
    

}
#pragma mark -上拉刷新、下拉加载
-(void)headerRereshing{
    NSLog(@"下拉加载");
//    _page=1;
//    [self getData];
    _page+=1;
    [self getData];
    
}
//-(void)footerRereshing{
//    NSLog(@"上拉刷新");
//    _page+=1;
//    [self getData];
//}
-(void)getData{
    //红包列表
    [SYObject startLoading];

    NSString *urlStr= [NSString stringWithFormat:@"%@%@",FIRST_URL,@"/app/buyer/my-redpack-data.htm"];
    
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    NSString *p=[NSString stringWithFormat:@"%zd",_page];
    NSDictionary *par=@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1],@"page":p};
    __weak typeof(self) ws= self;
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSLog(@"======%@",dic);
        [SYObject endLoading];
        
        if ([dic[@"ret"] isEqualToString:@"1"]) {
            
            if(_page==1){
                [_dataArr removeAllObjects];
               
            }
            
            
//            [_dataArr addObjectsFromArray: dic[@"list"]];
            NSArray *arr=dic[@"list"];
            
            NSRange range = NSMakeRange(0, [arr count]);
            
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            
            
            
            // Can't do this when I'm trying to add 9 new items at index 28
            
            // because of the error: index 28 beyond bounds [0 .. 5]
            
            [_dataArr insertObjects:arr atIndexes:indexSet];
#pragma mark - 这里的红包先用假数据

#if 0
            NSArray *arr=@[@{@"receive_state":@"RECEIVED",@"wishing":@"hello"},@{@"receive_state":@"RECEIVED",@"wishing":@"hello"},@{@"receive_state":@"RECEIVED",@"wishing":@"hello"}];
            [_dataArr addObjectsFromArray: arr];
            
#endif
            if (_dataArr.count==0) {

                [SYObject failedPrompt:@"暂无记录"];
            }
        }else if ([dic[@"ret"] isEqualToString:@"-4"]){
            [SYObject failedPrompt:@"错误"];
        }
        [SYObject endLoading];
//        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
        [self.tableView reloadData];

        if (isFirstCome) {//如果是第一次进来就让它滚到最下面，其他的刷新的就不用滚动到最下面了
            if (_dataArr.count>0) {
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_dataArr.count-1 inSection:0];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
                isFirstCome=NO;
            }
        
        }


        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        [SYObject endLoading];
        
    }];

}
-(UIView *)createBottomview{
    UIView *bottomView=[[UIView alloc]init];
    //1像素的横线
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 0,  self.view.bounds.size.width, 1)];
    line.backgroundColor=[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.5];
    [bottomView addSubview:line];
    bottomView.backgroundColor=[UIColor groupTableViewBackgroundColor];
//    [self.view addSubview:bottomView];
    
    //声音
    UIButton *sound=[[UIButton alloc]initWithFrame:CGRectMake(3, 5.5, 38, 38)];
    [sound setBackgroundImage:[UIImage imageNamed:@"sound"] forState:UIControlStateNormal];
    [bottomView addSubview:sound];
    
    
 
    //more
    UIButton *more=[[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-3-30, 7.5, 30, 30)];
    
    [more setBackgroundImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    more.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [bottomView addSubview:more];
    
    //emoji
    UIButton *emoji=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(more.frame)-3-38, 5.5, 38, 38)];
    [emoji setBackgroundImage:[UIImage imageNamed:@"emoji"] forState:UIControlStateNormal];
    [bottomView addSubview:emoji];
    
    //输入框
    
    int width=CGRectGetMinX(emoji.frame)-3-(CGRectGetMaxX(sound.frame)+3)-3;
    UITextView *tv=[[UITextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(sound.frame)+5, 7.5, width, 34)];
    tv.layer.masksToBounds=YES;
    tv.layer.cornerRadius=4;
    tv.font=[UIFont systemFontOfSize:17];
//    tv.text=@"敬请期待！";
    tv.delegate=self;
//    tv.userInteractionEnabled=NO;
//    tv.textColor=[UIColor lightGrayColor];
    tv.backgroundColor=[UIColor lightTextColor];
    tv.returnKeyType=UIReturnKeySend;
    [bottomView addSubview:tv];
    

    
    return bottomView;
}
#pragma mark -UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];

        if (textView.text.length==0) {
            return YES;
        }
        [_dataArr addObject:@{@"text":textView.text}];
        
        NSLog(@"_dataArr_dataArr==%@",_dataArr);
        [self.tableView reloadData];

#pragma mark -滚动到最底部
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_dataArr.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        textView.text=@"";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIAlertController *a=[UIAlertController alertControllerWithTitle:@"e网购" message:@"e网购消息为内部体验功能，暂不可实际对话，关闭该页面后消息自动清除。" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [a addAction:action];
            [self presentViewController:a animated:YES completion:nil];
        });
        
//        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height -self.tableView.bounds.size.height) animated:YES];
        

        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSDictionary *dic=_dataArr[indexPath.row];
    //如果已经领取红包了，就直接跳到红包详情那里
    if ([dic[@"receive_state"] isEqualToString:@"RECEIVED"]) {
        return 130;
    }else if(dic[@"text"]) {//如果是文本的话
        
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:17]};
        
        CGSize  maxSize=CGSizeMake(ScreenFrame.size.width-50*2, MAXFLOAT);
        CGRect rect= [dic[@"text"] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];

        return rect.size.height+10+20+10;
    }else{
        return 110;
    }

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    NSDictionary *dic=_dataArr[indexPath.row];
    if (dic[@"text"]) {//如果是文本的话
        MyTextcell *cell=[tableView dequeueReusableCellWithIdentifier:@"MyTextcell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.myText=dic[@"text"];
        //获取本地存储的头像URL
        NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
      NSString *photo_url= [d valueForKey:@"photo_url"];
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:photo_url]];
        return cell;
    }else{//如果是红包的话,返回红包的 cell
        LuckMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LuckMoneyTableViewCell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
//        NSLog(@"==%@",cell.contentView.subviews);
        // Configure the cell...
        cell.bigView.layer.masksToBounds=YES;
        cell.bigView.layer.cornerRadius=3;
        
        if (dic[@"wishing"]) {
            cell.topLabel.text=dic[@"wishing"];
            
        }
        
        //如果已经领取红包了，就直接跳到红包详情那里
        if ([dic[@"receive_state"] isEqualToString:@"RECEIVED"]) {
            cell.Bview.hidden=NO;
        }else{
            cell.Bview.hidden=YES;
        }
        cell.Bview.layer.cornerRadius=5;
        cell.Bview.layer.masksToBounds=YES;
        cell.backgroundColor=[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.3];
        return cell;

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    selectedRow=indexPath.row;
    
    NSDictionary *dic=_dataArr[indexPath.row];
    if (dic[@"text"]) {
        return;
    }
    //如果已经领取红包了，就直接跳到红包详情那里
    if ([dic[@"receive_state"] isEqualToString:@"RECEIVED"]) {
        LuckyMoney2TableViewController *vc=[[LuckyMoney2TableViewController alloc]init];
        vc.dic=dic;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (dic[@"wishing"]) {
        [self luckyMoneyUIWithWishing:dic[@"wishing"]];

    }else{
        [self luckyMoneyUIWithWishing:@"恭喜发财，大吉大利！"];

    }
    
    if(dic[@"id"]){
        redpackId=dic[@"id"];
    }
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakImageView.transform = CGAffineTransformScale(weakImageView.transform, 2.1, 2.1);

    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            weakImageView.transform = CGAffineTransformScale(weakImageView.transform, 0.9, 0.9);
            
        } completion:nil];
    }];
}

-(void)tapBackView:(UITapGestureRecognizer *)tap{
   CGPoint point= [tap locationInView:self.navigationController.view];
    float x=point.x;
    float y=point.y;
    NSLog(@"point=%@",NSStringFromCGPoint(point));
  float x1= CGRectGetMinX(weakImageView.frame);
    float x2=  CGRectGetMaxX(weakImageView.frame);
    float y1= CGRectGetMinY(weakImageView.frame);
    float y2=  CGRectGetMaxY(weakImageView.frame);

    if ((x>x1&&x<x2 )&&(y>y1&&y<y2)) {
            //图片里面的范围
        
    }else{
        [self closed];
    }
    
}

-(void)luckyMoneyUIWithWishing:(NSString *)wishing{
    int width= self.navigationController.view.bounds.size.width;
    int height=self.navigationController.view.bounds.size.height;
    weakBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,width, height)];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackView:)];;
    [weakBackView addGestureRecognizer:tap];
    weakBackView.backgroundColor=[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.7];
    [self.navigationController.view addSubview:weakBackView];
    
    
//    weakImageView=[[UIImageView alloc]initWithFrame:CGRectMake(30, 80, width-30*2, height-80*2)];
    weakImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 280, 400)];
    
    weakImageView.center=CGPointMake(width/2, height/2);
    weakImageView.image=[UIImage imageNamed:@"red-back"];
    
    weakImageView.layer.masksToBounds=YES;
    weakImageView.layer.cornerRadius=5;
    
    weakImageView.userInteractionEnabled=YES;
    [weakBackView addSubview:weakImageView];
    //close按钮
    UIButton *closeBut=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    [closeBut setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBut addTarget:self action:@selector(closed) forControlEvents:UIControlEventTouchUpInside];
    [weakImageView addSubview:closeBut];
    //    头像
    UIImageView *headimageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    headimageview.center=CGPointMake(weakImageView.frame.size.width/2, 70);
    
    headimageview.image=[UIImage imageNamed:@"logo"];
    
    [weakImageView addSubview:headimageview];
    
    
    
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headimageview.frame),weakImageView.frame.size.width, 30)];
    label.text=@"e网购优品";
    label.font=[UIFont systemFontOfSize:14];
    label.textColor=[UIColor lightGrayColor];
    label.textAlignment=NSTextAlignmentCenter;
    [weakImageView addSubview:label];
    
    
    UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame)+10,weakImageView.frame.size.width, 30)];
    label2.text=@"给你发了一个红包";
    label2.font=[UIFont systemFontOfSize:14];
    label2.textColor=[UIColor lightGrayColor];
    label2.textAlignment=NSTextAlignmentCenter;
    [weakImageView addSubview:label2];
    
    UILabel *label3=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label2.frame)+20,weakImageView.frame.size.width, 30)];
    label3.text=wishing;
    label3.font=[UIFont systemFontOfSize:20];
    label3.textColor=[UIColor lightGrayColor];
    label3.textAlignment=NSTextAlignmentCenter;
    [weakImageView addSubview:label3];
    
    
    
    
    
    //打开红包
//    openBut=[[UIButton alloc]initWithFrame:CGRectMake(weakImageView.frame.size.width/2-40, CGRectGetMaxY(label3.frame)+80, 80, 80)];
    
   
    openBut=[[UIButton alloc]initWithFrame:CGRectMake(weakImageView.frame.size.width/2-40, weakImageView.frame.size.height/10*6, 80, 80)];
    [openBut setTitle:@"拆红包" forState:UIControlStateNormal];
    openBut.layer.cornerRadius=40;
    openBut.layer.masksToBounds=YES;
    openBut.backgroundColor=[UIColor orangeColor];
//    [openBut setBackgroundImage:[UIImage imageNamed:@"logo3"] forState:UIControlStateNormal];
    [openBut addTarget:self action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
    [weakImageView addSubview:openBut];
    
    if (self.view.bounds.size.width==320) {//说明是5 5s
        weakImageView.transform = CGAffineTransformScale(weakImageView.transform, 0.5, 0.5);

    }else if(self.view.bounds.size.width==375){//6
        weakImageView.transform = CGAffineTransformScale(weakImageView.transform, 0.55, 0.55);

    }else{
        weakImageView.transform = CGAffineTransformScale(weakImageView.transform, 0.6, 0.6);

    }


}

-(void)open{
    
    
#if 0
//    CATransform3D rotationTransform  = CATransform3DMakeRotation(1*M_PI, 0, 1,0);
//    
//    
//    
//    CABasicAnimation* animation;
//    
//    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
//    
//    
//    
//    animation.toValue = [NSValue valueWithCATransform3D:rotationTransform];
//    
//    animation.duration        = 0.3;
//    
//    animation.autoreverses    = YES;
//    
//    animation.cumulative    = YES;
//    
//    animation.repeatCount    = 1;
//    
//    animation.beginTime        = 0.1;
//    
//    animation.delegate        = self;
//    
//    CAAnimationGroup *m_pGroupAnimation = [CAAnimationGroup animation];
//    
//    m_pGroupAnimation.delegate              =self;
//    
//    m_pGroupAnimation.removedOnCompletion   =NO;
//    
//    m_pGroupAnimation.duration   =1;
//    m_pGroupAnimation.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    
//    m_pGroupAnimation.repeatCount           =FLT_MAX;//FLT_MAX;  //"forever";
//    
//    m_pGroupAnimation.fillMode              =kCAFillModeForwards;
//    
//    m_pGroupAnimation.animations =[NSArray arrayWithObjects:animation,nil];
//    
//    
//    
//    [openBut.layer  addAnimation:m_pGroupAnimation forKey:@"animationRotate"];
//    
//
//    [openBut.layer addAnimation:animation forKey:@"he"];
#else
    
#pragma mark - 取消了3d旋转效果
//    CABasicAnimation* rotationAnimation;
//    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
//    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
//    rotationAnimation.duration = 1;
//    rotationAnimation.cumulative = YES;
//    rotationAnimation.repeatCount = MAXFLOAT;
//    
//    [openBut.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
#endif
    
    
    //领取红包
    
    NSString *urlStr= [NSString stringWithFormat:@"%@%@",FIRST_URL,@"/app/buyer/receive-redpack.htm"];
    
    NSArray *fileContent2 = [MyUtil returnLocalUserFile];
    NSDictionary *par=@{@"user_id":[fileContent2 objectAtIndex:3],@"token":[fileContent2 objectAtIndex:1],@"redpackId":redpackId};
    __weak typeof(self) ws= self;
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSLog(@"======%@",dic);
        
        
        if ([dic[@"result"] isEqualToString:@"1"]) {
            [self closed];
            //延时0.3秒跳转
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                LuckyMoney2TableViewController *vc=[[LuckyMoney2TableViewController alloc]init];
                vc.dic=_dataArr[selectedRow];
                [self.navigationController pushViewController:vc animated:YES];
            });
            
        }else{
        
            [SYObject failedPrompt:@"领取失败"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self closed];

            });
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
    }];

}



-(void)closed{
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        weakImageView.transform = CGAffineTransformScale(weakImageView.transform, 0.01, 0.01);
//        weakBackView.alpha=0;
        
    } completion:^(BOOL finished) {
        [weakBackView removeFromSuperview];
        weakBackView=nil;
    }];
   
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end



