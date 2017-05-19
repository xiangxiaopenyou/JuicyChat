//
//  CheckSetPayPasswordRequest.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/9.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "CheckSetPayPasswordRequest.h"

@implementation CheckSetPayPasswordRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [[RequestManager sharedInstance] POST:@"CheckPayPwd.aspx" parameters:self.params success:^(NSURLSessionDataTask *task, id responseObject) {
        !resultHandler ?: resultHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !resultHandler ?: resultHandler(nil, error.description);
    }];
}

@end
