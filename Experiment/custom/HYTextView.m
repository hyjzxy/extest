//
//  HYTextView.m
//  HuaYue
//
//  Created by 崔俊红 on 15-4-1.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "HYTextView.h"
#import <CoreText/CoreText.h>
@interface HYTextView ()
@property (strong, nonatomic) UILabel *placeholdLabel;
@end

@implementation HYTextView

- (void)setPlacehold:(NSString *)placehold
{
    self.delegate = self;
    [_placeholdLabel removeFromSuperview];
    self.placeholdLabel = [[UILabel alloc]initWithFrame:Rect(5, 5, VWidth(self), 0)];
    _placeholdLabel.textAlignment = NSTextAlignmentLeft;
    _placeholdLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _placeholdLabel.textColor = [UIColor grayColor];
    _placeholdLabel.font = SYSTEMFONT(12);
    _placeholdLabel.backgroundColor = [UIColor redColor];
    _placeholdLabel.numberOfLines = 0;
    _placeholdLabel.backgroundColor = [UIColor clearColor];
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    _placeholdLabel.text = placehold;
    NSMutableParagraphStyle *p = [[NSMutableParagraphStyle alloc]init];
    p.firstLineHeadIndent = 5.0f;
    p.headIndent = 5.0f;
    p.tailIndent = VWidth(_placeholdLabel)-5.0f;
    CGRect size = [placehold boundingRectWithSize:Size(VWidth(self), MAXFLOAT) options:options attributes:@{NSFontAttributeName:_placeholdLabel.font,NSParagraphStyleAttributeName:p} context:nil];
    CGRectSetHeight(_placeholdLabel, size.size.height+2.0f);
    [self insertSubview:_placeholdLabel atIndex:0];
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

- (void)dealloc
{
    [self removeObserver:self  forKeyPath:@"text"];
}
@end
