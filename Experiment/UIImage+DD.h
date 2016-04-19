//
//  UIImage+DD.h
//  DDMessage
//
//  Created by ricky on 13-9-7.
//  Copyright (c) 2013年 ricky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DD)

- (UIImage *)resizedImageWithSize:(CGSize)size;
- (UIImage *)resizedImageWithMaxHeight:(CGFloat)height maxWidth:(CGFloat)width;
+ (UIImage *)createImageWithColor:(UIColor *)color;
+ (UIImage *)createImageWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
+ (UIImage *)rotateImage:(UIImage *)aImage;

@end
