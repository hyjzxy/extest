//
//  ChartCell.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import "ChartCell.h"
#import "ChartContentView.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface ChartCell()<ChartContentViewDelegate>
@property (nonatomic,strong) UIButton *icon;
@property (nonatomic,strong) ChartContentView *chartView;
@property (nonatomic,strong) ChartContentView *currentChartView;
@property (nonatomic,strong) NSString *contentStr;
@property (nonatomic,strong) UILabel *timeLabel;
@end

@implementation ChartCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.icon=[[UIButton alloc] init];
        [self.icon setImage:[UIImage imageNamed:@"defaultImg"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.icon];
        
        self.chartView =[[ChartContentView alloc]initWithFrame:CGRectZero];
        self.chartView.delegate=self;
        [self.contentView addSubview:self.chartView];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.font = [UIFont systemFontOfSize:11.0];
        self.timeLabel.textColor = RGBCOLOR(186, 186, 186);
        self.timeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}

-(void)setCellFrame:(ChartCellFrame *)cellFrame
{
    _cellFrame=cellFrame;
    
    ChartMessage *chartMessage=cellFrame.chartMessage;
    
    self.icon.frame=cellFrame.iconRect;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:chartMessage.icon] forState:UIControlStateNormal];
    self.chartView.chartMessage=chartMessage;
    self.chartView.frame=cellFrame.chartViewRect;
    [self setBackGroundImageViewImage:self.chartView from:@"chatfrom_bg_normal.png" to:@"chatto_bg_normal.png"];
    
    if (chartMessage.contentType == MessageType_Content) {
        self.chartView.contentLabel.text = chartMessage.content;
    }else
    {
        [self.chartView.contentImageView sd_setImageWithURL:[NSURL URLWithString:chartMessage.imgUrl]];
    }
    
    self.timeLabel.text = @"time";
    CGRect labelFrame = CGRectZero;
    
    if (cellFrame.chartMessage.messageType == kMessageFrom) {
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        labelFrame.origin.x = cellFrame.chartViewRect.origin.x;
    }else
    {
        labelFrame.origin.x = cellFrame.chartViewRect.origin.x + cellFrame.chartViewRect.size.width - 200;
        self.timeLabel.textAlignment = NSTextAlignmentRight;
    }
    labelFrame.origin.y = cellFrame.chartViewRect.size.height + cellFrame.chartViewRect.origin.y + 8;
    labelFrame.size.width = 200;
    labelFrame.size.height = 13.0;
    self.timeLabel.frame = labelFrame;
    
    self.timeLabel.text = cellFrame.chartMessage.time;
}

-(void)setBackGroundImageViewImage:(ChartContentView *)chartView from:(NSString *)from to:(NSString *)to
{
    UIImage *normal=nil ;
    if(chartView.chartMessage.messageType==kMessageFrom){
        normal = [UIImage imageNamed:from];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
    }else if(chartView.chartMessage.messageType==kMessageTo){
        normal = [UIImage imageNamed:to];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
    }
    
    chartView.backImageView.image=normal;
}

-(void)chartContentViewLongPress:(ChartContentView *)chartView content:(NSString *)content
{
//    [self becomeFirstResponder];
//    UIMenuController *menu=[UIMenuController sharedMenuController];
//    [menu setTargetRect:self.bounds inView:self];
//    [menu setMenuVisible:YES animated:YES];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuShow:) name:UIMenuControllerWillShowMenuNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuHide:) name:UIMenuControllerWillHideMenuNotification object:nil];
//    self.contentStr=content;
//    self.currentChartView=chartView;
}

-(void)chartContentViewTapPress:(ChartContentView *)chartView content:(NSString *)content
{
    if([self.delegate respondsToSelector:@selector(chartCell:tapContent:)]){
        [self.delegate chartCell:self tapContent:content];
    }
}

-(void)menuShow:(UIMenuController *)menu
{
    [self setBackGroundImageViewImage:self.currentChartView from:@"chatfrom_bg_focused.png" to:@"chatto_bg_focused.png"];
}
-(void)menuHide:(UIMenuController *)menu
{
    [self setBackGroundImageViewImage:self.currentChartView from:@"chatfrom_bg_normal.png" to:@"chatto_bg_normal.png"];
    self.currentChartView=nil;
    [self resignFirstResponder];
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(action ==@selector(copy:)){

        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}

-(void)copy:(id)sender
{
    [[UIPasteboard generalPasteboard]setString:self.contentStr];
}
-(BOOL)canBecomeFirstResponder
{
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
