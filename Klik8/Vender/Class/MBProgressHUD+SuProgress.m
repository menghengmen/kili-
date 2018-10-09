//
//  MBProgressHUD+SuProgress.m
//  CJOL
//
//  Created by SuDream on 16/10/12.
//  Copyright © 2016年 SuDream. All rights reserved.
//

#import "MBProgressHUD+SuProgress.h"

@implementation MBProgressHUD (SuProgress)

+ (instancetype) showMessage:(NSString *)message{
    return [self showMessage:message toView:nil];
}

+ (instancetype)showMessage:(NSString *)message toView:(UIView *) view{
    if (view == nil) view =  [UIApplication sharedApplication].keyWindow;
    NSArray *subView=[view subviews];
    UIView *target;
    for (UIView *tempView in subView) {
        if([tempView isKindOfClass:[MBProgressHUD class]]){
            MBProgressHUD *hud=(MBProgressHUD *)tempView;
            if(hud.labelText.length>0){target=tempView;break;}
        }
    }
    if(target){[(MBProgressHUD *)target hide:NO];}
    
    if (view == nil) view =  [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    if(!StringIsEmpty(message)){
        hud.labelText = message;
    }else{
        hud.labelText = @"";
    }
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    hud.userInteractionEnabled=NO;
    hud.labelFont=[UIFont systemFontOfSize:16];
    hud.margin = 20.0f;

    //一秒消失
    [hud hide:YES afterDelay:1.5];
    return hud;
}

@end
