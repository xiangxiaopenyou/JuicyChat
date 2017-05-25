//
//  MyRedPacketsViewController.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/18.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "MyRedPacketsViewController.h"

#import "MyRedPacketsRequest.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

#import <RongIMKit/RongIMKit.h>

@interface MyRedPacketsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *receivedButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipLabelLeadingConstraints;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *sendCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *receivedCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestLuckCountLabel;

@property (copy, nonatomic) NSDictionary *informations;

@end

@implementation MyRedPacketsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self myRedPacketsRecord];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)receiveAction:(id)sender {
    if (!self.receivedButton.selected) {
        self.receivedButton.selected = YES;
        self.sendButton.selected = NO;
        self.tipLabelLeadingConstraints.constant = 0;
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded];
        }];
        [self refreshInformations];
    }
}
- (IBAction)sendAction:(id)sender {
    if (!self.sendButton.selected) {
        self.sendButton.selected = YES;
        self.receivedButton.selected = NO;
        self.tipLabelLeadingConstraints.constant = CGRectGetWidth([UIScreen mainScreen].bounds) / 2.0;
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded];
        }];
        [self refreshInformations];
    }
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)myRedPacketsRecord {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MyRedPacketsRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (object) {
            self.informations = [(NSDictionary *)object copy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshInformations];
            });
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];
}
- (void)refreshInformations {
    RCUserInfo *userInfo = [RCIM sharedRCIM].currentUserInfo;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri] placeholderImage:nil];
    self.receivedCountLabel.text = [NSString stringWithFormat:@"%@", @([self.informations[@"receivecount"] integerValue])];
    self.sendCountLabel.text = [NSString stringWithFormat:@"发出红包%@个", @([self.informations[@"sendcount"] integerValue])];
    self.bestLuckCountLabel.text = [NSString stringWithFormat:@"%@", @([self.informations[@"bestluckcount"] integerValue])];
    if (self.receivedButton.selected) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@共收到", userInfo.name];
        self.amountLabel.text = [NSString stringWithFormat:@"%@", @([self.informations[@"moneyreceive"] integerValue])];
        self.infoView.hidden = NO;
        self.sendCountLabel.hidden = YES;
    } else {
        self.nameLabel.text =[ NSString stringWithFormat:@"%@共发出", userInfo.name];
        self.amountLabel.text = [NSString stringWithFormat:@"%@", @([self.informations[@"moneysend"] integerValue])];
        self.infoView.hidden = YES;
        self.sendCountLabel.hidden = NO;
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
