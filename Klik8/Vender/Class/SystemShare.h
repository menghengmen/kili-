//
//  SystemShare.h
//  系统分享
//
//  Created by mac on 17/5/18.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemShare : NSObject

+ (void)shareFromVC:(UIViewController *)vc textToShare:(NSString *)textToShare imageToShare:(UIImage *)imageToShare urlToShare:(NSURL *)urlToShare completion:(void (^)(BOOL completed))completion;

@end
