
//
//  SendRedPacketRequest.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/11.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "SendRedPacketRequest.h"

@implementation SendRedPacketRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.toId forKey:@"toMemberId"];
    [self.params setObject:self.payPassword forKey:@"paypwd"];
    [self.params setObject:self.amount forKey:@"money"];
    [self.params setObject:self.type forKey:@"type"];
    if (self.note) {
        [self.params setObject:self.note forKey:@"note"];
    }
    if (self.count) {
        [self.params setObject:self.count forKey:@"count"];
    }
    [[RequestManager sharedInstance] POST:@"SendRedPacket.aspx" parameters:self.params success:^(NSURLSessionDataTask *task, id responseObject) {
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
