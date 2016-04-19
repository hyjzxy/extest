//
//  MultilineTextViewContainerViewController.h
//  Multiline-TextView
//
//  Created by Mounir Dellagi on 14.10.13.
//  Copyright (c) 2013 Mounir Dellagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDMultilineTextView.h"

@interface MDMultilineTextViewDelegateController : UIViewController <UITextViewDelegate>

/** The multiline text view */
@property (nonatomic, weak) IBOutlet MDMultilineTextView *multiTextView;

@end
