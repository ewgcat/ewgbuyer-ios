//
//  AddAddressTableViewController.h
//  下班接着干
//
//  Created by apple2 on 15/11/18.
//  Copyright © 2015年 shiyuwudi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    SY_ADDRESS_POST_TYPE_ADD,
    SY_ADDRESS_POST_TYPE_EDIT
}SY_ADDRESS_POST_TYPE;

typedef enum {
    NEED_VALIDATE,
    NO_NEED_VALIDATE
}VALIDATE_TYPE;
@interface AddAddressTableViewController : UITableViewController

@property (nonatomic, assign)SY_ADDRESS_POST_TYPE editType;
@property (nonatomic, strong)NSArray *infoArrayWhenEditing;


//是否需要身份证验证
@property (nonatomic, assign)VALIDATE_TYPE validateType;
@end
