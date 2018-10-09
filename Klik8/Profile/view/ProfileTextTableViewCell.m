#import "ProfileTextTableViewCell.h"

@interface ProfileTextTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView* iconImageView;
@property (weak, nonatomic) IBOutlet UILabel* contextLabel;

@property (weak, nonatomic) IBOutlet UIImageView* bgImageView;
@property (weak, nonatomic) IBOutlet UIView* bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* bgViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* bgViewHeight;

@property (nonatomic, weak) ProfileTextCellModel* dataModel;

@end

@implementation ProfileTextTableViewCell
- (void)refreshUI:(ProfileTextCellModel*)dataModel{
    _dataModel = dataModel;
    self.bgView.layer.borderColor = [UIColor clearColor].CGColor;
    self.bgView.layer.borderWidth = 1;
    self.bgImageView.image = [[UIImage imageNamed:@"bubble1"] stretchableImageWithLeftCapWidth:112 / 4.0 topCapHeight:80 / 4.0 + 5];

    self.contextLabel.text = dataModel.content;

    self.bgViewWidth.constant = dataModel.size.width + 10 + 20;
    self.bgViewHeight.constant = dataModel.size.height + 20;
    if (self.bgViewHeight.constant < 42)
        self.bgViewHeight.constant = 42;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contextLabel.textColor = [UIColor whiteColor];
    self.contextLabel.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

@end

