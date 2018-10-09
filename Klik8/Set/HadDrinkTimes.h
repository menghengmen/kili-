//
//  HadDrinkTimes.h
//  Klik8
//
//  Created by mac on 17/5/29.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HadDrinkTimes : NSObject

singleton_interface(HadDrinkTimes)

- (NSInteger)drinkCountToday;
- (void)addDrinkToday;
- (void)resetToday;

@end
