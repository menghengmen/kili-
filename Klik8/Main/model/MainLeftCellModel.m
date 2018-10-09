#import "MainLeftCellModel.h"

@implementation MainLeftCellModel

- (void)setVineImageName:(NSString*)vineImageName{
    _vineImageName = vineImageName;
    if ([vineImageName hasSuffix:@"01"]) {
        self.vineType = 1;
    } else if ([vineImageName hasSuffix:@"02"]) {
        self.vineType = 2;
    } else if ([vineImageName hasSuffix:@"03"]) {
        self.vineType = 3;
    }
}

- (void)setFruit:(NSString*)fruit{
    _fruit = fruit;
    if ([fruit hasSuffix:@"01"]) {
        self.fruitType = 1;
    } else if ([fruit hasSuffix:@"02"]) {
        self.fruitType = 2;
    } else if ([fruit hasSuffix:@"03"]) {
        self.fruitType = 3;
    } else if ([fruit hasSuffix:@"04"]) {
        self.fruitType = 4;
    } else if ([fruit hasSuffix:@"05"]) {
        self.fruitType = 5;
    } else if ([fruit hasSuffix:@"06"]) {
        self.fruitType = 6;
    } else if ([fruit hasSuffix:@"07"]) {
        self.fruitType = 7;
    } else {
        self.fruitType = 0;
    }
}

- (BOOL)isTimeOutDay{
    if (self.growTime <= 0) {
        return NO;
    }
    int TimeOutDay[7] = { 2, 2, 2, 2, 3, 3, 4 };
    double curInterval = [[NSDate date] timeIntervalSince1970];
    if (self.growTime > curInterval) { //用户修改时间了,并且往前修改了
        self.growTime = curInterval;
        return YES;
    }
    if (self.fruitType >= 3 && self.fruitType <= 7) {
        if (self.growTime + TimeOutDay[self.fruitType - 1] * 24 * 3600 < curInterval) {
            self.fruit = @"";
            self.growTime = 0;
            return YES;
        }
    }
    return NO;
}

- (BOOL)addLeverRandom{
    if (self.fruitType < 7) {
        CGFloat sj = arc4random() % 101 / 100.0;
        float UPGRADE_CHANCE[7] = { 0.7f, 0.6f, 0.5f, 0.4f, 0.5f, 0.6f, 0.7f };
        if (sj < UPGRADE_CHANCE[self.fruitType]) {
            self.fruitType++;
            self.fruit = [NSString stringWithFormat:@"img_fruit_%02zd", self.fruitType];
            self.growTime = [[NSDate date] timeIntervalSince1970];
            return YES;
        }
    }
    return NO;
}

- (void)encodeWithCoder:(NSCoder*)aCoder{
    [aCoder encodeObject:self.vineImageName forKey:@"vineImageName"];
    [aCoder encodeObject:self.fruit forKey:@"fruit"];
    [aCoder encodeInteger:self.vineType forKey:@"vineType"];
    [aCoder encodeInteger:self.fruitType forKey:@"fruitType"];
    [aCoder encodeDouble:self.leftCloudMargin forKey:@"leftCloudMargin"];
    [aCoder encodeDouble:self.rightCloudMargin forKey:@"rightCloudMargin"];
    [aCoder encodeBool:self.shouldShowCloud forKey:@"shouldShowCloud"];
    [aCoder encodeBool:self.isRandomLeft forKey:@"isRandomLeft"];
    [aCoder encodeBool:self.isLargetCloud forKey:@"isLargetCloud"];
    [aCoder encodeDouble:self.growTime forKey:@"growTime"];
}

- (id)initWithCoder:(NSCoder*)aDecoder{
    if (self = [super init]) {
        self.vineImageName = [aDecoder decodeObjectForKey:@"vineImageName"];
        self.fruit = [aDecoder decodeObjectForKey:@"fruit"];
        self.vineType = [aDecoder decodeIntegerForKey:@"vineType"];
        self.fruitType = [aDecoder decodeIntegerForKey:@"fruitType"];
        self.leftCloudMargin = [aDecoder decodeDoubleForKey:@"leftCloudMargin"];
        self.rightCloudMargin = [aDecoder decodeDoubleForKey:@"rightCloudMargin"];
        self.shouldShowCloud = [aDecoder decodeBoolForKey:@"shouldShowCloud"];
        self.isRandomLeft = [aDecoder decodeBoolForKey:@"isRandomLeft"];
        self.isLargetCloud = [aDecoder decodeBoolForKey:@"isLargetCloud"];
        self.growTime = [aDecoder decodeDoubleForKey:@"growTime"];
    }
    return self;
}

@end

