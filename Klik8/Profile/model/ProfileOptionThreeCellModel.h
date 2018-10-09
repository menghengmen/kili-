#import <UIKit/UIKit.h>
@interface ProfileOptionThreeCellModel : NSObject

@property (nonatomic, copy) NSString* iconImageName;
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, copy) NSString* option1;
@property (nonatomic, copy) NSString* option2;
@property (nonatomic, copy) NSString* option3;

@property (nonatomic, assign) CGSize sizeOption1;
@property (nonatomic, assign) CGSize sizeOption2;
@property (nonatomic, assign) CGSize sizeOption3;

- (void)setOption1:(NSString*)option1 Option2:(NSString*)option2 Option3:(NSString*)option3;

- (CGFloat)maxHeight;

@end
