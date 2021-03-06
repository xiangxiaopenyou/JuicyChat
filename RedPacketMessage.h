//
//  RedPacketMessage.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/12.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
static NSString *const RedPacketMessageTypeIdentifier = @"JC:RedPacketMsg";

@interface RedPacketMessage : RCMessageContent<NSCoding>
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *redpacketId;

+ (instancetype)messageWithContent:(NSString *)content redPacketId:(NSString *)redpacketId;

@end
