//
//  LoopScrollView.m
//  TestApplication
//
//  Created by 潘鸿吉 on 13-8-2.
//  Copyright (c) 2013年 潘鸿吉. All rights reserved.
//

#import "LoopScrollView.h"
@interface LoopScrollView(private)
- (void) setCurrentImage;
- (void) cacheImageViewSetImage;
@end

@implementation LoopScrollView
@synthesize loop , delegate;
-(void)dealloc
{
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        
        isScrollView = YES;
        
        showIndex1 = 0;
        showIndex2 = 0;
        showIndex3 = 0;
        
        showArray = [[NSMutableArray alloc] init];
        imageArray = [[NSArray alloc] init];
        
        CGFloat width1 = self.bounds.size.width;
        CGFloat height1 = self.bounds.size.height - 20;
        
        myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width1, height1)];
        [myScrollView setDelegate:self];
        [myScrollView setBackgroundColor:[UIColor clearColor]];
        [myScrollView setShowsHorizontalScrollIndicator:NO];
        [myScrollView setShowsVerticalScrollIndicator:NO];
        [myScrollView setBounces:NO];
        [myScrollView setPagingEnabled:YES];
        [self addSubview:myScrollView];
        
        CGFloat width = myScrollView.frame.size.width;
        CGFloat height = myScrollView.frame.size.height;
        
        firstView = [[CacheImageView alloc] initWithImage:nil Frame:CGRectMake(0, 0, width, height)];
        firstView.userInteractionEnabled=YES;
        [firstView imageClickWithIndex:^{
            callBack();
        }];
        [myScrollView addSubview:firstView];
        
        UIButton *firstButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [firstButton addTarget:self action:@selector(firstButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [myScrollView addSubview:firstButton];
        
        
        secondView = [[CacheImageView alloc] initWithImage:nil Frame:CGRectMake(width, 0, width, height)];
        secondView.userInteractionEnabled=YES;
        [secondView imageClickWithIndex:^{
            callBack();
        }];
        [myScrollView addSubview:secondView];
        
        
        UIButton *secondButton = [[UIButton alloc] initWithFrame:CGRectMake(width, 0, width, height)];
        [secondButton addTarget:self action:@selector(secondButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [myScrollView addSubview:secondButton];
        
        
        thirdView = [[CacheImageView alloc] initWithImage:nil Frame:CGRectMake(width * 2, 0, width, height)];
        thirdView.userInteractionEnabled=YES;
        [thirdView imageClickWithIndex:^{
            callBack();
        }];
        [myScrollView addSubview:thirdView];
        
        
        UIButton *thirdButton = [[UIButton alloc] initWithFrame:CGRectMake(width * 2, 0, width, height)];
        [thirdButton addTarget:self action:@selector(thirdButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [myScrollView addSubview:thirdButton];
        
        
        pc = [[MyPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - 20, frame.size.width, 20)];
        [pc setHidesForSinglePage:YES];
        pc.backgroundColor = RGBCOLOR(240, 240, 240);
        [pc setUserInteractionEnabled:NO];
        [self addSubview:pc];
        
    }
    return self;
}
-(void)imageClick:(block)back
{
    callBack=[back copy];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void) setImageArray : (NSArray*) _imageArray
{
    if (!_imageArray || _imageArray.count == 0) {
        return;
    }
    else
    {
        if (showArray) {
            [showArray removeAllObjects];
        }
        imageArray = [[NSArray alloc] initWithArray:_imageArray];
        pc.numberOfPages = [imageArray count];
        if ([imageArray count] > 2) {
            [myScrollView setContentSize:CGSizeMake(self.frame.size.width * 3, self.frame.size.height)];
            showIndex1 = 0/*[imageArray count] - 1*/;
            showIndex2 = 1;
            showIndex3 = 2;
            [showArray addObject:[imageArray objectAtIndex:showIndex1]];
            [showArray addObject:[imageArray objectAtIndex:showIndex2]];
            [showArray addObject:[imageArray objectAtIndex:showIndex3]];
            
            
            [firstView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [secondView setFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
            [thirdView setFrame:CGRectMake(self.frame.size.width * 2, 0, self.frame.size.width, self.frame.size.height)];
            
            [self cacheImageViewSetImage];
            [pc setCurrentPage:0];
            [myScrollView setScrollEnabled:YES];
            [myScrollView setContentOffset:CGPointMake(/*self.frame.size.width*/0, 0)];
        }
        else if ([imageArray count] == 2)
        {
            if (loop) {
                [myScrollView setContentSize:CGSizeMake(self.frame.size.width * 3, self.frame.size.height)];
            }
            else
            {
                [myScrollView setContentSize:CGSizeMake(self.frame.size.width * 2, self.frame.size.height)];
            }
            
            showIndex1 = 0;
            showIndex2 = 1;
            showIndex3 = 0;
            [showArray addObject:[imageArray objectAtIndex:showIndex1]];
            [showArray addObject:[imageArray objectAtIndex:showIndex2]];
            [showArray addObject:[imageArray objectAtIndex:showIndex3]];
            [self cacheImageViewSetImage];
            [myScrollView setScrollEnabled:YES];
            [myScrollView setContentOffset:CGPointMake(0/*self.frame.size.width*/, 0)];
        }
        else if ([imageArray count] == 1)
        {
            [showArray addObject:[imageArray objectAtIndex:0]];
            [showArray addObject:[imageArray objectAtIndex:0]];
            [showArray addObject:[imageArray objectAtIndex:0]];
            [self cacheImageViewSetImage];
            [myScrollView setScrollEnabled:NO];
            [myScrollView setContentSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
        }
    }
}

#pragma mark - buttonAction
- (void) firstButtonAction : (id) sender
{
//    NSLog(@"firstButtonAction index : %d" , pc.currentPage);
    if (delegate && [delegate respondsToSelector:@selector(loopScrollView:didSelectIndex:didSelectImage:)]) {
        [delegate loopScrollView:self didSelectIndex:pc.currentPage didSelectImage:firstView.image];
    }
    
}

- (void) secondButtonAction : (id) sender
{
//    NSLog(@"secondButtonAction index : %d" , pc.currentPage);
    if (delegate && [delegate respondsToSelector:@selector(loopScrollView:didSelectIndex:didSelectImage:)]) {
        [delegate loopScrollView:self didSelectIndex:pc.currentPage didSelectImage:secondView.image];
    }
}

- (void) thirdButtonAction : (id) sender
{
    if (delegate && [delegate respondsToSelector:@selector(loopScrollView:didSelectIndex:didSelectImage:)]) {
        [delegate loopScrollView:self didSelectIndex:pc.currentPage didSelectImage:thirdView.image];
    }
}

#pragma mark - private methods
- (void) cacheImageViewSetImage
{
    if ([[showArray objectAtIndex:0] isKindOfClass:[UIImage class]]) {
        [firstView setImage:[showArray objectAtIndex:0]];
    }
    else if ([[showArray objectAtIndex:0] isKindOfClass:[NSString class]])
    {
        [firstView getImageFromURL:[NSURL URLWithString:[showArray objectAtIndex:0]]];
    }
    else if ([[showArray objectAtIndex:0] isKindOfClass:[NSURL class]])
    {
        [firstView getImageFromURL:[showArray objectAtIndex:0]];
    }
    
    if ([[showArray objectAtIndex:1] isKindOfClass:[UIImage class]]) {
        [secondView setImage:[showArray objectAtIndex:1]];
    }
    else if ([[showArray objectAtIndex:1] isKindOfClass:[NSString class]])
    {
        [secondView getImageFromURL:[NSURL URLWithString:[showArray objectAtIndex:1]]];
    }
    else if ([[showArray objectAtIndex:1] isKindOfClass:[NSURL class]])
    {
        [secondView getImageFromURL:[showArray objectAtIndex:1]];
    }
    
    if ([[showArray objectAtIndex:2] isKindOfClass:[UIImage class]]) {
        [thirdView setImage:[showArray objectAtIndex:2]];
    }
    else if ([[showArray objectAtIndex:2] isKindOfClass:[NSString class]])
    {
        [thirdView getImageFromURL:[NSURL URLWithString:[showArray objectAtIndex:2]]];
    }
    else if ([[showArray objectAtIndex:2] isKindOfClass:[NSURL class]])
    {
        [thirdView getImageFromURL:[showArray objectAtIndex:2]];
    }
}

- (void) setCurrentImage
{
    if (myScrollView.contentOffset.x == 0.0f) {
        
        showIndex1--;
        if (loop) {
            if (showIndex1 < 0) {
                showIndex1 = [imageArray count] - 1;
            }
        }
        else
        {
            if (showIndex1 < 0) {
                showIndex1 = 0;
            }
        
        }
        
        showIndex2--;
        if (loop) {
            if (showIndex2 < 0) {
                showIndex2 = [imageArray count] - 1;
            }
        }
        else
        {
            if (showIndex2 < 1) {
                showIndex2 = 1;
            }
        }
        
        showIndex3--;
        if (loop) {
            if (showIndex3 < 0) {
                showIndex3 = [imageArray count] - 1;
            }
        }
        else
        {
            if (showIndex3 < 2) {
                showIndex3 = 2;
            }
        }
        [showArray replaceObjectAtIndex:0 withObject:[imageArray objectAtIndex:showIndex1]];
        [showArray replaceObjectAtIndex:1 withObject:[imageArray objectAtIndex:showIndex2]];
        [showArray replaceObjectAtIndex:2 withObject:[imageArray objectAtIndex:showIndex3]];
        
        [self cacheImageViewSetImage];
        [pc setCurrentPage:showIndex2];
        [myScrollView setContentOffset:CGPointMake(self.frame.size.width, 0)];
    }
    else if (myScrollView.contentOffset.x == self.frame.size.width)
    {
        [pc setCurrentPage:showIndex2];
    }
    else if (myScrollView.contentOffset.x == self.frame.size.width * 2)
    {
        showIndex1++;
        if (loop) {
            if (showIndex1 >= [imageArray count]) {
                showIndex1 = 0;
            }
        }
        else
        {
            if (showIndex1 > [imageArray count] - 3) {
                showIndex1 = [imageArray count] - 3;
            }
        }
        
        
        showIndex2++;
        if (loop) {
            if (showIndex2 >= [imageArray count]) {
                showIndex2 = 0;
            }
        }
        else
        {
            if (showIndex2 > [imageArray count] - 2) {
                showIndex2 = [imageArray count] - 2;
            }
        }
        
        showIndex3++;
        if (loop) {
            if (showIndex3 >= [imageArray count]) {
                showIndex3 = 0;
            }
        }
        else
        {
            if (showIndex3 == [imageArray count] - 1) {
                showIndex3 = [imageArray count] - 1;
            }
        }
        [showArray replaceObjectAtIndex:0 withObject:[imageArray objectAtIndex:showIndex1]];
        [showArray replaceObjectAtIndex:1 withObject:[imageArray objectAtIndex:showIndex2]];
        [showArray replaceObjectAtIndex:2 withObject:[imageArray objectAtIndex:showIndex3]];
        
        [self cacheImageViewSetImage];
        [pc setCurrentPage:showIndex2];
        [myScrollView setContentOffset:CGPointMake(self.frame.size.width, 0)];
    }
}

#pragma mark - timer action
- (void) timerStart : (float) duration
{
    [self setLoop:YES];
    [self timerEnd];
    myTimer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

- (void) timerEnd
{
    if (myTimer) {
        [myTimer invalidate];
        myTimer = nil;
    }
}
- (void) scrollAnimationStop
{
    [self setCurrentImage];
    [myScrollView setContentOffset:CGPointMake(self.frame.size.width, 0)];
    [myScrollView setUserInteractionEnabled:YES];
}
- (void) timerAction : (NSTimer*) sender
{
    [myScrollView setUserInteractionEnabled:NO];
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(scrollAnimationStop)];
    
    [myScrollView setContentOffset:CGPointMake(myScrollView.contentOffset.x + self.frame.size.width, 0)];
    
    [UIView commitAnimations];
}

#pragma mark - UIScrollView Delegate
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.x == 0) {
        return;
    }
    
    if (imageArray.count != 2 && scrollView.contentOffset.x == scrollView.bounds.size.width * 2) {
        return;
    }
    
    if (imageArray.count == 2 && scrollView.contentOffset.x == scrollView.bounds.size.width) {
        return;
    }
    
    [myScrollView setUserInteractionEnabled:NO];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!loop) {
        if (imageArray.count > 2) {
            if (showIndex2 == imageArray.count - 2) {
                if (scrollView.contentOffset.x > self.frame.size.width) {
                    [pc setCurrentPage:showIndex3];
                }
                else if (scrollView.contentOffset.x < self.frame.size.width) {
//                    if (showIndex2 == 2) {
//                        [self setCurrentImage];
//                    }
//                    else
//                    {
//                        [pc setCurrentPage:showIndex1];
//                    }
                    if (imageArray.count == 3) {
                        [pc setCurrentPage:showIndex1];
                    }
                    else
                    {
                        [self setCurrentImage];
                    }
                    
                }
                else
                {
                    [self setCurrentImage];
                }
            }
            else
            {
                if (showIndex2 == 1) {
                    if (scrollView.contentOffset.x < self.frame.size.width) {
                        [pc setCurrentPage:showIndex1];
                    }
                    else
                    {
                        [self setCurrentImage];
                    }
                    
                }
                else
                {
                    [self setCurrentImage];
                }
                
            }
        }
        else
        {
            if (scrollView.contentOffset.x == 0) {
                [pc setCurrentPage:showIndex1];
            }
            else
            {
                [pc setCurrentPage:showIndex2];
            }
        }
    }
    else
    {
        [self setCurrentImage];
    }
    
    
    
//    NSLog(@"index1 : %d ----- index2 : %d ----- index3 : %d" , showIndex1 , showIndex2 , showIndex3);
//    NSLog(@"content.x : %f" , scrollView.contentOffset.x);
    [myScrollView setUserInteractionEnabled:YES];
    isScrollView = YES;
}

#pragma mark - scrollView setting
-(void)setLoop:(BOOL)_loop
{
    loop = _loop;
    if (imageArray.count == 2) {
        if (loop) {
            [myScrollView setContentSize:CGSizeMake(myScrollView.bounds.size.width * 3, myScrollView.bounds.size.height)];
        }
        else
        {
            [myScrollView setContentSize:CGSizeMake(myScrollView.bounds.size.width * 2, myScrollView.bounds.size.height)];
        }
    }
    else
    {
        [myScrollView setContentSize:CGSizeMake(myScrollView.bounds.size.width * 3, myScrollView.bounds.size.height)];
    }
}

- (void) setContentOffset : (CGPoint) point
{
    if (myScrollView) {
        [myScrollView setContentOffset:point];
    }
}

- (void) setContentOffset : (CGPoint) point animated : (BOOL) animated
{
    if (myScrollView) {
        [myScrollView setContentOffset:point animated:animated];
    }
}

- (void) setBounces : (BOOL) bounces
{
    if (myScrollView) {
        [myScrollView setBounces:bounces];
    }
}

- (void) setBackgroundColor : (UIColor*) color
{
    if (myScrollView) {
        [myScrollView setBackgroundColor:color];
    }
}

- (void) setPagingEnabled : (BOOL) enabled
{
    if (myScrollView) {
        [myScrollView setPagingEnabled:enabled];
    }
}

- (void) setHidden : (BOOL) hidden
{
    if (myScrollView) {
        [myScrollView setHidden:hidden];
    }
}

- (void) setScrollEnabled : (BOOL) enabled
{
    if (myScrollView) {
        [myScrollView setScrollEnabled:enabled];
    }
}

- (void) setScrollsToTop : (BOOL) top
{
    if (myScrollView) {
        [myScrollView setScrollsToTop:top];
    }
}

- (void) setShowsHorizontalScrollIndicator : (BOOL) show
{
    if (myScrollView) {
        [myScrollView setShowsHorizontalScrollIndicator:show];
    }
}

- (void) setShowsVerticalScrollIndicator : (BOOL) show
{
    if (myScrollView) {
        [myScrollView setShowsVerticalScrollIndicator:show];
    }
}

- (void) setUserInteractionEnabled : (BOOL) enabled
{
    if (myScrollView) {
        [myScrollView setUserInteractionEnabled:enabled];
    }
}

#pragma mark - pageControl setting
- (void) setPageControlHidden : (BOOL) hidden
{
    if (pc) {
        [pc setHidden:hidden];
    }
}

- (void) setPageControlOffset : (CGPoint) offset
{
    if (pc) {
        CGRect rect = pc.frame;
        [pc setFrame:CGRectMake(offset.x, rect.origin.y + offset.y, rect.size.width, rect.size.height)];
    }
}

- (void) setPageControlCurrentPage : (NSInteger) index
{
    if (pc) {
        [pc setCurrentPage:index];
    }
}

- (void) setPageControlNumberOfPages : (NSInteger) pages
{
    if (pc) {
        [pc setNumberOfPages:pages];
    }
}

- (void) setPageControlCurrentImage : (UIImage*) currentImage
{
    if (pc) {
        [pc setImagePageStateHighlighted:currentImage];
    }
}

- (void) setPageControlDefaultImage : (UIImage*) defaultImage
{
    if (pc) {
        [pc setImagePageStateNormal:defaultImage];
        
    }
}

@end
