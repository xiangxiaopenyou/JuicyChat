//
//  RequestManager.h
//  DongDong
//
//  Created by 项小盆友 on 16/6/6.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "AFNetworking.h"

@interface RequestManager : AFHTTPSessionManager
+ (instancetype)sharedInstance;

@end
