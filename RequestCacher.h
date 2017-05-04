//
//  RequestCacher.h
//  DongDong
//
//  Created by 项小盆友 on 16/6/6.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestCacher : NSObject
@property (copy, nonatomic) NSString *method;
@property (copy, nonatomic) NSDictionary *param;

+ (instancetype)sharedInstance;
- (void)cacheRequest:(NSString *)request method:(NSString *)method param:(NSDictionary *)param;
- (void)reloadRequest;
@end
