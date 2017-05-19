//
//  SendRedPacketRequest.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/11.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "BaseRequest.h"

@interface SendRedPacketRequest : BaseRequest
@property (copy, nonatomic) NSString *toId;
@property (strong, nonatomic) NSNumber *amount;
@property (copy, nonatomic) NSString *payPassword;
@property (copy, nonatomic) NSString *note;
@property (strong, nonatomic) NSNumber *type;
@property (strong, nonatomic) NSNumber *count;

@end
