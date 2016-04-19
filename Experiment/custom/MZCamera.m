//
//  MZCameraHelper.m
//  WebViewTest
//
//  Created by 崔俊红 on 15/5/7.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "MZCamera.h"
#import "HYHelper.h"
@interface MZCamera () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) UIViewController *inVC;
@property (strong, nonatomic) mzcamera_block_t cBlock;
@end
@implementation MZCamera

+ (instancetype)shared
{
    static MZCamera *__mzCamera;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __mzCamera = [[MZCamera alloc]init];
    });
    return __mzCamera;
}

- (void)mOpenPickerInVC:(UIViewController*)vc  source:(UIImagePickerControllerSourceType)st block:(mzcamera_block_t)block
{
    self.inVC = vc;
    self.cBlock = block;
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    picker.sourceType = st;
    picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    picker.allowsEditing = NO;
    if (st == UIImagePickerControllerSourceTypePhotoLibrary) {
    }else if(st == UIImagePickerControllerSourceTypeCamera){
        picker.showsCameraControls = YES;
    }
    picker.delegate = self;
    [vc presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image =info[UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum(image, self, nil, NULL);
    //NSData *data = UIImagePNGRepresentation([HYHelper imageCompressForSize:image  targetSize:CGSizeMake(330.0f,560.0f)]);
    NSData *data = [HYHelper imageCompressWithImage:image];
    if (_cBlock) {_cBlock(data);}
}

@end
