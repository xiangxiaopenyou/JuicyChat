//
//  TakeApartRequest.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/15.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "TakeApartRequest.h"

@implementation TakeApartRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.redPacketId forKey:@"redpacketid"];
    [[RequestManager sharedInstance] POST:@"UnPackRedPacket.aspx" parameters:self.params success:^(NSURLSessionDataTask *task, id responseObject) {
        !resultHandler ?: resultHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !resultHandler ?: resultHandler(nil, error.description);
    }];
}

@end
