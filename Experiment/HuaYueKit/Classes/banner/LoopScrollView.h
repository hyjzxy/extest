//
//  LoopScrollView.h
//  TestApplication
//
//  Created by 潘鸿吉 on 13-8-2.
//  Copyright (c) 2013年 潘鸿吉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPageControl.h"
#import "CacheImageView.h"

@class LoopScrollView;

@protocol LoopScrollViewDelegate <NSObject>

@optional
- (void) loopScrollView : (LoopScrollView*) loopScrollView didSelectIndex : (NSInteger) index didSelectImage : (UIImage*) image;

@end

@interface LoopScrollView : UIView <UIScrollViewDelegate>
{
    MyPageControl   *pc;
    UIScrollView    *myScrollView;
    
    CacheImageView *firstView;
    CacheImageView *secondView;
    CacheImageView *thirdView;
    
    NSArray         *imageArray;
    NSMutableArray  *showArray;
    
    int             showIndex1;
    int             showIndex2;
    int             showIndex3;

    NSTimer         *myTimer;
    
//    BOOL            isLoop;
    
    BOOL            isScrollView;
    block callBack;
    
}
@property (nonatomic , assign) BOOL            loop;
@property (nonatomic , retain) id <LoopScrollViewDelegate> delegate;
//- (id)initWithFrame:(CGRect)frame isLoop : (BOOL) _isLoop;
-(void)imageClick:(block)back;
- (void) setImageArray : (NSArray*) _imageArray;
#pragma mark - timer
- (void) timerStart : (float) duration;
- (void) timerEnd;

#pragma mark - scrollView setting
- (void) setContentOffset : (CGPoint) point;
- (void) setContentOffset : (CGPoint) point animated : (BOOL) animated;
- (void) setBackgroundColor : (UIColor*) color;
- (void) setHidden : (BOOL) hidden;
- (void) setScrollEnabled : (BOOL) enabled;
- (void) setScrollsToTop : (BOOL) top;
- (void) setUserInteractionEnabled : (BOOL) enabled;

#pragma mark - pageControl setting
- (void) setPageControlHidden : (BOOL) hidden;
- (void) setPageControlOffset : (CGPoint) offset;
- (void) setPageControlCurrentPage : (NSInteger) index;
- (void) setPageControlNumberOfPages : (NSInteger) pages;
- (void) setPageControlCurrentImage : (UIImage*) currentImage;
- (void) setPageControlDefaultImage : (UIImage*) defaultImage;
@end
