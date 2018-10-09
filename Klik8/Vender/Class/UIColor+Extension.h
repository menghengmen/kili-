//
//  UIColor+Extension.h
//  APP_iOS
//
//  Created by 左偲 on 16/1/21.
//  Copyright © 2016年 HK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

+( UIColor *)getColor:( NSString *)hexColor;

+ (UIImage *)imageWithColor:(UIColor *)color;

@end
