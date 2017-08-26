//
//  WCRemoveNewFriendInfoRequest.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/8/23.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "WCRemoveNewFriendInfoRequest.h"

@implementation WCRemoveNewFriendInfoRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.friendId forKey:@"friendId"];
    [[RequestManager sharedInstance] POST:@"RemoveFriendFromNewFriends.aspx" parameters:self.params success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            !resultHandler ?: resultHandler(responseObject, nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !resultHandler ?: resultHandler(nil, @"网络错误");
    }];
}

@end
