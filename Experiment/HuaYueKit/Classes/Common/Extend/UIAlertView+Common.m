//
//  UIAlertView+Common.m
//  Les
//
//  Created by 朱 亮亮 on 14-9-9.
//  Copyright (c) 2014年 朱 亮亮. All rights reserved.
//

#import "UIAlertView+Common.h"

@implementation UIAlertView (Common)

+ (UIAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    [alert show];
    
    return alert;
}

@end
