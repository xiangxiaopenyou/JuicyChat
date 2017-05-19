//
//  ChangePayPasswordRequest.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/18.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "BaseRequest.h"

@interface ChangePayPasswordRequest : BaseRequest
@property (copy, nonatomic) NSString *oldPassword;
@property (copy, nonatomic) NSString *password;

@end
