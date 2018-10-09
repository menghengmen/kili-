#import <Foundation/Foundation.h>

@interface ZHNotificationLocal : NSObject

+ (void)registerLocalNotificationForTime:(NSInteger)time;
+ (void)cancelLocalNotificationForTime:(NSInteger)time;
+ (void)changeLocalNotificationForOldTime:(NSInteger)oldTime newTime:(NSInteger)newTime;
+ (void)removeAll;

@end
