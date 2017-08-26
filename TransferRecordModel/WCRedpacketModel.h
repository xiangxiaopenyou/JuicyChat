//
//  WCRedpacketModel.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/8/22.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "XLModel.h"

@interface WCRedpacketModel : XLModel
@property (strong, nonatomic) NSNumber *count;
@property (copy, nonatomic) NSString *createtime;
@property (copy, nonatomic) NSString *fromuser;
@property (copy, nonatomic) NSString *fromuserid;
@property (copy, nonatomic) NSString *id;
@property (strong, nonatomic) NSNumber <Optional> *redpacketmoney;
@property (strong, nonatomic) NSNumber *state;
@property (copy, nonatomic) NSString *tomember;
@property (copy, nonatomic) NSString *tomemberid;
@property (strong, nonatomic) NSNumber *type;
@property (strong, nonatomic) NSNumber <Optional> *unpackmoney;
@property (strong, nonatomic) NSNumber <Optional> *unpacksummoney;
@property (copy, nonatomic) NSString <Optional> *userid;
@property (copy, nonatomic) NSString <Optional> *note;
@property (strong, nonatomic) NSNumber <Optional> *money;
@property (strong, nonatomic) NSNumber <Optional> *unpackcount;

+ (void)sentRedPacketRecord:(NSNumber *)index handler:(RequestResultHandler)handler;
+ (void)receivedRedPacketRecord:(NSNumber *)index handler:(RequestResultHandler)handler;

@end
