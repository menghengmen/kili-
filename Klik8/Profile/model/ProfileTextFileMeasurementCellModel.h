#import <UIKit/UIKit.h>
@interface ProfileTextFileMeasurementCellModel : NSObject

@property (nonatomic,copy)NSString *iconImageName;
@property (nonatomic,assign)CGSize sizeMeasurement;
@property (nonatomic,assign)CGFloat width;
@property (nonatomic,copy)NSString *measurement;
@property (nonatomic,copy)NSString *textFiled;

- (void)setMeasurement:(NSString *)measurement;
@end
