//
//  IYiMing
//
//  Created by lee on 14/12/2.
//  Copyright (c) 2014年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDRequest.h"

#define DEFAULT_PAGE_SIZE 5.0

@interface DDConnection : NSObject

//登录
+ (void)loginConnectionWithTimestamp:(NSString *)timestamp
                               password:(NSString *)pwd
                                username:(NSString *)usn
                               version:(NSString *)v
                           finishBlock:(void (^)(NSDictionary *json, BOOL success))finish;
//登录
+ (void)registerConnectionWithTimestamp:(NSString *)timestamp
                            password:(NSString *)pwd
                            name:(NSString *)username
                             mobile:(NSString *)mobile
                           validateCode:(NSString *)validateCode
                                   city:(NSString *)city
                         finishBlock:(void (^)(NSDictionary *json, BOOL success))finish;

+ (void)getCoderConnectionWithTimestamp:(NSString *)timestamp
                            mobile:(NSString *)mobile
                         finishBlock:(void (^)(NSDictionary *json, BOOL success))finish;
+ (void)changePassWorldConnectionWithTimestamp:(NSString *)timestamp
                                 oldPassword:(NSString *)oldPassword
                                   newPassword:(NSString *)newPassword
                                   newPassword2:(NSString *)newPassword2
                            finishBlock:(void (^)(NSDictionary *json, BOOL success))finish;

+ (void)loginOutConnectionWithTimestamp:(NSString *)timestamp
                        WithFinishBlock:(void (^)(NSDictionary *json, BOOL success))finish;

+ (void)setUpUserInfoConnectionWithTimestamp:(NSString *)timestamp
                                         sex:(NSString *)sex
                                    realName:(NSString *)realName
                                     address:(NSString *)address
                                    nickName:(NSString *)nickName
                        WithFinishBlock:(void (^)(NSDictionary *json, BOOL success))finish;

+ (void)getUserInfoConnectionWithTimestamp:(NSString *)timestamp
                             WithFinishBlock:(void (^)(NSDictionary *json, BOOL success))finish;

+ (void)getItemListConnectionWithTimestamp:(NSString *)timestamp
                                  pageSize:(NSString *)pageSize
                                    pageNo:(NSString *)pageNo
                                   country:(NSString *)country
                                    amtMin:(NSString *)amtMin
                                    amtMax:(NSString *)amtMax
                            releaseDateMin:(NSString *)releaseDateMin
                            releaseDateMax:(NSString *)releaseDateMax
                                 attention:(NSString *)attention
                                      type:(NSString *)type
                                  amtOrder:(NSString *)amtOrder
                                  dateType:(NSString *)dateType
                           WithFinishBlock:(void (^)(NSDictionary *json, BOOL success))finish;
+ (void)getItemDetailConnectionWithTimestamp:(NSString *)timestamp
                                      itemID:(NSString *)itemID
                           WithFinishBlock:(void (^)(NSDictionary *json, BOOL success))finish;

+ (void)attentionConnectionWithTimestamp:(NSString *)timestamp
                                      itemID:(NSString *)itemID
                            attentionType:(NSString *)attentionType
                             WithFinishBlock:(void (^)(NSDictionary *json, BOOL success))finish;

+(void)upDateUserHeadImageWithTimestamp:(NSString *)timestamp
                                 UserImage:(UIImage *)image
                        WithFinishBlock:(void (^)(NSDictionary *json, BOOL success))finish;
+ (void)searchItemListConnectionWithTimestamp:(NSString *)timestamp
                                  pageSize:(NSString *)pageSize
                                    pageNo:(NSString *)pageNo
                                   country:(NSString *)country
                                    amtMin:(NSString *)amtMin
                                    amtMax:(NSString *)amtMax
                            releaseDateMin:(NSString *)releaseDateMin
                            releaseDateMax:(NSString *)releaseDateMax
                                 attention:(NSString *)attention
                                      type:(NSString *)type
                                  amtOrder:(NSString *)amtOrder
                                  dateType:(NSString *)dateType
                                      name:(NSString *)ItemName
                           WithFinishBlock:(void (^)(NSDictionary *json, BOOL success))finish;

+(void)getHeadImageConnectionWithFinishBlock:(void (^)(NSDictionary *json, BOOL success))finish;

+(void)sendContentWithTimestamp:(NSString *)timestamp
                              content:(NSString *)content
                        WithFinishBlock:(void (^)(NSDictionary *json, BOOL success))finish;

+(void)getNewVersion:(NSString *)timestamp
                        type:(NSString *)type
                WithFinishBlock:(void (^)(NSDictionary *json, BOOL success))finish;

@end

