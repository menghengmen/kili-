#import "ZHNotificationLocal.h"

@implementation ZHNotificationLocal

+ (void)registerLocalNotificationForTime:(NSInteger)time{
    // 处理耗时操作的代码块...
    NSString *key=[NSString stringWithFormat:@"Notification:%zd",time];
    if ([self exsitLocalNotificationForTime:time]) {
        return ;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self registerLocalNotificationIntervalSinceToday:time repeatInterval:NSCalendarUnitDay alertBody:@"主人,该喝水了" withObject:@"" withKey:key];
    });
}
+ (void)cancelLocalNotificationForTime:(NSInteger)time{
    NSString *key=[NSString stringWithFormat:@"Notification:%zd",time];
    [ZHNotificationLocal cancelLocalNotificationWithKey:key];
}
+ (void)changeLocalNotificationForOldTime:(NSInteger)oldTime newTime:(NSInteger)newTime{
    [self cancelLocalNotificationForTime:oldTime];
    [self registerLocalNotificationForTime:newTime];
}

+ (BOOL)exsitLocalNotificationForTime:(NSInteger)time{
    NSString *key=[NSString stringWithFormat:@"Notification:%zd",time];
    
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            // 根据设置通知参数时指定的key来获取通知参数
            id obj = userInfo[key];
            
            // 如果找到需要取消的通知，则取消
            if (obj != nil) {
                return YES;
            }
        }
    }
    return NO;
}

+ (void)registerLocalNotificationIntervalSinceToday:(long long)alertTime repeatInterval:(NSCalendarUnit)repeatInterval alertBody:(NSString *)alertBody withObject:(id)obj withKey:(NSString *)key{
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    // 设置触发通知的时间
    NSDate *fireDate=[NSDate dateWithTimeIntervalSince1970:[DateTools getCurDayInterval]+alertTime*60];
    
    notification.fireDate = fireDate;
    
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 通知重复提示的单位，可以是天、周、月
    notification.repeatInterval = repeatInterval;
    
    // 通知内容
    notification.alertBody = alertBody;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // 通知被触发时播放的声音
    NSString *bell=[ZHSaveDataToFMDB selectDataWithIdentity:@"SystemSoundID"];
    notification.soundName = bell;
    
    // 通知参数
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:obj forKey:key];
    notification.userInfo = userDict;
    
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

+ (void)cancelLocalNotificationWithKey:(NSString *)key{
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            // 根据设置通知参数时指定的key来获取通知参数
            id obj = userInfo[key];
            
            // 如果找到需要取消的通知，则取消
            if (obj != nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;
            }
        }
    }
}

+ (void)removeAll{
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

@end
