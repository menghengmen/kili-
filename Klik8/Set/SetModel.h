//
//  SetModel.h
//  Klik8
//
//  Created by mac on 17/5/27.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SetModelImageTipType) {
    SetModelImageTipTypeNone=0,//没有此刻的提示
    SetModelImageTipTypeDone,//已经喝完水了
    SetModelImageTipTypeUntill,//还没到时间
    SetModelImageTipTypeExpired//已经到点了,还没有喝水
};

typedef NS_ENUM(NSUInteger, SetModelTimeStrTipType) {
    SetModelTimeStrTipTypeNone=0,//不显示时间
    SetModelTimeStrTipTypeIsHour,//是处于小时的时刻,需要显示时间
    SetModelTimeStrTipTypeHaveTip,//此刻需要提示用户喝水
};

@interface SetModel : NSObject

@property (nonatomic,copy)NSString *timeStr;
@property (nonatomic,assign)NSInteger minutes;
@property (nonatomic,assign)NSInteger splitWidth;
@property (nonatomic,assign)SetModelImageTipType imageTipType;
@property (nonatomic,assign)SetModelTimeStrTipType timeStrTipType;

- (instancetype)initWithMinutes:(NSInteger)minutes;
@end
