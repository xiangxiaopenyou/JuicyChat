//
//  RedPacketViewController.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/9.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "RedPacketViewController.h"
#import "SetupPayPasswordViewController.h"
#import "RedPacketWordsCell.h"
#import "RedPacketCommonCell.h"
#import "EntryPasswordView.h"

#import "CheckSetPayPasswordRequest.h"
#import "FetchBalanceRequest.h"
#import "SendRedPacketRequest.h"
#import "UIColor+RCColor.h"
#import "MBProgressHUD.h"

#define SCREEN_WIDTH CGRectGetWidth(UIScreen.mainScreen.bounds)
#define SCREEN_HEIGHT CGRectGetHeight(UIScreen.mainScreen.bounds)

@interface RedPacketViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) EntryPasswordView *entryView;

@end

@implementation RedPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发红包";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeAction)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishInputAction:) name:@"kPayPaswordInputDidFinish" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kPayPaswordInputDidFinish" object:nil];
}
- (IBAction)submitAction:(id)sender {
    UITextField *textField1 = (UITextField *)[self.tableView viewWithTag:1000];
    UITextField *textField2 = (UITextField *)[self.tableView viewWithTag:1002];
    if (self.type == ConversationType_GROUP) {
        if (textField1.text.integerValue * 100 / textField2.text.integerValue < 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"每个红包至少1个果币哦~" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    
    [textField1 resignFirstResponder];
    [textField2 resignFirstResponder];
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
                            self.entryView.amount = textField1.text.integerValue * 100;
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
        [[SendRedPacketRequest new] request:^BOOL(SendRedPacketRequest *request) {
            UITextField *textField1 = (UITextField *)[self.tableView viewWithTag:1001];
            UITextField *textField2 = (UITextField *)[self.tableView viewWithTag:1000];
            UITextField *textField3 = (UITextField *)[self.tableView viewWithTag:1002];
            if (self.type == ConversationType_GROUP) {
                request.type = @(2);
                request.toId = self.groupInfo.groupId;
                request.count = @(textField3.text.integerValue);
            } else {
                request.type = @(1);
                request.toId = self.toId;
            }
            
            if (textField1.text.length > 0) {
                request.note = textField1.text;
            }
            request.payPassword = passwordString;
            request.amount = @(textField2.text.integerValue * 100);
            return YES;
        } result:^(id object, NSString *msg) {
            [_hud hide:YES];
            if (object) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (object[@"id"]) {
                        [self.entryView closeAction];
                        [self dismissViewControllerAnimated:YES completion:nil];
                        NSString *noteString = @"恭喜发财，大吉大利";
                        if (object[@"note"]) {
                            noteString = object[@"note"];
                        }
                        NSString *idString = [NSString stringWithFormat:@"%@", object[@"id"]];
                        if (self.successBlock) {
                            self.successBlock(idString, noteString);
                        }
                    } else {
                        [self.entryView clearPassword];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"发送失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [alert show];
                    }
                    
                });
            } else {
                [_hud hide:YES];
                [self.entryView clearPassword];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
}
- (void)textChanged:(UITextField *)textField {
    UITextField *textField1 = (UITextField *)[self.tableView viewWithTag:1000];
    UITextField *textField2 = (UITextField *)[self.tableView viewWithTag:1002];
    UILabel *tipLabel = (UILabel *)[self.tableView viewWithTag:10000];
    if (self.type == ConversationType_PRIVATE) {
        if ([textField1.text integerValue] > 0) {
            self.submitButton.enabled = YES;
            tipLabel.hidden = NO;
            [self.submitButton setBackgroundColor:[UIColor colorWithRed:216/255.0 green:78/255.0 blue:67/255.0 alpha:1]];
        } else {
            self.submitButton.enabled = NO;
            tipLabel.hidden = YES;
            [self.submitButton setBackgroundColor:[UIColor colorWithRed:245/255.0 green:168/255.0 blue:171/255.0 alpha:1]];
        }
    } else {
        if ([textField1.text integerValue] > 0 && [textField2.text integerValue] > 0) {
            self.submitButton.enabled = YES;
            [self.submitButton setBackgroundColor:[UIColor colorWithRed:216/255.0 green:78/255.0 blue:67/255.0 alpha:1]];
        } else {
            self.submitButton.enabled = NO;
            [self.submitButton setBackgroundColor:[UIColor colorWithRed:245/255.0 green:168/255.0 blue:171/255.0 alpha:1]];
        }
        if ([textField1.text integerValue] > 0) {
            tipLabel.hidden = NO;
        } else {
            tipLabel.hidden = YES;
        }
    }
    if (textField == textField1) {
        self.amountLabel.text = [self amountStringFromNumber:@([textField1.text
                                                                integerValue] * 100)];
    }
}
- (void)closeAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    
//    return YES;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.type == ConversationType_PRIVATE ? 2 : 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    if (self.type == ConversationType_PRIVATE) {
        height = indexPath.section == 0 ? 60 : 70;
    } else {
        height = indexPath.section == 2 ? 70 : 60;
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *identifier = @"RedPacketCommon";
        RedPacketCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.type == ConversationType_PRIVATE) {
            cell.leftLabel.text = @"金额";
        } else {
            cell.leftLabel.text = @"总金额";
        }
        cell.rightLabel.text = @"果币";
        cell.textField.tag = 1000;
        cell.tipLabel.tag = 10000;
        cell.textField.delegate = self;
        [cell.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        return cell;
    } else if (indexPath.section == 1) {
        if (self.type == ConversationType_PRIVATE) {
            static NSString *identifier = @"RedPacketWords";
            RedPacketWordsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textView.tag = 1001;
            return cell;
        } else {
            static NSString *identifier = @"RedPacketCommon";
            RedPacketCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftLabel.text = @"红包个数";
            cell.rightLabel.text = @"个";
            cell.textField.tag = 1002;
            cell.tipLabel.tag = 10002;
            [cell.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
            return cell;

        }
    } else {
        static NSString *identifier = @"RedPacketWords";
        RedPacketWordsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textView.tag = 1001;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    footerView.backgroundColor = [UIColor clearColor];
    if (section == 1 && self.type == ConversationType_GROUP) {
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 30)];
        numberLabel.text = [NSString stringWithFormat:@"本群共%@人", self.groupInfo.number];
        numberLabel.font = [UIFont systemFontOfSize:12];
        numberLabel.textColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
        [footerView addSubview:numberLabel];
    }
    return footerView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (EntryPasswordView *)entryView {
    if (!_entryView) {
        _entryView = [[EntryPasswordView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _entryView;
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

@end
