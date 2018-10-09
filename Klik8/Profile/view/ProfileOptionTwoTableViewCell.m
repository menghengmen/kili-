#import "ProfileOptionTwoTableViewCell.h"

@interface ProfileOptionTwoTableViewCell ()

@property (nonatomic, weak) ProfileOptionTwoCellModel* dataModel;

@property (weak, nonatomic) IBOutlet UILabel* option1;
@property (weak, nonatomic) IBOutlet UILabel* option2;

@property (weak, nonatomic) IBOutlet UIImageView* iconImageView;

@property (weak, nonatomic) IBOutlet UIImageView* bgImageView;
@property (weak, nonatomic) IBOutlet UIView* bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* bgViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* bgViewHeight;

@end

@implementation ProfileOptionTwoTableViewCell

- (void)refreshUI:(ProfileOptionTwoCellModel*)dataModel{
    _dataModel = dataModel;

    self.bgView.layer.borderColor = [UIColor clearColor].CGColor;
    self.bgView.layer.borderWidth = 1;
    self.bgImageView.image = [[UIImage imageNamed:@"bubble2"] stretchableImageWithLeftCapWidth:112 / 4.0 topCapHeight:80 / 4.0 + 5];

    self.option1.text = dataModel.option1;
    self.option2.text = dataModel.option2;

    self.bgViewWidth.constant = dataModel.sizeOption1.width + dataModel.sizeOption2.width + 32 + 1 + 15 + 20;
    self.bgViewHeight.constant = [dataModel maxHeight] + 20;
    if (self.bgViewHeight.constant < 42)
        self.bgViewHeight.constant = 42;
    [self loadData];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.option1.textColor = self.option2.textColor = [UIColor getColor:@"#898888"];
    self.option1.highlightedTextColor = [UIColor getColor:@"#32aabb"];
    ;
    self.option2.highlightedTextColor = [UIColor getColor:@"#fa456f"];
    [self.option1 addUITapGestureRecognizerWithTarget:self withAction:@selector(option1Action)];
    [self.option2 addUITapGestureRecognizerWithTarget:self withAction:@selector(option2Action)];
}

- (void)loadData{
    NSString* bell = [ZHSaveDataToFMDB selectDataWithIdentity:@"Sex"];
    [self.option1 setHighlighted:NO];
    [self.option2 setHighlighted:NO];
    if (StringIsEmpty(bell)) {

    } else {
        if ([bell isEqualToString:@"Man"]) {
            [self.option1 setHighlighted:YES];
        } else if ([bell isEqualToString:@"Femme"]) {
            [self.option2 setHighlighted:YES];
        }
    }
}

- (void)option1Action{
    [self.option1 setHighlighted:YES];
    [self.option2 setHighlighted:NO];
    [ZHSaveDataToFMDB insertDataWithData:@"Man" WithIdentity:@"Sex"];
}

- (void)option2Action{
    [self.option1 setHighlighted:NO];
    [self.option2 setHighlighted:YES];
    [ZHSaveDataToFMDB insertDataWithData:@"Femme" WithIdentity:@"Sex"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

@end

