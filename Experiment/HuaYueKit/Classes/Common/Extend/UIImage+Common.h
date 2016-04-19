//
//  UIImage+Common.h
//  Les
//
//  Created by 朱 亮亮 on 14-9-19.
//  Copyright (c) 2014年 朱 亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Common)

- (UIImage *)cropImageWithBounds:(CGRect)bounds;

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

- (UIImage *)resizedImage:(CGSize)newSize 
     interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;
- (CGAffineTransform)transformForOrientation:(CGSize)newSize;

-(CGSize) getRealSizeInSizeRrange:(CGSize)size;

@end
