//
//  XJTransferRecordViewController.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/8/19.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "XJTransferRecordViewController.h"
#import "WCTransferDetailTableViewController.h"
#import "WCTransferRecordCell.h"
#import "WCMonthPickerView.h"

#import "TransferRecordModel.h"

#import "UIImageView+WebCache.h"
#import "UIColor+RCColor.h"
#import "RCDUtilities.h"

#import "MJRefresh.h"
#import "MBProgressHUD.h"

@interface XJTransferRecordViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) UILabel *footerLabel;
@property (strong, nonatomic) WCMonthPickerView *pickerView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (copy, nonatomic) NSString *selectedDate;
@property (nonatomic) NSInteger index;
@end

@implementation XJTransferRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UIApplication sharedApplication].keyWindow addSubview:self.pickerView];
    __weak typeof(self) weakSelf = self;
    self.pickerView.selectBlock = ^(NSInteger year, NSInteger month) {
        __strong typeof(self) strongSelf = weakSelf;
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy"];
        NSInteger currentYear=[[formatter stringFromDate:nowDate] integerValue];
        [formatter setDateFormat:@"MM"];
        NSInteger currentMonth=[[formatter stringFromDate:nowDate] integerValue];
        if (year == currentYear && month == currentMonth) {
            _selectedDate = nil;
        } else {
            _selectedDate = [NSString stringWithFormat:@"%@%02ld", @(year), (long)month];
        }
        [strongSelf recordRequest];
    };
    
    self.tableview.tableFooterView = [UIView new];
    [self.tableview setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _index = 1;
        [self recordRequest];
    }]];
    [self.tableview setMj_footer:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self recordRequest];
    }]];
    self.tableview.mj_footer.hidden = YES;
    _index = 1;
    [self recordRequest];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Requests
- (void)recordRequest {
    [TransferRecordModel transferRecord:_selectedDate index:@(_index) handler:^(id object, NSString *msg) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (object) {
            NSArray *resultArray = [object copy];
            if (_index == 1) {
                self.dataArray = [resultArray mutableCopy];
            } else {
                NSMutableArray *tempArray = [self.dataArray mutableCopy];
                [tempArray addObjectsFromArray:resultArray];
                self.dataArray = [tempArray mutableCopy];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableview reloadData];
                if (resultArray.count < 20) {
                    [self.tableview.mj_footer endRefreshingWithNoMoreData];
                    self.tableview.mj_footer.hidden = YES;
                } else {
                    _index += 1;
                    self.tableview.mj_footer.hidden = NO;
                }
                if (self.dataArray.count > 0) {
                    self.tableview.tableFooterView = [UIView new];
                    self.tableview.mj_header.hidden = NO;
                } else {
                    self.tableview.tableFooterView = self.footerLabel;
                    self.tableview.mj_header.hidden = YES;
                }
            });
        } else {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil] show];
        }
    }];
}

- (IBAction)rightItemAction:(id)sender {
    [self.pickerView show];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WCTransferRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TransferRecordCell" forIndexPath:indexPath];
    TransferRecordModel *tempModel = self.dataArray[indexPath.row];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    if ([tempModel.fromuserid isEqualToString:userId]) {
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:tempModel.touserheadico] placeholderImage:nil];
        cell.contentLabel.text = [NSString stringWithFormat:@"转账-转给%@", tempModel.touser];
        cell.moneyLabel.textColor = [UIColor colorWithHexString:@"333333" alpha:1];
        cell.moneyLabel.text = [NSString stringWithFormat:@"-%@ 果币", [RCDUtilities amountStringFromNumber:tempModel.money]];
    } else {
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:tempModel.fromuserheadico] placeholderImage:nil];
        cell.contentLabel.text = [NSString stringWithFormat:@"转账-来自%@", tempModel.fromuser];
        cell.moneyLabel.textColor = [UIColor colorWithHexString:@"ffc000" alpha:1];
        cell.moneyLabel.text = [NSString stringWithFormat:@"+%@ 果币", [RCDUtilities amountStringFromNumber:tempModel.money]];
    }
    cell.timeLabel.text = [RCDUtilities commonDateString:tempModel.createtime];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TransferRecordModel *tempModel = self.dataArray[indexPath.row];
    WCTransferDetailTableViewController *detailController = [self.storyboard instantiateViewControllerWithIdentifier:@"TransferDetail"];
    detailController.model = tempModel;
    [self.navigationController pushViewController:detailController animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.selectedDate ? 28.f : 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.selectedDate) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 28)];
        headerView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2" alpha:1];
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 28)];
        headerLabel.font = [UIFont systemFontOfSize:13];
        headerLabel.textColor = [UIColor colorWithHexString:@"333333" alpha:1];
        NSString *tempYear = [self.selectedDate substringToIndex:4];
        NSString *tempMonth = [self.selectedDate substringWithRange:NSMakeRange(4, 2)];
        NSInteger tempMonthInt = tempMonth.integerValue;
        headerLabel.text = [NSString stringWithFormat:@"%@年%@月", tempYear, @(tempMonthInt)];
        [headerView addSubview:headerLabel];
        return headerView;
    } else {
        return nil;
    }
}

#pragma mark - Getters
- (UILabel *)footerLabel {
    if (!_footerLabel) {
        _footerLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
        _footerLabel.font = [UIFont boldSystemFontOfSize:16];
        _footerLabel.text = @"无转账记录";
        _footerLabel.textColor = [UIColor lightGrayColor];
        _footerLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _footerLabel;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (WCMonthPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[WCMonthPickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _pickerView;
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
