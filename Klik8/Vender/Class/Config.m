//
//  Config.m
//  Klik8
//
//  Created by mac on 17/5/31.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "Config.h"

@interface Config ()

@end
@implementation Config

singleton_implementation(Config)

- (NSInteger)score{
    NSString *scoreStr=[ZHSaveDataToFMDB selectDataWithIdentity:@"Score"];
    if (StringIsEmpty(scoreStr)) {
        [ZHSaveDataToFMDB insertDataWithData:@"0" WithIdentity:@"Score"];
        return 0;
    }else{
        return [scoreStr integerValue];
    }
}
- (void)setScore:(NSInteger)score{
    [ZHSaveDataToFMDB insertDataWithData:[NSString stringWithFormat:@"%zd",score] WithIdentity:@"Score"];
}

- (NSString *)scoreNumString{
    NSString *scoreStr=[ZHSaveDataToFMDB selectDataWithIdentity:@"Score"];
    if (StringIsEmpty(scoreStr)) {
        [ZHSaveDataToFMDB insertDataWithData:@"0" WithIdentity:@"Score"];
        return @"0";
    }
    return scoreStr;
}
@end
