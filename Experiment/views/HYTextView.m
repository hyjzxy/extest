//
//  HYTextView.m
//  HuaYue
//
//  Created by 崔俊红 on 15-4-1.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "HYTextView.h"
#import <CoreText/CoreText.h>
#import "Masonry.h"
@interface HYTextView ()
@property (strong, nonatomic) UILabel *placeholdLabel;
@property (strong, nonatomic) UILabel *maxLabel;
@end

@implementation HYTextView
{
    NSInteger mLen;
}
- (void)setMaxLen:(NSInteger)len
{
    mLen = len;
    if (mLen >0) {
        if (!_maxLabel) {
            _maxLabel.backgroundColor = [UIColor yellowColor];
            self.maxLabel = [[UILabel alloc]init];
            [self.superview addSubview:_maxLabel];
            WS(ws);
            [_maxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(ws.mas_bottom);
                make.trailing.equalTo(ws).offset(-2);
            }];
        }
        _maxLabel.textAlignment = NSTextAlignmentRight;
        _maxLabel.font = SYSTEMFONT(12);
        _maxLabel.textColor = [UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.790];
        _maxLabel.text = [NSString stringWithFormat:@"%zd",len];
    }
}

- (void)setPlacehold:(NSString *)placehold
{
    self.delegate = self;
    [_placeholdLabel removeFromSuperview];
    self.placeholdLabel = [[UILabel alloc]init];
    _placeholdLabel.numberOfLines = 0;
    _placeholdLabel.textAlignment = self.textAlignment;
    _placeholdLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _placeholdLabel.textColor = [UIColor grayColor];
    _placeholdLabel.font = SYSTEMFONT(12);
    _placeholdLabel.text = placehold;
    _placeholdLabel.backgroundColor = [UIColor clearColor];
    [self insertSubview:_placeholdLabel atIndex:0];
    WS(ws);
    [_placeholdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.edges.equalTo(ws).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"text"]) {
        _placeholdLabel.hidden = ![[change objectForKey:@"new"] isEqualToString:@""];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (_beginEditBlock) {
        _beginEditBlock();
    }
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        _placeholdLabel.hidden = YES;
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        _placeholdLabel.hidden = textView.text.length>0;
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (mLen >0) {
        if (self.text.length > mLen) {
            textView.text = [textView.text substringWithRange:NSMakeRange(0, mLen)];
        }
        _maxLabel.text = [NSString stringWithFormat:@"%zd",mLen - self.text.length];
        return range.location<=mLen;
    }
    return YES;
}

- (void)dealloc
{
   [self removeObserver:self  forKeyPath:@"text"];
}
@end
