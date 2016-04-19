//
//  UIScreen+Common.m
//  Les
//
//  Created by 朱 亮亮 on 14-9-3.
//  Copyright (c) 2014年 朱 亮亮. All rights reserved.
//

#import "UIScreen+Common.h"

@implementation UIScreen (Common)

+ (UIScreenSizeType)currentScreenSizeType
{
    if (CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size)) {
        return UIScreenSizeType_640x960;
    } 
    else {
        return UIScreenSizeType_640x1136;
    }
}

@end
