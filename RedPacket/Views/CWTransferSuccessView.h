//
//  CWTransferSuccessView.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/7/31.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWTransferSuccessView : UIView
@property (strong, nonatomic) UILabel *senderLabel;
@property (strong, nonatomic) UILabel *receiverLabel;
@property (strong, nonatomic) UILabel *amountLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (copy, nonatomic) void (^closeBlock)();

- (void)show;

@end
