//
//  WCMonthPickerView.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/8/21.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "WCMonthPickerView.h"
#import "UIColor+RCColor.h"
#import "Masonry.h"

@interface WCMonthPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (nonatomic) NSInteger selectedYear;
@property (nonatomic) NSInteger selectedMonth;
@property (strong, nonatomic) NSMutableArray *yearArray;
@property (strong, nonatomic) NSMutableArray *monthArray;
@end
@implementation WCMonthPickerView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        
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
        
        UILabel *line = [[UILabel alloc] init];
        line.backgroundColor = [UIColor colorWithHexString:@"0F83FF" alpha:1];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.equalTo(self.contentView);
            make.height.mas_offset(0.5);
        }];
        
        [self.contentView addSubview:self.submitButton];
        [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.trailing.equalTo(self.contentView);
            make.size.mas_offset(CGSizeMake(60, 40));
        }];
        [self.contentView addSubview:self.cancelButton];
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.equalTo(self.contentView);
            make.size.mas_offset(CGSizeMake(60, 40));
        }];
        
        [self.contentView addSubview:self.pickerView];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(self.contentView);
            make.height.mas_offset(216);
        }];
        self.hidden = YES;
        
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy"];
        NSInteger currentYear=[[formatter stringFromDate:nowDate] integerValue];
        [formatter setDateFormat:@"MM"];
        NSInteger currentMonth=[[formatter stringFromDate:nowDate] integerValue];
        for (NSInteger i = 2017; i <= currentYear; i ++) {
            [self.yearArray addObject:@(i)];
        }
        if (currentYear == 2017) {
            for (NSInteger i = 6; i <= currentMonth; i ++) {
                [self.monthArray addObject:@(i)];
            }
        } else {
            for (NSInteger i = 1; i <= currentMonth; i ++) {
                [self.monthArray addObject:@(i)];
            }
        }
        _selectedYear = currentYear;
        _selectedMonth = currentMonth;
        
        [self.pickerView selectRow:self.yearArray.count - 1 inComponent:0 animated:YES];
        [self.pickerView selectRow:self.monthArray.count - 1 inComponent:1 animated:YES];
    }
    return self;
}

- (void)selectYear:(NSInteger)year month:(NSInteger)month {
}
- (void)submitAction {
    if (self.selectBlock) {
        self.selectBlock(_selectedYear, _selectedMonth);
    }
    [self dismiss];
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

#pragma mark - Picker view data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return component == 0? self.yearArray.count : self.monthArray.count;
}

#pragma mark - Picker view delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return component == 0 ? [NSString stringWithFormat:@"%@", self.yearArray[row]] : [NSString stringWithFormat:@"%@", self.monthArray[row]];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return component == 0 ? CGRectGetWidth([UIApplication sharedApplication].keyWindow.bounds) * 0.3 : CGRectGetWidth([UIApplication sharedApplication].keyWindow.bounds) * 0.3;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _selectedYear = [self.yearArray[row] integerValue];
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy"];
        NSInteger currentYear=[[formatter stringFromDate:nowDate] integerValue];
        [formatter setDateFormat:@"MM"];
        NSInteger currentMonth=[[formatter stringFromDate:nowDate] integerValue];
        if (_selectedYear == 2017) {
            if (_selectedYear == currentYear) {
                [self.monthArray removeAllObjects];
                for (NSInteger i = 6; i <= currentMonth; i ++) {
                    [self.monthArray addObject:@(i)];
                }
            } else {
                self.monthArray = [@[@6, @7, @8, @9, @10, @11, @12] mutableCopy];
            }
        } else {
            if (_selectedYear == currentYear) {
                [self.monthArray removeAllObjects];
                for (NSInteger i = 1; i <= currentMonth; i ++) {
                    [self.monthArray addObject:@(i)];
                }
            } else {
                self.monthArray = [@[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11, @12] mutableCopy];
            }
        }
        [pickerView reloadComponent:1];
    } else {
        _selectedMonth = [self.monthArray[row] integerValue];
    }
}

#pragma mark - Getters
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}
- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"确定" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor colorWithHexString:@"0F83FF" alpha:1] forState:UIControlStateNormal];
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_submitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"999999" alpha:1] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
- (NSMutableArray *)yearArray {
    if (!_yearArray) {
        _yearArray = [[NSMutableArray alloc] init];
    }
    return _yearArray;
}
- (NSMutableArray *)monthArray {
    if (!_monthArray) {
        _monthArray = [[NSMutableArray alloc] init];
    }
    return _monthArray;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
