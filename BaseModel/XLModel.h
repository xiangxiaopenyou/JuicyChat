//
//  XLModel.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/8/21.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "JSONModel.h"
#import "BaseRequest.h"

@interface XLModel : JSONModel
+ (NSArray *)setupWithArray:(NSArray *)array;
+ (NSArray *)dictionaryArrayFromModelArray:(NSArray *)array;
@end
