//
//  TakeApartPacketView.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/13.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "TakeApartPacketView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#define MAINCOlOR [UIColor colorWithRed:210/255.0 green:170/255.0 blue:103/255.0 alpha:1]

@interface TakeApartPacketView ()
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImageView *redPacketBackground;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *tipLabel;
@property (strong, nonatomic) UILabel *noteLabel;
@property (strong, nonatomic) UIButton *openButton;
@property (strong, nonatomic) UIButton *goDetailButton;
@property (copy, nonatomic) NSDictionary *dictionary;
@end

@implementation TakeApartPacketView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        [self.contentView addSubview:self.redPacketBackground];
        [self.redPacketBackground mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        [self.contentView addSubview:self.closeButton];
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.equalTo(self.contentView);
            make.size.mas_offset(CGSizeMake(40, 40));
        }];
        
        [self.contentView addSubview:self.avatarImageView];
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView.mas_top).with.mas_offset(35);
            make.size.mas_offset(CGSizeMake(40, 40));
        }];
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.avatarImageView.mas_bottom).with.mas_offset(20);
        }];
        
        [self.contentView addSubview:self.tipLabel];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.nameLabel.mas_bottom).with.mas_offset(10);
        }];
        
        [self.contentView addSubview:self.noteLabel];
        [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tipLabel.mas_bottom).with.mas_offset(40);
            make.leading.equalTo(self.contentView.mas_leading).with.mas_offset(10);
            make.trailing.equalTo(self.contentView.mas_trailing).with.mas_offset(- 10);
        }];
        
        [self.contentView addSubview:self.openButton];
        [self.openButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.noteLabel.mas_bottom).with.mas_offset(50);
            make.size.mas_offset(CGSizeMake(99, 99));
        }];

        [self.contentView addSubview:self.goDetailButton];
        [self.goDetailButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView.mas_bottom).with.mas_offset(- 5);
            make.size.mas_offset(CGSizeMake(100, 30));
        }];
    }
    return self;
}

- (void)show {
    self.alpha = 1.0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self addSubview:self.contentView];
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.contentView.layer addAnimation:popAnimation forKey:nil];
}
- (void)dismiss {
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    CAKeyframeAnimation *hideAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    hideAnimation.duration = 0.4;
    hideAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.00f, 0.00f, 0.00f)]];
    hideAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f];
    hideAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.contentView.layer addAnimation:hideAnimation forKey:nil];
}
- (void)openAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(packetViewDidClickOpen)]) {
        [self.delegate packetViewDidClickOpen];
    }
}
- (void)detailAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(packetViewDidClickGoDetail)]) {
        [self.delegate packetViewDidClickGoDetail];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(UIScreen.mainScreen.bounds) / 2.0 - 155, CGRectGetHeight(UIScreen.mainScreen.bounds) / 2.0 - 205, 310, 410)];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}
- (UIImageView *)redPacketBackground {
    if (!_redPacketBackground) {
        _redPacketBackground = [[UIImageView alloc] init];
        _redPacketBackground.image = [UIImage imageNamed:@"packet_background"];
    }
    return _redPacketBackground;
}
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"packet_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = 10.0;
        _avatarImageView.layer.borderWidth = 1.0;
        _avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _avatarImageView;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = MAINCOlOR;
    }
    return _nameLabel;
}
- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:12];
        _tipLabel.textColor = MAINCOlOR;
        _tipLabel.text = @"发了一个红包，金额随机";
    }
    return _tipLabel;
}
- (UILabel *)noteLabel {
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.font = [UIFont systemFontOfSize:18];
        _noteLabel.textColor = MAINCOlOR;
        _noteLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noteLabel;
}
- (UIButton *)openButton {
    if (!_openButton) {
        _openButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_openButton setImage:[UIImage imageNamed:@"packet_open_button"] forState:UIControlStateNormal];
        [_openButton addTarget:self action:@selector(openAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openButton;
}
- (UIButton *)goDetailButton {
    if (!_goDetailButton) {
        _goDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goDetailButton setTitleColor:MAINCOlOR forState:UIControlStateNormal];;
        _goDetailButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_goDetailButton setTitle:@"查看领取详情" forState:UIControlStateNormal];
        [_goDetailButton addTarget:self action:@selector(detailAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goDetailButton;
}
//- (void)setState:(BOOL)state {
//    if (state) {
//        self.tipLabel.hidden = NO;
//        self.noteLabel.text = @"恭喜发财，大吉大利";
//        self.openButton.hidden = NO;
//    } else {
//        self.tipLabel.hidden = YES;
//        self.noteLabel.text = @"手慢了，红包被抢完了";
//        self.openButton.hidden = YES;
//    }
//}
- (void)setInformations:(NSDictionary *)informations {
    if (informations) {
        _dictionary = [informations copy];
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:informations[@"fromheadico"]]];
        self.nameLabel.text = informations[@"fromnickname"];
        if ([informations[@"state"] integerValue] == 2) {
            self.openButton.hidden = YES;
            self.tipLabel.hidden = YES;
            self.noteLabel.text = @"手慢了，红包派完了";
            self.goDetailButton.hidden = NO;
        } else if ([informations[@"state"] integerValue] == 3) {
            self.openButton.hidden = YES;
            self.tipLabel.hidden = YES;
            self.noteLabel.text = @"来晚了，红包已经过期了";
            self.goDetailButton.hidden = NO;
        } else {
            self.openButton.hidden = NO;
            self.tipLabel.hidden = NO;
            self.noteLabel.text = informations[@"note"];
            NSString *ownerId = [NSString stringWithFormat:@"%@", informations[@"fromuserid"]];
            NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
            if ([userId isEqualToString:ownerId]) {
                self.goDetailButton.hidden = NO;
            } else {
                self.goDetailButton.hidden = YES;
            }
        }
//        NSString *ownerId = [NSString stringWithFormat:@"%@", informations[@"fromuserid"]];
//        NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
//        if ([userId isEqualToString:ownerId]) {
//            self.goDetailButton.hidden = NO;
//        } else {
//            self.goDetailButton.hidden = YES;
//        }
    }
}
- (void)setResultState:(NSInteger)resultState {
    if (resultState == 200) {
        self.openButton.hidden = NO;
        self.tipLabel.hidden = NO;
        self.noteLabel.text = _dictionary[@"note"];
    } else if (resultState == 66003) {
        self.openButton.hidden = YES;
        self.tipLabel.hidden = YES;
        self.noteLabel.text = @"手慢了，红包派完了";
        self.goDetailButton.hidden = NO;
    } else if (resultState == 66102) {
        self.openButton.hidden = YES;
        self.tipLabel.hidden = YES;
        self.noteLabel.text = @"红包已经过期了";
        self.goDetailButton.hidden = NO;
    } else if (resultState == 66103) {
        self.openButton.hidden = YES;
        self.tipLabel.hidden = YES;
        self.noteLabel.text = @"你不是群成员，不能抢红包";
    } else {
        self.openButton.hidden = YES;
        self.tipLabel.hidden = YES;
        self.noteLabel.text = @"抢红包失败";
    }
}
- (void)setIsPrivateChat:(BOOL)isPrivateChat {
    if (isPrivateChat) {
        self.tipLabel.text = @"给你发了一个红包";
        self.goDetailButton.hidden = YES;
    } else {
        self.tipLabel.text = @"发了一个红包，金额随机";
        self.goDetailButton.hidden = NO;
    }
}

@end
