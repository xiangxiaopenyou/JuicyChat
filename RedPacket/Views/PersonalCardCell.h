//
//  PersonalCardCell.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/26.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface PersonalCardCell : RCMessageCell
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *cardLabel;
@property (strong, nonatomic) UILabel *line;
@property (strong, nonatomic) UIImageView *bubbleBackgroundView;

@end
