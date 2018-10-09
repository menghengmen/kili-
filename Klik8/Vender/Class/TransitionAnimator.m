#import "TransitionAnimator.h"

@implementation TransitionAnimator

- (instancetype)init {
    if (self = [super init]) {
        self.duration = 0.3;
        self.presenting = YES;
        self.originFrame = CGRectZero;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView;
    UIView *toView;
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        // iOS8以上用此方法准确获取
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    }
    else {
        fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
        toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    }
    
    UIView *pictureView = self.presenting ? toView : fromView;
    CGFloat scaleX = CGRectGetWidth(pictureView.frame) ? CGRectGetWidth(self.originFrame) / CGRectGetWidth(pictureView.frame) : 0;
    CGFloat scaleY = CGRectGetHeight(pictureView.frame) ? CGRectGetHeight(self.originFrame) / CGRectGetHeight(pictureView.frame) : 0;
    CGAffineTransform transform = CGAffineTransformMakeScale(scaleX, scaleY);
    CGPoint orginCenter = CGPointMake(CGRectGetMidX(self.originFrame), CGRectGetMidY(self.originFrame));
    CGPoint pictureCenter = CGPointMake(CGRectGetMidX(pictureView.frame), CGRectGetMidY(pictureView.frame));;
    
    CGAffineTransform startTransform;
    CGPoint startCenter;
    CGAffineTransform endTransform;
    CGPoint endCenter;
    if (self.presenting) {
        startTransform = transform;
        startCenter = orginCenter;
        endTransform = CGAffineTransformIdentity;
        endCenter = pictureCenter;
    }
    else {
        startTransform = CGAffineTransformIdentity;
        startCenter = pictureCenter;
        endTransform = transform;
        endCenter = orginCenter;
    }
    
    UIView *container = [transitionContext containerView];
    [container addSubview:toView];
    [container bringSubviewToFront:pictureView];
    
    pictureView.transform = startTransform;
    pictureView.center = startCenter;
    toView.alpha=0;
    fromView.alpha=1.0;
    [UIView animateWithDuration:self.duration animations:^{
        pictureView.transform = endTransform;
        pictureView.center = endCenter;
        toView.alpha=1;
        fromView.alpha=0.5;
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}

@end
