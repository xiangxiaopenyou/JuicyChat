//
//  WCRedPacketTipCell.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/8/24.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "WCRedPacketTipCell.h"
#import "WCRedPacketTipMessage.h"
#import "UIColor+RCColor.h"
#import "Masonry.h"

@implementation WCRedPacketTipCell
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model withCollectionViewWidth:(CGFloat)collectionViewWidth referenceExtraHeight:(CGFloat)extraHeight {
    WCRedPacketTipMessage *message = (WCRedPacketTipMessage *)model.content;
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    NSString *showIds = message.showuserids;
    NSArray *showArray = [showIds componentsSeparatedByString:@","];
    if (userId.integerValue == message.touserid.integerValue) {
        NSString *contentString = message.iosmessage;
        if ([showArray containsObject:[NSString stringWithFormat:@"%@", message.touserid]]) {
            contentString = message.tipmessage;
        }
        NSArray *tempArray = [contentString componentsSeparatedByString:@"\n"];
        if (message.islink.integerValue == 0) {
            return CGSizeMake(collectionViewWidth, 14.f * tempArray.count + extraHeight + 14);
        } else {
            return CGSizeMake(collectionViewWidth, 14.f * tempArray.count + extraHeight + 38);
        }
    } else if ([showArray containsObject:userId]) {
        NSString *contentString = @"";
        if (message.islink.integerValue == 0) {
            contentString = message.tipmessage;
        } else {
            contentString = message.iosmessage;
        }
        NSArray *tempArray = [contentString componentsSeparatedByString:@"\n"];
        if (message.islink.integerValue == 0) {
            return CGSizeMake(collectionViewWidth, 14.f * tempArray.count + extraHeight + 14);
        } else {
            return CGSizeMake(collectionViewWidth, 14.f * tempArray.count + extraHeight + 38);
        }
    } else {
        return CGSizeMake(collectionViewWidth, 0.1);
    }
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize {
    self.viewOfContent = [[UIView alloc] initWithFrame:CGRectZero];
    self.viewOfContent.backgroundColor = [UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:1];
    self.viewOfContent.layer.masksToBounds = YES;
    self.viewOfContent.layer.cornerRadius = 5.f;
    self.viewOfContent.clipsToBounds = YES;
    [self.baseContentView addSubview:self.viewOfContent];
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.textLabel setFont:[UIFont systemFontOfSize:12]];
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.numberOfLines = 0;
    self.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.viewOfContent addSubview:self.textLabel];
    
    self.detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.detailButton setTitle:@"查看详情" forState:UIControlStateNormal];
    [self.detailButton setTitleColor:[UIColor colorWithHexString:@"0F83FF" alpha:1] forState:UIControlStateNormal];
    [self.detailButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    self.detailButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.detailButton addTarget:self action:@selector(detailAction) forControlEvents:UIControlEventTouchUpInside];
    [self.viewOfContent addSubview:self.detailButton];
}
- (void)detailAction {
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}
- (void)setDataModel:(RCMessageModel *)model {
    WCRedPacketTipMessage *message = (WCRedPacketTipMessage *)model.content;
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    NSString *showIds = message.showuserids;
    NSArray *showArray = [showIds componentsSeparatedByString:@","];
    if (userId.integerValue == message.touserid.integerValue || [showArray containsObject:userId]) {
        [super setDataModel:model];
        [self setAutoLayout];
    } else {
        self.messageTimeLabel.hidden = YES;
    }
}
- (void)setAutoLayout {
    self.clipsToBounds = YES;
    WCRedPacketTipMessage *message = (WCRedPacketTipMessage *)self.model.content;
    NSString *contentString = message.iosmessage;
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    NSString *showIds = message.showuserids;
    NSArray *showArray = [showIds componentsSeparatedByString:@","];
    if ([showArray containsObject:userId] && message.islink.integerValue == 0) {
        contentString = message.tipmessage;
    }
    self.textLabel.text = contentString;
    NSArray *tempArray = [contentString componentsSeparatedByString:@"\n"];
    CGFloat textWidth = [tempArray[0] sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}].width;
    for (NSString *tempString in tempArray) {
        if ([tempString sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}].width > textWidth) {
            textWidth = [tempString sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}].width;
        }
    }
    self.viewOfContent.frame = CGRectMake(CGRectGetWidth(self.baseContentView.frame) / 2.0 - (textWidth + 25) / 2.0, 10, textWidth + 25, CGRectGetHeight(self.baseContentView.frame) - 20);
    CGFloat bottom = message.islink.integerValue == 0 ? - 5 : -25;
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewOfContent.mas_top).with.mas_offset(5);
        make.leading.equalTo(self.viewOfContent.mas_leading).with.mas_offset(10);
        make.trailing.equalTo(self.viewOfContent.mas_trailing).with.mas_offset(- 10);
        make.bottom.equalTo(self.viewOfContent.mas_bottom).with.mas_offset(bottom);
    }];
    if (message.islink.integerValue != 0) {
        self.detailButton.hidden = NO;
        [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.viewOfContent.mas_bottom);
            make.leading.equalTo(self.viewOfContent.mas_leading).with.mas_offset(10);
            make.height.mas_offset(25);
        }];
    } else {
        self.detailButton.hidden = YES;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
