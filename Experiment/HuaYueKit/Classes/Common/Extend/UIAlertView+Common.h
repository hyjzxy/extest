//
//  UIAlertView+Common.h
//  Les
//
//  Created by 朱 亮亮 on 14-9-9.
//  Copyright (c) 2014年 朱 亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Common)

+ (UIAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
