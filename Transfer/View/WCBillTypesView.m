//
//  WCBillTypesView.m
//  SealTalk
//
//  Created by 项小盆友 on 2017/10/20.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "WCBillTypesView.h"
#import "Masonry.h"
#import "RCDCommonDefine.h"
#import "UIColor+RCColor.h"

#define kXJBillButtonWidth (RCDscreenWidth - 64) / 3.0

@interface WCBillTypesView ()
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *typesView;
@property (strong, nonatomic) UIButton *selectedButton;
@property (copy, nonatomic) NSArray *typesArray;
@end

@implementation WCBillTypesView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        self.hidden = YES;
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).with.mas_offset(250);
            make.height.mas_offset(250);
        }];
        
        UIButton *backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backgroundButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backgroundButton];
        [backgroundButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.bottom.equalTo(self.contentView.mas_top);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = HEXCOLOR(0x333333);
        titleLabel.text = @"请选择账单类型";
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.mas_offset(15);
            make.centerX.equalTo(self.contentView);
        }];
        
        UIImageView *line = [[UIImageView alloc] init];
        line.backgroundColor = HEXCOLOR(0xe6e6e6);
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).with.mas_offset(15);
            make.leading.equalTo(self.contentView.mas_leading).with.mas_offset(16);
            make.trailing.equalTo(self.contentView.mas_trailing).with.mas_offset(- 16);
            make.height.mas_offset(0.5);
        }];
        [self.contentView addSubview:self.typesView];
        [self.typesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).with.mas_offset(18);
            make.leading.trailing.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}
- (void)setupContent:(NSArray *)dataArray {
    _typesArray = [dataArray copy];
    [self createTypesView];
}
- (void)createTypesView {
    [_typesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = idx + 10000;
        [self.typesView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.typesView.mas_leading).with.mas_offset(16 + idx % 3 * (16 + kXJBillButtonWidth));
            make.top.equalTo(self.typesView.mas_top).with.mas_offset(idx / 3 * 60);
            make.size.mas_offset(CGSizeMake(kXJBillButtonWidth, 42));
        }];
        NSDictionary *dictionary = [obj copy];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:[NSString stringWithFormat:@"%@", dictionary[@"typename"]] forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIColor imageWithColor:HEXCOLOR(0x009aff)] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIColor imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 4.f;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor =HEXCOLOR(0xe6e6e6).CGColor;
        if (idx == 0) {
            button.selected = YES;
            _selectedButton = button;
        }
        [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    }];
}
- (void)show {
    self.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
        }];
        [self layoutIfNeeded];
    }];
}
- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).with.mas_offset(250);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
- (void)selectAction:(UIButton *)button {
    if (button != _selectedButton) {
        _selectedButton.selected = NO;
        _selectedButton = button;
    }
    _selectedButton.selected = YES;
    if (self.selectBlock) {
        self.selectBlock(_selectedButton.tag - 10000);
    }
    [self dismiss];
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
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}
- (UIView *)typesView {
    if (!_typesView) {
        _typesView = [[UIView alloc] init];
        _typesView.backgroundColor = [UIColor clearColor];
    }
    return _typesView;
}

@end
