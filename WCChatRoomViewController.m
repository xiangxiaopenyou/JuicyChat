//
//  WCChatRoomViewController.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/8/26.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "WCChatRoomViewController.h"
#import "RCDChatViewController.h"
#import "WCChatRoomListCell.h"

#import "WCChatRoomModel.h"

#import "UIImageView+WebCache.h"
#import "MBProgressHUD+Add.h"

@interface WCChatRoomViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSArray *chatRoomsArray;

@end

@implementation WCChatRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"聊天室";
    self.tabBarController.navigationItem.rightBarButtonItems = nil;
    if (self.chatRoomsArray.count == 0) {
        [self fetchChatRoomsRequest];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request
- (void)fetchChatRoomsRequest {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WCChatRoomModel chatRoomList:^(id object, NSString *msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (object) {
            self.chatRoomsArray = [object copy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } else {
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatRoomsArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ChatRoomListCell";
    WCChatRoomListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    WCChatRoomModel *model = self.chatRoomsArray[indexPath.row];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.headico] placeholderImage:[UIImage imageNamed:@"icon_4"]];
    cell.nameLabel.text = model.name;
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WCChatRoomModel *tempModel = self.chatRoomsArray[indexPath.row];
    RCDChatViewController *chatVC = [[RCDChatViewController alloc] initWithConversationType:ConversationType_CHATROOM targetId:tempModel.id];
    chatVC.title = tempModel.name;
    [self.navigationController pushViewController:chatVC animated:YES];
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
