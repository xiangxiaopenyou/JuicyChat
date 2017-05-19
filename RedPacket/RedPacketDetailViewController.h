//
//  RedPacketDetailViewController.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/13.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedPacketDetailViewController : UIViewController
@property (copy, nonatomic) NSString *redPacketId;
@property (assign, nonatomic) NSInteger redPacketNumber;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *avatarUrl;
@property (copy, nonatomic) NSString *noteString;
@property (copy, nonatomic) NSDictionary *informations;
@property (copy, nonatomic) NSArray *membersArray;
@property (assign, nonatomic) BOOL isPrivateChat;
@end
