//
//  GoodsEditDetailsViewController.m
//  2016seller_01_09_new
//
//  Created by apple on 16/1/9.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

#import "GoodsEditDetailsViewController.h"
#import "NilCell.h"
#import "SpecDetailCell.h"
#import "GoodsSpecModel.h"
#import "FlayButton.h"

@interface GoodsEditDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,SpecDetailCellDelegate>
{
    UITableView *myTableview;
    NSMutableArray *specListArray;
    NSMutableArray *specDetailArray;
    NSMutableArray *colorSpecListArray;
    NSMutableArray *specSeleArray;
    NSMutableArray *colorSpecSeleArray;
    NSMutableArray *needResultArr;
    UIView *semiTransparentView;
    UIView *specifView;
    UITextField *batchPriceTextField;
    UITextField *batchCountTextField;
    
}
@end

@implementation GoodsEditDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [MyObject noDataViewIn:self.view];
    [self createBackBtn];
    [self designPage];
    [self creatBatchSettingInterface];
    [self getGoodsEditDetailsGoodsId:_model.goods_id];
  
}
-(void)createBackBtn{
    self.title=@"商品规格详情";
    
    UIButton *button_edit = [UIButton buttonWithType:UIButtonTypeCustom ];
    button_edit.frame =CGRectMake(0, 0, 44, 44);
    [button_edit setTitle:@"保存" forState:UIControlStateNormal];
    button_edit.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button_edit addTarget:self action:@selector(overBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button_edit];
    self.navigationItem.rightBarButtonItem =bar;
}
-(void)designPage {
    self.view.backgroundColor = [UIColor whiteColor];
    if (UIDeviceSystem>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    myTableview = [[UITableView alloc]initWithFrame:CGRectMake(0,64, ScreenFrame.size.width, ScreenFrame.size.height-64) style:UITableViewStyleGrouped];
    myTableview.backgroundColor = GRAY_COLOR;
    myTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableview.delegate = self;
    myTableview.dataSource=  self;
    myTableview.showsVerticalScrollIndicator=NO;
    myTableview.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:myTableview];
}
-(void)creatBatchSettingInterface{
    semiTransparentView=[LJControl viewFrame:CGRectMake(0,0,ScreenFrame.size.width, ScreenFrame.size.height) backgroundColor:[UIColor blackColor]];
    semiTransparentView.alpha=0.7;
    [self.navigationController.view addSubview:semiTransparentView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
    [semiTransparentView addGestureRecognizer:tap];
    
    specifView=[LJControl viewFrame:CGRectMake(30,ScreenFrame.size.height/2-100, ScreenFrame.size.width-60,230) backgroundColor:UIColorFromRGB(0Xe2e2e2)];
    [self.navigationController.view addSubview:specifView];
    [specifView.layer setMasksToBounds:YES];
    [specifView.layer  setCornerRadius:6.0];
    
    UILabel *titleLabel=[LJControl labelFrame:CGRectMake(0, 5, ScreenFrame.size.width-60, 30) setText:@"批量设定价格/库存" setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0X4e4e4e) textAlignment:NSTextAlignmentCenter];
    [specifView addSubview:titleLabel];

    batchPriceTextField=[LJControl textFieldFrame:CGRectMake(10,50,ScreenFrame.size.width-60 -20, 40) text:@"" placeText:@"统一输入价格" setfont:17 textColor:UIColorFromRGB(0Xa9a9a9) keyboard:UIKeyboardTypeNumberPad];
    batchPriceTextField.textAlignment=NSTextAlignmentCenter;
    batchPriceTextField.backgroundColor=UIColorFromRGB(0Xeeeeee);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:batchPriceTextField.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = batchPriceTextField.bounds;
    maskLayer.path = maskPath.CGPath;
    batchPriceTextField.layer.mask = maskLayer;
    
//    [batchPriceTextField.layer setMasksToBounds:YES];
//    [batchPriceTextField.layer  setCornerRadius:6.0];
    batchPriceTextField.delegate=self;
    [specifView addSubview:batchPriceTextField];
  
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 30)];
    [topView setBarStyle:UIBarStyleBlack];
    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];// UIBarButtonItemStyleBordered
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
    [topView setItems:buttonsArray];
    [batchPriceTextField setInputAccessoryView:topView];
    
    batchCountTextField=[LJControl textFieldFrame:CGRectMake(10,92,ScreenFrame.size.width-60 -20, 40) text:@"" placeText:@"统一输入库存" setfont:17 textColor:UIColorFromRGB(0Xa9a9a9) keyboard:UIKeyboardTypeNumberPad];
    batchCountTextField.textAlignment=NSTextAlignmentCenter;
    batchCountTextField.backgroundColor=UIColorFromRGB(0Xeeeeee);
    
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:batchCountTextField.layer.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = batchCountTextField.bounds;
    maskLayer1.path = maskPath1.CGPath;
    batchCountTextField.layer.mask = maskLayer1;
//    [batchCountTextField.layer setMasksToBounds:YES];
//    [batchCountTextField.layer  setCornerRadius:6.0];
    batchCountTextField.delegate=self;
    [specifView addSubview:batchCountTextField];

    UIToolbar * topView1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 30)];
    [topView1 setBarStyle:UIBarStyleBlack];
    UIBarButtonItem * helloButton1 = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];// UIBarButtonItemStyleBordered
    UIBarButtonItem * btnSpace1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton1 = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray1 = [NSArray arrayWithObjects:helloButton1,btnSpace1,doneButton1,nil];
    [topView1 setItems:buttonsArray1];
    [batchCountTextField setInputAccessoryView:topView1];
    
    UILabel *ifonLabel=[LJControl labelFrame:CGRectMake(0,140, ScreenFrame.size.width-60, 30) setText:@"您可以只设定价格或只设定库存" setTitleFont:14 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0X4e4e4e) textAlignment:NSTextAlignmentCenter];
    [specifView addSubview:ifonLabel];
    
    UIView *lin=[LJControl viewFrame:CGRectMake(0, 179, ScreenFrame.size.width-60, 1) backgroundColor:UIColorFromRGB(0Xa9a9a9)];
    [specifView addSubview:lin];
    UIView *line=[LJControl viewFrame:CGRectMake((ScreenFrame.size.width-60)/2-0.5, 180, 1,60) backgroundColor:UIColorFromRGB(0Xa9a9a9)];
    [specifView addSubview:line];
    
    UIButton *cancelButton=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake(5, 185, (ScreenFrame.size.width-60)/2-10, 40) setNormalImage:nil setSelectedImage:nil setTitle:@"" setTitleFont:0 setbackgroundColor:[UIColor clearColor]];
    UILabel *cancelLabel=[LJControl labelFrame:CGRectMake(5,0, (ScreenFrame.size.width-60)/2-20, 40) setText:@"取消" setTitleFont:20 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0X4e4e4e) textAlignment:NSTextAlignmentCenter];
    [cancelButton addSubview:cancelLabel];
    [cancelButton addTarget:self action:@selector(tapClick:) forControlEvents:UIControlEventTouchUpInside];
    [specifView addSubview:cancelButton];
    
    UIButton *sureButton=[LJControl buttonType:UIButtonTypeCustom setFrame:CGRectMake((ScreenFrame.size.width-60)/2-5, 185, (ScreenFrame.size.width-60)/2-10, 40) setNormalImage:nil setSelectedImage:nil setTitle:@"" setTitleFont:0 setbackgroundColor:[UIColor clearColor]];
    UILabel *surLabel=[LJControl labelFrame:CGRectMake(5,0, (ScreenFrame.size.width-60)/2-20, 40) setText:@"确定" setTitleFont:20 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0X4e4e4e) textAlignment:NSTextAlignmentCenter];
    [sureButton addSubview:surLabel];
    [sureButton addTarget:self action:@selector(sureBatch:) forControlEvents:UIControlEventTouchUpInside];
    [specifView addSubview:sureButton];
    
    semiTransparentView.hidden=YES;
    specifView.hidden=YES;
}
-(void)sureBatch:(UIButton *)btn{
//批量设定确定事件
    for (GoodsSpecModel *model in specDetailArray) {
        if ([batchPriceTextField.text floatValue]>=0 && batchPriceTextField.text.length>0) {
            model.price=batchPriceTextField.text;
        }
        if ([batchCountTextField.text integerValue]>=0 && batchCountTextField.text.length>0) {
            model.count=batchCountTextField.text;
        }
    }
    [myTableview reloadData];
    [batchPriceTextField resignFirstResponder];
    [batchCountTextField resignFirstResponder];
    semiTransparentView.hidden=YES;
    specifView.hidden=YES;
    

}
-(void)dismissKeyBoard{
    [batchPriceTextField resignFirstResponder];
    [batchCountTextField resignFirstResponder];
}
-(void)tapClick:(UITapGestureRecognizer *)tap{
    //隐藏统一设定
    semiTransparentView.hidden=YES;
    specifView.hidden=YES;
    [batchPriceTextField resignFirstResponder];
    [batchCountTextField resignFirstResponder];
}
#pragma mark-选择的id 数组
-(void)createSelectDataArray{
    if(!specSeleArray){
        specSeleArray=[[NSMutableArray alloc]init];
        for (int i=0; i<specListArray.count; i++) {
            NSMutableArray *marry=[[NSMutableArray alloc]init];
            [specSeleArray addObject:marry];
        }
    }else{
        for (NSMutableArray *marry in specSeleArray) {
            [marry removeAllObjects];
        }
        
    }
    if(!colorSpecSeleArray){
        colorSpecSeleArray=[[NSMutableArray alloc]init];
        for (int i=0; i<colorSpecListArray.count; i++) {
            NSMutableArray *marry=[[NSMutableArray alloc]init];
            [colorSpecSeleArray addObject:marry];
        }
    }else{
        for (NSMutableArray *marry in colorSpecSeleArray) {
            [marry removeAllObjects];
        }
    }
}
-(void)getSelectDataArray:(NSArray *)idArray{
    //colorSpecListArray
    for (int i=0; i<colorSpecListArray.count; i++) {
        GoodsSpecModel *model=[colorSpecListArray objectAtIndex:i];
        NSArray *propertyArry=model.property;
        NSMutableArray *mArry=[[NSMutableArray alloc]init];
        for (NSDictionary *dic in propertyArry) {
            NSString *idStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
            for (NSString *is in idArray) {
                if ([idStr isEqualToString:is]) {
                    [mArry addObject:is];
                }
            }
        }
        NSMutableArray *seleArray=[colorSpecSeleArray objectAtIndex:i];
        if (seleArray.count>0) {
            for (NSString *str in mArry) {
                for (int j=0; j<seleArray.count; j++) {
                    NSString *seleStr=[seleArray objectAtIndex:j];
                    if ([seleStr isEqualToString:str]) {
                        break;
                    }else{
                        if (j==seleArray.count-1 && ![seleStr isEqualToString:str]) {
                             [[colorSpecSeleArray objectAtIndex:i] addObject:str];
                        }
                    }
                }
            }
        }else{
            for (NSString *str in mArry) {
                [[colorSpecSeleArray objectAtIndex:i] addObject:str];
            }
        }
    }
    //specListArray
    for (int i=0; i<specListArray.count; i++) {
        GoodsSpecModel *model=[specListArray objectAtIndex:i];
        NSArray *propertyArry=model.property;
        NSMutableArray *mArry=[[NSMutableArray alloc]init];
        for (NSDictionary *dic in propertyArry) {
            NSString *idStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
            for (NSString *is in idArray) {
                if ([idStr isEqualToString:is]) {
                    [mArry addObject:is];
                }
            }
        }
        NSMutableArray *seleArray=[specSeleArray objectAtIndex:i];
        if (seleArray.count>0) {
            for (NSString *str in mArry) {
                for (int j=0; j<seleArray.count; j++) {
                    NSString *seleStr=[seleArray objectAtIndex:j];
                    if ([seleStr isEqualToString:str]) {
                        break;
                    }else{
                        if (j==seleArray.count-1 && ![seleStr isEqualToString:str]) {
                            [[specSeleArray objectAtIndex:i] addObject:str];
                        }
                    }
                }
            }
        }else{
            for (NSString *str in mArry) {
                [[specSeleArray objectAtIndex:i] addObject:str];
            }
        }
    }
}
#pragma mark-根据id获得规格名称
-(NSString *)getSelectSpecValue:(NSArray *)idArray{
    NSMutableArray *allSpcArray=[[NSMutableArray alloc]init];
    for (GoodsSpecModel *model in colorSpecListArray) {
        for (NSDictionary *dic in model.property) {
            [allSpcArray addObject:dic];
        }
    }
    for (GoodsSpecModel *model in specListArray) {
        for (NSDictionary *dic in model.property) {
            [allSpcArray addObject:dic];
        }
    }
    NSMutableArray *mArray=[[NSMutableArray alloc]init];
    for (NSString *str in idArray) {
        for (NSDictionary *dic in allSpcArray) {
            NSString *idStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
            if ([str isEqualToString:idStr]) {
                [mArray addObject:[NSString stringWithFormat:@"\"%@\"",[dic objectForKey:@"value"]]];
            }
        }
    }
    NSString *string=[mArray componentsJoinedByString:@"+"];
    return string;
}
#pragma mark-根据id获得规格数组
-(NSArray *)getSelectSpecValuesArray:(NSArray *)idArray{
    NSMutableArray *allSpcArray=[[NSMutableArray alloc]init];
    for (GoodsSpecModel *model in colorSpecListArray) {
        for (NSDictionary *dic in model.property) {
            [allSpcArray addObject:dic];
        }
    }
    for (GoodsSpecModel *model in specListArray) {
        for (NSDictionary *dic in model.property) {
            [allSpcArray addObject:dic];
        }
    }
    NSMutableArray *mArray=[[NSMutableArray alloc]init];
    for (NSString *str in idArray) {
        for (NSDictionary *dic in allSpcArray) {
            NSString *idStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
            if ([str isEqualToString:idStr]) {
                [mArray addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"value"]]];
            }
        }
    }
    return mArray;
}

#pragma mark-数据请求
-(void)getGoodsEditDetailsGoodsId:(NSString *)goodsId{
    [MyObject startLoading];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,GOODS_SPECIFICATION_URL];
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken],
                          @"goods_id":goodsId
                          };
   [myAfnetwork netWorkingURL:urlStr parameters:par andWay:@"post" getParseSuccess:^(myselfParse *parse) {
       NSDictionary *dicBig=parse.dicBig;
       NSLog(@"%@",parse.dicBig);
       if(!specListArray){
           specListArray=[[NSMutableArray alloc]init];
       }else{
           [specListArray removeAllObjects];
       }
       if(!colorSpecListArray){
           colorSpecListArray=[[NSMutableArray alloc]init];
       }else{
           [colorSpecListArray removeAllObjects];
       }
       
       if(!specDetailArray){
           specDetailArray=[[NSMutableArray alloc]init];
       }else{
           [specDetailArray removeAllObjects];
       }
       for (NSDictionary *dict in [dicBig objectForKey:@"color_spec_list"]) {
           GoodsSpecModel *model=[[GoodsSpecModel alloc]init];
           model.specId=[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
           model.name=[NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
           model.property=[dict objectForKey:@"property"];
           model.type=[NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]];
           if (model.property.count>0) {
                [colorSpecListArray addObject:model];
           }
       }
       for (NSDictionary *dict in [dicBig objectForKey:@"other_spec_list"]) {
           GoodsSpecModel *model=[[GoodsSpecModel alloc]init];
           model.specId=[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
           model.name=[NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
           model.property=[dict objectForKey:@"property"];
           model.type=[NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]];
           if (model.property.count>0) {
               [specListArray addObject:model];
           }
       }
       [self createSelectDataArray];
       
       for (NSDictionary *dict in [dicBig objectForKey:@"goods_specification_detail"]) {
           GoodsSpecModel *model=[[GoodsSpecModel alloc]init];
           model.code=[NSString stringWithFormat:@"%@",[dict objectForKey:@"code"]];
           model.count=[NSString stringWithFormat:@"%@",[dict objectForKey:@"count"]];
           model.detailId=[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
           NSMutableArray *idArray=(NSMutableArray *)[model.detailId componentsSeparatedByString:@"_"];
           if ([[idArray lastObject]isEqualToString:@""]) {
               [idArray removeLastObject];
           }
           model.detailIdArray=idArray;
           [self getSelectDataArray:idArray];
           model.detailValue=[self getSelectSpecValue:idArray];
           model.price=[NSString stringWithFormat:@"%@",[dict objectForKey:@"price"]];
           model.supp=[NSString stringWithFormat:@"%@",[dict objectForKey:@"supp"]];
           if (model.detailIdArray.count>0) {
              [specDetailArray addObject:model];
           }
       }
       if (specDetailArray.count>0) {
       }else{
           [self getSelectDataArray:_seleArray];
           [self start];
       
       }
       
       if (colorSpecListArray.count==0 && specListArray.count==0 && specDetailArray.count==0) {
           myTableview.hidden=YES;
       }else{
           myTableview.hidden=NO;
           [self.view bringSubviewToFront:myTableview];
       }
       
       
       [myTableview reloadData];
       [MyObject endLoading];
    }getParsefailure:^{
        [MyObject failedPrompt:@"网络这在开小差"];
        [MyObject endLoading];
    }];
}


#pragma mark -UITableViewDataSource&&UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([_speFlay integerValue]==0) {
          return 2;
    }else if ([_speFlay integerValue]==1){
        return 3;
    }
     return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return specListArray.count;
    }else if (section==1){
        return colorSpecListArray.count;
    }else if (section==2){
        return specDetailArray.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        GoodsSpecModel *model=[specListArray objectAtIndex:indexPath.row];
        NSArray *propertyArray=model.property;
        NSInteger h;
        if (propertyArray.count==0) {
            h=0;
        }else{
            h=(propertyArray.count%3)==0?50*(propertyArray.count/3)+35:50*(propertyArray.count/3)+85;
        }
        return h;
    }else if (indexPath.section==1){
        GoodsSpecModel *model=[colorSpecListArray objectAtIndex:indexPath.row];
        NSArray *propertyArray=model.property;
        NSInteger h;
        if (propertyArray.count==0) {
            h=0;
        }else{
            h=(propertyArray.count%3)==0?50*(propertyArray.count/3)+35:50*(propertyArray.count/3)+85;
        }
        return h;
    }else if (indexPath.section==2){
        return 100;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NilCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%d%d",indexPath.section,indexPath.row]];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NilCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }else{
        for (UIView *subView in cell.contentView.subviews){
            [subView removeFromSuperview];
        }
    }
    if (indexPath.section==0) {
        GoodsSpecModel *model=[specListArray objectAtIndex:indexPath.row];
        NSArray *propertyArray=model.property;
        UILabel *namelalel=[LJControl labelFrame:CGRectMake(10,10, ScreenFrame.size.width-20, 20) setText:model.name setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0X4e4e4e) textAlignment:NSTextAlignmentLeft];
        [cell.contentView addSubview:namelalel];
        for (int i=0; i<propertyArray.count; i++) {
            NSInteger x=(ScreenFrame.size.width/3)*(i%3);
            NSInteger y=50*(i/3)+35;
            NSInteger w=(ScreenFrame.size.width/3);
            NSInteger h=50;
            UIView *bgView=[LJControl viewFrame:CGRectMake(x, y, w, h) backgroundColor:[UIColor whiteColor]];
            [cell.contentView addSubview:bgView];
            FlayButton *button = [FlayButton buttonWithType:UIButtonTypeCustom];
            button.section=indexPath.section;
            button.row=indexPath.row;
            button.theFew=i;
            button.frame = CGRectMake(5,7, w-10,30);
            NSDictionary *diction=[propertyArray objectAtIndex:i];
            if([model.type isEqualToString:@"text"]||[model.type isEqualToString:@"img"]){
                UILabel *label=[LJControl labelFrame:CGRectMake(0,0,w-10, 30) setText:[diction objectForKey:@"value"]setTitleFont:13 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0X4e4e4e) textAlignment:NSTextAlignmentCenter];
                label.tag=1000;
                [label.layer setMasksToBounds:YES];
                [label.layer  setCornerRadius:6.0];
                [label.layer setBorderWidth:1];
                [label.layer setBorderColor:[UIColorFromRGB(0Xe2e2e2) CGColor]];
                [button addSubview:label];
            }else if ([model.type isEqualToString:@"img"]){
                UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, w-10, 30)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:[diction objectForKey:@"value"]]];
                imageView.tag=2000;
                [imageView.layer setMasksToBounds:YES];
                [imageView.layer  setCornerRadius:6.0];
                [imageView.layer setBorderWidth:1];
                [imageView.layer setBorderColor:[UIColorFromRGB(0Xe2e2e2) CGColor]];
                [button addSubview:imageView];
            }
            [button addTarget:self action:@selector(spcClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:button];
            
            //刷新选中的specList
            NSMutableArray *seleArray=[specSeleArray objectAtIndex:indexPath.row];
            NSString  *string=[NSString stringWithFormat:@"%@",[diction objectForKey:@"id"]];
            for (NSString *str in seleArray) {
                if ([string isEqualToString:str ]) {
                    button.selected=YES;
                    UILabel *label=[button viewWithTag:1000];
                    [label.layer setBorderColor:[UIColorFromRGB(0X2196f3) CGColor]];
                    label.textColor=UIColorFromRGB(0X2196f3);
                }
            }
            
        }
        return cell;
    }else if (indexPath.section==1){
        GoodsSpecModel *model=[colorSpecListArray objectAtIndex:indexPath.row];
        NSArray *propertyArray=model.property;
        UILabel *namelalel=[LJControl labelFrame:CGRectMake(10, 10, ScreenFrame.size.width-20, 20) setText:model.name setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0X4e4e4e) textAlignment:NSTextAlignmentLeft];
        [cell.contentView addSubview:namelalel];
        for (int i=0; i<propertyArray.count; i++) {
            NSInteger x=(ScreenFrame.size.width/3)*(i%3);
            NSInteger y=50*(i/3)+35;
            NSInteger w=(ScreenFrame.size.width/3);
            NSInteger h=50;
            UIView *bgView=[LJControl viewFrame:CGRectMake(x, y, w, h) backgroundColor:[UIColor whiteColor]];
            [cell.contentView addSubview:bgView];
            FlayButton *button = [FlayButton buttonWithType:UIButtonTypeCustom];
            button.section=indexPath.section;
            button.row=indexPath.row;
            button.theFew=i;
            button.frame = CGRectMake(5,7, w-10,30);
            NSDictionary *diction=[propertyArray objectAtIndex:i];
            if([model.type isEqualToString:@"text"]||[model.type isEqualToString:@"img"]){
                UILabel *label=[LJControl labelFrame:CGRectMake(0,0,w-10, 30) setText:[diction objectForKey:@"value"]setTitleFont:13 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0X4e4e4e) textAlignment:NSTextAlignmentCenter];
                label.tag=1000;
                [label.layer setMasksToBounds:YES];
                [label.layer  setCornerRadius:6.0];
                [label.layer setBorderWidth:1];
                [label.layer setBorderColor:[UIColorFromRGB(0Xe2e2e2) CGColor]];
                [button addSubview:label];
            }else if ([model.type isEqualToString:@"img"]){
                UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, w-10, 40)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:[diction objectForKey:@"value"]]];
                imageView.tag=2000;
                [imageView.layer setMasksToBounds:YES];
                [imageView.layer  setCornerRadius:6.0];
                [imageView.layer setBorderWidth:1];
                [imageView.layer setBorderColor:[UIColorFromRGB(0Xe2e2e2) CGColor]];
                [button addSubview:imageView];
            }
            [button addTarget:self action:@selector(spcClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:button];
            
            
            //刷新选中的specList
            NSMutableArray *seleArray=[colorSpecSeleArray objectAtIndex:indexPath.row];
            NSString  *string=[NSString stringWithFormat:@"%@",[diction objectForKey:@"id"]];
            for (NSString *str in seleArray) {
                if ([string isEqualToString:str ]) {
                    button.selected=YES;
                    UILabel *label=[button viewWithTag:1000];
                    [label.layer setBorderColor:[UIColorFromRGB(0X2196f3) CGColor]];
                    label.textColor=UIColorFromRGB(0X2196f3);
                }
            }
        }
        return cell;

    
    }else if (indexPath.section==2){
        SpecDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpecDetailCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SpecDetailCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        cell.delegate=self;
        GoodsSpecModel *model=[specDetailArray objectAtIndex:indexPath.row];
        cell.nameLabell.text=model.detailValue;
        cell.nameLabell.numberOfLines=2;
        cell.priceTextField.text=model.price;
        cell.priceTextField.keyboardType=UIKeyboardTypeNumberPad;
        cell.priceTextField.tag=indexPath.row*1000+1;
        cell.priceTextField.delegate=self;

        cell.countTextField.text=model.count;
        cell.countTextField.keyboardType=UIKeyboardTypeNumberPad;
        cell.countTextField.tag=indexPath.row*1000+2;
        cell.countTextField.delegate=self;

        return cell;
    }
     return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section==2){
        UIView *bgView=[LJControl viewFrame:CGRectMake(0, 0, ScreenFrame.size.width,40) backgroundColor:[UIColor whiteColor]];
        if (specDetailArray.count>0) {
            UILabel *title=[LJControl labelFrame:CGRectMake(10,10, ScreenFrame.size.width-90, 20) setText:@"价格/库存" setTitleFont:17 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0X4e4e4e) textAlignment:NSTextAlignmentLeft];
            title.numberOfLines=2;
            [bgView addSubview:title];
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(ScreenFrame.size.width-70, 10, 60, 20);
            UILabel *label=[LJControl labelFrame:CGRectMake(0,0,60, 20) setText:@"批量设定" setTitleFont:15 setbackgroundColor:[UIColor clearColor] setTextColor:UIColorFromRGB(0X4e4e4e) textAlignment:NSTextAlignmentCenter];
            [button addSubview:label];
            [button addTarget:self action:@selector(uniformConfiguration) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:button];
              return bgView;
        }else{
            return nil;
        }

    }
    
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
     if (section==2) {
        if (specDetailArray.count>0) {
            return 40;
        }else{
            return 0.001;
        }
    }
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *bgView=[LJControl viewFrame:CGRectMake(0, 0, ScreenFrame.size.width, 20) backgroundColor:UIColorFromRGB(0XF5F5F5)];
    return bgView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        if (colorSpecListArray.count>0) {
              return 20.00;
        }else{
            return 0.001;
        }
    }
    if (section==1) {
        if (specDetailArray.count>0) {
            if ([_speFlay integerValue]==0) {
               return 0.001;
            }else if ([_speFlay integerValue]==1){
                return 20.00;
            }
            return 20.00;
        }else{
            return 0.001;
        }
    }
    if (section==2) {
        return 0.01;
    }
    return 0.0001;
}
#pragma mark- 点击事件
-(void)getgoodsSpecificationHoldGoodsId:(NSString *)goodsId andspecDetailArray:(NSArray *)goodsInventoryDetail{
    [MyObject startLoading];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SELLER_URL,GOODS_SPECIFICATIONHOLD_URL];
    NSMutableArray *mArray=[[NSMutableArray alloc]init];
    for (GoodsSpecModel *model in goodsInventoryDetail) {
        NSDictionary *dict=[[NSDictionary alloc]initWithObjects:@[model.count,model.detailId,model.price,model.supp] forKeys:@[@"count",@"id",@"price",@"supp"]];
        [mArray addObject:dict];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *par = @{
                          @"user_id":[MyNetTool currentUserID],
                          @"token":[MyNetTool currentToken],
                          @"goods_id":goodsId,
                          @"goods_inventory_detail":jsonString
                          };
    [myAfnetwork netWorkingURL:urlStr parameters:par andWay:@"post" getParseSuccess:^(myselfParse *parse) {
        NSDictionary *dicBig=parse.dicBig;
        NSLog(@"%@",parse.dicBig);
        if ([[dicBig objectForKey:@"ret"]integerValue]==100) {
            [MyObject failedPrompt:@"保存成功"];
        }else{
            [MyObject failedPrompt:@"保存失败，请检查配置"];
        }
        [MyObject endLoading];
    }getParsefailure:^{
        [MyObject failedPrompt:@"网络这在开小差"];
        [MyObject endLoading];
    }];
}

-(void)overBtn{
//保存
    NSMutableArray *allseleArray=[[NSMutableArray alloc]init];
    for (NSArray *array in colorSpecSeleArray) {
        if (array.count>0) {
            [allseleArray addObject:array];
        }
    }
    for (NSArray *array in specSeleArray) {
        if (array.count>0) {
            [allseleArray addObject:array];
        }
    }
    NSMutableArray *goodsSpecIds=[[NSMutableArray alloc]init];
    for (NSArray *array in allseleArray) {
        for (NSString *idStr in array) {
             [goodsSpecIds addObject:idStr];
        }
    }
    NSMutableArray *specValues=(NSMutableArray *)[self getSelectSpecValuesArray:goodsSpecIds];
    
    NSMutableArray *goodsSpecIdValues=[[NSMutableArray alloc]init];
    for (int i=0; i<goodsSpecIds.count; i++) {
        NSString *str=[NSString stringWithFormat:@"%@:%@",[goodsSpecIds objectAtIndex:i],[specValues objectAtIndex:i]];
        [goodsSpecIdValues addObject:str];
    }
    
    NSMutableArray *goodsInventoryDetails=[[NSMutableArray alloc]init];
    for (GoodsSpecModel *model in specDetailArray) {
        NSDictionary *dict=[[NSDictionary alloc]initWithObjects:@[model.count,model.detailId,model.price,model.supp] forKeys:@[@"count",@"id",@"price",@"supp"]];
        [goodsInventoryDetails addObject:dict];
    }
    
    [self.delegate getGoodsEditDetailsData:goodsSpecIds andGoodsSpecIdValue:goodsSpecIdValues andGoodsInventoryDetail:goodsInventoryDetails];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)uniformConfiguration{
//批量设定
    semiTransparentView.hidden=NO;
    specifView.hidden=NO;
}
-(void)spcClick:(FlayButton *)btn{
//点击按钮
    GoodsSpecModel *model;
    if (btn.section==0) {
        model=[specListArray objectAtIndex:btn.row];
    }else{
        model=[colorSpecListArray objectAtIndex:btn.row];
    }
    NSArray *propertyArray=model.property;
    NSDictionary *dict=[propertyArray objectAtIndex:btn.theFew];
    UILabel *label=[btn viewWithTag:1000];
    btn.selected=!btn.selected;
    if (btn.selected) {
        [label.layer setBorderColor:[UIColorFromRGB(0X2196f3) CGColor]];
        label.textColor=UIColorFromRGB(0X2196f3);
        if (btn.section==0) {
            [[specSeleArray objectAtIndex:btn.row]addObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]]];
        }else{
           [[colorSpecSeleArray objectAtIndex:btn.row]addObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]]];
        }

    }else{
        [label.layer setBorderColor:[UIColorFromRGB(0Xe2e2e2) CGColor]];
        label.textColor=UIColorFromRGB(0X4e4e4e);
        if (btn.section==0) {
            [[specSeleArray objectAtIndex:btn.row]removeObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]]];
        }else{
            [[colorSpecSeleArray objectAtIndex:btn.row]removeObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]]];
        }

    }
    [self start];
}
#pragma mark -形成组合
- (void)start {
    NSMutableArray *allseleArray=[[NSMutableArray alloc]init];
    for (NSArray *array in colorSpecSeleArray) {
        if (array.count>0) {
            [allseleArray addObject:array];
        }
    }
    for (NSArray *array in specSeleArray) {
        if (array.count>0) {
            [allseleArray addObject:array];
        }
    }
    needResultArr = [NSMutableArray array];
    NSMutableArray* result = [NSMutableArray array];
    [self combine:result data:allseleArray curr:0 count:(int)allseleArray.count];
    NSLog(@"needResultArr=%@",needResultArr);
    [self getSpecDetailArray:needResultArr];
    
}
- (void)combine:(NSMutableArray *)result data:(NSArray *)data curr:(int)currIndex count:(int)count{
    if (currIndex == count) {
        [needResultArr addObject:[result mutableCopy]];
        [result removeLastObject];
        
    }else {
        NSArray* array = [data objectAtIndex:currIndex];
        for (int i = 0; i < array.count; ++i) {
            [result addObject:[array objectAtIndex:i]];
            //进入递归循环
            [self combine:result data:data curr:currIndex+1 count:count];
            if ((i+1 == array.count) && (currIndex-1>=0)) {
                [result removeObjectAtIndex:currIndex-1];
            }
        }
    }
}
#pragma mark-整理SelectDataArray数据
-(void)getSpecDetailArray:(NSMutableArray *)needResultArray{
    NSMutableArray *detailArray=[[NSMutableArray alloc]initWithArray:specDetailArray];
    
    [specDetailArray removeAllObjects];
    for (NSArray *array in needResultArray) {
        NSString *detailId=[NSString stringWithFormat:@"%@_",[array componentsJoinedByString:@"_"]];
        GoodsSpecModel *model=[[GoodsSpecModel alloc]init];
        model.code=@"0";
        model.count=@"0";
        model.detailId=detailId;
        model.detailIdArray=array;
        [self getSelectDataArray:array];
        model.detailValue=[self getSelectSpecValue:array];
        model.price=@"0";
        model.supp=@"0";
        for (GoodsSpecModel *SpecModel in detailArray) {
            if ([SpecModel.detailId isEqualToString:detailId]) {
                model.code=SpecModel.code;
                model.count=SpecModel.count;
                model.detailId=SpecModel.detailId;
                model.detailIdArray=SpecModel.detailIdArray;
                model.detailValue=SpecModel.detailValue;
                model.price=SpecModel.price;
                model.supp=SpecModel.supp;
                break;
            }
        }
        [specDetailArray addObject:model];
        
    }
    [myTableview reloadData];
}
#pragma mark -UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField.text integerValue]==0) {
        textField.text=@"";
    }
    [UIView animateWithDuration:0.00001 animations:^{
        self.view.frame=CGRectMake(0,0, ScreenFrame.size.width, ScreenFrame.size.height);
    }];
    if (textField==batchPriceTextField ||textField==batchCountTextField) {
    }else{
        NSIndexPath *indexpath=[NSIndexPath indexPathForRow:textField.tag/1000 inSection:2];
        
        if ((indexpath.section==2)&&(indexpath.row==[myTableview numberOfRowsInSection:2]-1)) {
            [myTableview scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            [UIView animateWithDuration:1 animations:^{
                self.view.frame=CGRectMake(0,-230, ScreenFrame.size.width, ScreenFrame.size.height);
            }];
        }else if((indexpath.section==2)&&(indexpath.row== [myTableview numberOfRowsInSection:2]-2)){
            [myTableview scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            [UIView animateWithDuration:1 animations:^{
                self.view.frame=CGRectMake(0,-170, ScreenFrame.size.width, ScreenFrame.size.height);
            }];
        }else{
            [myTableview scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if (textField==batchPriceTextField ) {
        if ([self isNumberField:batchPriceTextField.text textField:batchPriceTextField]) {
        }else{
            batchPriceTextField.text =@"";
        }
        
    }else if(textField==batchCountTextField){
        if ([self isNumberField:batchCountTextField.text textField:batchCountTextField]) {
        }else{
            batchCountTextField.text =@"";
        }
        
    }else{
        GoodsSpecModel *model=[specDetailArray objectAtIndex:textField.tag/1000];
        if (textField.tag%1000==1) {
            model.price=textField.text;
        }else if (textField.tag%1000==2) {
            model.count=textField.text;
        }
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==batchPriceTextField ) {
        if ([self isNumberField:batchPriceTextField.text textField:batchPriceTextField]) {
        }else{
            batchPriceTextField.text =@"";
        }
       [batchPriceTextField resignFirstResponder];
    }else if(textField==batchCountTextField){
        if ([self isNumberField:batchCountTextField.text textField:batchCountTextField]) {
        }else{
            batchCountTextField.text =@"";
        }
        [batchCountTextField resignFirstResponder];
    }else{
        [UIView animateWithDuration:1 animations:^{
            self.view.frame=CGRectMake(0,0, ScreenFrame.size.width, ScreenFrame.size.height);
            [textField resignFirstResponder];
        }];
    }
    return YES;
}
- (BOOL)isNumberField:(NSString *)phoneNumber textField:(UITextField *)textField{
    if (textField.text.length == 0) {
        return NO;
    }
    NSString *phoneRegex = @"^[0-9]*$";//判断是不是数字的正则表达式
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",phoneRegex];
    BOOL isMatch = [phoneTest evaluateWithObject:phoneNumber];
    if (!isMatch) {
        [MyObject failedPrompt:@"请输入数字"];
        return NO;
    }
    return YES;
}
#pragma mark -SpecDetailCellDelegate
-(void)getSpecDetailCell{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame=CGRectMake(0,0, ScreenFrame.size.width, ScreenFrame.size.height);
    }];
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
