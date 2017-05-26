//
//  RedPacketCell.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/12.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "RedPacketCell.h"

@implementation RedPacketCell
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model withCollectionViewWidth:(CGFloat)collectionViewWidth referenceExtraHeight:(CGFloat)extraHeight {
    return CGSizeMake(collectionViewWidth, 100.f + extraHeight);
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
    self.redPacketImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.messageContentView addSubview:self.redPacketImageView];
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.textLabel setFont:[UIFont systemFontOfSize:14]];
    self.textLabel.textColor = [UIColor whiteColor];
    [self.redPacketImageView addSubview:self.textLabel];
    
    self.redpacketLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.redpacketLabel.textColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
    self.redpacketLabel.font = [UIFont systemFontOfSize:10];
    self.redpacketLabel.text = @"果聊红包";
    [self.redPacketImageView addSubview:self.redpacketLabel];
    
    self.redPacketImageView.userInteractionEnabled = YES;
//    UILongPressGestureRecognizer *longPress =
//    [[UILongPressGestureRecognizer alloc]
//     initWithTarget:self
//     action:@selector(longPressed:)];
//    [self.redPacketImageView addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(tapPressed:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.redPacketImageView addGestureRecognizer:tap];
    
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
    RedPacketMessage *testMessage = (RedPacketMessage *)self.model.content;
    if (testMessage) {
        NSString *contentString = testMessage.content;
        if (contentString.length > 4) {
            contentString = [contentString substringFromIndex:4];
        }
        self.textLabel.text = contentString;
    }
    
    //CGSize bubbleBackgroundViewSize = [[self class] getBubbleSize:textLabelSize];
    CGRect messageContentViewRect = self.messageContentView.frame;
//    float maxWidth = [UIScreen mainScreen].bounds.size.width - (10 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10) * 2 - 80;
    //拉伸图片
    if (MessageDirection_RECEIVE == self.messageDirection) {
        self.redPacketImageView.frame = CGRectMake(0, 0, 225, 100);
        self.textLabel.frame = CGRectMake(60, 24, 150, 30);
        self.redpacketLabel.frame = CGRectMake(12, 78, 70, 20);
        self.redPacketImageView.image = [UIImage imageNamed:@"red_packet_to"];
        //messageContentViewRect.size.width = bubbleBackgroundViewSize.width;
        //self.messageContentView.frame = messageContentViewRect;
        
//        self.bubbleBackgroundView.frame = CGRectMake(
//                                                     0, 0, bubbleBackgroundViewSize.width, bubbleBackgroundViewSize.height);
//        UIImage *image = [RCKitUtility imageNamed:@"chat_from_bg_normal"
//                                         ofBundle:@"RongCloud.bundle"];
//        self.bubbleBackgroundView.image = [image
//                                           resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8,
//                                                                                        image.size.width * 0.8,
//                                                                                        image.size.height * 0.2,
//                                                                                        image.size.width * 0.2)];
    } else {
        //CGFloat x = [UIScreen mainScreen].bounds.size.width - 350;
        self.redPacketImageView.frame = CGRectMake(0, 0, 225, 100);
        self.textLabel.frame = CGRectMake(54, 24, 140, 30);
        self.redpacketLabel.frame = CGRectMake(7, 78, 70, 20);
        self.redPacketImageView.image = [UIImage imageNamed:@"red_packet_from"];
        
        messageContentViewRect.size.width = 225;
        messageContentViewRect.size.height = 100;
        messageContentViewRect.origin.x = [UIScreen mainScreen].bounds.size.width - 285;
        self.messageContentView.frame = messageContentViewRect;
//        self.baseContentView.bounds.size.width -
//        (messageContentViewRect.size.width + HeadAndContentSpacing +
//         [RCIM sharedRCIM].globalMessagePortraitSize.width + 10);
//        self.messageContentView.frame = messageContentViewRect;
//        
//        self.bubbleBackgroundView.frame = CGRectMake(
//                                                     0, 0, bubbleBackgroundViewSize.width, bubbleBackgroundViewSize.height);
//        UIImage *image = [RCKitUtility imageNamed:@"chat_to_bg_normal"
//                                         ofBundle:@"RongCloud.bundle"];
//        self.bubbleBackgroundView.image = [image
//                                           resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8,
//                                                                                        image.size.width * 0.2,
//                                                                                        image.size.height * 0.2,
//                                                                                        image.size.width * 0.8)];
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
