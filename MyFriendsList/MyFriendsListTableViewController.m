//
//  MyFriendsListTableViewController.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/25.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "MyFriendsListTableViewController.h"
#import "RCDUserInfo.h"
#import "RCDRCIMDataSource.h"
#import "RCDUtilities.h"
#import "RCDataBaseManager.h"
#import "RCDUserInfoManager.h"
#import "RCDCommonDefine.h"
#import "RCDContactTableViewCell.h"
#import "DefaultPortraitView.h"
#import "UIImageView+WebCache.h"

@interface MyFriendsListTableViewController ()
@property(nonatomic, strong) NSMutableDictionary *resultDic;
@property(nonatomic, strong) NSDictionary *allFriendSectionDic;
@property(nonatomic, assign) BOOL hasSyncFriendList;

@end

@implementation MyFriendsListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.view.backgroundColor = HEXCOLOR(0xf0f0f6);
    self.title = @"选择朋友";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(closeAction)];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = HEXCOLOR(0x555555);
    [self sortAndRefreshWithList:[self getAllFriendList]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)closeAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 获取好友并且排序

- (NSArray *)getAllFriendList {
    NSMutableArray *friendList = [[NSMutableArray alloc] init];
    NSMutableArray *userInfoList = [NSMutableArray arrayWithArray:[[RCDataBaseManager shareInstance] getAllFriends]];
    for (RCDUserInfo *user in userInfoList) {
        if ([user.status integerValue] == 1) {
            [friendList addObject:user];
        }
    }
    if (friendList.count <= 0 && !self.hasSyncFriendList) {
        [RCDDataSource syncFriendList:[RCIM sharedRCIM].currentUserInfo.userId
                             complete:^(NSMutableArray *result) {
                                 self.hasSyncFriendList = YES;
                                 [self sortAndRefreshWithList:[self getAllFriendList]];
                             }];
    }
    //如有好友备注，则显示备注
    NSArray *resultList = [[RCDUserInfoManager shareInstance]
                           getFriendInfoList:friendList];
    
    return resultList;
}
- (void)sortAndRefreshWithList:(NSArray *)friendList {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.resultDic = [RCDUtilities sortedArrayWithPinYinDic:friendList];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.allFriendSectionDic = self.resultDic[@"infoDic"];
            [self.tableView reloadData];
        });
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.resultDic[@"allKeys"] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *letter = self.resultDic[@"allKeys"][section];
    return[self.allFriendSectionDic[letter] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 21.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.frame = CGRectMake(0, 0, self.view.frame.size.width, 22);
    view.backgroundColor = HEXCOLOR(0xf0f0f6);
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.frame = CGRectMake(13, 3, 15, 15);
    title.font = [UIFont systemFontOfSize:15.f];
    title.textColor = HEXCOLOR(0x999999);
    [view addSubview:title];
    title.text = self.resultDic[@"allKeys"][section];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *isDisplayID = [[NSUserDefaults standardUserDefaults] objectForKey:@"isDisplayID"];
    static NSString *reusableCellWithIdentifier = @"RCDContactTableViewCell";
    RCDContactTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
    if (cell == nil) {
        cell = [[RCDContactTableViewCell alloc] init];
    }
    NSString *letter = self.resultDic[@"allKeys"][indexPath.section];
    NSArray *sectionUserInfoList = self.allFriendSectionDic[letter];
    RCDUserInfo *userInfo = sectionUserInfoList[indexPath.row];
    if (userInfo) {
        if ([isDisplayID isEqualToString:@"YES"]) {
            cell.userIdLabel.text = userInfo.userId;
        }
        cell.nicknameLabel.text = userInfo.name;
        if ([userInfo.portraitUri isEqualToString:@""]) {
            DefaultPortraitView *defaultPortrait = [[DefaultPortraitView alloc]
                                                    initWithFrame:CGRectMake(0, 0, 100, 100)];
            [defaultPortrait setColorAndLabel:userInfo.userId Nickname:userInfo.name];
            UIImage *portrait = [defaultPortrait imageFromView];
            cell.portraitView.image = portrait;
        } else {
            [cell.portraitView
             sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri]
             placeholderImage:[UIImage imageNamed:@"contact"]];
        }
    }
    cell.portraitView.layer.masksToBounds = YES;
    cell.portraitView.layer.cornerRadius = 5.f;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.portraitView.contentMode = UIViewContentModeScaleAspectFill;
    cell.nicknameLabel.font = [UIFont systemFontOfSize:15.f];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.5;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.resultDic[@"allKeys"];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *letter = self.resultDic[@"allKeys"][indexPath.section];
    NSArray *sectionUserInfoList = self.allFriendSectionDic[letter];
    RCDUserInfo *userInfo = sectionUserInfoList[indexPath.row];
    if (self.selectBlock) {
        self.selectBlock(userInfo);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
