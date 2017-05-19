//
//  SetupPayPasswordViewController.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/9.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "SetupPayPasswordViewController.h"
#import "MBProgressHUD.h"
#import "UIColor+RCColor.h"
#import "SetupPayPasswordRequest.h"

@interface SetupPayPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation SetupPayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishAction)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)finishAction {
    if (self.passwordTextField.text.length < 6 || self.passwordTextField.text.length > 6) {
        [self AlertShow:@"密码必须为6位数字"];
        return;
    }
    if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        [self AlertShow:@"两次密码输入不一致"];
        return;
    }
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.color = [UIColor colorWithHexString:@"343637" alpha:0.5];
    _hud.labelText = @"";
    [_hud show:YES];
    [[SetupPayPasswordRequest new] request:^BOOL(SetupPayPasswordRequest *request) {
        request.password = self.passwordTextField.text;
        return YES;
    } result:^(id object, NSString *msg) {
        if (object) {
            [_hud setHidden:YES];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [_hud setHidden:YES];
            [self AlertShow:@"支付密码设置失败"];
        }
    }];
    
}

- (void)AlertShow:(NSString *)content {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:content
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
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
