//
//  addressListViewController.m
//  My_App
//
//  Created by apple on 15/8/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "addressListViewController.h"
#import "addressListCell.h"
#import <AddressBook/AddressBook.h>
#import "addressListModel.h"
#import "DemoSectionItemSubclass.h"
#import "pinyin.h"
#import "rechargeViewController.h"
#import "AppDelegate.h"

#define kSectionSelectorWidth 45

@interface addressListViewController ()

@end

@implementation addressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
    }
    MyTableView.delegate = self;
    MyTableView.dataSource = self;
    
    _selectionView = [[CHSectionSelectionView alloc] init];
    _selectionView.frame = CGRectMake(0, 0, 30, self.view.bounds.size.height-200);
    _selectionView.backgroundColor = [UIColor whiteColor];
    _selectionView.dataSource = self;
    _selectionView.delegate = self;
    _selectionView.showCallouts = YES;
    _selectionView.calloutPadding = 20;
    _selectionView.backgroundColor = [UIColor redColor];
    [rightView addSubview:_selectionView];
    
    [cancelBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    addressListArray = [[NSMutableArray alloc]init];
    Vcardarray = [[NSMutableArray alloc]init];
    
    [self addressList];
}
-(void)addressList{
    if (addressListArray.count !=0 ) {
        [addressListArray removeAllObjects];
    }
    if (Vcardarray.count !=0 ) {
        [Vcardarray removeAllObjects];
    }
    NSMutableDictionary*dic;
    AppDelegate *app =  (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //获得Vcard
    dic= (NSMutableDictionary*)app.addressListDic;
    //获得序列索引
    NSArray *arr = app.addressVCard;
    for(int i=0;i<arr.count;i++){
        NSString *str = [[arr objectAtIndex:i] uppercaseString];
        [Vcardarray addObject:str];
    }
    
    for(int i=0;i<arr.count;i++){
        NSArray *arraySub = [dic objectForKey:[arr objectAtIndex:i]];
        NSMutableArray *arraySub2 = [[NSMutableArray alloc]init];
        for(NSDictionary *dic in arraySub){
            addressListModel *list = [[addressListModel alloc]init];
            if([[dic objectForKey:@"first"] isEqualToString:@" "]){
                list.lastName = [dic objectForKey:@"last"];
            }else {
                list.lastName = [dic objectForKey:@"first"];
            }
            list.tmpPhoneIndex = [dic objectForKey:@"telphone"];
            [arraySub2 addObject:list];
        }
        [addressListArray addObject:arraySub2];
    }
    [_selectionView reloadSections];
}

-(void)backBtnClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - SectionSelectionView DataSource

// Tell the datasource how many sections we have - best is to forward to the tableviews datasource
-(NSInteger)numberOfSectionsInSectionSelectionView:(CHSectionSelectionView *)sectionSelectionView
{
    return [MyTableView.dataSource numberOfSectionsInTableView:MyTableView];
}

// Create a nice callout view so that you see whats selected when
// your finger covers the sectionSelectionView
-(UIView *)sectionSelectionView:(CHSectionSelectionView *)selectionView callOutViewForSelectedSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    
    label.frame = CGRectMake(0, 0, 80, 80); // you MUST set the size of the callout in this method
    
    // do some ui stuff
    
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [UIColor redColor];
    label.font = [UIFont boldSystemFontOfSize:40];
    label.text = [MyTableView.dataSource tableView:MyTableView titleForHeaderInSection:section];
    label.textAlignment = NSTextAlignmentCenter;
    
    // dont use that in your code cause layer shadows are
    // negatively affecting performance
    
    [label.layer setCornerRadius:label.frame.size.width/2];
    [label.layer setMasksToBounds:YES];
    [label.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [label.layer setBorderWidth:3.0f];
    [label.layer setShadowColor:[UIColor blackColor].CGColor];
    //    [label.layer setShadowOpacity:0.8];
    //    [label.layer setShadowRadius:5.0];
    //    [label.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    return label;
}
-(CHSectionSelectionItemView *)sectionSelectionView:(CHSectionSelectionView *)selectionView sectionSelectionItemViewForSection:(NSInteger)section
{
    DemoSectionItemSubclass *selectionItem = [[DemoSectionItemSubclass alloc] init];
    
    selectionItem.titleLabel.text = [MyTableView.dataSource tableView:MyTableView titleForHeaderInSection:section];
    selectionItem.titleLabel.font = [UIFont boldSystemFontOfSize:11];
    selectionItem.titleLabel.textColor = [UIColor colorWithRed:12/255.0f green:96/255.0f blue:250/255.0f alpha:1];
    selectionItem.titleLabel.highlightedTextColor = [UIColor redColor];
    selectionItem.titleLabel.shadowColor = [UIColor whiteColor];
    selectionItem.titleLabel.shadowOffset = CGSizeMake(0, 1);
    
    return selectionItem;
}


#pragma mark - SectionSelectionView Delegate

// Jump to the selected section in our tableview
-(void)sectionSelectionView:(CHSectionSelectionView *)sectionSelectionView didSelectSection:(NSInteger)section
{
    [MyTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}
#pragma mark - tabelView方法
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [Vcardarray objectAtIndex:section];
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    if (addressListArray.count!=0) {
        return addressListArray.count;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (addressListArray.count!=0) {
        return [[addressListArray objectAtIndex:section] count];
    }
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    addressListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressListCell"];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"addressListCell" owner:self options:nil] lastObject];
    }
    if (addressListArray.count!=0) {
        addressListModel *address = [[addressListArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [cell setData:address];
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (addressListArray.count!=0) {
        addressListModel *address = [[addressListArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        rechargeViewController *rechar = [rechargeViewController sharedUserDefault];
        rechar.phoneNumber = address.tmpPhoneIndex;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
