
#import <UIKit/UIKit.h>

@interface UIView (ZHView)

@property (assign, nonatomic) CGFloat x;

@property (assign, nonatomic) CGFloat y;

@property (assign, nonatomic) CGFloat width;

@property (assign, nonatomic) CGFloat height;

@property (assign, nonatomic) CGSize size;

@property (assign, nonatomic) CGPoint origin;

@property (assign, nonatomic)CGFloat centerX;

@property (assign, nonatomic)CGFloat centerY;

@property (assign, nonatomic,readonly)CGFloat minX;

@property (assign, nonatomic,readonly)CGFloat minY;

@property (assign, nonatomic,readonly)CGFloat maxX;

@property (assign, nonatomic,readonly)CGFloat maxY;

/**给控件设置成圆角*/
- (void)cornerRadius;

- (void)cornerRadiusWithFloat:(CGFloat)vaule;

- (void)cornerRadiusWithBorderColor:(UIColor *)color borderWidth:(CGFloat)width;

- (void)cornerRadiusWithFloat:(CGFloat)vaule borderColor:(UIColor *)color borderWidth:(CGFloat)width;

/**为view添加点击手势*/
- (UITapGestureRecognizer *)addUITapGestureRecognizerWithTarget:(id)target withAction:(SEL)action;

/**为view添加长按手势*/
- (UILongPressGestureRecognizer *)addUILongPressGestureRecognizerWithTarget:(id)target withAction:(SEL)action withMinimumPressDuration:(double)minimumPressDuration;

/**获取ViewController*/
-(UIViewController *)getViewController;

/**添加毛玻璃效果*/
- (UIVisualEffectView *)addBlurEffectWithAlpha:(CGFloat)alpha;

- (void)rotationAnimationDuration:(CGFloat)duration repeatCount:(CGFloat)repeatCount;
- (void)rotationAnimationFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(CGFloat)duration;
- (void)setAnchorPoint:(CGPoint)anchorpoint;
- (void)addAutoresizingMask;
@end
