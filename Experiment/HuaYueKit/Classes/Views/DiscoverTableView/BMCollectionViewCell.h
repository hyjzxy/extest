//
//  BMCollectionViewCell.h
//  XinCaiFu
//
//  Created by Appolls on 14-10-23.
//  Copyright (c) 2014年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMCollectionViewCell : UICollectionViewCell
@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UILabel *qunZhu;
@property (retain, nonatomic) IBOutlet UIImageView *gradeImage;

@property (retain, nonatomic) IBOutlet UIImageView *header;


@property (retain, nonatomic) IBOutlet UIButton *deleteButton;

@end
