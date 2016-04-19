//
//  MZCameraHelper.h
//  WebViewTest
//
//  Created by 崔俊红 on 15/5/7.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^mzcamera_block_t)(NSData*data);

@interface MZCamera : NSObject
+ (instancetype)shared;
- (void)mOpenPickerInVC:(UIViewController*)vc  source:(UIImagePickerControllerSourceType)st block:(mzcamera_block_t)block;
@end
