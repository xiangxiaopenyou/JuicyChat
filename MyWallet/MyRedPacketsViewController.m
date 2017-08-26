//
//  MyRedPacketsViewController.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/18.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "MyRedPacketsViewController.h"
#import "WCRedPacketDetailTableViewController.h"
#import "WCRedpacketRecordCell.h"

#import "WCRedpacketModel.h"
#import "MyRedPacketsRequest.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "RCDUtilities.h"
#import "MJRefresh.h"
#import "UIColor+RCColor.h"

#import <RongIMKit/RongIMKit.h>

@interface MyRedPacketsViewController () <UITableViewDelegate, UITableViewDataSource>
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
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSDictionary *informations;
@property (strong, nonatomic) NSMutableArray *receivedArray;
@property (strong, nonatomic) NSMutableArray *sentArray;
@property (nonatomic) NSInteger receicedIndex;
@property (nonatomic) NSInteger sentIndex;

@end

@implementation MyRedPacketsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setMj_footer:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.receivedButton.selected) {
            [self receivedRequest];
        } else {
            [self sentRequest];
        }
    }]];
    self.tableView.mj_footer.hidden = YES;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self myRedPacketsRecord];
    _receicedIndex = 1;
    _sentIndex = 1;
    [self receivedRequest];
    [self sentRequest];
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
        [self.tableView reloadData];
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
        [self.tableView reloadData];
    }
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)myRedPacketsRecord {
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
- (void)receivedRequest {
    [WCRedpacketModel receivedRedPacketRecord:@(_receicedIndex) handler:^(id object, NSString *msg) {
        [self.tableView.mj_footer endRefreshing];
        if (object) {
            NSArray *resultArray = [object copy];
            if (_receicedIndex == 1) {
                self.receivedArray = [resultArray mutableCopy];
            } else {
                NSMutableArray *tempArray = [self.receivedArray mutableCopy];
                [tempArray addObjectsFromArray:resultArray];
                self.receivedArray = [tempArray mutableCopy];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                if (resultArray.count < 20) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    self.tableView.mj_footer.hidden = YES;
                } else {
                    _receicedIndex += 1;
                    self.tableView.mj_footer.hidden = NO;
                }
            });
        } else {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil] show];
        }
    }];
}
- (void)sentRequest {
    [WCRedpacketModel sentRedPacketRecord:@(_sentIndex) handler:^(id object, NSString *msg) {
        [self.tableView.mj_footer endRefreshing];
        if (object) {
            NSArray *resultArray = [object copy];
            if (_sentIndex == 1) {
                self.sentArray = [resultArray mutableCopy];
            } else {
                NSMutableArray *tempArray = [self.sentArray mutableCopy];
                [tempArray addObjectsFromArray:resultArray];
                self.sentArray = [tempArray mutableCopy];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                if (resultArray.count < 20) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    self.tableView.mj_footer.hidden = YES;
                } else {
                    _sentIndex += 1;
                    self.tableView.mj_footer.hidden = NO;
                }
            });
        } else {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil] show];
        }
    }];
}

- (void)refreshInformations {
    RCUserInfo *userInfo = [RCIM sharedRCIM].currentUserInfo;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri] placeholderImage:nil];
    self.receivedCountLabel.text =  [NSString stringWithFormat:@"%@", @([self.informations[@"receivecount"] integerValue])];
    self.sendCountLabel.text = [NSString stringWithFormat:@"发出红包%@个", @([self.informations[@"sendcount"] integerValue])];
    self.bestLuckCountLabel.text = [NSString stringWithFormat:@"%@", @([self.informations[@"bestluckcount"] integerValue])];
    if (self.receivedButton.selected) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@共收到", userInfo.name];
        self.amountLabel.text = [RCDUtilities amountStringFromNumber:@([self.informations[@"moneyreceive"] integerValue])];
        self.infoView.hidden = NO;
        self.sendCountLabel.hidden = YES;
    } else {
        self.nameLabel.text =[ NSString stringWithFormat:@"%@共发出", userInfo.name];
        self.amountLabel.text = [RCDUtilities amountStringFromNumber:@([self.informations[@"moneysend"] integerValue])];
        self.infoView.hidden = YES;
        self.sendCountLabel.hidden = NO;
    }
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.receivedButton.selected ? self.receivedArray.count : self.sentArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 71.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"RedpacketRecordCell";
    WCRedpacketRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (self.receivedButton.selected) {
        WCRedpacketModel *tempModel = self.receivedArray[indexPath.row];
        if (tempModel.type.integerValue == 1) {
            cell.headLabel.text = tempModel.fromuser;
        } else {
            cell.headLabel.text = @"群红包";
        }
        cell.timeLabel.text = [RCDUtilities commonDateString:tempModel.createtime];
        NSString *moneyString = [RCDUtilities amountStringFromNumber:tempModel.unpackmoney];
        cell.moneyLabel.text = [NSString stringWithFormat:@"%@ 果币", moneyString];
        cell.numberLabel.hidden = YES;
    } else {
        WCRedpacketModel *tempModel = self.sentArray[indexPath.row];
        cell.headLabel.text = tempModel.type.integerValue == 1 ? tempModel.tomember : @"群红包";
        cell.timeLabel.text = [RCDUtilities commonDateString:tempModel.createtime];
        NSString *moneyString = [RCDUtilities amountStringFromNumber:tempModel.money];
        cell.moneyLabel.text = [NSString stringWithFormat:@"%@ 果币", moneyString];
        cell.numberLabel.hidden = NO;
        if (tempModel.state.integerValue == 2) {
            cell.numberLabel.textColor = [UIColor colorWithHexString:@"999999" alpha:1];
            cell.numberLabel.text = [NSString stringWithFormat:@"已领完%@/%@个", tempModel.unpackcount, tempModel.count];
        } else {
            cell.numberLabel.textColor = [UIColor colorWithHexString:@"fd625a" alpha:1];
            cell.numberLabel.text = [NSString stringWithFormat:@"已领取%@/%@个", tempModel.unpackcount, tempModel.count];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WCRedPacketDetailTableViewController *detailController = [[UIStoryboard storyboardWithName:@"RedPacket" bundle:nil] instantiateViewControllerWithIdentifier:@"RedPacketRecordDetail"];
    if (self.receivedButton.selected) {
        detailController.model = self.receivedArray[indexPath.row];
        detailController.isSent = NO;
    } else {
        detailController.model = self.sentArray[indexPath.row];
        detailController.isSent = YES;
    }
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark - Getters
- (NSMutableArray *)receivedArray {
    if (!_receivedArray) {
        _receivedArray = [[NSMutableArray alloc] init];
    }
    return _receivedArray;
}
- (NSMutableArray *)sentArray {
    if (!_sentArray) {
        _sentArray = [[NSMutableArray alloc] init];
    }
    return _sentArray;
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
