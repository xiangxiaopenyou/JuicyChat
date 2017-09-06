//
//  WCSpeakingManageViewController.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/8/23.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "WCSpeakingManageViewController.h"
#import "WCSpeakingMemberCell.h"
#import "WCNoSpeakingMembersRequest.h"
#import "WCSpeakingManageRequest.h"
#import "RCDataBaseManager.h"
#import "RCDUtilities.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+Add.h"

@interface WCSpeakingManageViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightItem;
@property (strong, nonatomic) NSMutableArray *allMembersArray;
@property (strong, nonatomic) NSMutableArray *allKeysArray;
@property (strong, nonatomic) NSMutableDictionary *allMembersDictionary;
@property (strong, nonatomic) NSMutableArray *selectedMembersArray;

@end

@implementation WCSpeakingManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
    [self allData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rightAction:(id)sender {
    NSMutableArray *userIdsArray = [[NSMutableArray alloc] init];
    for (RCDUserInfo *tempInfo in _selectedMembersArray) {
        [userIdsArray addObject:tempInfo.userId];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WCSpeakingManageRequest new] request:^BOOL(WCSpeakingManageRequest *request) {
        request.groupId = self.groupInfo.groupId;
        request.userIds = userIdsArray;
        return YES;
    } result:^(id object, NSString *msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (object) {
            [MBProgressHUD showSuccess:@"成功" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}

#pragma mark - Private methods
- (void)allData {
    _allMembersArray = [[NSMutableArray alloc] init];
    _allKeysArray = [[NSMutableArray alloc] init];
    _allMembersDictionary = [[NSMutableDictionary alloc] init];
    _selectedMembersArray = [[NSMutableArray alloc] init];
    _allMembersArray = [[RCDataBaseManager shareInstance] getGroupMember:self.groupInfo.groupId];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [_allMembersArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RCDUserInfo *tempInfo = (RCDUserInfo *)obj;
        if (![tempInfo.userId isEqualToString:self.groupInfo.creatorId]) {
            [tempArray addObject:tempInfo];
        }
    }];
    _allMembersArray = [tempArray mutableCopy];
    NSMutableDictionary *resultDic = [RCDUtilities sortedArrayWithPinYinDic:_allMembersArray];
    //dispatch_async(dispatch_get_main_queue(), ^{
    _allMembersDictionary = resultDic[@"infoDic"];
    _allKeysArray = resultDic[@"allKeys"];
    [_allKeysArray insertObject:@"" atIndex:0];
    [self speakingMembersRequest];
    //});
    
}
- (void)refreshItemTitle {
    if (_selectedMembersArray.count > 0) {
        self.rightItem.title = [NSString stringWithFormat:@"确定(%@)", @(_selectedMembersArray.count)];
    } else {
        self.rightItem.title = @"确定";
    }
}

#pragma mark - Requests
- (void)speakingMembersRequest {
    [[WCNoSpeakingMembersRequest new] request:^BOOL(WCNoSpeakingMembersRequest *request) {
        request.groupId = self.groupInfo.groupId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (object) {
            for (NSDictionary *dictionary in (NSArray *)object) {
                RCDUserInfo *userInfo = [[RCDUserInfo alloc] initWithUserId:dictionary[@"userid"] name:dictionary[@"nickname"] portrait:dictionary[@"userhead"]];
                [_selectedMembersArray addObject:userInfo];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshItemTitle];
                [self.tableView reloadData];
            });
        } else {
            [[[UIAlertView alloc] initWithTitle:@"错误" message:msg delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil] show];
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _allKeysArray.count;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        NSString *key = [_allKeysArray objectAtIndex:section];
        NSArray *arr = [_allMembersDictionary objectForKey:key];
        return [arr count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.f;
}
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _allKeysArray;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SpeakingMemberCell";
    WCSpeakingMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.avatarImageView.image = [UIImage imageNamed:@"icon_all"];
        cell.nameLabel.text = @"全部成员";
        if (_selectedMembersArray.count == _allMembersArray.count) {
            cell.selectImageView.image = [UIImage imageNamed:@"select"];
        } else {
            cell.selectImageView.image = [UIImage imageNamed:@"unselect"];
        }
        return cell;
    } else {
        NSString *key = [_allKeysArray objectAtIndex:indexPath.section];
        NSArray *arr = [_allMembersDictionary objectForKey:key];
        RCDUserInfo *userInfo = arr[indexPath.row];
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri] placeholderImage:nil];
        cell.nameLabel.text = userInfo.name;
        cell.selectImageView.image = [UIImage imageNamed:@"unselect"];
        for (RCDUserInfo *tempInfo in _selectedMembersArray) {
            if (userInfo.userId.integerValue == tempInfo.userId.integerValue) {
                cell.selectImageView.image = [UIImage imageNamed:@"select"];
            }
        }
    }
    return cell;
}

#pragma mark - Table view delegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = [_allKeysArray objectAtIndex:section];
    return key;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (_selectedMembersArray.count == _allMembersArray.count) {
            [_selectedMembersArray removeAllObjects];
        } else {
            _selectedMembersArray = [_allMembersArray mutableCopy];
        }
    } else {
        NSString *key = [_allKeysArray objectAtIndex:indexPath.section];
        NSArray *arr = [_allMembersDictionary objectForKey:key];
        RCDUserInfo *userInfo = arr[indexPath.row];
        BOOL selected = NO;
        NSInteger index = 0;
        for (NSInteger i = 0; i < _selectedMembersArray.count; i ++) {
            RCDUserInfo *tempInfo = _selectedMembersArray[i];
            if (userInfo.userId.integerValue == tempInfo.userId.integerValue) {
                selected = YES;
                index = i;
            }
        }
        if (selected) {
            [_selectedMembersArray removeObjectAtIndex:index];
        } else {
            [_selectedMembersArray addObject:userInfo];
        }
    }
    [tableView reloadData];
    [self refreshItemTitle];
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
