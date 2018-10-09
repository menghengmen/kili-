//
//  IQTextView.m
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

#import "IQTextView.h"

#import <UIKit/UILabel.h>
#import <UIKit/UINibLoading.h>

@interface IQTextView ()

-(void)refreshPlaceholder;

@end

@implementation IQTextView
{
    UILabel *placeHolderLabel;
}

@synthesize placeholder = _placeholder;

//当不是控制器时,在这个方法里可以注册一些通知什么的
-(void)initialize
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPlaceholder) name:UITextViewTextDidChangeNotification object:self];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}

//有时候我们暂时不需要某个控件时,可以设置它的Alpha为0,这样她也可以不接收事件,并且不显示不来,而不用remove又add
-(void)refreshPlaceholder
{
    if([[self text] length])
    {
        [placeHolderLabel setAlpha:0];
    }else
    {
        [placeHolderLabel setAlpha:1];
    }
    
    [self setNeedsLayout];//一般来说,这两句代码都要加上
    [self layoutIfNeeded];//一般来说,这两句代码都要加上
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self refreshPlaceholder];
}

-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    placeHolderLabel.font = self.font;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [placeHolderLabel sizeToFit];//这句代码的作用是,label的宽高会自动适应文字的大小
    placeHolderLabel.frame = CGRectMake(8, 8, CGRectGetWidth(self.frame)-16, CGRectGetHeight(placeHolderLabel.frame));//之所以写在这里,原因是第一,利用了前面那句自动适应文字大小获取宽高,第二是,有时候,我们会在代码中动态的修改palceHoder的文字,所以,frame值需要时刻变动,写在这里,可手动刷新,而不是写死了frame值
}

-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    if ( placeHolderLabel == nil )
    {
        placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.font = self.font;
        placeHolderLabel.backgroundColor = [UIColor clearColor];
        placeHolderLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        placeHolderLabel.alpha = 0;
        [self addSubview:placeHolderLabel];
    }
    
    placeHolderLabel.text = self.placeholder;
    [self refreshPlaceholder];
}

//When any text changes on textField, the delegate getter is called. At this time we refresh the textView's placeholder
//当文字发生改变时,我们也许需要手动调用一个方法去判断,是否文字长度大于1,如果是,就隐藏placehoder,这样有要自己去外面调用这个方法,造成累赘,这个时候,我们会发现,textview有个代理方法,我们一般会去实现它,而且在方法中会返回这个代理,这个时候,如果我们在这里写一个getter方法,那么久可以避免之前所说的需要写一个额外的方法了,这是一种很好的机制,真心很佩服作者的编程能力,看似没必要,其实蕴含着技巧和工程的封装能力
-(id<UITextViewDelegate>)delegate
{
    [self refreshPlaceholder];
    return [super delegate];
}

@end
