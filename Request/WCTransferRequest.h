//
//  WCTransferRequest.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/7/28.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "BaseRequest.h"

@interface WCTransferRequest : BaseRequest
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *password;
@property (strong, nonatomic) NSNumber *money;
@property (copy, nonatomic) NSString *note;

@end
