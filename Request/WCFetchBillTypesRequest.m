//
//  WCFetchBillTypesRequest.m
//  SealTalk
//
//  Created by 项小盆友 on 2017/10/19.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "WCFetchBillTypesRequest.h"

@implementation WCFetchBillTypesRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [[RequestManager sharedInstance] POST:@"GetBillTypes.aspx" parameters:self.params success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            !resultHandler ?: resultHandler(responseObject[@"data"], nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !resultHandler ?: resultHandler(nil, @"网络错误");
    }];
}
@end
