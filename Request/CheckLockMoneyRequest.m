//
//  CheckLockMoneyRequest.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/13.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "CheckLockMoneyRequest.h"

@implementation CheckLockMoneyRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.groupId forKey:@"groupId"];
    [[RequestManager sharedInstance] POST:@"CheckLockMoney.aspx" parameters:self.params success:^(NSURLSessionDataTask *task, id responseObject) {
        !resultHandler ?: resultHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !resultHandler ?: resultHandler(nil, error.description);
    }];
}

@end
