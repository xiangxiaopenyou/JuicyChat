//
//  LockedDetailTableViewController.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/20.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "LockedDetailTableViewController.h"
#import "LockDetailCell.h"
#import "LockMoneyDetailRequest.h"
#import "UIImageView+WebCache.h"
#import "WCUtils.h"

@interface LockedDetailTableViewController ()
@property (copy, nonatomic) NSArray *detailArray;

@end

@implementation LockedDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableFooterView = [UIView new];
    [self lockedGroupList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)lockedGroupList {
    [[LockMoneyDetailRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (object && [object isKindOfClass:[NSArray class]]) {
            self.detailArray = [object copy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}
- (NSString *)timeStringFromDate:(NSString *)time {
    NSString *tempString = [time stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    tempString = [tempString substringWithRange:NSMakeRange(0, 19)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:tempString];
    tempString = [formatter stringFromDate:date];
    return [tempString substringWithRange:NSMakeRange(5, 11)];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.detailArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LockDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LockDetailCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *temp = [self.detailArray[indexPath.row] copy];
    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:temp[@"groupheadico"]] placeholderImage:[UIImage imageNamed:@"icon_5"]];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@", temp[@"groupname"]];
    NSString *timeString = [self timeStringFromDate:temp[@"locktime"]];
    cell.timeLabel.text = timeString;
    cell.amountLabel.text = [NSString stringWithFormat:@"- %@", [WCUtils amountStringFromNumber:@([temp[@"lockmoney"] integerValue])]];
    return cell;
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
