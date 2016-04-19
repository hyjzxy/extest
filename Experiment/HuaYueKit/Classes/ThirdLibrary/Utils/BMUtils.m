//
//  BMUtils.m
//  XinCaiFu
//
//  Created by Heidi on 13-8-22.
//  Copyright (c) 2013年 bluemobi. All rights reserved.
//

#import "BMUtils.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#include <QuartzCore/QuartzCore.h>
#import "DesEncrypt.h"
#import "MZToast.h"
#import "MZTip.h"
#import "SVProgressHUD.h"

@implementation BMUtils

+ (CGRect)screenRect
{
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    if (![UIApplication sharedApplication].statusBarHidden) {
        rect.origin.y -= 20;
    }
    return rect;
}

+ (NSString*)appIdentifier
{
    return [[NSBundle mainBundle] bundleIdentifier];
}

+ (NSString *)bundlePath:(NSString *)fileName
{
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
}

+ (NSString *)documentsPath:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
//    NSFileManager * fileManager = [NSFileManager defaultManager];
//    if ([fileManager fileExistsAtPath:filePath]) {
        return filePath;
//    }
//    return @"";
}

+ (NSString *)tempPath:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"temp"];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

+ (NSString *)getDeviceModel
{
    struct utsname u;
    uname(&u);
    NSString *modelVersion = [NSString stringWithFormat:@"%s", u.machine];
    return modelVersion;
}

+ (NSString*)systemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString*)platformString
{
    // Gets a string with the device model
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"])    return@"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"])    return@"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return@"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return@"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return@"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return@"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    return@"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return@"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])    return@"iPhone 5 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPod1,1"])      return@"iPod Touch (1 Gen)";
    if ([platform isEqualToString:@"iPod2,1"])      return@"iPod Touch (2 Gen)";
    if ([platform isEqualToString:@"iPod3,1"])      return@"iPod Touch (3 Gen)";
    if ([platform isEqualToString:@"iPod4,1"])      return@"iPod Touch (4 Gen)";
    if ([platform isEqualToString:@"iPod5,1"])      return@"iPod Touch (5 Gen)";
    
    if ([platform isEqualToString:@"iPad1,1"])      return@"iPad";
    if ([platform isEqualToString:@"iPad1,2"])      return@"iPad 3G";
    if ([platform isEqualToString:@"iPad2,1"])      return@"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return@"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])      return@"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return@"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])      return@"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return@"iPad Mini";
    if ([platform isEqualToString:@"iPad2,7"])      return@"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return@"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return@"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return@"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])      return@"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return@"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])      return@"iPad 4 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"i386"])         return@"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return@"Simulator";
    
    return platform;
}

#pragma mark -UILabel参数设定
+ (void)initWihtLabel:(UILabel *)label color:(UIColor *)color fontSize:(float)size line:(int)line alignment:(NSTextAlignment)alignment
{
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = alignment;
    label.textColor = color;
    label.numberOfLines = line;
    [label setFont:[UIFont systemFontOfSize:size]];
}

#pragma mark -设置UITextField属性
+ (void)initWithTextField:(UITextField *)textField placeholder:(NSString *)placeholder horizontalAlignment:(UIControlContentHorizontalAlignment) horizontalAlignment verticalAlignment:(UIControlContentVerticalAlignment)verticalAlignment fontSzie:(float)fontSize textColor:(UIColor *)color
{
    textField.textColor = color;
    [textField setFont:[UIFont systemFontOfSize:fontSize]];
    textField.backgroundColor = [UIColor clearColor];
    textField.placeholder = placeholder;
    textField.returnKeyType = UIReturnKeyDone;
    textField.contentHorizontalAlignment = horizontalAlignment;
    textField.contentVerticalAlignment = verticalAlignment;
}
//时间
+(NSString *)getDateStringByStringOld:(NSString*)time
{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [dateFormatter setDateFormat:@"HH:mm:ss"];//2012-11-26 00:00:00
        NSString*stingt = [NSString stringWithFormat:@"%@",time];
        if (stingt.length<10) {
            return time;
        }
        stingt = [stingt substringToIndex:10];
        NSDate *theday = [NSDate dateWithTimeIntervalSince1970:[stingt longLongValue]];
        return  [dateFormatter stringFromDate:theday];
}

+(NSString *)getDateByStringOld:(NSString*)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setDateFormat:@"MM/dd"];//2012-11-26 00:00:00
    NSString*stingt = [NSString stringWithFormat:@"%@",time];
    stingt = [stingt substringToIndex:10];
    
    NSDate *theday = [NSDate dateWithTimeIntervalSince1970:[stingt longLongValue]];
    NSString * dateStr = [dateFormatter stringFromDate:theday];
    NSArray *array = [dateStr componentsSeparatedByString:@"/"];
    dateStr = [NSString stringWithFormat:@"%@月%@日", array[0], array[1]];
    return dateStr;
    
}
+(NSString *)getFullDateByStringOld:(NSString *)time{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];//2012-11-26 00:00:00
    NSString*stingt = [NSString stringWithFormat:@"%@",time];
//    stingt = [stingt substringToIndex:10];
    
    NSDate *theday = [NSDate dateWithTimeIntervalSince1970:[stingt longLongValue]];
    NSString * dateStr = [dateFormatter stringFromDate:theday];
    NSArray *array = [dateStr componentsSeparatedByString:@"-"];
    dateStr = [NSString stringWithFormat:@"%@年%@月%@日", array[0], array[1], array[2]];
    return dateStr;
}

#pragma mark UIAlert
+ (void)addAlert:(NSString*)alertTitle AlertMessage:(NSString*)alertMessage
{
    [[MZTip shared]showWithTitle:@"提示" msg:alertMessage];
   /* if ([[NSThread currentThread]isMainThread]) {
         [[MZToast shared]makeWithText:alertTitle detail:alertMessage duration:mzShort];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[MZToast shared]makeWithText:alertTitle detail:alertMessage duration:mzShort]; 
        });
    }*/
}

+ (void)showSuccess:(NSString*)message
{
    if ([NSThread isMainThread]) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:message];
    } else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:message];
        });
    }
}

+ (void)showError:(NSString*)message
{
    if ([NSThread isMainThread]) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:message];
    } else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:message];
        });
    }
}

+ (NSString *)getHTMLChangge:(NSString *)htmlStr
{
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:htmlStr];
    
    while ([theScanner isAtEnd] == NO)
    {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        htmlStr = [htmlStr stringByReplacingOccurrencesOfString:
                   [NSString stringWithFormat:@"%@>", text]
                                                     withString:@" "];
    }
    
    return htmlStr;
}

+ (NSString*) getEncodingWithUTF8 : (NSString*) str
{
    NSString *tempStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return tempStr;
}

+ (NSString*)getPercentEscapesWithUTF8:(NSString *)str{
    NSString *tempStr = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return tempStr;
}

#pragma mark - 验证邮箱是否正确的方法
+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isYES = [emailTest evaluateWithObject:email];
    return isYES;
}

+(BOOL)validateEmail:(NSString*)email
{
    if((0 != [email rangeOfString:@"@"].length) &&
       (0 != [email rangeOfString:@"."].length))
    {
        
        NSCharacterSet* tmpInvalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        NSMutableCharacterSet* tmpInvalidMutableCharSet = [[tmpInvalidCharSet mutableCopy] autorelease];
        [tmpInvalidMutableCharSet removeCharactersInString:@"_-"];
        
        //使用compare option 来设定比较规则，如
        //NSCaseInsensitiveSearch是不区分大小写
        //NSLiteralSearch 进行完全比较,区分大小写
        //NSNumericSearch 只比较定符串的个数，而不比较字符串的字面值
        NSRange range1 = [email rangeOfString:@"@"
                                      options:NSCaseInsensitiveSearch];
        
        //取得用户名部分
        NSString* userNameString = [email substringToIndex:range1.location];
        NSArray* userNameArray   = [userNameString componentsSeparatedByString:@"."];
        
        for(NSString* string in userNameArray)
        {
            NSRange rangeOfInavlidChars = [string rangeOfCharacterFromSet: tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length != 0 || [string isEqualToString:@""])
                return NO;
        }
        
        NSString *domainString = [email substringFromIndex:range1.location+1];
        NSArray *domainArray   = [domainString componentsSeparatedByString:@"."];
        
        for(NSString *string in domainArray)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        
        return YES;
    }
    else // no ''@'' or ''.'' present
        return NO;
}


+ (void)hiddenLabel:(UIView *)view
{
    UILabel *l = (UILabel *)[view viewWithTag:6789];
    [l removeFromSuperview];
}
#pragma mark UIAlert  正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,183,187,188,152,147
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[0127-9]|8[2378]|47[0-8])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[156])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


+(NSString *)getDesValueWithUrlModule:(NSString*)module withUrlAction:(NSString *)action{
    NSString *nowTime = [DesEncrypt getStringFromDate:[NSDate dateWithTimeIntervalSinceNow:0] withFormat:@"yyyy-MM-dd-HH"];
    NSString *desStr = [NSString stringWithFormat:@"%@%@%@",module,action,nowTime];
    return desStr;
    
}

+(NSString *)getDesValueWithUrlStr:(NSString*)urlStr{
    NSString *randomStr = [NSString stringWithFormat:@"%d",[DesEncrypt getRandomNumber:10000000 to:100000000]];
    NSString *nowTime = [DesEncrypt getStringFromDate:[NSDate dateWithTimeIntervalSinceNow:0] withFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *desStr = [NSString stringWithFormat:@"%@,%@,%@",randomStr,nowTime,urlStr];
    return desStr;
}

@end
