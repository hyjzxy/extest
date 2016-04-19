//
//  IYiMing
//
//  Created by lee on 14/12/2.
//  Copyright (c) 2014年 lee. All rights reserved.
//

//#import <ASIHTTPRequest/ASIFormDataRequest.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "UIImage+DD.h"
#import "DDRequest.h"


#define CODE_DEFAULT @"uTwM6"
#define IS_CH_SYMBOL(chr) ((int)(chr)>127)

@implementation DDRequest

- (void)dealloc
{
    self.urlDic = nil;
}

+ (id)request
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.urlDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (ASIHTTPRequest*)buildRequest
{
    return [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", HOST]]];  // Override point
}

- (NSString *)urlStringWithBaseUrl:(NSString *)url data:(NSDictionary *)dic {
    NSMutableArray *valueArray = [[NSMutableArray alloc] init];
    for (NSString *key in [dic allKeys]) {
        NSString *value = @"";
        if ([dic[key] isKindOfClass:[NSString class]]) {
            //字符串進行utf8轉換
            value = [dic[key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        NSString *string = [NSString stringWithFormat:@"%@=%@",key,value.length ? value : dic[key]];
        [valueArray addObject:string];
    }
    
    NSString *urlValue = [valueArray componentsJoinedByString:@"&"];
    NSString *urlString = [NSString stringWithFormat:@"%@?%@",url,urlValue];
//    NSLog(@"%@", urlString);
    return urlString;
}



- (ASIHTTPRequest *)updateHeadImageBuildRequest{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:LOGIN_URL]];
//    [request addRequestHeader:@"ua" value:@"method"]

//    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
//    [tempDic setValue:@"iyiming_zeus" forKey:@"app_secret"];
//    [tempDic setValue:@"ua" forKey:@"method"];
////    [tempDic setValue:timeString forKey:@"timestamp"];
//    NSString *key = [self encodeMD5WithDictionary:tempDic];
//    NSLog(@"%@", key);
//    [request addPostValue:@"ua" forKey:@"method"];
//    [request addPostValue:key forKey:@"sign"];
    
    [request addRequestHeader:@"Content-Disposition" value:@"Content-Disposition"];
        [request addData:UIImageJPEGRepresentation([self.headImage resizedImageWithMaxHeight:200 maxWidth:200], 0.8)
        withFileName:@"avatar.jpg"
      andContentType:@"image/jpeg"
              forKey:@"avatar"];

    return request;
}
//- (ASIHTTPRequest *)getImageRequest{
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",GETPICURL,[DDUser sharedUser].imageUrl]]];
//    
//    return request;
//}
@end
