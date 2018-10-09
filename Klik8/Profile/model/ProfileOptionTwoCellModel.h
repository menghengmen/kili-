#import <UIKit/UIKit.h>

@interface ProfileOptionTwoCellModel : NSObject

@property (nonatomic, copy) NSString* iconImageName;
@property (nonatomic, copy) NSString* option1;
@property (nonatomic, copy) NSString* option2;
@property (nonatomic, assign) CGSize sizeOption1;
@property (nonatomic, assign) CGSize sizeOption2;
@property (nonatomic, assign) CGFloat width;

- (void)setOption1:(NSString*)option1 Option2:(NSString*)option2;

- (CGFloat)maxHeight;

@end
