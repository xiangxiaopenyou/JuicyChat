//
//  ModifyGroupInformationsRequest.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/5.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "BaseRequest.h"

@interface ModifyGroupInformationsRequest : BaseRequest
@property (copy, nonatomic) NSString *groupId;
@property (copy, nonatomic) NSString *groupName;
@property (copy, nonatomic) NSString *headIco;
@property (strong, nonatomic) NSNumber *redPacketLimit;
@property (strong, nonatomic) NSNumber *lockLimit;
@property (copy, nonatomic) NSString *gonggao;
@property (nonatomic) NSInteger iscanadduser;

@end
