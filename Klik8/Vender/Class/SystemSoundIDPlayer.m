
#import "SystemSoundIDPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface SystemSoundIDPlayer ()
@property (nonatomic,assign)SystemSoundID soundID;
@end

@implementation SystemSoundIDPlayer

singleton_implementation(SystemSoundIDPlayer)

- (void)vibrate{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}
- (void)play{
    if(self.soundID!=0)
        AudioServicesPlaySystemSound(self.soundID);
    else{
        NSString *bell=[ZHSaveDataToFMDB selectDataWithIdentity:@"SystemSoundID"];
        if (StringIsEmpty(bell)) {
            [self playIndex:1];
        }else{
            if ([bell isEqualToString:@"ice.mp3"]) {
                [self playIndex:1];
            }else if([bell isEqualToString:@"adorable.mp3"]){
                [self playIndex:2];
            }else if([bell isEqualToString:@"crash.mp3"]){
                [self playIndex:3];
            }
        }
    }
}
- (void)playIndex:(int)index{
    SystemSoundID soundID;
    CFURLRef url;
    if (index==1) {
        url=(__bridge CFURLRef)[[NSBundle mainBundle] URLForResource:@"ice.mp3" withExtension:nil];
        [ZHSaveDataToFMDB insertDataWithData:@"ice.mp3" WithIdentity:@"SystemSoundID"];
    }else if(index==2){
        url=(__bridge CFURLRef)[[NSBundle mainBundle] URLForResource:@"adorable.mp3" withExtension:nil];
        [ZHSaveDataToFMDB insertDataWithData:@"adorable.mp3" WithIdentity:@"SystemSoundID"];
    }else if(index==3){
        url=(__bridge CFURLRef)[[NSBundle mainBundle] URLForResource:@"crash.mp3" withExtension:nil];
        [ZHSaveDataToFMDB insertDataWithData:@"crash.mp3" WithIdentity:@"SystemSoundID"];
    }else{
        return;
    }
    AudioServicesCreateSystemSoundID(url, &soundID);
    self.soundID=soundID;
    AudioServicesPlaySystemSound(soundID);
}
@end
