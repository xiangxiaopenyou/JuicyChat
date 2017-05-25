//
//  AddFriendMessageCell.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/21.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "AddFriendMessageCell.h"

@implementation AddFriendMessageCell
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model withCollectionViewWidth:(CGFloat)collectionViewWidth referenceExtraHeight:(CGFloat)extraHeight {
    return CGSizeMake(collectionViewWidth, 20 + extraHeight);
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
    self.bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.bubbleBackgroundView.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    self.bubbleBackgroundView.layer.masksToBounds = YES;
    self.bubbleBackgroundView.layer.cornerRadius = 5.0;
    [self.baseContentView addSubview:self.bubbleBackgroundView];
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.textLabel.font = [UIFont systemFontOfSize:12];
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self.baseContentView addSubview:self.textLabel];
}
- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    [self setAutoLayout];
}
- (void)setAutoLayout {
    AddFriendMessage *message = (AddFriendMessage *)self.model.content;
    if (message) {
        NSString *oprationString = message.operation;
        if ([oprationString isEqualToString:@"AcceptResponse"] || [oprationString isEqualToString:@"Request"]) {
            self.textLabel.text = @"你们已经是好友了，可以开始聊天了";
        }
    }
    self.bubbleBackgroundView.frame = CGRectMake(CGRectGetWidth(self.baseContentView.frame) / 2.0 - 120, 10, 240, 20);
    self.textLabel.frame = CGRectMake(60, 10, CGRectGetWidth([UIScreen mainScreen].bounds) - 120, 20);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
