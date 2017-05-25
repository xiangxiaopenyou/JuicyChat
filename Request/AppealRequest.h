//
//  AppealRequest.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/20.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "BaseRequest.h"

@interface AppealRequest : BaseRequest
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSArray *images;

@end
