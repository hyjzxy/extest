//
//  DailyBoothViewController.h
//  RaisedCenterTabBar
//
//  Created by Peter Boctor on 12/15/10.
//
// Copyright (c) 2011 Peter Boctor
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE
//

#import "BaseViewController.h"

@interface DailyBoothViewController : BaseViewController
{
    
}

@property (nonatomic, strong) NSDictionary *messageNumDict;

/** 回答数*/
@property (nonatomic, assign) NSInteger aNum;
/** 品牌数*/
@property (nonatomic, assign) NSInteger bNum;
/** 日报数*/
@property (nonatomic, assign) NSInteger dNum;
/** 粉丝求助数*/
@property (nonatomic, assign) NSInteger fNum;
/** 关注数*/
@property (nonatomic, assign) NSInteger gNum;
/** 系统消息数*/
@property (nonatomic, assign) NSInteger mNum;
/** 法规文献数*/
@property (nonatomic, assign) NSInteger nNum;
/** 活动中心数*/
@property (nonatomic, assign) NSInteger pNum;
/** 提问数*/
@property (nonatomic, assign) NSInteger qNum;
/** 培训信息数*/
@property (nonatomic, assign) NSInteger tNum;
/** 周刊数*/
@property (nonatomic, assign) NSInteger wNum;
/** 追问我的数*/
@property (nonatomic, assign) NSInteger afternum;
/** 排行榜数*/
@property (nonatomic, assign) NSInteger chartnum;

@property (nonatomic, assign) NSInteger meSum;
@property (nonatomic, assign) NSInteger findSum;
@property(nonatomic, assign) NSInteger status;

@property(nonatomic, strong)UILabel    *meCountLabel;
@property(nonatomic, strong)UILabel    *findCountLabel;

-(void)willAppearIn:(UINavigationController *)navigationController;

-(void)openTIWenView;

- (void)resetNotice;

@end
