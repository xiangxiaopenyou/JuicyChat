//
//  TakeApartPacketView.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/13.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TakeApartPacketViewDelegate<NSObject>
- (void)packetViewDidClickOpen;
- (void)packetViewDidClickGoDetail;
@end
@interface TakeApartPacketView : UIView
@property (copy, nonatomic) NSDictionary *informations;
@property (assign, nonatomic) NSInteger resultState;
@property (assign, nonatomic) BOOL isPrivateChat;

@property (weak, nonatomic) id<TakeApartPacketViewDelegate> delegate;
- (void)show;
- (void)dismiss;

@end
