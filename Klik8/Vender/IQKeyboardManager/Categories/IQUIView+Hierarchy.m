//
//  UIView+Hierarchy.m
// https://github.com/hackiftekhar/IQKeyboardManager
// Copyright (c) 2013-16 Iftekhar Qurashi.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "IQUIView+Hierarchy.h"

#import <UIKit/UICollectionView.h>

#import <UIKit/UITableView.h>
#import <UIKit/UITextView.h>
#import <UIKit/UITextField.h>
#import <UIKit/UISearchBar.h>
#import <UIKit/UIViewController.h>
#import <UIKit/UIWindow.h>

#import <objc/runtime.h>

#import "IQNSArray+Sort.h"

@implementation UIView (IQ_UIView_Hierarchy)


-(void)_setIsAskingCanBecomeFirstResponder:(BOOL)isAskingCanBecomeFirstResponder
{
    objc_setAssociatedObject(self, @selector(isAskingCanBecomeFirstResponder), @(isAskingCanBecomeFirstResponder), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)isAskingCanBecomeFirstResponder
{
    NSNumber *isAskingCanBecomeFirstResponder = objc_getAssociatedObject(self, @selector(isAskingCanBecomeFirstResponder));
    return [isAskingCanBecomeFirstResponder boolValue];
}

//获取该控件的控制器
-(UIViewController*)viewController
{
    UIResponder *nextResponder =  self;
    
    do
    {
        //利用nextResponder的链表
        nextResponder = [nextResponder nextResponder];

        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController*)nextResponder;

    } while (nextResponder != nil);

    return nil;
}

//这个函数是返回能回应Responder的最顶部的ViewController
-(UIViewController *)topMostController
{
    NSMutableArray *controllersHierarchy = [[NSMutableArray alloc] init];
    
    UIViewController *topController = self.window.rootViewController;
    
    if (topController)
    {
        [controllersHierarchy addObject:topController];
    }
    
    while ([topController presentedViewController]) {
        
        topController = [topController presentedViewController];
        [controllersHierarchy addObject:topController];
    }
    //上述代码是用来获取所有的入栈控制器(牛逼,很有用)
    
    UIResponder *matchController = [self viewController];
    
    while (matchController != nil && [controllersHierarchy containsObject:matchController] == NO)
    {
        //当找到了响应控制器,继续往下走,去寻找最父亲级别的响应控制器
        do
        {
            matchController = [matchController nextResponder];
            
        } while (matchController != nil && [matchController isKindOfClass:[UIViewController class]] == NO);
    }
    
    return (UIViewController*)matchController;
}

-(UIView*)superviewOfClassType:(Class)classType
{
    UIView *superview = self.superview;
    
    while (superview)
    {
        //虽然没有搞懂为什么要排除这三个类,但是下面的代码还是很精简的
        static Class UITableViewCellScrollViewClass;   //UITableViewCell
        static Class UITableViewWrapperViewClass;      //UITableViewCell
        static Class UIQueuingScrollViewClass;         //UIPageViewController

        //保证只执行一次,经典,将dispatch_once用到了极致
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            UITableViewCellScrollViewClass      = NSClassFromString(@"UITableViewCellScrollView");
            UITableViewWrapperViewClass         = NSClassFromString(@"UITableViewWrapperView");
            UIQueuingScrollViewClass            = NSClassFromString(@"_UIQueuingScrollView");
        });
        if ([superview isKindOfClass:classType] &&
            ([superview isKindOfClass:UITableViewCellScrollViewClass] == NO) &&
            ([superview isKindOfClass:UITableViewWrapperViewClass] == NO) &&
            ([superview isKindOfClass:UIQueuingScrollViewClass] == NO))
        {
            return superview;
        }
        else    superview = superview.superview;
    }
    
    return nil;
}


//判断是否可以成为FirstResponder
-(BOOL)_IQcanBecomeFirstResponder
{
    [self _setIsAskingCanBecomeFirstResponder:YES];
    
    //牛逼就牛逼在这句判断代码
    BOOL _IQcanBecomeFirstResponder = ([self canBecomeFirstResponder] && [self isUserInteractionEnabled] && ![self isHidden] && [self alpha]!=0.0 && ![self isAlertViewTextField]  && ![self isSearchBarTextField]);
    
    if (_IQcanBecomeFirstResponder == YES)
    {
        if ([self isKindOfClass:[UITextField class]])
        {
            _IQcanBecomeFirstResponder = [(UITextField*)self isEnabled];
        }
        else if ([self isKindOfClass:[UITextView class]])
        {
            _IQcanBecomeFirstResponder = [(UITextView*)self isEditable];
        }
    }
    
    [self _setIsAskingCanBecomeFirstResponder:NO];
    
    return _IQcanBecomeFirstResponder;
}

- (NSArray*)responderSiblings
{
    //	Getting all siblings
    NSArray *siblings = self.superview.subviews;
    
    //Array of (UITextField/UITextView's).
    NSMutableArray *tempTextFields = [[NSMutableArray alloc] init];
    
    for (UIView *textField in siblings)
        if ([textField _IQcanBecomeFirstResponder])
            [tempTextFields addObject:textField];
    
    return tempTextFields;
}

- (NSArray*)deepResponderViews
{
    NSMutableArray *textFields = [[NSMutableArray alloc] init];
    
    for (UIView *textField in self.subviews)
    {
        if ([textField _IQcanBecomeFirstResponder])
        {
            [textFields addObject:textField];
        }
        //Sometimes there are hidden or disabled views and textField inside them still recorded, so we added some more validations here (Bug ID: #458)
        else if (textField.subviews.count && [textField isUserInteractionEnabled] && ![textField isHidden] && [textField alpha]!=0.0)
        {
            //这个递归用的,我给满分
            [textFields addObjectsFromArray:[textField deepResponderViews]];
        }
    }

    //subviews are returning in incorrect order. Sorting according the frames 'y'.
    return [textFields sortedArrayUsingComparator:^NSComparisonResult(UIView *view1, UIView *view2) {
        
        CGRect frame1 = [view1 convertRect:view1.bounds toView:self];
        CGRect frame2 = [view2 convertRect:view2.bounds toView:self];
        
        CGFloat x1 = CGRectGetMinX(frame1);
        CGFloat y1 = CGRectGetMinY(frame1);
        CGFloat x2 = CGRectGetMinX(frame2);
        CGFloat y2 = CGRectGetMinY(frame2);
        
        if (y1 < y2)  return NSOrderedAscending;
        
        else if (y1 > y2) return NSOrderedDescending;
        
        //Else both y are same so checking for x positions
        else if (x1 < x2)  return NSOrderedAscending;
        
        else if (x1 > x2) return NSOrderedDescending;
        
        else    return NSOrderedSame;
    }];

    return textFields;
}

-(CGAffineTransform)convertTransformToView:(UIView*)toView
{
    if (toView == nil)
    {
        toView = self.window;
    }
    
    CGAffineTransform myTransform = CGAffineTransformIdentity;
    
    //My Transform
    {
        UIView *superView = [self superview];
        
        if (superView)  myTransform = CGAffineTransformConcat(self.transform, [superView convertTransformToView:nil]);
        else            myTransform = self.transform;
    }
    
    CGAffineTransform viewTransform = CGAffineTransformIdentity;
    
    //view Transform
    {
        UIView *superView = [toView superview];
        
        if (superView)  viewTransform = CGAffineTransformConcat(toView.transform, [superView convertTransformToView:nil]);
        else if (toView)  viewTransform = toView.transform;
    }
    
    return CGAffineTransformConcat(myTransform, CGAffineTransformInvert(viewTransform));
}

//返回自己在嵌套subview中的深度
- (NSInteger)depth
{
    NSInteger depth = 0;
    
    if ([self superview])
    {
        //同时也是边遍历边赋值
        depth = [[self superview] depth] + 1;
    }
    
    return depth;
}

//打印子层次结构
- (NSString *)subHierarchy
{
    NSMutableString *debugInfo = [[NSMutableString alloc] initWithString:@"\n"];
    NSInteger depth = [self depth];
    
    for (int counter = 0; counter < depth; counter ++)  [debugInfo appendString:@"|  "];
    
    [debugInfo appendString:[self debugHierarchy]];
    
    for (UIView *subview in self.subviews)
    {
        [debugInfo appendString:[subview subHierarchy]];
    }
    
    return debugInfo;
}
//往上打印层次结构
- (NSString *)superHierarchy
{
    NSMutableString *debugInfo = [[NSMutableString alloc] init];

    if (self.superview)
    {
        [debugInfo appendString:[self.superview superHierarchy]];
    }
    else
    {
        [debugInfo appendString:@"\n"];
    }
    
    NSInteger depth = [self depth];
    
    for (int counter = 0; counter < depth; counter ++)  [debugInfo appendString:@"|  "];
    
    [debugInfo appendString:[self debugHierarchy]];

    [debugInfo appendString:@"\n"];
    
    return debugInfo;
}
//打印self.frame self class contentSize transform
-(NSString *)debugHierarchy
{
    NSMutableString *debugInfo = [[NSMutableString alloc] init];

    [debugInfo appendFormat:@"%@: ( %.0f, %.0f, %.0f, %.0f )",NSStringFromClass([self class]), CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)];
    
    if ([self isKindOfClass:[UIScrollView class]])
    {
        UIScrollView *scrollView = (UIScrollView*)self;
        [debugInfo appendFormat:@"%@: ( %.0f, %.0f )",NSStringFromSelector(@selector(contentSize)),scrollView.contentSize.width,scrollView.contentSize.height];
    }
    
    if (CGAffineTransformEqualToTransform(self.transform, CGAffineTransformIdentity) == false)
    {
        [debugInfo appendFormat:@"%@: %@",NSStringFromSelector(@selector(transform)),NSStringFromCGAffineTransform(self.transform)];
    }
    
    return debugInfo;
}

-(BOOL)isSearchBarTextField
{
    //如果不这样写,NSClassFromString(@"UISearchBarTextField")每次调用这个函数要执行一次,而这样写就可以避免这种问题
    static Class UISearchBarTextFieldClass;        //UISearchBar

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UISearchBarTextFieldClass           = NSClassFromString(@"UISearchBarTextField");
    });
    return ([self isKindOfClass:UISearchBarTextFieldClass] || [self isKindOfClass:[UISearchBar class]]);
}

-(BOOL)isAlertViewTextField
{
    //Special textFields,textViews,scrollViews
    static Class UIAlertSheetTextFieldClass;       //UIAlertView
    static Class UIAlertSheetTextFieldClass_iOS8;  //UIAlertView

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIAlertSheetTextFieldClass          = NSClassFromString(@"UIAlertSheetTextField");
        UIAlertSheetTextFieldClass_iOS8     = NSClassFromString(@"_UIAlertControllerTextField");
    });
    
    return ([self isKindOfClass:UIAlertSheetTextFieldClass] || [self isKindOfClass:UIAlertSheetTextFieldClass_iOS8]);
}

@end


@implementation NSObject (IQ_Logging)

-(NSString *)_IQDescription
{
    return [NSString stringWithFormat:@"<%@ %p>",NSStringFromClass([self class]),self];
}

@end
