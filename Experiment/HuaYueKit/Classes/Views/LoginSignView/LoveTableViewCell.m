//
//  LoveTableViewCell.m
//  HuaYue
//
//  Created by Appolls on 14-12-25.
//
//

#import "LoveTableViewCell.h"

@implementation LoveTableViewCell

- (void)awakeFromNib {
    // Initialization code
    UIImageView *lineImgView = [[UIImageView alloc]init];
    lineImgView.image = [UIImage imageNamed:@"line_2"];
    lineImgView.frame = CGRectMake(0, self.bounds.size.height-0.5, 320, .5);
    [self addSubview:lineImgView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonBtn:(id)sender {
    
    if([self.delegate respondsToSelector:@selector(buttonBtn:)]){
        [self.delegate buttonBtn:self];
    }
    
}
@end
