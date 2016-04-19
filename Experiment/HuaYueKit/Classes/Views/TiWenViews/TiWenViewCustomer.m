//
//  TiWenViewCustomer.m
//  HuaYue
//
//  Created by Appolls on 14-12-18.
//
//

#import "TiWenViewCustomer.h"
#import "XHWenGaoShouViewController.h"
@interface TiWenViewCustomer ()
@end
@implementation TiWenViewCustomer

- (IBAction)paiZhaoBtn:(id)sender {}
- (IBAction)wengaoShou:(id)sender {}
- (IBAction)xuanShangBtn:(id)sender {
    self.xuanShangisSelected = !_xuanShangisSelected;
    if (_delegate && [_delegate respondsToSelector:@selector(xuanShangGO)]) {
        [_delegate xuanShangGO];
        [self mShowToolBar];
    }
}
/// // 判断键盘、是否悬赏意图
- (void)mShowToolBar
{
    BOOL isKeyBoard = !CGRectIsEmpty(_keyBoardFrame);
    [UIView animateWithDuration:0.3 animations:^{
        if (_xuanShangisSelected) {
            if (isKeyBoard) {
                [self.superview endEditing:YES];
            }
            CGRectSetY(self,VMaxY(self.superview)-259);
        }else{
            if(isKeyBoard){
                CGRectSetY(self,_keyBoardFrame.origin.y-45);
            }else{
                CGRectSetY(self,VMaxY(self.superview)-109);
            }
        }
    }];
}

- (IBAction)jiFenBtn:(id)sender {
    UIButton * btn = (UIButton *)sender;
    if ([self.delegate respondsToSelector:@selector(didClickedRankWitnScore:)]) {
        [self.delegate didClickedRankWitnScore:[NSString stringWithFormat:@"%zd",  btn.tag - 1000]];
    }
}
@end
