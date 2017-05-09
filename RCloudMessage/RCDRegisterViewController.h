//
//  RCDRegisterViewController.h
//  RCloudMessage
//
//  Created by Liv on 15/3/10.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCAnimatedImagesView.h"
#import <UIKit/UIKit.h>
@interface RCDRegisterViewController
    : UIViewController <RCAnimatedImagesViewDelegate>
@property (assign, nonatomic) BOOL isWechatRegister;
@property (copy, nonatomic) NSDictionary *informations;

@end
