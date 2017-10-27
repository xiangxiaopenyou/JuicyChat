//
//  TransferRecordModel.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/8/21.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "XLModel.h"

@interface TransferRecordModel : XLModel
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *fromuser;
@property (copy, nonatomic) NSString *fromuserheadico;
@property (copy, nonatomic) NSString *fromuserid;
@property (strong, nonatomic) NSNumber *money;
@property (strong, nonatomic) NSString <Optional> *note;
@property (copy, nonatomic) NSString *touser;
@property (copy, nonatomic) NSString *touserheadico;
@property (copy, nonatomic) NSString *touserid;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *option;

+ (void)transferRecord:(NSString *)date index:(NSNumber *)index type:(NSString *)type handler:(RequestResultHandler)handler;
+ (void)billTypes:(RequestResultHandler)handler;
@end
