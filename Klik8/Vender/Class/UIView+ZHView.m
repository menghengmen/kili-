
#import "UIView+ZHView.h"

@implementation UIView (ZHView)

- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin{
    return self.frame.origin;
}

- (void)setCenterX:(CGFloat)centerX{
    CGPoint center=self.center;
    center.x=centerX;
    self.center=center;
}

- (CGFloat)centerX{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY{
    CGPoint center=self.center;
    center.y=centerY;
    self.center=center;
}

- (CGFloat)centerY{
    return self.center.y;
}

- (CGFloat)minX{
    return CGRectGetMinX(self.frame);
}

- (CGFloat)minY{
    return CGRectGetMinY(self.frame);
}

- (CGFloat)maxX{
    return CGRectGetMaxX(self.frame);
}

-(CGFloat)maxY{
    return CGRectGetMaxY(self.frame);
}

- (void)cornerRadius{
    [self cornerRadiusWithFloat:-1 borderColor:nil borderWidth:0];
}
- (void)cornerRadiusWithFloat:(CGFloat)vaule{
    [self cornerRadiusWithFloat:vaule borderColor:nil borderWidth:0];
}
- (void)cornerRadiusWithBorderColor:(UIColor *)color borderWidth:(CGFloat)width{
    [self cornerRadiusWithFloat:-1 borderColor:color borderWidth:width];
}
- (void)cornerRadiusWithFloat:(CGFloat)vaule borderColor:(UIColor *)color borderWidth:(CGFloat)width{
    if (vaule==-1) {
        if(self.frame.size.height==0||self.frame.size.width==0){
            
        }else if(self.frame.size.height==self.frame.size.width){
            self.layer.cornerRadius=self.frame.size.height/2.0;
        }
    }else{
        self.layer.cornerRadius=vaule;
    }
    
    if (color!=nil) {
        self.layer.borderColor=[color CGColor];
    }
    
    if(width!=0){
        self.layer.borderWidth=width;
    }
    
    self.layer.masksToBounds=YES;
}


//为view添加点击手势
- (UITapGestureRecognizer *)addUITapGestureRecognizerWithTarget:(id)target withAction:(SEL)action{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled=YES;
    return tap;
}

//为view添加长按手势
- (UILongPressGestureRecognizer *)addUILongPressGestureRecognizerWithTarget:(id)target withAction:(SEL)action withMinimumPressDuration:(double)minimumPressDuration{
    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:target action:action];
    longPress.minimumPressDuration=minimumPressDuration;
    [self addGestureRecognizer:longPress];
    self.userInteractionEnabled=YES;
    return longPress;
}

-(UIViewController *)getViewController{
    for (UIView *view = self.superview; view; view = view.superview) {
        UIResponder *responder = [view nextResponder];
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}

- (UIVisualEffectView *)addBlurEffectWithAlpha:(CGFloat)alpha{
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.alpha=alpha;
    effectview.frame = CGRectMake(-1, -1, self.width+2, self.height+2);
    effectview.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:effectview];
    return effectview;
}

- (void)rotationAnimationDuration:(CGFloat)duration repeatCount:(CGFloat)repeatCount{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue=[NSNumber numberWithFloat: 0 ];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI*2 ];
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.duration = duration;
    rotationAnimation.repeatCount = repeatCount;
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:rotationAnimation forKey:@"Rotation"];
}
- (void)rotationAnimationFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(CGFloat)duration{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue=[NSNumber numberWithFloat: fromValue ];
    rotationAnimation.toValue = [NSNumber numberWithFloat: toValue ];
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.duration = duration;
    rotationAnimation.repeatCount = 1;
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:rotationAnimation forKey:@"Rotation"];
}
- (void)setAnchorPoint:(CGPoint)anchorpoint{
    CGRect oldFrame= self.frame;
    self.layer.anchorPoint = anchorpoint;
    self.frame = oldFrame;
}
- (void)addAutoresizingMask{
    self.autoresizingMask=
    UIViewAutoresizingFlexibleLeftMargin|
    UIViewAutoresizingFlexibleWidth|
    UIViewAutoresizingFlexibleRightMargin|
    UIViewAutoresizingFlexibleTopMargin|
    UIViewAutoresizingFlexibleHeight|
    UIViewAutoresizingFlexibleBottomMargin;
}
@end
