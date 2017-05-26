//
//  PersonalCardMessage.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/26.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "PersonalCardMessage.h"

@implementation PersonalCardMessage
///初始化
+ (instancetype)messageWithUserId:(NSString *)userId name:(NSString *)name portraitUrl:(NSString *)portraitUri user:(NSDictionary *)user {
    PersonalCardMessage *text = [[PersonalCardMessage alloc] init];
    if (text) {
        text.userId = userId;
        text.name = name;
        text.portraitUri = portraitUri;
        text.user = user;
    }
    return text;
}

+ (RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}
/// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.portraitUri = [aDecoder decodeObjectForKey:@"portraitUri"];
        self.user = [aDecoder decodeObjectForKey:@"user"];
    }
    return self;
}

/// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.portraitUri forKey:@"portraitUri"];
    [aCoder encodeObject:self.user forKey:@"user"];
}

///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.userId forKey:@"userId"];
    [dataDict setObject:self.name forKey:@"name"];
    [dataDict setObject:self.portraitUri forKey:@"portraitUri"];
    if (self.senderUserInfo) {
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [userInfoDic setObject:self.senderUserInfo.name
                 forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [userInfoDic setObject:self.senderUserInfo.portraitUri
                 forKeyedSubscript:@"portrait"];
        }
        if (self.senderUserInfo.userId) {
            [userInfoDic setObject:self.senderUserInfo.userId
                 forKeyedSubscript:@"id"];
        }
        [dataDict setObject:userInfoDic forKey:@"user"];
    } else {
        [dataDict setObject:self.user forKey:@"user"];
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
            self.userId = dictionary[@"userId"];
            self.name = dictionary[@"name"];
            self.portraitUri = dictionary[@"portraitUri"];
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}

/// 会话列表中显示的摘要
- (NSString *)conversationDigest {
    return @"[个人名片]";
}

///消息的类型名
+ (NSString *)getObjectName {
    return CardMessageTypeIdentifier;
}

@end
