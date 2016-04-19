//
//  TiWenViewCustomer.h
//  HuaYue
//
//  Created by Appolls on 14-12-18.
//
//

#import <UIKit/UIKit.h>

@protocol tiwenDelegate <NSObject>
- (void)didClickedRankWitnScore:(NSString *)scoreStr;
- (void)xuanShangGO;
@optional

@end
@interface TiWenViewCustomer : UIView
- (IBAction)paiZhaoBtn:(id)sender;
- (IBAction)wengaoShou:(id)sender;
- (IBAction)xuanShangBtn:(id)sender;
- (IBAction)jiFenBtn:(id)sender;
- (void)mShowToolBar;
@property(assign, nonatomic)BOOL xuanShangisSelected;
@property(assign, nonatomic)CGRect keyBoardFrame;
@property (strong, nonatomic) dispatch_block_t block;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *myJifen;
@property (nonatomic, assign)id<tiwenDelegate>delegate;
@end
