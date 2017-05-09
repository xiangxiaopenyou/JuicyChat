//
//  WechatLoginRequest.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/8.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "WechatLoginRequest.h"

@implementation WechatLoginRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.wechat forKey:@"wechat"];
    [[RequestManager sharedInstance] POST:@"LoginByWeChat.aspx" parameters:self.params success:^(NSURLSessionDataTask *task, id responseObject) {
        !resultHandler ?: resultHandler(responseObject, responseObject[@"message"]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !resultHandler ?: resultHandler(nil, error.description);
    }];
}

@end
