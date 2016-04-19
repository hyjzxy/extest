//
//  HYDef.h
//  HuaYue
//
//  Created by 崔俊红 on 15-3-28.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#ifndef HuaYue_HYDef_h
#define HuaYue_HYDef_h

#define  N2V(_A,_D) ((_A)==nil || (NSNull*)(_A)==[NSNull null]) ?(_D):(_A)

#define KString static NSString *const
//119 197 221
#define  ViewFromXib(NibName,Index) ([[NSBundle mainBundle]loadNibNamed:(NibName) owner:nil options:nil][(Index)])
#define ViewWithTag(TYPE,V,TAG) (TYPE)[(V) viewWithTag:(TAG)]

#define Point(_x_,_y_) CGPointMake((_x_),(_y_))
#define Size(_w,_h) CGSizeMake((_w),(_h))
#define Rect(_x,_y,_w,_h) CGRectMake((_x),(_y),(_w),(_h))
#define RectSzie(_w,_h) CGRectMake(0,0,(_w),(_h))
#define RectPoint(_x,_y) CGRectMake((_x),(_y),0,0)
#define VMinX(_v) CGRectGetMinX((_v.)frame)
#define VMinY(_v) CGRectGetMinY((_v).frame)
#define VMaxX(_v) CGRectGetMaxX((_v).frame)
#define VMaxY(_v) CGRectGetMaxY((_v).frame)
#define VMidX(_v) CGRectGetMidX((_v).frame)
#define VMidY(_v) CGRectGetMidY((_v).frame)
#define VWidth(_v) CGRectGetWidth((_v).frame)
#define VHeight(_v) CGRectGetHeight((_v).frame)
#define FMinX(_f) CGRectGetMinX((_f))
#define FMinY(_f) CGRectGetMinY((_f))
#define FMaxX(_f) CGRectGetMaxX((_f))
#define FMaxY(_f) CGRectGetMaxY((_f))
#define FMidX(_f) CGRectGetMidX((_f))
#define FMidY(_f) CGRectGetMidY((_f))
#define FWidth(_f) CGRectGetWidth((_f))
#define FHeight(_f) CGRectGetHeight((_f))

#endif
