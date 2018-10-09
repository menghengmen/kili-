//
//  DrinkHintTimes.m
//  Klik8
//
//  Created by mac on 17/5/29.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "DrinkHintTimes.h"

@interface DrinkHintTimes ()
@property (nonatomic, strong) NSMutableArray* dataArr;
@end

@implementation DrinkHintTimes

singleton_implementation(DrinkHintTimes)

    - (NSMutableArray*)dataArr{
    if (!_dataArr) {
        _dataArr = [ZHSaveDataToFMDB selectDataWithIdentity:@"DrinkHintTimes"];
        if (!_dataArr) {
            _dataArr = [NSMutableArray array];
            [_dataArr addObjectsFromArray:@[ @(420), @(510), @(690), @(820), @(900), @(1050), @(1170), @(1260) ]];
            //注册所有默认的通知提醒
            for (NSInteger i = 0; i < _dataArr.count; i++) {
                NSNumber* num = _dataArr[i];
                NSInteger tempTime = [num integerValue];
                [ZHNotificationLocal registerLocalNotificationForTime:tempTime];
            }
            [ZHSaveDataToFMDB insertDataWithData:_dataArr WithIdentity:@"DrinkHintTimes"];
        } else {
            //判断是否所有通知提醒都存在,不存在就注册
            for (NSInteger i = 0; i < _dataArr.count; i++) {
                NSNumber* num = _dataArr[i];
                NSInteger tempTime = [num integerValue];
                [ZHNotificationLocal registerLocalNotificationForTime:tempTime];
            }
        }
    }
    return _dataArr;
}
- (void)saveToDataBase{
    [ZHSaveDataToFMDB insertDataWithData:self.dataArr WithIdentity:@"DrinkHintTimes"];
}
- (BOOL)isExsitTime:(NSInteger)time{
    for (NSInteger i = 0; i < self.dataArr.count; i++) {
        NSNumber* num = self.dataArr[i];
        NSInteger tempTime = [num integerValue];
        if (tempTime == time) {
            return YES;
        }
    }
    return NO;
}
- (NSInteger)indexOfTime:(NSInteger)time{
    for (NSInteger i = 0; i < self.dataArr.count; i++) {
        NSNumber* num = self.dataArr[i];
        NSInteger tempTime = [num integerValue];
        if (tempTime == time) {
            return i;
        }
    }
    return -1;
}
- (void)insertTime:(NSInteger)time{
    [self.dataArr addObject:@(time)];
    [self.dataArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSNumber *num1=obj1;NSNumber *num2=obj2;
        return [num1 integerValue]>[num2 integerValue];
    }];
    [self saveToDataBase];
    [ZHNotificationLocal registerLocalNotificationForTime:time];
}
- (void)removeTime:(NSInteger)time{
    for (NSInteger i = 0; i < self.dataArr.count; i++) {
        NSNumber* num = self.dataArr[i];
        NSInteger tempTime = [num integerValue];
        if (tempTime == time) {
            [self.dataArr removeObjectAtIndex:i];
            i--;
            [self saveToDataBase];
        }
    }
    [ZHNotificationLocal cancelLocalNotificationForTime:time];
}
- (void)changeOldTime:(NSInteger)oldTime withNewTime:(NSInteger)newTime{
    [self removeTime:oldTime];
    [self insertTime:newTime];
    [ZHNotificationLocal changeLocalNotificationForOldTime:oldTime newTime:newTime];
}
- (NSInteger)countBeforeTime:(NSInteger)time{
    NSInteger count = 0;
    for (NSInteger i = 0; i < self.dataArr.count; i++) {
        NSNumber* num = self.dataArr[i];
        NSInteger tempTime = [num integerValue];
        if (tempTime <= time) {
            count++;
        }
    }
    return count;
}
- (NSArray*)allTimes{
    return self.dataArr;
}
- (NSInteger)allTimesCount{
    return self.dataArr.count;
}
- (void)reset{
    //先取消所有通知提醒
    for (NSInteger i = 0; i < self.dataArr.count; i++) {
        NSNumber* num = self.dataArr[i];
        NSInteger tempTime = [num integerValue];
        [ZHNotificationLocal cancelLocalNotificationForTime:tempTime];
    }
    [self.dataArr setArray:@[ @(420), @(510), @(690), @(820), @(900), @(1050), @(1170), @(1260) ]];
    //注册所有默认的通知提醒
    for (NSInteger i = 0; i < self.dataArr.count; i++) {
        NSNumber* num = self.dataArr[i];
        NSInteger tempTime = [num integerValue];
        [ZHNotificationLocal registerLocalNotificationForTime:tempTime];
    }
    [self saveToDataBase];
}

/**移除所有通知提醒,静音*/
- (void)cancelLocalNotification{
    for (NSInteger i = 0; i < self.dataArr.count; i++) {
        NSNumber* num = self.dataArr[i];
        NSInteger tempTime = [num integerValue];
        [ZHNotificationLocal cancelLocalNotificationForTime:tempTime];
    }
}
/**注册所有通知提醒*/
- (void)registerLocalNotification{
    for (NSInteger i = 0; i < self.dataArr.count; i++) {
        NSNumber* num = self.dataArr[i];
        NSInteger tempTime = [num integerValue];
        [ZHNotificationLocal registerLocalNotificationForTime:tempTime];
    }
}
/**替换所有铃声*/
- (void)resetAllBell{
    //先取消所有通知提醒
    [self cancelLocalNotification];
    //注册所有的通知提醒
    [self registerLocalNotification];
}

@end

