//
//  WCMonthPickerView.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/8/21.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCMonthPickerView : UIView
@property (copy, nonatomic) void (^selectBlock)(NSInteger year, NSInteger month);

- (void)show;
- (void)selectYear:(NSInteger)year month:(NSInteger)month;

@end
