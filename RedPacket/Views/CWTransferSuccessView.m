//
//  CWTransferSuccessView.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/7/31.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "CWTransferSuccessView.h"
#import "Masonry.h"
#import "UIColor+RCColor.h"
@interface CWTransferSuccessView ()
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImageView *successImageView;
@end

@implementation CWTransferSuccessView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        UILabel *label1 = [[UILabel alloc] init];
        label1.font = [UIFont systemFontOfSize:13];
        label1.textColor = [UIColor blackColor];
        label1.textAlignment = NSTextAlignmentRight;
        label1.text = @"转账用户：";
        [self.contentView addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.mas_offset(35);
            make.leading.equalTo(self.contentView.mas_leading).with.mas_offset(10);
            make.width.equalTo(self.contentView.mas_width).with.multipliedBy(0.5).mas_offset(- 50);
        }];
        
        [self.contentView addSubview:self.senderLabel];
        [self.senderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.mas_offset(35);
            make.leading.equalTo(label1.mas_trailing);
            make.trailing.equalTo(self.contentView.mas_trailing).with.mas_offset(- 10);
        }];
        
        UILabel *label2 = [[UILabel alloc] init];
        label2.font = [UIFont systemFontOfSize:13];
        label2.textColor = [UIColor blackColor];
        label2.textAlignment = NSTextAlignmentRight;
        label2.text = @"接收用户：";
        [self.contentView addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label1.mas_bottom).with.mas_offset(12);
            make.leading.equalTo(self.contentView.mas_leading).with.mas_offset(10);
            make.width.equalTo(self.contentView.mas_width).with.multipliedBy(0.5).mas_offset(- 50);
        }];
        
        [self.contentView addSubview:self.receiverLabel];
        [self.receiverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.senderLabel.mas_bottom).with.mas_offset(12);
            make.leading.equalTo(label2.mas_trailing);
            make.trailing.equalTo(self.contentView.mas_trailing).with.mas_offset(- 10);
        }];
        
        UILabel *label3 = [[UILabel alloc] init];
        label3.font = [UIFont systemFontOfSize:13];
        label3.textColor = [UIColor blackColor];
        label3.textAlignment = NSTextAlignmentRight;
        label3.text = @"转账果币：";
        [self.contentView addSubview:label3];
        [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label2.mas_bottom).with.mas_offset(12);
            make.leading.equalTo(self.contentView.mas_leading).with.mas_offset(10);
            make.width.equalTo(self.contentView.mas_width).with.multipliedBy(0.5).mas_offset(- 50);
        }];
        
        [self.contentView addSubview:self.amountLabel];
        [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.receiverLabel.mas_bottom).with.mas_offset(12);
            make.leading.equalTo(label3.mas_trailing);
            make.trailing.equalTo(self.contentView.mas_trailing).with.mas_offset(- 10);
        }];
        
        UILabel *label4 = [[UILabel alloc] init];
        label4.font = [UIFont systemFontOfSize:13];
        label4.textColor = [UIColor blackColor];
        label4.textAlignment = NSTextAlignmentRight;
        label4.text = @"转账时间：";
        [self.contentView addSubview:label4];
        [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label3.mas_bottom).with.mas_offset(12);
            make.leading.equalTo(self.contentView.mas_leading).with.mas_offset(10);
            make.width.equalTo(self.contentView.mas_width).with.multipliedBy(0.5).mas_offset(- 50);
        }];
        
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.amountLabel.mas_bottom).with.mas_offset(12);
            make.leading.equalTo(label4.mas_trailing);
            make.trailing.equalTo(self.contentView.mas_trailing).with.mas_offset(- 10);
        }];
        
        [self.contentView addSubview:self.successImageView];
        [self.successImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(80, 80));
            make.trailing.equalTo(self.contentView.mas_trailing).with.mas_offset(- 5);
            make.bottom.equalTo(self.contentView.mas_bottom).with.mas_offset(- 20);
        }];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [closeButton setBackgroundColor:[UIColor colorWithHexString:@"0099ff" alpha:1.0f]];
        closeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        closeButton.layer.masksToBounds = YES;
        closeButton.layer.cornerRadius = 5.f;
        [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:closeButton];
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(80, 38));
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView.mas_bottom).with.mas_offset(- 30);
        }];
    }
    return self;
}
- (void)show {
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
- (void)closeAction {
    [self removeFromSuperview];
    if (self.closeBlock) {
        self.closeBlock();
    }
}

#pragma mark - Getters
- (UILabel *)senderLabel {
    if (!_senderLabel) {
        _senderLabel = [[UILabel alloc] init];
        _senderLabel.font = [UIFont systemFontOfSize:13];
        _senderLabel.textColor = [UIColor blackColor];
    }
    return _senderLabel;
}
- (UILabel *)receiverLabel {
    if (!_receiverLabel) {
        _receiverLabel = [[UILabel alloc] init];
        _receiverLabel.font = [UIFont systemFontOfSize:13];
        _receiverLabel.textColor = [UIColor blackColor];
    }
    return _receiverLabel;
}
- (UILabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.font = [UIFont systemFontOfSize:13];
        _amountLabel.textColor = [UIColor blackColor];
    }
    return _amountLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [UIColor blackColor];
    }
    return _timeLabel;
}
- (UIImageView *)successImageView {
    if (!_successImageView) {
        _successImageView = [[UIImageView alloc] init];
        _successImageView.image = [UIImage imageNamed:@"transfer_success"];
    }
    return _successImageView;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(UIScreen.mainScreen.bounds) / 2 - 140, CGRectGetHeight(UIScreen.mainScreen.bounds) / 2 - 140, 280, 230)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.clipsToBounds = YES;
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 5.0;
    }
    return _contentView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
