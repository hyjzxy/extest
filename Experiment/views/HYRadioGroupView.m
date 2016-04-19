//
//  HYRadioGroupView.m
//  HuaYue
//
//  Created by 崔俊红 on 15-4-5.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "HYRadioGroupView.h"

@interface HYRadioGroupView()
@property (strong, nonatomic) NSMutableArray *radioBtns;
@end

@implementation HYRadioGroupView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title problem:(NSDictionary*)problem
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectIndex = -1;
        self.radioBtns = [NSMutableArray arrayWithCapacity:4];
        [self mSetUpUIWithProblem:problem title:title];
    }
    return self;
}

- (void)mSetUpUIWithProblem:(NSDictionary*)problem title:(NSString*)title
{
    CGFloat topSY = 0.0f;
    NSMutableParagraphStyle *headPara = [[NSMutableParagraphStyle alloc]init];
    headPara.firstLineHeadIndent = 10.0f;
    headPara.headIndent = 30.0f;
    headPara.alignment = NSTextAlignmentLeft;
    headPara.lineBreakMode = NSLineBreakByCharWrapping;
    //1、题目
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:Rect(0, 0, VWidth(self)-10, 0)];
    titleLabel.numberOfLines = 0;
    NSAttributedString *att = [[NSAttributedString alloc]initWithString:title attributes:@{NSParagraphStyleAttributeName:headPara,NSFontAttributeName:SYSTEMFONT(13.0f)}];
    titleLabel.attributedText = att;
    CGRectSetHeight(titleLabel, heightForStr(title, VWidth(self), @{NSParagraphStyleAttributeName:headPara,NSFontAttributeName:SYSTEMFONT(13.0f)}));
    [self addSubview:titleLabel];
    topSY = VMaxY(titleLabel) + 5;
    //2、选项
    NSArray *optionTtitls = @[@"optiona",@"optionb",@"optionc",@"optiond"];
    for (int i=0;i<4;i++) {
        UIButton *optBtn = [[UIButton alloc]initWithFrame:Rect(30, topSY, 20, 20)];
        [optBtn setImage:[UIImage imageNamed:@"box-on"] forState:UIControlStateSelected];
        [optBtn setImage:[UIImage imageNamed:@"box-off"] forState:UIControlStateNormal];
        [optBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        optBtn.tag = i;
        [_radioBtns addObject:optBtn];
        [self addSubview:optBtn];
        UILabel *optionDes = [[UILabel alloc]initWithFrame:Rect(VMaxX(optBtn)+5, topSY+2,VWidth(self)-VMaxX(optBtn)-10, 0)];
        optionDes.numberOfLines = 0;
        optionDes.lineBreakMode = NSLineBreakByCharWrapping;
        optionDes.font = SYSTEMFONT(12.0f);
        optionDes.textColor = [UIColor colorWithWhite:0 alpha:0.7];
        optionDes.text = problem[optionTtitls[i]];
        CGRectSetHeight(optionDes, heightForStr(problem[optionTtitls[i]], VWidth(self)-VMaxX(optBtn)+5, @{NSFontAttributeName:optionDes.font}));
        [self addSubview:optionDes];
        topSY = VMaxY(optionDes) + 5;
    }
    CGRectSetHeight(self, topSY);
}

- (void)selectClick:(UIButton*)sender
{
    for (UIButton *radion in _radioBtns) {
        radion.selected = NO;
    }
    sender.selected = YES;
    self.selectIndex = sender.tag;
}
@end
