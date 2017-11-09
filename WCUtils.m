//
//  WCUtils.m
//  SealTalk
//
//  Created by 项小盆友 on 2017/11/7.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "WCUtils.h"

@implementation WCUtils
+ (NSString *)amountStringFromNumber:(NSNumber *)amount {
    NSString *amountString = [NSString stringWithFormat:@"%@", amount];
    NSMutableString *mutableString = [amountString mutableCopy];
    if (amountString.length > 2) {
        for (NSInteger i = amountString.length - 2; i > 0; i -= 4) {
            [mutableString insertString:@"," atIndex:i];
        }
    }
    return mutableString;
}

@end
