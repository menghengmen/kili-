//
//  UIColor+Extension.m
//  APP_iOS
//
//  Created by 左偲 on 16/1/21.
//  Copyright © 2016年 HK. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

// 十六进制数转换成颜色
+( UIColor *) getColor:( NSString *)hexColor{
    if ([hexColor hasPrefix:@"0x"]) {
        hexColor=[hexColor substringFromIndex:2];
    }
    if ([hexColor hasPrefix:@"#"]) {
        hexColor=[hexColor substringFromIndex:1];
    }
    if ([hexColor length] != 6)
        return [UIColor whiteColor];
    //这其实是一个十六进制的颜色字符串,通过截取字符串就可以转换为十进制
    unsigned int red, green, blue;
    
    NSRange range;
    range. length = 2 ;
    range. location = 0 ;
    [[ NSScanner scannerWithString :[hexColor substringWithRange :range]] scanHexInt :&red];
    range. location = 2 ;
    [[ NSScanner scannerWithString :[hexColor substringWithRange :range]] scanHexInt :&green];
    range. location = 4 ;
    [[ NSScanner scannerWithString :[hexColor substringWithRange :range]] scanHexInt :&blue];
    
    return [ UIColor colorWithRed :( float )(red/ 255.0f ) green :( float )(green/ 255.0f ) blue :( float )(blue/ 255.0f ) alpha : 1.0f ];
}

+ (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
