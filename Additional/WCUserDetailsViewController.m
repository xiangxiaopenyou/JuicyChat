//
//  WCUserDetailsViewController.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/6/21.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "WCUserDetailsViewController.h"
#import "RCDFrienfRemarksViewController.h"
#import "JCBigAvatarViewController.h"
#import "RCDChatViewController.h"
#import "WCTransferViewController.h"
#import "AppealCenterViewController.h"
#import "JCDetailsCell.h"
#import "JCSignCell.h"

#import "RCDUserInfo.h"
#import "RCDataBaseManager.h"
#import "DefaultPortraitView.h"
#import "UIImageView+WebCache.h"
#import "UIColor+RCColor.h"
#import "MBProgressHUD.h"
#import "DeleteFriendRequest.h"
#import "AFHttpTool.h"

#import <RongIMKit/RongIMKit.h>

@interface WCUserDetailsViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *transferButton;
@property (strong, nonatomic) RCDUserInfo *friendInfo;
@property (assign, nonatomic) BOOL inBlackList;
@property (copy, nonatomic) NSString *signString;

@end

@implementation WCUserDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"详细资料";
    if ([self isMyself]) {
        self.chatButton.hidden = YES;
        self.transferButton.hidden = YES;
    } else {
        self.chatButton.hidden = NO;
        self.transferButton.hidden = NO;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"config"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClicked:)];
        [self fetchInformations];
    }
    //self.friendInfo = [[RCDataBaseManager shareInstance] getFriendInfo:self.userId];
    [[RCIMClient sharedRCIMClient] getBlacklistStatus:self.userId success:^(int bizStatus) {
        if (bizStatus == 0) {
            self.inBlackList = YES;
        } else {
            self.inBlackList = NO;
        }
    } error:^(RCErrorCode status) {
        NSArray *array = [[RCDataBaseManager shareInstance] getBlackList];
        for (RCUserInfo *blackInfo in array) {
            if ([blackInfo.userId isEqualToString:self.userId]) {
                self.inBlackList = YES;
            }
        }
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchInformations {
    [AFHttpTool getFriendDetailsByID:self.userId success:^(id response) {
        if ([response[@"code"] integerValue] == 200) {
            NSDictionary *dic = response[@"data"];
            if (!dic[@"whatsup"] || [dic[@"whatsup"] isKindOfClass:[NSNull class]]) {
                _signString = nil;
            } else {
                _signString = dic[@"whatsup"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    } failure:^(NSError *err) {
    }];
}

#pragma mark - IBAction
- (IBAction)createChatAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeTabBarIndex" object:@0];
    //创建会话
    RCDChatViewController *chatViewController =
    [[RCDChatViewController alloc] init];
    chatViewController.conversationType = ConversationType_PRIVATE;
    chatViewController.targetId = self.userId;
    NSString *title;
    if ([self.userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        title = [RCIM sharedRCIM].currentUserInfo.name;
    } else {
        if (self.friendInfo.displayName.length > 0) {
            title = self.friendInfo.displayName;
        } else {
            title = self.friendInfo.name;
        }
    }
    chatViewController.title = title;
    chatViewController.needPopToRootView = YES;
    chatViewController.displayUserNameInCell = NO;
    [self.navigationController pushViewController:chatViewController animated:YES];
}
- (IBAction)transferAction:(id)sender {
    WCTransferViewController *transferController = [[UIStoryboard storyboardWithName:@"RedPacket" bundle:nil] instantiateViewControllerWithIdentifier:@"Transfer"];
    transferController.userInfo = self.friendInfo;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:transferController];
    [self presentViewController:navigationController animated:YES completion:nil];
}
- (void)rightBarButtonItemClicked:(id)sender {
    NSString *blackString = self.inBlackList ? @"取消黑名单" : @"加入黑名单";
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除好友" otherButtonTitles:blackString, @"举报", nil];
    [actionSheet showInView:self.view];
}
- (void)avatarAction {
    NSString *portraitUrl;
    if ([self isMyself]) {
        portraitUrl = [RCIM sharedRCIM].currentUserInfo.portraitUri;
    } else {
        self.friendInfo = [[RCDataBaseManager shareInstance] getFriendInfo:self.userId];
        portraitUrl = self.friendInfo.portraitUri;
    }
    JCBigAvatarViewController *avatarViewController = [[UIStoryboard storyboardWithName:@"Additional" bundle:nil] instantiateViewControllerWithIdentifier:@"BigAvatar"];
    avatarViewController.urlString = portraitUrl;
    [self presentViewController:avatarViewController animated:NO completion:nil];
}

#pragma mark - private methods
- (BOOL)isMyself {
    BOOL isSelf = NO;
    if ([self.userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        isSelf = YES;
    }
    return isSelf;
}

#pragma mark - action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[DeleteFriendRequest new] request:^BOOL(DeleteFriendRequest *request) {
            request.friendId = self.userId;
            return YES;
        } result:^(id object, NSString *msg) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (object) {
                //需要设置显示
                [[RCDataBaseManager shareInstance] deleteFriendFromDB:self.userId];
                [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE targetId:self.userId];
                [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_PRIVATE targetId:self.userId];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"删除好友失败"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        }];
    } else if (buttonIndex == 1) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //黑名单
        __weak WCUserDetailsViewController *weakSelf = self;
        if (!self.inBlackList) {
            hud.labelText = @"正在加入黑名单";
            [[RCIMClient sharedRCIMClient] addToBlacklist:self.friendInfo.userId success:^{
                 weakSelf.inBlackList = YES;
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [hud hide:YES];
                 });
                 [[RCDataBaseManager shareInstance] insertBlackListToDB:weakSelf.friendInfo];
            } error:^(RCErrorCode status) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [hud hide:YES];
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                         message:@"加入黑名单失败"
                                                                        delegate:nil
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil, nil];
                     [alertView show];
                 });
                 weakSelf.inBlackList = NO;
             }];
        } else {
            hud.labelText = @"正在从黑名单移除";
            [[RCIMClient sharedRCIMClient] removeFromBlacklist:self.friendInfo.userId success:^{
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [hud hide:YES];
                 });
                 [[RCDataBaseManager shareInstance] removeBlackList:weakSelf.userId];
                 weakSelf.inBlackList = NO;
            } error:^(RCErrorCode status) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [hud hide:YES];
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                         message:@"从黑名单移除失败"
                                                                        delegate:nil
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil, nil];
                     [alertView show];
                 });
                 weakSelf.inBlackList = YES;
             }];
        }
    } else if (buttonIndex == 2) {
        AppealCenterViewController *appealCenterController = [[UIStoryboard storyboardWithName:@"RedPacket" bundle:nil] instantiateViewControllerWithIdentifier:@"AppealCenter"];
        appealCenterController.navigationItem.title = @"投诉";
        [self.navigationController pushViewController:appealCenterController animated:YES];
    }
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger number = 1;
    if (![self isMyself]) {
        number = 3;
    }
    return number;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    switch (indexPath.section) {
        case 0:
            height = 85.f;
            break;
        case 1: {
            if (_signString.length > 0) {
                CGFloat windowWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
                CGSize size = [_signString boundingRectWithSize:CGSizeMake(windowWidth - 115, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size;
                height = 30.f + size.height;
            } else {
                height = 45.f;
            }
        }
            break;
        case 2:
            height = 45.f;
            break;
        default:
            break;
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            static NSString *identifier = @"DetailsCell";
            JCDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSString *portraitUrl;
            if ([self isMyself]) {
                portraitUrl = [RCIM sharedRCIM].currentUserInfo.portraitUri;
            } else {
                self.friendInfo = [[RCDataBaseManager shareInstance] getFriendInfo:self.userId];
                portraitUrl = self.friendInfo.portraitUri;
            }
            if (portraitUrl.length == 0) {
                DefaultPortraitView *defaultPortrait =
                [[DefaultPortraitView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
                [defaultPortrait setColorAndLabel:self.friendInfo.userId
                                         Nickname:self.friendInfo.name];
                UIImage *portrait = [defaultPortrait imageFromView];
                cell.avatarImageView.image = portrait;
            } else {
                [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:portraitUrl] placeholderImage:[UIImage imageNamed:@"icon_person"]];
            }
            cell.avatarImageView.userInteractionEnabled = YES;
            [cell.avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarAction)]];
            if ([self isMyself]) {
                cell.nameLabelCenterConstraint.constant = 0;
                cell.nameLabel.text = [RCIM sharedRCIM].currentUserInfo.name;
                cell.nicknameLabel.hidden = YES;
            } else {
                if (self.friendInfo.displayName && ![self.friendInfo.displayName isEqualToString:@""]) {
                    cell.nameLabelCenterConstraint.constant = - 10;
                    cell.nicknameLabel.hidden = NO;
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@（ID%@）", self.friendInfo.displayName, self.friendInfo.userId]];
                    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(self.friendInfo.displayName.length, self.friendInfo.userId.length + 4)];
                    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"999999" alpha:1] range:NSMakeRange(self.friendInfo.displayName.length, self.friendInfo.userId.length + 4)];
                    cell.nameLabel.attributedText = attributedString;
                    cell.nicknameLabel.text = [NSString stringWithFormat:@"昵称: %@",self.friendInfo.name];
                } else {
                    cell.nameLabelCenterConstraint.constant = 0;
                    cell.nicknameLabel.hidden = YES;
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@（ID%@）", self.friendInfo.name, self.friendInfo.userId]];
                    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(self.friendInfo.name.length, self.friendInfo.userId.length + 4)];
                    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"999999" alpha:1] range:NSMakeRange(self.friendInfo.name.length, self.friendInfo.userId.length + 4)];
                    cell.nameLabel.attributedText = attributedString;
                }
            }
            return cell;
        }
            break;
        case 1: {
            static NSString *identifier = @"SignCell";
            JCSignCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (_signString.length > 0) {
                cell.signLabel.text = _signString;
            } else {
                cell.signLabel.text = @"暂未设置";
            }
            return cell;
        }
            break;
        case 2: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemarkSetCell" forIndexPath:indexPath];
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : 12.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        RCDFrienfRemarksViewController *vc = [[RCDFrienfRemarksViewController alloc] init];
        vc.friendInfo = self.friendInfo;
        [self.navigationController pushViewController:vc animated:YES];
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
