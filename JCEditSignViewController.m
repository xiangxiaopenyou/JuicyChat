//
//  JCEditSignViewController.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/6/23.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "JCEditSignViewController.h"
#import "UIColor+RCColor.h"
#import "Masonry.h"
#import "MBProgressHUD.h"
#import "ModifyInformationsRequest.h"

@interface JCEditSignViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UILabel *limitLabel;
@property (strong, nonatomic) UIBarButtonItem *rightItem;

@property (copy, nonatomic) NSString *signString;

@end

@implementation JCEditSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"f0f0f6" alpha:1];
    self.navigationItem.title = @"个性签名";
    self.rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(submitAction)];
    self.navigationItem.rightBarButtonItem = self.rightItem;
    self.rightItem.enabled = NO;
    
    _signString = [[NSUserDefaults standardUserDefaults] stringForKey:@"whatsUp"];
    [self createView];
    
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)submitAction {
    [self.textView resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[ModifyInformationsRequest new] request:^BOOL(ModifyInformationsRequest *request) {
        request.signString = _signString;
        return YES;
    } result:^(id object, NSString *msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (object) {
            [[NSUserDefaults standardUserDefaults] setObject:_signString forKey:@"whatsUp"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"修改失败，请检查网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}
- (void)createView {
    [self.view addSubview:self.tableView];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 12.f)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(8, 10, 30, 10));
    }];
    self.textView.text = _signString;
    [cell.contentView addSubview:self.limitLabel];
    [self.limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(cell.contentView.mas_trailing).with.mas_offset(- 10);
        make.bottom.equalTo(cell.contentView.mas_bottom).with.mas_offset(- 8);
    }];
    self.limitLabel.text = [NSString stringWithFormat:@"%@", @(50 - _signString.length)];
    return cell;
}
- (void)textViewDidChange:(UITextView *)textView {
    _signString = textView.text;
    if (textView.text.length > 0) {
        self.rightItem.enabled = YES;
    } else {
        self.rightItem.enabled = NO;
    }
    if (textView.text.length > 50) {
        textView.text = [_signString substringToIndex:50];
        _signString = textView.text;
    }
    self.limitLabel.text = [NSString stringWithFormat:@"%@", @(50 - _signString.length)];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - getters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectZero];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.delegate = self;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.textColor = [UIColor blackColor];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.returnKeyType = UIReturnKeyDone;
    }
    return _textView;
}
- (UILabel *)limitLabel {
    if (!_limitLabel) {
        _limitLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _limitLabel.font = [UIFont systemFontOfSize:14];
        _limitLabel.textColor = [UIColor colorWithHexString:@"999999" alpha:1];
    }
    return _limitLabel;
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
