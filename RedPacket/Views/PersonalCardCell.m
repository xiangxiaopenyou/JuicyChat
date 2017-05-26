//
//  PersonalCardCell.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/26.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "PersonalCardCell.h"
#import "PersonalCardMessage.h"
#import "UIImageView+WebCache.h"

@implementation PersonalCardCell
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model withCollectionViewWidth:(CGFloat)collectionViewWidth referenceExtraHeight:(CGFloat)extraHeight {
    return CGSizeMake(collectionViewWidth, 90.f + extraHeight);
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
    [self.messageContentView addSubview:self.bubbleBackgroundView];
    
    self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.bubbleBackgroundView addSubview:self.avatarImageView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.nameLabel setFont:[UIFont systemFontOfSize:15]];
    self.nameLabel.textColor = [UIColor blackColor];
    [self.bubbleBackgroundView addSubview:self.nameLabel];
    
    self.line = [[UILabel alloc] initWithFrame:CGRectZero];
    self.line.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    [self.bubbleBackgroundView addSubview:self.line];
    
    self.cardLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.cardLabel.textColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
    self.cardLabel.font = [UIFont systemFontOfSize:10];
    self.cardLabel.text = @"个人名片";
    [self.bubbleBackgroundView addSubview:self.cardLabel];
    self.bubbleBackgroundView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(tapPressed:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.bubbleBackgroundView addGestureRecognizer:tap];
    
}
- (void)tapPressed:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}
- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    [self setAutoLayout];
}
- (void)setAutoLayout {
    PersonalCardMessage *message = (PersonalCardMessage *)self.model.content;
    if (message) {
        self.nameLabel.text = message.name;
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:message.portraitUri]];
    }
    if (self.messageDirection == MessageDirection_RECEIVE) {
        self.avatarImageView.frame = CGRectMake(20, 10, 40, 40);
        self.nameLabel.frame = CGRectMake(65, 20, CGRectGetWidth(self.messageContentView.frame) - 70, 20);
        self.cardLabel.frame = CGRectMake(20, 70, 50, 15);
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, CGRectGetWidth(self.messageContentView.frame), 90);
        UIImage *image = [RCKitUtility imageNamed:@"chat_from_bg_normal" ofBundle:@"RongCloud.bundle"];
        self.bubbleBackgroundView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.8, image.size.height * 0.2, image.size.width * 0.2)];
        self.line.frame = CGRectMake(7, 65, CGRectGetWidth(self.messageContentView.frame) - 8, 0.5);
    } else {
        self.avatarImageView.frame = CGRectMake(10, 10, 40, 40);
        self.nameLabel.frame = CGRectMake(55, 20, CGRectGetWidth(self.messageContentView.frame) - 60, 20);
        self.cardLabel.frame = CGRectMake(10, 70, 50, 15);
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, CGRectGetWidth(self.messageContentView.frame), 90);
        UIImage *image = [RCKitUtility imageNamed:@"chat_to_bg_white" ofBundle:@"RongCloud.bundle"];
        self.bubbleBackgroundView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.2, image.size.height * 0.2, image.size.width * 0.8)];
        self.line.frame = CGRectMake(0, 65, CGRectGetWidth(self.messageContentView.frame) - 7, 0.5);
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
