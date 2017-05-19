//
//  RedPacketViewController.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/9.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>
#import "RCDGroupInfo.h"

@interface RedPacketViewController : UIViewController
@property (nonatomic) RCConversationType type;
@property (strong, nonatomic) RCDGroupInfo *groupInfo;
@property (copy, nonatomic) NSString *toId;

@property (copy, nonatomic) void (^successBlock)(NSString *packetId, NSString *note);

@end
