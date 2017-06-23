//
//  JCMySignCell.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/6/22.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "JCMySignCell.h"
#import "Masonry.h"
#import "UIColor+RCColor.h"

@interface JCMySignCell ()

@end

@implementation JCMySignCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = @"个性签名";
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.contentView.mas_leading).with.mas_offset(10);
            make.centerY.equalTo(self.contentView);
        }];
        
        UIImageView *rightArrow = [[UIImageView alloc] init];
        rightArrow.image = [UIImage imageNamed:@"right_arrow"];
        [self.contentView addSubview:rightArrow];
        [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.contentView.mas_trailing).with.mas_offset(- 10);
            make.centerY.equalTo(self.contentView);
            make.size.mas_offset(CGSizeMake(8, 13));
        }];
        
        [self.contentView addSubview:self.signLabel];
        [self.signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(rightArrow.mas_leading).with.mas_offset(- 10);
            make.centerY.equalTo(self.contentView);
            make.leading.equalTo(self.contentView.mas_leading).with.mas_offset(100);
        }];
        
        UIImageView *line = [[UIImageView alloc] init];
        line.backgroundColor = [UIColor colorWithHexString:@"dfdfdf" alpha:1.0];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.trailing.equalTo(self.contentView);
            make.leading.equalTo(self.contentView.mas_leading).with.mas_offset(10);
            make.height.mas_offset(0.5);
        }];
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

- (UILabel *)signLabel {
    if (!_signLabel) {
        _signLabel = [[UILabel alloc] init];
        _signLabel.font = [UIFont systemFontOfSize:14];
        _signLabel.textColor = [UIColor colorWithHexString:@"999999" alpha:1];
        _signLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _signLabel.numberOfLines = 0;
        _signLabel.textAlignment = NSTextAlignmentRight;
        _signLabel.text = @"啊点击发送电缆附件啊但是冷风机的撒李开复绝对是";
    }
    return _signLabel;
}

@end
