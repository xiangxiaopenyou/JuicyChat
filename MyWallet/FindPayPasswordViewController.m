//
//  FindPayPasswordViewController.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/19.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "FindPayPasswordViewController.h"
#import "MBProgressHUD.h"
#import "AFHttpTool.h"
#import "FindPayPasswordRequest.h"

@interface FindPayPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeButton;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (assign, nonatomic) NSInteger seconds;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation FindPayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *accountString = [[NSUserDefaults standardUserDefaults] stringForKey:@"userName"];
    if (accountString.length) {
        self.accountTextField.text = accountString;
        self.accountTextField.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendCodeAction:(id)sender {
    NSString *accountString = self.accountTextField.text;
    if (accountString.length != 11) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"手机号有误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFHttpTool getVerificationCode:accountString success:^(id response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.sendCodeButton.hidden = YES;
        self.countDownLabel.hidden = NO;
        [self countDown:60];
    } failure:^(NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"获取验证码失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }];
}
- (IBAction)finishAction:(id)sender {
    if (self.codeTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (self.passwordTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入新密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (self.passwordTextField.text.length != 6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"密码必须为6位数字" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[FindPayPasswordRequest new] request:^BOOL(FindPayPasswordRequest *request) {
        request.verificationCode = self.codeTextField.text;
        request.password = self.passwordTextField.text;
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
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)countDown:(NSInteger)second {
    _seconds = second;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(timeFireMethod)
                                   userInfo:nil
                                    repeats:YES];
}
- (void)timeFireMethod {
    _seconds--;
    self.countDownLabel.text = [NSString stringWithFormat:@"%@秒后发送", @(_seconds)];
    if (_seconds == 0) {
        [_timer invalidate];
        self.sendCodeButton.hidden = NO;
        self.countDownLabel.hidden = YES;
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
- (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
