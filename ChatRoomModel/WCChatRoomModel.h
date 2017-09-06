//
//  WCChatRoomModel.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/8/26.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "XLModel.h"

@interface WCChatRoomModel : XLModel
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *limitmoney;
@property (copy, nonatomic) NSString *createtime;
@property (copy, nonatomic) NSString *headico;
+ (void)chatRoomList:(RequestResultHandler)handler;

@end
