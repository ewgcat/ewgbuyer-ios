//
//  WXApiManager.h
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
@class WXApiManager;

typedef NS_ENUM(NSUInteger, backType) {
    backTypePaySuccess,
    backTypePayError,
    backTypeCancelOrder,
    backTypeAuth
};

@protocol WXApiManagerDelegate <NSObject>

@optional

-(void)managerDidGetBackType:(WXApiManager *)manager backType:(backType)backtype;



@end

@interface WXApiManager : NSObject<WXApiDelegate>

@property(nonatomic,strong)NSString *codestring;
@property (nonatomic, weak) id<WXApiManagerDelegate> delegate;

+ (instancetype)sharedManager;

/**=================================================================*/
@property (nonatomic, assign)backType backType;//返回的方式

@end
