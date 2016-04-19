//
//  ChartContentView.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//
#define kContentStartMargin 25
#import "ChartContentView.h"
#import "ChartMessage.h"
@implementation ChartContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backImageView=[[UIImageView alloc]init];
        self.backImageView.userInteractionEnabled=YES;
        [self addSubview:self.backImageView];
        
        self.contentImageView = [[UIImageView alloc] init];
        self.contentImageView.userInteractionEnabled = NO;
        [self addSubview:self.contentImageView];
        
        self.contentLabel=[[UILabel alloc]init];
        self.contentLabel.numberOfLines=0;
        self.contentLabel.textAlignment=NSTextAlignmentLeft;
        self.contentLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:13];
        [self addSubview:self.contentLabel];
        
        [self addGestureRecognizer: [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap:)]];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPress:)]];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.backImageView.frame=self.bounds;
    
    if (self.chartMessage.contentType == MessageType_Content) {
        CGFloat contentLabelX=0;
        if(self.chartMessage.messageType==kMessageFrom){
            
            contentLabelX=kContentStartMargin*0.8;
        }else if(self.chartMessage.messageType==kMessageTo){
            contentLabelX=kContentStartMargin*0.5;
        }
        
        self.contentLabel.frame=CGRectMake(contentLabelX, -3, self.frame.size.width-kContentStartMargin-5, self.frame.size.height);
        self.contentImageView.hidden = YES;
        self.contentLabel.hidden = NO;
    }else
    {
        CGRect rect = CGRectZero;
        rect.origin = CGPointMake(10, 12);
        rect.size = CGSizeMake(100, 120);
        self.contentImageView.frame = rect;
        self.contentImageView.hidden = NO;
        self.contentLabel.hidden= YES;
    }
}

-(void)longTap:(UILongPressGestureRecognizer *)longTap
{
    if([self.delegate respondsToSelector:@selector(chartContentViewLongPress:content:)]){
        
        [self.delegate chartContentViewLongPress:self content:self.contentLabel.text];
    }
}

-(void)tapPress:(UILongPressGestureRecognizer *)tapPress
{
    if([self.delegate respondsToSelector:@selector(chartContentViewTapPress:content:)]){
    
        [self.delegate chartContentViewTapPress:self content:self.contentLabel.text];
    }
}
@end
