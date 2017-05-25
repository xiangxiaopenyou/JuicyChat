//
//  AddFriendMessage.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/21.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "AddFriendMessage.h"

@implementation AddFriendMessage
///初始化
//+ (instancetype)messageWithContent:(NSString *)content {
//    AddFriendMessage *text = [[AddFriendMessage alloc] init];
//    if (text) {
//        text.content = content;
//    }
//    return text;
//}
//+ (RCMessagePersistent)persistentFlag {
//    return (MessagePersistent_ISPERSISTED);
//}
///// NSCoding
//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    self = [super init];
//    if (self) {
//        self.content = [aDecoder decodeObjectForKey:@"content"];
//        self.extra = [aDecoder decodeObjectForKey:@"extra"];
//    }
//    return self;
//}
//
///// NSCoding
//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [aCoder encodeObject:self.content forKey:@"content"];
//    [aCoder encodeObject:self.extra forKey:@"extra"];
//}
//
/////将消息内容编码成json
//- (NSData *)encode {
//    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
//    [dataDict setObject:self.content forKey:@"content"];
//    if (self.extra) {
//        [dataDict setObject:self.extra forKey:@"extra"];
//    }
//    
//    if (self.senderUserInfo) {
//        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
//        if (self.senderUserInfo.name) {
//            [userInfoDic setObject:self.senderUserInfo.name
//                 forKeyedSubscript:@"name"];
//        }
//        if (self.senderUserInfo.portraitUri) {
//            [userInfoDic setObject:self.senderUserInfo.portraitUri
//                 forKeyedSubscript:@"icon"];
//        }
//        if (self.senderUserInfo.userId) {
//            [userInfoDic setObject:self.senderUserInfo.userId
//                 forKeyedSubscript:@"id"];
//        }
//        [dataDict setObject:userInfoDic forKey:@"user"];
//    }
//    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict
//                                                   options:kNilOptions
//                                                     error:nil];
//    return data;
//}
//
/////将json解码生成消息内容
//- (void)decodeWithData:(NSData *)data {
//    if (data) {
//        __autoreleasing NSError *error = nil;
//        
//        NSDictionary *dictionary =
//        [NSJSONSerialization JSONObjectWithData:data
//                                        options:kNilOptions
//                                          error:&error];
//        
//        if (dictionary) {
//            self.content = dictionary[@"content"];
//            self.extra = dictionary[@"extra"];
//            
//            NSDictionary *userinfoDic = dictionary[@"user"];
//            [self decodeUserInfo:userinfoDic];
//        }
//    }
//}
//
///// 会话列表中显示的摘要
//- (NSString *)conversationDigest {
//    return self.content;
//}
//
/////消息的类型名
//+ (NSString *)getObjectName {
//    return AddFriendMessageTypeIdentifier;
//}

@end
