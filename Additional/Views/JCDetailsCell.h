//
//  JCDetailsCell.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/6/21.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCDetailsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelCenterConstraint;

@end
