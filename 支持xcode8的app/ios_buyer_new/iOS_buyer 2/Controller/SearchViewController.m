//
//  SearchViewController.m
//  My_App
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "SearchViewController.h"
#import "SecondViewController.h"
#import "Seconde_sub2ViewController.h"
#import "searchCell.h"

@interface SearchViewController ()<UIGestureRecognizerDelegate>

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"搜索";
    }
    return self;
}
//-(void)failedPrompt:(NSString *)prompt{
//    labelTi.hidden = NO;
//    labelTi.text = prompt;
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
//}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    
    
    if (_MyTextField.text.length ==0) {
        [SYObject failedPrompt:@"搜索内容不能为空"];
    }else{
        //做页面跳转
        [_MyTextField resignFirstResponder];
        if ([_MyTextField.text isEqualToString:@"dev"]) {
            NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
            [d setObject:@"0" forKey:@"yy"];//不隐藏
            [d synchronize];
        }
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"search.txt"];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        if([fileManagerDong fileExistsAtPath:filePathDong] == NO){
            //新建文件
            NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
            NSString *filePaht = [documentsPath stringByAppendingPathComponent:@"search.txt"];
            NSArray *array = [NSArray arrayWithObjects:_MyTextField.text, nil];
            [array writeToFile:filePaht atomically:NO];
        }else{
            //将数据保存到文件里面 先判断里面是否已经存在 若存在则不添加
            NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"search.txt"];
            NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
            BOOL cunzai = NO;
            NSString *str = [fileContent2 objectAtIndex:0];
            NSArray *arr = [str componentsSeparatedByString:@","];
            for(NSString *str2 in arr){
                if ([str2 isEqualToString:_MyTextField.text]) {
                    cunzai = YES;
                }
            }
            if (cunzai == YES) {
                
            }else{
                NSString *str2 = [NSString stringWithFormat:@"%@,%@",_MyTextField.text,[fileContent2 objectAtIndex:0]];
                NSArray *array = [NSArray arrayWithObjects:str2, nil];
                [array writeToFile:readPath2 atomically:NO];
                [MyTableView reloadData];
            }
        }
        SecondViewController *thire = [SecondViewController sharedUserDefault];
        thire.searchKeyword = _MyTextField.text;
        thire.sub_title2 = [NSString stringWithFormat:@"%@",_MyTextField.text];
        thire.sub_id2 = @"search";
        Seconde_sub2ViewController *sub = [[Seconde_sub2ViewController alloc]init];
        [self.navigationController pushViewController:sub animated:YES];
    }
    return YES;
}
#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == MyTableView) {
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"search.txt"];
        NSFileManager *fileManagerDong = [NSFileManager defaultManager];
        if([fileManagerDong fileExistsAtPath:filePathDong] == NO){
            //新建文件
            return 0;
        }else{
            //将数据保存到文件里面 先判断里面是否已经存在 若存在则不田间
            NSArray *arr = [[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"search.txt"]] objectAtIndex:0] componentsSeparatedByString:@","];
            return arr.count;
        }
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 32;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    searchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"searchCell" owner:self options:nil] lastObject];
    }
    if (indexPath.row == 0) {
        
    }
    NSArray *arr = [[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"search.txt"]] objectAtIndex:0] componentsSeparatedByString:@","];
    [cell setData:[arr objectAtIndex:indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = [[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"search.txt"]] objectAtIndex:0] componentsSeparatedByString:@","];
    
    [_MyTextField resignFirstResponder];
    
    if ([_MyTextField.text isEqualToString:@"dev"]) {
        NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
        [d setObject:@"0" forKey:@"yy"];//不隐藏
        [d synchronize];
    }
    
    SecondViewController *thire = [SecondViewController sharedUserDefault];
    thire.searchKeyword = [arr objectAtIndex:indexPath.row];
    thire.sub_title2 = [NSString stringWithFormat:@"%@",[arr objectAtIndex:indexPath.row]];
    thire.sub_id2 = @"search";
    Seconde_sub2ViewController *sub = [[Seconde_sub2ViewController alloc]init];
    [self.navigationController pushViewController:sub animated:YES];
}

-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
    _MyTextField.text = @"";
}
-(void)createTopView{
    
    WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"取消" leftTarget:self leftAction:@selector(dismissKeyBoard) rightTitle:@"完成" rightTarget:self rightAction:@selector(dismissKeyBoard)];
    [_MyTextField setInputAccessoryView:inputView];
    
    
    searchBtn.tag = 101;
    [searchBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)dismissKeyBoard{
    [_MyTextField resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    NSArray *arr = [[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"search.txt"]] objectAtIndex:0] componentsSeparatedByString:@","];
    if (arr.count == 0) {
        nothingView.hidden = NO;
        MyTableView.hidden = YES;
    }else{
        MyTableView.hidden = NO;
        nothingView.hidden = YES;
    }
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [MyTableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
}
#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    NSLog(@"viewControllers==%@",self.navigationController.viewControllers);
    if (self.navigationController.viewControllers.count == 1){  //关闭主界面的右滑返回
        return NO;
    }else{
        
        return YES;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"搜索";
    
    [self createTopView];
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    
    _MyTextField.delegate = self;
    
    MyTableView.delegate = self;
    MyTableView.dataSource=  self;
    MyTableView.showsVerticalScrollIndicator=NO;
    MyTableView.showsHorizontalScrollIndicator = NO;
    
    clearHistoryBtn.tag = 103;
    [clearHistoryBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
//    [labelTi.layer setMasksToBounds:YES];
//    [labelTi.layer setCornerRadius:4.0];
//    labelTi.hidden = YES;
    
    NSArray *arr = [[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"search.txt"]] objectAtIndex:0] componentsSeparatedByString:@","];
    if (arr.count == 0) {
        nothingView.hidden = NO;
        MyTableView.hidden = YES;
    }else{
        MyTableView.hidden = NO;
        nothingView.hidden = YES;
    }
    
    [bottomLabel.layer setMasksToBounds:YES];
    [bottomLabel.layer setCornerRadius:4];
}

- (IBAction)btnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 101) {
        if (_MyTextField.text.length ==0) {
            [SYObject failedPrompt:@"搜索内容不能为空"];
        }else{
            //做页面跳转
            [_MyTextField resignFirstResponder];
            
            if ([_MyTextField.text isEqualToString:@"dev"]) {
                NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
                [d setObject:@"0" forKey:@"yy"];//不隐藏
                [d synchronize];
            }
            
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            NSString *filePathDong=[documentsPath stringByAppendingPathComponent:@"search.txt"];
            NSFileManager *fileManagerDong = [NSFileManager defaultManager];
            if([fileManagerDong fileExistsAtPath:filePathDong] == NO){
                //新建文件
                NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                NSString *filePaht = [documentsPath stringByAppendingPathComponent:@"search.txt"];
                NSArray *array = [NSArray arrayWithObjects:_MyTextField.text, nil];
                [array writeToFile:filePaht atomically:NO];
            }else{
                //将数据保存到文件里面 先判断里面是否已经存在 若存在则不田间
                NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"search.txt"];
                NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
                BOOL cunzai = NO;
                NSString *str = [fileContent2 objectAtIndex:0];
                NSArray *arr = [str componentsSeparatedByString:@","];
                for(NSString *str2 in arr){
                    if ([str2 isEqualToString:_MyTextField.text]) {
                        cunzai = YES;
                    }
                }
                if (cunzai == YES) {
                    
                }else{
                    NSString *str2 = [NSString stringWithFormat:@"%@,%@",_MyTextField.text,[fileContent2 objectAtIndex:0]];
                    NSArray *array = [NSArray arrayWithObjects:str2, nil];
                    [array writeToFile:readPath2 atomically:NO];
                    [MyTableView reloadData];
                }
            }
            SecondViewController *thire = [SecondViewController sharedUserDefault];
            thire.searchKeyword = _MyTextField.text;
            thire.sub_title2 = [NSString stringWithFormat:@"%@",_MyTextField.text];
            thire.sub_id2 = @"search";
            Seconde_sub2ViewController *sub = [[Seconde_sub2ViewController alloc]init];
            [self.navigationController pushViewController:sub animated:YES];
        }
    }
    if (btn.tag == 103) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *MapLayerDataPath2 = [documentsDirectory stringByAppendingPathComponent:@"search.txt"];
        BOOL bRet2 = [fileMgr fileExistsAtPath:MapLayerDataPath2];
        if (bRet2) {
            NSError *err;
            [fileMgr removeItemAtPath:MapLayerDataPath2 error:&err];
        }
        NSArray *arr = [[[[NSArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"search.txt"]] objectAtIndex:0] componentsSeparatedByString:@","];
        if (arr.count == 0) {
            nothingView.hidden = NO;
            MyTableView.hidden = YES;
        }else{
            MyTableView.hidden = NO;
            nothingView.hidden = YES;
        }
        
        [MyTableView reloadData];
    }
    if (btn.tag == 110) {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc {
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    MyTableView = nil;
    _selectLabel = nil;
    
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
