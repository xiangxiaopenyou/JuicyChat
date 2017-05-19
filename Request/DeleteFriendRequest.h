//
//  DeleteFriendRequest.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/19.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "BaseRequest.h"

@interface DeleteFriendRequest : BaseRequest
@property (copy, nonatomic) NSString *friendId;

@end
