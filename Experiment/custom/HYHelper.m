//
//  HYHelper.m
//  HuaYue
//
//  Created by 崔俊红 on 15-4-5.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "HYHelper.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UIView+Cate.h"
#import "XHMyselfViewController.h"
#import "UIAlertView+Block.h"
#import "Masonry.h"
#import "NSObject+Cate.h"
@implementation HYHelper
+ (NSAttributedString*)mAnswerAttach:(NSInteger)number
{
    UIFont *font  = SYSTEMFONT(12);
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" %ld人回答",(long)number] attributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:SYSTEMFONT(12)}];
    NSTextAttachment *answerAtt = [[NSTextAttachment alloc]init];
    answerAtt.image = [UIImage imageNamed:@"answer_pingjia"];
    answerAtt.bounds = Rect(0, 0, font.lineHeight, font.lineHeight);
    [att insertAttributedString:[NSAttributedString attributedStringWithAttachment:answerAtt]  atIndex:0];
    return att;
}


+ (void)mShowImage:(NSURL*)iURL m:(UIImageView*)mIV
{
    UIView *mv = [[UIView alloc]init];
    mv.backgroundColor = [UIColor blackColor];
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView addGestureRecognizerToView];
    iURL?[imageView setImageWithURL:iURL usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]:(imageView.image = mIV.image);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIWindow *mainWin = [UIApplication sharedApplication].keyWindow;
    imageView.frame = mainWin.bounds;
    mv.frame = mainWin.bounds;
    [mv addSubview:imageView];
    [mainWin addSubview:mv];
    mv.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    mv.alpha = 0.3f;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0.9 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        mv.transform = CGAffineTransformIdentity;
        mv.alpha = 1;
    } completion:nil];
    mv.tapBlock = ^(UIView *mIV) {
        [UIView animateWithDuration:0.2 animations:^{
            mIV.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
            mIV.alpha = 0.3f;
        } completion:^(BOOL finished) {
            [mIV removeFromSuperview];
        }];
    };
}

+ (BOOL)isSameName:(NSString*)name
{
    NSString *uname = [[NSUserDefaults standardUserDefaults]stringForKey:USERNAME];
    if (uname) {
        return [uname isEqualToString:name];
    }
    return NO;
}

+ (BOOL)mLoginID:(mz_block_t)block
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
    // 已登录
    if(uid && [uid stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>0){
        if (block) {
            block(uid);
        }
        return YES;
    }else{// 未登录
        if (block) {
            block(nil);
        }
        return NO;
    }
}

+ (void)pushPersonCenterOnVC:(UIViewController*)vc uid:(int)uid
{
    if ([HYHelper mLoginID:nil]){
        XHMyselfViewController *control = [[XHMyselfViewController alloc] initWithwithUID:uid];
        [vc.navigationController pushViewController:control animated:YES];
    } else {
        [BMUtils showError:@"您还没有登录"];
    }

}

+ (void)mSuperList:(UILabel*)label supers:(NSString*)supers
{
    if (label && supers && supers.length>0) {
        NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc]initWithString:@"邀请" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:label.font}];
        [mAttr appendAttributedString:[[NSAttributedString alloc]initWithString:supers attributes:@{NSFontAttributeName:label.font,NSForegroundColorAttributeName:UIColorFromRGB(0x46BDE3)}]];
        [mAttr appendAttributedString:[[NSAttributedString alloc]initWithString:@"回答" attributes:@{NSFontAttributeName:label.font,NSForegroundColorAttributeName:[UIColor grayColor]}]];
        label.attributedText = mAttr;
    }
}

+ (NSString*)mNickLable:(NSString*)oNickName userId:(id)userId
{
    __block NSString *nickName = oNickName;
    [HYHelper mLoginID:^(id uid) {
        if (uid != nil && [uid integerValue] ==[userId integerValue]) {
            nickName = @"我";
        }
    }];
    return nickName;
}

+ (NSAttributedString*)mBuildLable:(NSString*)lable font:(UIFont *)font
{
    NSMutableAttributedString *label = [[NSMutableAttributedString alloc]init];
    [label appendAttributedString:[[NSAttributedString alloc]initWithString:@"标签：" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor grayColor]}]];
    [label appendAttributedString:[[NSAttributedString alloc]initWithString:(lable == nil || lable.length==0?@"空":lable) attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor colorWithRed:0.164 green:0.863 blue:1.000 alpha:1.000]}]];
    return label;
}

+ (NSAttributedString*)mBuildAnswerWithDic:(NSDictionary*)data isImage:(BOOL)isImage
{
    UIColor *supperlistColor = [UIColor colorWithRed:0.165 green:0.863 blue:1.000 alpha:1.000];
    UIFont *font = SYSTEMFONT(14.0f);
    NSString *supperlist = N2V(data[@"ansupperlist"],@"");
    if([supperlist stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length >0) {
        supperlist = [supperlist stringByAppendingString:@": "];
    }
    NSMutableAttributedString *label = [[NSMutableAttributedString alloc]initWithString:supperlist attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:supperlistColor}];
    if (isImage) {
        [label appendAttributedString:[[NSAttributedString alloc]initWithString:@"【图片】" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor blackColor]}]];
    }else{
        [label appendAttributedString:[[NSAttributedString alloc]initWithString:data[@"content"] attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor blackColor]}]];
    }
    return label;
}

+ (NSAttributedString*)mBuildAnswer:(NSString *)lable font:(UIFont *)font userId:(id)userId isAnswer:(BOOL)isAnswer
{
    __block NSString *nickName = @"TA";
    [HYHelper mLoginID:^(id uid) {
        if (uid != nil && [uid integerValue] ==[userId integerValue]) {
            nickName = @"我";
        }
    }];
    NSMutableAttributedString *label = [[NSMutableAttributedString alloc]init];
    [label appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@的%@：",nickName,isAnswer?@"回答":@"追问"] attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor colorWithRed:1.000 green:0.347 blue:0.259 alpha:1.000]}]];
    if ([lable stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0 ) {
        /*NSTextAttachment *attach = [[NSTextAttachment alloc]init];
        attach.image = [UIImage imageNamed:@"icon"];
        attach.bounds = CGRectMake(2, 0, font.pointSize, font.pointSize);
        [label appendAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];*/
        [label appendAttributedString:[[NSAttributedString alloc]initWithString:@"【图片】" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor blackColor]}]];
    }else{
        [label appendAttributedString:[[NSAttributedString alloc]initWithString:lable attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor grayColor]}]];
    }
    return label;
}

+ (NSAttributedString*)mBuildAnswerNick:(NSString *)lable font:(UIFont *)font nickname:(NSString*)nickname isAnswer:(BOOL)isAnswer
{
    NSMutableAttributedString *label = [[NSMutableAttributedString alloc]init];
    [label appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@的%@：",nickname,isAnswer?@"回答":@"追问"] attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor colorWithRed:1.000 green:0.347 blue:0.259 alpha:1.000]}]];
    if ([lable stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0 ) {
        /*NSTextAttachment *attach = [[NSTextAttachment alloc]init];
        attach.image = [UIImage imageNamed:@"icon"];
        attach.bounds = CGRectMake(2, 0, font.pointSize, font.pointSize);
        [label appendAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];*/
        [label appendAttributedString:[[NSAttributedString alloc]initWithString:@"【图片】" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor blackColor]}]];
    }else{
        [label appendAttributedString:[[NSAttributedString alloc]initWithString:lable attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor grayColor]}]];
    }
    return label;
}

/**
 *  @author 麦子收割队-崔俊红, 15-05-11 16:05:44
 *
 *  @brief  设置Rank
 *  @param label UILabel
 *  @param level 等级数
 *  @since v1.0
 */
+ (void)mSetLevelLabel:(UILabel*)label level:(id)level
{
    [label.superview layoutIfNeeded];
    if (!level) { level = @"0";}
    label.backgroundColor = UIColorFromRGB(0x93C477);
    label.textColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@" Lv%d ",[level intValue]];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 2.0f;
    label.layer.borderColor = nil;
    label.layer.borderWidth = 0.0f;
    label.font = SYSTEMFONT(8);
    [label sizeToFit];
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@10);
    }];
    CGRectSetHeight(label, 10);
    [label.superview layoutIfNeeded];}

/**
 *  @author 麦子收割队-崔俊红, 15-05-11 16:05:07
 *
 *  @brief  设置用户级别
 *  @param iv 级别图片
 *  @param v  级别
 *  @since v1.0
 */
+ (void)mSetVImageView:(UIImageView*)iv v:(id)v head:(UIView*)head
{
    if (!v) {return;}
    [iv setImage:nil];
    [head.info[@"tmp"] removeFromSuperview];
    switch ([v integerValue]) {
        case 20:
            [iv setImage:[UIImage imageNamed:@"v_profile"]];
            break;
        case 21:
            [iv setImage:[UIImage imageNamed:@"v"]];
            break;
        case 4:
            [iv setImage:[UIImage imageNamed:@"edit_v"]];
            break;
        case 5:
        {
            head.layer.borderColor = [UIColor clearColor].CGColor;
            UIImageView *bv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"crownexpert"]];
            head.info = @{@"tmp":bv};
            [head.superview insertSubview:bv aboveSubview:head];
            [bv mas_updateConstraints:^(MASConstraintMaker *make) {
                make.leading.top.equalTo(head);
                make.trailing.equalTo(head);
                make.height.equalTo(head).multipliedBy(1.33f);
                make.bottom.lessThanOrEqualTo(head.superview.mas_bottom).with.offset(-5);
            }];
            break;
        }
        case 6:
        {
            head.layer.borderColor = [UIColor clearColor].CGColor;
            UIImageView *bv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"crownbeta"]];
            head.info = @{@"tmp":bv};
            [head.superview insertSubview:bv aboveSubview:head];
            [bv mas_updateConstraints:^(MASConstraintMaker *make) {
                make.leading.top.equalTo(head);
                make.trailing.equalTo(head);
                make.height.equalTo(head).multipliedBy(1.33f);
                make.bottom.lessThanOrEqualTo(head.superview.mas_bottom).with.offset(-5);
            }];
            break;
        }
        case 7:
        {
            head.layer.borderColor = [UIColor clearColor].CGColor;
            UIImageView *bv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"crownboss"]];
            head.info = @{@"tmp":bv};
            [head.superview insertSubview:bv aboveSubview:head];
            [bv mas_updateConstraints:^(MASConstraintMaker *make) {
                make.leading.top.equalTo(head);
                make.trailing.equalTo(head);
                make.height.equalTo(head).multipliedBy(1.33f);
                make.bottom.lessThanOrEqualTo(head.superview.mas_bottom).with.offset(-5);
            }];
            break;
        }
        default:
            break;
    }
}

+(NSData*)imageCompressWithImage:(UIImage*)image {
    int MIN_UPLOAD_RESOLUTION = 960 * 640;
    int MAX_UPLOAD_SIZE = 100*1024;
    
    float factor;
    float currentResolution = image.size.height * image.size.width;
    
    //We first shrink the image a little bit in order to compress it a little bit more
    if (currentResolution > MIN_UPLOAD_RESOLUTION) {
        factor = sqrt(currentResolution / MIN_UPLOAD_RESOLUTION) * 2;
        image = [self scaleDown:image withSize:CGSizeMake(image.size.width / factor, image.size.height / factor)];
    }
    
    //Compression settings
    CGFloat compression = 0.75;
    CGFloat maxCompression = 0.1;
    
    //We loop into the image data to compress accordingly to the compression ratio
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > MAX_UPLOAD_SIZE && compression > maxCompression) {
        compression -= 0.10;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    //Retuns the compressed image
    return imageData;
}

+ (UIImage*)scaleDown:(UIImage*)image withSize:(CGSize)newSize
{
    
    //We prepare a bitmap with the new size
    UIGraphicsBeginImageContextWithOptions(newSize, YES, 0.0);
    
    //Draws a rect for the image
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    //We set the scaled image from the context
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

+(UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}


+ (void)mCheckVersionUpdate
{
    
    NSString *currVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://itunes.apple.com/lookup?id=979792470"]];
    [request setHTTPMethod:@"POST"];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (error) {
                                   NSLog(@"ErrorCode:%ld %@",(long)error.code,error.localizedDescription);
                               }else{
                                   NSError *error;
                                   NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                   if (dataDic && !error) {
                                       NSNumber *resultCount = dataDic[@"resultCount"];
                                       if (resultCount.integerValue>0) {
                                           NSString *lastVersion = dataDic[@"results"][0][@"version"];
                                           NSString *releaseNote = dataDic[@"results"][0][@"releaseNotes"];
                                           NSString *updateURL = dataDic[@"results"][0][@"trackViewUrl"];
                                           if ([lastVersion compare:currVersion]==NSOrderedDescending) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   [[UIAlertView mBuildWithTitle:@"版本更新" msg:releaseNote okTitle:@"暂不" noTitle:@"更新" cancleBlock:nil okBlock:^{
                                                       [[UIApplication sharedApplication]openURL:[NSURL URLWithString:updateURL]];
                                                   }]show];
                                               });
                                           }
                                       }
                                   }
                               }
                           }];
}

+ (BOOL)mTestWithReg:(NSString*)regStr withStr:(NSString*)str
{
    if (str==nil) {
        return NO;
    }
    NSRegularExpression *exgExp = [NSRegularExpression regularExpressionWithPattern:regStr options:kNilOptions error:nil];
    return [exgExp matchesInString:str options:kNilOptions range:NSMakeRange(0, str.length)].count>0;
}
@end