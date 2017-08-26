//
//  WCRedPacketDetailTableViewController.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/8/23.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WCRedpacketModel;

@interface WCRedPacketDetailTableViewController : UITableViewController
@property (strong, nonatomic) WCRedpacketModel *model;
@property (nonatomic) BOOL isSent;

@end
