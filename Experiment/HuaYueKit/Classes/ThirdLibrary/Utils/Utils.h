//
//  Utils.h
//  TestApplication
//
//  Created by 潘鸿吉 on 13-4-22.
//  Copyright (c) 2013年 潘鸿吉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>
#import "UIView+bottomPosition.h"
#import "UITextField+fontSizeUp.h"
#import "UILabel+fontSizeUp.h"

@interface Utils : NSObject
{
    
}

+ (CGRect)screenRect;

+ (float)nextHeight:(id)sender;

+ (NSString*)base64forData:(NSData*)theData;


+ (BOOL)isEmptyString:(NSString*)testString;

//app bundle id
+ (NSString*)appIdentifier;
//bundle目录
+ (NSString *)bundlePath:(NSString *)fileName;
//document目录
+ (NSString *)documentsPath:(NSString *)fileName;
//临时目录
+ (NSString *)tempPath:(NSString *)fileName;
//系统版本
+ (NSString*)systemVersion;
//平台类型
+ (NSString*)platformString;

+ (NSString*)getDeviceModel;

+ (BOOL)isIphone5;

+ (NSString*)getTimeForNow;

+ (UIImage*)getImageFromProject:(NSString*)path;

+ (UIFont*)getTitleFontWithSize:(float) _size;

//+(void)drawAlertBackGroundImage:(UIAlertView *)alert backGroundImageName:(NSString*) imageName;
//判断string是否是邮箱
+ (BOOL)validateEmail:(NSString*)candidate;
//判断string是否是手机
+ (BOOL)validatePhone: (NSString *) candidate ;

+ (NSString *)isBlankString:(NSString *)string;

+ (NSString*) getEncodingWithGBK : (NSString*) _str;

#pragma mark 获取中文字符串转码utf8
+ (NSString*) getEncodingWithUTF8:(NSString *)_str;

@end
