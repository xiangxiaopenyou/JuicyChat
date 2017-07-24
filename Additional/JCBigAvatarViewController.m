//
//  JCBigAvatarViewController.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/6/26.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "JCBigAvatarViewController.h"
#import "UIImageView+WebCache.h"

@interface JCBigAvatarViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end

@implementation JCBigAvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.urlString] placeholderImage:nil];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAction)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeAction {
    [self dismissViewControllerAnimated:NO completion:nil];
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
