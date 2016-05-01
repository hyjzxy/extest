//
//  UIView+Common.m
//  BlueMobiProject
//
//  Created by 朱 亮亮 on 14-4-28.
//  Copyright (c) 2014年 朱 亮亮. All rights reserved.
//

#import "UIView+Common.h"
#import <objc/runtime.h>

static char *viewClickKey;

@implementation UIView (Common)

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)removeAllSubviews
{
	while (self.subviews.count)
    {
		UIView *child = self.subviews.lastObject;
		[child removeFromSuperview];
	}
}

-(void)makeRoundCorner
{
    [self makeRoundCornerWithRadius:4];
}

-(void)makeRoundCornerWithRadius:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.shouldRasterize = YES;
    self.layer.masksToBounds = YES;
    
}

-(void)becomeRound
{
    self.layer.cornerRadius = MIN(self.width,self.height)/2;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.shouldRasterize = YES;
    self.layer.masksToBounds = YES;
    //    self.layer.borderColor = [UIColor whiteColor].CGColor;
    //    self.layer.borderWidth = 2;
}


- (void)handleClick:(UIViewClickHandle)handle {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick)];
    [self addGestureRecognizer:tap];
    objc_setAssociatedObject(self, &viewClickKey, handle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


-(void)viewClick {
    UIViewClickHandle callBack = objc_getAssociatedObject(self, &viewClickKey);
    if (callBack!= nil)
    {
        callBack(self);
    }
}


@end
