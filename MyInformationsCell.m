//
//  MyInformationsCell.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/5.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "MyInformationsCell.h"
#import "Masonry.h"
#import "RCDCommonDefine.h"
#import "RCDUtilities.h"
#import "UIImageView+WebCache.h"
#import <RongIMKit/RongIMKit.h>
@interface MyInformationsCell ()
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *nicknameLabel;
@property (strong, nonatomic) UILabel *userIdLabel;
@property (strong, nonatomic) UIImageView *arrowImageView;
@end

@implementation MyInformationsCell
- (instancetype)init {
    self = [super init];
    if (self) {
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.nicknameLabel];
        [self.contentView addSubview:self.userIdLabel];
        [self.contentView addSubview:self.arrowImageView];
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(65, 65));
            make.leading.equalTo(self.contentView.mas_leading).with.mas_offset(10);
            make.centerY.equalTo(self.contentView);
        }];
        [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.avatarImageView.mas_trailing).with.mas_offset(10);
            make.centerY.equalTo(self.contentView).with.mas_offset(- 12);
        }];
        [self.userIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.avatarImageView.mas_trailing).with.mas_offset(10);
            make.centerY.equalTo(self.contentView).with.mas_offset(12);
        }];
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(8, 13));
            make.trailing.equalTo(self.contentView.mas_trailing).with.mas_offset(- 10);
            make.centerY.equalTo(self.contentView);
        }];
        NSString *portraitUrl = [DEFAULTS stringForKey:@"userPortraitUri"];
        if (!portraitUrl || [portraitUrl isEqualToString:@""]) {
            portraitUrl = [RCDUtilities defaultUserPortrait:[RCIM sharedRCIM].currentUserInfo];
        }
        if ([portraitUrl hasPrefix:@"http"] || [portraitUrl hasPrefix:@"file:"]) {
            [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:portraitUrl] placeholderImage:nil];
        } else {
            self.avatarImageView.image = [UIImage imageNamed:portraitUrl];
        }
        self.nicknameLabel.text = [DEFAULTS stringForKey:@"userNickName"];
        self.userIdLabel.text = [NSString stringWithFormat:@"用户ID：%@",[DEFAULTS stringForKey:@"userId"]];

    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Getters
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = 5.0;
        _avatarImageView.clipsToBounds= YES;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _avatarImageView;
}
- (UILabel *)nicknameLabel {
    if (!_nicknameLabel) {
        _nicknameLabel = [[UILabel alloc] init];
        _nicknameLabel.font = [UIFont systemFontOfSize:16];
        _nicknameLabel.textColor = [UIColor blackColor];
    }
    return _nicknameLabel;
}
- (UILabel *)userIdLabel {
    if (!_userIdLabel) {
        _userIdLabel = [[UILabel alloc] init];
        _userIdLabel.textColor = [UIColor grayColor];
        _userIdLabel.font = [UIFont systemFontOfSize:12];
    }
    return _userIdLabel;
}
- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"right_arrow"];
    }
    return _arrowImageView;
}

@end
