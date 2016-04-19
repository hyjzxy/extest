//
//  BMUtils.h
//  XinCaiFu
//
//  Created by Heidi on 13-8-22.
//  Copyright (c) 2013年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>

@interface BMUtils : NSObject
{
    
}
//screen size
+ (CGRect)screenRect;
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
//版本号
+ (NSString *)getDeviceModel;
//Label设置
+ (void)initWihtLabel:(UILabel *)label color:(UIColor *)color fontSize:(float)size line:(int)line alignment:(NSTextAlignment)alignment;
//UITextField设置
+ (void)initWithTextField:(UITextField *)textField placeholder:(NSString *)placeholder horizontalAlignment:(UIControlContentHorizontalAlignment) horizontalAlignment verticalAlignment:(UIControlContentVerticalAlignment)verticalAlignment fontSzie:(float)fontSize textColor:(UIColor *)color;
//提示框
+ (void)addAlert:(NSString*)alertTitle AlertMessage:(NSString*)alertMessage;
+ (void)showSuccess:(NSString*)message;
+ (void)showError:(NSString*)message;
+ (NSString *)getHTMLChangge:(NSString *)_str;

+ (NSString*) getEncodingWithUTF8 : (NSString*) str;
+ (NSString*)getPercentEscapesWithUTF8:(NSString *)str;

+ (BOOL)isValidateEmail:(NSString *)email;
+ (BOOL)validateEmail:(NSString*)email;

+(NSString *)getDateStringByStringOld:(NSString*)time;
+(NSString *)getDateByStringOld:(NSString*)time;
+(NSString *)getFullDateByStringOld:(NSString*)time;
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+ (NSString *)getDesValueWithUrlStr:(NSString*)urlStr;

+(NSString *)getDesValueWithUrlModule:(NSString*)module withUrlAction:(NSString *)action;


@end
