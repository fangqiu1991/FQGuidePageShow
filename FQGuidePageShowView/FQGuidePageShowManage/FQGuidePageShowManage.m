//
//  FQGuidePageShowManage.m
//  FQGuidePageShowView
//
//  Created by mac on 2018/5/4.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FQGuidePageShowManage.h"

@interface FQGuidePageShowManage()

@property (nonatomic, copy) FinishBlock finish;
@property (nonatomic, copy) NSString *guidePageKey;
@property (nonatomic, assign) FQGuidePageType guidePageType;

@end

@implementation FQGuidePageShowManage

+ (instancetype)shareManager
{
    static FQGuidePageShowManage *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)showGuidePageWithType:(FQGuidePageType)type
{
    [self creatControlWithType:type completion:NULL];
}


- (void)showGuidePageWithType:(FQGuidePageType)type completion:(FinishBlock)completion
{
    [self creatControlWithType:type completion:completion];
}

- (void)creatControlWithType:(FQGuidePageType)type completion:(FinishBlock)completion
{
    _finish = completion;
    
    // 遮盖视图
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    
    // 信息提示视图
    UIImageView *imgView = [[UIImageView alloc] init];
    [bgView addSubview:imgView];
    
    // 第一个路径
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
    switch (type) {
        case FQGuidePageTypeHome:
            // 下一个路径，圆形
            [path appendPath:[UIBezierPath bezierPathWithArcCenter:KSuitPoint(227, 188) radius:KSuitFloat(46) startAngle:0 endAngle:2 * M_PI clockwise:NO]];
            imgView.frame = KSuitRect(220, 40, 100, 100);
            imgView.image = [UIImage imageNamed:@"hi"];
            _guidePageKey = FQGuidePageHomeKey;
            break;
            
        case FQGuidePageTypeMajor:
            // 下一个路径，矩形
            [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:KSuitRect(5, 436, 90, 40) cornerRadius:5] bezierPathByReversingPath]];
            imgView.frame = KSuitRect(100, 320, 120, 120);
            imgView.image = [UIImage imageNamed:@"ly"];
            _guidePageKey = FQGuidePageMajorKey;
            break;
            
        default:
            break;
    }
    
    // 绘制透明区域
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [bgView.layer setMask:shapeLayer];
}

- (void)tap:(UITapGestureRecognizer *)recognizer
{
    UIView *bgView = recognizer.view;
    [bgView removeFromSuperview];
    [bgView removeGestureRecognizer:recognizer];
    [[bgView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    bgView = nil;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:_guidePageKey];
    
    if (_finish) _finish();
}

@end
