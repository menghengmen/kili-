//
//  BirdHint.h
//  Klik8
//
//  Created by mac on 17/5/30.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BirdHint : UIView

- (void)hint:(NSString*)text;
- (void)startAnimation;
- (void)endAnimation;

@end
