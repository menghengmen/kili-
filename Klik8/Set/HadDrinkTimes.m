//
//  HadDrinkTimes.m
//  Klik8
//
//  Created by mac on 17/5/29.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HadDrinkTimes.h"

@interface HadDrinkTimes ()
@property (nonatomic, strong) NSMutableDictionary* hadDrinkTimesDicM;
@end

@implementation HadDrinkTimes

singleton_implementation(HadDrinkTimes)

    - (NSMutableDictionary*)hadDrinkTimesDicM{
    if (!_hadDrinkTimesDicM) {
        _hadDrinkTimesDicM = [ZHSaveDataToFMDB selectDataWithIdentity:@"HadDrinkTimes"];
        if (!_hadDrinkTimesDicM) {
            _hadDrinkTimesDicM = [NSMutableDictionary dictionary];
            [ZHSaveDataToFMDB insertDataWithData:_hadDrinkTimesDicM WithIdentity:@"HadDrinkTimes"];
        }
    }
    return _hadDrinkTimesDicM;
}
- (void)saveToDataBase{
    [ZHSaveDataToFMDB insertDataWithData:self.hadDrinkTimesDicM WithIdentity:@"HadDrinkTimes"];
}
- (NSInteger)drinkCountToday{
    NSString* curDate = [DateTools currentDate_yyyy_MM_dd];
    NSNumber* num = self.hadDrinkTimesDicM[curDate];
    if (num) {
        return [num integerValue];
    }
    return 0;
}
- (void)addDrinkToday{
    NSString* curDate = [DateTools currentDate_yyyy_MM_dd];
    NSNumber* num = self.hadDrinkTimesDicM[curDate];
    NSInteger count = 0;
    if (num) {
        count = [num integerValue];
    }
    count++;
    [self.hadDrinkTimesDicM setValue:@(count) forKey:curDate];
    [self saveToDataBase];
}
- (void)resetToday{
    NSString* curDate = [DateTools currentDate_yyyy_MM_dd];
    NSNumber* num = self.hadDrinkTimesDicM[curDate];
    if (num) {
        [self.hadDrinkTimesDicM setValue:@(0) forKey:curDate];
    }
    [self saveToDataBase];
}
@end

