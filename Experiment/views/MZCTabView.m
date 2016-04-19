//
//  MZCTabView.m
//  HuaYue
//
//  Created by 崔俊红 on 15/6/2.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "MZCTabView.h"
#import "Masonry.h"
#import "HYHelper.h"

@interface MZCTabView ()
@property (strong, nonatomic) NSArray *blocks;
@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSMutableArray *underLines;
@end

@implementation MZCTabView

{
    NSInteger selectedIndex;
}

- (instancetype)initWithTitles:(NSArray*)titles blocks:(NSArray*)blocks
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        selectedIndex = 0;
        self.btns = [NSMutableArray array];
        self.underLines = [NSMutableArray array];
        self.titles = titles;
        self.blocks = blocks;
        WS(ws);
        for (int i=0; i<titles.count; i++) {
            UIButton *btn = [self buildBtn:i];
            [self addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                if (_btns.lastObject) {
                    make.leading.equalTo(((UIView*)_btns.lastObject).mas_trailing);
                    make.height.and.width.equalTo(_btns.lastObject);
                    make.centerY.equalTo(_btns.lastObject);
                }else{
                    make.leading.equalTo(ws);
                    make.top.bottom.equalTo(ws);
                }
            }];
            [_btns addObject:btn];
            UIImageView *underLine = [[UIImageView alloc]init];
            [_underLines addObject:underLine];
            underLine.backgroundColor = UIColorFromRGB(0xDBDADA);
            [self addSubview:underLine];
            [underLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(@4.0f);
                make.width.equalTo(ws.btns.lastObject);
                make.bottom.equalTo(ws.btns.lastObject);
                make.centerX.equalTo(ws.btns.lastObject);
            }];
        }
        if(_btns.lastObject){
            [((UIView*)_btns.lastObject) mas_updateConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(ws);
            }];
        }
        [self updateBtnState:selectedIndex];
    }
    
    return self;
}

- (UIButton*)buildBtn:(NSInteger)tag
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = BOLDSYSTEMFONT(14.0);
    [btn setTitleColor:UIColorFromRGB(0x626363) forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x20ACF4) forState:UIControlStateSelected];
    btn.tag = tag;
    [btn setTitle:_titles[tag] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAct:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)btnAct:(UIButton*)sender
{
    NSInteger index = sender.tag;
    //  处理按钮状态
    [self updateBtnState:index];
    //  事件回调
    mz_block_t block = _blocks[index];
    block(@(index));
}

- (void)updateBtnState:(NSInteger)selected
{
    UIButton *preBtn = _btns[selectedIndex];
    UIButton *currBtn = _btns[selected];
    preBtn.selected = NO;
    currBtn.selected = YES;
    ((UIImageView*)_underLines[selectedIndex]).backgroundColor = UIColorFromRGB(0xDBDADA);
    selectedIndex = selected;
    ((UIImageView*)_underLines[selectedIndex]).backgroundColor = UIColorFromRGB(0x00A6F4);
}

@end
