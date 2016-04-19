//
//  MZTabView.m
//  HuaYue
//
//  Created by 崔俊红 on 15/5/27.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "MZTabView.h"
#import "Masonry.h"
#import "HYHelper.h"

@interface MZTabView ()
@property (strong, nonatomic) NSArray *blocks;
@property (strong, nonatomic) NSMutableArray *btns;
@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) UIImageView *underLine;
@end

@implementation MZTabView
{
    NSInteger selectedIndex;
}

- (instancetype)initWithTitles:(NSArray*)titles blocks:(NSArray*)blocks
{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xEEE9E3);
        selectedIndex = 0;
        self.btns = [NSMutableArray array];
        self.titles = titles;
        self.blocks = blocks;
        WS(ws);
        UILabel *tmp = nil;
        for (int i=0; i<titles.count; i++) {
            UIButton *btn = [self buildBtn:i];
            [self addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                if (_btns.lastObject) {
                    make.leading.equalTo(tmp.mas_trailing);
                    make.height.and.width.equalTo(_btns.lastObject);
                    make.centerY.equalTo(_btns.lastObject);
                }else{
                    make.leading.equalTo(ws);
                    make.top.bottom.equalTo(ws);
                }
            }];
            [_btns addObject:btn];
            if(titles.count >1 && i < titles.count - 1){
                UILabel *line = [[UILabel alloc]init];
                line.backgroundColor = [UIColor grayColor];
                [self addSubview:line];
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(@1);
                    make.leading.equalTo(btn.mas_trailing);
                    make.top.equalTo(ws).with.offset(13.0f);
                    make.bottom.equalTo(ws).with.offset(-13.0f);
                }];
                tmp = line;
            }
        }
        if(_btns.lastObject){
            [((UIView*)_btns.lastObject) mas_updateConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(ws);
            }];
        }
        self.underLine = [[UIImageView alloc]init];
        _underLine.backgroundColor = UIColorFromRGB(0xF2AC53);
        [self addSubview:_underLine];
        [_underLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@3.0f);
            make.width.equalTo(ws.btns[0]);
            make.bottom.equalTo(ws.btns[0]);
            make.centerX.equalTo(ws.btns[0]);
        }];
        [self updateBtnState:selectedIndex];
    }
    return self;
}

- (UIButton*)buildBtn:(NSInteger)tag
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = BOLDSYSTEMFONT(13.0f);
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0xF17157) forState:UIControlStateSelected];
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
    block(nil);
}

- (void)updateBtnState:(NSInteger)selected
{
    UIButton *preBtn = _btns[selectedIndex];
    UIButton *currBtn = _btns[selected];
    preBtn.selected = NO;
    currBtn.selected = YES;
    selectedIndex = selected;
    WS(ws);
    [_underLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@3.0f);
        make.width.equalTo(ws.btns[selectedIndex]);
        make.bottom.equalTo(ws.btns[selectedIndex]);
        make.centerX.equalTo(ws.btns[selectedIndex]);
    }];
}

@end
