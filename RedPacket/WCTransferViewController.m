//
//  WCTransferViewController.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/7/28.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "WCTransferViewController.h"
#import "SetupPayPasswordViewController.h"
#import "DefaultPortraitView.h"
#import "UIImageView+WebCache.h"
#import "WCTransferRequest.h"
#import "FetchBalanceRequest.h"
#import "CheckSetPayPasswordRequest.h"
#import "EntryPasswordView.h"
#import "CWTransferSuccessView.h"
#import "MBProgressHUD.h"
#import "UIColor+RCColor.h"
#import "RCDUtilities.h"

#define SCREEN_WIDTH CGRectGetWidth(UIScreen.mainScreen.bounds)
#define SCREEN_HEIGHT CGRectGetHeight(UIScreen.mainScreen.bounds)

@interface WCTransferViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *noteTextField;
@property (weak, nonatomic) IBOutlet UIButton *transferButton;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipLabelLeadingConstraint;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) EntryPasswordView *entryView;
@property (strong, nonatomic) CWTransferSuccessView *successView;

@end

@implementation WCTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.userInfo.portraitUri isEqualToString:@""]) {
        DefaultPortraitView *defaultPortrait = [[DefaultPortraitView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [defaultPortrait setColorAndLabel:self.userInfo.userId
                                 Nickname:self.userInfo.name];
        UIImage *portrait = [defaultPortrait imageFromView];
        self.avatarImageView.image = portrait;
    } else {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.userInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"icon_person"]];
    }
    self.nicknameLabel.text = [NSString stringWithFormat:@"%@", self.userInfo.name];
    [self.textField becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishInputAction:) name:@"kPayPaswordInputDidFinish" object:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kPayPaswordInputDidFinish" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)transferAction:(id)sender {
    [self.textField resignFirstResponder];
    [self.noteTextField resignFirstResponder];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.color = [UIColor colorWithHexString:@"343637" alpha:0.5];
    _hud.labelText = @"";
    [_hud show:YES];
    [[CheckSetPayPasswordRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (object) {
            if ([object[@"code"] integerValue] == 200) {
                [[FetchBalanceRequest new] request:^BOOL(id request) {
                    return YES;
                } result:^(id object, NSString *msg) {
                    if (object) {
                        [_hud hide:YES];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.entryView show];
                            self.entryView.amount = self.textField.text.integerValue * 100;
                            self.entryView.balance = [object[@"money"] integerValue];
                        });
                    } else {
                        [_hud hide:YES];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"获取余额失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [alert show];
                    }
                }];
                
            } else if ([object[@"code"] integerValue] == 66001) {
                [_hud hide:YES];
                SetupPayPasswordViewController *setupPayPassword = [[UIStoryboard storyboardWithName:@"RedPacket" bundle:nil] instantiateViewControllerWithIdentifier:@"SetupPayPassword"];
                [self.navigationController pushViewController:setupPayPassword animated:YES];
            } else {
                [_hud hide:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"网络错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        } else {
            [_hud hide:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"网络错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];

}
- (void)finishInputAction:(NSNotification *)notification {
    if (notification) {
        _hud = [MBProgressHUD showHUDAddedTo:self.entryView animated:YES];
        _hud.color = [UIColor colorWithHexString:@"343637" alpha:0.5];
        _hud.labelText = @"";
        [_hud show:YES];
        NSString *passwordString = (NSString *)notification.object;
        [[WCTransferRequest new] request:^BOOL(WCTransferRequest *request) {
            request.userId = self.userInfo.userId;
            request.money = @(self.textField.text.integerValue * 100);
            request.password = passwordString;
            request.note = self.noteTextField.text;
            return YES;
        } result:^(id object, NSString *msg) {
            if (object) {
                [_hud hide:YES];
               [self.entryView closeAction];
                _successView = [[CWTransferSuccessView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
                NSString *nameString = [[NSUserDefaults standardUserDefaults] stringForKey:@"userNickName"];
                NSString *userIdString = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
                _successView.senderLabel.text = [NSString stringWithFormat:@"%@（ID:%@）", nameString, userIdString];
                _successView.receiverLabel.text = [NSString stringWithFormat:@"%@（ID:%@）", self.userInfo.name, self.userInfo.userId];
                _successView.amountLabel.text = [RCDUtilities amountStringFromNumber:@(self.textField.text.integerValue * 100)];
                NSDate *date = [NSDate date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                _successView.timeLabel.text = [formatter stringFromDate:date];
                __weak WCTransferViewController *weakSelf = self;
                _successView.closeBlock = ^{
                    __strong WCTransferViewController *strongSelf = weakSelf;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [strongSelf dismissViewControllerAnimated:YES completion:nil];
                    });
                };
                [_successView show];
            } else {
                [_hud hide:YES];
                [self.entryView clearPassword];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
}
- (IBAction)cancelAction:(id)sender {
    [self.textField resignFirstResponder];
    [self.noteTextField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)editingChanged:(id)sender {
    self.countLabel.text = [self amountStringFromNumber:@(self.textField.text.integerValue * 100)];
    if ([self.textField.text integerValue] > 0) {
        self.transferButton.enabled = YES;
        [self.transferButton setBackgroundColor:[UIColor colorWithRed:216/255.0 green:78/255.0 blue:67/255.0 alpha:1]];
        self.tipLabel.hidden = NO;
        CGSize size = [self.textField.text sizeWithAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:26]}];
        self.tipLabelLeadingConstraint.constant = size.width + 18;
    } else {
        self.transferButton.enabled = NO;
        [self.transferButton setBackgroundColor:[UIColor colorWithRed:245/255.0 green:168/255.0 blue:171/255.0 alpha:1]];
        self.tipLabel.hidden = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (NSString *)amountStringFromNumber:(NSNumber *)amount {
    NSString *amountString = [NSString stringWithFormat:@"%@", amount];
    NSMutableString *mutableString = [amountString mutableCopy];
    if (amountString.length > 2) {
        for (NSInteger i = amountString.length - 2; i > 0; i -= 4) {
            [mutableString insertString:@"," atIndex:i];
        }
    }
    return mutableString;
}

- (EntryPasswordView *)entryView {
    if (!_entryView) {
        _entryView = [[EntryPasswordView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _entryView;
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
