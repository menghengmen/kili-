#import "DrinkHintTimes.h"
#import "ProfileOptionThreeTableViewCell.h"
#import "SystemSoundIDPlayer.h"

@interface ProfileOptionThreeTableViewCell ()

@property (nonatomic, weak) ProfileOptionThreeCellModel* dataModel;

@property (weak, nonatomic) IBOutlet UILabel* option1;
@property (weak, nonatomic) IBOutlet UILabel* option2;
@property (weak, nonatomic) IBOutlet UILabel* option3;

@property (weak, nonatomic) IBOutlet UIImageView* iconImageView;

@property (weak, nonatomic) IBOutlet UIImageView* bgImageView;
@property (weak, nonatomic) IBOutlet UIView* bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* bgViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* bgViewHeight;

@end

@implementation ProfileOptionThreeTableViewCell

- (void)refreshUI:(ProfileOptionThreeCellModel*)dataModel{
    _dataModel = dataModel;

    self.bgView.layer.borderColor = [UIColor clearColor].CGColor;
    self.bgView.layer.borderWidth = 1;
    self.bgImageView.image = [[UIImage imageNamed:@"bubble2"] stretchableImageWithLeftCapWidth:112 / 4.0 topCapHeight:80 / 4.0 + 5];

    self.option1.text = dataModel.option1;
    self.option2.text = dataModel.option2;
    self.option3.text = dataModel.option3;

    self.bgViewWidth.constant = dataModel.sizeOption1.width + dataModel.sizeOption2.width + dataModel.sizeOption3.width + 64 + 2 + 15 + 20;
    self.bgViewHeight.constant = [dataModel maxHeight] + 20;
    if (self.bgViewHeight.constant < 42)
        self.bgViewHeight.constant = 42;

    [self loadData];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.option1.textColor = self.option2.textColor = self.option3.textColor = [UIColor getColor:@"#898888"];
    self.option1.highlightedTextColor = self.option2.highlightedTextColor = self.option3.highlightedTextColor = [UIColor getColor:@"#32aabb"];
    [self.option1 addUITapGestureRecognizerWithTarget:self withAction:@selector(option1Action)];
    [self.option2 addUITapGestureRecognizerWithTarget:self withAction:@selector(option2Action)];
    [self.option3 addUITapGestureRecognizerWithTarget:self withAction:@selector(option3Action)];
}

- (void)loadData{
    NSString* bell = [ZHSaveDataToFMDB selectDataWithIdentity:@"SystemSoundID"];
    [self.option1 setHighlighted:NO];
    [self.option2 setHighlighted:NO];
    [self.option3 setHighlighted:NO];
    if (StringIsEmpty(bell)) {
        [self.option1 setHighlighted:YES];
    } else {
        if ([bell isEqualToString:@"ice.mp3"]) {
            [self.option1 setHighlighted:YES];
        } else if ([bell isEqualToString:@"adorable.mp3"]) {
            [self.option2 setHighlighted:YES];
        } else if ([bell isEqualToString:@"crash.mp3"]) {
            [self.option3 setHighlighted:YES];
        }
    }
}
- (void)option1Action{
    if (self.option1.isHighlighted == NO) {
        [self.option1 setHighlighted:YES];
        [self.option2 setHighlighted:NO];
        [self.option3 setHighlighted:NO];
        [[SystemSoundIDPlayer sharedSystemSoundIDPlayer] playIndex:1];
        [[DrinkHintTimes sharedDrinkHintTimes] resetAllBell];
    }
}

- (void)option2Action{
    if (self.option2.isHighlighted == NO) {
        [self.option1 setHighlighted:NO];
        [self.option2 setHighlighted:YES];
        [self.option3 setHighlighted:NO];
        [[SystemSoundIDPlayer sharedSystemSoundIDPlayer] playIndex:2];
        [[DrinkHintTimes sharedDrinkHintTimes] resetAllBell];
    }
}

- (void)option3Action{
    if (self.option3.isHighlighted == NO) {
        [self.option1 setHighlighted:NO];
        [self.option2 setHighlighted:NO];
        [self.option3 setHighlighted:YES];
        [[SystemSoundIDPlayer sharedSystemSoundIDPlayer] playIndex:3];
        [[DrinkHintTimes sharedDrinkHintTimes] resetAllBell];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

@end

