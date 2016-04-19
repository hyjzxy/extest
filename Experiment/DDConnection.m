//
//  IYiMing
//
//  Created by lee on 14/12/2.
//  Copyright (c) 2014年 lee. All rights reserved.
//

#import "DDConnection.h"
#import "SVProgressHUD.h"
//#import "LoginViewController.h"
#import "NSObject+NULLJudge.h"
@implementation DDConnection

+ (void)upDateUserHeadImageWithTimestamp:(NSString *)timestamp UserImage:(UIImage *)image WithFinishBlock:(void (^)(NSDictionary *, BOOL))finish{
    
    [SVProgressHUD showWithStatus:@"修改中..." maskType:SVProgressHUDMaskTypeClear];
    DDRequest *requestM = [DDRequest request];
    requestM.headImage = image;
    void(^failBlock)(void) = ^() {
        finish(@{@"memo": @"网速不给力"}, NO);
        [SVProgressHUD showErrorWithStatus:@"网速不给力"];
    };
    __weak ASIHTTPRequest *request = [requestM updateHeadImageBuildRequest];
//    [request setAuthenticationScheme:@"https"];//设置验证方式
//    [request setValidatesSecureCertificate:NO];//设置验证证书
    NSLog(@"StatusCode------%d", request.responseStatusCode);
//    [request.requestHeaders setObject:[DDUser sharedUser].JSESSIONID forKey:@"Set-Cookie"];
    [request setCompletionBlock:^{
        NSError *error = nil;
        if (!request.responseData) {
            failBlock();
            return;
        }
        id JSON = [NSJSONSerialization JSONObjectWithData:request.responseData
                                                  options:NSJSONReadingAllowFragments
                                                    error:&error];
        NSLog(@"JSON--------%@", JSON);
        if (JSON) {
//            if ([JSON isKindOfClass:[NSDictionary class]]) {
//                int state = [JSON[@"status"] isEqualToString:@"000"];
//                if (state) {
//                    finish(@{@"json": JSON}, YES);
//                [SVProgressHUD showSuccessWithStatus:JSON[@"memo"]];
//                }else {
//                    NSString * msg = [NSObject isNullWithObject:JSON[@"memo"]] ? @"网速不给力" : JSON[@"memo"];
//                    [SVProgressHUD showErrorWithStatus:msg];
//                    finish(@{@"memo": msg}, NO);
//                }
//                
//            }
        }else {
            failBlock();
        }
        [SVProgressHUD dismiss];
        
    }];
    [request setFailedBlock:failBlock];
    [request startAsynchronous];

}

@end

