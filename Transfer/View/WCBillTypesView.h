//
//  WCBillTypesView.h
//  SealTalk
//
//  Created by 项小盆友 on 2017/10/20.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCBillTypesView : UIView
@property (copy, nonatomic) void (^selectBlock)(NSInteger index);

- (void)setupContent:(NSArray *)dataArray;
- (void)show;

@end
