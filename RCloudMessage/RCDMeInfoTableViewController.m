//
//  RCDMeInfoTableViewController.m
//  RCloudMessage
//
//  Created by litao on 15/11/4.
//  Copyright © 2015年 RongCloud. All rights reserved.
//

#import "RCDMeInfoTableViewController.h"
#import "DefaultPortraitView.h"
#import "MBProgressHUD.h"
#import "RCDChangePasswordViewController.h"
#import "RCDChatViewController.h"
#import "RCDCommonDefine.h"
#import "RCDEditUserNameViewController.h"
#import "RCDHttpTool.h"
#import "RCDRCIMDataSource.h"
#import "RCDataBaseManager.h"
#import "UIColor+RCColor.h"
#import "UIImageView+WebCache.h"
#import <RongIMLib/RongIMLib.h>
#import "RCDUIBarButtonItem.h"
#import "RCDBaseSettingTableViewCell.h"
#import "JCMySignCell.h"
#import "RCDUtilities.h"
#import "ModifyInformationsRequest.h"
#import "JCEditSignViewController.h"

@interface RCDMeInfoTableViewController ()

@end

@implementation RCDMeInfoTableViewController {
  NSData *data;
  UIImage *image;
  MBProgressHUD *hud;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.tableFooterView = [UIView new];
  self.tabBarController.navigationItem.rightBarButtonItem = nil;
  self.tabBarController.navigationController.navigationBar.tintColor =
      [UIColor whiteColor];
  self.tableView.backgroundColor = [UIColor colorWithHexString:@"f0f0f6" alpha:1.f];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 11.0) {
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
  self.navigationItem.title = @"个人信息";
  
  RCDUIBarButtonItem *leftBtn =
  [[RCDUIBarButtonItem alloc] initContainImage:[UIImage imageNamed:@"navigator_btn_back"]
                                imageViewFrame:CGRectMake(-6, 4, 10, 17)
                                   buttonTitle:@"我"
                                    titleColor:[UIColor whiteColor]
                                    titleFrame:CGRectMake(9, 4, 85, 17)
                                   buttonFrame:CGRectMake(0, 6, 87, 23)
                                        target:self
                                        action:@selector(cilckBackBtn:)];
  self.navigationItem.leftBarButtonItem = leftBtn;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 6;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *reusableCellWithIdentifier = @"RCDBaseSettingTableViewCell";
  RCDBaseSettingTableViewCell *cell = [self.tableView
                                       dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
  if (cell == nil) {
    cell = [[RCDBaseSettingTableViewCell alloc] init];
  }
  switch (indexPath.section) {
    case 0: {
      switch (indexPath.row) {
        case 0: {
          NSString *portraitUrl = [DEFAULTS stringForKey:@"userPortraitUri"];
          if ([portraitUrl isEqualToString:@""]) {
            portraitUrl = [RCDUtilities defaultUserPortrait:[RCIM sharedRCIM].currentUserInfo];
          }
          [cell setImageView:cell.rightImageView
                    ImageStr:portraitUrl
                   imageSize:CGSizeMake(65, 65)
                 LeftOrRight:1];
          cell.rightImageCornerRadius = 5.f;
          cell.leftLabel.text = @"头像";
          return cell;
        }
          break;
          
        case 1: {
          [cell setCellStyle:DefaultStyle_RightLabel];
          cell.leftLabel.text = @"昵称";
          cell.rightLabel.text = [DEFAULTS stringForKey:@"userNickName"];
          return cell;
        }
          break;
          
        case 2: {
          [cell setCellStyle:DefaultStyle_RightLabel_WithoutRightArrow];
          cell.leftLabel.text = @"账号";
          cell.rightLabel.text = [DEFAULTS stringForKey:@"userName"];
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
          return cell;
        }
          break;
          case 3: {
              [cell setCellStyle:DefaultStyle_RightLabel];
              cell.leftLabel.text = @"性别";
              if ([DEFAULTS integerForKey:@"userSex"] == 0) {
                  cell.rightLabel.text = @"未设置";
              } else {
                  cell.rightLabel.text = [DEFAULTS integerForKey:@"userSex"] == 1 ? @"男" : @"女";
              }
              return cell;
          }
              break;
          case 4:{
              [cell setCellStyle:DefaultStyle_RightLabel_WithoutRightArrow];
              cell.leftLabel.text = @"用户ID";
              cell.rightLabel.text = [DEFAULTS stringForKey:@"userId"];
              cell.selectionStyle = UITableViewCellSelectionStyleNone;
              return cell;
          }
              break;
          case 5:{
              JCMySignCell *signCell = [tableView dequeueReusableCellWithIdentifier:@"MySignCell"];
              if (!signCell) {
                  signCell = [[JCMySignCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MySignCell"];
              }
              NSString *signString = [DEFAULTS stringForKey:@"whatsUp"];
              signCell.signLabel.text = signString ? signString : @"暂未设置";
              return signCell;
          }
              break;
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
  CGFloat height = 0;
  switch (indexPath.section) {
    case 0:{
      switch (indexPath.row) {
        case 0:
          height = 88.f;
          break;
          case 5: {
              NSString *signString = [DEFAULTS stringForKey:@"whatsUp"];
              if (signString) {
                  CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
                  CGSize size = [signString boundingRectWithSize:CGSizeMake(width - 128, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
                  height = 26.f + size.height;
              } else {
                  height = 44.f;
              }
              
          }
              break;
        default:
          height = 44.f;
          break;
      }
    }
      break;
      
    default:
      break;
  }
  return height;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  return 15.f;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES]; // 取消选中
  
  switch (indexPath.row) {
    case 0: {
      if ([self dealWithNetworkStatus]) {
        [self changePortrait];
      }
    }
      break;
      
    case 1: {
      if ([self dealWithNetworkStatus]) {
        RCDEditUserNameViewController *vc = [[RCDEditUserNameViewController alloc] init];
        [self.navigationController pushViewController:vc
                                             animated:YES];
      }
    }
      break;
      case 3: {
          UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
          UIAlertAction *alert1 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
              [self editSexRequest:1];
          }];
          UIAlertAction *alert2 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
              [self editSexRequest:2];
          }];
          UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
          [alertController addAction:alert1];
          [alertController addAction:alert2];
          [alertController addAction:cancelAlert];
          [self presentViewController:alertController animated:YES completion:nil];
      };
          break;
      case 5: {
          JCEditSignViewController *signViewController = [[JCEditSignViewController alloc] init];
          [self.navigationController pushViewController:signViewController animated:YES];
      }
          break;
    default:
      break;
  }
}
- (void)editSexRequest:(NSInteger)sexInt {
    [[ModifyInformationsRequest new] request:^BOOL(ModifyInformationsRequest *request) {
        request.sex = @(sexInt);
        return YES;
    } result:^(id object, NSString *msg) {
        if (object) {
            [DEFAULTS setObject:@(sexInt) forKey:@"userSex"];
            [DEFAULTS synchronize];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                //关闭HUD
                [hud hide:YES];
            });
        } else {
            [hud hide:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"设置性别失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void)changePortrait {
  UIActionSheet *actionSheet =
      [[UIActionSheet alloc] initWithTitle:nil
                                  delegate:self
                         cancelButtonTitle:@"取消"
                    destructiveButtonTitle:@"拍照"
                         otherButtonTitles:@"我的相册", nil];
  [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet
    didDismissWithButtonIndex:(NSInteger)buttonIndex {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    
    switch (buttonIndex) {
      case 0:
        if ([UIImagePickerController
             isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
          picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
          NSLog(@"模拟器无法连接相机");
        }
        [self presentViewController:picker animated:YES completion:nil];
        break;
        
      case 1:
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
        break;
        
      default:
        break;
  }
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
  [UIApplication sharedApplication].statusBarHidden = NO;

  NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];

  
  if ([mediaType isEqual:@"public.image"]) {
    //获取原图
    UIImage *originImage =
        [info objectForKey:UIImagePickerControllerOriginalImage];
    //获取截取区域
     CGRect captureRect = [[info objectForKey:UIImagePickerControllerCropRect] CGRectValue];
    //获取截取区域的图像
    UIImage *captureImage = [self getSubImage:originImage Rect:captureRect imageOrientation:originImage.imageOrientation];
    UIImage *scaleImage = [self scaleImage:captureImage toScale:0.8];
    data = UIImageJPEGRepresentation(scaleImage, 0.00001);
  }
  image = [UIImage imageWithData:data];
  [self dismissViewControllerAnimated:YES completion:nil];
  hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  hud.color = [UIColor colorWithHexString:@"343637" alpha:0.5];
  hud.labelText = @"上传头像中...";
  [hud show:YES];

  [RCDHTTPTOOL uploadImageToQiNiu:[RCIM sharedRCIM].currentUserInfo.userId
      ImageData:data
      success:^(NSString *url) {
          [[ModifyInformationsRequest new] request:^BOOL(ModifyInformationsRequest *request) {
              request.avatar = url;
              return YES;
          } result:^(id object, NSString *msg) {
              if (object) {
                    [RCIM sharedRCIM].currentUserInfo.portraitUri = url;
                    RCUserInfo *userInfo = [RCIM sharedRCIM].currentUserInfo;
                    userInfo.portraitUri = url;
                    [DEFAULTS setObject:url forKey:@"userPortraitUri"];
                    [DEFAULTS synchronize];
                    [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:[RCIM sharedRCIM].currentUserInfo.userId];
                    [[RCDataBaseManager shareInstance] insertUserToDB:userInfo];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"setCurrentUserPortrait"
                                      object:image];
                    dispatch_async(dispatch_get_main_queue(), ^{
                      [self.tableView reloadData];
                      //关闭HUD
                      [hud hide:YES];
                    });
              } else {
                    [hud hide:YES];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"上传头像失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
              }
          }];
//        [RCDHTTPTOOL
//            setUserPortraitUri:url
//                      complete:^(BOOL result) {
//                        if (result == YES) {
//                          [RCIM sharedRCIM].currentUserInfo.portraitUri = url;
//                          RCUserInfo *userInfo =
//                              [RCIM sharedRCIM].currentUserInfo;
//                          userInfo.portraitUri = url;
//                          [DEFAULTS setObject:url forKey:@"userPortraitUri"];
//                          [DEFAULTS synchronize];
//                          [[RCIM sharedRCIM]
//                              refreshUserInfoCache:userInfo
//                                        withUserId:[RCIM sharedRCIM]
//                                                       .currentUserInfo.userId];
//                          [[RCDataBaseManager shareInstance]
//                              insertUserToDB:userInfo];
//                          [[NSNotificationCenter defaultCenter]
//                              postNotificationName:@"setCurrentUserPortrait"
//                                            object:image];
//                          dispatch_async(dispatch_get_main_queue(), ^{
//                            [self.tableView reloadData];
//                            //关闭HUD
//                            [hud hide:YES];
//                          });
//                        }
//                        if (result == NO) {
//                          //关闭HUD
//                          [hud hide:YES];
//                          UIAlertView *alert = [[UIAlertView alloc]
//                                  initWithTitle:nil
//                                        message:@"上传头像失败"
//                                       delegate:self
//                              cancelButtonTitle:@"确定"
//                              otherButtonTitles:nil];
//                          [alert show];
//                        }
//                      }];

      }
      failure:^(NSError *err) {
        //关闭HUD
        [hud hide:YES];
        UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:nil
                                       message:@"上传头像失败"
                                      delegate:self
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil];
        [alert show];
      }];
}

-(UIImage*)getSubImage:(UIImage *)originImage Rect:(CGRect)rect imageOrientation:(UIImageOrientation)imageOrientation
{
  CGImageRef subImageRef = CGImageCreateWithImageInRect(originImage.CGImage, rect);
  CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
  
  UIGraphicsBeginImageContext(smallBounds.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextDrawImage(context, smallBounds, subImageRef);
  UIImage* smallImage = [UIImage imageWithCGImage:subImageRef scale:1.f orientation:imageOrientation];
  UIGraphicsEndImageContext();
  return smallImage;
}

- (UIImage *)scaleImage:(UIImage *)tempImage toScale:(float)scaleSize {
  UIGraphicsBeginImageContext(CGSizeMake(tempImage.size.width * scaleSize,
                                         tempImage.size.height * scaleSize));
  [tempImage drawInRect:CGRectMake(0, 0, tempImage.size.width * scaleSize,
                                   tempImage.size.height * scaleSize)];
  UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return scaledImage;
}

-(void)cilckBackBtn:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)dealWithNetworkStatus {
  BOOL isconnected = NO;
  RCNetworkStatus networkStatus = [[RCIMClient sharedRCIMClient] getCurrentNetworkStatus];
  if (networkStatus == 0) {
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:nil
                               message:@"当前网络不可用，请检查你的网络设置"
                              delegate:nil
                     cancelButtonTitle:@"确定"
                     otherButtonTitles:nil];
    [alert show];
    return isconnected;
  }
  return isconnected = YES;
}
@end
