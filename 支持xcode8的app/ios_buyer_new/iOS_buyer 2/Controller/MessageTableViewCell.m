//
//  MessageTableViewCell.m
//  My_App
//
//  Created by 邱炯辉 on 16/8/17.
//  Copyright © 2016年 邱炯辉. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        UIImageView *imgBG = [[UIImageView alloc]init];
        self.imgBG=imgBG;
        [imgBG.layer setMasksToBounds:YES];
        [imgBG.layer setCornerRadius:4.0];
        [self.contentView addSubview:imgBG];
        //白色的view；
        //        UIView *whiteView=[LJControl viewFrame:CGRectMake(10, 10, ScreenFrame.size.width-20, cell.frame.size.height-5) backgroundColor:[UIColor whiteColor]];
        UIView *whiteView=[[UIView alloc]init];
        whiteView.backgroundColor=[UIColor whiteColor];
        self.whiteView=whiteView;
        [whiteView.layer setMasksToBounds:YES];
        [whiteView.layer setCornerRadius:4.0];
        [self.contentView addSubview:whiteView];
        //        来自哪里
        UILabel *lblFromUser = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, ScreenFrame.size.width-40, 21)];
        lblFromUser.backgroundColor = [UIColor clearColor];
        self.lblFromUser=lblFromUser;
        
        lblFromUser.textAlignment = NSTextAlignmentLeft;
        lblFromUser.font = [UIFont fontWithName:@"Arial" size:15.0f];
        [self.contentView addSubview:lblFromUser];
        //        时间label
        UILabel *lbladdTime = [[UILabel alloc]initWithFrame:CGRectMake(ScreenFrame.size.width-222, 21, 200, 21)];
        lbladdTime.backgroundColor = [UIColor clearColor];
        self.lbladdTime=lbladdTime;
        lbladdTime.textColor=UIColorFromRGB(0x999999);
        lbladdTime.textAlignment = NSTextAlignmentRight;
        lbladdTime.font = [UIFont fontWithName:@"Arial" size:15.0f];
        [self.contentView addSubview:lbladdTime];
        
        //内容Label
        UILabel *lblContent = [[UILabel alloc]init];
        lblContent.backgroundColor = [UIColor clearColor];
        
        self.lblContent=lblContent;
        
        
        lblContent.numberOfLines = 0;
        
        
        lblContent.textAlignment = NSTextAlignmentLeft;
        lblContent.font = [UIFont fontWithName:@"Arial" size:15.0f];
        
        [self.contentView addSubview:lblContent];
        
        self.backgroundColor = [UIColor clearColor];
        
        
        
#pragma mark -已读，未读
        UILabel *label=[[UILabel alloc]init];
        label.textAlignment=NSTextAlignmentRight;
        self.statuLabel=label;
        //        label.backgroundColor=[UIColor redColor];
        label.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:label];
        

        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
