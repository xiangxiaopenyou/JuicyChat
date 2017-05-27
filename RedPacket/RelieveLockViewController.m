//
//  RelieveLockViewController.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/21.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "RelieveLockViewController.h"
#import "LockMembersRequest.h"
#import "RCDUserInfo.h"
#import "RCDUtilities.h"
#import "RCDContactSelectedTableViewCell.h"
#import "UnlockMemberCell.h"
#import "UnlockMoneyRequest.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"

@interface RelieveLockViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *users;
@property (strong, nonatomic) NSMutableArray *allKeys;
@property (strong, nonatomic) NSMutableDictionary *allUsers;
@property (strong, nonatomic) NSMutableArray *selectedUserIds;
@property (strong, nonatomic) UIButton *submitButton;

@end

@implementation RelieveLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:self.submitButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(submitAction)];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self allData];
    [self refreshContents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)submitAction {
    if (_selectedUserIds.count > 0) {
        [self unlockRequest];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)unlockRequest {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[UnlockMoneyRequest new] request:^BOOL(UnlockMoneyRequest *request) {
        request.groupId = self.groupId;
        request.userIds = _selectedUserIds;
        return YES;
    } result:^(id object, NSString *msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (object) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];
}
- (void)allData {
    _users = [[NSMutableArray alloc] init];
    _allKeys = [[NSMutableArray alloc] init];
    _allUsers = [[NSMutableDictionary alloc] init];
    _selectedUserIds = [[NSMutableArray alloc] init];
    [[LockMembersRequest new] request:^BOOL(LockMembersRequest *request) {
        request.groupId = self.groupId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (object) {
            [self.users removeAllObjects];
            NSArray *tempArray = [object copy];
            [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *temp = [obj copy];
                RCUserInfo *model = [[RCUserInfo alloc] initWithUserId:temp[@"userid"] name:temp[@"nickname"] portrait:temp[@"userheadico"]];
                [self.users addObject:model];
            }];
            [self dealWithFriendList];
        }
    }];
}
- (void)dealWithFriendList {
    if (self.users.count > 0) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSMutableDictionary *result = [RCDUtilities sortedArrayWithPinYinDic:self.users];
            dispatch_async(dispatch_get_main_queue(), ^{
                _allUsers = result[@"infoDic"];
                _allKeys = result[@"allKeys"];
                [self.tableView reloadData];
            });
        });
    }
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _allKeys.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = [_allKeys objectAtIndex:section];
    NSArray *arr = [_allUsers objectForKey:key];
    return [arr count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [RCDContactSelectedTableViewCell cellHeight];
}
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _allKeys;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = [_allKeys objectAtIndex:section];
    return key;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UnlockMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UnlockMemberCell" forIndexPath:indexPath];
    RCDUserInfo *user;
    NSString *key = [self.allKeys objectAtIndex:indexPath.section];
    NSArray *arrayForKey = [self.allUsers objectForKey:key];
    user = arrayForKey[indexPath.row];
    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:[UIImage imageNamed:@"icon_person"]];
    cell.nicknameLabel.text = user.name;
    if ([_selectedUserIds containsObject:user.userId]) {
        [cell selectState:YES];
    } else {
        [cell selectState:NO];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UnlockMemberCell *cell = (UnlockMemberCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *key = [self.allKeys objectAtIndex:indexPath.section];
    NSArray *arrayForKey = [self.allUsers objectForKey:key];
    RCDUserInfo *user = arrayForKey[indexPath.row];
    if ([_selectedUserIds containsObject:user.userId]) {
        [_selectedUserIds removeObject:user.userId];
        [cell selectState:NO];
        
    } else {
        [_selectedUserIds addObject:user.userId];
        [cell selectState:YES];
    }
    [self refreshContents];
    
}

- (void)refreshContents {
    if (_selectedUserIds.count == 0) {
        [self.submitButton setTitle:@"确定" forState:UIControlStateNormal];
        self.submitButton.enabled = NO;
    } else {
        [self.submitButton setTitle:[NSString stringWithFormat:@"确定(%@)", @(_selectedUserIds.count)] forState:UIControlStateNormal];
        self.submitButton.enabled = YES;
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
//- (UIButton *)submitButton {
//    if (!_submitButton) {
//        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_submitButton setTitle:@"确定" forState:UIControlStateNormal];
//        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _submitButton.titleLabel.font = [UIFont systemFontOfSize:14];
//        [_submitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
//        _submitButton.enabled = NO;
//    }
//    return _submitButton;
//}

@end
