@import UIKit;

@interface TransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

/// 动画时间
@property (nonatomic, assign) CGFloat duration;

/// 图片原位置
@property (nonatomic, assign) CGRect originFrame;

/// 展示或消失
@property (nonatomic, assign) BOOL presenting;

@end
