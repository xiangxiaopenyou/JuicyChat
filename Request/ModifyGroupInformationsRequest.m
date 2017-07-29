//
//  ModifyGroupInformationsRequest.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/5.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "ModifyGroupInformationsRequest.h"

@implementation ModifyGroupInformationsRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.groupId forKey:@"groupId"];
    if (self.groupName) {
        [self.params setObject:self.groupName forKey:@"groupName"];
    }
    if (self.headIco) {
        [self.params setObject:self.headIco forKey:@"headIco"];
    }
    if (self.gonggao) {
        [self.params setObject:self.gonggao forKey:@"gonggao"];
    }
    [self.params setObject:@(self.iscanadduser) forKey:@"iscanadduser"];
    [self.params setObject:@(self.redPacketLimit.integerValue) forKey:@"redPacketLimit"];
    [self.params setObject:@(self.lockLimit.integerValue) forKey:@"lockLimit"];
    [[RequestManager sharedInstance] POST:@"UpdateGroup.aspx" parameters:self.params success:^(NSURLSessionDataTask *task, id responseObject) {
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
