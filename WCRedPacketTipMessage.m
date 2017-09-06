//
//  WCRedPacketTipMessage.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/8/24.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "WCRedPacketTipMessage.h"

@implementation WCRedPacketTipMessage
+ (instancetype)messageWithContent:(NSString *)message
                        iosMessage:(NSString *)iosmessage
                        tipMessage:(NSString *)tipmessage
                       redPacketId:(NSString *)redpacketId
                            userId:(NSString *)toUserId
                       showUserIds:(NSString *)showuserids
                            islink:(NSNumber *)islink {
    WCRedPacketTipMessage *tipMessage = [[WCRedPacketTipMessage alloc] init];
    if (tipMessage) {
        tipMessage.message = message;
        tipMessage.iosmessage = iosmessage;
        tipMessage.tipmessage = tipmessage;
        tipMessage.redpacketId = redpacketId;
        tipMessage.touserid = toUserId;
        tipMessage.showuserids = showuserids;
        tipMessage.islink = islink;
    }
    return tipMessage;
}
+ (RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.message = [aDecoder decodeObjectForKey:@"message"];
        self.iosmessage = [aDecoder decodeObjectForKey:@"iosmessage"];
        self.tipmessage = [aDecoder decodeObjectForKey:@"tipmessage"];
        self.redpacketId = [aDecoder decodeObjectForKey:@"redpacketId"];
        self.touserid = [aDecoder decodeObjectForKey:@"touserid"];
        self.showuserids = [aDecoder decodeObjectForKey:@"showuserids"];
        self.islink = [aDecoder decodeObjectForKey:@"islink"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.message forKey:@"message"];
    [aCoder encodeObject:self.iosmessage forKey:@"iosmessage"];
    [aCoder encodeObject:self.tipmessage forKey:@"tipmessage"];
    [aCoder encodeObject:self.redpacketId forKey:@"redpacketId"];
    [aCoder encodeObject:self.touserid forKey:@"touserid"];
    [aCoder encodeObject:self.showuserids forKey:@"showuserids"];
    [aCoder encodeObject:self.islink forKey:@"islink"];
}
///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.message forKey:@"message"];
    if (self.iosmessage) {
        [dataDict setObject:self.iosmessage forKey:@"iosmessage"];
    }
    if (self.tipmessage) {
        [dataDict setObject:self.tipmessage forKey:@"tipmessage"];
    }
    if (self.redpacketId) {
        [dataDict setObject:self.redpacketId forKey:@"redpacketId"];
    }
    if (self.touserid) {
        [dataDict setObject:self.touserid forKey:@"touserid"];
    }
    if (self.showuserids) {
        [dataDict setObject:self.showuserids forKey:@"showuserids"];
    }
    if (self.islink) {
        [dataDict setObject:self.islink forKey:@"islink"];
    }
    if (self.senderUserInfo) {
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [userInfoDic setObject:self.senderUserInfo.name
                 forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [userInfoDic setObject:self.senderUserInfo.portraitUri
                 forKeyedSubscript:@"icon"];
        }
        if (self.senderUserInfo.userId) {
            [userInfoDic setObject:self.senderUserInfo.userId
                 forKeyedSubscript:@"id"];
        }
        [dataDict setObject:userInfoDic forKey:@"user"];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict
                                                   options:kNilOptions
                                                     error:nil];
    return data;
}

///将json解码生成消息内容
- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                        options:kNilOptions
                                          error:&error];
        
        if (dictionary) {
            self.message = dictionary[@"message"];
            self.iosmessage = dictionary[@"iosmessage"];
            self.tipmessage = dictionary[@"tipmessage"];
            self.redpacketId = dictionary[@"redpacketId"];
            self.touserid = dictionary[@"touserid"];
            self.showuserids = dictionary[@"showuserids"];
            self.islink = dictionary[@"islink"];
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}

/// 会话列表中显示的摘要
- (NSString *)conversationDigest {
    return self.message;
}

///消息的类型名
+ (NSString *)getObjectName {
    return RedPacketTipMessageTypeIdentifier;
}


@end
