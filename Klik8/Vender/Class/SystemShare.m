//
//  SystemShare.m
//  系统分享
//
//  Created by mac on 17/5/18.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "SystemShare.h"

@implementation SystemShare

+ (void)shareFromVC:(UIViewController*)vc textToShare:(NSString*)textToShare imageToShare:(UIImage*)imageToShare urlToShare:(NSURL*)urlToShare completion:(void (^)(BOOL completed))completion{

    NSMutableArray* activityItems = [NSMutableArray array];

    if (textToShare)
        [activityItems addObject:textToShare];
    if (imageToShare)
        [activityItems addObject:imageToShare];
    if (urlToShare)
        [activityItems addObject:urlToShare];

    UIActivityViewController* activeViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];

    //不显示哪些分享平台
    //    activeViewController.excludedActivityTypes = @[UIActivityTypeAirDrop,UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypeOpenInIBooks];

    [vc presentViewController:activeViewController animated:YES completion:nil];

    //分享结果回调方法
    UIActivityViewControllerCompletionWithItemsHandler myblock = ^(UIActivityType __nullable activityType, BOOL completed, NSArray* __nullable returnedItems, NSError* __nullable activityError) {
        NSLog(@"activityType :%@", activityType);
        if (completion) {
            completion(completed);
        }
    };
    activeViewController.completionWithItemsHandler = myblock;
}
@end

