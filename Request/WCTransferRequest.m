//
//  WCTransferRequest.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/7/28.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "WCTransferRequest.h"

@implementation WCTransferRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.userId forKey:@"toUserId"];
    [self.params setObject:self.password forKey:@"paypwd"];
    [self.params setObject:self.money forKey:@"money"];
    if (self.note.length > 0) {
        [self.params setObject:self.note forKey:@"note"];
    }
    [[RequestManager sharedInstance] POST:@"TransferMoney.aspx" parameters:self.params success:^(NSURLSessionDataTask *task, id responseObject) {
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
