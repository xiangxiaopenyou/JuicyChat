//
//  WCRedpacketModel.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/8/22.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "WCRedpacketModel.h"

#import "WCSentRedPacketRecordRequest.h"
#import "WCReceivedRedPacketRequest.h"

@implementation WCRedpacketModel
+ (void)sentRedPacketRecord:(NSNumber *)index handler:(RequestResultHandler)handler {
    [[WCSentRedPacketRecordRequest new] request:^BOOL(WCSentRedPacketRecordRequest *request) {
        request.index = index;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler (nil, msg);
        } else {
            NSArray *resultArray = [WCRedpacketModel setupWithArray:(NSArray *)object];
            !handler ?: handler(resultArray, nil);
        }
    }];
}
+ (void)receivedRedPacketRecord:(NSNumber *)index handler:(RequestResultHandler)handler {
    [[WCReceivedRedPacketRequest new] request:^BOOL(WCReceivedRedPacketRequest *request) {
        request.index = index;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler (nil, msg);
        } else {
            NSArray *resultArray = [WCRedpacketModel setupWithArray:(NSArray *)object];
            !handler ?: handler(resultArray, nil);
        }
    }];
}

@end
