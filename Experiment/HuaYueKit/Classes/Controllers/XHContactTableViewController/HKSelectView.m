//
//  HKSelectView.m
//  HuaYue
//
//  Created by Gideon on 16/5/1.
//  Copyright © 2016年 麦子收割队. All rights reserved.
//

#import "HKSelectView.h"



@interface HKSelectCell : UITableViewCell

@property (nonatomic,strong) UIImageView* icon;
@property (nonatomic,strong) UILabel* titleLabel;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,strong) NSDictionary* dataDic;
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
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = @"分类";
        
        UIView* sepline = [[UIView alloc]initWithFrame:CGRectMake(10, 43.5, SCREENWIDTH/3.0-20, 0.5)];
        sepline.backgroundColor = [UIColor grayColor];
        [self addSubview:sepline];
    }
    return self;
}

//- (void)setType:(NSInteger)type{
//    _type = type;
//    if (type == 1){
//        
//    }
//}

- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    if (self.type == 1){
        [_icon removeFromSuperview];
        _titleLabel.frame = CGRectMake(10, 10, SCREENWIDTH/3.0-20, 20);
//        _titleLabel.text = da taDic[@""];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [_titleLabel makeRoundCorner];
    }
    if ([dataDic[@"bSelect"] boolValue]){
//        self.icon.backgroundColor = [UIColor grayColor];
        _titleLabel.backgroundColor = UIColorFromRGB(0x2EC9FB);
        _titleLabel.textColor = [UIColor whiteColor];
    }else{
//       self.icon.backgroundColor = [UIColor yellowColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
    }
    
    self.titleLabel.text = dataDic[@"catname"];
}

@end

@class HKSelectDetailView;
@protocol HKSelectDetailViewDelegate <NSObject>

- (void)selectDetailView:(HKSelectDetailView*)detailView didselectIndex:(NSInteger)index;

@end

@interface HKSelectDetailView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray* titleArray;
@property (nonatomic,strong)UITableView* tableView;
//@property (nonatomic,assign)NSInteger selectIndex;
@property (nonatomic,strong)UIView* backView;
@property (nonatomic,assign)CGFloat newHeight;
@property (nonatomic,weak) id<HKSelectDetailViewDelegate> delegate;
@property (nonatomic,assign) NSInteger selectDetailIndex;

@end

@implementation HKSelectDetailView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleArray = [NSMutableArray new];
        self.selectDetailIndex = -1;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(frame.origin.x, 0, self.width, 0) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _newHeight = SCREENHEIGHT - frame.origin.y;
        
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, -10, SCREENWIDTH, _newHeight+10)];
        _backView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0];
        [self addSubview:_backView];
        [_backView handleClick:^(UIView *view) {
            [self dismiss];
            if (self.delegate){
                [self.delegate selectDetailView:self didselectIndex:-1];
            }
        }];
        
        [self addSubview:_tableView];

        self.frame = CGRectMake(0, self.frame.origin.y, SCREENWIDTH, _newHeight);
    }
    return self;
}

- (void)setTitleArray:(NSArray *)titleArray{
    [_titleArray addObjectsFromArray:titleArray];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tag == 1){
        if (self.selectDetailIndex != -1){
            NSDictionary* dic = self.titleArray[self.selectDetailIndex];
            if ([dic[@"bSelect"] boolValue]){
                [dic setValue:@"0" forKey:@"bSelect"];
            }else{
                [dic setValue:@"1" forKey:@"bSelect"];
            }
            [self.titleArray replaceObjectAtIndex:self.selectDetailIndex withObject:dic];
        }
        NSDictionary* dic = self.titleArray[indexPath.row];
        if ([dic[@"bSelect"] boolValue]){
            [dic setValue:@"0" forKey:@"bSelect"];
        }else{
            [dic setValue:@"1" forKey:@"bSelect"];
            self.selectDetailIndex = indexPath.row;
        }
        [self.titleArray replaceObjectAtIndex:indexPath.row withObject:dic];
        if (self.delegate){
            [self.delegate selectDetailView:self didselectIndex:indexPath.row];
        }
        [self.tableView reloadData];
        [self dismiss];
    }
    
//    sleep(1);
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell == nil ){
        cell = [[HKSelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    NSDictionary* dic = self.titleArray[indexPath.row];
//    if (self.selectIndex == indexPath.row){
//        ((HKSelectCell* )cell).icon.backgroundColor = [UIColor grayColor];
//    }
    if (self.tag == 1){
        ((HKSelectCell* )cell).type = 1;
    }else{
        ((HKSelectCell* )cell).type = 0;
    }
    ((HKSelectCell* )cell).dataDic = dic;
    
    return cell;
}

@end

@protocol HKSelectViewDelegate <NSObject>

- (void)selectView:(HKSelectView*)selectView selectIndex:(NSInteger)index subindex:(NSInteger)subindex;

@end

@interface HKSelectView()<HKSelectDetailViewDelegate>

@property(nonatomic,weak)HKSelectDetailView* detailView;
@property(nonatomic,assign)NSInteger selectIndex;
@property(nonatomic,assign)id<HKSelectViewDelegate> delegate;
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
    if (button.tag == 101){
        [detailView.titleArray addObjectsFromArray: self.classifyArray];
        [detailView.tableView reloadData];
    }
    
    
    [detailView show];
}

- (void)selectDetailView:(HKSelectDetailView *)detailView didselectIndex:(NSInteger)index{
   
    
    if (detailView.tag == 1){
//        [self.detailView dismiss];
        if (self.delegate) {
            [self.delegate selectView:self selectIndex:detailView.tag subindex:index];
        }
        [self.selectArray replaceObjectAtIndex:1 withObject:[NSNumber numberWithInteger:index]];
    }
//    if (index == -1 ){
//        self.selectIndex = -1;
//    }
}

@end


