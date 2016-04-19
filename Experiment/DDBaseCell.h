//
//  DDBaseCell.h
//  DDMessage
//
//  Created by HuiPeng Huang on 13-12-26.
//  Copyright (c) 2013年 HuiPeng Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDContentView : UIView

@end

@interface DDBaseCell : UITableViewCell

@property (nonatomic, strong) DDContentView *customView;

- (void)drawContentView:(CGRect)rect;

@end
