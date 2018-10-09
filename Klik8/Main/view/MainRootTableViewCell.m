#import "MainRootTableViewCell.h"

@interface MainRootTableViewCell ()

@property (nonatomic, weak) MainRootCellModel* dataModel;

@end

@implementation MainRootTableViewCell
- (void)refreshUI:(MainRootCellModel*)dataModel{
    _dataModel = dataModel;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.transform = CGAffineTransformMakeScale(1, -1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

@end

