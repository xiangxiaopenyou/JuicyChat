//
//  WCRedPacketDetailTableViewController.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/8/23.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "WCRedPacketDetailTableViewController.h"
#import "WCTransferMoneyCell.h"
#import "WCTransferInformationCell.h"

#import "WCRedpacketModel.h"
#import "RCDUtilities.h"
#import "UIImageView+WebCache.h"

@interface WCRedPacketDetailTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation WCRedPacketDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.avatarImageView.image = [UIImage imageNamed:@"icon_redpackets"];
    self.nameLabel.text = self.model.type.integerValue == 1 ? @"普通红包" : @"群红包";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    if (indexPath.row == 1 || indexPath.row == 7) {
        height = 10.f;
    } else if (indexPath.row == 0) {
        height = 57.f;
    } else {
        height = 30.f;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1 || indexPath.row == 7) {
        UITableViewCell *cell = [UITableViewCell new];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return  cell;
    }
    if (indexPath.row == 0) {
        static NSString *identifier = @"TransferMoneyCell";
        WCTransferMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        if (self.isSent) {
            NSString *moneyString = [RCDUtilities amountStringFromNumber:self.model.money];
            cell.moneyLabel.text = [NSString stringWithFormat:@"-%@ 果币", moneyString];
        } else {
            NSString *moneyString = [RCDUtilities amountStringFromNumber:self.model.unpackmoney];
            cell.moneyLabel.text = [NSString stringWithFormat:@"+%@ 果币", moneyString];
        }
        return cell;
    } else {
        static NSString *identifier = @"TransferInformationCell";
        WCTransferInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.checkButton.hidden = YES;
        switch (indexPath.row) {
            case 2:{
                cell.headLabel.text = @"红包详情";
                cell.checkButton.hidden = NO;
                cell.rightLabel.text = nil;
            }
                break;
            case 3:{
                if (self.model.type.integerValue == 1) {
                    cell.headLabel.text = self.isSent ? @"收包人" : @"发包人";
                    cell.rightLabel.text = self.isSent ? self.model.tomember : self.model.fromuser;
                } else {
                    cell.headLabel.text = self.isSent ? @"收包群" : @"发包群";
                    cell.rightLabel.text = self.model.tomember;
                }
                
            }
                break;
            case 4:{
                cell.headLabel.text = @"红包说明";
                cell.rightLabel.text = self.model.note ? self.model.note : @"恭喜发财，大吉大利";
            }
                break;
            case 5:{
                cell.headLabel.text = @"红包状态";
                if (self.model.state.integerValue == 1) {
                    cell.rightLabel.text = @"未领完";
                } else if (self.model.state.integerValue == 2) {
                    cell.rightLabel.text = @"领取完毕";
                } else {
                    cell.rightLabel.text = @"已过期";
                }
            }
                break;
            case 6:{
                cell.headLabel.text = @"红包时间";
                NSString *timeString = [self.model.createtime substringToIndex:19];
                timeString = [timeString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                cell.rightLabel.text = timeString;
            }
                break;
            default:
                break;
        }
        return cell;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
