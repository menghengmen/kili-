#import "ProfileTextCellModel.h"

@implementation ProfileTextCellModel

- (void)setContent:(NSString *)content{
	_content=content;
	if (self.width==0) {
		self.width=200;
	}
	self.size=[content boundingRectWithSize:CGSizeMake(self.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
}

@end
