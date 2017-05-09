//
//  DeleteGroupRequest.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/5.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "BaseRequest.h"

@interface DeleteGroupRequest : BaseRequest
@property (copy, nonatomic) NSString *groupId;

@end
