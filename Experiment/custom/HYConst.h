//
//  HYConst.h
//  HuaYue
//
//  Created by 崔俊红 on 15-3-28.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "Reachability.h"
#ifndef HuaYue_HYConst_h
#define HuaYue_HYConst_h

KString kNotificationMainSave = @"kNotificationMainSave";
KString kCacheMainDSFileName = @"MainDSCache.ds";
KString kCacheMainBannerFileName = @"MainBannerCache.ds";
KString kQuestionFileName = @"QuestCache.ds";
typedef NS_ENUM(NSInteger, UpladType) {
    kUploadMember=1,  // 头像
    kUploadQuestion,    // 问题
    kUploadAnswer        // 回答
};

NS_INLINE NSString* NSDocFilePath(NSString *const fileName)
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingPathComponent:fileName];
}

NS_INLINE BOOL isEmptyDicForKey(NSDictionary *dic,NSString *key)
{
    return [dic[key] isEqualToString:@""] || [dic[key] isEqualToString:@"0"];
}

NS_INLINE void CGRectSetX(UIView* view, CGFloat x)
{
    CGRect rect = view.frame;
    rect.origin.x = x;
    view.frame = rect;
}

NS_INLINE void CGRectSetY(UIView* view, CGFloat y)
{
    CGRect rect = view.frame;
    rect.origin.y = y;
    view.frame = rect;
}

NS_INLINE void CGRectSetPoint(UIView* view, CGPoint point)
{
    CGRect rect = view.frame;
    rect.origin = point;
    view.frame = rect;
}

NS_INLINE void CGRectSetSize(UIView* view, CGSize size)
{
    CGRect rect = view.frame;
    rect.size = size;
    view.frame = rect;
}

NS_INLINE void CGRectSetWidth(UIView* view, CGFloat w)
{
    CGRect rect = view.frame;
    rect.size.width = w;
    view.frame = rect;
}

NS_INLINE void CGRectSetHeight(UIView* view, CGFloat h)
{
    CGRect rect = view.frame;
    rect.size.height = h;
    view.frame = rect;
}

NS_INLINE void CGRectExtLeft(UIView* view, CGFloat ext)
{
    CGRect rect = view.frame;
    rect.size.width -= ext;
    view.frame = rect;
}

NS_INLINE void CGRectExtRight(UIView* view, CGFloat ext)
{
    CGRect rect = view.frame;
    rect.size.width += ext;
    view.frame = rect;
}

NS_INLINE void CGRectExtTop(UIView* view, CGFloat ext)
{
    CGRect rect = view.frame;
    rect.size.height -= ext;
    view.frame = rect;
}

NS_INLINE void CGRectExtBottom(UIView* view, CGFloat ext)
{
    CGRect rect = view.frame;
    rect.size.height += ext;
    view.frame = rect;
}

NS_INLINE void CGRectScaleBottom(UIView* view, CGFloat ext)
{
    CGRect rect = view.frame;
    rect.origin.y = rect.origin.y + ext;
    rect.size.height -= ext;
    view.frame = rect;
}



NS_INLINE CGFloat heightForStr(NSString* text,CGFloat width,NSDictionary* attr) {
    return [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                     attributes:attr
                    context:nil].size.height;
}
#endif
