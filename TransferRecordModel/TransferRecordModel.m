//
//  TransferRecordModel.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/8/21.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "TransferRecordModel.h"
#import "WCTransferRecordRequest.h"
#import "WCFetchBillTypesRequest.h"

@implementation TransferRecordModel
+ (void)transferRecord:(NSString *)date index:(NSNumber *)index type:(NSString *)type handler:(RequestResultHandler)handler {
    [[WCTransferRecordRequest new] request:^BOOL(WCTransferRecordRequest *request) {
        request.index = index;
        request.date = date;
        request.type = type;
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
+ (void)billTypes:(RequestResultHandler)handler {
    [[WCFetchBillTypesRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            NSArray *tempArray = [object copy];
            !handler ?: handler(tempArray, nil);
        }
    }];
}

@end
