//
//  SecuritySettingTableViewController.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/18.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "SecuritySettingTableViewController.h"
#import "RCDChangePasswordViewController.h"
#import "FindPayPasswordViewController.h"
#import "RCDUIBarButtonItem.h"

@interface SecuritySettingTableViewController ()

@end

@implementation SecuritySettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"安全设置";
    self.navigationItem.leftBarButtonItem = [[RCDUIBarButtonItem alloc] initContainImage:[UIImage imageNamed:@"navigator_btn_back"]
                                                                          imageViewFrame:CGRectMake(-6, 4, 10, 17)
                                                                             buttonTitle:@"我的果币"
                                                                              titleColor:[UIColor whiteColor]
                                                                              titleFrame:CGRectMake(9, 4, 85, 17)
                                                                             buttonFrame:CGRectMake(0, 6, 87, 23)
                                                                                  target:self
                                                                                  action:@selector(clickBackBtn)];
    
    self.tableView.tableFooterView = [UIView new];
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 11.0) {
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = indexPath.row == 0? @"修改支付密码" : @"忘记支付密码";
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        RCDChangePasswordViewController *changeViewController = [[RCDChangePasswordViewController alloc] init];
        changeViewController.isPayPassword = YES;
        [self.navigationController pushViewController:changeViewController animated:YES];
    } else {
        FindPayPasswordViewController *viewController = [[UIStoryboard storyboardWithName:@"RedPacket" bundle:nil] instantiateViewControllerWithIdentifier:@"FindPayPassword"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
