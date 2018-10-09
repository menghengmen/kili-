#import "ProfileTextFileMeasurementCellModel.h"

@implementation ProfileTextFileMeasurementCellModel

- (void)setMeasurement:(NSString*)measurement{
    _measurement = measurement;
    if (self.width == 0) {
        self.width = 200;
    }

    self.sizeMeasurement = [measurement boundingRectWithSize:CGSizeMake(self.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:16] } context:nil].size;
}

@end

