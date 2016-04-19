//
//  BMCollectionViewCell.m
//  XinCaiFu
//
//  Created by Appolls on 14-10-23.
//  Copyright (c) 2014年 bluemobi. All rights reserved.
//

#import "BMCollectionViewCell.h"

@implementation BMCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CollectionCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
        
        self.deleteButton.layer.cornerRadius = 10;
        self.deleteButton.alpha = 0;
        
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor colorWithWhite:0.800 alpha:1.000].CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.shadowOpacity = .3f;
        self.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
        self.layer.shadowColor = [UIColor colorWithWhite:0.800 alpha:1.000].CGColor;
    }
    return self;
}
@end
