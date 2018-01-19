//
//  TSCell.m
//  My_App
//
//  Created by barney on 15/11/24.
//  Copyright © 2015年 barney. All rights reserved.
//

#import "TSCell.h"
#import "TSDoubleCell.h"

static CGFloat innerCellHeight = 100;

@implementation TSCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

    self.yourTableView.delegate=self;
    self.yourTableView.dataSource=self;
    self.yourTableView.showsVerticalScrollIndicator=NO;
    self.yourTableView.scrollEnabled = NO;

//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"kTSTableViewCellShouldRefresh" object:nil];
}

- (void)refresh {
    //更新表视图高度的约束
    self.tableViewHeightConstraint.constant = innerCellHeight * _array.count;
//    [self setNeedsUpdateConstraints];
    [self.yourTableView reloadData];
}

-(void)setArray:(NSArray *)array {
    _array = array;
    [self refresh];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//-table
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *Cell = @"TSDoubleCell";
    TSDoubleCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
    
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TSDoubleCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dicttt =[self.array objectAtIndex:indexPath.row];
   
    NSString *text1 = [dicttt objectForKey:@"goods_name"];
    cell.content.text = text1;
    [cell.img sd_setImageWithURL:[NSURL URLWithString:[[self.array objectAtIndex:indexPath.row]objectForKey:@"goods_img"]]placeholderImage:[UIImage imageNamed:@"kong_lj"]];
    cell.TSBtn.layer.cornerRadius=5;
    [cell.TSBtn.layer setMasksToBounds:YES];
    cell.TSBtn.layer.borderColor=[UIColor redColor].CGColor;
    cell.TSBtn.layer.borderWidth=0.5;
    [cell.TSBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.TSBtn.tag=indexPath.row+100;
    return cell;

}
-(void)buttonClick:(UIButton *)btn
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(detailsButtonCLick:WithOid:)])
    {
        [self.delegate detailsButtonCLick:[self.array objectAtIndex:btn.tag-100]WithOid:self.oid];
        
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return innerCellHeight;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
