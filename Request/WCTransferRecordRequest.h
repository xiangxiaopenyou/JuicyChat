//
//  WCTransferRecordRequest.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/8/21.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "BaseRequest.h"

@interface WCTransferRecordRequest : BaseRequest
@property (copy, nonatomic) NSString *date;
@property (strong, nonatomic) NSNumber *index;
@property (copy, nonatomic) NSString *type;

@end
