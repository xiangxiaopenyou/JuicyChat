//
//  AddFriendMessageCell.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/21.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "AddFriendMessage.h"

@interface AddFriendMessageCell : RCMessageBaseCell
/*!
 文本内容的Label
 */
@property(strong, nonatomic) UILabel *textLabel;

/*!
 背景View
 */
@property(nonatomic, strong) UIImageView *bubbleBackgroundView;

@end
