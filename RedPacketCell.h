//
//  RedPacketCell.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/12.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "RedPacketMessage.h"

@interface RedPacketCell : RCMessageCell
@property (strong, nonatomic) UIImageView *redPacketImageView;
@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UILabel *redpacketLabel;

@end
