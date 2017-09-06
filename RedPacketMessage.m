//
//  RedPacketMessage.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/12.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "RedPacketMessage.h"

@implementation RedPacketMessage
+ (instancetype)messageWithContent:(NSString *)content redPacketId:(NSString *)redpacketId fromuserid:(NSString *)fromuserid tomemberid:(NSString *)tomemberid {
    RedPacketMessage *message = [[RedPacketMessage alloc] init];
    if (message) {
        message.content = content;
        message.redpacketId = redpacketId;
        message.fromuserid = fromuserid;
        message.tomemberid = tomemberid;
    }
    return message;
}
+ (RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.redpacketId = [aDecoder decodeObjectForKey:@"redpacketId"];
        self.fromuserid = [aDecoder decodeObjectForKey:@"fromuserid"];
        self.tomemberid = [aDecoder decodeObjectForKey:@"tomemberid"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.redpacketId forKey:@"redpacketId"];
    [aCoder encodeObject:self.fromuserid forKey:@"fromuserid"];
    [aCoder encodeObject:self.tomemberid forKey:@"tomemberid"];
}
///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.content forKey:@"content"];
    if (self.redpacketId) {
        [dataDict setObject:self.redpacketId forKey:@"redpacketId"];
    }
    if (self.fromuserid) {
        [dataDict setObject:self.fromuserid forKey:@"fromuserid"];
    }
    if (self.tomemberid) {
        [dataDict setObject:self.tomemberid forKey:@"tomemberid"];
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
        
        NSDictionary *dictionary =
        [NSJSONSerialization JSONObjectWithData:data
                                        options:kNilOptions
                                          error:&error];
        
        if (dictionary) {
            self.content = dictionary[@"content"];
            self.redpacketId = dictionary[@"redpacketId"];
            self.fromuserid = dictionary[@"fromuserid"];
            self.tomemberid = dictionary[@"tomemberid"];
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}

/// 会话列表中显示的摘要
- (NSString *)conversationDigest {
    return self.content;
}

///消息的类型名
+ (NSString *)getObjectName {
    return RedPacketMessageTypeIdentifier;
}

@end
