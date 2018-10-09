//
//  SetModel.m
//  Klik8
//
//  Created by mac on 17/5/27.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "DrinkHintTimes.h"
#import "HadDrinkTimes.h"
#import "SetModel.h"

@implementation SetModel

- (instancetype)initWithMinutes:(NSInteger)minutes{
    self = [super init];
    if (self) {
        self.minutes = minutes;
    }
    return self;
}

- (void)setMinutes:(NSInteger)minutes{
    if (minutes == 24 * 60)
        minutes = 0;
    _minutes = minutes;
    self.timeStr = [DateTools get_HH_MM_fromMinutes:minutes];
    if (minutes % 60 == 0) {
        self.splitWidth = 28;
        self.timeStrTipType = SetModelTimeStrTipTypeIsHour;
    } else {
        NSInteger temp = minutes % 60;
        if (temp % 30 == 0)
            self.splitWidth = 23;
        else
            self.splitWidth = 17;
    }

    if ([[DrinkHintTimes sharedDrinkHintTimes] isExsitTime:minutes]) {
        self.timeStrTipType = SetModelTimeStrTipTypeHaveTip;
        NSInteger drinkCountToday = [[HadDrinkTimes sharedHadDrinkTimes] drinkCountToday];
        if ([[DrinkHintTimes sharedDrinkHintTimes] indexOfTime:minutes] + 1 <= drinkCountToday) {
            self.imageTipType = SetModelImageTipTypeDone; //已经喝完水了
        } else {
            NSInteger curDayMinutes = [DateTools getCurDayMinites];
            if (minutes > curDayMinutes) {
                self.imageTipType = SetModelImageTipTypeUntill; //还没到时间
            } else {
                self.imageTipType = SetModelImageTipTypeExpired; //已经到点了,还没有喝水
            }
        }
    }
}

@end
