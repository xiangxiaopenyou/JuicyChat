//
//  AddFriendMessage.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/21.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
#define AddFriendMessageTypeIdentifier @"RC:ContactNtf"

@interface AddFriendMessage : RCContactNotificationMessage<NSCoding>

///*!
// 消息的内容
// */
//@property(nonatomic, strong) NSString *content;
//
///*!
// 消息的附加信息
// */
//@property(nonatomic, strong) NSString *extra;
//
//+ (instancetype)messageWithContent:(NSString *)content;

@end
