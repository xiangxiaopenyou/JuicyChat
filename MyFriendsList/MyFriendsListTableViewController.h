//
//  MyFriendsListTableViewController.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/25.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RCDUserInfo;

@interface MyFriendsListTableViewController : UITableViewController
@property (copy, nonatomic) void (^selectBlock)(RCDUserInfo *userInfo);

@end
