//
//  selectCollectionCell.m
//  HuaYue
//
//  Created by tianzhenkuan on 15/2/3.
//
//

#import "selectCollectionCell.h"

@implementation selectCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.titleLabel  = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 2, 2)];
        self.titleLabel.font  = [UIFont systemFontOfSize:13.0];
        self.titleLabel.textAlignment   = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

@end
