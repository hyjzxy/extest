//
//  XHContactTableViewCell.h
//  MessageDisplayExample
//
//  Created by dw_iOS on 14-5-22.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBaseTableViewCell.h"
#import "XHMyButton.h"
@interface XHContactTableViewCell : XHBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *tipImageView;
@property (weak, nonatomic) IBOutlet UIImageView *head;
@property (weak, nonatomic) IBOutlet XHMyButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *level;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *reward;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *gaoShou;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UIImageView *huidaIMG;
@property (weak, nonatomic) IBOutlet UIImageView *logImg;
@property (weak, nonatomic) IBOutlet UIImageView *qImgeView;
@property (weak, nonatomic) IBOutlet UILabel *profileLabel;
@end
