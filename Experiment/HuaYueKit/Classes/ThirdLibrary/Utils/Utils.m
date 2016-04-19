//
//  Utils.m
//  TestApplication
//
//  Created by 潘鸿吉 on 13-4-22.
//  Copyright (c) 2013年 潘鸿吉. All rights reserved.
//

#import "Utils.h"
#include <sys/types.h>
#include <sys/sysctl.h>


@implementation Utils

+ (void)showAlert:(NSString*)title msg:(NSString*)msg{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    [alertView release];
}


+ (CGRect)screenRect{
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        rect.size = CGSizeMake(rect.size.height, rect.size.width);
    }
    
//    if (![UIApplication sharedApplication].statusBarHidden) {
//        rect.origin.y -= 20;
//    }
    return rect;
}

+ (float)nextHeight:(id)sender{
    return ((UIView*)sender).frame.origin.y + ((UIView*)sender).frame.size.height;
}

+ (NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}


+ (BOOL)isEmptyString:(NSString*)testString{
    if (!testString) {
        return YES;
    }
    if ([[testString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}

+ (NSString*)appIdentifier{
    return [[NSBundle mainBundle] bundleIdentifier];
}

+ (NSString *)bundlePath:(NSString *)fileName {
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
}

+ (NSString *)documentsPath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

+ (NSString *)tempPath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"temp"];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

+ (NSString *)getDeviceModel{
    struct utsname u;
    uname(&u);
    NSString *modelVersion = [NSString stringWithFormat:@"%s", u.machine];
    return modelVersion;
}

+ (NSString*)systemVersion{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString*)platformString{
    // Gets a string with the device model
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"])return@"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"])return@"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])return@"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])return@"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])return@"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])return@"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])return@"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])return@"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])return@"iPhone 5 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPod1,1"])return@"iPod Touch (1 Gen)";
    if ([platform isEqualToString:@"iPod2,1"])return@"iPod Touch (2 Gen)";
    if ([platform isEqualToString:@"iPod3,1"])return@"iPod Touch (3 Gen)";
    if ([platform isEqualToString:@"iPod4,1"])return@"iPod Touch (4 Gen)";
    if ([platform isEqualToString:@"iPod5,1"])return@"iPod Touch (5 Gen)";
    
    if ([platform isEqualToString:@"iPad1,1"])return@"iPad";
    if ([platform isEqualToString:@"iPad1,2"])return@"iPad 3G";
    if ([platform isEqualToString:@"iPad2,1"])return@"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])return@"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])return@"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])return@"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])return@"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])return@"iPad Mini";
    if ([platform isEqualToString:@"iPad2,7"])return@"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])return@"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])return@"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])return@"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])return@"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])return@"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])return@"iPad 4 (GSM+CDMA)";

    if ([platform isEqualToString:@"i386"]) return@"Simulator";
    if ([platform isEqualToString:@"x86_64"]) return@"Simulator";

    return platform;
}

+ (BOOL) isIphone5
{
    if ([UIScreen instancesRespondToSelector:@selector(currentMode)]) {
        return CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size);
    }
    else
    {
        return NO;
    }
}

+ (NSString *) getTimeForNow
{
    NSDate * senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *timeDate = [[NSString alloc] initWithString:[dateformatter stringFromDate:senddate]];
    [dateformatter release];
    return [timeDate autorelease];
}

+ (UIImage *)getImageFromProject:(NSString *)path
{
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:path ofType:@"png"]];
}

+ (UIFont*) getTitleFontWithSize : (float) _size
{
    return [UIFont fontWithName:@"ShiShangZhongHeiJianTi" size:_size];
//    return [UIFont fontWithName:@"TRENDS" size:15.0f];
}

+(BOOL)validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

+ (BOOL)validatePhone: (NSString *) candidate {
    //验证手机号
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:candidate];
}

+ (NSString *)isBlankString:(NSString *)string{
    
    if (string == nil) {
        
        return @"";
        
    }
    
    if (string == NULL) {
        
        return @"";
        
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        
        return @"";
        
    }
    if ([string isKindOfClass:[NSDecimalNumber class]] || [string isKindOfClass:[NSNumber class]]) {
        
        return [NSString stringWithFormat:@"%@",string];
        
    }
    
    
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        
        return @"";
        
    }
    
    return string;
    
}

+ (NSString*) getEncodingWithGBK : (NSString*) _str{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [_str stringByAddingPercentEscapesUsingEncoding:enc];
}

#pragma mark 获取中文字符串转码utf8
+ (NSString*) getEncodingWithUTF8:(NSString *)_str{
    return [_str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


@end
