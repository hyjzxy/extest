//
//  HKSelectView.m
//  HuaYue
//
//  Created by Gideon on 16/5/1.
//  Copyright © 2016年 麦子收割队. All rights reserved.
//

#import "HKSelectView.h"

@interface HKSelectView()<HKSelectDetailViewDelegate>

@property(nonatomic,weak)HKSelectDetailView* detailView;
@property(nonatomic,assign)NSInteger selectIndex;
//@property(nonatomic,assign)id<HKSelectViewDelegate> delegate;
@property(nonatomic,strong)NSMutableArray* selectArray;

@end

@implementation HKSelectView

//NSInteger selectIndex;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        selectIndex = -1;
        self.backgroundColor = [UIColor whiteColor];
        self.selectArray = [NSMutableArray new];
        [self.selectArray addObject:@-1];
        [self.selectArray addObject:@-1];
        [self.selectArray addObject:@-1];
//        self.detailArray = [NSMutableArray new];
    }
    return self;
}

- (void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    for (UIView* view in self.subviews) {
        if (view.tag >= 99)
        {
            [view removeFromSuperview];
        }
    }
    for (NSInteger i = 0; i < titleArray.count; i++)
    {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100+i;
        
        button.frame = CGRectMake(self.width/self.titleArray.count*i, 0, self.width/self.titleArray.count, self.height);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [button setTitleColor:self.selectColor forState:UIControlStateSelected];
//        [button setBackgroundColor:self.normalBackgroundColor];
        
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        //        if (!IS_IPHONE_6P) {
        //            button.titleLabel.font = XZFont(15);
        //        }
        
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        if ( i != titleArray.count-1 ){
            UIView* sepLine = [[UIView alloc]initWithFrame:CGRectMake(button.width-0.5, 10, 0.5, self.height-20)];
            [button addSubview:sepLine];
            sepLine.backgroundColor = [UIColor grayColor];
        }
        if (i == 0) {
            
//            button.selected = YES;
//            self.selectTag = 100+i;
//            [button setBackgroundColor:self.selectBackgroundColor];
        }
        [self addSubview:button];
    }
}

- (void)buttonAction:(id)sender
{
//    UIButton* selectButton = (UIButton*)sender;
    
    UIButton* button = (UIButton*)sender;
//    if (button.tag - 100 == selectIndex) {
//        return;
//    }
    if (self.selectIndex == button.tag - 100 && self.detailView != nil){
        [self.detailView dismiss];
        self.detailView = nil;
        return;
    }
    self.selectIndex = button.tag - 100;
    if (self.detailView != nil){
        [self.detailView dismiss];
    }
    HKSelectDetailView* detailView = [[HKSelectDetailView alloc]initWithFrame:CGRectMake(button.frame.origin.x , button.frame.origin.y+button.frame.size.height+74, SCREENWIDTH/3.0, 200)];
    detailView.delegate = self;
    detailView.selectDetailIndex = [self.selectArray[1] integerValue];
//    detailView.titleArray = self.detailArray[0];
    self.detailView = detailView;
    detailView.tag = button.tag-100;
    if (button.tag == 100){
        [detailView.titleArray addObjectsFromArray: self.stateArray];
//        NSString *uidS = [NSString stringWithFormat:@"%@topArray", [[NSUserDefaults standardUserDefaults] objectForKey:UID]];
//        if ([[NSUserDefaults standardUserDefaults]objectForKey:uidS]!=nil){
//            NSArray* son = [[NSUserDefaults standardUserDefaults]objectForKey:uidS];
//            for( NSInteger i= 0;i<detailView.titleArray.count;i++){
//                detailView.titleArray[i][@"bSelect"] = son[i][@"bSelect"];
//            }
//        }
        [detailView.tableView reloadData];
    }else if (button.tag == 101){
        [detailView.titleArray addObjectsFromArray: self.classifyArray];
        for (NSInteger i = 0; i<self.classifyArray.count; i++) {
            self.classifyArray[i][@"bSelect"] =  @"0";
        }
        NSString *uidS = [NSString stringWithFormat:@"%@Index",  [[NSUserDefaults standardUserDefaults] objectForKey:UID]];
        if ([[NSUserDefaults standardUserDefaults]objectForKey:uidS]!=nil){
            NSString* sub = [[NSUserDefaults standardUserDefaults]objectForKey:uidS];
            NSInteger index = sub.integerValue;
            detailView.titleArray[index][@"bSelect"] =  @"1";
            detailView.selectDetailIndex = index;
        }
        
        [detailView.tableView reloadData];
    } else if (button.tag == 102){
        detailView.tableView.frame = CGRectMake(SCREENWIDTH/2.0, 0, SCREENWIDTH/2.0, 0);
        [detailView.titleArray addObjectsFromArray: self.sonArray];
        NSString *uidS = [NSString stringWithFormat:@"%@Index",  [[NSUserDefaults standardUserDefaults] objectForKey:UID]];
        if ([[NSUserDefaults standardUserDefaults]objectForKey:uidS]!=nil){
            NSString* sub = [[NSUserDefaults standardUserDefaults]objectForKey:uidS];
            NSString* sonA = [NSString stringWithFormat:@"%@%@",uidS,sub];
            if ([[NSUserDefaults standardUserDefaults]objectForKey:sonA]!=nil){
                NSArray* son = [[NSUserDefaults standardUserDefaults]objectForKey:sonA];
                for( NSInteger i= 0;i<detailView.titleArray.count;i++){
                    detailView.titleArray[i][@"bSelect"] = son[i][@"bSelect"];
                }
            }
        }
        [detailView.tableView reloadData];
    }
    
    
    [detailView show];
}

- (void)selectDetailView:(HKSelectDetailView *)detailView didselectIndexs:(NSArray *)titleArray {
    if (self.delegate != nil){
        [self.delegate selectView:self selectIndex:self.selectIndex subArray:titleArray];
    }
}

- (void)selectDetailView:(HKSelectDetailView *)detailView didselectIndex:(NSInteger)index{
    if (self.delegate) {
        [self.delegate selectView:self selectIndex:detailView.tag subindex:index];
    }

    
//    if (detailView.tag == 1){
////        [self.detailView dismiss];
//        [self.selectArray replaceObjectAtIndex:1 withObject:[NSNumber numberWithInteger:index]];
//    }
//    if (index == -1 ){
//        self.selectIndex = -1;
//    }
}

@end


