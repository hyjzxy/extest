//
//  UIScreen+Common.h
//  Les
//
//  Created by 朱 亮亮 on 14-9-3.
//  Copyright (c) 2014年 朱 亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *	@brief	新浪微博好友类型
 */
typedef enum {
	UIScreenSizeType_640x960,    /**< 屏幕尺寸640x960 */
	UIScreenSizeType_640x1136    /**< 屏幕尺寸640x1136 */
}UIScreenSizeType;

@interface UIScreen (Common)

/**
 *  当前屏幕尺寸
 *
 *  @return 屏幕尺寸类型
 */
+ (UIScreenSizeType)currentScreenSizeType;

@end
