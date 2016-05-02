//
//  HKSelectView.m
//  HuaYue
//
//  Created by Gideon on 16/5/1.
//  Copyright © 2016年 麦子收割队. All rights reserved.
//

#import "HKSelectView.h"

#define KEYWINDOW [[UIApplication sharedApplication] keyWindow]
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface HKSelectCell : UITableViewCell

@property (nonatomic,strong) UIImageView* icon;
@property (nonatomic,strong) UILabel* titleLabel;

@end

@implementation HKSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 20, 20)];
        [self addSubview:_icon];
        _icon.backgroundColor = [UIColor redColor];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, self.width, 20)];
        [self addSubview:_titleLabel];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = @"分类";
    }
    return self;
}

@end

@interface HKSelectDetailView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSArray* titleArray;
@property (nonatomic,strong)UITableView* tableView;
@property (nonatomic,assign)NSInteger selectIndex;
@property (nonatomic,strong)UIView* backView;
@property (nonatomic,assign)CGFloat newHeight;

@end

@implementation HKSelectDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(frame.origin.x, 0, self.width, 0) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _newHeight = SCREENHEIGHT - frame.origin.y;
        
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, -10, SCREENWIDTH, _newHeight+10)];
        _backView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0];
        [self addSubview:_backView];
        [_backView handleClick:^(UIView *view) {
            [self dismiss];
        }];
        
        [self addSubview:_tableView];

        self.frame = CGRectMake(0, self.frame.origin.y, SCREENWIDTH, _newHeight);
    }
    return self;
}

- (void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    [self.tableView reloadData];
}

- (void)show{
    [KEYWINDOW addSubview:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, 44*self.titleArray.count);
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.2 animations:^{
        self.backView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0];
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell == nil ){
        cell = [[HKSelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    if (self.selectIndex == indexPath.row){
        ((HKSelectCell* )cell).icon.backgroundColor = [UIColor grayColor];
    }
    ((HKSelectCell* )cell).titleLabel.text = self.titleArray[indexPath.row];
    return cell;
}

@end

@interface HKSelectView()

@property(nonatomic,weak)HKSelectDetailView* detailView;

@end

@implementation HKSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
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
    if (self.detailView != nil){
        [self.detailView dismiss];
    }
    UIButton* button = (UIButton*)sender;
    HKSelectDetailView* detailView = [[HKSelectDetailView alloc]initWithFrame:CGRectMake(button.frame.origin.x , button.frame.origin.y+button.frame.size.height+74, 100, 200)];
    
    detailView.titleArray = [NSArray arrayWithObjects:@"悬赏",@"未解决", nil];
    self.detailView = detailView;
    [detailView show];
}

@end


