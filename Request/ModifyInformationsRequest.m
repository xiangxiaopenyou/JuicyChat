//
//  ModifyInformationsRequest.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/4/27.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "ModifyInformationsRequest.h"

@implementation ModifyInformationsRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    if (self.nickname) {
        [self.params setObject:self.nickname forKey:@"nickName"];
    }
    if (self.avatar) {
        [self.params setObject:self.avatar forKey:@"headIco"];
    }
    if (self.sex) {
        [self.params setObject:self.sex forKey:@"sex"];
    }
    if (self.signString) {
        [self.params setObject:self.signString forKey:@"whatsup"];
    }
    [[RequestManager sharedInstance] POST:@"UpdateMyInfo.aspx" parameters:self.params success:^(NSURLSessionDataTask *task, id responseObject) {
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
