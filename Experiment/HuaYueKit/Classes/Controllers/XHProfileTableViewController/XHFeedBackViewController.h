//
//  XHFeedBackViewController.h
//  HuaYue
//
//  Created by lee on 15/1/21.
//
//

#import <UIKit/UIKit.h>
#import "HYTextView.h"

@interface XHFeedBackViewController : UIViewController

- (IBAction)sendFeedBack:(id)sender;
@property (weak, nonatomic) IBOutlet HYTextView *content;
@end
