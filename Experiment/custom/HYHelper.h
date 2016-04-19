//
//  HYHelper.h
//  HuaYue
//
//  Created by 崔俊红 on 15-4-5.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^mz_block_t) (id);

#define REG_EMAIL   @"^[A-Za-z\\d]+([-_\.][A-Za-z\\d]+)*@([A-Za-z\\d]+[-\.])+[A-Za-z\\d]{2,5}$"
#define REG_TEL @"^1[0-9]{10}$"
#define REG_PWD  @"^[\x20-\x7E]{6,20}$"
#define REG_CASH  @"^[0-9]+\\.?0+$"
#define REG_CODE  @"^[0-9]+$"

@interface HYHelper : NSObject
+ (NSAttributedString*)mAnswerAttach:(NSInteger)number;
+ (BOOL)mLoginID:(mz_block_t)block;
+ (BOOL)isSameName:(NSString*)name;
+ (void)mShowImage:(NSURL*)iURL m:(UIImageView*)mIV;
+ (void)pushPersonCenterOnVC:(UIViewController*)vc uid:(int)uid;
+ (void)mSuperList:(UILabel*)label supers:(NSString*)supers;
+ (NSString*)mNickLable:(NSString*)oNickName userId:(id)userId;
+ (NSAttributedString*)mBuildAnswerWithDic:(NSDictionary*)data isImage:(BOOL)isImage;
+ (NSAttributedString*)mBuildLable:(NSString*)lable font:(UIFont*)font;
+ (NSAttributedString*)mBuildAnswer:(NSString *)lable font:(UIFont *)font userId:(id)userId isAnswer:(BOOL)isAnswer;
+ (NSAttributedString*)mBuildAnswerNick:(NSString *)lable font:(UIFont *)font nickname:(NSString*)nickname isAnswer:(BOOL)isAnswer;
+ (void)mSetLevelLabel:(UILabel*)label level:(id)level;
+ (void)mSetVImageView:(UIImageView*)iv v:(id)v head:(UIView*)head;
+ (NSData*)imageCompressWithImage:(UIImage*)image;
+ (UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;
+ (UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
+ (void)mCheckVersionUpdate;
+ (BOOL)mTestWithReg:(NSString*)regStr withStr:(NSString*)str;
@end
