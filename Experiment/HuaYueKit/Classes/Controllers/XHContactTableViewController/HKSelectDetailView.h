//
//  HKSelectDetailView.h
//  HuaYue
//
//  Created by Gideon on 16/5/21.
//  Copyright © 2016年 麦子收割队. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKSelectDetailView;
@protocol HKSelectDetailViewDelegate <NSObject>

- (void)selectDetailView:(HKSelectDetailView*)detailView didselectIndex:(NSInteger)index;

@end

@interface HKSelectDetailView : UIView

@property (nonatomic,strong)NSMutableArray* titleArray;
@property (nonatomic,strong)UITableView* tableView;
//@property (nonatomic,assign)NSInteger selectIndex;
@property (nonatomic,strong)UIView* backView;
@property (nonatomic,assign)CGFloat newHeight;
@property (nonatomic,weak) id<HKSelectDetailViewDelegate> delegate;
@property (nonatomic,assign) NSInteger selectDetailIndex;

@property (nonatomic,assign)BOOL isOne;//是否单选 no是 yes多选

- (void)show;
- (void)dismiss;

@end
