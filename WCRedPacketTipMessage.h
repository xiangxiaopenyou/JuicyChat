//
//  WCRedPacketTipMessage.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/8/24.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

static NSString *const RedPacketTipMessageTypeIdentifier = @"RC:RedPacketNtf";

@interface WCRedPacketTipMessage : RCMessageContent<NSCoding>
@property (copy, nonatomic) NSString *message;
@property (copy, nonatomic) NSString *redpacketId;
@property (copy, nonatomic) NSString *touserid;

+ (instancetype)messageWithContent:(NSString *)message redPacketId:(NSString *)redpacketId userId:(NSString *)toUserId;

@end
