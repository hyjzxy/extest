//
//  ChartMessage.h
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//
typedef enum {
  
    kMessageFrom=0,
    kMessageTo
 
}ChartMessageType;

typedef NS_ENUM(NSInteger, MessageContentType)
{
    /** 文字*/
    MessageType_Content = 0,
    /** 图片*/
    MessageType_Image = 1
};

#import <Foundation/Foundation.h>

@interface ChartMessage : NSObject
@property (nonatomic,assign) ChartMessageType messageType;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) MessageContentType contentType;
@property (nonatomic, copy) NSString *imgUrl;

@end
