//
//  BaseRequest.h
//  DongDong
//
//  Created by 项小盆友 on 16/6/6.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestManager.h"
typedef BOOL (^ParamsBlock)(id request);
typedef void (^RequestResultHandler)(id object, NSString *msg);
@protocol RequestProtocol <NSObject>
@required
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler;

@end

@interface BaseRequest : NSObject<RequestProtocol>
@property (strong, nonatomic) NSMutableDictionary *params;
- (void)cacheRequest:(NSString *)request method:(NSString *)method param:(NSDictionary *)param;
- (NSString *)handlerError:(NSError *)error;

@end
