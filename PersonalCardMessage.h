//
//  PersonalCardMessage.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/26.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

#define CardMessageTypeIdentifier @"RCD:CardMsg"

@interface PersonalCardMessage : RCMessageContent<NSCoding>

@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *portraitUri;
@property (copy, nonatomic) NSDictionary *user;

+ (instancetype)messageWithUserId:(NSString *)userId name:(NSString *)name portraitUrl:(NSString *)portraitUri user:(NSDictionary *)user;

@end
