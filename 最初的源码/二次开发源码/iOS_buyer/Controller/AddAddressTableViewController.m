//
//  AddAddressTableViewController.m
//  下班接着干
//
//  Created by apple2 on 15/11/18.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import "AddAddressTableViewController.h"
#import "ProvinceModel.h"
#import "CityModel.h"
#import "DistrictModel.h"
#import "NilCell.h"


@interface AddAddressTableViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong)NSArray *titleArray;
@property (nonatomic,strong)NSMutableArray *textFieldArray;
@property (nonatomic,weak)UIPickerView *pickerView;
@property (nonatomic,strong)NSMutableArray *bigArr;
@property (nonatomic,strong)NSArray *currentCities;
@property (nonatomic,strong)NSArray *currentDistricts;
@property (nonatomic,copy)NSString *areaID;
@property (nonatomic,assign)BOOL isAreaChanged;
@property (nonatomic,strong)NSMutableDictionary *tfDict;

@end

@implementation AddAddressTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tfDict = [NSMutableDictionary dictionary];
    self.isAreaChanged = NO;
    //提前获取所有城市的列表(可能有延迟)。
    [SYObject startLoading];

    [self createBackBtn];
    self.titleArray = @[@"收货人姓名",@"手机号码",@"所在区域",@"详细地址",@"邮政编码"];
    if (self.editType==SY_ADDRESS_POST_TYPE_ADD) {
        self.title = @"新增地址";
    }else if (self.editType==SY_ADDRESS_POST_TYPE_EDIT){
        self.title = @"编辑地址";
    }else{
    }
    _textFieldArray = [NSMutableArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIBarButtonItem *confirm = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(addBtnClicked:)];
    self.navigationItem.rightBarButtonItem = confirm;
    self.tableView.scrollEnabled = NO;
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getAllCitiesFromLocal];
    [self showOldData];
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

-(void)failedPrompt:(NSString *)prompt{
    [SYObject endLoading];
    [SYObject failedPrompt:prompt];
}
#pragma mark - 加载已存在的数据
-(void)showOldData{

    if (self.editType==SY_ADDRESS_POST_TYPE_EDIT){
        UITextField *nameTF = self.textFieldArray[0];
        UITextField *regionTF = self.textFieldArray[2];
        UITextField *mobileTF = self.textFieldArray[1];
        UITextField *streetTF = self.textFieldArray[3];
        UITextField *zipTF = self.textFieldArray[4];
        
        regionTF.text = self.infoArrayWhenEditing[1];
        nameTF.text = self.infoArrayWhenEditing[4];
        mobileTF.text = self.infoArrayWhenEditing[3];
        streetTF.text = self.infoArrayWhenEditing[2];
        zipTF.text = self.infoArrayWhenEditing[5];
    }else{
        return;
    }
}
#pragma mark - 安全判断
- (BOOL)isMobileField:(NSString *)phoneNumber
{
    UITextField *mobileTF = self.textFieldArray[1];
    if (mobileTF.text.length == 0) {
        return YES;
    }
    NSString *phoneRegex = @"^1\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",phoneRegex];
    
    BOOL isMatch = [phoneTest evaluateWithObject:phoneNumber];
    if (!isMatch) {
        mobileTF.text = 0;
        return NO;
    }
    
    return YES;
}
-(BOOL)isZipField:(UITextField *)zipTF
{
    if (zipTF.text.length == 0) {
        return YES;
    }
    else{
        NSString *zipRegex = @"[1-9]\\d{5}(?!\\d)";
        NSPredicate *zipTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",zipRegex];
        BOOL isMatch = [zipTest evaluateWithObject:zipTF.text];
        if (!isMatch) {
            zipTF.clearsOnInsertion = YES;
            zipTF.text = 0;
            return NO;
        }
    }
    return YES;
}
-(BOOL)isAvailableTextField:(UITextField *)textField{
    if (textField.text==nil||[textField.text isEqualToString:@""]) {
        return NO;
    }
    return YES;
}
#pragma mark - 用地区名(三级)取得地区的id
-(NSString *)getDistrictIDByName:(NSString *)dName{
    for (ProvinceModel *pModel in self.bigArr) {
        NSArray *arr1 = pModel.cityArray;
        for (CityModel *cModel in arr1) {
            NSArray *arr2 = cModel.districtArray;
            for (DistrictModel *dModel in arr2) {
                if ([dModel.dName isEqualToString:dName]) {
                    return dModel.dID;
                }
            }
        }
    }
    return nil;
}
#pragma mark - 网络请求
-(void)postCreateRequest{
    
}
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    int statuscode2 = [request responseStatusCode];
    //code 500
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"新建收货人3332 :%@",dicBig);
        if ([[dicBig objectForKey:@"verify"] isEqualToString:@"true"]) {
            //成功保存
            [self failedPrompt:@"新建地址成功"];
           [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self failedPrompt:@"新建地址失败"];
        }
        
        
    }
    
}
-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{
    [SYObject endLoading];
    [self failedPrompt:@"网络请求失败"];
}
#pragma mark - 获取所有城市列表
-(void)getAllCitiesFromLocal{
    
    NSMutableArray *bigArr = [NSMutableArray array];
    self.bigArr = bigArr;
    NSString *path = [[NSBundle mainBundle]pathForResource:@"province" ofType:@"plist"];
    
    NSString *path1 = [[NSBundle mainBundle]pathForResource:@"cities" ofType:@"plist"];
    NSDictionary *dictCities = [NSDictionary dictionaryWithContentsOfFile:path1];
    
    NSString *path2 = [[NSBundle mainBundle]pathForResource:@"districts" ofType:@"plist"];
    NSDictionary *dictDistricts = [NSDictionary dictionaryWithContentsOfFile:path2];
    
    NSArray *arrProv = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *dict2 in arrProv) {
        ProvinceModel *pModel = [[ProvinceModel alloc]init];
        pModel.pID = dict2[@"id"];
        pModel.pName = dict2[@"name"];
        NSMutableArray *cArray = [NSMutableArray array];
        pModel.cityArray = cArray;
        [bigArr addObject:pModel];
        
        NSString *key1 = [NSString stringWithFormat:@"%@",pModel.pID];
        NSArray *citys = [dictCities valueForKey:key1];
        
        for (NSDictionary *dict4 in citys) {
            CityModel *cModel = [[CityModel alloc]init];
            cModel.cName = dict4[@"name"];
            cModel.cID = dict4[@"id"];
            NSMutableArray *dArray = [NSMutableArray array];
            cModel.districtArray = dArray;
            [cArray addObject:cModel];
            
            NSString *key2 = [NSString stringWithFormat:@"%@",cModel.cID];
            NSArray *districs = [dictDistricts valueForKey:key2];
            
            for (NSDictionary *dict6 in districs) {
                DistrictModel *dModel = [[DistrictModel alloc]init];
                dModel.dName = dict6[@"name"];
                dModel.dID = dict6[@"id"];
                [dArray addObject:dModel];
            }
        }
    }
    //加载完毕
    [SYObject endLoading];
    if (self.editType==SY_ADDRESS_POST_TYPE_ADD) {
        [self setDefaultCities];
    }else if (self.editType==SY_ADDRESS_POST_TYPE_EDIT){
        [self.pickerView reloadAllComponents];
    }
}

#pragma mark - 设置初始化城市
-(void)setDefaultCities{
    ProvinceModel *pModel1 = self.bigArr[0];
    self.currentCities = pModel1.cityArray;
    CityModel *cModel1 = pModel1.cityArray[0];
    self.currentDistricts = cModel1.districtArray;
    DistrictModel *dModel1 = cModel1.districtArray[0];
    self.areaID = dModel1.dID;
    [self.pickerView reloadAllComponents];
    [self setRegionText];
}
#pragma mark - 确认提交数据
-(void)addBtnClicked:(id)sender{
    UITextField *nameTF;// = self.textFieldArray[0];
    UITextField *mobileTF;// = self.textFieldArray[1];
    UITextField *addressTF;// = self.textFieldArray[3];
    UITextField *zipTF;// = self.textFieldArray[4];
    for (UITextField *tf in self.textFieldArray) {
        if (tf.tag == 0) {
            nameTF = tf;
        }else if (tf.tag == 1){
            mobileTF = tf;
        }else if (tf.tag == 3){
            addressTF = tf;
        }else if (tf.tag == 4){
            zipTF = tf;
        }
    }
    
    NSInteger thirdIndex = [self.pickerView selectedRowInComponent:2];
    if (self.editType==SY_ADDRESS_POST_TYPE_EDIT&&!_isAreaChanged) {
        //编辑且没有更改城市
        NSString *area = self.infoArrayWhenEditing[1];
        NSArray *arr = [area componentsSeparatedByString:@","];
        NSString *dName = [arr lastObject];
        NSString *dID =  [self getDistrictIDByName:dName];
        self.areaID = dID;
    }else{
        DistrictModel *dModel = self.currentDistricts[thirdIndex];
        NSString *areaID = dModel.dID;
        self.areaID = areaID;
    }
    //安全判定
    if (![self isAvailableTextField:nameTF]) {
        [SYObject failedPrompt:@"请输入收货人姓名"];
        return;
    }
    if (![self isMobileField:mobileTF.text]||[mobileTF.text isEqualToString:@""]) {
        [SYObject failedPrompt:@"请输入正确的手机号码"];
        return;
    }

    if (![self isAvailableTextField:addressTF]||[addressTF.text isEqualToString:@""]) {
        [SYObject failedPrompt:@"请输入具体地址"];
        return;
    }
    if(![self isZipField:zipTF]) {
        [SYObject failedPrompt:@"请输入正确的邮编"];
        return;
    }
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath2 = [documentsPath stringByAppendingPathComponent:@"information.txt"];
    NSArray *fileContent2 = [[NSArray alloc] initWithContentsOfFile:readPath2];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,ADDNEW]];
    ASIFormDataRequest * requestAddManage1;
    requestAddManage1 = [ASIFormDataRequest requestWithURL:url];
    [requestAddManage1 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [requestAddManage1 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    [requestAddManage1 setPostValue:zipTF.text forKey:@"zip"];
    [requestAddManage1 setPostValue:self.areaID forKey:@"area_id"];
    [requestAddManage1 setPostValue:@"" forKey:@"mobile"];
    [requestAddManage1 setPostValue:addressTF.text forKey:@"area_info"];
    [requestAddManage1 setPostValue:mobileTF.text forKey:@"telephone"];
    [requestAddManage1 setPostValue:nameTF.text forKey:@"trueName"];
    if (self.editType==SY_ADDRESS_POST_TYPE_EDIT) {
        //修改
        NSString *addr_id = self.infoArrayWhenEditing[0];
        [requestAddManage1 setPostValue:addr_id forKey:@"addr_id"];
    }
    
    [requestAddManage1 setRequestHeaders:[LJControl requestHeaderDictionary]];
    requestAddManage1.tag = 101;
    [requestAddManage1 setDelegate: self];
    [requestAddManage1 setDidFailSelector:@selector(my1_urlRequestFailed:)];
    [requestAddManage1 setDidFinishSelector:@selector(my1_urlRequestSucceeded:)];
    [requestAddManage1 startAsynchronous];
    [self failedPrompt:@"正在提交..."];
    [SYObject startLoading];
}
#pragma mark - Table view 数据源和代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[SYObject new] cellHeight];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseId = @"reuseId";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];

    SYObject *line = [[SYObject alloc]init];
    UIView *view = [line addAddressLineViewWithTitle:_titleArray[indexPath.row]];
    [cell addSubview:view];
    [_textFieldArray addObject:line.textField];
    line.textField.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    line.textField.delegate = self;
    if(indexPath.row==1){
        line.textField.keyboardType = UIKeyboardTypeNumberPad;
        
        WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"" leftTarget:self leftAction:@selector(dismissKeyBoard) rightTitle:@"完成" rightTarget:self rightAction:@selector(dismissKeyBoard1)];
        [line.textField setInputAccessoryView:inputView];
        
//        UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 44)];
//        [topView setBarStyle:UIBarStyleBlack];
//        UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];// UIBarButtonItemStyleBordered
//        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard1)];
//        NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
//        [topView setItems:buttonsArray];
//        [line.textField setInputAccessoryView:topView];
    }
    if (indexPath.row==2) {
        //所在区域
        line.textField.backgroundColor = [UIColor whiteColor];
        line.arrow.hidden = YES;
        UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 460.f/667.f*ScreenFrame.size.height, ScreenFrame.size.width, 207.f/667.f*ScreenFrame.size.height)];
        line.textField.inputView = pickerView;
        
        pickerView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1.0];
        
        pickerView.delegate = self;
        pickerView.dataSource = self;
        self.pickerView = pickerView;
    }
    if (indexPath.row==3) {
        //所在街道
        line.textField.backgroundColor = [UIColor whiteColor];
        line.arrow.hidden = YES;
    }
    if (indexPath.row==4) {
        //邮编
        line.textField.keyboardType = UIKeyboardTypeNumberPad;
        WDInputView *inputView=[[WDInputView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 34) leftTitle:@"" leftTarget:self leftAction:@selector(dismissKeyBoard) rightTitle:@"完成" rightTarget:self rightAction:@selector(dismissKeyBoard)];
        [line.textField setInputAccessoryView:inputView];
        
//        UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, 44)];
//        [topView setBarStyle:UIBarStyleBlack];
//        UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];// UIBarButtonItemStyleBordered
//        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
//        NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
//        [topView setItems:buttonsArray];
//        [line.textField setInputAccessoryView:topView];
    }
    if (self.editType==SY_ADDRESS_POST_TYPE_ADD&&indexPath.row==4) {
        line.textField.placeholder = @"(选填)";
    }else if (self.editType==SY_ADDRESS_POST_TYPE_EDIT&&indexPath.row==5){
        line.textField.placeholder = @"(选填)";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger index = indexPath.row;
    NSString *text = [self.tfDict valueForKey:[NSString stringWithFormat:@"%lu",(unsigned long)index]];
    line.textField.text = text;
    
    return cell;
}
-(void)dismissKeyBoard{
    UITextField *zipTF = self.textFieldArray[4];
    [zipTF resignFirstResponder];
}
-(void)dismissKeyBoard1{
    UITextField *zipTF = self.textFieldArray[1];
    [zipTF resignFirstResponder];
}
#pragma mark - textField代理方法
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSInteger index = textField.tag;
    [self.tfDict setValue:textField.text forKey:[NSString stringWithFormat:@"%lu",(unsigned long)index]];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSInteger index2 = [self.textFieldArray indexOfObject:textField]+1;
    
    if (index2<self.textFieldArray.count) {
        UITextField *newTF = self.textFieldArray[index2];
        [textField resignFirstResponder];
        [textField endEditing:YES];
        [newTF becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
    }

    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([self.textFieldArray indexOfObject:textField]==2) {
        [self setDefaultCities];
    }
    return YES;
}
#pragma mark - Picker View 数据源和代理方法
-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:15.f],NSForegroundColorAttributeName:_K_Color(147, 147, 147)};
    if (component==0) {
        ProvinceModel *pModel = self.bigArr[row];
        NSAttributedString *str = [[NSAttributedString alloc]initWithString:pModel.pName attributes:attr];
        return str;
    }else if (component==1){
        CityModel *cModel = self.currentCities[row];
        NSAttributedString *str = [[NSAttributedString alloc]initWithString:cModel.cName attributes:attr];
        return str;
    }else if (component==2){
        DistrictModel *dModel = self.currentDistricts[row];
        NSAttributedString *str = [[NSAttributedString alloc]initWithString:dModel.dName attributes:attr];
        return str;
    }else{
        NSAttributedString *str = [[NSAttributedString alloc]initWithString:@"" attributes:attr];
        return str;
    }
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component==0){
        return self.bigArr.count;
    }else if (component==1){
        return self.currentCities.count;
    }else if (component==2){
        return self.currentDistricts.count;
    }else{
        return 0;
    }
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component==0) {
        ProvinceModel *pModel = self.bigArr[row];
        self.currentCities = pModel.cityArray;
        CityModel *cModel = pModel.cityArray[0];
        self.currentDistricts = cModel.districtArray;
        [self.pickerView reloadAllComponents];
    }else if (component==1){
        CityModel *cModel = self.currentCities[row];
        self.currentDistricts = cModel.districtArray;
        [self.pickerView reloadAllComponents];
    }else if (component==2){
    }else{
    }
    [self setRegionText];
    self.isAreaChanged = YES;
}
#pragma mark - 设置地区选择文本
-(void)setRegionText{
    NSInteger row1 = [self.pickerView selectedRowInComponent:0];
    NSInteger row2 = [self.pickerView selectedRowInComponent:1];
    NSInteger row3 = [self.pickerView selectedRowInComponent:2];
    ProvinceModel *model1 = self.bigArr[row1];
    CityModel *model2 = self.currentCities[row2];
    DistrictModel *model3 = self.currentDistricts[row3];
    UITextField *regionTF = self.textFieldArray[2];
    regionTF.text = [NSString stringWithFormat:@"%@,%@,%@",model1.pName,model2.cName,model3.dName];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
