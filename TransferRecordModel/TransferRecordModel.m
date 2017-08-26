//
//  TransferRecordModel.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/8/21.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "TransferRecordModel.h"
#import "WCTransferRecordRequest.h"

@implementation TransferRecordModel
+ (void)transferRecord:(NSString *)date index:(NSNumber *)index handler:(RequestResultHandler)handler {
    [[WCTransferRecordRequest new] request:^BOOL(WCTransferRecordRequest *request) {
        request.index = index;
        request.date = date;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:object];
            NSArray *resultArray = [TransferRecordModel setupWithArray:tempArray];
            !handler ?: handler(resultArray, nil);
        }
    }];
}

@end
