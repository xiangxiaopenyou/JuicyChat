//
//  WCSpeakingManageRequest.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/8/24.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "BaseRequest.h"

@interface WCSpeakingManageRequest : BaseRequest
@property (copy, nonatomic) NSArray *userIds;
@property (copy, nonatomic) NSString *groupId;
@end
