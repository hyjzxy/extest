//
//  MZTextField.m
//  HuaYue
//
//  Created by 崔俊红 on 15/6/19.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "MZTextField.h"
#import "Masonry.h"

@interface MZTextField ()
@property (strong, nonatomic) UILabel *maxLabel;
@end

@implementation MZTextField
{
    NSInteger mLen;
}
- (void)setMaxLen:(NSInteger)len
{
    mLen = len;
    if (mLen >0) {
        if (!_maxLabel) {
            self.maxLabel = [[UILabel alloc]init];
            [self addSubview:_maxLabel];
            WS(ws);
            [_maxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(ws.mas_bottom);
                make.trailing.equalTo(ws);
            }];
        }
        _maxLabel.textAlignment = NSTextAlignmentRight;
        _maxLabel.font = SYSTEMFONT(12);
        _maxLabel.textColor = [UIColor redColor];
        _maxLabel.text = [NSString stringWithFormat:@"%zd",len-self.text.length];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didChange:) name:UITextFieldTextDidChangeNotification object:self];
        [self.layer displayIfNeeded];
    }
}

- (void)didChange:(NSNotification*)noti
{
    if (self.text.length>mLen) {
        self.text = [self.text substringToIndex:mLen-1];
        _maxLabel.text = [NSString stringWithFormat:@"%zd",0];
    }else{
        _maxLabel.text = [NSString stringWithFormat:@"%zd",mLen-self.text.length];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
