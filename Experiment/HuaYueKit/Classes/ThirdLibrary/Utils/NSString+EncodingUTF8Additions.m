//
//  NSString+EncodingUTF8Additions.m
//  LokiProject
//
//  Created by loki on 13-11-7.
//  Copyright (c) 2013年 loki. All rights reserved.
//

#import "NSString+EncodingUTF8Additions.h"

@implementation NSString (EncodingUTF8Additions)

-(NSString *)URLEncodingUTF8String{
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self,
                                                                           NULL,
                                                                           CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8);
    [result autorelease];
    return result;
}
-(NSString *)URLDecodingUTF8String{
    NSString *result = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                           (CFStringRef)self,
                                                                                           CFSTR(""),
                                                                                           kCFStringEncodingUTF8);
    [result autorelease];
    return result;
}
@end