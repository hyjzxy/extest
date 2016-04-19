//
//  XHShouTipsView.m
//  HuaYue
//
//  Created by Appolls on 14-12-12.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHShouTipsView.h"

@implementation XHShouTipsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if(self){
        
        
        UIImageView *imgeView = [[UIImageView alloc] initWithFrame:CGRectMake(63, 191, 195, 100)];
        imgeView.image = [UIImage imageNamed:@"shou_Tips"];
        [self addSubview:imgeView];
        
        
        UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 195, 33)];
        [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [moreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [imgeView addSubview:moreBtn];
        
        
        UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 34, 195, 33)];
        [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        [shareBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        shareBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [imgeView addSubview:shareBtn];
        
        
        
        UIButton *juBaoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 67, 195, 33)];
        [juBaoBtn setTitle:@"举报" forState:UIControlStateNormal];
        [juBaoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        juBaoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [imgeView addSubview:juBaoBtn];
        
        
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self removeFromSuperview];
    
}

@end
