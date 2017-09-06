//
//  WCRedPacketTipMessage.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/8/24.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

static NSString *const RedPacketTipMessageTypeIdentifier = @"JC:RedPacketNtf";

@interface WCRedPacketTipMessage : RCMessageContent<NSCoding>
@property (copy, nonatomic) NSString *message;
@property (copy, nonatomic) NSString *iosmessage;
@property (copy, nonatomic) NSString *tipmessage;
@property (copy, nonatomic) NSString *redpacketId;
@property (copy, nonatomic) NSString *touserid;
@property (copy, nonatomic) NSString *showuserids;
@property (strong, nonatomic) NSNumber *islink;

+ (instancetype)messageWithContent:(NSString *)message iosMessage:(NSString *)iosmessage tipMessage:(NSString *)tipmessage redPacketId:(NSString *)redpacketId userId:(NSString *)toUserId showUserIds:(NSString *)showuserids islink:(NSNumber *)islink;

@end
