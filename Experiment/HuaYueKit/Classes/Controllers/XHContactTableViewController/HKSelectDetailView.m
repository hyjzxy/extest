//
//  HKSelectDetailView.m
//  HuaYue
//
//  Created by Gideon on 16/5/21.
//  Copyright © 2016年 麦子收割队. All rights reserved.
//

#import "HKSelectDetailView.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface HKSelectCell : UITableViewCell

@property (nonatomic,strong) UIImageView* icon;
@property (nonatomic,strong) UILabel* titleLabel;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,strong) NSDictionary* dataDic;
@property (nonatomic,assign) BOOL isOne;
@end

@implementation HKSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
        _icon = [[UIImageView alloc] init];
        [self addSubview:_icon];
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@20);
        }];
        _icon.image = [UIImage imageNamed:@"box-off.png"];
//        _icon.backgroundColor = [UIColor redColor];
        
        _titleLabel = [[UILabel alloc]init];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_icon.mas_right).offset(5);
            make.centerY.equalTo(self);
            make.height.equalTo(@20);
            
        }];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.text = @"分类";
        
        UIView* sepline = [[UIView alloc]init];
        sepline.backgroundColor = [UIColor grayColor];
        [self addSubview:sepline];
        [sepline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.right.equalTo(@-10);
            make.bottom.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (void)setType:(NSInteger)type{
    _type = type;
    if (type == 1){
        [_icon removeFromSuperview];
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.centerX.centerY.equalTo(self);
            make.width.equalTo(@(SCREENWIDTH/3.0-20));
        }];
//        _titleLabel.frame = CGRectMake(10, 10, SCREENWIDTH/3.0-20, 20);
        //        _titleLabel.text = da taDic[@""];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [_titleLabel makeRoundCorner];
    }else {
        _icon.image = [UIImage imageNamed:@"box-off.png"];
//        _icon.layer.masksToBounds = YES;
//        _icon.layer.borderColor = [UIColor grayColor].CGColor;
//        _icon.layer.borderWidth = 0.5;
        
    }
}

- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    if (self.type == 1){
        if ([dataDic[@"bSelect"] boolValue]){
            //        self.icon.backgroundColor = [UIColor grayColor];
            _titleLabel.backgroundColor = UIColorFromRGB(0x2EC9FB);
            _titleLabel.textColor = [UIColor whiteColor];
        }else{
            //       self.icon.backgroundColor = [UIColor yellowColor];
            _titleLabel.backgroundColor = [UIColor clearColor];
            _titleLabel.textColor = [UIColor grayColor];
        }
    }else{
        if ([dataDic[@"bSelect"] boolValue]) {
            _icon.image = [UIImage imageNamed:@"box-on.png"];
//            _icon.image = [UIImage imageNamed:@"common_select"];
        }else{
            _icon.image = [UIImage imageNamed:@"box-off.png"];
//            _icon.image = nil;
        }
    }

    
    self.titleLabel.text = dataDic[@"catname"];
}

@end



@interface HKSelectDetailView() <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray* selectArray;

@end

@implementation HKSelectDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectArray = [NSMutableArray new];
        _isOne = YES;
        
        _titleArray = [NSMutableArray new];
        self.selectDetailIndex = -1;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(frame.origin.x+3, 0, self.width-6, 0) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _newHeight = SCREENHEIGHT - frame.origin.y;
        
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, -10, SCREENWIDTH, _newHeight+10)];
        _backView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0];
        [self addSubview:_backView];
        [_backView handleClick:^(UIView *view) {
            [self dismiss];
//            if (self.delegate){
//                [self.delegate selectDetailView:self didselectIndex:-1];
//            }
        }];
        
        [self addSubview:_tableView];
        
        UIImageView* upIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"answer_up"]];
        [self addSubview:upIV];
        [upIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_tableView);
            make.bottom.equalTo(_tableView.mas_top);
        }];
        
        UIView* footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableView.width, 40)];
        
        UIButton* doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneButton setTitle:@"确定" forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        doneButton.backgroundColor = UIColorFromRGB(0x02A8F3);
//        doneButton.frame = CGRectMake(5, 10, self.width-10, 20);
        [footView addSubview:doneButton];
        [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@10);
//            make.right.equalTo(@10);
            make.height.equalTo(@20);
            make.centerX.centerY.equalTo(footView);
            make.width.equalTo(@(SCREENWIDTH/3.0-20));
        }];
        self.tableView.tableFooterView = footView;
        doneButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [doneButton makeRoundCornerWithRadius:4];
        [doneButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.frame = CGRectMake(0, self.frame.origin.y, SCREENWIDTH, _newHeight);
    }
    return self;
}

- (void)setTitleArray:(NSArray *)titleArray{
    [_titleArray removeAllObjects];
    [_titleArray addObjectsFromArray:titleArray];
    if (self.tag == 1){
        for (NSInteger i = 0; i<titleArray.count;i++){
            NSDictionary* dic = titleArray[i];
            if ([dic[@"bSelect"] isEqualToString:@"1"]){
                self.selectDetailIndex = i;
                break;
            }
        }
    }
    [self.tableView reloadData];
}

- (void)show{
    [KEYWINDOW addSubview:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
        if (self.tag != 1){
            self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, 40*self.titleArray.count+40);
        }else{
            self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, 40*self.titleArray.count);
        }
        
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

- (void)buttonAction:(id)sender{
    
    if (self.delegate){
        if (self.tag == 1){
            [self.delegate selectDetailView:self didselectIndex:self.selectDetailIndex];
        }else{
            [self.delegate selectDetailView:self didselectIndexs:self.titleArray];
        }
        
    }
    [self dismiss];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isOne) {
        [self.selectArray removeObject:@(indexPath.row)];
        [self.selectArray addObject:@(indexPath.row)];
    }
    
    if (self.tag == 1){//单选
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
            self.selectDetailIndex = -1;
        }else{
            [dic setValue:@"1" forKey:@"bSelect"];
            self.selectDetailIndex = indexPath.row;
        }
        [self.titleArray replaceObjectAtIndex:indexPath.row withObject:dic];
        [self.tableView reloadData];
        [self.delegate selectDetailView:self didselectIndex:self.selectDetailIndex];
        [self dismiss];
    }else {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithDictionary:self.titleArray[indexPath.row]] ;
        if ([dic[@"bSelect"] boolValue]){
            [dic setValue:@"0" forKey:@"bSelect"];
        }else{
            [dic setValue:@"1" forKey:@"bSelect"];
            self.selectDetailIndex = indexPath.row;
        }
        [self.titleArray replaceObjectAtIndex:indexPath.row withObject:dic];
        [self.tableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell == nil ){
        cell = [[HKSelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    NSDictionary* dic = self.titleArray[indexPath.row];
    NSString* bSelect = [[NSString alloc]initWithFormat:@"%@",dic[@"bSelect"]];
    if ([bSelect isEqualToString:@"1"]){
        self.selectDetailIndex = indexPath.row;
    }
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

