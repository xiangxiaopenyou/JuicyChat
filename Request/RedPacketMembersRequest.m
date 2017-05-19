//
//  RedPacketMembersRequest.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/16.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "RedPacketMembersRequest.h"

@implementation RedPacketMembersRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.redPacketId forKey:@"redpacketid"];
    [[RequestManager sharedInstance] POST:@"GetRedPacketUsers.aspx" parameters:self.params success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            !resultHandler ?: resultHandler(responseObject[@"data"], nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !resultHandler ?: resultHandler(nil, error.description);
    }];
}

@end
