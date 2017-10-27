//
//  WCTransferDetailTableViewController.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/8/22.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "WCTransferDetailTableViewController.h"
#import "WCTransferMoneyCell.h"
#import "WCTransferInformationCell.h"

#import "TransferRecordModel.h"
#import "RCDUtilities.h"
#import "UIImageView+WebCache.h"

@interface WCTransferDetailTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation WCTransferDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if ([self isSender]) {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.model.touserheadico] placeholderImage:nil];
        self.nameLabel.text = self.model.touser;
    } else {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.model.fromuserheadico] placeholderImage:nil];
        self.nameLabel.text = self.model.fromuser;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isSender {
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    if ([self.model.fromuserid isEqualToString:userId]) {
        return YES;
    }
    return NO;
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
        NSString *moneyString = [RCDUtilities amountStringFromNumber:self.model.money];
        if ([self isSender]) {
            cell.moneyLabel.text = [NSString stringWithFormat:@"-%@ 果币", moneyString];
        } else {
            cell.moneyLabel.text = [NSString stringWithFormat:@"+%@ 果币", moneyString];
        }
        return cell;
    } else {
        static NSString *identifier = @"TransferInformationCell";
        WCTransferInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.checkButton.hidden = YES;
        switch (indexPath.row) {
            case 2:{
                cell.headLabel.text = @"收款方";
                cell.rightLabel.text = self.model.touser;
            }
                break;
            case 3:{
                cell.headLabel.text = @"转账说明";
                cell.rightLabel.text = self.model.note? self.model.note : @"无";
            }
                break;
            case 4:{
                cell.headLabel.text = @"当前状态";
                cell.rightLabel.text = @"已收钱";
            }
                break;
            case 5:{
                cell.headLabel.text = @"转账时间";
                NSString *timeString = [self.model.time substringToIndex:19];
                timeString = [timeString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                cell.rightLabel.text = timeString;
            }
                break;
            case 6:{
                cell.headLabel.text = @"支付方式";
                cell.rightLabel.text = self.model.option;
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
