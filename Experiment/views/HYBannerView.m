//
//  HYBannerView.m
//  HuaYue
//
//  Created by 崔俊红 on 15-3-29.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "HYBannerView.h"
#import "UIButton+WebCache.h"
#import "NetManager.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "Masonry.h"

@interface HYBannerView ()<UIScrollViewDelegate>
@property (nonatomic, strong)dispatch_source_t timer;
@end

@implementation HYBannerView
{
    __block BOOL directRight;
    __block NSInteger currIndex;
    BOOL autoScroll;
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    
    NSArray *banners;
    UIView *maskView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self mBuildUI:frame];
    }
    return self;
}

/**
 *  @author 崔俊红, 15-03-30 19:03:08
 *
 *  @brief  UI组件初始化
 *
 *  @param frame 组件大小CGRect
 *
 *  @since v1.0
 */
- (void)mBuildUI:(CGRect)frame
{
    scrollView = [[UIScrollView alloc]initWithFrame:frame];
    scrollView.pagingEnabled = YES;
    scrollView.directionalLockEnabled = YES;
    scrollView.bounces = NO;
    scrollView.scrollEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.userInteractionEnabled = NO;
    pageControl = [[UIPageControl alloc]initWithFrame:Rect(FMinX(frame), FMaxY(frame), FWidth(frame), 10.0)];
    pageControl.hidesForSinglePage = YES;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.userInteractionEnabled = NO;
    maskView = [[UIView alloc]initWithFrame:scrollView.frame];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0;
    CGRectExtBottom(self, 10.0);
    [self mAddSubViews:@[scrollView,pageControl,maskView]];
    self.timer =dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, 1ull*NSEC_PER_SEC), 4ull*NSEC_PER_SEC, 0ull*NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        CGFloat offsetX = currIndex * VWidth(scrollView);
        pageControl.currentPage = currIndex;
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [scrollView setContentOffset:Point(offsetX, 0)];
        } completion:^(BOOL finished) {
            maskView.alpha = 0.05;
            maskView.transform = CGAffineTransformMakeScale(1, 1);
            [UIView animateWithDuration:0.5f delay:0.1f options:UIViewAnimationOptionCurveLinear animations:^{
                maskView.alpha = 0.0f;
                maskView.transform = CGAffineTransformMakeScale(0.0001f,1);
            } completion:nil];
        }];
        directRight?currIndex++:currIndex--;
        [self resetIndex];
    });
    dispatch_resume(_timer);
}

/**
 *  @author 崔俊红, 15-03-30 19:03:51
 *
 *  @brief  自动切换控制
 *
 *  @since v1.0
 */
- (void)resetIndex
{
    if (currIndex>=banners.count-1) {
        directRight = NO;
        currIndex = banners.count - 1;
    }
    if (currIndex<=0) {
        directRight = YES;
        currIndex = 0;
    }
}

/**
 *  @author 崔俊红, 15-03-30 19:03:08
 *
 *  @brief  加载数据
 *
 *  @since v1.0
 */
- (void)reloadData
{
    if (_dataSource!=nil && [_dataSource respondsToSelector:@selector(bannerDatas)]) {
        banners = [_dataSource bannerDatas];
        if (banners!=nil && banners.count>0) {
            scrollView.userInteractionEnabled = YES;
            currIndex = 0;
            directRight = YES;
            autoScroll = YES;
            NSInteger index = 0;
            for (NSDictionary *dic in banners) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectOffset(scrollView.frame, VWidth(scrollView)*index, 0);
                UIImageView *imgV = [[UIImageView alloc]init];
                [imgV setImageWithURL:IMG_URL([dic objectForKey:@"image"]) usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [btn addSubview:imgV];
                [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(btn);
                }];
                if (self.delegate && [self.delegate respondsToSelector:@selector(buildImageView:index:)]) {
                    [self.delegate buildImageView:imgV index:index];
                }
                btn.tag = index++;
                [btn addTarget:self action:@selector(onClickAct:) forControlEvents:UIControlEventTouchUpInside];
                [scrollView addSubview:btn];
            }
            scrollView.contentSize = Size(VWidth(scrollView)*index,0);
            pageControl.numberOfPages = banners.count;
        }
    }
}

/**
 *  @author 崔俊红, 15-03-30 19:03:18
 *
 *  @brief  点击广告
 *
 *  @param sender UIButton
 *
 *  @since v1.0
 */
- (void)onClickAct:(id)sender
{
    if (_delegate) {
        [_delegate bannerView:self selectedData:((UIView*)sender).tag];
    }
}

#pragma mark - UIScrollViewDelegate
/**
 *  @author 崔俊红, 15-03-30 19:03:41
 *
 *  @brief  滚动开始事件
 *
 *  @param scrollView UIScrollView
 *
 *  @since v1.0
 */
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    autoScroll = NO;
    dispatch_suspend(_timer);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        autoScroll = YES;
        dispatch_resume(_timer);
    });
}
/**
 *  @author 崔俊红, 15-03-30 19:03:59
 *
 *  @brief  滚动结束
 *
 *  @param sv UIScrollView
 *
 *  @since v1.0
 */
- (void)scrollViewDidScroll:(UIScrollView *)sv
{
    if (!autoScroll) {
        currIndex = sv.contentOffset.x/VWidth(sv);
        pageControl.currentPage = currIndex;
        [self resetIndex];
    }
}

/**
 *  @author 崔俊红, 15-03-30 19:03:16
 *
 *  @brief  释放定时期占用内存
 *
 *  @since v1.0
 */
- (void)dealloc
{
    if (_timer && dispatch_source_testcancel(_timer)!=0) {
        dispatch_source_cancel(_timer);
        self.timer = nil;
    }
}

- (void)mCancel
{
    if (_timer) {
   //     dispatch_suspend(_timer);
    }
}
@end
