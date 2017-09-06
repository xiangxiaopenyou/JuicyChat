//
//  RedPacketDetailViewController.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/13.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "RedPacketDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "RedPacketRequest.h"
#import "RedPacketMembersRequest.h"
#import "RedPacketMemberCell.h"
#import "RCDUtilities.h"

@interface RedPacketDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *senderAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *senderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@end

@implementation RedPacketDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
    self.senderAvatarImageView.layer.masksToBounds = YES;
    self.senderAvatarImageView.layer.cornerRadius = 5.0;
    self.senderAvatarImageView.layer.borderWidth = 1.0;
    self.senderAvatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    if (self.redPacketNumber) {
        self.amountLabel.hidden = NO;
        self.unitLabel.hidden = NO;
        NSString *numberString = [RCDUtilities amountStringFromNumber:@(self.redPacketNumber)];
        self.amountLabel.text = numberString;
    }
    if (self.avatarUrl) {
        [self.senderAvatarImageView sd_setImageWithURL:[NSURL URLWithString:self.avatarUrl]];
    }
    if (self.nickname) {
        self.senderNameLabel.text = self.nickname;
    }
    if (self.noteString) {
        self.noteLabel.text = self.noteString;
    }
    [self fetchDetails];
//    [self fetchMembers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Requests
- (void)fetchDetails {
    [[RedPacketRequest new] request:^BOOL(RedPacketRequest *request) {
        request.redPacketId = self.redPacketId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (object) {
            NSDictionary *temp = [object copy];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!self.avatarUrl) {
                    [self.senderAvatarImageView sd_setImageWithURL:[NSURL URLWithString:temp[@"fromheadico"]]];
                }
                if (!self.nickname) {
                    self.senderNameLabel.text = temp[@"fromnickname"];
                }
                if (!self.noteString) {
                    self.noteLabel.text = temp[@"note"];
                }
                if ([temp[@"state"] integerValue] != 2) {
                    if (self.isPrivateChat) {
                        NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
                        if (userId.integerValue == [temp[@"fromuserid"] integerValue]) {
                            self.detailLabel.text = [NSString stringWithFormat:@"红包金额%@果币，等待对方领取", temp[@"money"]];
                        } else {
                            self.detailLabel.text = nil;
                        }
                        
                    } else {
                        NSInteger unpacksummoney;
                        if ([temp[@"unpacksummoney"] isKindOfClass:[NSNull class]]) {
                            unpacksummoney = 0;
                        } else {
                            unpacksummoney = [temp[@"unpacksummoney"] integerValue];
                        }
                        self.detailLabel.text = [NSString stringWithFormat:@"已领取%@/%@个, 共%@/%@果币", @([temp[@"unpackcount"] integerValue]), temp[@"count"], @(unpacksummoney), @([temp[@"money"] integerValue])];
                    }
                    
                } else {
                    if (self.isPrivateChat) {
                        NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
                        if (userId.integerValue == [temp[@"fromuserid"] integerValue]) {
                            self.detailLabel.text = [NSString stringWithFormat:@"1个红包共%@果币", temp[@"money"]];
                        } else {
                            self.detailLabel.text = nil;
                        }
                    } else {
                        NSInteger second = [temp[@"duration"] integerValue];
                        NSString *timeString = [self timeString:second];
                        self.detailLabel.text = [NSString stringWithFormat:@"%@个红包共%@果币，%@被抢光", temp[@"count"], temp[@"money"], timeString];
                    }
                    
                }
            });
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];
}
//- (void)fetchMembers {
//    [[RedPacketMembersRequest new] request:^BOOL(RedPacketMembersRequest *request) {
//        request.redPacketId = self.redPacketId;
//        return YES;
//    } result:^(id object, NSString *msg) {
//        if (object) {
//            _membersArray = [(NSArray *)object copy];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (!self.redPacketNumber) {
//                    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
//                    for (NSDictionary *temp in _membersArray) {
//                        if ([temp[@"userId"] isEqualToString:userId]) {
//                            self.amountLabel.hidden = NO;
//                            self.unitLabel.hidden = NO;
//                            self.amountLabel.text = [NSString stringWithFormat:@"%@", @(self.redPacketNumber)];
//                        }
//                    }
//                }
//                [self.tableView reloadData];
//            });
//        } else {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
//        }
//    }];
//}

- (IBAction)closeAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)timeString:(NSInteger)second {
    NSString *string = nil;
    if (second < 60) {
        string = [NSString stringWithFormat:@"%@秒", @(second)];
    } else if (second >= 60 && second < 3600) {
        if (second % 60 == 0) {
            string = [NSString stringWithFormat:@"%@分", @(second / 60)];
        } else {
            string = [NSString stringWithFormat:@"%@分%@秒", @(second / 60), @(second % 60)];
        }
    } else {
        NSInteger hours = second / 3600;
        if (second % 3600 == 0) {
            string = [NSString stringWithFormat:@"%@小时", @(hours)];
        } else if ((second - 3600 * hours) % 60 == 0) {
            string = [NSString stringWithFormat:@"%@小时%@分", @(hours), @((second - 3600 * hours) / 60)];
        } else {
            NSInteger minutes = (second - hours * 3600) / 60;
            string = [NSString stringWithFormat:@"%@小时%@分%@秒",@(hours), @(minutes), @(second - hours * 3600 - minutes * 60)];
        }
    }
    return string;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _membersArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 62.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RedPacketMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCell" forIndexPath:indexPath];
    cell.avatarImage.layer.masksToBounds = YES;
    cell.avatarImage.layer.cornerRadius = 5.0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *temp = _membersArray[indexPath.row];
    [cell.avatarImage sd_setImageWithURL:[NSURL URLWithString:temp[@"headico"]]];
    cell.nicknameLabel.text = [NSString stringWithFormat:@"%@", temp[@"nickname"]];
//    cell.amountLabel.text = [NSString stringWithFormat:@"%@", temp[@"unpackmoney"]];
    NSNumber *tempAmount = @([temp[@"unpackmoney"] integerValue]);
    cell.amountLabel.text = [RCDUtilities amountStringFromNumber:tempAmount];
    if ([temp[@"userid"] integerValue] == [self.informations[@"bestluckuserid"] integerValue] && !self.isPrivateChat) {
        cell.bestLuckLabel.hidden = NO;
    } else {
        cell.bestLuckLabel.hidden = YES;
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y >= 50) {
        self.navigationView.backgroundColor = [UIColor colorWithRed:227/255.0 green:67/255.0 blue:70/255.0 alpha:1];
    } else {
        self.navigationView.backgroundColor = [UIColor clearColor];
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
