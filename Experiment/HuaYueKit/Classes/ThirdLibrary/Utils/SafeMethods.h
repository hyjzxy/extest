//
//  SafeMethods.h
//  HanDuYiShe
//
//  Created by David Lee on 13-10-17.
//  Copyright (c) 2013年 David Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (safe)
- (id)objectAtIndexSafe:(NSUInteger)index;
@end

@interface NSObject (safe)
// 注意：会将对象指针置为nil
- (void)releaseSafe;

// 缓存方法
- (id)objectFromCache:(NSString *)cacheName;
- (BOOL)saveToCache:(NSString *)cacheName;
+ (BOOL)clearCacheWithName:(NSString *)cacheName;
@end

@interface UIView (safe)
// 便捷更改frame
- (void)setOriginX:(int)originX;
- (void)setOriginY:(int)originY;
- (void)setWidth:(int)width;
- (void)setHeight:(int)height;

// 线性布局
// 注意：所有的subViews会按照顺序线性向下布局,从Y坐标0开始
// 建议放在UIScrollView里
// 不会更改本View的属性，例如UIScrollView的contentSize
// 只会更改subViews的frame的origin.y
// 返回理想页面高度
- (CGFloat)linearLayout;
@end
