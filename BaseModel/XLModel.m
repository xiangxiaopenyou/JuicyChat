//
//  XLModel.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/8/21.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "XLModel.h"

@implementation XLModel
+ (NSArray *)setupWithArray:(NSArray *)array {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSDictionary *dictionary in array) {
        NSError *error;
        XLModel *model = [[[self class] alloc] initWithDictionary:dictionary error:&error];
        [resultArray addObject:model];
    }
    return resultArray;
}
+ (NSArray *)dictionaryArrayFromModelArray:(NSArray *)array {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (XLModel *model in array) {
        NSDictionary *dictionary = [model toDictionary];
        [resultArray addObject:dictionary];
    }
    return resultArray;
}


@end
