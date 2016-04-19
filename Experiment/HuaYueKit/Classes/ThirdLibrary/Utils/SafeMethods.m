//
//  SafeMethods.m
//  HanDuYiShe
//
//  Created by David Lee on 13-10-17.
//  Copyright (c) 2013年 David Lee. All rights reserved.
//

#import "SafeMethods.h"

@implementation NSArray (safe)
- (id)objectAtIndexSafe:(NSUInteger)index
{
    if ([self isKindOfClass:[NSArray class]]) {
        if (index < self.count) {
            return [self objectAtIndex:index];
        }
    }
    return nil;
}
@end

@implementation NSObject (safe)
// !!!: 加上注释和导航
- (void)releaseSafe
{
    [self release];
    self = nil;
}

- (id)objectFromCache:(NSString *)cacheName
{
    NSString *cachePath = [self cachePathWithName:cacheName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self cachePathWithName:cacheName]]) {
        NSData *data = [NSData dataWithContentsOfFile:cachePath];
        id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return obj;
    }
    return nil;
}

- (BOOL)saveToCache:(NSString *)cacheName
{
    if ([self conformsToProtocol:@protocol(NSCoding)]) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
        BOOL ok = [data writeToFile:[self cachePathWithName:cacheName] atomically:NO];
        return ok;
    } else {
        NSLog(@"%@ CAN NOT BE SAVE, Coding Error!", cacheName);
        return NO;
    }
}

+ (BOOL)clearCacheWithName:(NSString *)cacheName
{
    NSString *cachePath = [self cachePathWithName:cacheName];
    NSError *error = nil;
    BOOL ok = [[NSFileManager defaultManager] removeItemAtPath:cachePath error:&error];
    if (!error) {
        NSLog(@"%@", error);
    }
    return ok;
}

- (NSString *)cachePathWithName:(NSString *)cacheName
{
    // 目录列表
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    // 根目录
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/%@", documentsDirectory, cacheName];
    return path;
}
@end



@implementation UIView (safe)

- (void)setOriginX:(int)originX
{
    CGRect frame = self.frame;
    frame.origin.x = originX;
    self.frame = frame;
}

- (void)setOriginY:(int)originY
{
    CGRect frame = self.frame;
    frame.origin.y = originY;
    self.frame = frame;
}

- (void)setWidth:(int)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(int)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)linearLayout
{
    CGRect lastFrame = CGRectZero;
    for (UIView *view in self.subviews) {
        CGRect frame = view.frame;
        frame.origin.y = lastFrame.origin.y;
        view.frame = frame;
        lastFrame = frame;
    }
    return CGRectGetMaxY(lastFrame);
}
@end
