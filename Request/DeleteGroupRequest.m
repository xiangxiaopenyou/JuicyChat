//
//  DeleteGroupRequest.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/5.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "DeleteGroupRequest.h"

@implementation DeleteGroupRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.groupId forKey:@"groupId"];
    [[RequestManager sharedInstance] POST:@"RemoveGroup.aspx" parameters:self.params success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            !resultHandler ?: resultHandler(@(YES), nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !resultHandler ?: resultHandler(nil, error.description);
    }];
}

@end
