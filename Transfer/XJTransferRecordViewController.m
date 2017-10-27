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
#import "WCBillTypesView.h"

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
@property (strong, nonatomic) WCBillTypesView *typesView;
@property (strong, nonatomic) UIButton *monthSelectButton;
@property (strong, nonatomic) UIButton *typeSelectButton;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (copy, nonatomic) NSString *selectedDate;
@property (nonatomic) NSInteger index;
@property (strong, nonatomic) NSMutableArray *billTypesArray;
@property (copy, nonatomic) NSString *selectedType;
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
    [[UIApplication sharedApplication].keyWindow addSubview:self.typesView];
    self.typesView.selectBlock = ^(NSInteger index) {
        __strong typeof(self) strongSelf = weakSelf;
        if (index == 0) {
            strongSelf.selectedType = @"0";
            [strongSelf.typeSelectButton setTitle:@"全部分类" forState:UIControlStateNormal];
        } else {
            NSDictionary *tempDictionary = strongSelf.billTypesArray[index];
            strongSelf.selectedType = [NSString stringWithFormat:@"%@", tempDictionary[@"typeid"]];
            [strongSelf.typeSelectButton setTitle:[NSString stringWithFormat:@"%@", tempDictionary[@"typename"]] forState:UIControlStateNormal];
        }
        _index = 1;
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
    _selectedType = @"0";
    [self recordRequest];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self fetchBillTypes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods
- (void)createRightItem {
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(72, 16.5, 6.5, 5.5)];
    arrowImageView.image = [UIImage imageNamed:@"arrow"];
    [self.typeSelectButton addSubview:arrowImageView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.typeSelectButton];
    [self.typesView setupContent:_billTypesArray];
}

#pragma mark - Requests
- (void)recordRequest {
    [TransferRecordModel transferRecord:_selectedDate index:@(_index) type:_selectedType handler:^(id object, NSString *msg) {
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
//获取账单种类
- (void)fetchBillTypes {
    [TransferRecordModel billTypes:^(id object, NSString *msg) {
        if (object) {
            _billTypesArray = [object mutableCopy];
            NSDictionary *temp = @{@"typeid" : @"",
                                   @"typename" : @"全部分类"
                                   };
            [_billTypesArray insertObject:temp atIndex:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self createRightItem];
            });
        }
    }];
}

#pragma mark - Action
- (void)monthSelectAction {
    [self.pickerView show];
}
- (void)typeSelectAction {
    [self.typesView show];
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
        cell.contentLabel.text = [NSString stringWithFormat:@"%@-转给%@", tempModel.option, tempModel.touser];
        cell.moneyLabel.textColor = [UIColor colorWithHexString:@"333333" alpha:1];
        cell.moneyLabel.text = [NSString stringWithFormat:@"-%@ 果币", [RCDUtilities amountStringFromNumber:tempModel.money]];
    } else {
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:tempModel.fromuserheadico] placeholderImage:nil];
        cell.contentLabel.text = [NSString stringWithFormat:@"%@-来自%@", tempModel.option, tempModel.fromuser];
        cell.moneyLabel.textColor = [UIColor colorWithHexString:@"ffc000" alpha:1];
        cell.moneyLabel.text = [NSString stringWithFormat:@"+%@ 果币", [RCDUtilities amountStringFromNumber:tempModel.money]];
    }
    cell.timeLabel.text = [RCDUtilities commonDateString:tempModel.time];
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
    return 35.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 28)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2" alpha:1];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 35)];
    headerLabel.font = [UIFont systemFontOfSize:13];
    headerLabel.textColor = [UIColor colorWithHexString:@"333333" alpha:1];
    [headerView addSubview:headerLabel];
    if (self.selectedDate) {
        NSString *tempYear = [self.selectedDate substringToIndex:4];
        NSString *tempMonth = [self.selectedDate substringWithRange:NSMakeRange(4, 2)];
        NSInteger tempMonthInt = tempMonth.integerValue;
        headerLabel.text = [NSString stringWithFormat:@"%@年%@月", tempYear, @(tempMonthInt)];
    } else {
        headerLabel.text = @"全部";
    }
    [headerView addSubview:self.monthSelectButton];
    return headerView;
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
- (WCBillTypesView *)typesView {
    if (!_typesView) {
        _typesView = [[WCBillTypesView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _typesView;
}
- (UIButton *)monthSelectButton {
    if (!_monthSelectButton) {
        _monthSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _monthSelectButton.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 50, 0, 50, 35);
        [_monthSelectButton setImage:[UIImage imageNamed:@"record_calendar"] forState:UIControlStateNormal];
        [_monthSelectButton addTarget:self action:@selector(monthSelectAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _monthSelectButton;
}
- (UIButton *)typeSelectButton {
    if (!_typeSelectButton) {
        _typeSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _typeSelectButton.frame = CGRectMake(0, 0, 80, 40);
        _typeSelectButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_typeSelectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_typeSelectButton setTitle:@"全部分类" forState:UIControlStateNormal];
        [_typeSelectButton addTarget:self action:@selector(typeSelectAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _typeSelectButton;
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
