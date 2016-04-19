//
//  CacheImageView.h
//  cacheView
//
//  Created by 潘鸿吉 on 13-3-12.
//  Copyright (c) 2013年 潘鸿吉. All rights reserved.
//
typedef void(^block)(void);
#import <UIKit/UIKit.h>

@protocol CacheImageViewDelegate <NSObject>

@optional
- (void) cacheImageViewDidFinishLoading : (NSURL*) _url;

@end

@interface CacheImageView : UIImageView
{
    UIActivityIndicatorView     *aiView;
    NSURLConnection             *connection;
    NSMutableData               *data;
    NSURL                       *url;
    block                       callBack;
    id <CacheImageViewDelegate> delegate;
}

@property (nonatomic , retain) id <CacheImageViewDelegate> delegate;

- (id) initWithImage : (UIImage*) _image Frame : (CGRect) _frame;
- (void) getImageFromURL : (NSURL*) _url;
- (void) saveImage;
- (NSDictionary*) getSaveDictionary;
- (void) saveDictionary : (NSMutableDictionary*) _dic;
- (NSString*) generatImageName;
- (BOOL) isHaveImage;
-(void)imageClickWithIndex:(block)db;

@end
