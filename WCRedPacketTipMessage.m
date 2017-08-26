//
//  WCRedPacketTipMessage.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/8/24.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "WCRedPacketTipMessage.h"

@implementation WCRedPacketTipMessage
+ (instancetype)messageWithContent:(NSString *)message redPacketId:(NSString *)redpacketId userId:(NSString *)toUserId {
    WCRedPacketTipMessage *tipMessage = [[WCRedPacketTipMessage alloc] init];
    if (tipMessage) {
        tipMessage.message = message;
        tipMessage.redpacketId = redpacketId;
        tipMessage.touserid = toUserId;
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
        self.redpacketId = [aDecoder decodeObjectForKey:@"redpacketId"];
        self.touserid = [aDecoder decodeObjectForKey:@"touserid"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.message forKey:@"message"];
    [aCoder encodeObject:self.redpacketId forKey:@"redpacketId"];
    [aCoder encodeObject:self.touserid forKey:@"touserid"];
}
///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.message forKey:@"message"];
    if (self.redpacketId) {
        [dataDict setObject:self.redpacketId forKey:@"redpacketId"];
    }
    if (self.touserid) {
        [dataDict setObject:self.touserid forKey:@"touserid"];
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
            self.redpacketId = dictionary[@"redpacketId"];
            self.touserid = dictionary[@"touserid"];
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
