//
//  GoodsListViewController.m
//  My_App
//
//  Created by apple on 15-2-5.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "GoodsListViewController.h"
#import "ASIFormDataRequest.h"
#import "ThirdViewController.h"
#import "NilCell.h"

@interface GoodsListViewController ()

@end

@implementation GoodsListViewController
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"清单列表:%@",dicBig);
        if (billdataArray.count!=0) {
            [billdataArray removeAllObjects];
        }
        NSArray *arr = [dicBig objectForKey:@"goods_list"];
        for(NSDictionary *dic in arr){
            ClassifyModel *clas = [[ClassifyModel alloc]init];
            clas.goods_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"goods_id"]];
            clas.goods_main_photo = [dic objectForKey:@"goods_main_photo"];
            clas.goods_current_price =[dic objectForKey:@"goods_price"];
            clas.goods_goods_spec = [dic objectForKey:@"goods_spec"];
            clas.goods_goods_count = [NSString stringWithFormat:@"%@",[dic objectForKey:@"goods_count"]];
            clas.goods_name = [dic objectForKey:@"goods_name"];
            clas.goods_groupinfos = [dic objectForKey:@"suit_list"];
            clas.goods_status =[dic objectForKey:@"cart_status"] ;
            [billdataArray addObject:clas];
        }
    }
    [MyTableView reloadData];
    [SYObject endLoading];
    nothingView.hidden = YES;
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    [SYObject failedPrompt:@"网络请求失败"];
    
    nothingView.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request102 clearDelegatesAndCancel];
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [SYObject startLoading];
    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,BUYLIST_URL]];
    request102=[ASIFormDataRequest requestWithURL:url3];
    ThirdViewController *th = [ThirdViewController sharedUserDefault];
    [request102 setPostValue:th.jie_cart_ids forKey:@"cart_ids"];
    
    [request102 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request102.tag = 102;
    request102.delegate = self;
    [request102 setDidFailSelector:@selector(urlRequestFailed:)];
    [request102 setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [request102 startAsynchronous];
    [super viewWillAppear:YES];
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品清单";
    // Do any additional setup after loading the view.
    [self createBackBtn];
    billdataArray = [[NSMutableArray alloc]init];
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    MyTableView.delegate = self;
    MyTableView.dataSource=  self;
    
    labelTi.hidden = YES;
    [SYObject startLoading];
    nothingView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tabelView方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return billdataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (billdataArray.count!=0) {
        ClassifyModel *class = [billdataArray objectAtIndex:indexPath.row];
        if(class.goods_status.length == 0){
            if (class.goods_groupinfos.count==0){
                return 112;

            }else{
                return 112 + class.goods_groupinfos.count*65;//组合
            }
        }else{
            if ([class.goods_status isEqualToString:@"赠品"]) {
                
                return 112;
                
                
            }else
            {
            
            if (class.goods_groupinfos.count==0){
               return 112 + 30;
                
                
            }else{
                return 112 + 30 +class.goods_groupinfos.count*65;
            }
            }
        }
        
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NilCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell%ld_%ld", (long)indexPath.section, (long)indexPath.row]];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NilCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    }
    if (billdataArray.count!=0) {
       
        CGFloat h = 112;
        CGFloat h1 = h -5;
        CGFloat h2 = 85;
        CGFloat y = 0.5 * (h - h2);
        CGFloat x1 = 13;
        CGFloat w1 = h2;
        CGFloat x2 = x1 + h2 + x1;
        CGFloat w2 = ScreenFrame.size.width - x2 - x1;
       
        CGFloat w3 = 30;
        CGFloat y1 = y + w3 + 10;
        CGFloat w4 = 15;
        CGFloat x3 = ScreenFrame.size.width - x1 - 40;
       // CGFloat w2 = ScreenFrame.size.width - x3 - 10;
        CGFloat y2 = h - x1 - w4;
        CGFloat x4 = x3 + w2 - w2;
     
        
        CGRect frame_imgeWhite = CGRectMake(0, 5, ScreenFrame.size.width, h1);
        CGRect frame_imageGood = CGRectMake(x1, y, w1, w1);
        CGRect frame_labelname = CGRectMake(x2, y, w2, 40);
//        CGRect frame_labelCount = CGRectMake(x3, y2, ScreenFrame.size.width - x3 - 10, w4);
        CGRect frame_labelCount = CGRectMake(ScreenFrame.size.width-110, y2, 100, w4);
        CGRect frame_labelSpec = CGRectMake(x2, y1, w2, w4);
        CGRect frame_btn5 = CGRectMake(0, 0, ScreenFrame.size.width, 60);
        CGRect frame_labelCount1 = CGRectMake(x4, y2 - w4 - 10, ScreenFrame.size.width - x3 - 10, w3);
        
        CGRect frame_imgeWhite_1 = frame_imgeWhite;//CGRectMake(0, 5, ScreenFrame.size.width, 65)
        CGRect frame_imgeWhite_z = CGRectMake(0, 25, ScreenFrame.size.width, h1-20);
        
        CGRect frame_imgeWhite_2 = CGRectMake(0, 5, ScreenFrame.size.width, h1+30);
        CGRect frame_labelSSS_2 = CGRectMake(x1, 10, 80, 20);//满就减
        CGRect frame_labelSSS_3 = CGRectMake(x1, 10+20, 50, 20);
        CGRect frame_btn5_2 = CGRectMake(5, 35, ScreenFrame.size.width-10, 65);
        CGRect frame_labelSpec_2 = CGRectMake(x2, 70, w2, w4);
//        CGRect frame_labelCount_2 = CGRectMake(x3, y2 + 30, w2, w4);
        CGRect frame_labelCount_2 = CGRectMake(ScreenFrame.size.width-110, y2 + 30, 100, w4);
        CGRect frame_labelname_2 = CGRectMake(x2, y + 20, w2, w3);
        CGRect frame_labelname_3 = CGRectMake(x2, y + 30, w2, w3);
        CGRect frame_imageGood_2 = CGRectMake(x1, y + 30, w1, w1);
        CGRect frame_imageGood_3 = CGRectMake(x1, y + 40, 50, 50);
        
        UIImageView *imgeWhite = [[UIImageView alloc]initWithFrame:frame_imgeWhite];
        imgeWhite.backgroundColor = [UIColor whiteColor];
        [cell addSubview:imgeWhite];
        ClassifyModel *class = [billdataArray objectAtIndex:indexPath.row];
        
        UIImageView *imageGood = [[UIImageView alloc]initWithFrame:frame_imageGood];
        [imageGood sd_setImageWithURL:[NSURL URLWithString:class.goods_main_photo] placeholderImage:[UIImage imageNamed:@"kong"]];
        [cell addSubview:imageGood];
        
        UILabel *labelname = [[UILabel alloc]initWithFrame:frame_labelname];
        labelname.font = [UIFont systemFontOfSize:13];
        labelname.textColor = UIColorFromRGB(0x222222);
        labelname.numberOfLines = 2;
        labelname.text = class.goods_name;
        [cell addSubview:labelname];
        
        UILabel *labelCount = [[UILabel alloc]initWithFrame:frame_labelCount];
        labelCount.font = [UIFont boldSystemFontOfSize:12];
        labelCount.textColor = MY_COLOR;
        //labelCount.backgroundColor=[UIColor greenColor];
        labelCount.text = [NSString stringWithFormat:@"￥%.2f",[class.goods_current_price floatValue]];
        labelCount.textAlignment=NSTextAlignmentRight;
        [cell addSubview:labelCount];
        
        UILabel *labelCount1 = [[UILabel alloc]initWithFrame:frame_labelCount1];
        labelCount1.font = [UIFont boldSystemFontOfSize:12];
        labelCount1.textColor = MY_COLOR;
        if ([class.goods_status isEqualToString:@"赠品"]) {
             labelCount1.text = [NSString stringWithFormat:@"%@",class.goods_goods_count];
        }else
        {
        
        labelCount1.text = [NSString stringWithFormat:@"×%@",class.goods_goods_count];
            labelCount1.textAlignment=NSTextAlignmentRight;
            //labelCount1.backgroundColor=[UIColor greenColor];
        }
        [cell addSubview:labelCount1];
        
        UILabel *labelSpec = [[UILabel alloc]initWithFrame:frame_labelSpec];
       
        labelSpec.font = [UIFont systemFontOfSize:11];
        labelSpec.textColor = [UIColor darkGrayColor];
//        labelSpec.text = class.goods_goods_spec;
        NSRange range1=NSMakeRange(0, class.goods_goods_spec.length);
        NSMutableString *mutableStr=[class.goods_goods_spec mutableCopy];
        [mutableStr replaceOccurrencesOfString:@"<br>" withString:@" " options:NSCaseInsensitiveSearch range:range1];
        labelSpec.text = mutableStr;
        [cell addSubview:labelSpec];
        
        UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn5.frame = frame_btn5;
        btn5.tag = 100+indexPath.row;
        [btn5 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn5];
        
        if(class.goods_status.length == 0){
            imgeWhite.frame = frame_imgeWhite_1;
        }else{
            if ([class.goods_status isEqualToString:@"赠品"]) {
                imgeWhite.frame = frame_imgeWhite_z;
                UILabel *labelSSS = [[UILabel alloc]initWithFrame:frame_labelSSS_3];
                labelSSS.font = [UIFont systemFontOfSize:10];
                labelSSS.textColor = [UIColor whiteColor];
                labelSSS.backgroundColor = MY_COLOR;
                labelSSS.textAlignment = NSTextAlignmentCenter;
                labelSSS.text = class.goods_status;
                [labelSSS.layer setMasksToBounds:YES];
                [labelSSS.layer setCornerRadius:4.0];
                [cell addSubview:labelSSS];
                btn5.frame = frame_btn5_2;
                labelSpec.frame = frame_labelSpec_2;
                labelCount.frame = frame_labelCount_2;
                labelCount.text=@"";
                CGRect fra = labelCount1.frame;
                fra.origin.y += 30;
                labelCount1.frame = fra;
                labelname.frame = frame_labelname_3;
                imageGood.frame = frame_imageGood_3;
              
                
            }else{
            
            
            imgeWhite.frame = frame_imgeWhite_2;
            UILabel *labelSSS = [[UILabel alloc]initWithFrame:frame_labelSSS_2];
            labelSSS.font = [UIFont systemFontOfSize:10];
            [labelSSS.layer setMasksToBounds:YES];
            [labelSSS.layer setCornerRadius:4.0];
            labelSSS.textColor = [UIColor whiteColor];
            labelSSS.backgroundColor = MY_COLOR;
            labelSSS.textAlignment = NSTextAlignmentCenter;
            labelSSS.text = class.goods_status;
            [cell addSubview:labelSSS];
            btn5.frame = frame_btn5_2;
            labelSpec.frame = frame_labelSpec_2;
            labelCount.frame = frame_labelCount_2;
            CGRect fra = labelCount1.frame;
            fra.origin.y += 30;
            labelCount1.frame = fra;
            labelname.frame = frame_labelname_2;
            imageGood.frame = frame_imageGood_2;
                
            }
        }
        if (class.goods_groupinfos.count==0) {
            //说明不是组合商品
        }else{
            //说明是组合商品
            CGFloat shift = 40;
            CGRect frame_imgeWhite_3 = CGRectMake(0, 5, ScreenFrame.size.width,  h + 65*class.goods_groupinfos.count + shift - 15);
            imgeWhite.frame = frame_imgeWhite_3;
            
            for(int i=0;i<class.goods_groupinfos.count;i++){
                UIView *myLine = [[UIView alloc]initWithFrame:CGRectMake(10, 70+65*i + shift, ScreenFrame.size.width-10, 0.5)];
                myLine.backgroundColor = [UIColor lightGrayColor];
                [cell addSubview:myLine];
                
                UIImageView *imagePhoto = [[UIImageView alloc]initWithFrame:CGRectMake(13, 75+65*i + shift, 55, 55)];
                [imagePhoto sd_setImageWithURL:[NSURL URLWithString:[[class.goods_groupinfos objectAtIndex:i] objectForKey:@"img"]] placeholderImage:[UIImage imageNamed:@"kong_lj"]];
                [cell addSubview:imagePhoto];
                
                UILabel *labelNN = [[UILabel alloc]initWithFrame:CGRectMake(73, 75+65*i + shift, ScreenFrame.size.width-83, 40)];
                labelNN.font =  [UIFont systemFontOfSize:12];
                labelNN.textColor = [UIColor darkGrayColor];
                labelNN.backgroundColor = [UIColor whiteColor];
                labelNN.numberOfLines = 2;
                labelNN.text = [[class.goods_groupinfos objectAtIndex:i] objectForKey:@"name"];
                [cell addSubview:labelNN];
                if(class.goods_status.length == 0){
                    
                }else{
                    myLine.frame = CGRectMake(10, 100+65*i + shift, ScreenFrame.size.width-10, 0.5);
                    imagePhoto.frame = CGRectMake(13, 105+65*i + shift, 55, 55);
                    labelNN.frame = CGRectMake(73, 105+65*i + shift, ScreenFrame.size.width-83, 40);
                }
            }
        }
    }
    return cell;
}

-(void)btnClicked:(UIButton *)btn{
    
}

@end
