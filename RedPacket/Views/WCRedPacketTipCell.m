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
    if (userId.integerValue == message.touserid.integerValue) {
        NSString *contentString = message.message;
        NSArray *tempArray = [contentString componentsSeparatedByString:@"\n"];
        return CGSizeMake(collectionViewWidth, 14.f * tempArray.count + extraHeight + 23);
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
    if (userId.integerValue == message.touserid.integerValue) {
        [super setDataModel:model];
        [self setAutoLayout];
    } else {
        self.messageTimeLabel.hidden = YES;
    }
}
- (void)setAutoLayout {
    WCRedPacketTipMessage *message = (WCRedPacketTipMessage *)self.model.content;
    self.textLabel.text = message.message;
    //CGRect baseContentRect = self.baseContentView.frame;
    NSString *contentString = message.message;
    self.textLabel.text = contentString;
    NSArray *tempArray = [contentString componentsSeparatedByString:@"\n"];
    CGFloat textWidth = [tempArray[0] sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}].width;
    for (NSString *tempString in tempArray) {
        if ([tempString sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}].width > textWidth) {
            textWidth = [tempString sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}].width;
        }
    }
    [self.viewOfContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseContentView.mas_top).with.mas_offset(10);
        make.bottom.equalTo(self.baseContentView.mas_bottom).with.mas_offset(- 10);
        make.centerX.equalTo(self.baseContentView);
        make.width.mas_offset(textWidth + 20);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewOfContent.mas_top).with.mas_offset(5);
        make.leading.equalTo(self.viewOfContent.mas_leading).with.mas_offset(10);
        make.trailing.equalTo(self.viewOfContent.mas_trailing).with.mas_offset(- 10);
        make.bottom.equalTo(self.viewOfContent.mas_bottom).with.mas_offset(- 25);
    }];
    [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.viewOfContent.mas_bottom);
        make.leading.equalTo(self.viewOfContent.mas_leading).with.mas_offset(10);
        make.height.mas_offset(25);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
