//
//  RedPacketMemberCell.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/16.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedPacketMemberCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountCenterConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unitCenterConstraint;
@property (weak, nonatomic) IBOutlet UIButton *bestLuckLabel;

@end
