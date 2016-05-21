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
@end

@implementation HKSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        [self addSubview:_icon];
        _icon.backgroundColor = [UIColor redColor];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 10, self.width, 20)];
        [self addSubview:_titleLabel];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.text = @"分类";
        
        UIView* sepline = [[UIView alloc]initWithFrame:CGRectMake(10, 39.5, SCREENWIDTH/3.0-20, 0.5)];
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
        _titleLabel.textColor = [UIColor grayColor];
    }
    
    self.titleLabel.text = dataDic[@"catname"];
}

@end



@interface HKSelectDetailView() <UITableViewDelegate,UITableViewDataSource>



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
        
        UIView* footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 40)];
        
        UIButton* doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneButton setTitle:@"确定" forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        doneButton.backgroundColor = UIColorFromRGB(0x2EC9FB);
        doneButton.frame = CGRectMake(5, 10, self.width-10, 20);
        [footView addSubview:doneButton];
        self.tableView.tableFooterView = footView;
        doneButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [doneButton makeRoundCornerWithRadius:4];
        [doneButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
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
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, 40*self.titleArray.count+40);
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
//    if (self.delegate){
//        [self.delegate selectDetailView:self didselectIndex:indexPath.row];
//    }

    [self dismiss];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tag == 0) {
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
    }else if (self.tag == 1){
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
        
    }
    
    //    sleep(1);
    
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

