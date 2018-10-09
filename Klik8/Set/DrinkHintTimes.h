//
//  DrinkHintTimes.h
//  Klik8
//
//  Created by mac on 17/5/29.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrinkHintTimes : NSObject

singleton_interface(DrinkHintTimes)

- (BOOL)isExsitTime:(NSInteger)time;
- (NSInteger)indexOfTime:(NSInteger)time;
- (void)insertTime:(NSInteger)time;
- (void)removeTime:(NSInteger)time;
- (void)changeOldTime:(NSInteger)oldTime withNewTime:(NSInteger)newTime;
- (NSInteger)countBeforeTime:(NSInteger)time;
- (NSArray *)allTimes;
- (NSInteger)allTimesCount;
- (void)reset;
/**移除所有通知提醒,静音*/
- (void)cancelLocalNotification;
/**注册所有通知提醒*/
- (void)registerLocalNotification;
/**替换所有铃声*/
- (void)resetAllBell;

@end
