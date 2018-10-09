#import <UIKit/UIKit.h>

@interface MainRightCellModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString* vineImageName;
@property (nonatomic, assign) NSInteger vineType;

@property (nonatomic, copy) NSString* fruit;
@property (nonatomic, assign) NSInteger fruitType;

@property (nonatomic, assign) BOOL shouldShowCloud;
@property (nonatomic, assign) BOOL isRandomLeft; //是不是显示左边的云朵,否就是显示右边的云朵
@property (nonatomic, assign) BOOL isLargetCloud; //是不是显示大的云朵,否就是大右边的云朵
@property (nonatomic, assign) CGFloat leftCloudMargin;
@property (nonatomic, assign) CGFloat rightCloudMargin;

@property (nonatomic, assign) double growTime;
- (BOOL)isTimeOutDay;

- (BOOL)addLeverRandom;
@end
