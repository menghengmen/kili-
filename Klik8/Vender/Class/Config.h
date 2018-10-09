//
//  Config.h
//  Klik8
//
//  Created by mac on 17/5/31.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

singleton_interface(Config)

- (NSInteger)score;
- (void)setScore:(NSInteger)score;
@property (nonatomic,copy)NSString *scoreNumString;

@end
