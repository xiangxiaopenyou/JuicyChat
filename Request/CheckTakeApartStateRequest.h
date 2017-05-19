//
//  CheckTakeApartStateRequest.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/13.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "BaseRequest.h"

@interface CheckTakeApartStateRequest : BaseRequest
@property (copy, nonatomic) NSString *redPacketId;

@end
