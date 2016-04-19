//
//  UIAlertView+Block.m
//  HuaYue
//
//  Created by 崔俊红 on 15-3-28.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "UIAlertView+Block.h"
#import <objc/runtime.h>

@interface UIAlertView ()<UIAlertViewDelegate>

@end

@implementation UIAlertView (Block)
@dynamic okBlock;
@dynamic cancelBlock;

- (void)setOkBlock:(alert_block_t)newOkBlock
{
    objc_setAssociatedObject(self, @selector(okBlock), newOkBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (alert_block_t)okBlock
{
    return objc_getAssociatedObject(self, @selector(okBlock));
}

- (void)setCancelBlock:(alert_block_t)newCancelBlock
{
    objc_setAssociatedObject(self, @selector(cancelBlock), newCancelBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (alert_block_t)cancelBlock
{
    return objc_getAssociatedObject(self, @selector(cancelBlock));
}

+ (instancetype)mBuildWithTitle:(NSString*)title msg:(NSString*)message okTitle:(NSString*)okTitle noTitle:(NSString*)noTitle cancleBlock:(alert_block_t)cancleBlock okBlock:(alert_block_t)okBlock
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:noTitle otherButtonTitles:okTitle, nil];
    alertView.okBlock = okBlock;
    alertView.cancelBlock = cancleBlock;
    alertView.delegate = alertView;
    return alertView;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        self.cancelBlock ? self.cancelBlock() : NULL;
    }else if (buttonIndex == alertView.firstOtherButtonIndex)
    {
        self.okBlock ? self.okBlock() : NULL;
    }
}

@end
