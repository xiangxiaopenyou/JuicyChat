//
//  WCChatRoomModel.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/8/26.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "WCChatRoomModel.h"
#import "WCChatRoomListRequest.h"

@implementation WCChatRoomModel
+ (void)chatRoomList:(RequestResultHandler)handler {
    [[WCChatRoomListRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            NSArray *resultArray = [WCChatRoomModel setupWithArray:(NSArray *)object];
            !handler ?: handler(resultArray, nil);
        }
    }];
}

@end
