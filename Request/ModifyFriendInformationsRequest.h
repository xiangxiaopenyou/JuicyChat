//
//  ModifyFriendInformationsRequest.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/2.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "BaseRequest.h"

@interface ModifyFriendInformationsRequest : BaseRequest
@property (copy, nonatomic) NSString *friendId;
@property (copy, nonatomic) NSString *remark;
@property (strong, nonatomic) NSNumber *isBlackList;
@property (strong, nonatomic) NSNumber *isNoNotice;
@property (strong, nonatomic) NSNumber *state;


@end
