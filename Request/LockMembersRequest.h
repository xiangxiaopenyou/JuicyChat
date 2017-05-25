//
//  LockMembersRequest.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/20.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "BaseRequest.h"

@interface LockMembersRequest : BaseRequest
@property (copy, nonatomic) NSString *groupId;

@end
