//
//  MultilineTextViewContainerViewController.m
//  Multiline-TextView
//
//  Created by Mounir Dellagi on 14.10.13.
//  Copyright (c) 2013 Mounir Dellagi. All rights reserved.
//

#import "MDMultilineTextViewDelegateController.h"

@interface MDMultilineTextViewDelegateController ()

@property (nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutConstraint;

@end

@implementation MDMultilineTextViewDelegateController {
    id keyboardShowObserver;
    id keyboardHideObserver;
}

#pragma mark - Keyboard Handling
/** Handling the text view position relative to the keyboard */
- (void)keyboardHandling
{
    keyboardShowObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        NSDictionary *info = [note userInfo];
        CGSize kbSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        self.bottomLayoutConstraint.constant += kbSize.height;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        [UIView setAnimationCurve:[note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        [self.view layoutIfNeeded];
        
        [UIView commitAnimations];
        
    }];
    
    keyboardHideObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        NSDictionary *info = [note userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        self.bottomLayoutConstraint.constant -= kbSize.height;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        [UIView setAnimationCurve:[note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        [self.view layoutIfNeeded];
        
        [UIView commitAnimations];
        
    }];
}

#pragma mark - Text View Delegate
- (void)textViewDidChange:(UITextView *)textView
{
    // Tell layout system that size changed
    if (self.multiTextView.contentSize.height < self.multiTextView.maxHeight) {
        [self.multiTextView invalidateIntrinsicContentSize];
    }
    
    [self.multiTextView scrollRectToVisible:CGRectMake(0.0, self.multiTextView.contentSize.height - 1.0f, 1.0, 1.0) animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self keyboardHandling];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:keyboardShowObserver];
    [center removeObserver:keyboardHideObserver];
    
    keyboardShowObserver = nil;
    keyboardHideObserver = nil;
}

@end
