//
//  RequestManager.h
//  DongDong
//
//  Created by 项小盆友 on 16/6/6.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "AFNetworking.h"

#define DemoServer @"http://121.43.184.230:7654/API/"
//#define DemoServer @"http://47.92.72.63:5689/API/"

@interface RequestManager : AFHTTPSessionManager
+ (instancetype)sharedInstance;

@end
