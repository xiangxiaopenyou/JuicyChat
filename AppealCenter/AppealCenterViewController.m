//
//  AppealCenterViewController.m
//  RCloudMessage
//
//  Created by 项小盆友 on 2017/5/18.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "AppealCenterViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AppealRequest.h"
#import "MBProgressHUD.h"
#import "RCDHttpTool.h"
#import <RongIMKit/RongIMKit.h>

@interface AppealCenterViewController ()<UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (strong, nonatomic) UIImage *resultImage;
@property (strong, nonatomic) NSMutableArray *resultImagesArray;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation AppealCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentImageView.userInteractionEnabled = YES;
    [self.contentImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPicture)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)refreshImageContents {
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)
     ];
    for (NSInteger i = 0; i < self.resultImagesArray.count; i ++) {
        
    }
}
- (IBAction)submitAction:(id)sender {
    if (self.textView.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"先输入投诉原因" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.resultImage) {
        NSData *imageData = UIImageJPEGRepresentation(self.resultImage, 0.8);
        [RCDHTTPTOOL uploadImageToQiNiu:[RCIM sharedRCIM].currentUserInfo.userId ImageData:imageData success:^(NSString *url) {
            [[AppealRequest new] request:^BOOL(AppealRequest *request) {
                request.content = self.textView.text;
                request.images = @[url];
                return YES;
            } result:^(id object, NSString *msg) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (object) {
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }
            }];
        } failure:^(NSError *err) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败" message:@"上传图片失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }];
    } else {
        [[AppealRequest new] request:^BOOL(AppealRequest *request) {
            request.content = self.textView.text;
            return YES;
        } result:^(id object, NSString *msg) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (object) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
}
- (void)addPicture {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
    [actionSheet showInView:self.view];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.placeHolderLabel.hidden = textView.text.length > 0 ? YES : NO;
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.delegate = self;
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerController.mediaTypes = @[(NSString *)kUTTypeImage];
        pickerController.allowsEditing = YES;
        [self presentViewController:pickerController animated:YES completion:nil];
        
    } else if (buttonIndex == 0) {
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.delegate = self;
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerController.mediaTypes = @[(NSString *)kUTTypeImage];
        pickerController.allowsEditing = YES;
        [self presentViewController:pickerController animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    _resultImage = [info objectForKey:UIImagePickerControllerEditedImage];
    if (_resultImage) {
        self.contentImageView.image = _resultImage;
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

#pragma mark - Getters
- (NSMutableArray *)resultImagesArray {
    if (!_resultImagesArray) {
        _resultImagesArray = [[NSMutableArray alloc] init];
    }
    return _resultImagesArray;
}

@end
