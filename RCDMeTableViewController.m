//
//  RCDMeTableViewController.m
//  RCloudMessage
//
//  Created by Liv on 14/11/28.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import "RCDMeTableViewController.h"
#import "AFHttpTool.h"
#import "DefaultPortraitView.h"
#import "RCDChatViewController.h"
#import "RCDCommonDefine.h"
#import "RCDCustomerServiceViewController.h"
#import "RCDHttpTool.h"
#import "RCDRCIMDataSource.h"
#import "RCDUtilities.h"
#import "RCDataBaseManager.h"
#import "UIColor+RCColor.h"
#import "UIImageView+WebCache.h"
#import <RongIMLib/RongIMLib.h>
#import "RCDSettingsTableViewController.h"
#import "RCDMeInfoTableViewController.h"
#import "RCDAboutRongCloudTableViewController.h"
#import "RCDBaseSettingTableViewCell.h"
#import "RCDMeDetailsCell.h"
#import "RCDMeCell.h"
#import "MyInformationsCell.h"
#import "MyWalletViewController.h"
#import "AppealCenterViewController.h"
#import <OpenShareHeader.h>
#import "ShareRewardRequest.h"
#import "FetchSharePictureRequest.h"
#import "MBProgressHUD.h"

/* RedPacket_FTR */
//#import <JrmfWalletKit/JrmfWalletKit.h>

#define SERVICE_ID @"KEFU146001495753714"
#define SERVICE_ID_XIAONENG1 @"kf_4029_1483495902343"
#define SERVICE_ID_XIAONENG2 @"op_1000_1483495280515"

@interface RCDMeTableViewController ()
@property(nonatomic) BOOL hasNewVersion;
@property(nonatomic) NSString *versionUrl;
@property(nonatomic, strong) NSString *versionString;

@property(nonatomic, strong) NSURLConnection *connection;
@property(nonatomic, strong) NSMutableData *receiveData;

@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *nicknameLabel;
@property (strong, nonatomic) UIView *shareView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIButton *wechatButton;
@property (strong, nonatomic) UIButton *circleButton;

@end

@implementation RCDMeTableViewController {
  UIImage *userPortrait;
  BOOL isSyncCurrentUserInfo;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.edgesForExtendedLayout = UIRectEdgeNone;
  self.navigationController.navigationBar.translucent = NO;
  self.tableView.tableFooterView = [UIView new];
  self.tableView.backgroundColor = [UIColor colorWithHexString:@"f0f0f6" alpha:1.f];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

  self.tabBarController.navigationItem.rightBarButtonItem = nil;
  self.tabBarController.navigationController.navigationBar.tintColor =
      [UIColor whiteColor];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(setUserPortrait:)
                                               name:@"setCurrentUserPortrait"
                                             object:nil];

  isSyncCurrentUserInfo = NO;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.shareView];
    [self.shareView addSubview:self.contentView];
    [self.contentView addSubview:self.wechatButton];
    [self.contentView addSubview:self.circleButton];
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 101, CGRectGetWidth([UIScreen mainScreen].bounds), 49);
//    closeButton.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    [closeButton setTitle:@"取消" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:closeButton];
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth([UIScreen mainScreen].bounds), 0.5)];
    line.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
    [self.contentView addSubview:line];
    UIButton *backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backgroundButton.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds) - 150);
    backgroundButton.backgroundColor = [UIColor clearColor];
    [backgroundButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:backgroundButton];
    self.shareView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.tabBarController.navigationItem.title = @"我";
  self.tabBarController.navigationItem.rightBarButtonItems = nil;
  [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSInteger rows = 0;
  switch (section) {
    case 0:
      rows = 1;
      break;
      
    case 1:
    /* RedPacket_FTR */ //添加了红包，row+=1；
          rows = [OpenShare isWeixinInstalled] ? 3 : 2;
      break;
      
    case 2:
#if RCDDebugTestFunction
      rows = 4;
#else
      rows = 1;
#endif
      break;
      
    default:
      break;
  }
  return rows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *reusableCellWithIdentifier = @"RCDMeCell";
  RCDMeCell *cell = [self.tableView
                                       dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
  
  static NSString *detailsCellWithIdentifier = @"RCDMeDetailsCell";
  MyInformationsCell *detailsCell = [self.tableView
                                       dequeueReusableCellWithIdentifier:detailsCellWithIdentifier];
  if (cell == nil) {
    cell = [[RCDMeCell alloc] init];
  }
  if (detailsCell == nil) {
    detailsCell = [[MyInformationsCell alloc] init];
  }
    
  switch (indexPath.section) {
    case 0: {
      switch (indexPath.row) {
        case 0: {
//            static NSString *identifier = @"InformationCell";
//            UITableViewCell *informationCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//            if (!_avatarImageView) {
//                _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11.5, 65, 65)];
//                _avatarImageView.layer.masksToBounds = YES;
//                _avatarImageView.layer.cornerRadius = 5.f;
//            }
//            [informationCell.contentView addSubview:_avatarImageView];
//            NSString *portraitUrl = [DEFAULTS stringForKey:@"userPortraitUri"];
//            if (!portraitUrl || [portraitUrl isEqualToString:@""]) {
//                portraitUrl = [RCDUtilities defaultUserPortrait:[RCIM sharedRCIM].currentUserInfo];
//                _avatarImageView.image = [UIImage imageNamed:portraitUrl];
//            } else {
//                [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:portraitUrl] placeholderImage:nil];
//            }
//            if (!_nicknameLabel) {
//                _nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(83, 29, 300, 30)];
//                _nicknameLabel.textColor = [UIColor blackColor];
//                _nicknameLabel.font = [UIFont systemFontOfSize:16];
//            }
//            [informationCell.contentView addSubview:_nicknameLabel];
//            _nicknameLabel.text = [DEFAULTS stringForKey:@"userNickName"];
//          return informationCell;
            return detailsCell;
        }
          break;
          
        default:
          break;
      }
    }
      break;
      
    case 1: {
        switch (indexPath.row) {
            case 0: {
                [cell setCellWithImageName:@"setting_up" labelName:@"帐号设置"];
            }
                break;
          
          /* RedPacket_FTR */ //wallet cell
            case 1: {
                [cell setCellWithImageName:@"wallet" labelName:@"我的果币"];
            }
                break;
            case 2: {
                [cell setCellWithImageName:@"mine_share" labelName:@"分享赚果币"];
            }
                break;
            default:
                break;
        }
      return cell;
    }
      break;
      
    case 2: {
      switch (indexPath.row) {
        case 0:{
          [cell setCellWithImageName:@"sevre_inactive" labelName:@"投诉与建议"];
          return cell;
        }
          break;
          
//        case 1:{
//          [cell setCellWithImageName:@"about_rongcloud" labelName:@"关于 SealTalk"];
//          NSString *isNeedUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"isNeedUpdate"];
//          if ([isNeedUpdate isEqualToString:@"YES"]) {
//            [cell addRedpointImageView];
//          }
//          return cell;
//        }
//          break;
#if RCDDebugTestFunction
        case 2:{
          [cell setCellWithImageName:@"sevre_inactive" labelName:@"小能客服1"];
          return cell;
        }
          break;
        case 3:{
          [cell setCellWithImageName:@"sevre_inactive" labelName:@"小能客服2"];
          return cell;
        }
          break;
#endif
        default:
          break;
      }
    }
      break;
      
    default:
      break;
  }
  
  return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat height;
  switch (indexPath.section) {
    case 0:{
          height = 88.f;
      }
      break;
      
    default:
      height = 44.f;
      break;
  }
  return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.section) {
    case 0: {
      RCDMeInfoTableViewController *vc = [[RCDMeInfoTableViewController alloc] init];
      [self.navigationController pushViewController:vc animated:YES];
    }
      break;
      
    case 1: {
      switch (indexPath.row) {
        case 0: {
          RCDSettingsTableViewController *vc = [[RCDSettingsTableViewController alloc] init];
          [self.navigationController pushViewController:vc
                                               animated:YES];
        }
          break;
        /* RedPacket_FTR */ //open my wallet
          case 1: {
              //[JrmfWalletSDK openWallet];
              MyWalletViewController *walletViewController = [[UIStoryboard storyboardWithName:@"RedPacket" bundle:nil] instantiateViewControllerWithIdentifier:@"MyWallet"];
              [self.navigationController pushViewController:walletViewController animated:YES];
          }
              break;
          case 2:{
              [tableView deselectRowAtIndexPath:indexPath animated:YES];
              self.shareView.hidden = NO;
              [UIView animateWithDuration:0.2 animations:^{
                  self.contentView.frame = CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds) - 150, CGRectGetWidth([UIScreen mainScreen].bounds), 150);
              }];
          }
              break;
          
        default:
          break;
      }
    }
      break;
      
    case 2: {
      switch (indexPath.row) {
        case 0: {
          //[self chatWithCustomerService:SERVICE_ID];
            AppealCenterViewController *appealCenterController = [[UIStoryboard storyboardWithName:@"RedPacket" bundle:nil] instantiateViewControllerWithIdentifier:@"AppealCenter"];
            [self.navigationController pushViewController:appealCenterController animated:YES];
        }
          break;
          
        case 1: {
          RCDAboutRongCloudTableViewController *vc = [[RCDAboutRongCloudTableViewController alloc] init];
          [self.navigationController pushViewController:vc animated:YES];
        }
          break;
#if RCDDebugTestFunction
        case 2: {
          [self chatWithCustomerService:SERVICE_ID_XIAONENG1];
        }
          break;
        case 3: {
          [self chatWithCustomerService:SERVICE_ID_XIAONENG2];
        }
          break;
#endif
        default:
          break;
      }
    }
      break;
    default:
      break;
  }
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
    return 15.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (void)setUserPortrait:(NSNotification *)notifycation {
  userPortrait = [notifycation object];
}

- (void)chatWithCustomerService:(NSString *)kefuId {
  RCDCustomerServiceViewController *chatService =
      [[RCDCustomerServiceViewController alloc] init];
  // live800  KEFU146227005669524   live800的客服ID
  // zhichi   KEFU146001495753714   智齿的客服ID
  chatService.conversationType = ConversationType_CUSTOMERSERVICE;

  chatService.targetId = kefuId;

  //上传用户信息，nickname是必须要填写的
  RCCustomerServiceInfo *csInfo = [[RCCustomerServiceInfo alloc] init];
  csInfo.userId = [RCIMClient sharedRCIMClient].currentUserInfo.userId;
  csInfo.nickName = @"昵称";
  csInfo.loginName = @"登录名称";
  csInfo.name = @"用户名称";
  csInfo.grade = @"11级";
  csInfo.gender = @"男";
  csInfo.birthday = @"2016.5.1";
  csInfo.age = @"36";
  csInfo.profession = @"software engineer";
  csInfo.portraitUrl =
      [RCIMClient sharedRCIMClient].currentUserInfo.portraitUri;
  csInfo.province = @"beijing";
  csInfo.city = @"beijing";
  csInfo.memo = @"这是一个好顾客!";

  csInfo.mobileNo = @"13800000000";
  csInfo.email = @"test@example.com";
  csInfo.address = @"北京市北苑路北泰岳大厦";
  csInfo.QQ = @"88888888";
  csInfo.weibo = @"my weibo account";
  csInfo.weixin = @"myweixin";

  csInfo.page = @"卖化妆品的页面来的";
  csInfo.referrer = @"客户端";
  csInfo.enterUrl = @"testurl";
  csInfo.skillId = @"技能组";
  csInfo.listUrl = @[@"用户浏览的第一个商品Url",
                      @"用户浏览的第二个商品Url"];
  csInfo.define = @"自定义信息";

  chatService.csInfo = csInfo;
  chatService.title = @"客服";

  [self.navigationController pushViewController:chatService animated:YES];
}

- (void)shareAction:(UIButton *)button {
    [self closeAction];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[FetchSharePictureRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (object) {
            NSString *urlString = object[@"url"];
            OSMessage *message = [[OSMessage alloc] init];
            message.title = @"果聊";
            message.desc = @"果聊";
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
            //message.image = UIImageJPEGRepresentation(image, 1);
            message.image = imageData;
            //message.thumbnail = UIImageJPEGRepresentation(image, 0.1);
            message.thumbnail = imageData;
            
            if (button == self.wechatButton) {
                [OpenShare shareToWeixinSession:message Success:^(OSMessage *message) {
                    //[self fetchShareReward];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"分享成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                } Fail:^(OSMessage *message, NSError *error) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"分享失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }];
            } else {
                [OpenShare shareToWeixinTimeline:message Success:^(OSMessage *message) {
                    [self fetchShareReward];
                } Fail:^(OSMessage *message, NSError *error) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"分享失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"分享失败，请检查网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];
}
- (void)fetchShareReward {
    [[ShareRewardRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (object) {
            NSInteger money = [object[@"money"] integerValue];
            if (money > 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"分享成功，奖励%@果币", @(money)] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"分享成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];
}
- (void)closeAction {
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds), 150);
    } completion:^(BOOL finished) {
        self.shareView.hidden = YES;
    }];
}

- (UIView *)shareView {
    if (!_shareView) {
        _shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
        _shareView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    }
    return _shareView;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds), 150)];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}
- (UIButton *)wechatButton {
    if (!_wechatButton) {
        _wechatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _wechatButton.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) / 2.0 - 100, 0, 100, 100);
        [_wechatButton setImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
        [_wechatButton setTitle:@"微信好友" forState:UIControlStateNormal];
        [_wechatButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _wechatButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_wechatButton setContentEdgeInsets:UIEdgeInsetsMake(0, - 60, - 60, 0)];
        [_wechatButton setImageEdgeInsets:UIEdgeInsetsMake(- 80, 0, 0, - 110)];
        [_wechatButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wechatButton;
}
- (UIButton *)circleButton {
    if (!_circleButton) {
        _circleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _circleButton.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) / 2.0, 0, 100, 100);
        [_circleButton setImage:[UIImage imageNamed:@"wechat_circle"] forState:UIControlStateNormal];
        [_circleButton setTitle:@"朋友圈" forState:UIControlStateNormal];
        [_circleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _circleButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_circleButton setContentEdgeInsets:UIEdgeInsetsMake(0, - 60, - 60, 0)];
        [_circleButton setImageEdgeInsets:UIEdgeInsetsMake(- 80, 0, 0, - 90)];
        [_circleButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _circleButton;
}


@end
