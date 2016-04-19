//
//  UIImage+MJ.m
//  新浪微博
//
//  Created by apple on 13-10-26.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "UIImage+MJ.h"

@implementation UIImage (MJ)
#pragma mark 加载全屏的图片
// new_feature_1.png
+ (UIImage *)fullscrennImage:(NSString *)imgName
{
    // 1.如果是iPhone5，对文件名特殊处理
//    if (IS_IPHONE_5) {
//        // 1.1.获得文件拓展名
//        NSString *ext = [imgName pathExtension];
//        
//        // 1.2.删除最后面的扩展名
//        imgName = [imgName stringByDeletingPathExtension];
//        
//        // 1.3.拼接-568h@2x
//        imgName = [imgName stringByAppendingString:@"-568h@2x"];
//        
//        // 1.4.拼接扩展名
//        imgName = [imgName stringByAppendingPathExtension:ext];
//    }
    
    // 2.加载图片
    return [self imageNamed:imgName];
}
@end
