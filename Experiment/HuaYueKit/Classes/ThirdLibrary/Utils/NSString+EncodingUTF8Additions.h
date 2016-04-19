//
//  NSString+EncodingUTF8Additions.h
//  LokiProject
//
//  Created by loki on 13-11-7.
//  Copyright (c) 2013年 loki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (EncodingUTF8Additions)

-(NSString *) URLEncodingUTF8String;//编码
-(NSString *) URLDecodingUTF8String;//解码

@end
