//
//  ModifyFriendInformationsRequest.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/2.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "ModifyFriendInformationsRequest.h"

@implementation ModifyFriendInformationsRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.friendId forKey:@"friendId"];
    if (self.remark) {
        [self.params setObject:self.remark forKey:@"remark"];
    }
    if (self.isBlackList) {
        [self.params setObject:self.isBlackList forKey:@"isBlackList"];
    }
    if (self.isNoNotice) {
        [self.params setObject:self.isNoNotice forKey:@"isNoNotice"];
    }
    if (self.state) {
        [self.params setObject:self.state forKey:@"state"];
    }
    [[RequestManager sharedInstance] POST:@"UpdateFriend.aspx" parameters:self.params success:^(NSURLSessionDataTask *task, id responseObject) {
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
