//
//  NetManager.h
//  RongYi
//
//  Created by wen yu on 13-5-23.
//  Copyright (c) 2013年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyGTMBase64.h"
#define kPostKey @"cutefish_fortune"
#define kPostValue @"22489F54FAD97DC6241FD9C4268C1BD59E97A27B207D2B53"

@interface NetManager : NSObject

+ (id)sharedManager;

+ (BOOL)isNetHost:(NSString*)host;
+ (BOOL)isNetAlive;

-(void)myRequestParam:(NSMutableDictionary *)param withUrl:(NSString *)url withType:(NSString *)type
              success:(void (^)(id responseObject))success
              failure:(void (^)(id errorString))failure;

//-(void)updateimage:(NSMutableDictionary *)param
//           withUrl:(NSString *)url
//          withType:(NSString *)type
//           success:(void (^)(id responseObject))success
//           failure:(void (^)(id errorString))failure;

- (void)uploadImage:(UIImage *)sendImage
            success:(void (^)(id responseObject))success
            failure:(void (^)(id errorString))failure;

@end
