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
#import "MBProgressHUD+Add.h"
#import <RongIMKit/RongIMKit.h>

@interface AppealCenterViewController ()<UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (strong, nonatomic) UIImage *resultImage;
@property (strong, nonatomic) NSMutableArray *resultImagesArray;
@property (strong, nonatomic) NSMutableArray *imageUrlArray;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation AppealCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self refreshImageContents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)refreshImageContents {
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)
     ];
    CGFloat x = 15.f;
    for (NSInteger i = 0; i <= self.resultImagesArray.count; i ++) {
        if (i == self.resultImagesArray.count) {
            if (self.resultImagesArray.count < 4) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(x, 15, 80, 80);
                [button setImage:[UIImage imageNamed:@"add_contents"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
                [self.scrollView addSubview:button];
            }
        } else {
            UIImage *image = self.resultImagesArray[i];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 15, 80, 80)];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.image = image;
            [self.scrollView addSubview:imageView];
            UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteButton.frame = CGRectMake(x + 65, 0, 30, 30);
            [deleteButton setImage:[UIImage imageNamed:@"delete_picture"] forState:UIControlStateNormal];
            deleteButton.tag = 1000 + i;
            [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:deleteButton];
            x += 100;
        }
    }
    if (self.resultImagesArray.count < 4) {
        self.scrollView.contentSize = CGSizeMake(30 + 100 * (self.resultImagesArray.count + 1), 0);
    } else {
        self.scrollView.contentSize = CGSizeMake(30 + 100 * self.resultImagesArray.count, 0);
    }
}
- (void)addAction {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
    [actionSheet showInView:self.view];
}
- (void)deleteAction:(UIButton *)button {
    [self.resultImagesArray removeObjectAtIndex:button.tag - 1000];
    [self refreshImageContents];
}
- (IBAction)submitAction:(id)sender {
    if (self.textView.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"先输入原因" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self.textView resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.resultImagesArray.count > 0) {
        [self.imageUrlArray removeAllObjects];
        for (NSInteger i = 0; i < self.resultImagesArray.count; i ++) {
            UIImage *tempImage = self.resultImagesArray[i];
            NSData *imageData = UIImageJPEGRepresentation(tempImage, 0.7);
            [RCDHTTPTOOL uploadImageToQiNiu:[RCIM sharedRCIM].currentUserInfo.userId ImageData:imageData success:^(NSString *url) {
                [self.imageUrlArray addObject:url];
                if (self.imageUrlArray.count == self.resultImagesArray.count) {
                    [[AppealRequest new] request:^BOOL(AppealRequest *request) {
                        request.content = self.textView.text;
                        request.images = self.imageUrlArray;
                        return YES;
                    } result:^(id object, NSString *msg) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        if (object) {
                            [MBProgressHUD showSuccess:@"提交成功" toView:[UIApplication sharedApplication].keyWindow];
                            [self.navigationController popViewControllerAnimated:YES];
                        } else {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                            [alert show];
                        }
                    }];
                }
            } failure:^(NSError *err) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败" message:@"上传图片失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }];
        }
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
        [self.resultImagesArray addObject:_resultImage];
        [self refreshImageContents];
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
- (NSMutableArray *)imageUrlArray {
    if (!_imageUrlArray) {
        _imageUrlArray = [[NSMutableArray alloc] init];
    }
    return _imageUrlArray;
}

@end
