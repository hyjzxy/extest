//
//  UIView+Cate.m
//  HuaYue
//
//  Created by 崔俊红 on 15/4/20.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "UIView+Cate.h"
#import <objc/runtime.h>
#import "Masonry.h"
#import "NSObject+Cate.h"
#import "MZApp.h"

static char *BADGKEY = "BADGKEY";

@implementation UIView (Cate)
@dynamic tapBlock;

- (void)setMHeight:(CGFloat)h
{
    CGRectSetHeight(self, h);
}

- (mzm_block_t)tapBlock
{
    return objc_getAssociatedObject(self, @selector(tapBlock));
}

- (void)setTapBlock:(mzm_block_t)newTapBlock
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    objc_setAssociatedObject(self, @selector(tapBlock), newTapBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setCornerWidth:(CGFloat)borderWith
{
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = borderWith;
    self.layer.borderColor = [[UIColor colorWithWhite:0.000 alpha:0.300]CGColor];
    self.layer.cornerRadius = MAX(VHeight(self), VWidth(self))*0.5;
}

- (void)setCornerWidh:(CGFloat)borderWith
{
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = borderWith;
    self.layer.cornerRadius = MAX(VHeight(self), VWidth(self))*0.5;
}

- (void)setCornerGray:(CGFloat)borderWith
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4.0f;
    self.layer.borderColor = [UIColor colorWithWhite:0.901 alpha:1.000].CGColor;
    self.layer.borderWidth = borderWith;
}

- (void)setCorner:(id)t
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4.0f;
}


- (void)setCornerF:(CGFloat)t
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = t;
}

- (void)setShodow:(id)t
{
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [[UIColor blackColor]CGColor];
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowOffset = CGSizeMake(4,4);
    self.layer.shadowRadius = 4.0f;
}

- (void)setDialog:(id)t
{
    /*
    UIView *shadowView = [[UIView alloc]init];
    shadowView.layer.cornerRadius = 4.0f;
    shadowView.layer.masksToBounds = NO;
    shadowView.layer.shadowColor = [[UIColor yellowColor]CGColor];
    shadowView.layer.shadowOpacity = 0.3;
    shadowView.layer.shadowOffset = CGSizeMake(4,4);
    shadowView.layer.shadowRadius = 4.0f;
    [self addSubview:shadowView];
    WS(ws);
    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws);
    }];*/
}

- (void)setLeftImage:(NSString*)imgeName
{
    if ([self isKindOfClass:[UITextField class]]) {
        UITextField *tmp = (UITextField*)self;
        tmp.leftViewMode = UITextFieldViewModeAlways;
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 75, VHeight(self))];
        UIImageView *left  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgeName]];
        left.contentMode = UIViewContentModeScaleAspectFit;
        left.frame = Rect(0, 0, VHeight(self), VHeight(self));
        [leftView addSubview:left];
        UILabel *line = [[UILabel alloc]initWithFrame:Rect(0, 0, 1, VHeight(self))];
        line.backgroundColor =  [UIColor colorWithWhite:0.901 alpha:1.000];
        line.frame = CGRectInset(CGRectOffset(line.frame, VWidth(leftView)-10, 0),0,15.0f);
        [leftView addSubview:line];
        left.center = leftView.center;
        left.frame = CGRectOffset(CGRectInset(left.frame, 10, 10), -5, 0);
        tmp.leftView = leftView;
    }
}

- (void)setLeftInputSpace:(NSInteger)space
{
    if ([self isKindOfClass:[UITextField class]]) {
        UITextField *tmp = (UITextField*)self;
        tmp.leftViewMode = UITextFieldViewModeAlways;
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, space, VHeight(self))];
        tmp.leftView = leftView;
    }
}

- (void)tapGes:(UITapGestureRecognizer*)ges
{
    if (self.tapBlock) {
        self.tapBlock(self);
    }
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next =
         next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController
                                         class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

/**
 *  @author 麦子, 15-05-22 20:05:05
 *
 *  @brief  小贴士
 *
 *  @param tsStr  贴士信息
 *  @param tsType 贴士类型
 *
 *  @since v1.0
 */
- (void)mTSWithType:(TSType)tsType
{
    NSArray *TSInfo = @[@"友情提示：点击聊天框可以选择追问的对象哦！",
                        @"助手贴士：如您有需要共享的实验室相关法规或文献，还请联系助手QQ:2076938360",
                        @"助手贴士：本版块搜罗了国内外主要实验室仪器设备，试剂耗材品牌及代理商，可点击下方图标或搜索了解详细信息。",
                        @"助手贴士：每次只能@3位高手回答问题",
                        @"助手贴士：实物礼品以快递的方式送达，学习资料会通过邮件的形式送达。请务必填写正确的信息。如有问题，可联系助手客服QQ：2076938360",
                        @"助手贴士：不建议频繁修改昵称，昵称诚可贵，且改且珍惜!",
                        @"助手贴士：请准确填写认证信息，以便后台工作人员与您确认核实，实名认证后您可以享受：积分翻倍、实名认证标识、显示认证信息、商城高级礼品换购等特权！如有问题，请联系客服QQ：2076938360",
                        @"助手贴士：记得采纳满意的答案哦！可以获得5积分哦！若有悬赏，采纳后返还20%悬赏积分分值。",
                        @"助手贴士：如您需搜索多个关键词，还请在关键词之间加”空格“"];
    BOOL isEx = NO;
    switch (tsType) {
        case kTSAddQuest:
            isEx = [MZApp share].isTSAddQuest;
            break;
        case kTSPPK:
            isEx = [MZApp share].isTSPPK;
            break;
        case kTSGS:
            isEx = [MZApp share].isTSGS;
            break;
        case kTSKD:
            isEx = [MZApp share].isTSKD;
            break;
        case kTSNC:
            isEx = [MZApp share].isTSNC;
            break;
        case kTSSM:
            isEx = [MZApp share].isTSSM;
            break;
        case kTW:
            isEx = [MZApp share].isTW;
            break;
        case kTSearch:
            isEx = [MZApp share].isTSearch;
            break;
        default:
            break;
    }
    if (!isEx) {
        UIView *tsView = [[UIView alloc]init];
        tsView.backgroundColor = UIColorFromRGB(0xF1707C);
        [self addSubview:tsView];
        WS(ws);
        [tsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.equalTo(ws).with.offset(2);
            make.trailing.equalTo(ws).with.offset(-2);
        }];
        UILabel *tsLabel = [[UILabel alloc]init];
        tsLabel.textColor = [UIColor whiteColor];
        tsLabel.font = SYSTEMFONT(12.0f);
        tsLabel.backgroundColor = [UIColor clearColor];
        tsLabel.textAlignment = NSTextAlignmentLeft;
        tsLabel.numberOfLines = 0;
        tsLabel.lineBreakMode = NSLineBreakByWordWrapping;
        NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc]initWithString:TSInfo[tsType]];
        switch (tsType) {
            case kTSAddQuest:
            case kTSPPK:
            case kTSFGWX:
            case kTSGS:
            case kTSKD:
            case kTSNC:
            case kTSSM:
            case kTSearch:
                [mAttr setAttributes:@{NSFontAttributeName:BOLDSYSTEMFONT(12)} range:NSMakeRange(0, 5)];
                break;
            default:
                break;
        }
        tsLabel.attributedText = mAttr;
        [tsView addSubview:tsLabel];
        [tsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.equalTo(tsView).with.offset(5);
            make.bottom.equalTo(tsView).with.offset(-5);
        }];
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [tsView addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.greaterThanOrEqualTo(tsLabel.mas_trailing).with.offset(2.0f);
            make.centerY.equalTo(tsLabel);
            make.trailing.equalTo(tsView);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        closeBtn.info = @{@"TSType":@(tsType)};
        [closeBtn addTarget:self action:@selector(readTS:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        mzm_block_t block = self.info[@"CALL"];
        if (block) {
            block(nil);
        }
        [self removeFromSuperview];
    }
}

- (void)readTS:(UIButton*)btn
{
    NSInteger tsType = [btn.info[@"TSType"]integerValue];
    switch (tsType) {
        case kTSAddQuest:
            [MZApp share].isTSAddQuest = YES;
            break;
        case kTSPPK:
            [MZApp share].isTSPPK = YES;
            break;
        case kTSGS:
            [MZApp share].isTSGS = YES;
            break;
        case kTSKD:
            [MZApp share].isTSKD = YES;
            break;
        case kTSNC:
            [MZApp share].isTSNC = YES;
            break;
        case kTSSM:
            [MZApp share].isTSSM = YES;
            break;
        case kTW:
            [MZApp share].isTW = YES;
            break;
        case kTSearch:
            [MZApp share].isTSearch = YES;
        default:
            break;
    }
    mzm_block_t block = self.info[@"CALL"];
    if (block) {
        block(nil);
    }
    [self removeFromSuperview];
}

// 添加所有的手势
- (void) addGestureRecognizerToView
{
    
    [self setUserInteractionEnabled:YES];
    [self setMultipleTouchEnabled:YES];
    // 旋转手势
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
    [self addGestureRecognizer:rotationGestureRecognizer];
    
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self addGestureRecognizer:pinchGestureRecognizer];
    
    // 移动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self addGestureRecognizer:panGestureRecognizer];
}

// 处理旋转手势
- (void) rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    UIView *view = rotationGestureRecognizer.view;
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        [rotationGestureRecognizer setRotation:0];
    }
}

// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}

// 处理拖拉手势
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}

/**
 *  @author 麦子, 15-07-12 10:07:27
 *
 *  @brief  添加Badge
 *
 *  @param badge 显示数
 *
 *  @since v1.0
 */
/*
- (void)setBadge:(NSString*)badge
{
    objc_setAssociatedObject(self, &BADGKEY, badge, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addObserver:self forKeyPath:@"badge" options:NSKeyValueObservingOptionNew context:nil];
}

- (NSString*)badge
{
    return objc_getAssociatedObject(self, &BADGKEY);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@"badge"]) {
        BOOL isFinished=[[change objectForKey:NSKeyValueChangeNewKey] intValue];
        if (isFinished) {
        }
    }else{
        // be sure to call the super implementation
        // if the superclass implements it
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

- (void)dealloc
{
 
    
}*/
@end
