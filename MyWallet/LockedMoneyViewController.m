//
//  LockedMoneyViewController.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/19.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "LockedMoneyViewController.h"
#import "LockedDetailTableViewController.h"

#import "FetchInformationsRequest.h"
#import "RCDUtilities.h"

@interface LockedMoneyViewController ()
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailButton;

@end

@implementation LockedMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchInformations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fetchInformations {
    [[FetchInformationsRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (object && object[@"lockmoney"]) {
            NSInteger money = [object[@"lockmoney"] integerValue];
            self.amountLabel.text = [RCDUtilities amountStringFromNumber:@(money)];
            if (money > 0) {
                self.detailButton.hidden = NO;
            } else {
                self.detailButton.hidden = YES;
            }
        }
    }];
}

- (IBAction)detailAction:(id)sender {
    LockedDetailTableViewController *detailViewController = [[UIStoryboard storyboardWithName:@"RedPacket" bundle:nil] instantiateViewControllerWithIdentifier:@"LockedDetail"];
    [self.navigationController pushViewController:detailViewController animated:YES];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
