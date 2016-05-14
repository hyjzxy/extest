//
//  MZLoadingVIew.m
//  HuaYue
//
//  Created by Gideon on 16/5/14.
//  Copyright © 2016年 麦子收割队. All rights reserved.
//

#import "MZLoadingVIew.h"

@implementation MZLoadingVIew

UILabel* textLabel;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
        
        UIView* centerView = [UIView new];
        [self addSubview:centerView];
        [centerView makeRoundCorner];
        centerView.backgroundColor = [UIColor whiteColor];
        [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@200);
            make.centerY.equalTo(self);
            make.centerX.equalTo(self);
            make.height.equalTo(@44);
        }];
        
        UIImageView* imageView = [UIImageView new];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(centerView).offset(40);
        }];
        imageView.image = [UIImage imageNamed:@"common_loading"];
        textLabel = [UILabel new];
        [self addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(imageView.mas_right).offset(10);
        }];
        textLabel.font = [UIFont systemFontOfSize:15];
        textLabel.textColor = [UIColor grayColor];
        
    }
    return self;
}

- (void)setLoadingText:(NSString *)loadingText {
    _loadingText = loadingText;
    textLabel.text = loadingText;
}

- (void)show{
    [KEYWINDOW addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(KEYWINDOW);
        make.right.equalTo(KEYWINDOW);
        make.centerY.equalTo(KEYWINDOW);
        make.bottom.equalTo(KEYWINDOW);
    }];
}

- (void)dissMiss {
    [self removeFromSuperview];
}

@end
