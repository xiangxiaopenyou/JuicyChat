//
//  EntryPasswordView.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/11.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "EntryPasswordView.h"
#import "SYPasswordView.h"
#import "Masonry.h"
#import "RCDUtilities.h"
@interface EntryPasswordView ()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) SYPasswordView *passwordView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImageView *goldImageView;
@property (strong, nonatomic) UILabel *amountLabel;
@property (strong, nonatomic) UILabel *balanceLabel;
@end

@implementation EntryPasswordView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        [self.contentView addSubview:self.closeButton];
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.equalTo(self.contentView);
            make.size.mas_offset(CGSizeMake(35, 35));
        }];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.mas_offset(15);
            make.centerX.equalTo(self.contentView);
        }];
        [self.contentView addSubview:self.passwordView];
        
        UILabel *line1 = [[UILabel alloc] init];
        line1.backgroundColor = [UIColor colorWithRed:129/255.0 green:206/255.0 blue:242/255.0 alpha:1];
        [self.contentView addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).with.mas_offset(10);
            make.leading.trailing.equalTo(self.contentView);
            make.height.mas_offset(0.5);
        }];
        [self.contentView addSubview:self.amountLabel];
        [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line1.mas_bottom).with.mas_offset(18);
            make.centerX.equalTo(self.contentView).with.mas_offset(10);
        }];
        
        [self.contentView addSubview:self.goldImageView];
        [self.goldImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.amountLabel.mas_leading).with.mas_offset(-5);
            make.top.equalTo(line1.mas_bottom).with.mas_offset(20);
            make.size.mas_offset(CGSizeMake(25, 25));
        }];
        
        UILabel *line2 = [[UILabel alloc] init];
        line2.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
        [self.contentView addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.amountLabel.mas_bottom).with.mas_offset(12);
            make.leading.equalTo(self.contentView.mas_leading).with.mas_offset(15);
            make.trailing.equalTo(self.contentView.mas_trailing).with.mas_offset(- 15);
            make.height.mas_offset(0.5);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor grayColor];
        label.text = @"剩余果币";
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line2.mas_bottom).with.mas_offset(10);
            make.leading.equalTo(self.contentView.mas_leading).with.mas_offset(15);
        }];
        
        [self.contentView addSubview:self.balanceLabel];
        [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line2.mas_bottom).with.mas_offset(10);
            make.trailing.equalTo(self.contentView.mas_trailing).with.mas_offset(- 18);
        }];
        
        UILabel *line3 = [[UILabel alloc] init];
        line3.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
        [self.contentView addSubview:line3];
        [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.balanceLabel.mas_bottom).with.mas_offset(10);
            make.leading.equalTo(self.contentView.mas_leading).with.mas_offset(15);
            make.trailing.equalTo(self.contentView.mas_trailing).with.mas_offset(- 15);
            make.height.mas_offset(0.5);
        }];
    }
    return self;
}
- (void)show {
//    self.alpha = 1.0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.passwordView.textField becomeFirstResponder];
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
//    [UIView animateWithDuration:0.4 animations:^{
//        self.alpha = 0;
//    } completion:^(BOOL finished) {
        [self removeFromSuperview];
//    }];
//    CAKeyframeAnimation *hideAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    hideAnimation.duration = 0.4;
//    hideAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
//                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
//                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.00f, 0.00f, 0.00f)]];
//    hideAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f];
//    hideAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
//                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
//                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    [self.contentView.layer addAnimation:hideAnimation forKey:nil];
    [self clearPassword];
}
- (void)clearPassword {
    [self.passwordView clearUpPassword];
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
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(UIScreen.mainScreen.bounds) / 2 - 140, 120, 280, 220)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.clipsToBounds = YES;
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 5.0;
    }
    return _contentView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = @"请输入支付密码";
    }
    return _titleLabel;
}
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"btn_exit"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
- (SYPasswordView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[SYPasswordView alloc] initWithFrame:CGRectMake(15, 165, 240, 40)];
    }
    return _passwordView;
}
- (UIImageView *)goldImageView {
    if (!_goldImageView) {
        _goldImageView = [[UIImageView alloc] init];
        _goldImageView.image = [UIImage imageNamed:@"guobi"];
    }
    return _goldImageView;
}
- (UILabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.font = [UIFont systemFontOfSize:25];
        _amountLabel.textColor = [UIColor blackColor];
    }
    return _amountLabel;
}
-(UILabel *)balanceLabel {
    if (!_balanceLabel) {
        _balanceLabel = [[UILabel alloc] init];
        _balanceLabel.font = [UIFont systemFontOfSize:12];
        _balanceLabel.textColor = [UIColor grayColor];
    }
    return _balanceLabel;
}
- (void)setAmount:(NSInteger)amount {
    self.amountLabel.text = [RCDUtilities amountStringFromNumber:@(amount)];
}
- (void)setBalance:(NSInteger)balance {
    self.balanceLabel.text = [RCDUtilities amountStringFromNumber:@(balance)];
}

@end
