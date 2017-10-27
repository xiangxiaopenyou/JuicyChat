//
//  WCFetchShareLinkRequest.m
//  SealTalk
//
//  Created by 项小盆友 on 2017/10/23.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "WCFetchShareLinkRequest.h"

@implementation WCFetchShareLinkRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [[RequestManager sharedInstance] POST:@"GetShareLink.aspx" parameters:self.params success:^(NSURLSessionDataTask *task, id responseObject) {
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
