//
//  DDBarButton.m
//  DDMessage
//
//  Created by HuiPeng Huang on 14-1-3.
//  Copyright (c) 2014年 HuiPeng Huang. All rights reserved.
//

#import "DDBarButton.h"

@implementation DDBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.highlighted)  //高亮时降低透明度
    {
        self.alpha = 0.2;
    }
    else
    {
        self.alpha = 1.0;
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    
    
}

@end
