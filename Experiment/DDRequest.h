//
//  IYiMing
//
//  Created by lee on 14/12/2.
//  Copyright (c) 2014年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <ASIHTTPRequest/ASIHTTPRequest.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
//#import "IMAppDelegate.h"

//#define HOST @"https://115.29.248.18"
#define HOST @"https://115.29.239.176"
#define APP_URL  @"http://itunes.apple.com/lookup" //app store版本
#define APPLE_ID                        @"835731618"                                    //apple id
#define LOGIN_URL                       HOST@"/rest"                       //登录
#define APPSTOREURL @"http://a.app.qq.com/o/simple.jsp?pkgname=com.shiyanzhushou.app&g_f=991653"
//@"https://itunes.apple.com/us/app/shi-yan-zhu-shou/id979792470"
//#updateHeadImageURL                    @""

@interface DDRequest : NSObject

@property (nonatomic, assign) NSInteger clubId;
@property (nonatomic, strong) NSMutableDictionary *urlDic;
@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) UIImage *headImage;
+ (id)request;
- (ASIHTTPRequest*)buildRequest;

- (NSString *)urlStringWithBaseUrl:(NSString *)url data:(NSDictionary *)dic;

/**
 *  將url參數按字母大小進行排序，再進行md5加密
 *
 *  @param dic url參數字典
 */
- (NSString *)encodeMD5WithDictionary:(NSDictionary *)dic;

- (ASIHTTPRequest *)getCodebuildRequest;
- (ASIHTTPRequest *)RegisterBuildRequest;
- (ASIHTTPRequest *)loginBuildRequest;
- (ASIHTTPRequest *)changePassWorldBuildRequest;
- (ASIHTTPRequest *)loginOutBuildRequest;

- (ASIHTTPRequest *)toBuildRequest;
- (ASIHTTPRequest *)updateHeadImageBuildRequest;
- (ASIHTTPRequest *)getImageRequest;

@end
