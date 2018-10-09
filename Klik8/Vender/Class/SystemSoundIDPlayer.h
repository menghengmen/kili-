
#import <Foundation/Foundation.h>

@interface SystemSoundIDPlayer : NSObject

singleton_interface(SystemSoundIDPlayer)

- (void)vibrate;
- (void)play;
- (void)playIndex:(int)index;

@end
