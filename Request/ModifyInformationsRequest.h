//
//  ModifyInformationsRequest.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/4/27.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "BaseRequest.h"

@interface ModifyInformationsRequest : BaseRequest
@property (copy, nonatomic) NSString *avatar;
@property (copy, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSNumber *sex;
@property (copy, nonatomic) NSString *signString;

@end
