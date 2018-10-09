#import "MainRightTableViewCell.h"

@interface MainRightTableViewCell ()

@property (nonatomic, weak) MainRightCellModel* dataModel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* offset;
@property (weak, nonatomic) IBOutlet UIImageView* vineImageView;
@property (strong, nonatomic) UIImageView* fruit;
@property (nonatomic, strong) UIView* hotAreal; //点击热区
@property (weak, nonatomic) IBOutlet UIView* midView;
@property (weak, nonatomic) IBOutlet UIImageView* leftCloud;
@property (weak, nonatomic) IBOutlet UIImageView* rightCloud;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* leftCloudWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* leftCloudHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* leftCloudTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* rightCloudWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* rightCloudHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* rightCloudLeading;
@end

@implementation MainRightTableViewCell

- (void)refreshUI:(MainRightCellModel*)dataModel{
    _dataModel = dataModel;
    self.vineImageView.image = [UIImage imageNamed:dataModel.vineImageName];
    self.fruit.image = [UIImage imageNamed:dataModel.fruit];

    if (dataModel.shouldShowCloud) {
        if (dataModel.isRandomLeft) {
            self.leftCloud.hidden = NO;
            self.rightCloud.hidden = YES;
        } else {
            self.leftCloud.hidden = YES;
            self.rightCloud.hidden = NO;
        }
        if (dataModel.isLargetCloud) {
            self.leftCloud.image = [UIImage imageNamed:@"img_cloud"];
            self.rightCloud.image = [UIImage imageNamed:@"img_cloud"];
            self.leftCloudWidth.constant = self.rightCloudWidth.constant = 81;
            self.leftCloudHeight.constant = self.rightCloudHeight.constant = 34;
        } else {
            self.leftCloud.image = [UIImage imageNamed:@"img_cloud1"];
            self.rightCloud.image = [UIImage imageNamed:@"img_cloud1"];
            self.leftCloudWidth.constant = self.rightCloudWidth.constant = 61;
            self.leftCloudHeight.constant = self.rightCloudHeight.constant = 32;
        }
    } else {
        self.leftCloud.hidden = self.rightCloud.hidden = YES;
    }
    self.leftCloudTrailing.constant = dataModel.leftCloudMargin;
    self.rightCloudLeading.constant = dataModel.rightCloudMargin;

    if (dataModel.vineType == 1) {
        self.offset.constant = -7.5;
    } else if (dataModel.vineType == 2) {
        self.offset.constant = -2;
    } else if (dataModel.vineType == 3) {
        self.offset.constant = -7.5;
    }
    [self.midView layoutIfNeeded];
    [self.vineImageView layoutIfNeeded];

    CGFloat publicFruitOffset = CurrentScreen_Width / 2.0 + self.offset.constant;
    switch (dataModel.fruitType) {
    case 1: {
        self.fruit.width = self.fruit.height = 8;
        if (dataModel.vineType == 1) {
            self.fruit.y = 31;
            self.fruit.x = publicFruitOffset + 39;
        } else if (dataModel.vineType == 2) {
            self.fruit.y = 25;
            self.fruit.x = publicFruitOffset + 36;
        } else if (dataModel.vineType == 3) {
            self.fruit.y = 35;
            self.fruit.x = publicFruitOffset + 38;
        }
    } break;
    case 2:
        self.fruit.width = self.fruit.height = 10;
        if (dataModel.vineType == 1) {
            self.fruit.y = 30;
            self.fruit.x = publicFruitOffset + 38;
        } else if (dataModel.vineType == 2) {
            self.fruit.y = 24;
            self.fruit.x = publicFruitOffset + 35;
        } else if (dataModel.vineType == 3) {
            self.fruit.y = 34;
            self.fruit.x = publicFruitOffset + 37;
        }
        break;
    case 3:
    case 4:
    case 5:
    case 6:
        self.fruit.width = self.fruit.height = 15;
        if (dataModel.vineType == 1) {
            self.fruit.y = 27.5;
            self.fruit.x = publicFruitOffset + 35.5;
        } else if (dataModel.vineType == 2) {
            self.fruit.y = 21.5;
            self.fruit.x = publicFruitOffset + 32.5;
        } else if (dataModel.vineType == 3) {
            self.fruit.y = 31.5;
            self.fruit.x = publicFruitOffset + 34.5;
        }
        break;
    case 7:
        self.fruit.width = self.fruit.height = 28;
        if (dataModel.vineType == 1) {
            self.fruit.y = 21;
            self.fruit.x = publicFruitOffset + 29;
        } else if (dataModel.vineType == 2) {
            self.fruit.y = 15;
            self.fruit.x = publicFruitOffset + 26;
        } else if (dataModel.vineType == 3) {
            self.fruit.y = 25;
            self.fruit.x = publicFruitOffset + 28;
        }
        break;
    }
    [self.fruit layoutIfNeeded];
    self.hotAreal.center = self.fruit.center;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.transform = CGAffineTransformMakeScale(1, -1);

    self.fruit = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.contentView addSubview:self.fruit];

    self.hotAreal = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.hotAreal.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.hotAreal];
    [self.hotAreal addUITapGestureRecognizerWithTarget:self withAction:@selector(getFruit)];
}

- (void)getFruit{
    if (self.dataModel.fruitType > 3 && self.dataModel.fruit.length > 0) {
        CGRect rect = [self.fruit convertRect:self.fruit.superview.frame toView:[self getViewController].view];
        [ZHBlockSingleCategroy runBlockThreeCGFloatIdentity:@"GetFruit" Float1:rect.origin.x Float2:rect.origin.y Float3:self.dataModel.fruitType];
        self.dataModel.fruit = @"";
        self.fruit.image = nil;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

@end

