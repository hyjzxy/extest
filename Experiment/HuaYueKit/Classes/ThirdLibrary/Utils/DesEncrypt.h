//
//  DesEncrypt.h
//  Encryption
//
//  Created by super man on 14-6-24.
//  Copyright (c) 2014年 zhoumin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import"MyGTMBase64.h"
#import<CommonCrypto/CommonCryptor.h>
@interface DesEncrypt : NSObject
// 生成随机数
+(int)getRandomNumber:(int)from to:(int)to;
// 获取当前时间
+(NSString*)getStringFromDate:(NSDate*)date withFormat:(NSString*)formatString;
+ (NSString *)encryptWithText:(NSString *)sText;//加密
+ (NSString *)decryptWithText:(NSString *)sText;//解密
+ (NSString *)md5:(NSString *)str;
@end
