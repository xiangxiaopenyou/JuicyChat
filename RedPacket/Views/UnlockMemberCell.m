//
//  UnlockMemberCell.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/21.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "UnlockMemberCell.h"

@implementation UnlockMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)selectState:(BOOL)selected {
    if (selected) {
        self.selectImageView.image = [UIImage imageNamed:@"select"];
    } else {
        self.selectImageView.image = [UIImage imageNamed:@"unselect"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
