//
//  RedPacketViewController.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/9.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "RedPacketViewController.h"
#import "RedPacketWordsCell.h"
#import "RedPacketCommonCell.h"

#define SCREEN_WIDTH CGRectGetWidth(UIScreen.mainScreen.bounds)
#define SCREEN_HEIGHT CGRectGetHeight(UIScreen.mainScreen.bounds)

@interface RedPacketViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation RedPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发红包";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeAction)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submitAction:(id)sender {
}
- (void)textChanged:(UITextField *)textField {
    UITextField *textField1 = (UITextField *)[self.tableView viewWithTag:1000];
    UITextField *textField2 = (UITextField *)[self.tableView viewWithTag:1002];
    if (self.type == ConversationType_PRIVATE) {
        if ([textField1.text floatValue] > 0) {
            self.submitButton.enabled = YES;
            [self.submitButton setBackgroundColor:[UIColor colorWithRed:216/255.0 green:78/255.0 blue:67/255.0 alpha:1]];
        } else {
            self.submitButton.enabled = NO;
            [self.submitButton setBackgroundColor:[UIColor colorWithRed:245/255.0 green:168/255.0 blue:171/255.0 alpha:1]];
        }
    } else {
        if ([textField1.text floatValue] > 0 && [textField2.text integerValue] > 0) {
            self.submitButton.enabled = YES;
            [self.submitButton setBackgroundColor:[UIColor colorWithRed:216/255.0 green:78/255.0 blue:67/255.0 alpha:1]];
        } else {
            self.submitButton.enabled = NO;
            [self.submitButton setBackgroundColor:[UIColor colorWithRed:245/255.0 green:168/255.0 blue:171/255.0 alpha:1]];
        }
    }
    if (textField == textField1) {
        self.amountLabel.text = [NSString stringWithFormat:@"￥%.2f", [textField1.text floatValue]];
    }
}
- (void)closeAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSRange rangeItem = [textField.text rangeOfString:@"."];//判断字符串是否包含
    if (rangeItem.location != NSNotFound) {
        if ([string isEqualToString:@"."]) {
            return NO;
        } else {
            //rangeItem.location == 0   说明“.”在第一个位置
            if (range.location > rangeItem.location + 2) {
                return NO;
            }
        }
    } else {
        if ([string isEqualToString:@"."]) {
            if (textField.text.length < 1) {
                textField.text = @"0.";
                return NO;
            }
            return YES;
        }
        if (range.location>1) {
            return NO;
        }
    }
    
    return YES;
}

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
        cell.rightLabel.text = @"元";
        cell.textField.tag = 1000;
        cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
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
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
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

@end
