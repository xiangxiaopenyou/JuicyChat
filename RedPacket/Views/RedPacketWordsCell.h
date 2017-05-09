//
//  RedPacketWordsCell.h
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/9.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedPacketWordsCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@end
