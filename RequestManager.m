//
//  RequestManager.m
//  DongDong
//
//  Created by 项小盆友 on 16/6/6.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "RequestManager.h"
#import "AFHttpTool.h"
#define DemoServer @"http://121.43.184.230:7654/API/"
//#define DemoServer @"http://47.92.72.63:5689/API/"

@implementation RequestManager
+ (instancetype)sharedInstance {
    static RequestManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RequestManager alloc] initWithBaseURL:[NSURL URLWithString:DemoServer]];
        AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
        NSMutableSet *types = [[serializer acceptableContentTypes] mutableCopy];
        [types addObjectsFromArray:@[@"text/plain", @"text/html"]];
        serializer.acceptableContentTypes = types;
        instance.responseSerializer = serializer;
        [NSURLSessionConfiguration defaultSessionConfiguration].HTTPMaximumConnectionsPerHost = 1;
    });
    return instance;
}

@end
