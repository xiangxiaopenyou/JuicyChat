//
//  DeleteFriendRequest.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/19.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "DeleteFriendRequest.h"

@implementation DeleteFriendRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.friendId forKey:@"friendId"];
    [[RequestManager sharedInstance] POST:@"RemoveFriend.aspx" parameters:self.params success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            !resultHandler ?: resultHandler(responseObject, nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !resultHandler ?: resultHandler(nil, error.description);
    }];
}

@end
