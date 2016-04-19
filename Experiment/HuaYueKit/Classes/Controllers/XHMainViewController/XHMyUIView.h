//
//  XHMyUIView.h
//  HuaYue
//
//  Created by lee on 15/1/18.
//
//

#import <UIKit/UIKit.h>

@protocol SupportDelegate <NSObject>
@optional
- (void)mSupportSuccWithUserInfo:(NSDictionary*)info;
@end
@interface XHMyUIView : UIView
@property (weak, nonatomic) id<SupportDelegate> delegate;
@property(nonatomic , assign)int dataSourceArrayIndex;
@end
