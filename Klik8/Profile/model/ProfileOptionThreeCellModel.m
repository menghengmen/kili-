#import "ProfileOptionThreeCellModel.h"

@implementation ProfileOptionThreeCellModel

- (void)setOption1:(NSString*)option1 Option2:(NSString*)option2 Option3:(NSString*)option3{
    self.option1 = option1;
    self.option2 = option2;
    self.option3 = option3;
    if (self.width == 0) {
        self.width = 200;
    }

    self.sizeOption1 = [option1 boundingRectWithSize:CGSizeMake(self.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:16] } context:nil].size;

    self.sizeOption2 = [option2 boundingRectWithSize:CGSizeMake(self.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:16] } context:nil].size;

    self.sizeOption3 = [option3 boundingRectWithSize:CGSizeMake(self.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:16] } context:nil].size;
}

- (CGFloat)maxHeight{
    return MAX(MAX(self.sizeOption1.height, self.sizeOption2.height), self.sizeOption3.height);
}

@end

